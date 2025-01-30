import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:queue_management_system/src/features/auth/domain/models/admin.dart';

class AuthRepository {
  late Database _database;

  // Initialize the SQLite database
  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    _database = await openDatabase(
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
    print("Database initialized.");
  }

  // add admin
  Future<void> insertAdmin(Admin admin) async {
    await _database.insert(
      'admin',
      admin.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Admin inserted: ${admin.email}");

    // Fetch and print all admins to verify
    final admins = await getAdmins();
    print("Admins in DB after insert: $admins");
  }

  // Get the list of admins from the database
  Future<List<Admin>> getAdmins() async {
    final List<Map<String, dynamic>> maps = await _database.query('admin');
    print("Fetched admins from DB: $maps");
    return List.generate(maps.length, (i) {
      return Admin(
        id: maps[i]['id'],
        email: maps[i]['email'],
        password: maps[i]['password'],
      );
    });
  }

  // Validate admin credentials
  Future<bool> validateCredentials(String email, String password) async {
    final admins = await getAdmins();
    for (var admin in admins) {
      if (admin.email == email && admin.password == password) {
        return true;
      }
    }
    return false;
  }

  // Delete admin by id
   Future<void> deleteAdmin(String id) async {
    await _database.delete(
      'admin',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
final authRepoProvider = Provider<AuthRepository>((ref){
  final auth = AuthRepository();
  ref.onDispose(() {

  });
  auth.init();
  return auth;



});

// FutureProvider to fetch the list of admins
final adminsProvider = FutureProvider<List<Admin>>((ref) async {
  final authRepository = ref.watch(authRepoProvider);
  return authRepository.getAdmins();
});
// FutureProvider for validating admin credentials
final validateCredentialsProvider = FutureProvider.family<bool, Map<String, String>>((ref, credentials) async {
  final authRepository = ref.watch(authRepoProvider);
  return authRepository.validateCredentials(credentials['email']!, credentials['password']!);
});
