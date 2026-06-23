import 'package:flutter/material.dart';
import 'JournalFeedScreen.dart';
import 'JournalService.dart';
import 'LoginScreen.dart';
import 'app_theme.dart';

class ThatShyLifeApp extends StatelessWidget {
  const ThatShyLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'That Shy Life',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: FutureBuilder<String?>(
          future: JournalService.getToken(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if(snapshot.data != null){
              return const JournalFeedScreen();
            }
            return const LoginScreen();
          },
      ),
    );
  }
}