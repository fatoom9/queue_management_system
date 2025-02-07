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
      version: 3, // Increment version to 3
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE admin( 
            id TEXT PRIMARY KEY, 
            email TEXT NOT NULL, 
            password TEXT NOT NULL, 
            is_logged_in BOOLEAN DEFAULT FALSE 
          ) 
        ''');

        await db.execute('''
          CREATE TABLE queue_entries( 
            id TEXT PRIMARY KEY, 
            full_name TEXT NOT NULL, 
            phone_number TEXT NOT NULL, 
            queue_number INTEGER NOT NULL, 
            timestamp INTEGER NOT NULL, 
            notes TEXT,
            added_by TEXT NOT NULL
          ) 
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Add the `is_logged_in` column if upgrading from version 1
          await db.execute('''
            ALTER TABLE admin ADD COLUMN is_logged_in BOOLEAN DEFAULT FALSE 
          ''');
        }
        if (oldVersion < 3) {
          // Add the `added_by` column if upgrading from version 2
          await db.execute('''
            ALTER TABLE queue_entries ADD COLUMN added_by TEXT NOT NULL DEFAULT 'unknown'
          ''');
        }
      },
    );
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }
}

final databaseProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});
