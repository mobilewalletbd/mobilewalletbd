# 🎯 SMART CONTACT WALLET — NEXT STEPS PLAN
**Last Updated**: February 23, 2026  
**Overall Progress**: ~87% Complete  
**Current Phase**: Wallet Simulation (Phase 11) + Dashboard Polish

> **Legend**: ✅ DONE | 🔄 IN PROGRESS | ❌ TODO | ⏳ PARTIAL

---

## 📊 CURRENT STATUS ANALYSIS (Feb 23, 2026)

### ✅ Dashboard Issues — ALL CRITICAL ISSUES RESOLVED
| # | Issue | Status |
|---|-------|--------|
| 1 | TopBar different from body background | ✅ FIXED — AppBar: #1A1F36, Body: #F5F5F7 |
| 2 | "Welcome Back, UserName" text | ✅ FIXED — Shows "Dashboard" title only |
| 3 | Contact section layout | ✅ FIXED — Professional 2-column grid, aspect 0.75 |
| 4 | FAB consolidation | ✅ FIXED — Single centerDocked FAB in BottomNavShell |
| 5 | Profile image display | ⏳ NEEDS REAL-DEVICE TEST — code is correct (ClipOval + errorBuilder) |

**Remaining dashboard work**: Implement FAB fan menu (Scan / Add / QR / Import)

---

## ✅ COMPLETED PHASES — FULL STATUS

### Phase 0–3: Infrastructure, Auth, UI ✅ DONE
- [x] Firebase integration (Auth + Firestore + Storage)
- [x] Isar local database (11 schemas)
- [x] Riverpod 2.x, GoRouter, Material Design 3 theme
- [x] 10 authentication screens (Email, Phone OTP, Google Sign-In)
- [x] Session management + AES-256 security + biometric PIN

### Phase 4: Database & Offline Sync ✅ DONE
- [x] 11 Isar schemas, Firestore collections, sync queue

### Phase 5: Session & Security ✅ DONE
- [x] Token refresh (50-min), auto-logout, secure storage, biometric, PIN lockout

### Phase 6: Dashboard ✅ DONE
- [x] Professional home screen, category tabs, stats, FAB

### Phase 7: Testing ✅ DONE
- [x] 67 test cases (auth entity 45, login 8, register 10, home 4)

### Phase 8: Contact Management ✅ DONE
- [x] Full CRUD, Isar+Firestore offline-first, 15+ Riverpod providers
- [x] Phone import (flutter_contacts), batch creation, duplicate detection
- [x] All contact screens (list, add, edit, detail, import)

### Phase 9: Business Card Scanning ✅ 98% DONE
- [x] Google ML Kit OCR (multi-script: EN/BN/AR/CN/JP/KR/Devanagari)
- [x] Advanced duplicate detection (Levenshtein, composite scoring, merge sheet)
- [x] Cloudinary JPEG upload + thumbnail generation
- [x] Enhanced regex: fax mitigation, obfuscated emails, BD phone patterns (Feb 23)
- [x] Barcode/QR detection and vCard QR parsing
- [x] Auto-save for >80% confidence scans
- ❌ **Remaining**: Scan history screen, batch scan

### Phase 10: Digital Card Creator ✅ DONE
- [x] 15 professional templates (6 categories, 2 premium)
- [x] Dynamic card editor (template/theme/fields tabs, live preview)
- [x] Pattern engine: dots, grid, waves, lines, circles
- [x] Gradient support
- [x] QR Code service (vCard QR, PNG export, theme-colored)
- [x] vCard (.vcf) export + native share
- [x] PDF service (381 lines, printable, gradient-aware)
- [x] PNG/image sharing
- [x] Share options sheet (QR, vCard, PDF, NFC dialog, image)
- [x] Isar + Firestore sync, version history, publish/unpublish

### Phase 7-Extra: Settings & Teams ✅ 75% DONE
- [x] Settings screen (294 lines, all sections)
- [x] Edit Profile (photo via Cloudinary)
- [x] Account Settings (email/phone/password with re-auth)
- [x] Security (biometric toggle, privacy placeholders)
- [x] Team Collaboration (create, invite, share contacts/cards, manage)
- [x] Google Drive Backup & Restore (googleapis integration)

---

## 🚀 RECOMMENDED IMPLEMENTATION ROADMAP

### ▶️ WEEK 1–2: Wallet Simulation + Dashboard Final

#### Step 1: Dashboard FAB Fan Menu (0.5 days)
**File**: `lib/shared/presentation/widgets/bottom_nav_shell.dart`  
**Actions**:
- Implement animated Speed Dial or custom fan menu on FAB tap
- 4 options: Scan Card, Add Manually, My QR Code, Import from Phone

#### Step 2: Scan History Screen (1 day)
**File**: `lib/features/scanning/presentation/screens/scan_history_screen.dart` *(NEW)*  
**Requirements**:
- List of all scanned cards (front thumbnail + contact name + date)
- Search by name/company/phone
- Date range filter
- Tap to view extracted fields
- Link scan to existing contact

#### Step 3: Wallet Domain Layer (1 day)
**Files to Create**:
```
lib/features/wallet/domain/entities/wallet.dart
lib/features/wallet/domain/entities/wallet_transaction.dart
lib/features/wallet/domain/repositories/wallet_repository.dart
lib/features/wallet/data/datasources/local_wallet_datasource.dart
lib/features/wallet/data/repositories/wallet_repository_impl.dart
lib/features/wallet/presentation/providers/wallet_provider.dart
lib/features/wallet/presentation/providers/transaction_provider.dart
```

#### Step 4: Wallet Home Screen (2 days)
**File**: `lib/features/wallet/presentation/screens/wallet_home_screen.dart` *(REPLACE PLACEHOLDER)*  
**Requirements**:
- Virtual wallet card (credit card design, Primary Green #0BBF7D)
- Balance display: starts at ৳0.00, animated
- Quick stats (Total Sent / Received)
- Recent transactions mini-list (empty state)
- 4 action buttons: Add Money, Send, Receive, History

#### Step 5: Wallet Transaction Screens (3 days)
**Files to Create**:
```
lib/features/wallet/presentation/screens/add_money_screen.dart
lib/features/wallet/presentation/screens/send_money_screen.dart
lib/features/wallet/presentation/screens/receive_money_screen.dart
lib/features/wallet/presentation/screens/transaction_history_screen.dart
lib/features/wallet/presentation/screens/transaction_detail_screen.dart
```

---

### ▶️ WEEK 3–4: Notifications + Import Tools

#### Step 6: Firebase Cloud Messaging (FCM)
**Dependencies to add**: `firebase_messaging`, `flutter_local_notifications`  
**Files to Create**:
```
lib/features/notifications/domain/entities/notification.dart
lib/features/notifications/data/repositories/notification_repository_impl.dart
lib/features/notifications/presentation/screens/notification_center_screen.dart
lib/features/notifications/presentation/screens/notification_settings_screen.dart
```

#### Step 7: CSV / vCard Import
**File**: `lib/features/settings/presentation/screens/import_contacts_screen.dart` *(EXPAND)*  
- Column mapping UI
- Preview + duplicate detection
- Progress indicator

#### Step 8: Settings — PIN + Privacy
**Files to Create**:
```
lib/features/settings/presentation/screens/pin_management_screen.dart
lib/features/settings/presentation/screens/active_sessions_screen.dart
```

---

### ▶️ WEEK 5–6: Analytics + Localization

#### Step 9: Analytics Dashboard
**Dependencies**: `fl_chart`  
**Files to Create**:
```
lib/features/analytics/presentation/screens/analytics_dashboard_screen.dart
lib/features/analytics/presentation/screens/reports_screen.dart
lib/features/analytics/presentation/providers/analytics_provider.dart
```

#### Step 10: Localization
- Create `.arb` files (English + Bengali)
- Replace hardcoded strings
- Language switcher in Settings
- BDT (৳) number/currency formatting

---

### ▶️ WEEK 7–8: NFC + Digital Card Polish

#### Step 11: NFC Full Implementation (Optional)
**File**: `lib/features/digital_card/data/services/nfc_service.dart` *(IMPLEMENT)*  
**File**: `lib/features/digital_card/presentation/screens/nfc_share_screen.dart` *(NEW)*

#### Step 12: Digital Card UI Polish
- Card front/back flip animation on `my_digital_card_screen.dart`
- Version history display UI
- Share analytics (view/scan count tracking)

---

### ▶️ WEEK 9–10: Launch Preparation

#### Step 13: Code Quality
- Fix 158 lint warnings (avoid_print, withOpacity, deprecated APIs)
- Increase test coverage 40% → 80%
- Remove `azure_api_service.dart` stub
- Fix `manage_account_status_usecase.dart` Isar bug

#### Step 14: Performance
- Cold start < 1.5s
- 60 FPS scrolling verified on low-end device
- Pagination for >500 contacts
- DevTools memory audit

#### Step 15: App Store Prep
- Final app icon + splash screen
- Store screenshots (Android + iOS)
- Privacy Policy + Terms of Service
- Android APK/AAB signing
- TestFlight + Play Store submission
- Firebase Crashlytics + Performance

---

## 📦 DEPENDENCIES TO ADD (Future Steps)

```yaml
# Notifications
firebase_messaging: ^14.0.0
flutter_local_notifications: ^16.0.0

# Charts (Analytics)
fl_chart: ^0.66.0

# Additional (if needed)
image_cropper: ^5.0.0   # Profile photo crop
```

---

## 🗓️ TIMELINE SUMMARY

```
WEEK 1-2:   Dashboard FAB Menu + Scan History + Wallet (Domain + Screens)
WEEK 3-4:   Notifications (FCM) + Import/Export Tools + Settings (PIN, Privacy)
WEEK 5-6:   Analytics Dashboard + Localization (EN/BN)
WEEK 7-8:   NFC Full + Digital Card UI Polish
WEEK 9-10:  Code Quality + Performance + App Store Submission
TARGET:     V1.0 LAUNCH → April–May 2026
```

---

## 📝 IMPLEMENTATION NOTES

- All code follows **Clean Architecture** (Domain / Data / Presentation)
- State management: **Riverpod 2.x** with code generation
- Database: **Isar** offline-first, **Firestore** cloud sync
- Design: **Primary Green #0BBF7D**, Inter font, 8px grid, Material Design 3
- Offline-first: All screens must show cached data from Isar before Firestore load
- Error handling: Use `Either<Failure, T>` from `fpdart`

**Last Updated**: February 23, 2026  
**Managed by**: Mobile Wallet BD Development Team
