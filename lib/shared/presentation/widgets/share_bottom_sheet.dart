import 'package:flutter/material.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';

/// Option for share bottom sheet
class ShareOption {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ShareOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

/// Reusable share options bottom sheet.
///
/// Used for:
/// - Share digital card
/// - Share contact
/// - Share team invite
class ShareBottomSheet extends StatelessWidget {
  final String title;
  final List<ShareOption> options;

  const ShareBottomSheet({
    super.key,
    required this.title,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.share, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Options
          ...options.map((option) => _buildOption(context, option)),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, ShareOption option) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        option.onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(option.icon, color: AppColors.primaryGreen, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                option.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.mediumGray),
          ],
        ),
      ),
    );
  }

  /// Show share options bottom sheet
  static Future<void> show(
    BuildContext context, {
    required String title,
    required List<ShareOption> options,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ShareBottomSheet(title: title, options: options),
    );
  }
}
