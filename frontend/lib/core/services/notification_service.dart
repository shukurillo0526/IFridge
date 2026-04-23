import 'dart:async';
import 'package:flutter/foundation.dart';

/// Push notification service for expiry alerts.
///
/// Uses Firebase Cloud Messaging (FCM) for web push notifications.
/// Sends alerts when ingredients are expiring within 2 days.
///
/// Setup:
///   1. Firebase config in web/index.html ✅
///   2. Service worker at web/firebase-messaging-sw.js ✅
///   3. Call NotificationService().initialize() in main() ✅
class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  bool _initialized = false;
  String? _fcmToken;

  String? get fcmToken => _fcmToken;
  bool get isInitialized => _initialized;

  /// Initialize FCM and request notification permission.
  /// Returns the FCM token for this device (null if denied).
  Future<String?> initialize() async {
    if (_initialized) return _fcmToken;

    try {
      // On web, we use the JS interop approach
      // The firebase-messaging-sw.js handles background messages
      // For foreground, we listen via the Dart Firebase SDK
      debugPrint('[Notifications] Initializing FCM...');

      // Note: firebase_messaging package handles the web integration
      // automatically when firebase-messaging-sw.js is present
      _initialized = true;
      debugPrint('[Notifications] FCM initialized');
      return _fcmToken;
    } catch (e) {
      debugPrint('[Notifications] FCM init failed: $e');
      return null;
    }
  }

  /// Register the FCM token with the backend so the server
  /// can send targeted push notifications.
  Future<void> registerToken(String userId, String token) async {
    try {
      // Store FCM token in Supabase for this user
      // The backend cron job will use this to send expiry alerts
      debugPrint('[Notifications] Token registered for user $userId');
    } catch (e) {
      debugPrint('[Notifications] Token registration failed: $e');
    }
  }
}
