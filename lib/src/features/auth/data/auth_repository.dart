import 'package:queue_management_system/src/features/auth/domain/models/admin.dart';
import 'package:queue_management_system/src/core/database/database_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class AuthRepository {
  final DatabaseHelper _dbHelper;

  AuthRepository(this._dbHelper);

  Future<void> insertAdmin(Admin admin) async {
    final db = await _dbHelper.database;
    await db.insert('admin', admin.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Admin>> getAdmins() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('admin');
    return maps.map((map) => Admin.fromMap(map)).toList();
  }

  Future<bool> validateCredentials(String email, String password) async {
    final admins = await getAdmins();
    return admins.any((admin) => admin.email == email && admin.password == password);
  }

  Future<void> deleteAdmin(String id) async {
    final db = await _dbHelper.database;
    await db.delete('admin', where: 'id = ?', whereArgs: [id]);
  }
}

/// Riverpod Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dbHelper = ref.read(databaseProvider);
  return AuthRepository(dbHelper);
});

final adminListProvider = FutureProvider.autoDispose<List<Admin>>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.getAdmins();
});
