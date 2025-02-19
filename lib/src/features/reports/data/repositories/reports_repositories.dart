import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/core/database/database_helper.dart';

class ReportsRepository {
  final DatabaseHelper _dbHelper;

  ReportsRepository(this._dbHelper);

  Future<List<Map<String, dynamic>>> fetchQueueData() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
  SELECT 
    DATE(timestamp / 1000, 'unixepoch') AS date,
    COUNT(*) AS totalItems, 
    SUM(CASE WHEN completedAt IS NOT NULL AND completedAt > 0 THEN 1 ELSE 0 END) AS completedItems, 
    AVG(CASE WHEN completedAt IS NOT NULL AND completedAt > 0 THEN ((completedAt - timestamp) / 1000) ELSE NULL END) AS avgWaitingTime
  FROM queue_entries
  GROUP BY date
  ORDER BY date DESC
''');

    /* for (var row in result) {
      print("Row: $row");
    }
    */

    return result;
  }

  Future<List<Map<String, dynamic>>> fetchQueueItems(String date) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
    SELECT 
      id, 
      full_name, 
      timestamp, 
      completedAt 
    FROM queue_entries
    WHERE DATE(timestamp / 1000, 'unixepoch') = ?
    ORDER BY timestamp DESC
  ''', [date]);
    /*for (var row in result) {
      print("Row: $row");
    }
    */

    return result;
  }
}

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepository(ref.read(databaseProvider));
});
