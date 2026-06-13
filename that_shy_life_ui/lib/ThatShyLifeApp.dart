import 'package:flutter/material.dart';
import 'JournalFeedScreen.dart';
import 'app_theme.dart';

class ThatShyLifeApp extends StatelessWidget {
  const ThatShyLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'That Shy Life',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const JournalFeedScreen(),
    );
  }
}