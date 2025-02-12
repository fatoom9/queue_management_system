import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: const Color(0xFF335A7B),
      scaffoldBackgroundColor: const Color(0xFFF1F2ED),

      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF335A7B),
        titleTextStyle: TextStyle(
            color: Color(0xFFf1f2ed),
            fontSize: 22,
            fontWeight: FontWeight.bold),
      ),

      // Button styles
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Color(0xFFF1F2ED),
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

      // Define text styles with Google Fonts integration
      textTheme: TextTheme(
        headlineSmall: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF335A7B)),
        bodyMedium: GoogleFonts.poppins(
            fontSize: 16,
            color: const Color(0xFF335A7B),
            fontWeight: FontWeight.normal),
      ),

      // Set secondary color for alerts and notifications
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFAD534A)),
    );
  }
}
