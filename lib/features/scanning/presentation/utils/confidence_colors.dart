// Confidence Color Helper
// Provides color-coded visual feedback based on OCR field confidence

import 'package:flutter/material.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';

class ConfidenceColors {
  /// Get border color based on confidence score
  static Color getBorderColor(double confidence) {
    if (confidence >= 0.8) {
      return AppColors.primaryGreen; // High confidence
    } else if (confidence >= 0.6) {
      return Colors.amber.shade600; // Medium confidence
    } else {
      return Colors.red.shade400; // Low confidence
    }
  }

  /// Get background color (subtle) based on confidence score
  static Color getBackgroundColor(double confidence) {
    if (confidence >= 0.8) {
      return AppColors.primaryGreen.withValues(alpha: 0.05);
    } else if (confidence >= 0.6) {
      return Colors.amber.withValues(alpha: 0.05);
    } else {
      return Colors.red.withValues(alpha: 0.05);
    }
  }

  /// Get icon color based on confidence score
  static Color getIconColor(double confidence) {
    if (confidence >= 0.8) {
      return AppColors.primaryGreen;
    } else if (confidence >= 0.6) {
      return Colors.amber.shade700;
    } else {
      return Colors.red.shade600;
    }
  }

  /// Get confidence label
  static String getLabel(double confidence) {
    if (confidence >= 0.8) {
      return 'High Confidence';
    } else if (confidence >= 0.6) {
      return 'Medium Confidence';
    } else {
      return 'Low Confidence - Review';
    }
  }

  /// Get confidence icon
  static IconData getIcon(double confidence) {
    if (confidence >= 0.8) {
      return Icons.check_circle;
    } else if (confidence >= 0.6) {
      return Icons.warning_amber_rounded;
    } else {
      return Icons.error_outline;
    }
  }
}
