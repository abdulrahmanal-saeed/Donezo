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
    apiKey: 'AIzaSyAhJKqwhTDDMx0T8b4Jfe7ZjTBXIWiQ1G4',
    appId: '1:898107872958:web:37e3e00275068d001330ef',
    messagingSenderId: '898107872958',
    projectId: 'notabox-81f84',
    authDomain: 'notabox-81f84.firebaseapp.com',
    storageBucket: 'notabox-81f84.firebasestorage.app',
    measurementId: 'G-E8JF7TGRF7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD8dvK0-P44I50AgDDTxfu--AkfO22GX2w',
    appId: '1:898107872958:android:5f027a052dd482e11330ef',
    messagingSenderId: '898107872958',
    projectId: 'notabox-81f84',
    storageBucket: 'notabox-81f84.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB4GO8CrYSVnwLhAdTaLNgmF8r8GfkzD5M',
    appId: '1:898107872958:ios:bffaeea3072555771330ef',
    messagingSenderId: '898107872958',
    projectId: 'notabox-81f84',
    storageBucket: 'notabox-81f84.firebasestorage.app',
    iosBundleId: 'com.o.notabox',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB4GO8CrYSVnwLhAdTaLNgmF8r8GfkzD5M',
    appId: '1:898107872958:ios:b1cc1c667ab908561330ef',
    messagingSenderId: '898107872958',
    projectId: 'notabox-81f84',
    storageBucket: 'notabox-81f84.firebasestorage.app',
    iosBundleId: 'com.example.notabox',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAhJKqwhTDDMx0T8b4Jfe7ZjTBXIWiQ1G4',
    appId: '1:898107872958:web:db94c9e09b2b17fe1330ef',
    messagingSenderId: '898107872958',
    projectId: 'notabox-81f84',
    authDomain: 'notabox-81f84.firebaseapp.com',
    storageBucket: 'notabox-81f84.firebasestorage.app',
    measurementId: 'G-TY8M93P7R2',
  );
}