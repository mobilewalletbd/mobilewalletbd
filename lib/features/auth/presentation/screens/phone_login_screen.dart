import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile_wallet/core/theme/app_theme.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';

/// Phone login screen with country code selector.
class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _selectedCountryCode = '+880';
  bool _isLoading = false;
  String? _errorMessage;

  static const List<Map<String, String>> _countryCodes = [
    {'code': '+880', 'country': 'Bangladesh', 'flag': 'BD'},
    {'code': '+91', 'country': 'India', 'flag': 'IN'},
    {'code': '+1', 'country': 'United States', 'flag': 'US'},
    {'code': '+44', 'country': 'United Kingdom', 'flag': 'GB'},
    {'code': '+971', 'country': 'UAE', 'flag': 'AE'},
    {'code': '+966', 'country': 'Saudi Arabia', 'flag': 'SA'},
    {'code': '+65', 'country': 'Singapore', 'flag': 'SG'},
    {'code': '+60', 'country': 'Malaysia', 'flag': 'MY'},
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove any non-digit characters for validation
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

    if (_selectedCountryCode == '+880') {
      // Bangladesh: 10 digits after country code (1 + 9 digits)
      if (digitsOnly.length != 10 || !digitsOnly.startsWith('1')) {
        return 'Enter a valid Bangladesh number (01XX-XXXXXXX)';
      }
    } else {
      // Generic validation: 7-15 digits
      if (digitsOnly.length < 7 || digitsOnly.length > 15) {
        return 'Enter a valid phone number';
      }
    }

    return null;
  }

  String get _fullPhoneNumber {
    final phone = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    return '$_selectedCountryCode$phone';
  }

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(authenticationProvider.notifier)
          .sendPhoneOTP(
            phoneNumber: _fullPhoneNumber,
            onCodeSent: (verificationId) {
              if (mounted) {
                context.push(
                  '/otp-verification',
                  extra: {
                    'verificationId': verificationId,
                    'phoneNumber': _fullPhoneNumber,
                  },
                );
              }
            },
            onError: (error) {
              if (mounted) {
                setState(() {
                  _errorMessage = error;
                  _isLoading = false;
                });
              }
            },
          );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to send OTP. Please try again.';
      });
    } finally {
      if (mounted && _errorMessage == null) {
        // Only reset if we didn't navigate away
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Header
                _buildHeader(),
                const SizedBox(height: 48),
                // Error Message
                if (_errorMessage != null) ...[
                  _buildErrorBanner(),
                  const SizedBox(height: 16),
                ],
                // Phone Input
                _buildPhoneInput(),
                const SizedBox(height: 32),
                // Send OTP Button
                _buildSendOTPButton(),
                const SizedBox(height: 24),
                // Info Text
                _buildInfoText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phone Icon
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.phone_android,
            size: 32,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Enter your phone',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 8),
        Text(
          "We'll send you a verification code to confirm your phone number.",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondaryColor),
        ),
      ],
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.errorColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppTheme.errorColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: AppTheme.errorColor, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Phone Number', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Row(
          children: [
            // Country Code Dropdown
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCountryCode,
                  onChanged: _isLoading
                      ? null
                      : (value) {
                          setState(() {
                            _selectedCountryCode = value!;
                          });
                        },
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  borderRadius: BorderRadius.circular(12),
                  items: _countryCodes.map((country) {
                    return DropdownMenuItem<String>(
                      value: country['code'],
                      child: Text(
                        '${country['flag']} ${country['code']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Phone Number Field
            Expanded(
              child: TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                enabled: !_isLoading,
                validator: _validatePhone,
                onFieldSubmitted: (_) => _sendOTP(),
                decoration: InputDecoration(
                  hintText: _selectedCountryCode == '+880'
                      ? '01XXX-XXXXXX'
                      : 'Phone number',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSendOTPButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _sendOTP,
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text('Send Verification Code'),
    );
  }

  Widget _buildInfoText() {
    return Row(
      children: [
        Icon(
          Icons.info_outline,
          size: 16,
          color: AppTheme.textSecondaryColor.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Standard SMS charges may apply',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryColor.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }
}
