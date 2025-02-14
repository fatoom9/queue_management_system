import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/core/database/database_helper.dart';

class ReportsRepositories {
  final DatabaseHelper _dbHelper;
  ReportsRepositories(this._dbHelper);

//get number of all queue entries
  Future<List<Map<String, dynamic>>> getQueueEntries() async {
    final db = await _dbHelper.database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('queue_entries');
      print('REPORTS');
      print("Fetched ${maps.length} entries from queue_entries table");
      return maps;
    } catch (e) {
      print("Error fetching queue: $e");
      return [];
    }
  }
}

final reportsRepoProvider = Provider<ReportsRepositories>((ref) {
  final dbHelper = ref.read(databaseProvider);
  return ReportsRepositories(dbHelper);
});
