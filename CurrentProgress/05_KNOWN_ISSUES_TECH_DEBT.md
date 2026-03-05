# 🐛 KNOWN ISSUES & TECHNICAL DEBT
**Last Updated**: February 23, 2026

---

## 🔴 HIGH PRIORITY

### 1. Profile Image Not Confirmed in Production
- Code uses `ClipOval + Image.network` with errorBuilder fallback to initials
- **Action**: Test with real Firebase user to confirm Cloudinary URL renders
- **Location**: `user_profile_header.dart`

### 2. FAB Fan Menu Not Implemented
- Consolidated FAB exists in `bottom_nav_shell.dart` but tap does nothing
- **Action**: Implement animated fan menu (Scan, Add, My QR, Import)

### 3. NFC Writing Disabled / Stubbed
- `nfc_service.dart` throws error on write attempts
- **Action**: Implement real NFC write + test on hardware

### 4. Wallet is a Placeholder
- `wallet_home_screen.dart` = 28 lines placeholder
- **Action**: Full Phase 11 implementation needed

---

## 🟡 MEDIUM PRIORITY

### 5. Lint Warnings (~158 total)
- `avoid_print` in scan_provider, ocr_preview_screen, scan_card_screen, backup_repository
- `AutoDisposeFutureProviderRef` → should be `Ref`
- `RadioListTile` `groupValue`/`onChanged` deprecated (Flutter 3.32+) → `RadioGroup`
- `use_build_context_synchronously` in account_settings_screen
- `withOpacity` → `.withValues(alpha:)` across many files
- **Fix**: Run `dart fix --apply` and update `fix_opacity.dart`

### 6. OTP Step Missing After Phone Change
- AccountSettings re-authenticates but no OTP UI shown post-phone-update

### 7. Session Manager — No Integration Tests (risk of token refresh regression)

### 8. Security Service — No Unit Tests (AES-256, biometric, PIN untested)

---

## 🟢 LOW PRIORITY

### 9. Legacy File: `lib/core/services/azure_api_service.dart` — Safe to delete

### 10. DartDoc Comments — Incomplete across public APIs

### 11. CHANGELOG.md — Not maintained

### 12. Code Coverage ~40% — Target is 80% before launch
- Missing: Contact repository tests, OCR field mapper tests, PDF service tests

### 13. `manage_account_status_usecase.dart` — Pre-existing Isar `findFirst()` API issue

---

## ⚠️ EXTERNAL RISKS

| Risk | Impact | Status |
|------|--------|--------|
| Firebase SMS OTP costs | Medium | Monitor |
| Cloudinary free tier (25GB/mo) | Medium | Monitor |
| NFC write not supported on iOS | High | Documented |
| Firebase Functions (for shareable links) | Low | V2 |
