import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/settings/domain/entities/user_profile.dart';
import 'package:mobile_wallet/features/settings/presentation/providers/user_profile_provider.dart';
import 'package:mobile_wallet/features/settings/presentation/widgets/settings_section.dart';

class PrivacySettingsScreen extends ConsumerWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Settings')),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Profile not found'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildVisibilitySection(context, ref, profile),
              const SizedBox(height: 24),
              _buildImportSection(context, ref, profile),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildVisibilitySection(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
  ) {
    return SettingsSection(
      title: 'Profile Visibility',
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'Control who can see your digital card when searched or via link.',
            style: TextStyle(color: AppColors.mediumGray, fontSize: 13),
          ),
        ),
        _buildRadioTile(
          context,
          ref,
          title: 'Everyone',
          value: PrivacyLevels.public,
          groupValue: profile.cardVisibility,
          onChanged: (val) => _updateVisibility(ref, val!),
        ),
        _buildRadioTile(
          context,
          ref,
          title: 'Connections Only',
          value: PrivacyLevels.connectionsOnly,
          groupValue: profile.cardVisibility,
          onChanged: (val) => _updateVisibility(ref, val!),
        ),
        _buildRadioTile(
          context,
          ref,
          title: 'Nobody (Private)',
          value: PrivacyLevels.private,
          groupValue: profile.cardVisibility,
          onChanged: (val) => _updateVisibility(ref, val!),
        ),
      ],
    );
  }

  Widget _buildImportSection(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
  ) {
    return SettingsSection(
      title: 'Contact Import',
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'Control who can save your contact details to their list.',
            style: TextStyle(color: AppColors.mediumGray, fontSize: 13),
          ),
        ),
        _buildRadioTile(
          context,
          ref,
          title: 'Everyone',
          value: PrivacyLevels.public,
          groupValue: profile.contactImportPrivacy,
          onChanged: (val) => _updateImportPrivacy(ref, val!),
        ),
        _buildRadioTile(
          context,
          ref,
          title: 'Connections Only',
          value: PrivacyLevels.connectionsOnly,
          groupValue: profile.contactImportPrivacy,
          onChanged: (val) => _updateImportPrivacy(ref, val!),
        ),
        _buildRadioTile(
          context,
          ref,
          title: 'Nobody',
          value: PrivacyLevels.private,
          groupValue: profile.contactImportPrivacy,
          onChanged: (val) => _updateImportPrivacy(ref, val!),
        ),
      ],
    );
  }

  Widget _buildRadioTile(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    final isSelected = value == groupValue;
    return RadioListTile<String>(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? AppColors.primaryGreen : AppColors.darkGray,
        ),
      ),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: AppColors.primaryGreen,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      dense: true,
    );
  }

  Future<void> _updateVisibility(WidgetRef ref, String value) async {
    final notifier = ref.read(userProfileNotifierProvider.notifier);
    // Use the extension helper? The extension is on UserProfile entity,
    // but we need to call updatePreferences on the notifier.
    // The notifier updates the profile.
    // Let's manually construct the map for the notifier.
    await notifier.updatePreferences({'cardVisibility': value});
  }

  Future<void> _updateImportPrivacy(WidgetRef ref, String value) async {
    final notifier = ref.read(userProfileNotifierProvider.notifier);
    await notifier.updatePreferences({'contactImportPrivacy': value});
  }
}
