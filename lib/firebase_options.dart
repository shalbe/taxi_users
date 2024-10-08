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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCrrYKynUnrO3kfHpsQd4Fvr4t5YggV8Ag',
    appId: '1:810269776309:android:95782de9f9bce75631a1fc',
    messagingSenderId: '810269776309',
    projectId: 'ojacap-58298',
    databaseURL: 'https://ojacap-58298-default-rtdb.firebaseio.com',
    storageBucket: 'ojacap-58298.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCBqKW5qRK5rsxLg5DVebywELVMVFu07F0',
    appId: '1:810269776309:ios:605c06fe892e102e31a1fc',
    messagingSenderId: '810269776309',
    projectId: 'ojacap-58298',
    databaseURL: 'https://ojacap-58298-default-rtdb.firebaseio.com',
    storageBucket: 'ojacap-58298.appspot.com',
    androidClientId: '810269776309-38q9s1phif9026gc1hifnusp9l937nmo.apps.googleusercontent.com',
    iosClientId: '810269776309-h7fm7dp6qbj2ldomt9hq6i44b8pccegi.apps.googleusercontent.com',
    iosBundleId: 'com.madinauser.openai.ios',
  );

}