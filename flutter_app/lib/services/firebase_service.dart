import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../models/chat_model.dart';

abstract class ChatService {
  Future<List<Chat>> getAllChatsFromFirestore();
  Future<void> saveChatToFirestore(Chat chat);
  Future<void> deleteChatFromFirestore(String chatId);
  Future<Chat?> getChatFromFirestore(String chatId);
}

class FirebaseService implements ChatService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseAnalytics _analytics;
  final FirebaseCrashlytics _crashlytics;

  FirebaseService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    FirebaseAnalytics? analytics,
    FirebaseCrashlytics? crashlytics,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _analytics = analytics ?? FirebaseAnalytics.instance,
        _crashlytics = crashlytics ?? FirebaseCrashlytics.instance;

  User? getCurrentUser() => _auth.currentUser;

  Future<User?> signInAnonymously() async {
    try {
      return (await _auth.signInAnonymously()).user;
    } catch (error) {
      await _crashlytics.recordError(error, StackTrace.current);
      rethrow;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      return (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).user;
    } catch (error) {
      await _crashlytics.recordError(error, StackTrace.current);
      rethrow;
    }
  }

  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).user;
    } catch (error) {
      await _crashlytics.recordError(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      await _crashlytics.recordError(error, StackTrace.current);
      rethrow;
    }
  }

  @override
  Future<void> saveChatToFirestore(Chat chat) async {
    try {
      final user = getCurrentUser();
      if (user == null) throw Exception('User not authenticated');

      final chatRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('chats')
          .doc(chat.id);
      await chatRef.set({
        ...chat.toJson(),
        'createdAt': chat.createdAt?.millisecondsSinceEpoch ??
            FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await _analytics.logEvent(
        name: 'chat_saved',
        parameters: {'chat_id': chat.id},
      );
    } catch (error) {
      await _crashlytics.recordError(error, StackTrace.current);
      rethrow;
    }
  }

  @override
  Future<Chat?> getChatFromFirestore(String chatId) async {
    try {
      final user = getCurrentUser();
      if (user == null) throw Exception('User not authenticated');
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('chats')
          .doc(chatId)
          .get();
      final data = doc.data();
      if (data == null) return null;
      data['id'] = doc.id;
      return Chat.fromJson(data);
    } catch (error) {
      await _crashlytics.recordError(error, StackTrace.current);
      rethrow;
    }
  }

  @override
  Future<List<Chat>> getAllChatsFromFirestore() async {
    try {
      final user = getCurrentUser();
      if (user == null) throw Exception('User not authenticated');
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('chats')
          .orderBy('updatedAt', descending: true)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Chat.fromJson(data);
      }).toList();
    } catch (error) {
      await _crashlytics.recordError(error, StackTrace.current);
      rethrow;
    }
  }

  @override
  Future<void> deleteChatFromFirestore(String chatId) async {
    try {
      final user = getCurrentUser();
      if (user == null) throw Exception('User not authenticated');
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('chats')
          .doc(chatId)
          .delete();
      await _analytics.logEvent(
        name: 'chat_deleted',
        parameters: {'chat_id': chatId},
      );
    } catch (error) {
      await _crashlytics.recordError(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> logEvent(String eventName, Map<String, Object>? parameters) async {
    try {
      await _analytics.logEvent(name: eventName, parameters: parameters);
    } catch (error) {
      debugPrint('Analytics log error: $error');
    }
  }

  Future<void> recordError(dynamic error) async {
    try {
      await _crashlytics.recordError(error, StackTrace.current);
    } catch (crashlyticsError) {
      debugPrint('Failed to record error in Crashlytics: $crashlyticsError');
    }
  }

  Future<void> setUserProperty(String name, String value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (error) {
      debugPrint('Error setting user property: $error');
    }
  }
}
