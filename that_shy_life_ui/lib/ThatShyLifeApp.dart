import 'package:flutter/material.dart';
import 'package:that_shy_life_ui/LandingScreen.dart';
import 'JournalFeedScreen.dart';
import 'JournalService.dart';
import 'LoginScreen.dart';
import 'app_theme.dart';
import 'LegalScreen.dart';

class ThatShyLifeApp extends StatefulWidget {
  const ThatShyLifeApp({super.key});

  @override
  State<ThatShyLifeApp> createState() => _ThatShyLifeAppState();
  }
  class _ThatShyLifeAppState extends State<ThatShyLifeApp>{
  late Future <String?> _tokenFuture;

  @override
    void initState(){
    super.initState();
    _tokenFuture = JournalService.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'That Shy Life',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: FutureBuilder<String?>(
          future: _tokenFuture,
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if(snapshot.data != null){
              return const JournalFeedScreen();
            }
            return const LandingScreen();
          },
      ),
    );
  }
}