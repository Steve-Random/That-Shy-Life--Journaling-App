/// Represents a single journal eentry,mirroring the backends
/// 'JournalEntry' model.
///
/// Used both for entries fetched from the API and new entries being
/// created locally before they are saved via [JournalService].
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

/// Parses a [JournalEntry] from a JSON mao returned by the backend.
  ///
  /// [createdAt] is truncated to 26 characters when present, to strip
  /// excess sub-microsecond precision some backend responses include
  /// before parsing with [DateTime.tryParse]: if parsing fails or the
  /// field is missing, [DateTime.now] is used as a fallback.
  ///
  /// [socialBattery] defaults to 50 and [tags] to an empty list if
  /// absent from the response.
factory JournalEntry.fromJson(Map<String, dynamic> json) =>
  JournalEntry(
    id: json['id'],
    microEntry: json['microEntry'],
    content: json['content'],
    createdAt: json['createdAt']!= null
    ?DateTime.tryParse(json['createdAt'].toString().length>26
    ? json['createdAt'].toString().substring(0,26):json['createdAt'].toString())??DateTime.now():DateTime.now(),
    socialBattery: (json['socialBattery'] as num ?)?.toInt() ?? 50,
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


