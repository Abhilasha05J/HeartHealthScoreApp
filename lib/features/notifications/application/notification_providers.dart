import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heart_health_score/features/notifications/data/repositories/firebase_notification_repository.dart';
import 'package:heart_health_score/features/notifications/domain/entities/app_notification.dart';
import 'package:heart_health_score/features/notifications/domain/repositories/notification_repository.dart';

/// Single source of truth for the notification repository, following the
/// project's rule: screens/controllers depend on the interface
/// (`NotificationRepository`), never the concrete `Firebase...` class.
///
/// There's no "mock" swap needed here the way the other features have one
/// (auth, onboarding) — Firebase Local/Cloud Messaging doesn't have a
/// meaningful mock-vs-real distinction pre-backend, since it talks to
/// Firebase directly rather than your custom backend. If you want to
/// stub it out for widget tests, create a `FakeNotificationRepository`
/// implementing the same interface and override this provider in the
/// test's ProviderScope.
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final repo = FirebaseNotificationRepository();
  ref.onDispose(() {
    if (repo is FirebaseNotificationRepository) repo.dispose();
  });
  return repo;
});

/// Current FCM token, fetched once and kept in sync with `onTokenRefresh`.
/// Watch this from wherever you send the token to the backend (e.g. right
/// after login, or from a startup controller) — confirm the endpoint with
/// the backend team.
final fcmTokenProvider = StreamProvider<String?>((ref) async* {
  final repo = ref.watch(notificationRepositoryProvider);
  yield await repo.getFcmToken();
  yield* repo.onTokenRefresh;
});

/// Emits every time a notification (remote or local) is tapped. The router
/// listens to this exactly once at app root to deep-link — see
/// integration_snippets/app_router_diff.md and main_dart_diff.md.
final notificationTapProvider = StreamProvider<AppNotification>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.onNotificationTapped;
});