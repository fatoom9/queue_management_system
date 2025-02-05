import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/core/database/database_helper.dart';
import 'package:queue_management_system/src/router/router.dart'; // Import go_router.dart to access the router

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();
  await dbHelper.database; // Ensure database is initialized
  
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    return MaterialApp.router(
      // Use MaterialApp.router instead of MaterialApp
      routerConfig: ref.watch(goRouterProvider), // Pass the router configuration to the routerConfig property
      debugShowCheckedModeBanner: false, // Optional, hides the debug banner
    );
  }
}
