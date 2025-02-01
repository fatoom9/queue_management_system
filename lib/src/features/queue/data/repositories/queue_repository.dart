import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/core/database/database_helper.dart';
import 'package:queue_management_system/src/features/queue/domain/models/person_details.dart';
import 'package:sqflite/sqflite.dart';

class QueueRepository {
  final DatabaseHelper _dbHelper;
  QueueRepository(this._dbHelper);
  Future<void> insertQueue(PersonDetails persondetails) async {
    final db = await _dbHelper.database;
    await db.insert('queue_entries', persondetails.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //view current queue
  Future<List<PersonDetails>> getQueue() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('queue_entries');
    return maps.map((map) => PersonDetails.fromMap(map)).toList();
  }
  //delete person from queue

  Future<void> removeFromQueue(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'queue_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // View person details by ID
  Future<PersonDetails?> getPersonDetails(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'queue_entries',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PersonDetails.fromMap(maps.first);
    }
    return null;
  }

  // Edit person details
  Future<void> updatePersonDetails(PersonDetails personDetails) async {
    final db = await _dbHelper.database;
    await db.update(
      'queue_entries',
      personDetails.toMap(),
      where: 'id = ?',
      whereArgs: [personDetails.id],
    );
  }
}

final queueRepositoryProvider = Provider<QueueRepository>((ref) {
  final dbHelper = ref.read(databaseProvider);
  return QueueRepository(dbHelper);
});
