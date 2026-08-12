import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:heart_health_score/features/notifications/data/services/local_notification_service.dart';
import 'package:heart_health_score/features/notifications/domain/entities/app_notification.dart';
import 'package:heart_health_score/features/notifications/domain/repositories/notification_repository.dart';

class FirebaseNotificationRepository implements NotificationRepository {
  FirebaseNotificationRepository({FirebaseMessaging? messaging})
      : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;
  final LocalNotificationService _local = LocalNotificationService.instance;

  final _tapController = StreamController<AppNotification>.broadcast();
  StreamSubscription<String?>? _localTapSub;

  @override
  Stream<AppNotification> get onNotificationTapped => _tapController.stream;

  @override
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  @override
  Future<void> initialize() async {
    await _local.initialize();
    await requestPermission();

    // 1. Foreground FCM messages — iOS/Android suppress the system tray by
    //    default while the app is foregrounded, so we re-post via the local
    //    notifications plugin to keep behavior consistent across app states.
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // 2. App was backgrounded (not terminated) and the user tapped the
    //    system tray notification.
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTapFromFcm);

    // 3. App was fully terminated and launched BY tapping a notification.
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      // Defer to next frame so the router/navigator exists by the time this
      // fires — see integration_snippets/main_dart_diff.md for how the
      // listener is attached after the widget tree is built.
      Future.microtask(() => _handleNotificationTapFromFcm(initialMessage));
    }

    // 4. Local-reminder taps route through the same stream so the router
    //    only has to listen in one place.
    _localTapSub = _local.onTapped.listen((payload) {
      _tapController.add(AppNotification.fromLocalPayload(payload));
    });
  }

  @override
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final fcmGranted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional;

    final localGranted = await _local.requestPermission();
    return fcmGranted && localGranted;
  }

  @override
  Future<String?> getFcmToken() => _messaging.getToken();

  @override
  Future<void> subscribeToTopic(String topic) =>
      _messaging.subscribeToTopic(topic);

  @override
  Future<void> unsubscribeFromTopic(String topic) =>
      _messaging.unsubscribeFromTopic(topic);

  @override
  Future<void> scheduleLocalReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    bool repeatsDaily = false,
  }) {
    return _local.scheduleReminder(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      payload: payload,
      repeatsDaily: repeatsDaily,
    );
  }

  @override
  Future<void> cancelLocalReminder(int id) => _local.cancel(id);

  @override
  Future<void> cancelAllLocalReminders() => _local.cancelAll();

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return; // data-only message, nothing to show

    _local.showNow(
      id: message.hashCode,
      title: notification.title ?? '',
      body: notification.body ?? '',
      payload: message.data['type'] as String?,
    );
  }

  void _handleNotificationTapFromFcm(RemoteMessage message) {
    _tapController.add(
      AppNotification.fromFcmData(
        message.data,
        title: message.notification?.title,
        body: message.notification?.body,
      ),
    );
  }

  void dispose() {
    _localTapSub?.cancel();
    _tapController.close();
  }
}