// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyC-D01T8kavhNOsK5H5OR-SZYABIrBZIls',
    appId: '1:121891083314:web:a35f6351afe7d309f2d82b',
    messagingSenderId: '121891083314',
    projectId: 'gym-manager-edc5d',
    authDomain: 'gym-manager-edc5d.firebaseapp.com',
    storageBucket: 'gym-manager-edc5d.appspot.com',
    measurementId: 'G-T6BRV922JZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAIMx9CyxiNsfTGr1Mo9kXWNY7Qhn2TTmc',
    appId: '1:121891083314:android:fc78f0c280137568f2d82b',
    messagingSenderId: '121891083314',
    projectId: 'gym-manager-edc5d',
    storageBucket: 'gym-manager-edc5d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAMbshx18-WTWJyU82p6rUflKIL8BjJkoI',
    appId: '1:121891083314:ios:213239cc5b3c4897f2d82b',
    messagingSenderId: '121891083314',
    projectId: 'gym-manager-edc5d',
    storageBucket: 'gym-manager-edc5d.appspot.com',
    iosClientId: '121891083314-1tms6n3sfdjojkgu5u1i3uf66vnqfb2u.apps.googleusercontent.com',
    iosBundleId: 'com.example.gymManager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAMbshx18-WTWJyU82p6rUflKIL8BjJkoI',
    appId: '1:121891083314:ios:213239cc5b3c4897f2d82b',
    messagingSenderId: '121891083314',
    projectId: 'gym-manager-edc5d',
    storageBucket: 'gym-manager-edc5d.appspot.com',
    iosClientId: '121891083314-1tms6n3sfdjojkgu5u1i3uf66vnqfb2u.apps.googleusercontent.com',
    iosBundleId: 'com.example.gymManager',
  );
}
