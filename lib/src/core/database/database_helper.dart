import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'queue_management.db'),
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE admin(
            id TEXT PRIMARY KEY,
            email TEXT NOT NULL,
            password TEXT NOT NULL
          )
        ''');
        print("Admin table created");

        await db.execute('''
          CREATE TABLE queue_entries (
            id TEXT PRIMARY KEY,
            full_name TEXT NOT NULL,
            phone_number TEXT NOT NULL,
            queue_number INTEGER NOT NULL,
            timestamp INTEGER NOT NULL,
            notes TEXT
          )
        ''');
        print("Queue entries table created");
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE queue_entries (
              id TEXT PRIMARY KEY,
              full_name TEXT NOT NULL,
              phone_number TEXT NOT NULL,
              queue_number INTEGER NOT NULL,
              timestamp INTEGER NOT NULL,
              notes TEXT
            )
          ''');
          print("Queue entries table added in upgrade");
        }
      },
    );
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }
}

/// Riverpod Provider for DatabaseHelper
final databaseProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});
