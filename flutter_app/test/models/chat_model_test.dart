import 'package:flutter_test/flutter_test.dart';
import 'package:ai_studio_mobile/models/chat_model.dart';

void main() {
  group('Chat Model', () {
    test('fromJson creates Chat correctly', () {
      final json = {
        'id': '1',
        'title': 'Test Chat',
        'messages': [],
        'createdAt': 1234567890000,
        'updatedAt': 1234567899999,
      };

      final chat = Chat.fromJson(json);

      expect(chat.id, '1');
      expect(chat.title, 'Test Chat');
      expect(chat.messages, isEmpty);
      expect(chat.createdAt, DateTime(2009, 2, 13, 23, 31, 30));
      expect(chat.updatedAt, DateTime(2009, 2, 13, 23, 31, 39, 999));
    });

    test('toJson serializes Chat correctly', () {
      final chat = Chat(
        id: '1',
        title: 'Test Chat',
        messages: [],
        createdAt: DateTime(2009, 2, 13, 23, 31, 30),
        updatedAt: DateTime(2009, 2, 13, 23, 31, 39),
      );

      final json = chat.toJson();

      expect(json['id'], '1');
      expect(json['title'], 'Test Chat');
      expect(json['messages'], isEmpty);
      expect(json['createdAt'], 1234567890000);
      expect(json['updatedAt'], 1234567899000);
    });

    test('copyWith creates a copy with updated fields', () {
      final chat = Chat(
        id: '1',
        title: 'Test Chat',
        messages: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final updatedChat = chat.copyWith(title: 'Updated Chat');

      expect(updatedChat.id, '1');
      expect(updatedChat.title, 'Updated Chat');
      expect(updatedChat.messages, chat.messages);
    });
  });

  group('Message Model', () {
    test('fromJson creates Message correctly', () {
      final json = {
        'id': '1',
        'content': 'Hello',
        'sender': 'user',
        'timestamp': 1234567890000,
      };

      final message = Message.fromJson(json);

      expect(message.id, '1');
      expect(message.content, 'Hello');
      expect(message.sender, 'user');
      expect(message.timestamp, DateTime(2009, 2, 13, 23, 31, 30));
    });

    test('toJson serializes Message correctly', () {
      final message = Message(
        id: '1',
        content: 'Hello',
        sender: 'user',
        timestamp: DateTime(2009, 2, 13, 23, 31, 30),
      );

      final json = message.toJson();

      expect(json['id'], '1');
      expect(json['content'], 'Hello');
      expect(json['sender'], 'user');
      expect(json['timestamp'], 1234567890000);
    });
  });
}
