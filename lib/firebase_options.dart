// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyC7SlpsIT4_gCDQOj_9lLqgzntf43fonLs',
    appId: '1:988582009755:web:ffad3bab08b8c7953f1f3e',
    messagingSenderId: '988582009755',
    projectId: 'musicfy-72db4',
    authDomain: 'musicfy-72db4.firebaseapp.com',
    databaseURL: 'https://musicfy-72db4-default-rtdb.firebaseio.com',
    storageBucket: 'musicfy-72db4.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCnJg3LIDmM6C5TuiYNkKkx6pjlS3SKJV4',
    appId: '1:988582009755:android:ec98c0cffe2efe4c3f1f3e',
    messagingSenderId: '988582009755',
    projectId: 'musicfy-72db4',
    databaseURL: 'https://musicfy-72db4-default-rtdb.firebaseio.com',
    storageBucket: 'musicfy-72db4.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBkbZ4tcVH60Z4yDN1PmVtHTfIIFE4xBPY',
    appId: '1:988582009755:ios:bbc3cc06c0f38e353f1f3e',
    messagingSenderId: '988582009755',
    projectId: 'musicfy-72db4',
    databaseURL: 'https://musicfy-72db4-default-rtdb.firebaseio.com',
    storageBucket: 'musicfy-72db4.firebasestorage.app',
    iosBundleId: 'com.example.trabalho1',
  );
}
