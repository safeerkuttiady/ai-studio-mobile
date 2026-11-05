import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_studio_mobile/app.dart';

void main() {
  testWidgets('MyApp is a StatelessWidget', (WidgetTester tester) async {
    final app = MyApp();
    expect(app, isA<StatelessWidget>());
  });
}
