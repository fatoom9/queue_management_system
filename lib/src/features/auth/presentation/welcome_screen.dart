import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/common_widgets/button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:queue_management_system/src/constants/app_theme.dart';

class WelcomScreen extends HookConsumerWidget {
  const WelcomScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.theme.scaffoldBackgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF1F2ED),
              Color(0xFFF1F2ED),
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
                Image.asset(
                  'assets/logo/logo.png',
                  width: 180,
                  height: 180,
                ),
                const SizedBox(height: 30),
                Text(
                  'Queue Management System',
                  style: AppTheme.theme.textTheme.headlineSmall,
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
