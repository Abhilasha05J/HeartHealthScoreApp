import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/notifications/application/notification_providers.dart';

class HeartHealthScoreApp extends ConsumerStatefulWidget {
  const HeartHealthScoreApp({super.key});

  @override
  ConsumerState<HeartHealthScoreApp> createState() => _HeartHealthScoreAppState();
}

class _HeartHealthScoreAppState extends ConsumerState<HeartHealthScoreApp> {
  @override
  void initState() {
    super.initState();
    // Fire-and-forget: initialize() sets up FCM + local notification
    // listeners. Safe to call before the widget tree settles since it only
    // touches plugin channels, not app state.
    Future.microtask(
          () => ref.read(notificationRepositoryProvider).initialize(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    // Listen (not watch) so a tap doesn't rebuild the whole app — it just
    // triggers navigation as a side effect.
    ref.listen(notificationTapProvider, (previous, next) {
      next.whenData((notification) {
        // Was `appRouter` — that name isn't defined anywhere in this file.
        // `router`, from `appRouterProvider` above, is the actual GoRouter
        // instance this widget already has in scope.
        NotificationRouting.handleTap(notification, router);
      });
    });

    return MaterialApp.router(
      title: 'Heart Health Score',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}