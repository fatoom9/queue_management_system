import 'package:sqflite/sqflite.dart';
import  'package:queue_management_system/src/features/auth/domain/models/admin.dart';
import 'package:path/path.dart';

//to access database
class AdminRepository {
  static final AdminRepository instance = AdminRepository._();
  static Database? _database;

  AdminRepository._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    var path = join(await getDatabasesPath(), 'queue_management_database.db');
    return openDatabase(path, onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE admin (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        password TEXT NOT NULL
      )
      ''');
    }, version: 1);
  }

  Future<void> addAdmin(Admin admin) async {
    final db = await database;
    await db.insert('admin', admin.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

   Future<Admin?> getAdmin(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('admin', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Admin.fromMap(maps.first);
    }
    return null; 
  }

  Future<void> deleteAdmin(String id) async {
    final db = await database;
    await db.delete('admin', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateAdmin(Admin admin) async {
    final db = await database;
    await db.update(
      'admin',
      admin.toMap(),
      where: 'id = ?',
      whereArgs: [admin.id],
    );
  }

  Future<bool> doesAdminExist() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('admin');
    return maps.isNotEmpty;
  }
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}


