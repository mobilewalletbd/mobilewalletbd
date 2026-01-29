---
trigger: always_on
---
# Mobile Wallet BD - Development Rules & Best Practices

**Document Version:** 1.0  
**Date:** January 29, 2026  
**Project:** Smart Contact Wallet (Flutter Mobile Application)  
**Architecture:** Feature-First Clean Architecture with Riverpod
**Backend:** Firebase-first with Isar local storage (offline-first approach)

---

## Table of Contents

1. [Project Architecture Overview](#1-project-architecture-overview)
2. [Code Organization & Directory Structure](#2-code-organization--directory-structure)
3. [File Naming Conventions](#3-file-naming-conventions)
4. [Naming Conventions](#4-naming-conventions)
5. [State Management (Riverpod)](#5-state-management-riverpod)
6. [Database Patterns (Isar & Firestore)](#6-database-patterns-isar--firestore)
7. [Error Handling & Logging](#7-error-handling--logging)
8. [Git Workflow & Branch Naming](#8-git-workflow--branch-naming)
9. [Testing Requirements](#9-testing-requirements)
10. [Code Review Guidelines](#10-code-review-guidelines)
11. [Documentation Standards](#11-documentation-standards)
12. [Dependency Management](#12-dependency-management)
13. [Security Guidelines](#13-security-guidelines)

---

## 1. Project Architecture Overview

### 1.1 Architectural Pattern
This project follows **Feature-First Clean Architecture**. Code is organized by "what it does" (feature) rather than "what it is" (layer). Each feature module contains its own Domain, Data, and Presentation layers. The architecture is Firebase-first with Isar local storage for offline-first functionality.

```
lib/
├── main.dart                    # Entry Point
├── src/
│   ├── app.dart                 # App Configuration
│   ├── core/                    # Shared Infrastructure
│   │   ├── config/              # Environment, Constants
│   │   ├── error/               # Failures, Exceptions
│   │   ├── router/              # GoRouter Configuration
│   │   ├── services/            # Third-party Services (Firebase, Cloudinary, Isar)
│   │   ├── theme/               # App Theme, Colors, Typography
│   │   ├── utils/               # Helpers, Validators, Formatters
│   │   └── widgets/             # Global Reusable Widgets
│   ├── features/                # Feature Modules
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── contacts/
│   │   ├── wallet/
│   │   ├── settings/
│   │   └── shared/              # Shared between features
│   └── common_widgets/          # Global Composed Widgets
```

### 1.2 Layer Responsibilities

| Layer | Purpose | Dependencies | Contains |
|-------|---------|--------------|----------|
| **Domain** | Pure business logic | None (Pure Dart) | Entities, Failures, Value Objects, Use Cases |
| **Data** | Data access & storage | Domain | Repositories, Data Sources, DTOs |
| **Presentation** | UI & State | Domain, Application | Screens, Widgets, Controllers (Riverpod) |

**Special Note**: The Data layer handles both local (Isar) and remote (Firebase) data sources, with repositories coordinating the sync between them.

### 1.3 Data Flow
```
User Action → Controller (Riverpod) → Repository → Data Source → UI State Update
```

**Offline-First Flow**:
```
User Action → Isar Local Storage → Immediate UI Update → Queue for Firebase Sync → Firebase Storage
```

**Sync Strategy**:
```
Local Change → Queue in Isar → Background Sync Service → Firebase Firestore → Sync Confirmation
```

---

## 2. Code Organization & Directory Structure

### 2.1 Feature Module Structure
Each feature module MUST follow this exact structure:

```
lib/src/features/[feature_name]/
├── data/
│   ├── datasources/
│   │   ├── local_[feature]_datasource.dart
│   │   └── remote_[feature]_datasource.dart
│   ├── repositories/
│   │   └── [feature]_repository_impl.dart
│   └── dtos/
│       └── [feature]_dto.dart
├── domain/
│   ├── entities/
│   │   └── [feature]_model.dart
│   ├── repositories/
│   │   └── [feature]_repository.dart
│   ├── failures/
│   │   └── [feature]_failure.dart
│   └── usecases/
│       └── [feature]_usecase.dart
└── presentation/
    ├── screens/
    │   └── [feature]_screen.dart
    ├── widgets/
    │   └── [feature]_widgets.dart
    ├── controllers/
    │   └── [feature]_controller.dart
    └── providers/
        └── [feature]_provider.dart
```

### 2.2 Core Module Structure
The `core/` module contains shared infrastructure used across all features:

```
lib/src/core/
├── config/
│   ├── app_config.dart
│   └── env_config.dart
├── error/
│   ├── exceptions.dart
│   └── failure.dart
├── router/
│   ├── app_router.dart
│   ├── routes.dart
│   └── auth_guard.dart
├── services/
│   ├── firebase_service.dart
│   ├── firebase_auth_service.dart
│   ├── firestore_service.dart
│   ├── cloudinary_service.dart
│   ├── isar_service.dart
│   └── session_manager.dart
├── theme/
│   ├── app_theme.dart
│   ├── colors.dart
│   └── typography.dart
├── utils/
│   ├── validators.dart
│   ├── formatters.dart
│   └── constants.dart
└── widgets/
    ├── primary_button.dart
    ├── custom_text_field.dart
    └── async_value_widget.dart
```

### 2.3 File Placement Rules
- **DO** place feature-specific code within the feature module
- **DO** place shared code in `core/` or `common_widgets/`
- **DO** create a new feature module when adding distinct functionality
- **DO NOT** create utility files at the project root level
- **DO NOT** mix code from different features in one file
- **DO NOT** place presentation logic in the domain layer

---

## 3. File Naming Conventions

### 3.1 General Rules
| Component | Convention | Examples |
|-----------|------------|----------|
| Files | `snake_case` | `auth_user.dart`, `contact_repository.dart` |
| Directories | `snake_case` | `data_sources`, `domain_entities` |
| Classes | `PascalCase` | `AuthUser`, `ContactRepository` |
| Functions | `camelCase` | `getUserProfile()`, `validateEmail()` |
| Variables | `camelCase` | `userId`, `isLoading` |
| Constants | `camelCase` (or `SCREAMING_SNAKE_CASE` for enums) | `maxRetryCount`, `ApiEndpoints` |
| Private Members | Leading underscore | `_authService`, `_validateForm()` |

### 3.2 Layer-Specific File Names
| Layer | Suffix/Pattern | Examples |
|-------|----------------|----------|
| Entity | `[name].dart` | `auth_user.dart`, `contact.dart` |
| Repository Interface | `[feature]_repository.dart` | `auth_repository.dart` |
| Repository Impl | `[feature]_repository_impl.dart` | `auth_repository_impl.dart` |
| Data Source | `[type]_[feature]_datasource.dart` | `local_contact_datasource.dart` |
| DTO | `[feature]_dto.dart` | `user_dto.dart` |
| Screen | `[feature]_screen.dart` | `login_screen.dart` |
| Controller | `[feature]_controller.dart` | `contact_controller.dart` |
| Provider | `[feature]_provider.dart` | `auth_provider.dart` |
| Widget | `[feature]_[widget].dart` | `contact_card.dart` |
| Use Case | `[verb]_[feature]_usecase.dart` | `get_contact_usecase.dart` |
| Failure | `[feature]_failure.dart` | `auth_failure.dart` |

### 3.3 File Organization Rules
1. Each file should contain ONLY one public class
2. Private helper classes may be in the same file if closely related
3. Keep files under 300 lines when possible
4. Use `part` and `part of` for generated files (e.g., Riverpod providers)
5. Generated files should use the same name with `.g.dart` suffix

---

## 4. Naming Conventions

### 4.1 Class Naming
```dart
// Entities - Nouns describing business objects
class UserProfile { }
class Contact { }
class Transaction { }

// Repositories - Interface and Implementation
abstract class AuthRepository { }
class AuthRepositoryImpl implements AuthRepository { }

// Failures - Describe what went wrong
class AuthFailure { }
class ContactFailure { }

// Use Cases - Verb + Noun pattern
class GetContactUseCase { }
class CreateContactUseCase { }

// Screens - Feature + Screen
class LoginScreen { }
class ContactDetailScreen { }

// Controllers/Providers - Feature + Controller/Provider
class AuthController { }
class ContactProvider { }
```

### 4.2 Variable & Property Naming
```dart
// Boolean - Prefix with is/are/has/should
bool isLoading = false;
bool hasError = false;
bool isAuthenticated = true;
bool shouldValidate = true;

// Collections - Plural nouns or collective nouns
List<Contact> contacts = [];
Map<String, User> userMap = {};
Set<String> tags = {};

// Nullable - Clear nullability in name
String? email;
String? displayName;
int? retryCount;

// Constants - Descriptive names
const int maxRetryAttempts = 3;
const Duration defaultTimeout = Duration(seconds: 30);
```

### 4.3 Function Naming
```dart
// Verbs for actions
Future<User> getUser(String id) async { }
void saveContact(Contact contact) { }
bool validateEmail(String email) { }

// Query methods - nouns or question words
List<Contact> getContacts() { }
int getContactCount() { }
bool isContactFavorite(String id) { }

// Event handlers - indicate triggered action
void onSubmit() { }
void onTapContact(Contact contact) { }
void onSearchChanged(String query) { }
```

### 4.4 Enum & Constant Naming
```dart
enum ContactCategory { business, personal, family }

enum AuthStatus {
  unknown,
  unauthenticated,
  authenticated,
  loading,
}

class ApiEndpoints {
  static const String baseUrl = 'https://api.example.com';
  static const String contacts = '/contacts';
  static const String sync = '/sync';
}
```

---

## 5. State Management (Riverpod)

### 5.1 Provider Types & Usage
| Provider Type | Use Case | Example |
|---------------|----------|---------|
| `Provider` | Immutable static values | `configProvider`, `themeProvider` |
| `FutureProvider` | Async one-time data | `userProfileProvider` |
| `StreamProvider` | Real-time streams | `authStateProvider` |
| `StateProvider` | Simple mutable state | `searchQueryProvider` |
| `StateNotifierProvider` | Complex state with logic | `authControllerProvider` |
| `@Riverpod` class | Modern auto-generated | `Authentication` |

### 5.2 Provider Naming Conventions
```dart
// Simple providers - descriptive nouns
final themeProvider = Provider<ThemeService>((ref) => ThemeService());

// Async providers - Future/Stream + Noun
final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  final repo = ref.read(userRepositoryProvider);
  return repo.getCurrentUser();
});

final authStateProvider = StreamProvider<AuthUser>((ref) {
  return ref.read(authServiceProvider).authStateChanges;
});

// State Notifier - Feature + Controller/Notifier
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});

// Modern @Riverpod class - Feature as class name
@Riverpod(keepAlive: true)
class Authentication extends _$Authentication {
  @override
  Stream<AuthUser?> build() {
    final authService = ref.watch(firebaseAuthServiceProvider);
    return authService.authStateChanges.map(_mapFirebaseUser);
  }
}
```

### 5.3 State Management Patterns

**Pattern 1: Simple Async State**
```dart
// For loading, data, error states
@riverpod
Future<UserProfile> userProfile(RiverpodRef ref, String userId) async {
  final repository = ref.read(userProfileRepositoryProvider);
  return await repository.getUser(userId);
}

@riverpod
class UserProfileController extends _$UserProfileController {
  @override
  Future<UserProfile> build(String userId) async {
    final repository = ref.read(userProfileRepositoryProvider);
    return await repository.getUser(userId);
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repository.updateUser(userId, data));
  }
}
```

**Pattern 2: Controller with State**
```dart
class ContactController extends StateNotifier<ContactState> {
  final ContactRepository _repository;
  final Ref _ref;

  ContactController(this._repository, this._ref) : super(const ContactState.initial());

  Future<void> loadContacts() async {
    state = state.copyWith(isLoading: true);
    try {
      final contacts = await _repository.getContacts();
      state = state.copyWith(contacts: contacts, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e, isLoading: false);
    }
  }
}
```

**Pattern 3: Consumer Widget Usage**
```dart
class ContactListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(contactsProvider);
    
    return AsyncValueWidget<List<Contact>>(
      value: contactsAsync,
      data: (contacts) => ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) => ContactCard(contact: contacts[index]),
      ),
    );
  }
}
```

### 5.4 Riverpod Best Practices
1. **Use `ref.watch()` for reactive data** - UI rebuilds automatically
2. **Use `ref.read()` for one-time actions** - In buttons, handlers
3. **Keep providers `const` when possible** - Improves performance
4. **Use `keepAlive: true` for persistent providers** - Auth, config
5. **Prefer `@Riverpod` annotation** - Generates optimized code
6. **Always handle `AsyncValue` states** - Loading, data, error

---

## 6. Database Patterns (Isar & Firestore)

### 6.1 Isar Database Guidelines

**Schema Definition**
```dart
@collection
class ContactEntity {
  Id get id => isarContactId;
  
  String get isarContactId => uuid.v4();
  
  String? ownerId;
  
  @Index()
  String? globalContactId;
  
  String fullName = '';
  String? companyName;
  String? jobTitle;
  
  List<String> phones = [];
  List<String> emails = [];
  
  String? imageFrontUrl;
  String? imageBackUrl;
  
  // Store Cloudinary public IDs for business card images
  String? imageFrontPublicId;
  String? imageBackPublicId;
  
  List<String> tags = [];
  
  bool isFavorite = false;
  
  DateTime? createdAt;
  DateTime? updatedAt;
}
```

**Important**: Image storage follows the pattern where high-resolution images are stored locally in Isar, while cloud storage uses Cloudinary for sharing and backup purposes. The `imageFrontPublicId` and `imageBackPublicId` fields store the Cloudinary identifiers for remote access.

**Repository Pattern**
```dart
class IsarContactDatasource {
  final Isar _isar;
  
  IsarContactDatasource(this._isar);
  
  Future<List<ContactEntity>> getContacts(String ownerId) async {
    return await _isar.contactEntitys
        .filter()
        .ownerIdEqualTo(ownerId)
        .findAll();
  }
  
  Future<ContactEntity> saveContact(ContactEntity contact) async {
    await _isar.writeTxn(() async {
      await _isar.contactEntitys.put(contact);
    });
    return contact;
  }
  
  Future<void> deleteContact(String contactId) async {
    await _isar.writeTxn(() async {
      await _isar.contactEntitys.delete(contactId);
    });
  }
}
```

### 6.2 Firestore Guidelines

**Collection Structure**
```dart
class FirestoreCollections {
  static const String users = 'users';
  static const String contacts = 'contacts';
  static const String transactions = 'transactions';
  static const String teams = 'teams';
}
```

**Note**: Unlike traditional architectures, we use Firebase as our primary backend with Isar as the local cache. All writes go to Isar first for immediate UI updates, then are synchronized to Firestore in the background.

**Document Operations**
```dart
class FirestoreDataSource {
  final FirebaseFirestore _firestore;
  
  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _firestore
        .collection(FirestoreCollections.users)
        .doc(uid)
        .get();
    
    if (!doc.exists) return null;
    return UserProfileDto.fromFirestore(doc.data()!);
  }
  
  Future<void> saveUserProfile(UserProfile profile) async {
    await _firestore
        .collection(FirestoreCollections.users)
        .doc(profile.uid)
        .set(profile.toFirestore());
  }
  
  Stream<List<Contact>> watchContacts(String ownerId) {
    return _firestore
        .collection(FirestoreCollections.contacts)
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ContactDto.fromFirestore(doc.data()!))
            .toList());
  }
}
```

### 6.3 Data Synchronization Rules
1. **Offline-First**: Write to Isar first, sync to Firestore in background
2. **Optimistic Updates**: Update UI immediately, rollback on error
3. **Conflict Resolution**: Last-write-wins (server timestamp)
4. **Batch Operations**: Use Firestore transactions for multi-document updates
5. **Pagination**: Always use limit + startAfter for large collections
6. **Firebase Security Rules**: Implement proper Firestore security rules to validate data at the database level

---

## 7. Error Handling & Logging

### 7.1 Failure Class Hierarchy
```dart
// Base Failure
abstract class Failure {
  final String message;
  final dynamic code;
  
  const Failure(this.message, {this.code});
  
  @override
  String toString() => 'Failure: $message (code: $code)';
}

// Feature-specific Failures
class AuthFailure extends Failure {
  final AuthErrorType type;
  
  const AuthFailure(this.type, [String? message]) 
      : super(message ?? _getMessage(type));
  
  static String _getMessage(AuthErrorType type) {
    switch (type) {
      case AuthErrorType.invalidEmail:
        return 'Invalid email address';
      case AuthErrorType.wrongPassword:
        return 'Incorrect password';
      case AuthErrorType.userNotFound:
        return 'No user found with this email';
      case AuthErrorType.networkError:
        return 'Network error. Please check your connection';
    }
  }
}

enum AuthErrorType {
  invalidEmail,
  wrongPassword,
  userNotFound,
  networkError,
  unknown,
}
```

### 7.2 Error Handling Patterns
```dart
// Repository Level - Transform exceptions
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User> signIn(String email, String password) async {
    try {
      return await _authService.signInWithEmail(email, password);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_mapAuthError(e.code));
    } on FirebaseException catch (e) {
      throw AuthFailure(_mapAuthError(e.code));
    } on NetworkException catch (e) {
      throw AuthFailure(AuthErrorType.networkError, e.message);
    } catch (e) {
      throw const AuthFailure(AuthErrorType.unknown);
    }
  }
}

// Firebase-specific error handling
Future<void> handleFirebaseError(Exception e) async {
  if (e is FirebaseAuthException) {
    // Handle authentication-specific errors
    switch (e.code) {
      case 'user-not-found':
        // Handle user not found
        break;
      case 'wrong-password':
        // Handle wrong password
        break;
      default:
        // Handle other auth errors
    }
  } else if (e is FirebaseException) {
    // Handle general Firebase errors
  }
}

// UI Level - Handle AsyncValue errors
Widget build(BuildContext context, WidgetRef ref) {
  final authState = ref.watch(authProvider);
  
  return authState.when(
    data: (user) => HomeScreen(user: user),
    loading: () => LoadingIndicator(),
    error: (error, stack) => ErrorView(error: error as Failure),
  );
}
```

### 7.3 Logging Standards
```dart
class AppLogger {
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag]' : '';
      print('🟢 DEBUG $tagStr: $message');
    }
  }
  
  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag]' : '';
      print('🔵 INFO $tagStr: $message');
    }
  }
  
  static void error(String message, {String? tag, dynamic error}) {
    final tagStr = tag != null ? '[$tag]' : '';
    print('🔴 ERROR $tagStr: $message');
    if (error != null) {
      print('Error details: $error');
    }
  }
}

// Usage
void someFunction() {
  AppLogger.debug('Starting operation', tag: 'Auth');
  try {
    // operation
    AppLogger.info('Operation completed', tag: 'Auth');
  } catch (e) {
    AppLogger.error('Operation failed', tag: 'Auth', error: e);
  }
}
```

### 7.4 Logging Rules
1. **Never log sensitive data** - passwords, tokens, personal information
2. **Use appropriate log levels** - DEBUG for dev, INFO for actions, ERROR for failures
3. **Include context** - operation name, user ID (non-sensitive), timestamp
4. **Remove all `kDebugMode` logs before release** or use a proper logging service

---

## 8. Git Workflow & Branch Naming

### 8.1 Branch Naming Convention
```
[type]/[feature]/[description]

Types:
├── feature/      # New feature development
├── bugfix/       # Bug fixes
├── hotfix/       # Urgent production fixes
├── chore/        # Maintenance tasks
├── refactor/     # Code refactoring
└── docs/         # Documentation updates
```

**Examples:**
```
feature/auth/phone-verification
feature/contacts/ocr-scanning
bugfix/login-crash-on-android
hotfix/secure-token-storage
chore/update-dependencies
refactor/auth-provider-cleanup
docs/update-api-documentation
```

### 8.2 Commit Message Format
```
[TYPE]: Short description (max 50 chars)

- Detailed description if needed
- Reference issue: #123

Types: feat, fix, chore, docs, refactor, style, test
```

**Examples:**
```
feat(auth): Add phone number verification flow

- Implemented OTP sending and verification
- Added phone number input with validation
- Reference: #45
```

### 8.3 Pull Request Guidelines
1. **Keep PRs small** - Under 400 lines of code when possible
2. **Single responsibility** - One feature or fix per PR
3. **Squash commits** - Combine related commits before merging
4. **Required checks** - All tests pass, no lint errors
5. **Description** - Clear description of changes and testing steps

### 8.4 Branch Protection Rules
```markdown
## Branch Protection Rules

### Main Branch (main)
- ✅ Require pull request reviews (minimum 1)
- ✅ Require status checks to pass
- ✅ Require signed commits
- ⛔️ Force push not allowed
- ⛔️ Branch deletion not allowed

### Development Branch (develop)
- ✅ Require pull request reviews (minimum 1)
- ✅ Require status checks to pass
- ⛔️ Force push not allowed
```

---

## 9. Testing Requirements

### 9.1 Test Coverage Goals
| Test Type | Minimum Coverage | Target Coverage |
|-----------|-----------------|-----------------|
| Unit Tests | 70% | 80% |
| Integration Tests | 40% | 60% |
| Widget Tests | 30% | 50% |

### 9.2 Unit Test Structure
```dart
// test/features/auth/domain/entities/auth_user_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_wallet/features/auth/domain/entities/auth_user.dart';

void main() {
  group('AuthUser', () {
    test('should create user with required fields', () {
      const user = AuthUser(
        id: 'test-id',
        email: 'test@example.com',
        phoneNumber: '+8801234567890',
        displayName: 'Test User',
        emailVerified: true,
      );

      expect(user.id, 'test-id');
      expect(user.email, 'test@example.com');
      expect(user.isFullyVerified, true);
    });

    test('should copy user with updated fields', () {
      const user = AuthUser(id: 'test-id', emailVerified: false);
      final updatedUser = user.copyWith(emailVerified: true);

      expect(updatedUser.emailVerified, true);
      expect(updatedUser.id, 'test-id');
    });
  });
}
```

### 9.3 Repository Test Pattern
```dart
// test/features/auth/data/repositories/auth_repository_impl_test.dart
@GenerateMocks([AuthService])
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    repository = AuthRepositoryImpl(mockAuthService);
  });

  group('signInWithEmail', () {
    test('should return user on successful login', () async {
      // Arrange
      when(mockAuthService.signInWithEmail(email: 'test@example.com', password: 'password123'))
          .thenAnswer((_) async => MockUser());

      // Act
      final result = await repository.signInWithEmail(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result, isA<User>());
      verify(mockAuthService.signInWithEmail(email: 'test@example.com', password: 'password123'));
    });

    test('should throw AuthFailure on error', () async {
      // Arrange
      when(mockAuthService.signInWithEmail(email: 'test@example.com', password: 'wrong'))
          .thenThrow(FirebaseAuthException(code: 'wrong-password'));

      // Act & Assert
      expect(
        () => repository.signInWithEmail(email: 'test@example.com', password: 'wrong'),
        throwsA(isA<AuthFailure>()),
      );
    });
  });
}
```

### 9.4 Widget Test Pattern
```dart
// test/features/auth/presentation/screens/login_screen_test.dart
void main() {
  testWidgets('should show error on invalid email', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: LoginScreen()),
      ),
    );

    await tester.enterText(find.byType(TextField).first, 'invalid-email');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Invalid email address'), findsOneWidget);
  });
}
```

### 9.5 Pre-Commit Testing
```bash
# Run before every commit
flutter test --coverage
flutter format .
flutter analyze
```

---

## 10. Code Review Guidelines

### 10.1 Review Checklist
- [ ] Code follows project architecture and patterns
- [ ] Naming conventions are consistent
- [ ] No duplicate code (DRY principle)
- [ ] Error handling is comprehensive
- [ ] Sensitive data is not logged
- [ ] Tests are included and passing
- [ ] Documentation is updated
- [ ] No hardcoded values (use constants)
- [ ] Performance considerations
- [ ] Security best practices followed

### 10.2 Review Comments Style
```markdown
## Positive Comments
✅ "Clean implementation"
✅ "Good use of Riverpod patterns"
✅ "Well-structured error handling"

## Constructive Feedback
⚠️ "Consider using enum for these status values"
💡 "Could we extract this to a separate utility function?"
🔧 "Please add null check here to prevent runtime error"
```

### 10.3 Response Guidelines for Authors
1. **Address all feedback** - Don't ignore comments
2. **Ask for clarification** - If feedback is unclear
3. **Provide context** - Explain your reasoning if needed
4. **Be respectful** - Code review is collaborative, not adversarial

---

## 11. Documentation Standards

### 11.1 Code Comments
```dart
/// Creates a new contact in the local database and queues for cloud sync.
///
/// This method implements the offline-first pattern:
/// 1. Saves to Isar immediately for instant UI update
/// 2. Adds operation to sync queue for background processing
///
/// [contact] - The contact entity to save
/// Returns the saved contact with generated ID
///
/// Throws [ContactFailure] if save operation fails
Future<Contact> createContact(Contact contact) async {
  // Implementation
}

/// Represents a business contact with card imaging support.
///
/// Contains front/back card images and OCR-extracted data.
/// Optimized for quick loading with lazy image loading.
@collection
class ContactEntity {
  // Fields and methods
}
```

### 11.2 Documentation for Public APIs
```dart
/// Authentication provider managing user session state.
///
/// Listens to Firebase Auth state changes and exposes
/// the current user state through a Riverpod stream.
///
/// Usage:
/// ```dart
/// final authState = ref.watch(authenticationProvider);
/// authState.when(
///   data: (user) => HomeScreen(user: user),
///   loading: () => LoadingScreen(),
///   error: (e) => LoginScreen(),
/// );
/// ```
@Riverpod(keepAlive: true)
class Authentication extends _$Authentication {
  // Implementation
}
```

### 11.3 README Updates
When adding new features, update:
- `current.txt` - Task tracking
- API documentation if creating new services
- Architecture diagrams if changing structure

---

## 12. Dependency Management

### 12.1 Adding Dependencies
```bash
# Use pub add with version constraint
flutter pub add riverpod
flutter pub add firebase_auth --exact 4.20.0

# For dev dependencies
flutter pub add -d build_runner --exact 2.4.8
```

### 12.2 Version Constraints in pubspec.yaml
```yaml
dependencies:
  # Use ^ for minor/patch updates (recommended)
  flutter_riverpod: ^2.4.0
  
  # Use exact version for critical dependencies
  firebase_auth: 4.20.0
  
  # Use >= for flexible lower bounds
  isar: '>=3.1.0 <4.0.0'

dev_dependencies:
  # Development-only tools
  build_runner: ^2.4.8
  flutter_test:
    sdk: flutter
```

### 12.3 Dependency Review Rules
1. **Check license** - Ensure MIT, BSD, or Apache 2.0
2. **Verify maintenance** - Last update within 6 months preferred
3. **Check issues** - No critical unfixed bugs
4. **Minimal dependencies** - Avoid unnecessary packages
5. **Use platform-agnostic** - Prefer pure Dart over Flutter-specific
6. **Firebase ecosystem priority** - When choosing between similar packages, prioritize Firebase-compatible solutions
7. **Offline capability consideration** - Ensure packages work well with offline-first architecture

### 12.4 Prohibited Patterns
```dart
// ❌ BAD: Direct dependency on Firebase in presentation
class LoginScreen extends StatelessWidget {
  void login() {
    FirebaseAuth.instance.signInWithEmailAndPassword(...); // BAD
  }
}

// ✅ GOOD: Use abstraction through service/repository
class LoginScreen extends ConsumerWidget {
  void login() {
    ref.read(authRepositoryProvider).signIn(email, password); // GOOD
  }
}
```

---

## 13. Security Guidelines

### 13.1 Sensitive Data Handling
```dart
// ❌ NEVER: Log sensitive data
AppLogger.debug('User password: $password'); // BAD

// ✅ CORRECT: Log only non-sensitive information
AppLogger.debug('Login attempt for: $email'); // GOOD

// ✅ CORRECT: Use secure storage for tokens
class SecureStorage {
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}

// ✅ CORRECT: Properly handle Firebase authentication tokens
Future<String?> getIdToken() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return await user.getIdToken();
  }
  return null;
}
```

### 13.2 Authentication Best Practices
```dart
// Use Firebase Auth for user authentication
Future<User?> getCurrentUser() async {
  return FirebaseAuth.instance.currentUser;
}

// Validate session on app start
void validateSession() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // User not authenticated, redirect to login
  }
}

// Properly handle auth state changes
Stream<User?> get authStateChanges => FirebaseAuth.instance.authStateChanges();
```

### 13.3 Data Validation
```dart
// Client-side validation with Firebase security rules
class ContactValidator {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.length > 100) {
      return 'Name must be less than 100 characters';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Bangladesh phone validation
    final bangladeshiPhone = RegExp(r'^(\+880|0)?1[3-9]\d{8}$');
    if (!bangladeshiPhone.hasMatch(value)) {
      return 'Invalid Bangladesh phone number';
    }
    return null;
  }
}

// Server-side validation via Firestore Security Rules is mandatory
// All client-side validation must be duplicated in Firestore rules
```

### 13.4 Security Checklist
- [ ] No hardcoded API keys (use environment variables)
- [ ] Sensitive data encrypted at rest (Isar encryption)
- [ ] HTTPS only for API calls
- [ ] Input validation on all user inputs
- [ ] Output validation and sanitization
- [ ] Output encoding to prevent XSS
- [ ] Secure token storage (flutter_secure_storage)
- [ ] No sensitive data in logs
- [ ] Biometric authentication for sensitive operations
- [ ] Proper Firebase security rules implemented for all collections
- [ ] Client-side validation duplicated in Firestore rules
- [ ] Authentication state properly handled with Firebase listeners

---

## Quick Reference

### Command Reference
```bash
# Run app
flutter run

# Generate code (Riverpod, Freezed)
dart run build_runner build --delete-conflicting-outputs

# Clean and rebuild
flutter clean && flutter pub get

# Run tests
flutter test --coverage

# Format code
flutter format .

# Analyze code
flutter analyze

# Run integration tests
flutter test integration_test/

# Check for outdated dependencies
flutter pub outdated
```

### File Location Quick Guide
| What | Where |
|------|-------|
| New feature module | `lib/src/features/[feature_name]/` |
| Global utility | `lib/src/core/utils/` |
| Reusable widget | `lib/src/core/widgets/` |
| Theme configuration | `lib/src/core/theme/` |
| Route configuration | `lib/src/core/router/routes.dart` |
| API service | `lib/src/core/services/` |
| Entity model | `lib/src/features/[feature]/domain/entities/` |
| Repository | `lib/src/features/[feature]/data/repositories/` |
| Screen widget | `lib/src/features/[feature]/presentation/screens/` |
| State provider | `lib/src/features/[feature]/presentation/providers/` |

---

## Enforcement

These rules are **mandatory** for all code contributions to the Mobile Wallet BD project. Violations may result in:
1. Pull request rejection
2. Code review feedback requiring changes
3. Technical debt tracking

**Exception Process**: To request an exception to any rule, document the reasoning in the pull request description and get approval from a senior team member.

---

**Document Maintainer**: Development Team  
**Last Updated**: January 29, 2026  
**Next Review**: March 2026
