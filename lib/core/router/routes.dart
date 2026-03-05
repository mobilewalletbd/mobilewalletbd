part of 'app_router.dart';

/// Route definitions for the app.
final List<RouteBase> _routes = [
  // Splash Screen
  GoRoute(
    path: '/',
    name: 'splash',
    builder: (context, state) => const SplashScreen(),
  ),

  // Welcome/Logo Screen
  GoRoute(
    path: '/welcome',
    name: 'welcome',
    builder: (context, state) => const WelcomeScreen(),
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

  // Permission Screen (First Launch)
  GoRoute(
    path: '/permission',
    name: 'permission',
    builder: (context, state) => PermissionScreen(
      onComplete: () {
        // Navigate to welcome screen after permissions
        context.go('/welcome');
      },
    ),
  ),

  // Shell Route for Bottom Navigation
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return BottomNavShell(navigationShell: navigationShell);
    },
    branches: [
      // Branch 1: Home
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
        ],
      ),
      // Branch 2: Contacts
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/contacts',
            name: 'contacts',
            builder: (context, state) => const ContactListScreen(),
            routes: [
              // Add Contact Method Screen
              GoRoute(
                path: 'add-method',
                name: 'addContactMethod',
                builder: (context, state) => const AddContactMethodScreen(),
              ),
              // Add Contact Screen (Manual Form)
              GoRoute(
                path: 'add',
                name: 'addContact',
                builder: (context, state) => const AddContactScreen(),
              ),
              // Import Contacts from Phone
              GoRoute(
                path: 'import',
                name: 'importContacts',
                builder: (context, state) => const ImportContactsScreen(),
              ),
              // Import Contacts from File
              GoRoute(
                path: 'import-file',
                name: 'importFileContacts',
                builder: (context, state) => const FileImportScreen(),
              ),
              // Scan Business Card
              GoRoute(
                path: 'scan',
                name: 'scan',
                builder: (context, state) => const ScanCardScreen(),
                routes: [
                  // OCR Preview Screen
                  GoRoute(
                    path: 'ocr-preview',
                    name: 'ocrPreview',
                    builder: (context, state) => const OcrPreviewScreen(),
                  ),
                ],
              ),
              // Contact Details Screen
              GoRoute(
                path: ':id',
                name: 'contactDetails',
                builder: (context, state) => ContactDetailsScreen(
                  contactId: state.pathParameters['id'] ?? '',
                ),
                routes: [
                  // Edit Contact Screen
                  GoRoute(
                    path: 'edit',
                    name: 'editContact',
                    builder: (context, state) => EditContactScreen(
                      contactId: state.pathParameters['id'] ?? '',
                    ),
                  ),
                ],
              ),
              // Scan History Screen
              GoRoute(
                path: 'scan-history',
                name: 'scanHistory',
                builder: (context, state) => const ScanHistoryScreen(),
              ),
            ],
          ),
        ],
      ),
      // Branch 3: Wallet
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/wallet',
            name: 'wallet',
            builder: (context, state) => const WalletHomeScreen(),
            routes: [
              // Transaction History
              GoRoute(
                path: 'history',
                name: 'transactionHistory',
                builder: (context, state) => const TransactionHistoryScreen(),
              ),
            ],
          ),
        ],
      ),
      // Branch 4: Settings
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
            routes: [
              // Digital Card Routes
              GoRoute(
                path: 'digital-card',
                name: 'myDigitalCard',
                builder: (context, state) => const MyDigitalCardScreen(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: 'cardEditor',
                    builder: (context, state) => const CardEditorScreen(),
                  ),
                  GoRoute(
                    path: 'templates',
                    name: 'templateGallery',
                    builder: (context, state) => const TemplateGalleryScreen(),
                  ),
                  GoRoute(
                    path: 'history',
                    name: 'versionHistory',
                    builder: (context, state) => const VersionHistoryScreen(),
                  ),
                ],
              ),
              // Account Settings
              GoRoute(
                path: 'account',
                name: 'accountSettings',
                builder: (context, state) => const AccountSettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'profile',
                    name: 'editProfile',
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                ],
              ),
              // Security Settings
              GoRoute(
                path: 'security',
                name: 'securitySettings',
                builder: (context, state) => const SecuritySettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'pin',
                    name: 'pinManagement',
                    builder: (context, state) => const PinManagementScreen(),
                  ),
                  GoRoute(
                    path: 'sessions',
                    name: 'activeSessions',
                    builder: (context, state) => const ActiveSessionsScreen(),
                  ),
                ],
              ),
              // Privacy Settings
              GoRoute(
                path: 'privacy',
                name: 'privacySettings',
                builder: (context, state) => const PrivacySettingsScreen(),
              ),
              // Analytics Dashboard
              GoRoute(
                path: 'analytics',
                name: 'analyticsDashboard',
                builder: (context, state) => const AnalyticsDashboardScreen(),
              ),
              // Team Settings
              GoRoute(
                path: 'teams',
                name: 'teams',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const TeamListScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                ),
                routes: [
                  GoRoute(
                    path: 'create',
                    name: 'createTeam',
                    pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: const CreateTeamScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 1), // Slide from bottom
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                    ),
                  ),
                  GoRoute(
                    path: ':id',
                    name: 'teamDetails',
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: TeamDetailsScreen(teamId: id),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'invite',
                        name: 'inviteMember',
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return InviteMemberScreen(teamId: id);
                        },
                      ),
                      GoRoute(
                        path: 'card/:cardId',
                        name: 'sharedCardDetails',
                        builder: (context, state) {
                          final cardId = state.pathParameters['cardId']!;
                          return DigitalCardDetailScreen(cardId: cardId);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  ),

  // Notifications
  GoRoute(
    path: '/notifications',
    name: 'notifications',
    builder: (context, state) => const NotificationListScreen(),
  ),
];
