# Copilot Instructions for Mobile Wallet BD

**Project**: Smart Contact Wallet (Flutter Mobile App)  
**Architecture**: Feature-First Clean Architecture with Riverpod  
**Backend**: Firebase-first with Isar local cache (offline-first)

## Architecture Overview

### The "Big Picture"
This is a **Feature-First Clean Architecture** app where code is organized by what it does (features) rather than what it is (layers). Each feature module (`auth/`, `contacts/`, `wallet/`, etc.) independently contains **Domain** (business logic), **Data** (database/API access), and **Presentation** (UI/state) layers. A shared `core/` module provides infrastructure used across all features.

**Critical Data Flow Pattern** (Offline-First):
```
User Action → Isar Local Update (immediate UI response) 
         → Queue for Firebase Sync → Background Service Syncs to Firestore
```
This means **writes always go to Isar first for instant feedback**, then sync asynchronously to Firebase. Read [DEVELOPMENT_RULES.md](DEVELOPMENT_RULES.md) sections 1-6 for complete architecture details.

### Directory Structure Rules
```
lib/
├── core/                     # Shared infrastructure
│   ├── config/              # App config, env variables
│   ├── services/            # Firebase, Isar, Cloudinary, Session
│   ├── router/              # GoRouter with auth guards
│   ├── security/            # Security service, encryption
│   ├── theme/               # Colors, typography
│   └── database/            # Isar schema definitions
├── features/                # Feature modules (auth, contacts, wallet, etc.)
│   └── [feature]/
│       ├── data/            # Datasources (local/remote), repositories, DTOs
│       ├── domain/          # Entities, abstract repositories, use cases
│       └── presentation/    # Screens, widgets, controllers, providers
└── shared/                  # Composed widgets used across features
```

**Critical Rules**:
- **One public class per file** (exceptions: private helpers, part files)
- **Feature-specific code stays in the feature** - don't leak to core/shared
- **Core is for infrastructure only** - services, config, theme, widgets (not business logic)

## Key Patterns & Conventions

### State Management (Riverpod)
- Use **`@riverpod` annotation** (modern, auto-generated providers) for new code
- Use `ref.watch()` in UI for reactive data; use `ref.read()` for one-time actions
- Use `AsyncValueWidget<T>` helper to handle loading/error/data states
- Keep providers `const` when possible; use `keepAlive: true` for persistent state (auth, config)
- Name providers descriptively: `userProfileProvider`, `authControllerProvider`, `contactsProvider`

**Example**:
```dart
@riverpod
class ContactController extends _$ContactController {
  @override
  Future<List<Contact>> build() async {
    final repo = ref.watch(contactRepositoryProvider);
    return repo.getContacts();
  }
}
```

### Database Patterns
- **Isar**: Local database for caching and offline-first data. All writes go here first.
- **Firestore**: Remote source of truth. Synchronized from Isar in background.
- Use transactions in Isar: `await isar.writeTxn(() async { ... })`
- Always query Isar for reads; it syncs with Firestore asynchronously
- Add indexes to frequently queried Isar fields: `@Index()` on `globalContactId`, `ownerId`

**Important**: Images (contacts' business cards) are stored locally in Isar for immediate access; cloud storage uses Cloudinary (`imageFrontPublicId`, `imageBackPublicId` fields).

### Error Handling
- Create feature-specific `Failure` classes (e.g., `AuthFailure`, `ContactFailure`)
- **Repository layer**: Transform Firebase exceptions into Failure objects
- **UI layer**: Use Riverpod's `AsyncValue.when()` to handle loading/error/data
- Never log sensitive data (passwords, tokens, PII); use `AppLogger` with tags

**Pattern**:
```dart
try {
  return await _firebaseAuth.signIn(...);
} on FirebaseAuthException catch (e) {
  throw AuthFailure(_mapError(e.code));
}
```

### Naming Conventions
| Item | Style | Examples |
|------|-------|----------|
| Files | `snake_case` | `contact_repository.dart` |
| Classes | `PascalCase` | `ContactRepository`, `AuthUser` |
| Variables/Functions | `camelCase` | `isLoading`, `getUser()` |
| Booleans | Start with `is/has/should` | `isAuthenticated`, `hasError` |
| Providers | Nouns + Provider suffix | `userProfileProvider`, `contactsProvider` |
| Controllers | Feature + Controller | `AuthController`, `ContactController` |
| Use Cases | Verb + Noun | `GetContactUseCase`, `CreateContactUseCase` |

### File Naming by Layer
- **Entity/Model**: `[name].dart` → `contact.dart`
- **Repository Interface**: `[feature]_repository.dart` → `contact_repository.dart`
- **Repository Impl**: `[feature]_repository_impl.dart`
- **Data Source**: `[type]_[feature]_datasource.dart` → `local_contact_datasource.dart`, `remote_contact_datasource.dart`
- **DTO**: `[feature]_dto.dart`
- **Screen/Widget**: `[feature]_screen.dart`, `contact_card.dart`
- **Provider**: `[feature]_provider.dart`

## Feature Implementation Workflow

When creating a new feature, follow this checklist:

1. **Create directory structure** in `lib/features/[feature_name]/` with `data/`, `domain/`, `presentation/`
2. **Define domain layer first**:
   - Entity (immutable, @freezed): `lib/features/[feature]/domain/entities/[feature].dart`
   - Repository interface (abstract): `lib/features/[feature]/domain/repositories/[feature]_repository.dart`
   - Failures (sealed/enum): `lib/features/[feature]/domain/failures/[feature]_failure.dart`
   - Use cases (optional, if complex logic)

3. **Implement data layer**:
   - Local datasource (Isar queries): `lib/features/[feature]/data/datasources/local_[feature]_datasource.dart`
   - Remote datasource (Firestore): `lib/features/[feature]/data/datasources/remote_[feature]_datasource.dart`
   - DTO with serialization: `lib/features/[feature]/data/dtos/[feature]_dto.dart`
   - Repository implementation: `lib/features/[feature]/data/repositories/[feature]_repository_impl.dart`

4. **Implement presentation layer**:
   - Provider: `lib/features/[feature]/presentation/providers/[feature]_provider.dart` (using @riverpod)
   - Screen: `lib/features/[feature]/presentation/screens/[feature]_screen.dart`
   - Widgets: `lib/features/[feature]/presentation/widgets/[feature]_card.dart`, etc.

5. **Add route** to `lib/core/router/app_router.dart`

6. **Add tests** for repository, domain logic, and critical UI flows

## Critical Services & Integration Points

### Firebase Integration
- **Firebase Auth**: Handles user authentication, phone verification, OAuth (Google Sign-In)
- **Firestore**: Real-time backend database; every write to Isar syncs here
- **Firebase Cloud Storage**: Not heavily used; Cloudinary preferred for images

**Access**: Via `ref.read(firebaseAuthServiceProvider)`, `ref.read(firestoreServiceProvider)`

### Isar Local Database
- Initialized in `main()` via `IsarService.initialize()`
- Schema definitions in `lib/core/database/` (@collection annotated classes)
- Always use transactions for writes: `await isar.writeTxn(() async { ... })`
- Used for offline-first capability and as cache layer

### Cloudinary Image Storage
- Remote storage for shareable contact images
- Store public IDs in Isar entities: `imageFrontPublicId`, `imageBackPublicId`
- Accessed via `ref.read(cloudinaryServiceProvider)`

### Security & Session Management
- Encrypted local storage via `flutter_secure_storage`
- Session tokens managed by `SessionManager` (initialized in `main()`)
- Auth state changes watched via `FirebaseAuth.authStateChanges`

## Development Commands

```bash
# Generate code (freezed, riverpod, json_serializable)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes during development
flutter pub run build_runner watch

# Run app
flutter run

# Run tests
flutter test

# Run specific test file
flutter test test/features/auth/domain/entities/auth_user_test.dart

# Check code quality
flutter analyze

# Format code
dart format lib/ --line-length 100
```

## Common Pitfalls to Avoid

1. **Don't skip Isar writes** - Always write to local database first for offline-first guarantees
2. **Don't mix features** - Keep feature logic in the feature module; shared code goes to core/shared
3. **Don't forget to handle AsyncValue states** - Always use `.when()` to handle loading/error/data in UI
4. **Don't create utility files at project root** - Put utilities in `core/utils/`
5. **Don't log sensitive data** - Never print passwords, tokens, or PII; use `AppLogger`
6. **Don't ignore platform-specific code** - Android/iOS have different permissions; test on both
7. **Don't make Firestore calls without Isar sync** - All remote changes should flow through local cache

## Important Files Reference

- **Architecture docs**: [DEVELOPMENT_RULES.md](DEVELOPMENT_RULES.md) (comprehensive 1000+ line guide)
- **App theme & colors**: [lib/core/theme/app_theme.dart](lib/core/theme/app_theme.dart)
- **Router config**: [lib/core/router/app_router.dart](lib/core/router/app_router.dart)
- **Firebase setup**: [lib/firebase_options.dart](lib/firebase_options.dart)
- **Main entry**: [lib/main.dart](lib/main.dart)
- **Feature example**: [lib/features/contacts/](lib/features/contacts/) (complete feature module)

---

**Last Updated**: January 31, 2026  
**Maintainer**: Mobile Wallet BD Team
