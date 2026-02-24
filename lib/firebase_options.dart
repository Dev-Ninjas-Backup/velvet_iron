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
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ⚠️ Replace ALL placeholder values below with your actual Firebase client config.
  // Get them from: Firebase Console → Project Settings → Your Apps → SDK setup

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'velvetand-iron-training-mhr8qv',
    authDomain: 'velvetand-iron-training-mhr8qv.firebaseapp.com',
    storageBucket: 'velvetand-iron-training-mhr8qv.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'velvetand-iron-training-mhr8qv',
    storageBucket: 'velvetand-iron-training-mhr8qv.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'velvetand-iron-training-mhr8qv',
    storageBucket: 'velvetand-iron-training-mhr8qv.firebasestorage.app',
    iosBundleId: 'YOUR_IOS_BUNDLE_ID',
  );
}
