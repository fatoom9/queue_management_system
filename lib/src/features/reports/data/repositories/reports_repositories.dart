import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/core/database/database_helper.dart';

class ReportsRepository {
  final DatabaseHelper _dbHelper;

  ReportsRepository(this._dbHelper);

  Future<List<Map<String, dynamic>>> fetchQueueData() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT 
        DATE(timestamp, 'unixepoch') AS date, 
        COUNT(*) AS totalItems, 
        SUM(CASE WHEN completedAt IS NOT NULL THEN 1 ELSE 0 END) AS completedItems, 
        AVG(CASE WHEN completedAt IS NOT NULL THEN (completedAt - timestamp) ELSE NULL END) AS avgWaitingTime
      FROM queue_entries
      GROUP BY date
      ORDER BY date DESC
    ''');
    return result;
  }
}

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepository(ref.read(databaseProvider));
});
