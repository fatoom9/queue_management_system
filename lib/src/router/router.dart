import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:queue_management_system/src/features/auth/presentation/AdminSetupScreen.dart';
import 'package:queue_management_system/src/features/auth/presentation/Welcom_screen.dart';
import 'package:queue_management_system/src/features/auth/presentation/login_screen.dart';
import 'package:queue_management_system/src/features/auth/presentation/not_found_screen.dart';
import 'package:queue_management_system/src/features/queue/presentation/home.dart';

enum AppRoute{
  welcome,
  login,
  adminSetup,
  home,
  notFound,
}
final GoRouter router = GoRouter(
  initialLocation: '/Welcome',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(path:'/Welcome',
    name: AppRoute.welcome.name,
      builder: (context, state) => const WelcomScreen(),
    ),
    GoRoute(path: '/login',
    name:AppRoute.login.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
  path: '/admin-setup',
  name: AppRoute.adminSetup.name, 
  builder: (context, state) => const AdminSetupScreen(),
),
    
    
   ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);






