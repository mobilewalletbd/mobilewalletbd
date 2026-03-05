import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile_wallet/features/auth/presentation/screens/splash_screen.dart';
import 'package:mobile_wallet/features/auth/presentation/screens/welcome_screen.dart';
import 'package:mobile_wallet/features/auth/presentation/screens/login_screen.dart';
import 'package:mobile_wallet/features/auth/presentation/screens/register_screen.dart';
import 'package:mobile_wallet/features/auth/presentation/screens/phone_login_screen.dart';
import 'package:mobile_wallet/features/auth/presentation/screens/onboarding/permission_screen.dart';
import 'package:mobile_wallet/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:mobile_wallet/features/auth/presentation/screens/forgot_password_screen.dart';

import 'package:mobile_wallet/shared/presentation/widgets/bottom_nav_shell.dart';
import 'package:mobile_wallet/features/home/presentation/home_screen.dart';
import 'package:mobile_wallet/features/contacts/presentation/contact_list_screen.dart';
import 'package:mobile_wallet/features/contacts/presentation/screens/contact_details_screen.dart';
import 'package:mobile_wallet/features/contacts/presentation/screens/add_contact_screen.dart';
import 'package:mobile_wallet/features/contacts/presentation/screens/edit_contact_screen.dart';
import 'package:mobile_wallet/features/contacts/presentation/screens/add_contact_method_screen.dart';
import 'package:mobile_wallet/features/contacts/presentation/screens/import_contacts_screen.dart';
import 'package:mobile_wallet/features/contacts/presentation/screens/file_import_screen.dart';
import 'package:mobile_wallet/features/scanning/presentation/screens/scan_card_screen.dart';
import 'package:mobile_wallet/features/scanning/presentation/screens/ocr_preview_screen.dart';
import 'package:mobile_wallet/features/scanning/presentation/screens/scan_history_screen.dart';
import 'package:mobile_wallet/features/wallet/presentation/wallet_home_screen.dart';
import 'package:mobile_wallet/features/wallet/presentation/screens/transaction_history_screen.dart';
import 'package:mobile_wallet/features/settings/presentation/settings_screen.dart';
import 'package:mobile_wallet/features/settings/presentation/screens/account_settings_screen.dart';
import 'package:mobile_wallet/features/settings/presentation/screens/security_settings_screen.dart';
import 'package:mobile_wallet/features/collaboration/presentation/screens/team_list_screen.dart';
import 'package:mobile_wallet/features/collaboration/presentation/screens/create_team_screen.dart';
import 'package:mobile_wallet/features/collaboration/presentation/screens/team_details_screen.dart';
import 'package:mobile_wallet/features/collaboration/presentation/screens/invite_member_screen.dart';
import 'package:mobile_wallet/features/digital_card/presentation/screens/my_digital_card_screen.dart';
import 'package:mobile_wallet/features/digital_card/presentation/screens/card_editor_screen.dart';
import 'package:mobile_wallet/features/digital_card/presentation/screens/template_gallery_screen.dart';
import 'package:mobile_wallet/features/digital_card/presentation/screens/version_history_screen.dart';
import 'package:mobile_wallet/features/digital_card/presentation/screens/digital_card_detail_screen.dart';
import 'package:mobile_wallet/features/home/presentation/screens/notification_list_screen.dart';
import 'package:mobile_wallet/features/settings/presentation/screens/edit_profile_screen.dart';
import 'package:mobile_wallet/features/settings/presentation/screens/privacy_settings_screen.dart';
import 'package:mobile_wallet/features/settings/presentation/screens/pin_management_screen.dart';
import 'package:mobile_wallet/features/settings/presentation/screens/active_sessions_screen.dart';
import 'package:mobile_wallet/features/settings/presentation/screens/analytics_dashboard_screen.dart';

part 'routes.dart';

/// App router provider using GoRouter with Riverpod.
final routerProvider = Provider<GoRouter>((ref) {
  final routerNotifier = RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: routerNotifier,
    redirect: routerNotifier.redirect,
    routes: _routes,
    errorBuilder: (context, state) => _ErrorScreen(error: state.error),
  );
});

/// Router notifier that listens to auth state changes.
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  bool _isAuth = false;
  bool _isInitialized = false;

  RouterNotifier(this._ref) {
    _ref.listen(authenticationProvider, (_, next) {
      next.when(
        data: (user) {
          final wasAuth = _isAuth;
          _isAuth = user != null;
          _isInitialized = true;
          if (wasAuth != _isAuth || !_isInitialized) {
            notifyListeners();
          }
        },
        loading: () {},
        error: (_, __) {
          _isAuth = false;
          _isInitialized = true;
          notifyListeners();
        },
      );
    });
  }

  /// Handles route redirection based on authentication state.
  String? redirect(BuildContext context, GoRouterState state) {
    final isSplash = state.matchedLocation == '/';
    final isAuthRoute = _authRoutes.contains(state.matchedLocation);

    // Don't redirect while on splash screen - let it handle navigation
    if (isSplash) {
      return null;
    }

    // Not initialized yet - go to splash
    if (!_isInitialized) {
      return '/';
    }

    // User is authenticated but trying to access auth routes
    if (_isAuth && isAuthRoute) {
      return '/home';
    }

    // User is not authenticated and not on auth route
    if (!_isAuth && !isAuthRoute) {
      return '/login';
    }

    return null;
  }

  /// Auth-related routes that don't require authentication.
  static const _authRoutes = [
    '/login',
    '/register',
    '/phone-login',
    '/otp-verification',
    '/forgot-password',
  ];
}

/// Error screen for handling navigation errors.
class _ErrorScreen extends StatelessWidget {
  final Exception? error;

  const _ErrorScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 24),
              Text(
                error?.toString() ?? 'An unexpected error occurred.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
