# ❌ PENDING TODO TASKS — FULL LIST
**Last Updated**: February 23, 2026

---

## PHASE 11: Internal Wallet / Bookkeeping Simulation (5% → TODO)

> ⚠️ **SIMULATION ONLY** — No real money, no bKash/Nagad/Rocket API. All data stored locally in Isar.

### 11.1 Domain Layer
- [ ] `lib/features/wallet/domain/entities/wallet.dart`
  - Fields: id, userId, balance (BDT), currency, lastUpdated
- [ ] `lib/features/wallet/domain/entities/wallet_transaction.dart`
  - Fields: id, walletId, type (CREDIT/DEBIT/TRANSFER), amount, counterpartyId, timestamp, status (PENDING/COMPLETED/FAILED), description
- [ ] `lib/features/wallet/domain/repositories/wallet_repository.dart`
  - Methods: getWallet, updateBalance, addTransaction, getTransactions, getTransactionById

### 11.2 Data Layer
- [ ] `lib/features/wallet/data/datasources/local_wallet_datasource.dart`
  - Isar queries for WalletIsar and WalletTransactionIsar (schemas already exist)
- [ ] `lib/features/wallet/data/repositories/wallet_repository_impl.dart`
  - Implement all repository interface methods

### 11.3 Presentation — Providers
- [ ] `lib/features/wallet/presentation/providers/wallet_provider.dart`
  - WalletNotifier managing balance state
- [ ] `lib/features/wallet/presentation/providers/transaction_provider.dart`
  - Transaction list, filters, search

### 11.4 Presentation — Screens (all new)
- [ ] `lib/features/wallet/presentation/screens/wallet_home_screen.dart` (**currently placeholder**)
  - Virtual wallet card UI (credit card design)
  - Display balance (starts at ৳0.00)
  - Quick stats: Total Sent, Total Received
  - Recent transactions mini-list
  - Quick action buttons (Add, Send, Receive, History)
- [ ] `lib/features/wallet/presentation/screens/add_money_screen.dart`
  - Demo-only: adds amount to local balance instantly
  - Amount input with Bengali Taka (৳) symbol
  - Confirmation dialog
- [ ] `lib/features/wallet/presentation/screens/send_money_screen.dart`
  - Contact selection from existing contacts list
  - Amount input with balance validation
  - Note/message field (optional)
  - Send button with confirmation dialog
  - Success animation screen
- [ ] `lib/features/wallet/presentation/screens/receive_money_screen.dart`
  - Display wallet QR code (wallet ID encoded)
  - Show account number / wallet ID for sharing
  - Share payment request link
  - View pending incoming requests
- [ ] `lib/features/wallet/presentation/screens/transaction_history_screen.dart`
  - Full list of all transactions (Sent / Received)
  - Filter by type (Sent/Received), date range, contact
  - Search by contact name or description
  - Paginated list with LazyLoading
- [ ] `lib/features/wallet/presentation/screens/transaction_detail_screen.dart`
  - Full transaction view (amount, date, contact, status, description)
  - Receipt view / PDF download option

### 11.5 Presentation — Widgets (all new)
- [ ] `lib/features/wallet/presentation/widgets/wallet_card_widget.dart` — Credit card design
- [ ] `lib/features/wallet/presentation/widgets/transaction_list_item.dart` — Icon, name, amount, date
- [ ] `lib/features/wallet/presentation/widgets/balance_display.dart` — ৳ symbol, animated balance
- [ ] `lib/features/wallet/presentation/widgets/amount_input.dart` — Numeric keypad, BDT format

### 11.6 Routes to Add
- [ ] `/wallet` — WalletHomeScreen
- [ ] `/wallet/add` — AddMoneyScreen
- [ ] `/wallet/send` — SendMoneyScreen
- [ ] `/wallet/receive` — ReceiveMoneyScreen
- [ ] `/wallet/history` — TransactionHistoryScreen
- [ ] `/wallet/transaction/:id` — TransactionDetailScreen

### 11.7 Business Logic Rules
- [ ] Validate: balance cannot go below ৳0 (show error)
- [ ] Transaction atomicity: deduct sender, log record in same operation
- [ ] Contextual "Pay" button on ContactDetailsScreen → pre-fills SendMoney with that contact

### Testing Checkpoints
- [ ] Initial balance is ৳0.00
- [ ] "Add Money" increases balance
- [ ] "Send Money" decreases sender balance
- [ ] Transaction appears in history after send
- [ ] Filter by date range works
- [ ] Search finds transactions by contact name
- [ ] Negative balance prevented with validation error
- [ ] Transaction detail shows all fields correctly

---

## SETTINGS REMAINING TASKS

### PIN Management
- [ ] `pin_management_screen.dart` — Set/Change/Disable PIN
- [ ] PIN strength indicator (4–6 digit)
- [ ] PIN entry screen at app open (if PIN is enabled)

### Privacy Advanced
- [ ] "Who can see my card" toggle (Public/Contacts Only/Private)
- [ ] "Who can import my contacts" toggle
- [ ] Blocked users management screen

### Session Management
- [ ] View active sessions list
- [ ] "Logout from all other devices" action

---

## IMPORT / EXPORT TOOLS (Phase 7.6)

### Import Features
- [ ] Import contacts from CSV file
- [ ] Import contacts from Excel (.xlsx)
- [ ] Import contacts from vCard (.vcf) bulk file
- [ ] Bulk import with progress indicator (% and count)
- [ ] Column mapping UI for CSV imports
- [ ] Duplicate detection on import (flag, skip, merge options)
- [ ] Preview first 10 rows before committing import

### Export Features
- [ ] Export all contacts as CSV (comma-separated)
- [ ] Export contacts as vCard bulk (.vcf)
- [ ] Export contacts as formatted PDF report
- [ ] Schedule recurring export (daily/weekly/monthly)
- [ ] Email export to user's own email

---

## NOTIFICATIONS SYSTEM (Phase 7.8) — 0% Complete

### Infrastructure
- [ ] Firebase Cloud Messaging (FCM) setup
  - `firebase_messaging` package
  - Android: `google-services.json` already configured
  - iOS: APNs certificate needed
- [ ] Local notifications package (`flutter_local_notifications`)
- [ ] Notification permission request on first run
- [ ] Background message handler

### Notification Types to Implement
- [ ] "A contact added you" push notification
- [ ] "Team invitation received" push
- [ ] "Money received" push (Wallet)
- [ ] "Card viewed X times" digest push
- [ ] "Backup successful / failed" local notification
- [ ] "Import completed" local notification

### Notification Center Screen (new)
- [ ] `lib/features/notifications/presentation/screens/notification_center_screen.dart`
  - Full list of all notifications (oldest to newest)
  - Unread badge indicator per notification
  - Mark as read / Mark all as read
  - Delete individual notification
  - Clear all notifications
  - Tap notification to navigate to relevant screen

### Notification Settings Screen
- [ ] `lib/features/notifications/presentation/screens/notification_settings_screen.dart`
  - Enable/disable push notifications globally
  - Per-category toggle (Money, Teams, Contacts, Cards)
  - Notification sound toggle
  - Vibration toggle
  - Quiet hours schedule

---

## ANALYTICS DASHBOARD (Phase 7.7) — 0% Complete

### Analytics Screen
- [ ] `lib/features/analytics/presentation/screens/analytics_dashboard_screen.dart`
  - Total contacts count (with growth delta: "↑ 12 this month")
  - Contact source breakdown (manual / scanned / imported / NFC)
  - Most contacted people (top 5 list)
  - Contact engagement metrics (edits, views)
  - Contact growth chart over time (line chart, last 6 months)
  - Category distribution pie chart (Business/Friends/Family)

### Reports Screen
- [ ] `lib/features/analytics/presentation/screens/reports_screen.dart`
  - Monthly activity summary
  - Export report as PDF
  - Email report to user's email

### Required Packages (new)
- [ ] `fl_chart` or `syncfusion_flutter_charts` for charts

---

## APP STORE PREPARATION (Phase 12) — 0% Complete

### Documentation
- [ ] Privacy Policy document (web page + in-app link)
- [ ] Terms of Service document
- [ ] App store listing content (screenshots, description, keywords)

### App Branding
- [ ] Final app icon (1024×1024 PNG for iOS, adaptive icon for Android)
- [ ] Splash screen with brand animation
- [ ] Store screenshots (6.5" iPhone, 5.5" iPhone, 12.9" iPad, Android sizes)

### Release Builds
- [ ] Android: `key.jks` signing configured in `build.gradle`
- [ ] Android: Release APK/AAB build
- [ ] iOS: App ID, provisioning profile, distribution certificate
- [ ] iOS: TestFlight distribution for beta

### Quality Checks Before Submission
- [ ] Firebase Crashlytics integration (`firebase_crashlytics`)
- [ ] Performance monitoring (`firebase_performance`)
- [ ] App size optimization (tree-shaking, deferred loading)
- [ ] Accessibility audit: semantic labels, minimum touch targets (48dp)
- [ ] Zero-crash in 100 test sessions

### Deployment
- [ ] Google Play Store submission (closed testing first)
- [ ] Apple App Store submission
- [ ] Firebase Remote Config for feature flags
- [ ] Release notes / CHANGELOG.md

---

## PERFORMANCE & QUALITY (Ongoing)

### Performance Targets
- [ ] Cold start time < 1.5 seconds
- [ ] Smooth 60 FPS scrolling verified on low-end device
- [ ] Memory leak prevention (verified with DevTools)
- [ ] Image caching optimization (cached_network_image)
- [ ] Pagination for large contact lists (>500 contacts)
- [ ] Lazy loading for images in contact lists

### Database Optimization
- [ ] Index optimization for Isar queries
- [ ] Cursor-based pagination
- [ ] Query performance profiling

### UI/UX Polish
- [ ] Consistent transition animations between screens
- [ ] Loading skeleton states (shimmer) on all list screens
- [ ] Toast/snackbar animations for feedback
- [ ] Empty state illustrations (SVG or Lottie)
- [ ] Error state with retry button on all network screens
- [ ] Success animation after save/create actions

### Accessibility
- [ ] Semantic labels on all interactive widgets
- [ ] High contrast mode support
- [ ] Minimum touch target 48dp on all buttons
- [ ] Font scaling support (dynamic text sizes)
- [ ] Screen reader compatibility (TalkBack / VoiceOver)

### Code Quality
- [ ] Resolve ~158 lint warnings (avoid_print, deprecations)
- [ ] Replace all `withOpacity` with `.withValues(alpha: ...)`
- [ ] Replace `AutoDisposeProviderRef` with `Ref`
- [ ] Remove legacy `azure_api_service.dart` stub
- [ ] Add DartDoc comments to all public APIs
- [ ] Maintain CHANGELOG.md going forward
