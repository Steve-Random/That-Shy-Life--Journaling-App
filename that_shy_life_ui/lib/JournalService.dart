import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';
import 'JournalEntry.dart';
import 'package:flutter/foundation.dart';

class JournalService {
  static String? _cachedToken;

  static String get baseUrl{
      return 'https://that-shy-life-journaling-app.onrender.com';
  }

  //Token Storage
  static Future<void> saveToken(String token) async {
    _cachedToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  static Future<String?> getToken() async {
    if( _cachedToken != null) return _cachedToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.getString('jwt_token');
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  //Authentication
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
  }else{
    throw Exception('Failed to load entries');
  }
}

//Sending a new reflection to Java (POST...http.post())
Future<void> saveEntry(JournalEntry entry) async{
    final token = await getToken();
  await http.post(
    Uri.parse('$baseUrl/api/entries'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(entry.toJson()),
  );
}
}