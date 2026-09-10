import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_studio_mobile/screens/code_editor_screen.dart';

void main() {
  testWidgets('renders code editor screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CodeEditorScreen()),
    );

    expect(find.text('Code Editor'), findsOneWidget);
    expect(find.text('Write and edit your code'), findsOneWidget);
  });

  testWidgets('renders code input area', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CodeEditorScreen()),
    );

    expect(find.text('// Start writing your code here...'), findsOneWidget);
  });

  testWidgets('renders action buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CodeEditorScreen()),
    );

    expect(find.text('Run'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });
}
