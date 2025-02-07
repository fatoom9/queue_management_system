import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/auth/data/auth_repository.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, bool>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthStateNotifier(authRepository);
});

class AuthStateNotifier extends StateNotifier<bool> {
  final AuthRepository _authRepository;

  AuthStateNotifier(this._authRepository) : super(false);

  Future<void> checkLoginStatus(String id) async {
    final status = await _authRepository.isLoggedIn(id);
    state = status == 1; // true if logged in, false if not
  }

  void logOut() {
    state = false;
  }
}
