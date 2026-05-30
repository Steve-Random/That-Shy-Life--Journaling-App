class JournalEntry {
  final String? id;
  final String title;
  final String content;
  final DateTime createdAt;

  JournalEntry({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
});

  //converting JSON Map into a Dart object
factory JournalEntry.fromJson(Map<String, dynamic> json) {
  return JournalEntry(
    id: json['id'].toString(),
    title: json['title'],
    content: json['content'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}

// converting Dart object into JSON
Map<String, dynamic> toJson() {
  return {
    'title': title,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
  };
  }
}
