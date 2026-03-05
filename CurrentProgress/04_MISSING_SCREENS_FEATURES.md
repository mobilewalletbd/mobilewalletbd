# 🚫 MISSING SCREENS & FEATURES AUDIT
**Last Updated**: February 23, 2026  
**Source**: `missing_features_audit.md`, `incompletedTask.txt`, conversation history

---

## NEW FILES TO CREATE (Never Existed)

### 💰 Wallet Module
| File Path | Description |
|-----------|-------------|
| `lib/features/wallet/domain/entities/wallet.dart` | Wallet domain entity |
| `lib/features/wallet/domain/entities/wallet_transaction.dart` | Transaction entity |
| `lib/features/wallet/domain/repositories/wallet_repository.dart` | Repository interface |
| `lib/features/wallet/data/datasources/local_wallet_datasource.dart` | Isar data source |
| `lib/features/wallet/data/repositories/wallet_repository_impl.dart` | Repository impl |
| `lib/features/wallet/presentation/providers/wallet_provider.dart` | State management |
| `lib/features/wallet/presentation/providers/transaction_provider.dart` | Transaction state |
| `lib/features/wallet/presentation/screens/add_money_screen.dart` | Add money (demo) |
| `lib/features/wallet/presentation/screens/send_money_screen.dart` | Send money flow |
| `lib/features/wallet/presentation/screens/receive_money_screen.dart` | Receive money / QR |
| `lib/features/wallet/presentation/screens/transaction_history_screen.dart` | Transaction list |
| `lib/features/wallet/presentation/screens/transaction_detail_screen.dart` | Detail view |
| `lib/features/wallet/presentation/widgets/wallet_card_widget.dart` | Card UI |
| `lib/features/wallet/presentation/widgets/transaction_list_item.dart` | List row |
| `lib/features/wallet/presentation/widgets/balance_display.dart` | Balance widget |
| `lib/features/wallet/presentation/widgets/amount_input.dart` | Amount keyboard |

### 🔔 Notifications Module
| File Path | Description |
|-----------|-------------|
| `lib/features/notifications/domain/entities/notification.dart` | Notification entity |
| `lib/features/notifications/domain/repositories/notification_repository.dart` | Interface |
| `lib/features/notifications/data/repositories/notification_repository_impl.dart` | Impl |
| `lib/features/notifications/presentation/screens/notification_center_screen.dart` | Full list |
| `lib/features/notifications/presentation/screens/notification_settings_screen.dart` | Settings |
| `lib/features/notifications/presentation/providers/notification_provider.dart` | State |

### 📊 Analytics Module
| File Path | Description |
|-----------|-------------|
| `lib/features/analytics/domain/services/analytics_service.dart` | Data aggregation |
| `lib/features/analytics/presentation/screens/analytics_dashboard_screen.dart` | Charts + metrics |
| `lib/features/analytics/presentation/screens/reports_screen.dart` | PDF reports |
| `lib/features/analytics/presentation/providers/analytics_provider.dart` | State |

### 📷 Scanning Module — Missing
| File Path | Description |
|-----------|-------------|
| `lib/features/scanning/presentation/screens/scan_history_screen.dart` | Past scan history |

### ⚙️ Settings — Missing
| File Path | Description |
|-----------|-------------|
| `lib/features/settings/presentation/screens/pin_management_screen.dart` | PIN set/change |
| `lib/features/settings/presentation/screens/active_sessions_screen.dart` | View/manage sessions |
| `lib/features/settings/presentation/screens/import_contacts_screen.dart` | CSV/VCF bulk import |
| `lib/features/settings/presentation/screens/export_contacts_screen.dart` | Export options |

### 📱 NFC — Missing Implementation
| File Path | Description |
|-----------|-------------|
| `lib/features/digital_card/presentation/screens/nfc_share_screen.dart` | NFC tap screen |

---

## EXISTING FILES THAT NEED MAJOR WORK

| File Path | Status | What's Missing |
|-----------|--------|---------------|
| `lib/features/wallet/presentation/wallet_home_screen.dart` | PLACEHOLDER (28 lines) | Full implementation |
| `lib/features/digital_card/data/services/nfc_service.dart` | STUBBED | Actual NFC write/read |
| `lib/core/router/routes.dart` | EXISTS | Wallet + Notification routes missing |

---

## MISSING FUNCTIONALITIES (No UI Exists)

### Wallet & Transactions
- No real-time balance tracking
- No send/receive logic or transaction logging
- No wallet connection to any backend (Isar schemas exist but unused)

### Notifications System
- No FCM (Firebase Cloud Messaging) setup
- No local notification triggers
- No notification center UI
- No `NotificationIsar` usage (schema exists)

### Smart Scanning Features
- Scan History: Cannot browse past scans
- Batch Scanning: Cannot scan multiple cards in one session
- Per-field confidence coloring in preview UI

### Data Management
- No CSV/Excel import
- No vCard bulk file import
- No scheduled recurring exports

### Analytics
- No contact growth tracking over time
- No engagement metrics
- No chart visualizations
- No PDF reports generation for analytics

### Advanced Digital Card
- Card front/back FLIP animation on `my_digital_card_screen.dart`
- Card view count analytics
- Card version history display UI (data is stored, no UI)

---

## APP PAGES COVERAGE (from V1_PAGE_SPECIFICATIONS)

### ✅ Screens Implemented
1. Splash Screen
2. Welcome Screen
3. Login Screen (Email)
4. Register Screen
5. Phone Login Screen
6. OTP Verification Screen
7. Forgot Password Screen
8. Onboarding: Permission Screen
9. Onboarding: Intro Carousel
10. Home / Dashboard Screen
11. Contact List Screen
12. Add Contact Method Screen
13. Add Contact Screen (Manual)
14. Edit Contact Screen
15. Contact Details Screen
16. Import Contacts Screen (Phone)
17. Scan Card Screen (Camera)
18. OCR Preview Screen
19. My Digital Card Screen
20. Card Editor Screen
21. Template Gallery Screen
22. QR Code Screen
23. Settings Screen
24. Edit Profile Screen
25. Account Settings Screen
26. Security Settings Screen
27. Privacy Settings Screen
28. Team Details Screen
29. Create Team Screen

### ❌ Screens NOT Yet Implemented (~15+ screens)
30. Wallet Home Screen (placeholder only)
31. Add Money Screen
32. Send Money Screen
33. Receive Money Screen
34. Transaction History Screen
35. Transaction Detail Screen
36. Notification Center Screen
37. Notification Settings Screen
38. Analytics Dashboard Screen
39. Reports Screen
40. Scan History Screen
41. PIN Management Screen
42. Active Sessions Screen
43. Import Contacts (CSV/VCF) Screen
44. Export Contacts Screen
45. NFC Share Screen
