import 'package:flutter/material.dart';
import 'package:that_shy_life_ui/LoginScreen.dart';
import 'package:that_shy_life_ui/ThatShyLifeApp.dart';
import 'package:that_shy_life_ui/app_theme.dart';
import 'JournalDetailScreen.dart';
import 'SocialBatteryScreen.dart';
import 'JournalEntry.dart';
import 'JournalService.dart';
import 'NewEntryScreen.dart';

class JournalFeedScreen extends StatefulWidget {
  const JournalFeedScreen({super.key});

  @override
  State<JournalFeedScreen> createState() => _JournalFeedScreenState();
}

class _JournalFeedScreenState extends State<JournalFeedScreen> {
  //final JournalService _journalService = JournalService();
  late Future<List<JournalEntry>>_future;

  @override
  void initState() {
    super.initState();
    _future = JournalService.fetchEntries();
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
        leading:
          IconButton(
              icon: const Icon(Icons.battery_charging_full_rounded),
              color: AppTheme.primary,
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SocialBatteryScreen()),
                );
              },
          ),

        actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          color: AppTheme.primary,
          onPressed: (){
           JournalService.deleteToken();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const LoginScreen()),
                (route) => false,
            );
          },
        ),
        ],

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
            print('Entries count: ${entries.length}');
            return Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return _buildJournalCard(context, entry);
                },
              ),
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewEntryScreen()),
          );
          if (result == true){
            setState(() {
              _future = JournalService.fetchEntries();
            });
          }
          },
        icon: const Icon(Icons.edit_note),
        label: const Text('New Reflection'),
      ),
    );
  }
}

Widget _buildJournalCard(BuildContext context, JournalEntry entry) {
  //Helper for a readable date display
  String formattedDate = "Unknown Date";
  if (entry.createdAt != null){
    final DateTime date = entry.createdAt;
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    formattedDate = "${months[date.month-1]} ${date.day}, ${date.year}";
  }
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => JournalDetailScreen(entry: entry),
              ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(
                        entry.microEntry ?? "Untitled Reflection",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: 13, color: Colors.grey[500],
                    ),
                  ),
                  ],
              ),
                  const SizedBox(width: 12),
                  Text(
                    entry.content ?? "No content recorded",
                    style: TextStyle(fontSize: 16, height: 1.5, color: Colors.grey[800],
                  ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
