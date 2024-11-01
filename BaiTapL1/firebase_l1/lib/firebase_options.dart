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
    apiKey: 'AIzaSyCP7nI4QcbRhS_ArF-nyoQoSIDxz-kQORA',
    appId: '1:855547269468:web:857091e7edcff2e43bf199',
    messagingSenderId: '855547269468',
    projectId: 'bai-tap-thuc-tap',
    authDomain: 'bai-tap-thuc-tap.firebaseapp.com',
    storageBucket: 'bai-tap-thuc-tap.appspot.com',
    measurementId: 'G-XK4N23W0FE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJrEvAWF9fAJstEs2IrZQEDWC_Bqw3Y48',
    appId: '1:855547269468:android:7ed46ffb6eec23943bf199',
    messagingSenderId: '855547269468',
    projectId: 'bai-tap-thuc-tap',
    storageBucket: 'bai-tap-thuc-tap.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCUiAwOf1HRC6XpvR6XqvQOLzavw8x0nDs',
    appId: '1:855547269468:ios:b8239992ab4c51963bf199',
    messagingSenderId: '855547269468',
    projectId: 'bai-tap-thuc-tap',
    storageBucket: 'bai-tap-thuc-tap.appspot.com',
    iosBundleId: 'com.example.firebaseL1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCUiAwOf1HRC6XpvR6XqvQOLzavw8x0nDs',
    appId: '1:855547269468:ios:b8239992ab4c51963bf199',
    messagingSenderId: '855547269468',
    projectId: 'bai-tap-thuc-tap',
    storageBucket: 'bai-tap-thuc-tap.appspot.com',
    iosBundleId: 'com.example.firebaseL1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCP7nI4QcbRhS_ArF-nyoQoSIDxz-kQORA',
    appId: '1:855547269468:web:b3d5b30700256ba53bf199',
    messagingSenderId: '855547269468',
    projectId: 'bai-tap-thuc-tap',
    authDomain: 'bai-tap-thuc-tap.firebaseapp.com',
    storageBucket: 'bai-tap-thuc-tap.appspot.com',
    measurementId: 'G-DKCFBLBTGV',
  );
}
