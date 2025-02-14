import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/reports/data/repositories/reports_repositories.dart';

final reportsServicesProvider = Provider<ReportsServices>((ref) {
  final reportsRepository = ref.read(reportsRepoProvider);
  return ReportsServices(reportsRepository);
});

class ReportsServices {
  ReportsServices(this._reportRepository);
  final ReportsRepositories _reportRepository;

  // Get all people in database
  Future<List<Map<String, dynamic>>> getAllPersons() async {
    return await _reportRepository.getQueueEntries();
  }
}
