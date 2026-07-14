import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ThatShyLifeApp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'NotificationService.dart';
import 'app_theme.dart';

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



