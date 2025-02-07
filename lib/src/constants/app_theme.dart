import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      // Primary color for your app (blue shade)
      primaryColor: const Color(0xFF335A7B),
      // Background color for the entire app (light cream)
      scaffoldBackgroundColor: const Color(0xFFF1F2ED),

      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF335A7B),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),

      // Button styles
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF335A7B), // Text color on the button
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 6,
        ),
      ),

      // TextButton styles
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF335A7B), // Text color
        ),
      ),

      // Background gradient for screens
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        },
      ),

      // Define text styles
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF335A7B)),
        bodyMedium: TextStyle(color: Color(0xFF335A7B)),
      ),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFBB594E)),
    );
  }
}
