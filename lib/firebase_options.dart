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
    apiKey: 'AIzaSyCz22UHSeOXoKQJVmRUQACJZEoh_guEP-w',
    appId: '1:811975379858:web:4d7a818a2ee24984c3cf4b',
    messagingSenderId: '811975379858',
    projectId: 'clacostore-7303d',
    authDomain: 'clacostore-7303d.firebaseapp.com',
    storageBucket: 'clacostore-7303d.appspot.com',
    measurementId: 'G-TK8PFFV7VW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC1Td07Kuv52jJoo9QsHDnhh9M8RSygPEA',
    appId: '1:811975379858:android:ccb793a514ab3e5cc3cf4b',
    messagingSenderId: '811975379858',
    projectId: 'clacostore-7303d',
    storageBucket: 'clacostore-7303d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBSK-lsgcy743f43jZYLRpAneww2eFeNYQ',
    appId: '1:811975379858:ios:843f0bfe56dd0c2fc3cf4b',
    messagingSenderId: '811975379858',
    projectId: 'clacostore-7303d',
    storageBucket: 'clacostore-7303d.appspot.com',
    iosBundleId: 'com.claco.store.clacoStore',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBSK-lsgcy743f43jZYLRpAneww2eFeNYQ',
    appId: '1:811975379858:ios:843f0bfe56dd0c2fc3cf4b',
    messagingSenderId: '811975379858',
    projectId: 'clacostore-7303d',
    storageBucket: 'clacostore-7303d.appspot.com',
    iosBundleId: 'com.claco.store.clacoStore',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCz22UHSeOXoKQJVmRUQACJZEoh_guEP-w',
    appId: '1:811975379858:web:d375bdcfdef4ae5dc3cf4b',
    messagingSenderId: '811975379858',
    projectId: 'clacostore-7303d',
    authDomain: 'clacostore-7303d.firebaseapp.com',
    storageBucket: 'clacostore-7303d.appspot.com',
    measurementId: 'G-GX62291S1H',
  );
}