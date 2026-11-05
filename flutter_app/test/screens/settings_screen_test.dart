import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ai_studio_mobile/screens/settings_screen.dart';
import 'package:ai_studio_mobile/providers/auth_provider.dart' as app_auth;

void main() {
  testWidgets('renders settings screen', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(
      ChangeNotifierProvider<app_auth.AuthProvider>(
        create: (_) => app_auth.AuthProvider(authService: FakeAuthService()),
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Manage your app settings'), findsOneWidget);
  });

  testWidgets('renders account section', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(
      ChangeNotifierProvider<app_auth.AuthProvider>(
        create: (_) => app_auth.AuthProvider(authService: FakeAuthService()),
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );

    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Privacy'), findsOneWidget);
    expect(find.text('Security'), findsOneWidget);
  });

  testWidgets('renders preferences section', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(
      ChangeNotifierProvider<app_auth.AuthProvider>(
        create: (_) => app_auth.AuthProvider(authService: FakeAuthService()),
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );

    expect(find.text('Preferences'), findsOneWidget);
    expect(find.text('Dark Mode'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
  });
}

class FakeAuthService implements app_auth.AuthService {
  @override
  Stream<User?> authStateChanges() => const Stream.empty();

  @override
  Future<User?> signInAnonymously() async => null;

  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) async => null;

  @override
  Future<User?> createUserWithEmailAndPassword(String email, String password) async => null;

  @override
  Future<void> signOut() async {}
}
