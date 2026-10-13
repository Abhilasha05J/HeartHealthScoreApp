import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

/// Android reads the per-flavor google-services.json natively, so options are
/// passed only on other platforms.
Future<void> initFirebase() => Firebase.initializeApp(
  options: defaultTargetPlatform == TargetPlatform.android
      ? null
      : DefaultFirebaseOptions.currentPlatform,
);