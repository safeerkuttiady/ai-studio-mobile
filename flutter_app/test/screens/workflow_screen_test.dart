import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_studio_mobile/screens/workflow_screen.dart';

void main() {
  testWidgets('renders workflow screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: WorkflowScreen()),
    );

    expect(find.text('Workflows'), findsOneWidget);
    expect(find.text('Manage your automated workflows'), findsOneWidget);
  });

  testWidgets('renders workflow items', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: WorkflowScreen()),
    );

    expect(find.text('Daily Tasks'), findsOneWidget);
    expect(find.text('Project Planning'), findsOneWidget);
    expect(find.text('AI Automation'), findsOneWidget);
  });
}
