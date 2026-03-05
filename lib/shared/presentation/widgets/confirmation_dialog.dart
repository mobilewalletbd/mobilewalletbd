import 'package:flutter/material.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';

/// Reusable confirmation dialog for destructive or important actions.
///
/// Used for:
/// - Delete contact
/// - Delete team
/// - Leave team
/// - Clear data
/// - Any action requiring user confirmation
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final bool isDangerous;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    required this.onConfirm,
    this.isDangerous = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      content: Text(
        message,
        style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            cancelText,
            style: const TextStyle(color: AppColors.darkGray, fontSize: 16),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDangerous
                ? AppColors.error
                : AppColors.primaryGreen,
            foregroundColor: AppColors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            confirmText,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  /// Show confirmation dialog
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    required VoidCallback onConfirm,
    bool isDangerous = false,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        isDangerous: isDangerous,
      ),
    );
  }
}
