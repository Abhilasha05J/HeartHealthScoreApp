import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heart_health_score/features/assessment/presentation/assessment_screen.dart';
import 'package:heart_health_score/features/notifications/domain/entities/app_notification.dart';
import 'package:heart_health_score/features/notifications/domain/entities/notification_type.dart';
import 'package:heart_health_score/features/onboarding/presentation/widgets/basic_vitals_screen.dart';
import 'package:heart_health_score/features/onboarding/presentation/widgets/daily_activity_screen.dart';
import 'package:heart_health_score/features/onboarding/presentation/widgets/profile_setup_screen.dart';
import 'package:heart_health_score/features/plans/presentation/plans_screen.dart';
import 'package:heart_health_score/features/profile/presentation/profile_screen.dart';
import 'package:heart_health_score/features/water_intake_data/presentation/water_intake_screen.dart';
import 'package:heart_health_score/features/workout/presentation/workout_detail_screen.dart';

import 'package:heart_health_score/features/nutrition/presentation/nutrition_screen.dart';
import 'package:heart_health_score/features/splash/presentation/splash_screen.dart';
import 'package:heart_health_score/features/auth/presentation/auth_screen.dart';
import 'package:heart_health_score/features/dashboard/presentation/home_shell.dart';
import 'package:heart_health_score/features/dashboard/presentation/home_dashboard_screen.dart';
import 'package:heart_health_score/features/dashboard/presentation/placeholder_tab_screen.dart';
import 'package:heart_health_score/features/wearable/presentation/connect_wearable_screen.dart';

import '../../features/assessment/presentation/reports_history_screen.dart';

abstract class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const auth = '/auth';
  static const profileSetup = '/onboarding/profile';
  static const dailyActivity = '/onboarding/activity';
  static const basicVitals = '/onboarding/vitals';
  static const home = '/home';
  static const reminder = '/reminder';
  static const profile = '/profile';
  static const plans = '/plans';
  static const parameters = '/parameters';
  static const connectWearable = '/connect-wearable';

  // Nested UNDER /home (note: no leading slash on the child path below)
  // so it renders inside the persistent shell (bottom nav + FAB) instead
  // of covering it the way a top-level route would. This is what makes
  // "all screens keep the bottom nav" actually work — see the
  // StatefulShellRoute setup below.
  static const waterIntake = '/home/water-intake';
  static const workoutDetail = '/home/workout';
  static const mealTracker = '/home/log-meal';

  static const reportsHistory = '/parameters/reports-history';
}

/// Root navigator — used for screens that should NOT show the persistent
/// bottom-nav shell (Splash, Auth, Onboarding). StatefulShellRoute needs
/// its own separate navigator key internally; this one is for everything
/// outside the shell.
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
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
        path: AppRoutes.connectWearable,
        builder: (context, state) => const ConnectWearableScreen(),
      ),

      // --------------------------------------------------------------
      // Persistent shell: every route nested inside a branch here keeps
      // the bottom nav bar + expandable "+" FAB visible (rendered once,
      // in HomeShell), while each branch still has its own independent
      // navigation stack — e.g. pushing Water Intake under the Home
      // branch still lets its back button/gesture pop correctly without
      // affecting the Reminder/Plans/Setting branches' stacks.
      // --------------------------------------------------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeDashboardScreen(),
                routes: [
                  GoRoute(
                    // Full path resolves to AppRoutes.waterIntake ("/home/water-intake")
                    path: 'water-intake',
                    builder: (context, state) => const WaterIntakeScreen(),
                  ),
                  GoRoute(
                    // Full path resolves to AppRoutes.workoutDetail ("/home/workout").
                    // Push this from wherever the workout card/CTA lives on
                    // HomeDashboardScreen — WorkoutDetailScreen brings its own
                    // AppBar + back button (see workout_detail_screen.dart).
                    path: 'workout',
                    builder: (context, state) => const WorkoutDetailScreen(),
                  ),
                  GoRoute(
                    // Full path resolves to AppRoutes.mealTracker ("/home/log-meal").
                    // Wire ExpandableLogFab's "Log meal" action to
                    // context.push(AppRoutes.mealTracker).
                    path: 'log-meal',
                    builder: (context, state) => const NutritionScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.reminder,
                builder: (context, state) => const PlaceholderTabScreen(
                  title: 'Reminder',
                  path: 'assets/icons/reminder.png',
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.plans,
                builder: (context, state) => const PlansScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.parameters,
                builder: (context, state) => const AssessmentScreen(),
                routes: [
                  GoRoute(
                    // Full path resolves to AppRoutes.reportsHistory
                    // ("/parameters/reports-history").
                    path: 'reports-history',
                    builder: (context, state) => const ReportsHistoryScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

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