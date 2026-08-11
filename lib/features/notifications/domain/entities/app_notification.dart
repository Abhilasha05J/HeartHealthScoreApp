import 'notification_type.dart';

/// Normalized notification model. Both the FCM path and the local-reminder
/// path convert into this before reaching the application/presentation
/// layers, so the rest of the app never touches `RemoteMessage` or
/// `flutter_local_notifications` types directly.
class AppNotification {
  final String? id;
  final String title;
  final String body;
  final NotificationType type;

  /// Raw key/value payload — kept around in case a screen needs a specific
  /// field (e.g. a score value) beyond just routing.
  final Map<String, dynamic> data;

  const AppNotification({
    this.id,
    required this.title,
    required this.body,
    required this.type,
    this.data = const {},
  });

  factory AppNotification.fromFcmData(
      Map<String, dynamic> data, {
        String? title,
        String? body,
      }) {
    return AppNotification(
      id: data['id'] as String?,
      title: title ?? (data['title'] as String? ?? ''),
      body: body ?? (data['body'] as String? ?? ''),
      type: NotificationType.fromRaw(data['type'] as String?),
      data: data,
    );
  }

  factory AppNotification.fromLocalPayload(String? payload) {
    // Local reminders encode type as a plain string payload, e.g. "daily_reminder".
    return AppNotification(
      title: '',
      body: '',
      type: NotificationType.fromRaw(payload),
      data: {'type': payload},
    );
  }
}