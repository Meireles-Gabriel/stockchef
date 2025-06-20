import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBhv-f0PkltNxFDwWjl-Dy89eh8SvyaAvc',
    appId: '1:304542064690:web:f78bcaae02243ba4e45c2b',
    messagingSenderId: '304542064690',
    projectId: 'stockchef-e08d4',
    authDomain: 'stockchef-e08d4.firebaseapp.com',
    storageBucket: 'stockchef-e08d4.appspot.com',
    measurementId: 'G-TK7KZHNYHY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAugcYpc4X4nVmV2BLtG1FklTcaabKVLg4',
    appId: '1:304542064690:android:b711f3ce74981a9ce45c2b',
    messagingSenderId: '304542064690',
    projectId: 'stockchef-e08d4',
    storageBucket: 'stockchef-e08d4.appspot.com',
  );
}
