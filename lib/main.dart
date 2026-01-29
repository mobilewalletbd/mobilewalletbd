import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/config_provider.dart';
import 'core/services/firebase_service.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize configuration (loads .env and required_info.json)
  await initializeConfig();

  // Initialize Firebase
  await FirebaseService.initialize();

  runApp(const ProviderScope(child: SmartWalletApp()));
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
