import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_wallet/core/config/config_provider.dart';
import 'package:mobile_wallet/core/services/firebase_service.dart';
import 'package:mobile_wallet/core/services/isar_service.dart';
import 'package:mobile_wallet/core/services/session_manager.dart';
import 'package:mobile_wallet/core/security/security_service.dart';
import 'package:mobile_wallet/core/router/app_router.dart';
import 'package:mobile_wallet/core/theme/app_theme.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize configuration (loads .env and required_info.json)
  await initializeConfig();

  // Initialize Firebase with timeout handling
  await FirebaseService.initialize();

  // Initialize Isar local database
  await IsarService.initialize();

  // Initialize security service
  await SecurityService().initialize();

  // Initialize session manager
  await SessionManager().initialize();

  runApp(const ProviderScope(child: SmartWalletApp()));
}

/// Initial splash screen widget shown while app initializes
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 120,
              height: 120,
              package: null,
            ),
            const SizedBox(height: 24),
            const Text(
              'Mobile Wallet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            // Replaced hardcoded color with AppColors.primaryGreen
            const CircularProgressIndicator(color: AppColors.primaryGreen),
          ],
        ),
      ),
    );
  }
}

/// Root application widget for Smart Wallet.
class SmartWalletApp extends ConsumerWidget {
  const SmartWalletApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final appName = ref.watch(appNameProvider);

    return MaterialApp.router(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
