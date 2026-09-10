import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat_model.dart';

class LocalStorageService {
  static const _chatsKey = 'ai_studio_chats';
  static const _codeKey = 'ai_studio_code';
  static const darkModeKey = 'ai_studio_dark_mode';
  static const notificationsKey = 'ai_studio_notifications';
  static const languageKey = 'ai_studio_language';

  Future<List<Chat>> loadChats() async {
    final preferences = await SharedPreferences.getInstance();
    final encodedChats = preferences.getString(_chatsKey);
    if (encodedChats == null || encodedChats.isEmpty) return [];

    try {
      final decoded = jsonDecode(encodedChats) as List<dynamic>;
      final chats = decoded
          .map((item) => Chat.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
      chats.sort((a, b) => (b.updatedAt ?? DateTime(1970))
          .compareTo(a.updatedAt ?? DateTime(1970)));
      return chats;
    } on FormatException {
      return [];
    }
  }

  Future<void> saveChats(List<Chat> chats) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _chatsKey,
      jsonEncode(chats.map((chat) => chat.toJson()).toList()),
    );
  }

  Future<String> loadCode() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_codeKey) ?? '';
  }

  Future<void> saveCode(String code) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_codeKey, code);
  }

  Future<bool> loadBool(String key, {required bool fallback}) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(key) ?? fallback;
  }

  Future<void> saveBool(String key, bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, value);
  }

  Future<String?> loadString(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

  Future<void> saveString(String key, String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
  }
}