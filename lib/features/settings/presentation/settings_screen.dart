import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile_wallet/features/settings/presentation/providers/user_profile_provider.dart';
import 'package:mobile_wallet/features/settings/presentation/widgets/settings_section.dart';
import 'package:mobile_wallet/features/settings/presentation/widgets/settings_tile.dart';
import 'package:mobile_wallet/features/contacts/presentation/providers/contact_provider.dart';
import 'package:mobile_wallet/features/collaboration/presentation/providers/team_provider.dart';
import 'package:mobile_wallet/features/settings/services/export_service.dart';
import 'package:mobile_wallet/features/settings/data/repositories/backup_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileNotifierProvider);
    final userProfile = userProfileAsync.valueOrNull;
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: userProfileAsync.when(
        data: (profile) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile Header
            _buildProfileHeader(context, profile, currentUser),
            const SizedBox(height: 24),

            // Digital Card Section
            SettingsSection(
              title: 'Digital Card',
              children: [
                SettingsTile(
                  icon: Icons.badge_outlined,
                  title: 'My Digital Card',
                  subtitle: 'View and edit your digital business card',
                  onTap: () => context.push('/settings/digital-card'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Data Management
            SettingsSection(
              title: 'Data Management',
              children: [
                SettingsTile(
                  icon: Icons.analytics_outlined,
                  title: 'Analytics & Usage',
                  subtitle: 'View your networking stats',
                  onTap: () => context.pushNamed('analyticsDashboard'),
                ),
                SettingsTile(
                  icon: Icons.download_rounded,
                  title: 'Export Contacts',
                  subtitle: 'Save as CSV or VCF',
                  onTap: () => _showExportDialog(context, ref),
                ),
                SettingsTile(
                  icon: Icons.cloud_upload_outlined,
                  title: 'Google Drive Backup',
                  subtitle: 'Backup your contacts to Google Drive',
                  onTap: () => _showBackupDialog(context, ref),
                ),
                SettingsTile(
                  icon: Icons.cloud_download_outlined,
                  title: 'Restore from Google Drive',
                  subtitle: 'Import contacts from a previous backup',
                  onTap: () => _showRestoreDialog(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Account Settings
            SettingsSection(
              title: 'Account',
              children: [
                SettingsTile(
                  icon: Icons.person_outline,
                  title: 'Personal Information',
                  subtitle: 'Name, Bio, Job Title',
                  onTap: () => context.push('/settings/edit-profile'),
                ),
                SettingsTile(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  subtitle: currentUser?.email ?? 'Not set',
                  onTap: () => context.push('/settings/account'),
                ),
                SettingsTile(
                  icon: Icons.phone_outlined,
                  title: 'Phone Number',
                  subtitle: currentUser?.phoneNumber ?? 'Not set',
                  onTap: () => context.push('/settings/account'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Security Section
            SettingsSection(
              title: 'Security',
              children: [
                SettingsTile(
                  icon: Icons.security,
                  title: 'Security Settings',
                  subtitle: 'PIN, biometric, password',
                  onTap: () => context.push('/settings/security'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Collaboration
            SettingsSection(
              title: 'Collaboration',
              children: [
                SettingsTile(
                  icon: Icons.group_outlined,
                  title: 'My Teams',
                  subtitle: ref
                      .watch(userTeamsProvider)
                      .when(
                        data: (teams) =>
                            '${teams.length} team${teams.length == 1 ? '' : 's'}',
                        loading: () => 'Loading teams...',
                        error: (_, __) => 'Manage teams and members',
                      ),
                  onTap: () => context.push('/settings/teams'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // App Preferences
            SettingsSection(
              title: 'Preferences',
              children: [
                SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Dark Mode coming soon')),
                      );
                    },
                    activeThumbColor: AppColors.primaryGreen,
                  ),
                ),
                SettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  trailing: Switch(
                    value: profile?.notificationsEnabled ?? true,
                    onChanged: (value) {
                      ref
                          .read(userProfileNotifierProvider.notifier)
                          .updatePreferences({'notificationsEnabled': value});
                    },
                    activeThumbColor: AppColors.primaryGreen,
                  ),
                ),
                SettingsTile(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: profile?.preferredLanguage == 'bn'
                      ? 'Bangla'
                      : 'English',
                  onTap: () => _showLanguageDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Legal & Support
            SettingsSection(
              title: 'Support',
              children: [
                SettingsTile(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () => _showHelpDialog(context),
                ),
                SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () => _showPrivacyPolicyDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(authenticationProvider.notifier).signOut();
                  if (context.mounted) {
                    context.go('/auth'); // Redirect to auth screen
                  }
                },
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: const Text(
                  'Log Out',
                  style: TextStyle(color: AppColors.error),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Version Info
            const Center(
              child: Text(
                'Version 1.0.0 (Build 1)',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _showExportDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Export Format'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _exportContacts(context, ref, ExportFormat.csv);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('CSV (Excel)'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _exportContacts(context, ref, ExportFormat.vcf);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('vCard (Contacts)'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportContacts(
    BuildContext context,
    WidgetRef ref,
    ExportFormat format,
  ) async {
    try {
      final contacts = await ref.read(contactsNotifierProvider.future);
      if (context.mounted) {
        await ExportService().exportContacts(contacts, format);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showBackupDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Google Drive Backup'),
        content: const Text(
          'This will backup all your contacts to your Google Drive account. '
          'You may be asked for permission if this is your first time.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              _performBackup(context, ref);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Backup Now'),
          ),
        ],
      ),
    );
  }

  Future<void> _performBackup(BuildContext context, WidgetRef ref) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.primaryGreen),
            SizedBox(height: 16),
            Text(
              'Backing up to Drive...',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    try {
      final success = await ref.read(backupRepositoryProvider).performBackup();
      if (context.mounted) {
        Navigator.pop(context); // Remove loading indicator

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Backup successful!'
                  : 'Backup failed. Please check your connection or permissions.',
            ),
            backgroundColor: success ? AppColors.primaryGreen : AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Remove loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showRestoreDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore from Google Drive'),
        content: FutureBuilder<List<Map<String, dynamic>>>(
          future: ref.read(backupRepositoryProvider).getAvailableBackups(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryGreen,
                  ),
                ),
              );
            }
            if (snapshot.hasError) {
              return Text('Error loading backups: ${snapshot.error}');
            }
            final backups = snapshot.data ?? [];
            if (backups.isEmpty) {
              return const Text('No backups found in Google Drive.');
            }

            return SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: backups.length,
                itemBuilder: (context, index) {
                  final backup = backups[index];
                  final date = backup['date'] as DateTime?;
                  final dateStr = date != null
                      ? '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}'
                      : 'Unknown date';
                  return ListTile(
                    title: Text(backup['name'] ?? 'Backup'),
                    subtitle: Text('Date: $dateStr'),
                    onTap: () {
                      Navigator.pop(context);
                      _confirmRestore(
                        context,
                        ref,
                        backup['id'] as String,
                        backup['name'] as String?,
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _confirmRestore(
    BuildContext context,
    WidgetRef ref,
    String fileId,
    String? fileName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Restore'),
        content: Text(
          'Are you sure you want to restore contacts from "$fileName"? '
          'This will merge the backed-up contacts with your current ones.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performRestore(context, ref, fileId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }

  Future<void> _performRestore(
    BuildContext context,
    WidgetRef ref,
    String fileId,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.primaryGreen),
            SizedBox(height: 16),
            Text(
              'Restoring from Drive...',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    try {
      final count = await ref
          .read(backupRepositoryProvider)
          .restoreFromBackup(fileId);
      if (context.mounted) {
        Navigator.pop(context); // Remove loading indicator

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              count > 0
                  ? 'Successfully restored $count contacts!'
                  : 'Restore failed or no contacts found.',
            ),
            backgroundColor: count > 0
                ? AppColors.primaryGreen
                : AppColors.error,
          ),
        );

        // Refresh contacts list if restore was successful
        if (count > 0) {
          // This will cause the provider to refresh
          ref.invalidate(contactsNotifierProvider);
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Remove loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Language'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Language set to English')),
              );
            },
            child: const Row(
              children: [
                Icon(Icons.check, color: AppColors.primaryGreen, size: 20),
                SizedBox(width: 8),
                Text('English'),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Language set to Bangla')),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 28),
              child: Text('Bangla'),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need assistance? Contact our support team.'),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.email, size: 20, color: AppColors.textSecondary),
                SizedBox(width: 8),
                Text('support@mobilewallet.bd'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, size: 20, color: AppColors.textSecondary),
                SizedBox(width: 8),
                Text('+880 1234 567890'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'At Smart Contact Wallet, we take your privacy seriously. '
            'We collect and use your personal information only to provide '
            'and improve our services. We do not share your data with '
            'third parties without your consent, except as required by law.\n\n'
            'For full details, please visit our website.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    dynamic profile,
    dynamic user,
  ) {
    ImageProvider? imageProvider;
    if (profile?.avatarUrl != null && profile!.avatarUrl!.isNotEmpty) {
      imageProvider = NetworkImage(profile.avatarUrl!);
    }

    final initials = profile?.initials ?? 'U';
    final displayName = profile?.displayName ?? user?.displayName ?? 'User';
    final email = user?.email ?? 'No email';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
                backgroundImage: imageProvider,
                child: imageProvider == null
                    ? Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            displayName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          if (profile?.jobTitle != null || profile?.companyName != null) ...[
            const SizedBox(height: 8),
            Text(
              [
                profile?.jobTitle,
                profile?.companyName,
              ].where((e) => e != null && e.isNotEmpty).join(' at '),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
