import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBvoywlLdxqXjHtUqrVrgyWOUzq0yHPGb0',
    appId: '1:1077718515746:android:e181fb966a092b513c0a7b',
    messagingSenderId: '1077718515746',
    projectId: 'campusthriftapp',
    storageBucket: 'campusthriftapp.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBoUyQ2L96846YuoqbrLgk3Ww9zmAVKiy4',
    appId: '1:1077718515746:ios:bd6332df81857a6d3c0a7b',
    messagingSenderId: '1077718515746',
    projectId: 'campusthriftapp',
    storageBucket: 'campusthriftapp.firebasestorage.app',
    iosBundleId: 'com.example.campusthrift',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBoUyQ2L96846YuoqbrLgk3Ww9zmAVKiy4',
    appId: '1:1077718515746:ios:bd6332df81857a6d3c0a7b',
    messagingSenderId: '1077718515746',
    projectId: 'campusthriftapp',
    storageBucket: 'campusthriftapp.firebasestorage.app',
    iosBundleId: 'com.example.campusthrift',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCZ8VGCpvxLjlWjpfJ5ue05VF1NaAmQQRM',
    appId: '1:1077718515746:web:16f01dea2d5111fc3c0a7b',
    messagingSenderId: '1077718515746',
    projectId: 'campusthriftapp',
    authDomain: 'campusthriftapp.firebaseapp.com',
    storageBucket: 'campusthriftapp.firebasestorage.app',
  );
}
