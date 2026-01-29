import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile_wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile_wallet/features/auth/presentation/screens/splash_screen.dart';
import 'package:mobile_wallet/features/auth/presentation/screens/login_screen.dart';
import 'package:mobile_wallet/features/auth/presentation/screens/register_screen.dart';
import 'package:mobile_wallet/features/auth/presentation/screens/phone_login_screen.dart';
import 'package:mobile_wallet/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:mobile_wallet/features/auth/presentation/screens/forgot_password_screen.dart';

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

/// Temporary home screen placeholder.
/// This will be replaced with the actual dashboard in Phase 6.
class _HomeScreen extends ConsumerWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Wallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authenticationProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // User Avatar
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).primaryColor,
                backgroundImage: user?.photoUrl != null
                    ? NetworkImage(user!.photoUrl!)
                    : null,
                child: user?.photoUrl == null
                    ? Text(
                        user?.initials ?? '?',
                        style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 24),
              // Welcome Message
              Text(
                'Welcome, ${user?.displayName ?? 'User'}!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (user?.email != null)
                Text(
                  user!.email!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                ),
              if (user?.phoneNumber != null) ...[
                const SizedBox(height: 4),
                Text(
                  user!.phoneNumber!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                ),
              ],
              const SizedBox(height: 32),
              // Dashboard placeholder
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.construction,
                      size: 48,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Dashboard Coming Soon',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Phase 2 Authentication is complete.\nPhase 6 Dashboard will be implemented next.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
                'Page not found',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error?.toString() ??
                    'The page you are looking for does not exist.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
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
