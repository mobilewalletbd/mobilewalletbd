import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile_wallet/features/auth/domain/repositories/auth_repository.dart';

/// OTP verification screen with 6-digit input and auto-submit.
///
/// Design based on V1_APP_DESIGN_PLAN specifications:
/// - 6 individual digit input boxes (48x56px each)
/// - Auto-advance focus on digit entry
/// - Countdown timer for resend
/// - JetBrains Mono font for OTP codes
class OTPVerificationScreen extends ConsumerStatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OTPVerificationScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  ConsumerState<OTPVerificationScreen> createState() =>
      _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends ConsumerState<OTPVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  String? _errorMessage;
  int _resendSeconds = 60;
  Timer? _resendTimer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    // Focus the first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendSeconds = 60;
    _canResend = false;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() {
          _resendSeconds--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  bool get _isOTPComplete => _otpCode.length == 6;

  void _onOTPChanged(int index, String value) {
    setState(() {
      _errorMessage = null;
    });

    if (value.isNotEmpty) {
      // Move to next field
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last digit entered, auto-submit
        _focusNodes[index].unfocus();
        if (_isOTPComplete) {
          _verifyOTP();
        }
      }
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      // Move to previous field on backspace if current is empty
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }
  }

  Future<void> _verifyOTP() async {
    if (!_isOTPComplete) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(authenticationProvider.notifier)
          .verifyPhoneOTP(
            verificationId: widget.verificationId,
            smsCode: _otpCode,
          );

      if (mounted) {
        context.go('/home');
      }
    } on AuthFailure catch (e) {
      setState(() {
        _errorMessage = e.message;
        // Clear OTP fields on error
        for (final controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Verification failed. Please try again.';
        for (final controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendOTP() async {
    if (!_canResend) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(authenticationProvider.notifier)
          .sendPhoneOTP(
            phoneNumber: widget.phoneNumber,
            onCodeSent: (verificationId) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
                _startResendTimer();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Verification code sent'),
                    backgroundColor: AppColors.success,
                  ),
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
        _errorMessage = 'Failed to resend code. Please try again.';
        _isLoading = false;
      });
    }
  }

  String _formatPhoneNumber(String phone) {
    // Mask phone number for display
    if (phone.length <= 6) return phone;
    final visible = phone.substring(0, 4);
    final end = phone.substring(phone.length - 2);
    return '$visible****$end';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Verify OTP',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Header
              _buildHeader(),
              const SizedBox(height: 40),
              // Error Message
              if (_errorMessage != null) ...[
                _buildErrorBanner(),
                const SizedBox(height: 24),
              ],
              // OTP Input
              _buildOTPInput(),
              const SizedBox(height: 32),
              // Verify Button
              _buildVerifyButton(),
              const SizedBox(height: 32),
              // Resend Section
              _buildResendSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Phone/SMS Illustration
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.skyBlue.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(
            Icons.sms_outlined,
            size: 50,
            color: AppColors.skyBlue,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Verify OTP',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            children: [
              const TextSpan(text: 'Enter the 6-digit code sent to\n'),
              TextSpan(
                text: '+880 ${_formatPhoneNumber(widget.phoneNumber)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: AppColors.error, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOTPInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 48,
          height: 56,
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) => _onKeyEvent(index, event),
            child: TextFormField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              enabled: !_isLoading,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontFamily: 'JetBrainsMono',
                color: AppColors.black,
              ),
              decoration: InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: _controllers[index].text.isNotEmpty
                    ? AppColors.primaryGreen.withValues(alpha: 0.1)
                    : AppColors.offWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: _controllers[index].text.isNotEmpty
                      ? const BorderSide(
                          color: AppColors.primaryGreen,
                          width: 2,
                        )
                      : const BorderSide(color: AppColors.lightGray, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryGreen,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: _controllers[index].text.isNotEmpty
                      ? const BorderSide(
                          color: AppColors.primaryGreen,
                          width: 2,
                        )
                      : const BorderSide(color: AppColors.lightGray, width: 1),
                ),
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) => _onOTPChanged(index, value),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildVerifyButton() {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: (_isLoading || !_isOTPComplete) ? null : _verifyOTP,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isOTPComplete
              ? AppColors.primaryGreen
              : AppColors.lightGray,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : const Text('VERIFY'),
      ),
    );
  }

  Widget _buildResendSection() {
    return Column(
      children: [
        if (_canResend)
          TextButton(
            onPressed: _isLoading ? null : _resendOTP,
            child: const Text(
              'Resend Code',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryGreen,
              ),
            ),
          )
        else
          Text(
            'Resend code in 00:${_resendSeconds.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 14, color: AppColors.mediumGray),
          ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => context.pop(),
          child: const Text(
            'Change number?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryGreen,
            ),
          ),
        ),
      ],
    );
  }
}
