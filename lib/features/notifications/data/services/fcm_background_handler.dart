import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Handles FCM messages received while the app is fully terminated or in
/// the background.
///
/// FCM REQUIRES this to be a top-level function (not a class method, not a
/// closure) annotated with `@pragma('vm:entry-point')` so it survives Dart
/// tree-shaking and can be invoked on a separate isolate. It is registered
/// once in `main.dart` via `FirebaseMessaging.onBackgroundMessage(...)`
/// BEFORE `runApp()` — see integration_snippets/main_dart_diff.md.
///
/// Keep this function minimal. It runs on its own isolate with no access to
/// app state/providers — do NOT try to update Riverpod state or navigate
/// from here. Its only real job is any silent data processing you need
/// (e.g. local DB writes) or letting the OS show the notification tray
/// entry, which happens automatically for messages with a `notification`
/// payload.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Required if any Firebase API is touched on this isolate.
  await Firebase.initializeApp();

  // No-op by default — the OS already renders the notification tray entry
  // for messages that include a `notification` block. Add background data
  // processing here only if the backend sends data-only messages that need
  // local handling (e.g. updating a locally cached score).
}