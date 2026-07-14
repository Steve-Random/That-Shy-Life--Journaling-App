import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  static final ValueNotifier<ThemeMode> themeMode =
    ValueNotifier(ThemeMode.light);

  static bool get _isDark => themeMode.value == ThemeMode.dark;

  //Light palette (That Shy Life App Original Brand Colors)
  static const Color _primaryLight = Color(0xFF546E7A); //blue grey
  static const Color _backgroundLight = Color(0xFFF5F5F0); // warm off-white
  static const Color _surfaceLight = Colors.white;
  static const Color _textDarkLight = Color(0xFF1A1A1A);
  static const Color _textMutedLight = Color(0xFF757575);
  static const Color _borderLight = Color(0xFFE0E0E0);

  //Dark palette
  static const Color _primaryDark = Color(0xFF80CBC4);
  static const Color _backgroundDark = Color(0xFF12191C);
  static const Color _surfaceDark = Color(0xFF1B2428);
  static const Color _textDarkDark = Color(0xFFECEDEE);
  static const Color _textMutedDark = Color(0xFF9AA5A9);
  static const Color _borderDark = Color(0xFF2A353A);

  //Public getters
  static Color get primary => _isDark ? _primaryDark : _primaryLight;
  static Color get background => _isDark ? _backgroundDark : _backgroundLight;
  static Color get surface => _isDark ? _surfaceDark : _surfaceLight;
  static Color get textDark => _isDark ? _textDarkDark : _textDarkLight;
  static Color get textMuted => _isDark ? _textMutedDark : _textMutedLight;
  static Color get border => _isDark ? _borderDark : _borderLight;

  static ThemeData get lightTheme => _buildTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness){
    final isDark = (brightness == Brightness.dark);
    final primary = isDark ? _primaryDark : _primaryLight;
    final background = isDark ? _backgroundDark : _backgroundLight;
    final surface = isDark ? _surfaceDark : _surfaceLight;
    final textDark = isDark ? _textDarkDark : _textDarkLight;
    final textMuted = isDark ? _textMutedDark : _textMutedLight;
    final border = isDark ? _borderDark : _borderLight;

     return ThemeData(
        useMaterial3: true,
        brightness: brightness,
        colorScheme: ColorScheme.fromSeed(
            seedColor: primary,
            brightness: brightness,
        ),

        scaffoldBackgroundColor: background,

        appBarTheme: AppBarTheme(
          backgroundColor: isDark ? surface : Colors.white,
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

//helper method
static Future<void> setDarkMode(bool isDark) async{
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', isDark);
}
}
