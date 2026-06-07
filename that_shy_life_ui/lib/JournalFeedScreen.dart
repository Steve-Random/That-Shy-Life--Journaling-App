import 'package:flutter/material.dart';

import 'JournalEntry.dart';
import 'JournalService.dart';
import 'NewEntryScreen.dart';

class JournalFeedScreen extends StatefulWidget {
  const JournalFeedScreen({super.key});

  @override
  State<JournalFeedScreen> createState() => _JournalFeedScreenState();
}

class _JournalFeedScreenState extends State<JournalFeedScreen> {
  final JournalService _journalService = JournalService();
  late Future<List<JournalEntry>>_future;

  @override
  void initState(){
    super.initState();
    _future = _journalService.fetchEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text(
          'That Shy Life',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: FutureBuilder<List<JournalEntry>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            final entries = snapshot.data ?? [];
            return Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return _buildJournalCard(entry);
                },
              ),
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
          final result = Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewEntryScreen()),
          );
          await Future.delayed(const Duration(milliseconds: 500));
            setState(() {
              _future = _journalService.fetchEntries();
            });
          },
        icon: const Icon(Icons.edit_note),
        label: const Text('New Reflection'),
      ),
    );
  }
}

Widget _buildJournalCard(JournalEntry entry) {
  return Padding(
    padding: const EdgeInsets.only(top: 16.0),
    child: Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          //TODO: Tack care of oppening detail view
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.content ?? "No content recorded",
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
