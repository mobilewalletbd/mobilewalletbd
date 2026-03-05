import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/settings/presentation/providers/permission_provider.dart';

/// Permission request screen for app permissions.
///
/// Design based on V1_APP_DESIGN_PLAN specifications:
/// - Skip button at top right
/// - Illustration showing device permissions concept
/// - Permission cards with icons, titles, descriptions, and toggles
/// - Continue button at bottom
class PermissionScreen extends ConsumerStatefulWidget {
  final VoidCallback onComplete;

  const PermissionScreen({super.key, required this.onComplete});

  @override
  ConsumerState<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends ConsumerState<PermissionScreen> {
  bool _cameraEnabled = true;
  bool _contactsEnabled = true;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    // Initialize permission states from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePermissionStates();
    });
  }

  void _initializePermissionStates() {
    final permissionState = ref.read(permissionProvider);
    setState(() {
      _cameraEnabled = permissionState.cameraGranted;
      _contactsEnabled = permissionState.contactsGranted;
      _notificationsEnabled = permissionState.notificationsGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Mark first launch as completed even when skipping
                  ref
                      .read(permissionProvider.notifier)
                      .markFirstLaunchCompleted();
                  widget.onComplete();
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mediumGray,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryGreenLight.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.security_outlined,
                size: 60,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 24),
            // Message
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'We need a few permissions',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'To give you the best experience',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Permission cards
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildPermissionCard(
                    icon: Icons.camera_alt_outlined,
                    title: 'Camera',
                    description: 'For scanning business cards',
                    isEnabled: _cameraEnabled,
                    onToggle: (value) => _toggleCameraPermission(value),
                  ),
                  const SizedBox(height: 12),
                  _buildPermissionCard(
                    icon: Icons.contacts_outlined,
                    title: 'Contacts',
                    description: 'To import your contacts',
                    isEnabled: _contactsEnabled,
                    onToggle: (value) => _toggleContactsPermission(value),
                  ),
                  const SizedBox(height: 12),
                  _buildPermissionCard(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    description: 'For payment and contact updates',
                    isEnabled: _notificationsEnabled,
                    onToggle: (value) => _toggleNotificationPermission(value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Continue button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    // Mark first launch as completed
                    ref
                        .read(permissionProvider.notifier)
                        .markFirstLaunchCompleted();
                    widget.onComplete();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('CONTINUE'),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isEnabled,
    required ValueChanged<bool> onToggle,
  }) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.lightGray, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 51,
            height: 31,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Switch(
                value: isEnabled,
                onChanged: onToggle,
                activeThumbColor: AppColors.primaryGreen,
                activeTrackColor: AppColors.primaryGreenLight,
                inactiveThumbColor: AppColors.white,
                inactiveTrackColor: AppColors.lightGray,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Toggle camera permission
  Future<void> _toggleCameraPermission(bool enable) async {
    if (enable) {
      final granted = await ref
          .read(permissionProvider.notifier)
          .requestCameraPermission();
      setState(() => _cameraEnabled = granted);
    } else {
      setState(() => _cameraEnabled = false);
    }
  }

  /// Toggle contacts permission
  Future<void> _toggleContactsPermission(bool enable) async {
    if (enable) {
      final granted = await ref
          .read(permissionProvider.notifier)
          .requestContactsPermission();
      setState(() => _contactsEnabled = granted);
    } else {
      setState(() => _contactsEnabled = false);
    }
  }

  /// Toggle notification permission
  Future<void> _toggleNotificationPermission(bool enable) async {
    if (enable) {
      final granted = await ref
          .read(permissionProvider.notifier)
          .requestNotificationPermission();
      setState(() => _notificationsEnabled = granted);
    } else {
      setState(() => _notificationsEnabled = false);
    }
  }
}
