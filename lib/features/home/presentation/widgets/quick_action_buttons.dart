// Quick Action Buttons Widget
// Displays action buttons for main app features

import 'package:flutter/material.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';

/// Quick action buttons widget
/// Provides shortcuts to main features
class QuickActionButtons extends StatelessWidget {
  final VoidCallback? onScanCard;
  final VoidCallback? onAddManual;
  final VoidCallback? onScanQR;
  final VoidCallback? onImportContacts;

  const QuickActionButtons({
    super.key,
    this.onScanCard,
    this.onAddManual,
    this.onScanQR,
    this.onImportContacts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton(
                icon: Icons.document_scanner_outlined,
                label: 'Scan Card',
                onTap: onScanCard,
              ),
              _buildActionButton(
                icon: Icons.qr_code_scanner,
                label: 'Scan QR',
                onTap: onScanQR,
              ),
              _buildActionButton(
                icon: Icons.edit_outlined,
                label: 'Add Manual',
                onTap: onAddManual,
              ),
              _buildActionButton(
                icon: Icons.contacts_outlined,
                label: 'Import',
                onTap: onImportContacts,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build individual action button
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.offWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.lightGray, width: 1),
            ),
            child: Icon(icon, size: 28, color: AppColors.primaryGreen),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.darkGray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
