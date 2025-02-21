import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/common_widgets/custom_form.dart';

import 'package:queue_management_system/src/core/database/database_helper.dart';
import 'package:queue_management_system/src/router/router.dart';
import 'package:queue_management_system/src/features/auth/presentation/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();
  await dbHelper.database;

  // Create a ProviderContainer to access providers before runApp
  // This is just a way to pre-populate the providers before runApp
  final container = ProviderContainer();
  // Check auth status on startup - this will set the auth state based on the database
  await container.read(authControllerProvider.notifier).checkAuthStatus();

  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(goRouterProvider),
      debugShowCheckedModeBanner: false,
    );
  }
}
