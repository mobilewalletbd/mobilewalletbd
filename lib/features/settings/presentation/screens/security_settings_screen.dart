import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/settings/presentation/providers/user_profile_provider.dart';
import 'package:mobile_wallet/features/settings/presentation/widgets/settings_section.dart';
import 'package:mobile_wallet/features/settings/presentation/widgets/settings_tile.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';

class SecuritySettingsScreen extends ConsumerStatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  ConsumerState<SecuritySettingsScreen> createState() =>
      _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState
    extends ConsumerState<SecuritySettingsScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isBiometricAvailable = false;
  bool _isLoading = true;
  String _deviceModel = 'Unknown Device';
  String _osVersion = '';
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _loadSessionInfo();
  }

  Future<void> _loadSessionInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();

    String model = 'Unknown';
    String os = '';

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        model = '${androidInfo.manufacturer} ${androidInfo.model}';
        os = 'Android ${androidInfo.version.release}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        model = iosInfo.name;
        os = '${iosInfo.systemName} ${iosInfo.systemVersion}';
      }
    } catch (e) {
      debugPrint('Error loading device info: $e');
    }

    if (mounted) {
      setState(() {
        _deviceModel = model;
        _osVersion = os;
        _appVersion = packageInfo.version;
      });
    }
  }

  Future<void> _checkBiometricAvailability() async {
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      debugPrint('Error checking biometrics: $e');
    }

    if (!mounted) return;

    setState(() {
      _isBiometricAvailable = canCheckBiometrics;
      _isLoading = false;
    });
  }

  Future<void> _toggleBiometrics(bool value) async {
    if (value) {
      // Trying to enable biometrics - verify first
      bool authenticated = false;
      try {
        authenticated = await auth.authenticate(
          localizedReason: 'Authenticate to enable biometric login',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
      } on PlatformException catch (e) {
        debugPrint('Error authenticating: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication failed: ${e.message}')),
          );
        }
        return;
      }

      if (!authenticated) return;
    }

    // Update preference
    await ref.read(userProfileNotifierProvider.notifier).updatePreferences({
      'biometricsEnabled': value,
    });
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text(
          'Are you sure you want to sign out of this device?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authenticationProvider.notifier).signOut();
      // Router will handle redirect
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileNotifierProvider).valueOrNull;
    final biometricsEnabled =
        profile?.preferences['biometricsEnabled'] as bool? ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Security Settings')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SettingsSection(
                  title: 'App Security',
                  children: [
                    if (_isBiometricAvailable)
                      SettingsTile(
                        icon: Icons.fingerprint,
                        title: 'Biometric Authentication',
                        subtitle: 'Use fingerprint or face ID to log in',
                        trailing: Switch(
                          value: biometricsEnabled,
                          onChanged: _toggleBiometrics,
                          activeThumbColor: AppColors.primaryGreen,
                        ),
                      )
                    else
                      const SettingsTile(
                        icon: Icons.error_outline,
                        title: 'Biometrics Unavailable',
                        subtitle:
                            'Your device does not support biometric authentication.',
                        iconColor: AppColors.mediumGray,
                        textColor: AppColors.mediumGray,
                      ),
                    SettingsTile(
                      icon: Icons.pin,
                      title: 'App PIN',
                      subtitle: 'Set a 4-6 digit passcode',
                      onTap: () => context.pushNamed('pinManagement'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SettingsSection(
                  title: 'Privacy & Data',
                  children: [
                    SettingsTile(
                      icon: Icons.visibility,
                      title: 'Privacy Settings',
                      subtitle: 'Manage profile visibility and imports',
                      onTap: () => context.pushNamed('privacySettings'),
                    ),
                    SettingsTile(
                      icon: Icons.block,
                      title: 'Blocked Users',
                      onTap: () {
                        // TODO: Implement blocked users list
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Block list coming soon'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SettingsSection(
                  title: 'Session Management',
                  children: [
                    SettingsTile(
                      icon: Icons.devices,
                      title: 'Active Sessions',
                      subtitle: 'Manage devices logged into your account',
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.pushNamed('activeSessions'),
                    ),
                    SettingsTile(
                      icon: Icons.phone_android,
                      title: 'Current Session',
                      subtitle: '$_deviceModel • $_osVersion',
                      trailing: const Icon(
                        Icons.check_circle,
                        color: AppColors.primaryGreen,
                        size: 16,
                      ),
                    ),
                    SettingsTile(
                      icon: Icons.info_outline,
                      title: 'App Version',
                      subtitle: 'v$_appVersion',
                    ),
                    SettingsTile(
                      icon: Icons.logout,
                      title: 'Sign Out',
                      subtitle: 'Sign out of this device',
                      textColor: Colors.red,
                      iconColor: Colors.red,
                      onTap: _signOut,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
