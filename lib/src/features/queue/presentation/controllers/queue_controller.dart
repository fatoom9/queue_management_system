import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/queue/application/queue_service.dart';
import 'package:queue_management_system/src/features/queue/domain/models/person_details.dart';

final queueControllerProvider =
    StateNotifierProvider<QueueController, List<PersonDetails>>((ref) {
  final queueService = ref.read(queueServiceProvider);
  return QueueController(queueService, ref);
});

class QueueController extends StateNotifier<List<PersonDetails>> {
  final QueueService _queueService;
  final Ref ref;

  QueueController(this._queueService, this.ref) : super([]) {
    _loadQueue();
  }

  Future<void> _loadQueue() async {
    try {
      final queue = await _queueService.getAllQueue();
      state = queue;
    } catch (e) {
      print("Error loading queue: $e");
    }
  }

  Future<void> addPersonToQueue(
      String id, String fullName, String phoneNumber, String notes) async {
    try {
      final currentQueue = await _queueService.getAllQueue();
      final int newQueueNumber = currentQueue.length + 1;

      final personDetails = PersonDetails(
        id: id,
        fullName: fullName,
        phoneNumber: phoneNumber,
        queueNumber: newQueueNumber,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        completedAt: 0,
        notes: notes.isNotEmpty ? notes : null,
      );

      await _queueService.addPersonToQueue(personDetails);
      await updateQueueNumber();

      final updatedQueue = await _queueService.getAllQueue();
      state = updatedQueue;
    } catch (e) {
      print("Error adding person to queue: $e");
    }
  }

  Future<void> removePersonFromQueue(String id) async {
    try {
      await _queueService.removePersonFromQueue(id);
      await updateQueueNumber();
      final updateQueue = await _queueService.getAllQueue();
      state = updateQueue;
    } catch (e) {
      print("Error removing person from queue: $e");
    }
  }

  Future<void> removeFromCompletedList(String id) async {
    state = state.where((person) => person.id != id).toList();
  }

  Future<void> markAsCompleted(String id) async {
    try {
      await _queueService.markAsCompleted(id);
      await updateQueueNumber();

      final updatedQueueList = state.map((person) {
        if (person.id == id) {
          return person.copyWith(
              completedAt: DateTime.now().millisecondsSinceEpoch,
              queueNumber: 0);
        }
        return person;
      }).toList();
      await updateQueueNumber();

      final updateQueue = await _queueService.getAllQueue();

      state = updateQueue;

      // print("Updated queue list: $updateQueue");
    } catch (e) {
      print("Error marking person as completed: $e");
    }
  }

  Future<void> updateQueueNumber() async {
    final currentQueueList = await _queueService.getAllQueue();
    List<PersonDetails> activeQueue = currentQueueList
        .where(
            (person) => person.completedAt == null || person.completedAt == 0)
        .toList();

    for (int i = 0; i < activeQueue.length; i++) {
      final currentPerson = activeQueue[i];

      final updatedPerson = PersonDetails(
        id: currentPerson.id,
        fullName: currentPerson.fullName,
        phoneNumber: currentPerson.phoneNumber,
        queueNumber: i + 1,
        timestamp: currentPerson.timestamp,
        notes: currentPerson.notes,
        addedBy: currentPerson.addedBy,
        completedAt: currentPerson.completedAt, // Preserve completion status
      );

      await _queueService.updatePersonDetails(updatedPerson);
    }
  }
}
