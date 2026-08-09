import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:that_shy_life_ui/LoginScreen.dart';
import 'app_theme.dart';
import 'JournalEntry.dart';
import 'package:flutter/foundation.dart';

/// Thrown when the backend rejects a request due to a missing expired,
/// or invalid JWT (HTTP 401). Callers should catch this and redirect
/// the user to [LoginScreen] rather than showing a generic error.
class SessionExpiredException implements Exception{}

/// Handles all HTTP communication with the Spring Boot backend:
/// authentication (register/login), JWT token storage, and journal
/// entry CRUD operations.
///
/// Token persistence uses [SharedPreferences] with an in-memory cache
/// ([_cachedToken]) as a workaround for a Flutter web race condition
/// where SharedPreferences can return null immediately after a write.
class JournalService {
  static String? _cachedToken;

  /// Resolved at compile time via ' --dart-define=STAGING'; defaults to
  /// production if the flag isn't passed
  static String get baseUrl{
     const bool useStaging = bool.fromEnvironment('STAGING', defaultValue:  false);
      return useStaging
        ?'https://that-shy-life-journaling-app-staging.onrender.com'
          :'https://that-shy-life-journaling-app.onrender.com';
  }

  //Token Storage
  static Future<void> saveToken(String token) async {
    _cachedToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  /// Cache-first lookup -- see class doc for why the in memory cache exists.
  static Future<String?> getToken() async {
    if( _cachedToken != null) return _cachedToken;
    final prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString('jwt_token');
    _cachedToken = token;
    return token;
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  //Authentication
  /// Returns 'false' on failure rather than throwing (unlike fetchEntries / saveEntry).
  static Future<bool> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      await saveToken(data['token']);
      return true;
    }
    return false;
  }

  /// Same success/failure contract as [register].
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      await saveToken(data['token']);
      return true;
    }
    return false;
  }


  //Entries

  //Fetching all entries from Java
  ///Throws [SessionExpiredException] when the stored auth token is missing, expired
  /// or rejected by the backend so callers can redirect to [LoginScreen] instead of
  /// showing a generic error.
static Future<List<JournalEntry>> fetchEntries() async{
    final token = await getToken();
  final response = await http.get(
      Uri.parse('$baseUrl/api/entries'),
    headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
    }
  );
  if(response.statusCode == 200){
    List<dynamic> body = json.decode(response.body);
    return body.map((item) => JournalEntry.fromJson(item)).toList();
  }else if(response.statusCode == 401){
    throw SessionExpiredException();
  }else{
    throw Exception('Failed to load entries');
  }
}

//Sending a new reflection to Java (POST...http.post())
  /// Throws [SessionExpiredException] on HTTP 401 (same pattern as [fetchEntries]).
Future<void> saveEntry(JournalEntry entry) async{
    final token = await getToken();
 final response =  await http.post(
    Uri.parse('$baseUrl/api/entries'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(entry.toJson()),
  );
  if (response.statusCode == 401){
    throw SessionExpiredException();
  }else if ((response.statusCode != 200) && (response.statusCode != 201)){
    throw Exception("Failed to save entry");
  }
}

}