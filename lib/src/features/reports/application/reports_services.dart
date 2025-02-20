import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/reports/data/repositories/reports_repositories.dart';
import 'package:queue_management_system/src/features/reports/domain/queue_item_model.dart';
import 'package:queue_management_system/src/features/reports/domain/report_models.dart';

class ReportsService {
  final ReportsRepository _repository;
  ReportsService(this._repository);

  Future<List<ReportModel>> getReports() async {
    final rawData = await _repository.fetchQueueData();
    return rawData.map((data) => ReportModel.fromMap(data)).toList();
  }

  Future<List<QueueItemModel>> getItemsDetails(String date) async {
    final rawData = await _repository.fetchQueueItems(date); //
    return rawData.map((data) => QueueItemModel.fromMap(data)).toList();
  }
}

final reportsServiceProvider = Provider<ReportsService>((ref) {
  return ReportsService(ref.read(reportsRepositoryProvider));
});

final reportServicesFutureProvider =
    FutureProvider.autoDispose<List<ReportModel>>((ref) async {
  final reportsService = ref.read(reportsServiceProvider);
  return await reportsService.getReports();
});

final itemsDetailsFutureProvider = FutureProvider.family
    .autoDispose<List<QueueItemModel>, String>((ref, date) async {
  final reportsService = ref.read(reportsServiceProvider);
  return await reportsService.getItemsDetails(date);
});
