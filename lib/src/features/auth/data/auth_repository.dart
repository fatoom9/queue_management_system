import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:queue_management_system/src/features/auth/domain/models/admin.dart';

class AuthRepository {
  Database? _database;

  // Initialize the SQLite database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'queue_management.db'),
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE admin(
            id TEXT PRIMARY KEY,
            email TEXT NOT NULL,
            password TEXT NOT NULL
          )''',
        );
      },
      version: 1,
    );
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Add admin
  Future<void> insertAdmin(Admin admin) async {
    final db = await database;
    await db.insert(
      'admin',
      admin.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get the list of admins from the database
  Future<List<Admin>> getAdmins() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('admin');
    return maps.map((map) => Admin.fromMap(map)).toList();
  }

  // Validate admin credentials
  Future<bool> validateCredentials(String email, String password) async {
    final admins = await getAdmins();
    return admins
        .any((admin) => admin.email == email && admin.password == password);
  }

  // Delete admin by id
  Future<void> deleteAdmin(String id) async {
    final db = await database;
    await db.delete('admin', where: 'id = ?', whereArgs: [id]);
  }
}
