import 'dart:convert';
import 'package:http/http.dart' as http;
import 'JournalEntry.dart';
import 'package:flutter/foundation.dart';

class JournalService {
  // running locally for now (GET...http.get())

  static String get baseUrl{
    if(kIsWeb){
      return 'http://localhost:8080/api/entries';
    }else{
      return 'https://that-shy-life-journaling-app.onrender.com/api/entries';
    }
  }

  //Fetching all entries from Java
Future<List<JournalEntry>> fetchEntries() async{
  final response = await http.get(Uri.parse(baseUrl));

  if(response.statusCode == 200){
    List<dynamic> body = json.decode(response.body);
    return body.map((item) => JournalEntry.fromJson(item)).toList();
  }else{
    throw Exception('Failed to load entries');
  }
}

//Sending a new reflection to Java (POST...http.post())
Future<void> saveEntry(JournalEntry entry) async{
  await http.post(
    Uri.parse(baseUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(entry.toJson()),
  );
}
}