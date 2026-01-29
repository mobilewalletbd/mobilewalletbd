part of 'app_router.dart';

/// Route definitions for the app.
final List<RouteBase> _routes = [
  // Splash Screen
  GoRoute(
    path: '/',
    name: 'splash',
    builder: (context, state) => const SplashScreen(),
  ),

  // Login Screen
  GoRoute(
    path: '/login',
    name: 'login',
    builder: (context, state) => const LoginScreen(),
  ),

  // Register Screen
  GoRoute(
    path: '/register',
    name: 'register',
    builder: (context, state) => const RegisterScreen(),
  ),

  // Phone Login Screen
  GoRoute(
    path: '/phone-login',
    name: 'phoneLogin',
    builder: (context, state) => const PhoneLoginScreen(),
  ),

  // OTP Verification Screen
  GoRoute(
    path: '/otp-verification',
    name: 'otpVerification',
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      return OTPVerificationScreen(
        verificationId: extra?['verificationId'] ?? '',
        phoneNumber: extra?['phoneNumber'] ?? '',
      );
    },
  ),

  // Forgot Password Screen
  GoRoute(
    path: '/forgot-password',
    name: 'forgotPassword',
    builder: (context, state) => const ForgotPasswordScreen(),
  ),

  // Home Screen (Dashboard placeholder)
  GoRoute(
    path: '/home',
    name: 'home',
    builder: (context, state) => const _HomeScreen(),
  ),
];
