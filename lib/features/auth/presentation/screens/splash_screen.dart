import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile_wallet/core/config/config_provider.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile_wallet/features/settings/presentation/providers/permission_provider.dart';

/// Splash screen that initializes services and checks auth state.
///
/// Displays app logo/branding while:
/// 1. Waiting for Firebase and other services to initialize
/// 2. Checking authentication state
/// 3. Navigating to appropriate screen based on auth status
///
/// Design based on V1_APP_DESIGN_PLAN specifications:
/// - White background
/// - 120x120px app icon with scale animation (0.8 → 1.0)
/// - App name in Primary Green (#0BBF7D)
/// - Loading spinner at bottom
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    // Wait for animation to complete partially
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    // Initialize permissions
    await ref.read(permissionProvider.notifier).initialize();

    // Check if this is first launch
    final permissionState = ref.read(permissionProvider);

    if (permissionState.isFirstLaunch) {
      // Navigate to permission screen for first launch
      if (mounted) {
        context.go('/permission');
      }
      return;
    }

    // Check auth state and navigate
    final authState = ref.read(authenticationProvider);

    authState.when(
      data: (user) {
        if (user != null) {
          context.go('/home');
        } else {
          context.go('/welcome');
        }
      },
      loading: () {
        // Still loading, wait for auth state to resolve
        _waitForAuthState();
      },
      error: (_, __) {
        context.go('/welcome');
      },
    );
  }

  void _waitForAuthState() {
    ref.listenManual(authenticationProvider, (previous, next) {
      if (!mounted) return;

      next.when(
        data: (user) {
          if (user != null) {
            context.go('/home');
          } else {
            context.go('/welcome');
          }
        },
        loading: () {},
        error: (_, __) {
          context.go('/welcome');
        },
      );
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get configuration values
    final appName = ref.watch(appNameProvider);
    final splashImagePath = ref.watch(splashImagePathProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // App Logo from assets
                Container(
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Image.asset(
                        splashImagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback to icon if image fails to load
                          return Icon(
                            Icons.account_balance_wallet_rounded,
                            size: 60,
                            color: AppColors.primaryGreen,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // App Name from configuration
                Text(
                  appName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                // Loading indicator
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.mediumGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
