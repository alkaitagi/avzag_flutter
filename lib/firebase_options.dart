// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDZdch_YswpGoWogf7nN5nKs_hN1NJQMLE',
    appId: '1:882503981771:web:399cd0dce03fb54326994e',
    messagingSenderId: '882503981771',
    projectId: 'avzagapp',
    authDomain: 'avzagapp.firebaseapp.com',
    storageBucket: 'avzagapp.appspot.com',
    measurementId: 'G-YVNQDHDF94',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyClObYBjzRfHXQ6CBVkOJlx-v1x0oNIHd8',
    appId: '1:882503981771:android:a81c9f3fdf9537e426994e',
    messagingSenderId: '882503981771',
    projectId: 'avzagapp',
    storageBucket: 'avzagapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAcPrngkspxNZhO5SQeZQYfu2Ul7qdGFz4',
    appId: '1:882503981771:ios:c23cbbab13c953ad26994e',
    messagingSenderId: '882503981771',
    projectId: 'avzagapp',
    storageBucket: 'avzagapp.appspot.com',
    androidClientId:
        '882503981771-3p0m53d8evsh2jmgoce6r9tb0qqomlnt.apps.googleusercontent.com',
    iosClientId:
        '882503981771-nnnd93giupoogi7qiqpn039bq1kca0ap.apps.googleusercontent.com',
    iosBundleId: 'com.alkaitagi.avzag',
  );
}
