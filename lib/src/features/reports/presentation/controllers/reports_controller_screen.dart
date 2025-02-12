//import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/queue/data/repositories/queue_repository.dart';
import 'package:queue_management_system/src/features/queue/domain/models/person_details.dart';

final reportsControllerProvider =
    StateNotifierProvider<ReportsControllerScreen, ReportsState>((ref) {
  return ReportsControllerScreen(ref);
});

class ReportsControllerScreen extends StateNotifier<ReportsState> {
  final Ref ref;

  ReportsControllerScreen(this.ref) : super(ReportsState());

  Future<void> fetchQueueData() async {
    final queueRepository = ref.read(queueRepoProvider);

    final queueData = await queueRepository.getQueue();

    state = ReportsState(queueData);
    //print('gggggggggggggggggggggggggggggg');
    //print(queueData);
  }
}

class ReportsState {
  final List<PersonDetails> queueData;

  ReportsState([this.queueData = const []]);
}
