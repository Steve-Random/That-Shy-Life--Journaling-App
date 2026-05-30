import 'package:flutter/material.dart';

void main() {
  runApp(const ThatShyLifeApp());
}

class ThatShyLifeApp extends StatelessWidget {
  const ThatShyLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'That Shy Life',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.light,
        ),
      ),
      home: const JournalFeedScreen(),
    );
  }
}

class JournalFeedScreen extends StatefulWidget {
  const JournalFeedScreen({super.key});

  @override
  State<JournalFeedScreen> createState() => _JournalFeedScreenState();
}

class _JournalFeedScreenState extends State<JournalFeedScreen> {
  // this is mock data to visualise the layout before connecting to the API
  final List<Map<String, String>> _mockEntries = [
    {
      'date': 'May 29, 2026',
      'title': 'Morning Reflections',
      'content':
          'Just setting up the unified workspace today. It feels great to see the java backend and Flutter web UI finally talking to each other smoothly.',
    },
    {
      'date': 'May 28, 2026',
      'title': 'Keeping It Natural',
      'content':
          'Thinking about content styles today. There is something deeply powerful about keeping things raw, uscripted, and authentically human.',
    },
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
                                entry['date']!,
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
                            entry['title']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            entry['content']!,
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

//For New Entries/New Reflections
class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({super.key});

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('New Reflecion'),
        actions: [
          TextButton(
            onPressed: () {
              //TODO: link to Java API
            },
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const Divider(),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  style: const TextStyle(fontSize: 18, height: 1.5),
                  decoration: const InputDecoration(
                    hintText: 'What is on your mind?',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
