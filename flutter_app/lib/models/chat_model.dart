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
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt'])
          : null,
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
      timestamp: json['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'])
          : DateTime.now(),
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
}