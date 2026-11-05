import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_studio_mobile/models/chat_model.dart';
import 'package:ai_studio_mobile/screens/chat_screen.dart';
import 'package:ai_studio_mobile/services/firebase_service.dart';

class FakeChatService implements ChatService {
  @override
  Future<List<Chat>> getAllChatsFromFirestore() async => [];

  @override
  Future<void> saveChatToFirestore(Chat chat) async {}

  @override
  Future<void> deleteChatFromFirestore(String chatId) async {}

  @override
  Future<Chat?> getChatFromFirestore(String chatId) async => null;
}

void main() {
  testWidgets('renders chat screen with empty state', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChatScreen(chatService: FakeChatService()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Chats'), findsOneWidget);
    expect(find.text('Manage your conversations'), findsOneWidget);
    expect(find.text('No chats yet'), findsOneWidget);
  });

  testWidgets('creates a new chat', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChatScreen(chatService: FakeChatService()),
      ),
    );

    await tester.pumpAndSettle();

    final textField = find.byType(TextField);
    await tester.enterText(textField, 'New Chat');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('New Chat'), findsOneWidget);
  });
}
