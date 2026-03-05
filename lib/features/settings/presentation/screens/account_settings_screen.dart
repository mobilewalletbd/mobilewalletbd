import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile_wallet/features/settings/presentation/widgets/settings_section.dart';
import 'package:mobile_wallet/features/settings/presentation/widgets/settings_tile.dart';

class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<AccountSettingsScreen> createState() =>
      _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  Future<void> _showReauthDialog(VoidCallback onAuthenticated) async {
    _currentPasswordController.clear();
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Re-authentication Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please enter your current password to continue.'),
            const SizedBox(height: 16),
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final password = _currentPasswordController.text;
              if (password.isEmpty) return;

              final email = ref.read(currentUserProvider)?.email;
              if (email == null) return;

              Navigator.pop(context); // Close dialog

              try {
                setState(() => _isLoading = true);
                if (!mounted) return;
                await ref
                    .read(authenticationProvider.notifier)
                    .reauthenticateWithEmail(email: email, password: password);
                if (mounted) {
                  onAuthenticated();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Authentication failed: $e')),
                  );
                }
              } finally {
                if (mounted) {
                  setState(() => _isLoading = false);
                }
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _changeEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    await _showReauthDialog(() async {
      try {
        setState(() => _isLoading = true);
        await ref.read(authenticationProvider.notifier).updateEmail(email);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Email updated successfully. Please verify your new email.',
              ),
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to update email: $e')));
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    });
  }

  Future<void> _changePassword() async {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    await _showReauthDialog(() async {
      try {
        setState(() => _isLoading = true);
        await ref
            .read(authenticationProvider.notifier)
            .updatePassword(password);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password updated successfully')),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update password: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    });
  }

  void _showChangeEmailDialog() {
    _emailController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Email'),
        content: TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'New Email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _changeEmail();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    _passwordController.clear();
    _confirmPasswordController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _changePassword();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Account Settings')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SettingsSection(
                  title: 'Login & Security',
                  children: [
                    SettingsTile(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      subtitle: user?.email ?? 'Not set',
                      onTap: _showChangeEmailDialog,
                    ),
                    SettingsTile(
                      icon: Icons.lock_outline,
                      title: 'Password',
                      subtitle: 'Last changed: never', // Placeholder logic
                      onTap: _showChangePasswordDialog,
                    ),
                    SettingsTile(
                      icon: Icons.phone_android,
                      title: 'Phone Number',
                      subtitle: 'Not set',
                      onTap: _showChangePhoneDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SettingsSection(
                  title: 'Account Actions',
                  children: [
                    SettingsTile(
                      icon: Icons.edit_outlined, // Edit Profile
                      title: 'Edit Profile',
                      subtitle: 'Update your name, bio, and other details',
                      onTap: () {
                        context.pushNamed('editProfile');
                      },
                    ),
                    SettingsTile(
                      icon: Icons.delete_forever,
                      title: 'Delete Account',
                      subtitle: 'Permanently delete your account and data',
                      onTap: _confirmDeleteAccount,
                      textColor: AppColors.error,
                      iconColor: AppColors.error,
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  void _showChangePhoneDialog() {
    final phoneController = TextEditingController();
    bool isLoading = false;
    String? errorText;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Change Phone Number'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enter your new phone number with country code (e.g., +880...).',
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'New Phone Number',
                    border: const OutlineInputBorder(),
                    errorText: errorText,
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  enabled: !isLoading,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        final phone = phoneController.text.trim();
                        if (phone.isEmpty) {
                          setDialogState(
                            () => errorText = 'Phone number is required',
                          );
                          return;
                        }

                        setDialogState(() {
                          isLoading = true;
                          errorText = null;
                        });

                        try {
                          await ref
                              .read(authenticationProvider.notifier)
                              .sendPhoneOTP(
                                phoneNumber: phone,
                                onCodeSent: (verificationId) {
                                  Navigator.pop(context); // Close phone dialog
                                  _showPhoneOtpDialog(verificationId, phone);
                                },
                                onError: (error) {
                                  setDialogState(() {
                                    isLoading = false;
                                    errorText = error;
                                  });
                                },
                              );
                        } catch (e) {
                          setDialogState(() {
                            isLoading = false;
                            errorText = e.toString();
                          });
                        }
                      },
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Send OTP'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showPhoneOtpDialog(String verificationId, String phoneNumber) {
    final otpController = TextEditingController();
    bool isLoading = false;
    String? errorText;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Verify Phone Number'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Enter the 6-digit code sent to $phoneNumber'),
                const SizedBox(height: 16),
                TextField(
                  controller: otpController,
                  decoration: InputDecoration(
                    labelText: 'OTP Code',
                    border: const OutlineInputBorder(),
                    errorText: errorText,
                    counterText: '',
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  enabled: !isLoading,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        final code = otpController.text.trim();
                        if (code.length != 6) {
                          setDialogState(
                            () => errorText = 'Enter a valid 6-digit OTP',
                          );
                          return;
                        }

                        setDialogState(() {
                          isLoading = true;
                          errorText = null;
                        });

                        try {
                          await ref
                              .read(authenticationProvider.notifier)
                              .updatePhoneNumber(
                                verificationId: verificationId,
                                smsCode: code,
                              );

                          if (mounted) {
                            Navigator.pop(context); // Close OTP dialog
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Phone number updated successfully',
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          setDialogState(() {
                            isLoading = false;
                            errorText =
                                'Invalid OTP or verification failed. Try again.';
                          });
                        }
                      },
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Verify & Update'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(authenticationProvider.notifier).deleteAccount();
        if (mounted) {
          context.go('/login');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete account: $e')),
          );
        }
      }
    }
  }
}
