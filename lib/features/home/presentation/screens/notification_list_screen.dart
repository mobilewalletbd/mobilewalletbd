import 'package:flutter/material.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';

class NotificationListScreen extends StatelessWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.black),
      ),
      backgroundColor: AppColors.offWhite,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.lightGray.withValues(alpha: 0.5)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.primaryGreen,
                  size: 24,
                ),
              ),
              title: Text(
                'Notification Title ${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: const Text(
                  'This is a sample notification message used for demonstration purposes.',
                  style: TextStyle(color: AppColors.mediumGray),
                ),
              ),
              trailing: Text(
                '2h ago',
                style: TextStyle(color: AppColors.mediumGray, fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}
