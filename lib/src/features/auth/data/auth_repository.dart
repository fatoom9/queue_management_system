import 'package:queue_management_system/src/exceptions/app_exceptions.dart';
import 'package:queue_management_system/src/features/auth/domain/models/admin.dart';
import 'package:queue_management_system/src/core/database/database_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class AuthRepository {
  final DatabaseHelper _dbHelper;

  AuthRepository(this._dbHelper);

  Future<bool> _isEmailInUse(String email) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'admin',
      where: 'email = ?',
      whereArgs: [email],
    );
    return maps.isNotEmpty;
  }

  Future<void> insertAdmin(Admin admin) async {
    final db = await _dbHelper.database;
    await db.insert('admin', admin.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'admin',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isEmpty) {
      throw UserNotFoundException();
    }

    final admin = Admin.fromMap(maps.first);

    if (admin.password != password) {
      throw WrongPasswordException();
    }

    await updateLoginStatus(email, true);
  }

  Future<void> createAdminWithEmailAndPassword(
      String email, String password) async {
    if (await _isEmailInUse(email)) {
      throw EmailAlreadyInUseException();
    }

    if (password.length < 8) {
      throw WeakPasswordException();
    }

    final newAdmin =
        Admin(id: DateTime.now().toString(), email: email, password: password);
    await insertAdmin(newAdmin);
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
    return null;
  }

  Future<bool> validateCredentials(String email, String password) async {
    final admins = await getAdmins();
    final isValid = admins
        .any((admin) => admin.email == email && admin.password == password);
    return isValid;
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'admin',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    return maps.isNotEmpty;
  }

  Future<void> deleteAdmin(String id) async {
    final db = await _dbHelper.database;
    await db.delete('admin', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> isLoggedIn(String email) async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'admin',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      final admin = Admin.fromMap(maps.first);
      return admin.isLoggedIn ? 1 : 0;
      final admin = Admin.fromMap(
          maps.first); // Get the first match (should be unique by id)
      return admin.isLoggedIn ? 1 : 0; // Return 1 if logged in, otherwise 0
    } else {
      return 0;
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
