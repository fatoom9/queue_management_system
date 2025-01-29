import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:queue_management_system/src/features/auth/presentation/AdminSetupScreen.dart';
import 'package:queue_management_system/src/features/auth/presentation/Welcom_screen.dart';
import 'package:queue_management_system/src/features/auth/presentation/login_screen.dart';
import 'package:queue_management_system/src/features/auth/presentation/not_found_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/welcome', // Default screen to show
  routes: [
    GoRoute(
      path: '/welcome', // Path for the Welcome screen
      builder: (context, state) => const WelcomScreen(), // Welcome screen builder
    ),
    GoRoute(
      path: '/login', 
      builder: (context, state) => const LoginScreen(), // Login screen builder
    ),
    GoRoute(
      path: '/admin-setup', // Path for the Admin setup screen
      builder: (context, state) => const AdminSetupScreen(), // Admin setup screen builder
    ),
  
    GoRoute(
      path: '/404',
      builder: (context, state) => const NotFoundScreen(),
    ),
  ],
);
