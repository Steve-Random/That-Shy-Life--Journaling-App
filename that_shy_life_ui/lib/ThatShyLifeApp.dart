import 'package:flutter/material.dart';
import 'JournalFeedScreen.dart';

class ThatShyLifeApp extends StatelessWidget {
  const ThatShyLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'That Shy Life',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.light,
        ),
      ),
      home: const JournalFeedScreen(),
    );
  }
}