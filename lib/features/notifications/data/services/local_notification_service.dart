import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Thin wrapper around `flutter_local_notifications`. Not exposed outside
/// the data layer — `FirebaseNotificationRepository` is the only consumer.
class LocalNotificationService {
  LocalNotificationService._();
  static final LocalNotificationService instance = LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  final _tapController = StreamController<String?>.broadcast();

  /// Emits the notification `payload` string whenever a local notification
  /// is tapped (foreground or background).
  Stream<String?> get onTapped => _tapController.stream;

  static const String _reminderChannelId = 'heart_health_reminders';
  static const String _reminderChannelName = 'Health Reminders';
  static const String _reminderChannelDesc =
      'Daily reminders to log activity and vitals';

  Future<void> initialize() async {
    tz_data.initializeTimeZones();
    // Uses the device's local timezone. If reminders ever need to respect a
    // user-selected timezone instead of the device's, set tz.local via
    // tz.setLocalLocation(tz.getLocation(<iana_name>)) after fetching it
    // (e.g. via `flutter_timezone` package).

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    // Swap '@mipmap/ic_launcher' for a dedicated small monochrome status-bar
    // icon (e.g. 'ic_stat_notification') before release — Android requires
    // a flat white-on-transparent icon; the launcher icon will render as a
    // solid white square in the status bar otherwise.

    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false, // requested explicitly via requestPermission()
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: (response) {
        _tapController.add(response.payload);
      },
    );

    const androidChannel = AndroidNotificationChannel(
      _reminderChannelId,
      _reminderChannelName,
      description: _reminderChannelDesc,
      importance: Importance.high,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  Future<bool> requestPermission() async {
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final androidGranted =
        await androidImpl?.requestNotificationsPermission() ?? true;

    final iosImpl = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    final iosGranted = await iosImpl?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    ) ??
        true;

    return androidGranted && iosGranted;
  }

  /// Shows a notification immediately — used to re-post FCM foreground
  /// messages via the local notifications plugin (see
  /// `_handleForegroundMessage` in the repository), NOT for scheduled
  /// reminders. Use [scheduleReminder] for anything with a future time.
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) {
    return _plugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _reminderChannelId,
          _reminderChannelName,
          channelDescription: _reminderChannelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    bool repeatsDaily = false,
  }) async {
    final scheduledTz = tz.TZDateTime.from(scheduledDate, tz.local);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTz,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _reminderChannelId,
          _reminderChannelName,
          channelDescription: _reminderChannelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // Required on flutter_local_notifications < v17 (removed in v17+,
      // where iOS scheduling no longer needs this hint). If your resolved
      // version is v17+ and this line throws "no such named parameter"
      // instead, just delete this one line — everything else is unaffected.
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: repeatsDaily ? DateTimeComponents.time : null,
    );
  }

  Future<void> cancel(int id) => _plugin.cancel(id);

  Future<void> cancelAll() => _plugin.cancelAll();

  void dispose() => _tapController.close();
}