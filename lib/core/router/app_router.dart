import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/notifications/domain/entities/app_notification.dart';
import '../../features/notifications/domain/entities/notification_type.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/auth/presentation/auth_screen.dart';
import '../../features/onboarding/presentation/profile_setup_screen.dart';
import '../../features/onboarding/presentation/daily_activity_screen.dart';
import '../../features/onboarding/presentation/basic_vitals_screen.dart';
import '../../features/home/presentation/home_screen.dart';

abstract class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const auth = '/auth';
  static const profileSetup = '/onboarding/profile';
  static const dailyActivity = '/onboarding/activity';
  static const basicVitals = '/onboarding/vitals';
  static const home = '/home';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileSetup,
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.dailyActivity,
        builder: (context, state) => const DailyActivityScreen(),
      ),
      GoRoute(
        path: AppRoutes.basicVitals,
        builder: (context, state) => const BasicVitalsScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});

/// Maps a tapped notification to a concrete navigation action.
///
/// This is intentionally kept separate from `NotificationType` (in the
/// notifications feature's domain layer) — the domain layer shouldn't know
/// about routes/GoRouter, so the mapping lives here in the router instead.
class NotificationRouting {
  NotificationRouting._();

  static void handleTap(AppNotification notification, GoRouter router) {
    switch (notification.type) {
      case NotificationType.scoreReady:
      // Score is presumably already fetched fresh on Home; if Home caches
      // the last score, consider passing `extra: notification.data` so
      // Home knows to force-refresh instead of showing a stale cached one.
        router.go(AppRoutes.home);
        break;

      case NotificationType.dailyReminder:
      // Adjust this once Home's real dashboard exists — e.g. it might
      // deep-link straight into a "log today" flow rather than Home.
        router.go(AppRoutes.home);
        break;

      case NotificationType.vitalsReminder:
        router.go(AppRoutes.home);
        break;

      case NotificationType.general:
        router.go(AppRoutes.home);
        break;
    }
  }
}