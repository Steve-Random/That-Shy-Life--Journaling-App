import 'package:flutter/material.dart';
import 'package:that_shy_life_ui/JournalEntry.dart';

class JournalDetailScreen extends StatelessWidget{
  final JournalEntry entry;

  const JournalDetailScreen({super.key, required this.entry});

  //helper method for a readable date
  String _formatDate(DateTime? dateTime) {
  if (dateTime == null) return "Unknown Date";
  final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  return "${months[dateTime.month-1]} ${dateTime.day}, ${dateTime.year}";
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(entry.microEntry ?? "Reflection Details"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //------Header Card-------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Date Recorded",
                    style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(entry.createdAt),
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  //TODO Stack Social Battery and tags later
                ],
              ),
            ),
            //-----Main Reflection Body
            const Text(
              "My Reflection",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
            ),
            const SizedBox(height: 12),
            SelectableText(
              entry.content ?? "No content recorded.",
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),

    );
  }
}