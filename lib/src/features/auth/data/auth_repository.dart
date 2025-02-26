import 'package:queue_management_system/src/features/auth/domain/models/admin.dart';
import 'package:queue_management_system/src/core/database/database_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class AuthRepository {
  final DatabaseHelper _dbHelper;

  AuthRepository(this._dbHelper);

  Future<void> insertAdmin(Admin admin) async {
    final db = await _dbHelper.database;
    await db.insert('admin', admin.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Admin>> getAdmins() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('admin');
    return maps.map((map) => Admin.fromMap(map)).toList();
  }

  Future<void> updateLoginStatus(String email, bool isLoggedIn) async {
    final db = await _dbHelper.database;
    await db.update(
      'admin',
      {'is_logged_in': isLoggedIn ? 1 : 0},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<String?> getLoggedInAdminEmail() async {
    final db = await _dbHelper.database;

    List<Map<String, dynamic>> result = await db.query(
      'admin',
      columns: ['email'],
      where: 'is_logged_in = ?',
      whereArgs: [1],
    );

    if (result.isNotEmpty) {
      return result.first['email'] as String;
    }
    return null; // No admin is logged in
  }

  Future<bool> validateCredentials(String email, String password) async {
    final admins = await getAdmins();
    final isValid = admins
        .any((admin) => admin.email == email && admin.password == password);
    return isValid;
  }

  Future<void> deleteAdmin(String id) async {
    final db = await _dbHelper.database;
    await db.delete('admin', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> isLoggedIn(String id) async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'admin',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final admin = Admin.fromMap(
          maps.first); // Get the first match (should be unique by id)
      return admin.isLoggedIn ? 1 : 0; // Return 1 if logged in, otherwise 0
    } else {
      return 0; // Return 0 if the admin with the given id is not found
    }
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
