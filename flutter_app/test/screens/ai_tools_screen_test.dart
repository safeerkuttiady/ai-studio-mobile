import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_studio_mobile/screens/ai_tools_screen.dart';

void main() {
  testWidgets('renders AI tools screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AIToolsScreen()),
    );

    expect(find.text('AI Tools'), findsOneWidget);
    expect(find.text('Access various AI-powered tools'), findsOneWidget);
  });

  testWidgets('renders tool cards', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AIToolsScreen()),
    );

    expect(find.text('Text Generator'), findsOneWidget);
    expect(find.text('Image Generator'), findsOneWidget);
    expect(find.byType(Card), findsAtLeast(1));
  });
}
