import 'package:flutter/material.dart';

class AppTheme {
  //That Shy Life App Brand Colors
  static const Color primary = Color(0xFF546E7A); //blue grey
  static const Color background = Color(0xFFF5F5F0); // warm off-white
  static const Color surface = Colors.white;
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMuted = Color(0xFF757575);
  static const Color border = Color(0xFFE0E0E0);

  static ThemeData get theme =>
      ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: primary,
            brightness: Brightness.light,
        ),

        scaffoldBackgroundColor: background,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: textDark,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: textDark,
          ),
        ),

        cardTheme: CardThemeData(
          color: surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: border),
          ),
        ),
      );
}
