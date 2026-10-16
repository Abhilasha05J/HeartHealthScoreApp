import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app_root.dart';
import 'core/firebase/firebase_bootstrap.dart';
import 'core/network/api_config.dart';
import 'features/notifications/data/services/fcm_background_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fail fast on a missing or insecure prod URL.
  if (ApiConfig.baseUrl.isEmpty ||
      (ApiConfig.isProd && !ApiConfig.baseUrl.startsWith('https://'))) {
    throw StateError('Bad API_BASE_URL for env ${ApiConfig.env}');
  }

  await initFirebase();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
  await FirebaseCrashlytics.instance.setCustomKey('env', ApiConfig.env);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  if (kReleaseMode) {
    ErrorWidget.builder = (details) => const Material(
      child: Center(
        child: Text('Something went wrong. Please restart the app.'),
      ),
    );
  }

  runApp(const AppRoot());
}