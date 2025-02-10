import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:queue_management_system/src/features/queue/application/queue_service.dart';
import 'package:queue_management_system/src/features/queue/domain/models/person_details.dart';

final queueControllerProvider =
    StateNotifierProvider<QueueController, List<PersonDetails>>((ref) {
  final queueService = ref.read(queueServiceProvider);
  return QueueController(queueService, ref);
});

class QueueController extends StateNotifier<List<PersonDetails>> {
  final QueueService _queueService;
  final Ref ref; // إضافة الـ Ref هنا

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
      String fullName, String phoneNumber, String notes) async {
    try {
      final currentQueue = await _queueService.getAllQueue();
      final int newQueueNumber = currentQueue.length + 1;

      final personDetails = PersonDetails(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: fullName,
        phoneNumber: phoneNumber,
        queueNumber: newQueueNumber,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        notes: notes.isNotEmpty ? notes : null,
      );

      await _queueService.addPersonToQueue(personDetails);

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
      final updateQueu = await _queueService.getAllQueue();
      state = updateQueu;
    } catch (e) {
      print("Error removing person from queue: $e");
    }
  }

  Future<void> updateQueueNumber() async {
    final currentQueueList = await _queueService.getAllQueue();

    for (int i = 0; i < currentQueueList.length; i++) {
      final currentPerson = currentQueueList[i];

      final newPerson = PersonDetails(
        id: currentPerson.id,
        fullName: currentPerson.fullName,
        phoneNumber: currentPerson.phoneNumber,
        queueNumber: i + 1,
        timestamp: currentPerson.timestamp,
        notes: currentPerson.notes,
        addedBy: currentPerson.addedBy,
      );

      await _queueService.updatePersonDetails(newPerson);
    }
  }
}
