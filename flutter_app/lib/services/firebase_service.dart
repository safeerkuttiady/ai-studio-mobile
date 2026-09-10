import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../models/chat_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Authentication methods
  Future<User?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      await _crashlytics.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      await _crashlytics.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      await _crashlytics.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      await _crashlytics.recordError(Exception('Sign out error'), StackTrace.current);
      rethrow;
    }
  }

  // Chat data methods
  Future<DocumentReference> saveChatToFirestore(Chat chat) async {
    try {
      final user = getCurrentUser();
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final chatRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('chats')
          .doc(chat.id);

      await chatRef.set({
        ...chat.toJson(),
        'createdAt': chat.createdAt?.millisecondsSinceEpoch ?? FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Log the event in analytics
      await _analytics.logEvent(
        name: 'chat_saved',
        parameters: {'chat_id': chat.id},
      );

      return chatRef;
    } catch (e) {
      await _crashlytics.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<Chat?> getChatFromFirestore(String chatId) async {
    try {
      final user = getCurrentUser();
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final chatRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('chats')
          .doc(chatId);

      final doc = await chatRef.get();
      if (doc.exists) {
        return Chat.fromJson(doc.data()!..['id'] = doc.id);
      }
      return null;
    } catch (e) {
      await _crashlytics.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<List<Chat>> getAllChatsFromFirestore() async {
    try {
      final user = getCurrentUser();
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final chatsSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('chats')
          .orderBy('updatedAt', descending: true)
          .get();

      return chatsSnapshot.docs
          .map((doc) => Chat.fromJson(doc.data()..['id'] = doc.id))
          .toList();
    } catch (e) {
      await _crashlytics.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> deleteChatFromFirestore(String chatId) async {
    try {
      final user = getCurrentUser();
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('chats')
          .doc(chatId)
          .delete();

      // Log the event in analytics
      await _analytics.logEvent(
        name: 'chat_deleted',
        parameters: {'chat_id': chatId},
      );
    } catch (e) {
      await _crashlytics.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  // Analytics methods
  Future<void> logEvent(String eventName, Map<String, Object>? parameters) async {
    try {
      await _analytics.logEvent(name: eventName, parameters: parameters);
    } catch (e) {
      debugPrint('Analytics log error: $e');
    }
  }

  // Crashlytics methods
  Future<void> recordError(dynamic error) async {
    try {
      await _crashlytics.recordError(error, StackTrace.current);
    } catch (crashlyticsError) {
      debugPrint('Failed to record error in Crashlytics: $crashlyticsError');
    }
  }

  // Set user properties for analytics
  Future<void> setUserProperty(String name, String value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      debugPrint('Error setting user property: $e');
    }
  }
}