import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static Future<void> initialize() async {
    try {
      if (kIsWeb) {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyCihVZ48CE5LfpkcSHpfdOpjzWglbb6Dy4",
            authDomain: "smartwallet-c97fe.firebaseapp.com",
            projectId: "smartwallet-c97fe",
            storageBucket: "smartwallet-c97fe.firebasestorage.app",
            messagingSenderId: "343204336259",
            appId: "1:343204336259:web:a67797d05d44ab2e4041b6",
            measurementId: "G-KJSJTPTSEM",
          ),
        );
      } else {
        // Add timeout for mobile platforms to prevent hanging
        await Future.any([
          Firebase.initializeApp(),
          Future.delayed(
            const Duration(seconds: 30),
            () => throw TimeoutException('Firebase initialization timed out'),
          ),
        ]);
      }

      try {
        await FirebaseAppCheck.instance.activate(
          androidProvider: kReleaseMode
              ? AndroidProvider.playIntegrity
              : AndroidProvider.debug,
          appleProvider: kReleaseMode
              ? AppleProvider.appAttest
              : AppleProvider.debug,
        );
        if (kDebugMode) {
          print('✅ Firebase App Check initialized successfully');
        }
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Firebase App Check initialization failed: $e');
        }
      }

      if (kDebugMode) {
        print('✅ Firebase initialized successfully');
      }
    } on TimeoutException catch (e) {
      if (kDebugMode) {
        print('⚠️ Firebase initialization timed out: ${e.message}');
        print('⚠️ App will continue in offline mode');
      }
      // Continue without Firebase - app will work in offline mode
    } catch (e) {
      if (kDebugMode) {
        print('❌ Firebase initialization failed: $e');
        print('⚠️ App will continue in offline mode');
      }
      // Don't rethrow - allow app to continue in offline mode
    }
  }
}
