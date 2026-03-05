import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile_wallet/core/theme/app_colors.dart';

/// Add Contact - Choose Method Screen
///
/// Design based on V1_APP_DESIGN_PLAN specifications:
/// - Back button and title centered
/// - Prompt: "How would you like to add a contact?"
/// - Three method cards: Scan Card, Manual Entry, Import from Phone
class AddContactMethodScreen extends StatelessWidget {
  const AddContactMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Add Contact',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              // Prompt
              const Text(
                'How would you like to add a contact?',
                style: TextStyle(fontSize: 16, color: AppColors.darkGray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Method Cards
              Expanded(
                child: ListView(
                  children: [
                    _buildMethodCard(
                      icon: Icons.document_scanner_outlined,
                      title: 'Scan Card',
                      description: 'Quick scan using camera',
                      onTap: () => context.push('/contacts/scan'),
                    ),
                    const SizedBox(height: 16),
                    _buildMethodCard(
                      icon: Icons.edit_outlined,
                      title: 'Manual Entry',
                      description: 'Enter details manually',
                      onTap: () => context.push('/contacts/add'),
                    ),
                    const SizedBox(height: 16),
                    _buildMethodCard(
                      icon: Icons.contacts_outlined,
                      title: 'Import from Phone',
                      description: 'Import existing contacts',
                      onTap: () => context.push('/contacts/import'),
                    ),
                    const SizedBox(height: 16),
                    _buildMethodCard(
                      icon: Icons.file_upload_outlined,
                      title: 'Import from File',
                      description: 'Import CSV or vCard files',
                      onTap: () => context.push('/contacts/import-file'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.lightGray, width: 1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primaryGreen, size: 24),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.darkGray,
                    ),
                  ),
                ],
              ),
            ),
            // Chevron
            Icon(Icons.chevron_right, color: AppColors.mediumGray, size: 24),
          ],
        ),
      ),
    );
  }
}
