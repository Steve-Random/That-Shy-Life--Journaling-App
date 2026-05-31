import 'package:flutter/material.dart';
import 'JournalEntry.dart';
import 'NewEntryScreen.dart';

class JournalFeedScreen extends StatefulWidget {
  const JournalFeedScreen({super.key});

  @override
  State<JournalFeedScreen> createState() => _JournalFeedScreenState();
}

class _JournalFeedScreenState extends State<JournalFeedScreen> {
  // this is mock data to visualise the layout before connecting to the API
  final List<JournalEntry> _mockEntries = [
    JournalEntry(
      id: '1',
      title: 'Morning Reflections',
      content:
          'Just setting up the unified workspace today. It feels great to see the java backend and Flutter web UI finally talking to each other smoothly.',
      createdAt: DateTime.now(),
    ),

    JournalEntry(
      id: '2',
      title: 'Keeping It Natural',
      content:
          'Thinking about content styles today. There is something deeply powerful about keeping things raw, uscripted, and authentically human.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

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
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          //Centers and bounds layout on web
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.builder(
            itemCount: _mockEntries.length,
            itemBuilder: (context, index) {
              final entry = _mockEntries[index];
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
                                "${entry.createdAt.month}/${entry.createdAt.day}/${entry.createdAt.year}",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(Icons.more_horiz, color: Colors.grey[400]),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            entry.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            entry.content,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: ((context) => const NewEntryScreen())),
          );
        },
        icon: const Icon(Icons.edit_note),
        label: const Text('New Reflection'),
      ),
    );
  }
}
