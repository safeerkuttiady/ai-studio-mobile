import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat_model.dart';
import '../models/code_file.dart';
import '../models/workflow.dart';

class LocalStorageService {
  static const String _chatsKey = 'local_chats';
  static const String _codeFilesKey = 'local_code_files';
  static const String _workflowsKey = 'local_workflows';
  static const String _localUserIdKey = 'local_user_id';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _darkModeKey = 'dark_mode_enabled';
  static const String _languageKey = 'selected_language';
  static const String _analyticsKey = 'analytics_enabled';
  static const String _profileNameKey = 'profile_name';
  static const String _profileEmailKey = 'profile_email';

  Future<List<Chat>> getChats() async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = preferences.getString(_chatsKey);
    if (encoded == null || encoded.isEmpty) return [];
    try {
      final decoded = jsonDecode(encoded) as List<dynamic>;
      return decoded.map((item) => Chat.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      await preferences.remove(_chatsKey);
      return [];
    }
  }

  Future<void> saveChat(Chat chat) async {
    final preferences = await SharedPreferences.getInstance();
    final chats = await getChats();
    final index = chats.indexWhere((item) => item.id == chat.id);
    if (index == -1) {
      chats.add(chat);
    } else {
      chats[index] = chat;
    }
    await preferences.setString(_chatsKey, jsonEncode(chats.map((item) => item.toJson()).toList()));
  }

  Future<void> deleteChat(String chatId) async {
    final preferences = await SharedPreferences.getInstance();
    final chats = await getChats();
    chats.removeWhere((item) => item.id == chatId);
    await preferences.setString(_chatsKey, jsonEncode(chats.map((item) => item.toJson()).toList()));
  }

  Future<List<CodeFile>> getCodeFiles() async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = preferences.getString(_codeFilesKey);
    if (encoded == null || encoded.isEmpty) return [];
    try {
      final decoded = jsonDecode(encoded) as List<dynamic>;
      return decoded
          .map((item) => CodeFile.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      await preferences.remove(_codeFilesKey);
      return [];
    }
  }

  Future<void> saveCodeFile(CodeFile file) async {
    final preferences = await SharedPreferences.getInstance();
    final files = await getCodeFiles();
    final index = files.indexWhere((item) => item.id == file.id);
    if (index == -1) {
      files.add(file);
    } else {
      files[index] = file;
    }
    await preferences.setString(
      _codeFilesKey,
      jsonEncode(files.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> deleteCodeFile(String fileId) async {
    final preferences = await SharedPreferences.getInstance();
    final files = await getCodeFiles();
    files.removeWhere((item) => item.id == fileId);
    await preferences.setString(
      _codeFilesKey,
      jsonEncode(files.map((item) => item.toJson()).toList()),
    );
  }

  Future<List<Workflow>> getWorkflows() async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = preferences.getString(_workflowsKey);
    if (encoded == null || encoded.isEmpty) return [];
    try {
      final decoded = jsonDecode(encoded) as List<dynamic>;
      return decoded
          .map((item) => Workflow.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      await preferences.remove(_workflowsKey);

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

  Future<void> saveWorkflow(Workflow workflow) async {
    final preferences = await SharedPreferences.getInstance();
    final workflows = await getWorkflows();
    final index = workflows.indexWhere((item) => item.id == workflow.id);
    if (index == -1) {
      workflows.add(workflow);
    } else {
      workflows[index] = workflow;
    }
    await preferences.setString(
      _workflowsKey,
      jsonEncode(workflows.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> deleteWorkflow(String workflowId) async {
    final preferences = await SharedPreferences.getInstance();
    final workflows = await getWorkflows();
    workflows.removeWhere((item) => item.id == workflowId);
    await preferences.setString(
      _workflowsKey,
      jsonEncode(workflows.map((item) => item.toJson()).toList()),
    );
  }

  Future<String> getLocalUserId() async {
    final preferences = await SharedPreferences.getInstance();
    final existing = preferences.getString(_localUserIdKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final created = DateTime.now().microsecondsSinceEpoch.toString();
    await preferences.setString(_localUserIdKey, created);
    return created;
  }

  Future<bool> areNotificationsEnabled() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_notificationsKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_notificationsKey, value);
  }

  Future<bool> isDarkModeEnabled() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_darkModeKey) ?? false;
  }

  Future<void> setDarkModeEnabled(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_darkModeKey, value);
  }

  Future<String> getLanguage() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_languageKey) ?? 'English';
  }

  Future<void> setLanguage(String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_languageKey, value);
  }

  Future<bool> isAnalyticsEnabled() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_analyticsKey) ?? true;
  }

  Future<void> setAnalyticsEnabled(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_analyticsKey, value);
  }

  Future<String> getProfileName() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_profileNameKey) ?? 'AI Studio User';
  }

  Future<void> setProfileName(String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_profileNameKey, value);
  }

  Future<String> getProfileEmail() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_profileEmailKey) ?? '';
  }

  Future<void> setProfileEmail(String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_profileEmailKey, value);
  }

  Future<void> clearUserData() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_chatsKey);
    await preferences.remove(_codeFilesKey);
    await preferences.remove(_workflowsKey);
    await preferences.remove(_localUserIdKey);
    await preferences.remove(_profileNameKey);
    await preferences.remove(_profileEmailKey);
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
