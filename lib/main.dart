import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/router/router.dart'; // Import go_router.dart to access the router

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router( // Use MaterialApp.router instead of MaterialApp
      routerConfig: router, // Pass the router configuration to the routerConfig property
      debugShowCheckedModeBanner: false, // Optional, hides the debug banner
    );
  }
}
