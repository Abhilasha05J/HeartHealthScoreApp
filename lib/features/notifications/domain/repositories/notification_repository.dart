import 'package:heart_health_score/features/notifications/domain/entities/app_notification.dart';

/// Abstract contract for push + local notifications.
///
/// Following the project's dependency-inversion rule: screens/controllers
/// depend on this interface only, never on `FirebaseMessaging` or
/// `flutter_local_notifications` directly.
abstract class NotificationRepository {
  /// Sets up FCM + local notification plugin, requests permission where
  /// required (iOS always; Android 13+ via POST_NOTIFICATIONS), and wires
  /// up all listeners. Call once, early in app startup.
  Future<void> initialize();

  /// Current FCM registration token, or null if unavailable /
  /// not-yet-initialized. Send this to the backend so it can target this
  /// device — confirm the exact endpoint/field name with the backend team.
  Future<String?> getFcmToken();

  /// Fires whenever FCM rotates the token (rare, but happens — e.g. app
  /// restore on a new device). Re-send to backend when this fires.
  Stream<String> get onTokenRefresh;

  /// Emits an [AppNotification] whenever the user taps a notification
  /// (foreground, background, or terminated-then-launched). The router
  /// listens to this to deep-link (see app_router_diff.md).
  Stream<AppNotification> get onNotificationTapped;

  /// Topic-based broadcast, e.g. subscribe all users to `"general"` or a
  /// cohort-specific topic if the backend uses FCM topics rather than
  /// per-device targeting for some notification types.
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);

  /// Schedules a local (device-only) reminder notification, e.g. "Log
  /// today's vitals" at a user-chosen time. `id` must be unique per
  /// reminder so it can be individually cancelled/updated.
  Future<void> scheduleLocalReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    bool repeatsDaily = false,
  });

  Future<void> cancelLocalReminder(int id);
  Future<void> cancelAllLocalReminders();

  /// Explicit permission request (iOS notification prompt / Android 13+
  /// POST_NOTIFICATIONS). Returns true if granted. `initialize()` calls
  /// this internally, but expose it separately so a settings screen can
  /// re-prompt if the user initially declined.
  Future<bool> requestPermission();
}