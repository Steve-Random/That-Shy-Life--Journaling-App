import 'package:flutter/material.dart';
import 'package:that_shy_life_ui/JournalEntry.dart';
import 'package:that_shy_life_ui/app_theme.dart';
import 'JournalService.dart';

//For New Entries/New Reflections
class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({super.key});

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  int _socialBattery = 50;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  //Color helper
  Color _socialBatteryColor(){
    if (_socialBattery >= 65) return const Color(0xFF7FB5A8);
    if (_socialBattery >= 35) return const Color(0xFFD4A96A);
    return const Color(0xFFB08090);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('New Reflection'),
        actions: [
          TextButton(
            onPressed: () async {
              if((_titleController.text.isNotEmpty) && (_contentController.text.isNotEmpty)){
                final newEntry = JournalEntry(
                    microEntry: _titleController.text,
                    content: _contentController.text,
                    createdAt: DateTime.now(),
                  socialBattery: _socialBattery,
                );
                await JournalService().saveEntry(newEntry);
             if(mounted) Navigator.pop(context,true);}
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

              //Social Battery Label
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Social Battery',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textMuted,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Text(
                          '$_socialBattery',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _socialBatteryColor()
                          ),
                        ),
                      ],
                ),

                    const SizedBox(height: 8),

              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                  activeTickMarkColor: _socialBatteryColor(),
                  inactiveTickMarkColor: AppTheme.border,
                  thumbColor: Colors.white,
                  overlayColor: _socialBatteryColor().withValues(alpha: 0.15),
                ),
                child: Slider(
                  value: _socialBattery.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 100,
                  onChanged: (value){
                    setState(() {
                      _socialBattery = value.toInt();
                    });
                  },
                ),
              ),

              const SizedBox(height: 4),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Drained',
                    style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                  ),
                  Text(
                    'Recharged',
                    style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                  ),
                ],
              ),
              ],
                ),
              ),

              const SizedBox(height: 8),

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