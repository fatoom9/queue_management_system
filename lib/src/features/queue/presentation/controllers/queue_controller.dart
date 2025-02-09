import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/queue/application/queue_service.dart';
import 'package:queue_management_system/src/features/queue/data/repositories/queue_repository.dart';
import 'package:queue_management_system/src/features/queue/domain/models/person_details.dart';

final queueControllerProvider =
    StateNotifierProvider<QueueController, List<PersonDetails>>((ref) {
  final queueService = ref.read(queueServiceProvider);
  return QueueController(queueService);
});

class QueueController extends StateNotifier<List<PersonDetails>> {
  final QueueService _queueService;
  QueueController(this._queueService) : super([]) {
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
    await Future.delayed(const Duration(milliseconds: 1000));
    final nextQueueNumber = state.isEmpty ? 1 : state.length + 1;
    final person = PersonDetails(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      phoneNumber: phoneNumber,
      queueNumber: nextQueueNumber,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      notes: notes.isNotEmpty ? notes : null,
    );
    try {
      await _queueService.addPersonToQueue(person);
      state = [...state, person];
    } catch (e) {
      print(" Error adding person to queue: $e");
    }
  }

  Future<void> removePersonFromQueue(String id) async {
    try {
      await _queueService.removePersonFromQueue(id);

      state = state.where((person) => person.id != id).toList();
    } catch (e) {
      print("Error removing person from queue: $e");
    }
    await updateQueueNumber();
  }

  Future<void> updateQueueNumber() async {
    final currentQueueList = await _queueService.getAllQueue();
    // print("Updated Queue List: $currentQueueList");

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

      //  print('Update queue number: ${currentPerson.fullName}  ${i + 1}');
      await _queueService.updatePersonDetails(newPerson);
    }
  }
}
