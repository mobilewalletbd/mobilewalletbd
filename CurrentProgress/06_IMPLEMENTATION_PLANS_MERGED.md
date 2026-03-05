# 📋 MERGED IMPLEMENTATION PLANS — ALL PHASES
**Sources Merged**: `NEXT_STEPS_PLAN.md`, `DIGITAL_CARD_PHASE_PROGRESS.md`, `missing_features_audit.md`, `current.txt`, `incompletedTask.txt`, Brain Artifacts
**Last Updated**: February 23, 2026

---

## PLAN A — Phases 0–10 (COMPLETED ✅)

> All these entries represent work that has already been implemented.

### Phase 0: Infrastructure
- [x] Flutter project, Firebase, Isar, Cloudinary, Riverpod, GoRouter

### Phase 1: Core Services
- [x] SessionManager, SecurityService, FirestoreService, CloudinaryService (with compression)
- [x] 11 Isar schemas, sync queue, offline-first architecture

### Phase 2: Authentication
- [x] Email/Password, Phone OTP, Google Sign-In
- [x] 10 auth screens, auth guards in router

### Phase 3: Design System
- [x] Primary Green #0BBF7D, Inter font, 8px grid, full color palette

### Phase 4: Database Integration
- [x] 11 Isar schemas, Firestore collections, conflict resolution

### Phase 5: Security
- [x] AES-256, biometric, PIN, session auto-expiry

### Phase 6: Dashboard
- [x] Home with 2-column contact grid, category tabs, consolidated FAB, Deep Blue AppBar

### Phase 7: Testing
- [x] 67 test cases (Auth entity 45, Login 8, Register 10, Home 4)

### Phase 8: Contact Management
- [x] Full CRUD, Isar+Firestore sync, phone import, batch operations
- [x] 15+ Riverpod providers, all contact screens

### Phase 9: Business Card Scanning
- [x] ML Kit OCR v1 (Core), EnhancedOcrService (multi-language, QR, confidence)
- [x] DuplicateDetectionService (Levenshtein, composite scoring, merge sheet)
- [x] Advanced regex (Feb 23, 2026): fax mitigation, obfuscated emails, URL detection
- [x] Cloudinary image upload + thumbnails

### Phase 10: Digital Card Creator
- [x] 15 templates, CardTemplate entity (patterns, gradients, premium flag)
- [x] Full editor with tab-based UX (Template / Theme / Fields)
- [x] QR Code, vCard (.vcf), PDF, PNG export + share sheet
- [x] Pattern painter engine (dots, grid, waves, lines, circles)
- [x] Cloud sync (Firestore), version history

### Phase 7-Extra: Settings & Collaboration
- [x] EditProfile, AccountSettings (email/phone/password), SecuritySettings (biometric)
- [x] TeamDetails, CreateTeam, share contacts/cards with teams
- [x] Google Drive backup & restore (backup_repository.dart + google_drive_service.dart)

---

## PLAN B — Near-Term ACTIVE WORK

> Items to implement in the next 1–3 weeks.

### B1: Dashboard Final Polish
- [ ] Verify profile image renders from Firebase/Cloudinary with real user
- [ ] Implement FAB fan menu with 4 actions (Scan, Add, QR, Import)

### B2: Scan History Screen (Phase 9 remaining 2%)
- [ ] Build `scan_history_screen.dart`
- [ ] List scanned cards with thumbnails + timestamps
- [ ] Filter by date, search by name/company
- [ ] Re-link scan to an existing contact
- [ ] Batch scan UI (future)

### B3: Begin Wallet Simulation (Phase 11)
- [ ] Implement wallet domain entities + repository
- [ ] Build `wallet_home_screen.dart` (real content)
- [ ] Build `send_money_screen.dart` (contact picker + amount)
- [ ] Build `transaction_history_screen.dart`
- [ ] Add "Pay" button on ContactDetailsScreen

---

## PLAN C — Medium-Term FUTURE WORK

> Items for weeks 4–8. Not yet started.

### C1: Notifications System
- [ ] FCM integration + local notifications
- [ ] NotificationCenter screen
- [ ] Notification settings (per-category toggles)
- [ ] Triggers: team invite, card view, backup complete

### C2: Import/Export Tools
- [ ] CSV, vCard bulk import with preview + duplicate flag
- [ ] Export all contacts as CSV / vCard / PDF report
- [ ] Scheduled recurring export

### C3: Advanced Settings: PIN + Privacy
- [ ] PIN management screen (set/change/disable)
- [ ] "Who can see my card" visibility toggle
- [ ] "Who can import my contacts" toggle
- [ ] Active sessions screen (logout from other devices)

### C4: Localization (English + Bengali)
- [ ] Create `.arb` files
- [ ] Replace hardcoded strings with `AppLocalizations`
- [ ] Language switcher in Settings
- [ ] BDT (৳) currency formatting

### C5: Analytics Dashboard
- [ ] Contact count with monthly growth delta
- [ ] Source breakdown chart (manual/scan/import)
- [ ] Contact engagement metrics
- [ ] Monthly activity report (PDF)

### C6: NFC Full Implementation
- [ ] Write vCard to NFC tag (Android)
- [ ] NFC Share Screen with "Tap phones" animation
- [ ] iOS Core NFC read-only flow

---

## PLAN D — Launch Preparation (Weeks 9–10)

- [ ] Firebase Crashlytics integration
- [ ] Performance profiling (cold start < 1.5s, 60 FPS)
- [ ] App icon (1024×1024 + adaptive)
- [ ] Splash screen branding animation
- [ ] Privacy Policy + Terms of Service pages
- [ ] App store screenshots (Android + iOS sizes)
- [ ] Android signing + Play Store submission
- [ ] iOS provisioning + TestFlight + App Store submission
- [ ] Fix all 158+ lint warnings
- [ ] Reach 80% test coverage target

---

## RECOMMENDED IMPLEMENTATION ORDER

```
WEEK 1-2:   Dashboard polish + Scan History + Wallet Shell
WEEK 3-4:   Wallet transaction flows (Send/Receive/History)
WEEK 5-6:   Notifications (FCM) + Import/Export Tools
WEEK 7:     Analytics Dashboard + Advanced Settings (PIN, Privacy)
WEEK 8:     Localization (EN/BN) + NFC completion
WEEK 9-10:  Launch Prep (icons, store assets, Crashlytics)
TARGET:     V1 Launch → April–May 2026
```
