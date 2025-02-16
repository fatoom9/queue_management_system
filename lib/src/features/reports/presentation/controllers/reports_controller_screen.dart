import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/reports/application/reports_services.dart';
import 'package:queue_management_system/src/features/reports/domain/report_models.dart';

final reportsControllerProvider =
    StateNotifierProvider<ReportController, List<ReportModel>>((ref) {
  final queueService = ref.read(reportsServiceProvider);
  return ReportController(queueService);
});

class ReportController extends StateNotifier<List<ReportModel>> {
  final ReportsService _reportService;

  ReportController(this._reportService) : super([]) {
    fetchReports();
  }

  Future<void> fetchReports() async {
    try {
      final reports = await _reportService.getReports();
      state = reports;
    } catch (e) {
      print('Error fetching reports: $e');
      state = [];
    }
  }
}
