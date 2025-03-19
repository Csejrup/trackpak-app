import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color orange = Color(0xFFE68A25);
  static const Color yellow = Color(0xFFF1C931);
  static const Color red = Color(0xFFD63931);
  static const Color green = Color(0xFF36BB7A);
  static const Color lightGrey = Color(0xFFE7E9EA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color cyan = Color(0xFF1AC9B9);
  static const Color teal = Color(0xFF13B7AF);
  static const Color darkBlue = Color(0xFF1A2135);

  final ThemeData theme = ThemeData(
    primaryColor: darkBlue,
    scaffoldBackgroundColor: white,
    fontFamily: GoogleFonts.openSans().fontFamily,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: darkBlue,
      secondary: cyan,
      error: red,
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: darkBlue,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: darkBlue,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: darkBlue,
      ),
      bodyLarge: TextStyle(fontSize: 18, color: darkBlue),
      bodyMedium: TextStyle(fontSize: 16, color: darkBlue),
      bodySmall: TextStyle(fontSize: 14, color: darkBlue),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkBlue,
        foregroundColor: white,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
  );
}
