import 'package:flutter/material.dart';

class AppTheme {
  static const Color darkBg = Color(0xFF1A1A2E);
  static const Color darkSurface = Color(0xFF16213E);
  static const Color darkPrimary = Colors.cyanAccent;

  static const Color lightBg = Color(0xFFF5F7FB);
  static const Color lightSurface = Colors.white;
  static const Color lightPrimary = Color(0xFF00ADB5);

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: darkBg,
    primaryColor: darkPrimary,
    colorScheme: const ColorScheme.dark(
      primary: darkPrimary,
      surface: darkSurface,
      onSurface: Colors.white,
    ),
    useMaterial3: true,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: lightBg,
    primaryColor: lightPrimary,
    colorScheme: const ColorScheme.light(
      primary: lightPrimary,
      surface: lightSurface,
      onSurface: darkBg,
    ),
    useMaterial3: true,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
    ),
  );
}
