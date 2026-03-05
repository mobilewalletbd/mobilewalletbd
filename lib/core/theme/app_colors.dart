import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors
  static const Color primaryGreen = Color(0xFF0BBF7D);
  static const Color primaryGreenDark = Color(0xFF099D66);
  static const Color primaryGreenLight = Color(0xFF4DCE9F);

  // Secondary Colors
  static const Color deepBlue = Color(0xFF1A1F36);
  static const Color skyBlue = Color(0xFF4DABF7);
  static const Color warmGold = Color(0xFFFFC107);
  static const Color coralAccent = Color(0xFFFF4D4F);

  // Neutral Colors
  static const Color black = Color(0xFF1A1A2E);
  static const Color darkGray = Color(0xFF4A4A5A);
  static const Color mediumGray = Color(0xFF8E8E9A);
  static const Color lightGray = Color(0xFFE5E5E5);
  static const Color offWhite = Color(0xFFF5F5F7);
  static const Color white = Colors.white;

  // Semantic Colors
  static const Color error = coralAccent;
  static const Color success = primaryGreen;
  static const Color warning = warmGold;
  static const Color info = skyBlue;

  // Surface Colors
  static const Color background = white;
  static const Color surface =
      offWhite; // Used for inputs, cards background alt
  static const Color card = white;
  static const Color divider = lightGray;

  // Text Colors
  static const Color textPrimary = black;
  static const Color textSecondary = darkGray;
  static const Color textHint = mediumGray;
  static const Color textInverse = white;
}
