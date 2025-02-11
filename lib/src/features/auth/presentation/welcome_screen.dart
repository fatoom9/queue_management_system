import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/common_widgets/button.dart';
import 'package:queue_management_system/src/features/auth/application/auth_service.dart';

class WelcomScreen extends HookConsumerWidget {
  const WelcomScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB3E5FC),
              Color(0xFFE1F5FE)
            ], // Soft blue gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // App Logo
                Image.asset(
                  'assets/logo/logo.png',
                  width: 180,
                  height: 180,
                ),
                const SizedBox(height: 30),

                // App Title with style
                const Text(
                  'Queue Management System',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF01579B),
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                Btn(
                  onPress: () => context.go('/login'),
                  text: 'Login',
                ),
                const SizedBox(height: 20),
                Btn(
                  onPress: () => context.go('/admin-setup'),
                  text: 'Create Admin',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
