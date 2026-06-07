
class JournalEntry {
  final String? id;
  final String? microEntry;
  final String? content;
  final DateTime createdAt;
  final int socialBattery;
  final bool isAudioTranscript;
  final List<String> tags;

  JournalEntry({
    this.id,
    this.microEntry,
    this.content,
    required this.createdAt,
    this.socialBattery = 50,
    this.isAudioTranscript = false,
    this.tags = const[],
});

  //converting JSON Map into a Dart object
factory JournalEntry.fromJson(Map<String, dynamic> json) =>
  JournalEntry(
    id: json['id'],
    microEntry: json['microEntry'],
    content: json['content'],
    createdAt: json['createdAt']!= null
    ?DateTime.tryParse(json['createdAt'].toString().length>26
    ? json['createdAt'].toString().substring(0,26):json['createdAt'].toString())??DateTime.now():DateTime.now(),
    socialBattery: json['socialBattery']??50,
    isAudioTranscript: json['isAudioTranscript']??false,
    tags: List<String>.from(json['tags']??[]),
  );


// converting Dart object into JSON
Map<String, dynamic> toJson() =>{
    'microEntry': microEntry,
    'content': content,
    'socialBattery': socialBattery,
  'isAudioTranscript':isAudioTranscript,
  'tags': tags,
  };
}


