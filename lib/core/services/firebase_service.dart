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
        await Firebase.initializeApp();
      }
      if (kDebugMode) {
        print('✅ Firebase initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Firebase initialization failed: $e');
      }
      rethrow;
    }
  }
}
