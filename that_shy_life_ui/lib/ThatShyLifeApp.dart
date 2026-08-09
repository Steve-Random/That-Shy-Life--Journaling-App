import 'package:flutter/material.dart';
import 'package:that_shy_life_ui/LandingScreen.dart';
import 'JournalFeedScreen.dart';
import 'JournalService.dart';
import 'LoginScreen.dart';
import 'app_theme.dart';
import 'LegalScreen.dart';

/// Root widget. Rebuilds on theme changes via [AppTheme.themeMode], and
/// decides the initial route by checking for a stored auth token --
/// see [_ThatShyLifeAppState.build] for the routing logic.
class ThatShyLifeApp extends StatefulWidget {
  const ThatShyLifeApp({super.key});

  @override
  State<ThatShyLifeApp> createState() => _ThatShyLifeAppState();
  }
  class _ThatShyLifeAppState extends State<ThatShyLifeApp>{
  late Future <String?> _tokenFuture;

  /// Starts the token lookup once, at app launch, so [build] can gate
  /// the initial route on it via FutureBuilder rather than rechecking
  /// on every rebuild.
  @override
    void initState(){
    super.initState();
    _tokenFuture = JournalService.getToken();
  }

  /// Determines the initial screen based on whether a stored auth token
  /// exists: [JournalFeedScreen] if present, [LandingScreen] otherwise.
  /// This is a presence check only -- an expired or invalid token still
  /// routes to JournalFeedScreen, and any 401 there is caught by the
  /// SessionExpiredException handling in JournalService/JournalFeedScreen,
  /// which redirects to LoginScreen. So an expired token means one extra
  /// screen flash before redirect, not a broken state.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: AppTheme.themeMode,
        builder: (context,mode,_) {
          return MaterialApp(
            title: 'That Shy Life',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: mode,
            home: FutureBuilder<String?>(
              future: _tokenFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.data != null) {
                  return const JournalFeedScreen();
                }
                return const LandingScreen();
              },
            ),
          );
        }
          );
  }
}
