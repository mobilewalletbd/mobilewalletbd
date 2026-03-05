import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile_wallet/features/auth/domain/repositories/auth_repository.dart';

/// Welcome/Logo Page - Entry point for unauthenticated users
///
/// Design based on V1_PAGE_SPECIFICATIONS.txt (Page 2):
/// - Centered logo at top
/// - Large buttons for Log In and Sign Up
/// - Social login icons at bottom
///
/// Layout following V1_APP_DESIGN_PLAN.txt specifications:
/// - Clean white background
/// - Primary Green buttons
/// - Proper spacing and typography
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  Future<void> _signInWithGoogle(BuildContext context, WidgetRef ref) async {
    try {
      // Show loading indicator if needed, or handle loading state within the button if complex
      // For now, we'll rely on generating a quick overlay or just awaiting
      // To improve UX, we could add a local loading state if we converted to ConsumerStatefulWidget

      await ref.read(authenticationProvider.notifier).signInWithGoogle();

      if (context.mounted) {
        context.go('/home');
      }
    } on AuthFailure catch (e) {
      if (e.type != AuthFailureType.cancelled && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: AppColors.error),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to sign in with Google. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // App Logo
              _buildLogo(),
              const SizedBox(height: 48),
              // Tagline
              _buildTagline(),
              const Spacer(flex: 3),
              // Primary Action Buttons
              _buildActionButtons(context),
              const SizedBox(height: 32),
              // Divider with text
              _buildDivider(),
              const SizedBox(height: 24),
              // Social Login Options
              _buildSocialLoginButtons(context, ref),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.account_balance_wallet_rounded,
          size: 60,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }

  Widget _buildTagline() {
    return Column(
      children: [
        const Text(
          'Smart Contact Wallet',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Manage contacts, payments, and business networking',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Log In Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => context.push('/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Log In',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Sign Up Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () => context.push('/register'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryGreen,
              side: const BorderSide(color: AppColors.primaryGreen, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Sign Up',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.lightGray)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or continue with',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.lightGray)),
      ],
    );
  }

  Widget _buildSocialLoginButtons(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google Login Button
        _buildSocialButton(
          icon: Icons.g_mobiledata,
          label: 'G',
          onPressed: () => _signInWithGoogle(context, ref),
        ),
        const SizedBox(width: 16),
        // Facebook Login Button
        _buildSocialButton(
          icon: Icons.facebook,
          label: 'FB',
          onPressed: () {
            // Facebook Sign In is not yet implemented
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Facebook Sign In coming soon'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray, width: 1),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 24, color: AppColors.darkGray),
      ),
    );
  }
}
