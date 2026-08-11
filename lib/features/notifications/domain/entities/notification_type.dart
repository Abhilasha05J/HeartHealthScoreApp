/// Drives deep-link routing when a notification is tapped.
///
/// Add new values here as new notification categories are introduced by the
/// backend team, and extend `NotificationRouting.routeFor` in
/// `app_router.dart` (see integration_snippets/app_router_diff.md) to match.
enum NotificationType {
  /// A new Heart Health Score has been computed by the ML backend.
  scoreReady,

  /// Reminder to log today's activity / sleep / vitals.
  dailyReminder,

  /// Reminder specifically to log vitals (BP / resting heart rate).
  vitalsReminder,

  /// Fallback for anything not covered above — opens Home.
  general;

  /// Maps the raw `type` string sent in the FCM `data` payload (or used
  /// locally when scheduling a reminder) to a [NotificationType].
  ///
  /// Keep this in sync with whatever string key the backend team uses in
  /// their FCM data payload — confirm the exact key/values with them before
  /// wiring the real backend (see production-readiness note in the skill).
  static NotificationType fromRaw(String? raw) {
    switch (raw) {
      case 'score_ready':
        return NotificationType.scoreReady;
      case 'daily_reminder':
        return NotificationType.dailyReminder;
      case 'vitals_reminder':
        return NotificationType.vitalsReminder;
      default:
        return NotificationType.general;
    }
  }
}