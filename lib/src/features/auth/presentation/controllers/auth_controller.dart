import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/auth/application/auth_service.dart';
import 'package:queue_management_system/src/features/auth/domain/models/admin.dart';
import 'package:queue_management_system/src/features/auth/domain/models/auth_state.dart';

// This provider manages the authentication state throughout the app
// It uses StateNotifierProvider to handle the AuthState object
// AuthState tracks:
// - isAuthenticated: whether a user is currently logged in
// - adminEmail: the email of the currently logged in admin
//
// The auth state is used by the router to:
// - Redirect unauthenticated users to login
// - Prevent authenticated users from accessing login/welcome screens
// - Allow/deny access to protected routes
final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthController(authService);
});

class AuthController extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthController(this._authService) : super(AuthState());

  Future<bool> signIn(String email, String password) async {
    final isValid = await _authService.validateCredentials(email, password);
    if (isValid) {
      await _authService.updateLoginStatus(email, true);
      // After successful validation of credentials, update the AuthState
      // Set isAuthenticated to true since the user is now logged in
      // Store the admin's email to track who is currently authenticated
      state = AuthState(
        isAuthenticated: true,
        adminEmail: email,
      );
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    if (state.adminEmail != null) {
      // If there is an admin email, update the login status to false
      await _authService.updateLoginStatus(state.adminEmail!, false);
    }
    // After signing out, reset the AuthState to its initial state
    state = AuthState();
  }

  Future<void> createAdmin(String email, String password) async {
    await Future.delayed(const Duration(
        milliseconds: 1000)); // Add a small delay to simulate a network call
    final admin = Admin(
      id: DateTime.now().toString(),
      email: email,
      password: password,
    );
    await _authService.createAdmin(admin);
  }

  Future<void> deleteAdmin(String id) async {
    await _authService.deleteAdmin(id);
  }

  Future<void> checkAuthStatus() async {
    final adminEmail = await _authService.getLoggedInAdmin();
    if (adminEmail != null) {
      state = AuthState(
        isAuthenticated: true,
        adminEmail: adminEmail,
      );
    } else {
      state = AuthState();
    }
  }
}
