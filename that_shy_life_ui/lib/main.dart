import 'package:flutter/material.dart';
import 'ThatShyLifeApp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'NotificationService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.init();
  runApp(const ThatShyLifeApp());
}



