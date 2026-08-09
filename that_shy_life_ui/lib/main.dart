import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ThatShyLifeApp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'NotificationService.dart';
import 'app_theme.dart';

/// App entry point. Initialization order matters here:
/// Firebase and notifications must be before [runApp], and the
/// saved theme prefernces is read synchronously into [AppTheme.themeMode]
/// *before* runApp so the first frame renders in the correct theme
/// (avoids a light/dark flash on launch).
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.init();

  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('dark_mode') ?? false;
  AppTheme.themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;

  runApp(const ThatShyLifeApp());
}



