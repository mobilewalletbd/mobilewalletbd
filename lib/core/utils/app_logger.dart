// App Logger for Smart Contact Wallet V1
// Centralized logging utility following project standards

import 'package:flutter/foundation.dart';

/// Centralized logging utility that respects kDebugMode
class AppLogger {
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag]' : '';
      // ignore: avoid_print
      print('🟢 DEBUG $tagStr: $message');
    }
  }

  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag]' : '';
      // ignore: avoid_print
      print('🔵 INFO $tagStr: $message');
    }
  }

  static void error(String message, {String? tag, dynamic error}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag]' : '';
      // ignore: avoid_print
      print('🔴 ERROR $tagStr: $message');
      if (error != null) {
        // ignore: avoid_print
        print('Error details: $error');
      }
    }
  }

  static void warn(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag]' : '';
      // ignore: avoid_print
      print('🟡 WARN $tagStr: $message');
    }
  }
}
