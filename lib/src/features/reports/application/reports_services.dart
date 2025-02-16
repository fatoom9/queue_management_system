import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/reports/data/repositories/reports_repositories.dart';
import 'package:queue_management_system/src/features/reports/domain/report_models.dart';

class ReportsService {
  final ReportsRepository _repository;

  ReportsService(this._repository);

  Future<List<ReportModel>> getReports() async {
    final rawData = await _repository.fetchQueueData();
    return rawData.map((data) => ReportModel.fromMap(data)).toList();
  }
}

final reportsServiceProvider = Provider<ReportsService>((ref) {
  return ReportsService(ref.read(reportsRepositoryProvider));
});
