import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_studio_mobile/screens/chat_detail_screen.dart';

void main() {
  group('ChatDetailScreen', () {
    testWidgets('renders chat detail screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChatDetailScreen(
            chatId: 'test-chat-id',
            title: 'Test Chat',
          ),
        ),
      );

      expect(find.text('Test Chat'), findsOneWidget);
      expect(find.text('Start a conversation by sending a message'), findsOneWidget);
    });

    testWidgets('sends a message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChatDetailScreen(
            chatId: 'test-chat-id',
            title: 'Test Chat',
          ),
        ),
      );

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Hello AI');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      expect(find.text('Hello AI'), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      expect(find.text('This is a simulated AI response to: "Hello AI"'), findsOneWidget);
    });
  });
}
