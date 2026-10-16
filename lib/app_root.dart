import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

/// Owns the root [ProviderScope]. Changing its key disposes EVERY provider
/// (auth user, dashboard, wearable, water, nutrition, ...) and rebuilds the
/// app from Splash — used on logout so the next account on this device can
/// never see the previous account's in-memory data.
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  /// Wipes all provider state and restarts the app at Splash. Call after the
  /// auth repository's logout() has cleared the stored tokens.
  static void restart(BuildContext context) {
    context.findAncestorStateOfType<_AppRootState>()?._restart();
  }

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  Key _scopeKey = UniqueKey();

  void _restart() => setState(() => _scopeKey = UniqueKey());

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      key: _scopeKey,
      child: const HeartHealthScoreApp(),
    );
  }
}