import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final String title;
  final List<Message> messages;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Chat({
    required this.id,
    required this.title,
    this.messages = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      messages: (json['messages'] as List<dynamic>?)
              ?.map((msg) => Message.fromJson(msg))
              .toList() ??
          [],
      createdAt: _readDate(json['createdAt']),
      updatedAt: _readDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  Chat copyWith({
    String? id,
    String? title,
    List<Message>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Chat(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
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
    if (value is Timestamp) return value.toDate();
    return null;
  }
}

class Message {
  final String id;
  final String content;
  final String sender; // 'user' or 'ai'
  final DateTime timestamp;

  Message({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      sender: json['sender'] ?? '',
      timestamp: _readDate(json['timestamp']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender': sender,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
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
    if (value is Timestamp) return value.toDate();
    return null;
  }
}
