import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/presentation/controllers/auth_controller.dart';
import '../data/repositories/queue_repository.dart';
import '../domain/models/person_details.dart';

// Provider for QueueService
final queueServiceProvider = Provider<QueueService>((ref) {
  final queueRepository = ref.watch(queueRepoProvider);
  return QueueService(queueRepository, ref);
});

class QueueService {
  QueueService(this._queueRepository, this._ref);
  final QueueRepository _queueRepository;
  final Ref _ref;

  Future<void> addPersonToQueue(PersonDetails personDetails) async {
    // Get the current admin's email who is adding this person
    final addedBy = _ref.read(authControllerProvider).adminEmail;

    // Update the personDetails with the admin's email
    await _queueRepository.insertQueue(personDetails.copyWith(
      addedBy: addedBy,
    ));
  }

  // Get all people in queue
  Future<List<PersonDetails>> getAllQueue() async {
    return await _queueRepository.getQueue();
  }

  // Remove person from queue
  Future<void> removePersonFromQueue(String id) async {
    await _queueRepository.removeFromQueue(id);
  }

  // Get specific person details
  Future<PersonDetails?> getPersonDetails(int id) async {
    return await _queueRepository.getPersonDetails(id);
  }

  // Update person details
  Future<void> updatePersonDetails(PersonDetails personDetails) async {
    await _queueRepository.updatePersonDetails(personDetails);
  }
}
