import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'app.dart';
import 'app_settings.dart';
import 'services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (error) {
    // Firebase is optional for the local-first experience. The app can still
    // be used with local chats and tools when no platform config is present.
    debugPrint('Firebase unavailable: $error');
  }
  final storage = LocalStorageService();
  darkModeNotifier.value = await storage.loadBool(
    LocalStorageService.darkModeKey,
    fallback: false,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}