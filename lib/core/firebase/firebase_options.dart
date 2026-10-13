
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA9pecAwlxrlBSqbpCZfdZpcZQHRzddNE4',
    appId: '1:35373750516:web:9f1461d40644e081faa6a1',
    messagingSenderId: '35373750516',
    projectId: 'hearthealthscore',
    authDomain: 'hearthealthscore.firebaseapp.com',
    storageBucket: 'hearthealthscore.firebasestorage.app',
    measurementId: 'G-BKS4REH3DD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDvQ7g4toahOKjfFSvmXTb9w4j0KbA8iPE',
    appId: '1:35373750516:android:170599bf1174c836faa6a1',
    messagingSenderId: '35373750516',
    projectId: 'hearthealthscore',
    storageBucket: 'hearthealthscore.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAejXedKWSKebYSGr_F3rgS3jc9fdWUCaI',
    appId: '1:35373750516:ios:2bc61f7e63790543faa6a1',
    messagingSenderId: '35373750516',
    projectId: 'hearthealthscore',
    storageBucket: 'hearthealthscore.firebasestorage.app',
    iosBundleId: 'com.hearthealthscore.heartHealthScore',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAejXedKWSKebYSGr_F3rgS3jc9fdWUCaI',
    appId: '1:35373750516:ios:2bc61f7e63790543faa6a1',
    messagingSenderId: '35373750516',
    projectId: 'hearthealthscore',
    storageBucket: 'hearthealthscore.firebasestorage.app',
    iosBundleId: 'com.hearthealthscore.heartHealthScore',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA9pecAwlxrlBSqbpCZfdZpcZQHRzddNE4',
    appId: '1:35373750516:web:7752bd1f4603e804faa6a1',
    messagingSenderId: '35373750516',
    projectId: 'hearthealthscore',
    authDomain: 'hearthealthscore.firebaseapp.com',
    storageBucket: 'hearthealthscore.firebasestorage.app',
    measurementId: 'G-WJ1L9ENXBB',
  );
}
