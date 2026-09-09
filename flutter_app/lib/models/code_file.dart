class CodeFile {
  final String id;
  final String title;
  final String language;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  CodeFile({
    required this.id,
    required this.title,
    required this.language,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CodeFile.fromJson(Map<String, dynamic> json) {
    return CodeFile(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Untitled',
      language: json['language'] ?? 'dart',
      content: json['content'] ?? '',
      createdAt: _readDate(json['createdAt']) ?? DateTime.now(),
      updatedAt: _readDate(json['updatedAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'language': language,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  CodeFile copyWith({
    String? id,
    String? title,
    String? language,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CodeFile(
      id: id ?? this.id,
      title: title ?? this.title,
      language: language ?? this.language,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _readDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) {
      final milliseconds = int.tryParse(value);
      if (milliseconds != null) {
        return DateTime.fromMillisecondsSinceEpoch(milliseconds);
      }
    }
    return null;
  }
}
