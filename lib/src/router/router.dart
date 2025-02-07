import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/features/auth/presentation/admin_list_screen.dart';
import 'package:queue_management_system/src/features/auth/presentation/admin_setup_screen.dart.dart';
import 'package:queue_management_system/src/features/auth/presentation/not_found_screen.dart';
import 'package:queue_management_system/src/features/auth/presentation/welcome_screen.dart';
import 'package:queue_management_system/src/features/auth/presentation/login_screen.dart';
import 'package:queue_management_system/src/features/queue/presentation/home_screen.dart';
import 'package:queue_management_system/src/features/auth/presentation/controllers/auth_controller.dart';

enum AppRoute {
  welcome,
  login,
  adminSetup,
  home,
  notFound,
  adminList,
}

<<<<<<< HEAD
final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/welcome',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      // TODO: Remove this - it's for illustrating the auth state check firing on each navigation event + auth state change
      print('Auth State: ${authState.isAuthenticated}');
      print('User email: ${authState.adminEmail}');

      // Public routes that don't require authentication
      final publicRoutes = ['/welcome', '/login', '/admin-setup', '/admin-list'];
      final currentLocation = state.uri.toString();

      // If on a public route and not authenticated, allow access
      if (publicRoutes.contains(currentLocation) && !authState.isAuthenticated) {
        return null;
      }

      // If authenticated, automatically redirect to home if trying to access login/welcome
      if (authState.isAuthenticated && (currentLocation == '/login' || currentLocation == '/welcome')) {
        return '/home';
      }

      // If not authenticated and trying to access protected route, redirect to login
      if (!authState.isAuthenticated && !publicRoutes.contains(currentLocation)) {
        return '/login';
      }

      // Allow the navigation to proceed otherwise
      return null;
    },
    // refreshListenable: GoRouterRefreshStream(ref.read(authStateProvider.stream)),
=======
final isLoggedInProvider = StateProvider<bool>((ref) => false);

final goRouterProvider = Provider<GoRouter>((ref) {
  ref.watch(isLoggedInProvider);
  return GoRouter(
    initialLocation: '/welcome',
    // refreshListenable: GoRouterRefreshStream(ref.read(authStateProvider.stream)),
    redirect: (context, state) {
      final isLoggedIn = ref.read(isLoggedInProvider);
      if (isLoggedIn) {
        return '/home';
      }
      return null;
    },
    debugLogDiagnostics: false,
>>>>>>> f1c3e69bb1b2b2f04952dd658d679c6ffeaaba94
    routes: [
      GoRoute(
        path: '/welcome',
        name: AppRoute.welcome.name,
        builder: (context, state) => const WelcomScreen(),
      ),
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/admin-setup',
        name: AppRoute.adminSetup.name,
<<<<<<< HEAD
        builder: (context, state) => const AdminSetupScreen(),
      ),
      GoRoute(
        path: '/admin-list',
        name: AppRoute.adminList.name,
=======
        builder: (context, state) => AdminSetupScreen(
          onSetupComplete: () {
            // Navigate to the welcome screen after admin setup is complete
            context.goNamed(AppRoute.welcome.name);
          },
        ),
      ),
      GoRoute(
        path: '/admin-list',
        name: AppRoute.adminListScreen.name,
>>>>>>> f1c3e69bb1b2b2f04952dd658d679c6ffeaaba94
        builder: (context, state) => const AdminListScreen(),
      ),
      GoRoute(
        path: '/home',
        name: AppRoute.home.name,
<<<<<<< HEAD
        builder: (context, state) => const HomeScreen(),
=======
        builder: (context, state) => HomeScreen(),
>>>>>>> f1c3e69bb1b2b2f04952dd658d679c6ffeaaba94
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: const NotFoundScreen(),
    ),
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
