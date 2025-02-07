import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/auth/data/auth_repository.dart';
import 'package:queue_management_system/src/features/auth/domain/models/admin.dart';

class AuthService {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthService(this._authRepository, this._ref);

  Future<bool> validateCredentials(String email, String password) async {
    return _authRepository.validateCredentials(email, password);
  }

  Future<void> updateLoginStatus(String email, bool isLoggedIn) async {
    await _authRepository.updateLoginStatus(email, isLoggedIn);
  }

  Future<void> createAdmin(Admin admin) async {
    await _authRepository.insertAdmin(admin);
  }

  Future<String?> getLoggedInAdmin() async {
    return _authRepository.getLoggedInAdminEmail();
  }

  Future<List<Admin>> getAllAdmins() async {
    return _authRepository.getAdmins();
  }

  Future<void> deleteAdmin(String id) async {
    await _authRepository.deleteAdmin(id);
  }
}

// Provider for AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthService(authRepository, ref);
});
