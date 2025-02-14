import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/reports/domain/report_models.dart';
import 'package:queue_management_system/src/features/reports/data/repositories/reports_repositories.dart';
import 'package:queue_management_system/src/features/reports/application/reports_services.dart';

final reportsControllerProvider =
    StateNotifierProvider<ReportsController, ReportsState>(
        (ref) => ReportsController(ref));

class ReportsController extends StateNotifier<ReportsState> {
  final Ref ref;

  ReportsController(this.ref) : super(ReportsState(isEmpty: true)) {
    fetchQueueData(); // Fetch data on init
  }

  Future<void> fetchQueueData() async {
    try {
      state = ReportsState(isLoading: true, isEmpty: false);

      // Fetch data from ReportsServices (not itself)
      final queueData = await ref.read(reportsServicesProvider).getAllPersons();

      int totalItems = queueData.length;
      int completedItems =
          queueData.where((p) => p['completedAt'] != null).length;
      double avgWaitingTime = queueData.isNotEmpty
          ? queueData
                  .map((p) => (p['timestamp'] ?? 0))
                  .fold<int>(0, (a, b) => a + b as int) /
              totalItems
          : 0.0;

      final report = ReportModel(
        totalQueueItems: totalItems,
        completedQueueItems: completedItems,
        averageWaitingTime: avgWaitingTime,
      );

      state = ReportsState(
          queueData: queueData, report: report, isEmpty: queueData.isEmpty);
    } catch (e) {
      state =
          ReportsState(error: "Failed to fetch queue data: $e", isEmpty: true);
    }
  }
}

class ReportsState {
  final List<dynamic> queueData;
  final ReportModel? report;
  final bool isLoading;
  final bool isEmpty;
  final String? error;

  ReportsState({
    this.queueData = const [],
    this.report,
    this.isLoading = false,
    this.isEmpty = false,
    this.error,
  });
}
