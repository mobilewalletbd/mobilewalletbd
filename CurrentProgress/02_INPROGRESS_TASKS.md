# 🔄 IN-PROGRESS TASKS — CURRENT WORK
**Last Updated**: February 23, 2026

---

## 1. Business Card Scanning V2 — Advanced OCR (98% Complete)

### ✅ Done
- [x] ML Kit multi-language support (Latin, Bengali, Arabic, Chinese, Devanagari, Japanese, Korean)
- [x] Enhanced confidence scoring (block/line level)
- [x] Auto-save for high-confidence scans (>80%)
- [x] Barcode/QR detection from business cards
- [x] vCard-format QR parsing (`_extractContactFromBarcode`)
- [x] Advanced duplicate detection (Levenshtein, token reordering)
- [x] Phone normalization: +880 BD support in duplicate check
- [x] Email domain comparison (excludes gmail.com, yahoo.com, etc.)
- [x] Company name similarity matching (suffix stripping)
- [x] Composite duplicate score: Name 35%, Phone 30%, Email 20%, Company 15%
- [x] `merge_suggestion_sheet.dart` UI for merge prompts
- [x] **Advanced Regex upgrade** (Feb 23, 2026):
  - Fax number mitigation (excluded from phone fields if detected as Fax line)
  - Obfuscated email parsing (`john at company dot com` → `john@company.com`)
  - Comprehensive website regex (catches domain-only URLs, filters emails)
  - BD mobile/landline pattern refinement (`+880`, `01x`, `88-01x`)
  - International phone fallback with digit range validation (7–15 digits)

### ❌ Remaining (2%)
- [ ] **Scan History Screen** (`scan_history_screen.dart`)
  - List all previously scanned cards with thumbnails
  - Timestamps, card front/back preview
  - Filter by date range
  - Search by extracted name/company
  - Tap to view full extracted fields
  - Option to re-link scan to an existing contact
- [ ] **Scan Retry & Edit**
  - Allow re-scanning of problematic/blurry cards
  - Batch scan: scan multiple cards in one camera session
  - Rescan with different lighting or angle guidance
- [ ] **Multi-Script UI hints**
  - Show detected script type in preview (e.g., "Bengali text detected")
  - Per-field confidence coloring (green/amber/red)

---

## 2. Dashboard UX Polish (80% Complete)

### ✅ Done (resolved per NEXT_STEPS_PLAN.md)
- [x] TopBar styling: AppBar uses Deep Blue `#1A1F36`, body uses Off-White `#F5F5F7`
- [x] "Welcome Back, UserName" text removed — AppBar shows "Dashboard" only
- [x] Contact section: Professional 2-column grid, shadows, borders, aspect ratio 0.75
- [x] FAB consolidated to BottomNavShell (single `centerDocked` FAB)
- [x] Front/Back toggle pills on contact cards

### ❌ Remaining (20%)
- [ ] **Profile Image Display**: Validate that `user.photoUrl` from Firebase loads correctly in UI
  - Code uses `ClipOval` + `Image.network` with `errorBuilder` → falls back to initials
  - **Action**: Run with real user account to confirm image renders from Cloudinary/Firebase Storage
- [ ] **FAB Fan Menu**: Implement expansion menu when FAB is tapped:
  - "Scan Card" → `/contacts/scan`
  - "Add Manually" → `/contacts/add`
  - "My QR Code" → digital card QR screen
  - "Import from Phone" → `/contacts/import`

---

## 3. Phase 7-Extra: Settings Remaining (25% remaining)

### Account Settings
- [ ] Verify new email OTP flow (Firebase handles, but needs UI confirmation message)
- [ ] Change phone OTP verification UI flow (currently re-auth only)

### Privacy Settings
- [ ] PIN Set/Change screen (`pin_management_screen.dart`)
- [ ] PIN strength validation
- [ ] "Who can see my card" — privacy toggle for contact visibility
- [ ] "Who can import my contacts" — import control toggle
- [ ] View active sessions (logout from other devices)

### Team Collaboration
- [ ] Team profile picture upload
- [ ] Team member search (currently email/phone only)

### Profile
- [ ] Crop/resize photo after selection (low priority)

---

## 4. Localization / i18n (20% Complete)

### ✅ Done
- [x] `intl` package added as dependency
- [x] Bengali (Bangla) designated as primary locale
- [x] English as secondary locale
- [x] Initial pass at UI string identification

### ❌ Remaining
- [ ] Create `.arb` files for English and Bengali
- [ ] Replace hardcoded strings with `AppLocalizations` calls
- [ ] Dynamic language switching (in-app settings)
- [ ] Persist language preference to `AppSettingsIsar`
- [ ] Number formatting (e.g., BDT currency `৳`)
- [ ] Date formatting (Bengali calendar vs. Gregorian)

---

## 5. NFC Sharing (Stubbed — Optional)

### ✅ Done
- [x] `nfc_service.dart` — NfcCardData model, NfcSessionState enum
- [x] NFC UI dialogs in share_options_sheet
- [x] `nfc_manager` dependency in pubspec.yaml

### ❌ Remaining
- [ ] Implement write vCard data to NFC tag (currently throws error)
- [ ] Test NFC readability on standard Android device
- [ ] iOS Core NFC support (read-only mode)
- [ ] User-friendly "Tap phones" animation
