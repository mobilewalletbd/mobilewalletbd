# Missing Screens & Functionalities Audit
**Date**: February 17, 2026

## 🚫 Missing Screens (Not Created Yet)

### 1. Wallet Module (Phase 6) [later]
*   **Wallet Home Screen**: `lib/features/wallet/presentation/screens/wallet_home_screen.dart` (Currently missing/placeholder)
*   **Send Money Screen**: `lib/features/wallet/presentation/screens/send_money_screen.dart`
*   **Receive Money Screen**: `lib/features/wallet/presentation/screens/receive_money_screen.dart`
*   **Transaction History Screen**: `lib/features/wallet/presentation/screens/transaction_history_screen.dart`
*   **Transaction Details Screen**: `lib/features/wallet/presentation/screens/transaction_details_screen.dart`

### 2. Notifications Module (Phase 7.8)
*   **Notification Center**: `lib/features/notifications/presentation/screens/notification_center_screen.dart`
*   **Notification Settings**: `lib/features/notifications/presentation/screens/notification_settings_screen.dart` (UI exists in Settings, but dedicated screen missing)

### 3. Analytics Module (Phase 7.7)
*   **Analytics Dashboard**: `lib/features/analytics/presentation/screens/analytics_dashboard_screen.dart`
*   **Reports Screen**: `lib/features/analytics/presentation/screens/reports_screen.dart`

### 4. Scanning Module (Phase 4.3)
*   **Scan History Screen**: `lib/features/scanning/presentation/screens/scan_history_screen.dart`

### 5. Settings & Tools (Phase 7.6)
*   **Import Contacts Screen**: `lib/features/settings/presentation/screens/import_contacts_screen.dart` (Export exists as dialog)

---

## 🛠 Missing Functionalities (Not Implemented)

### 1. Wallet & Transactions [later]
*   **Real-time Balance**: Wallet system is not connected to any backend/local database.
*   **Send/Receive Logic**: No logic for transferring funds between users. 
*   **Transaction Logging**: No history recording or persistence.

### 2. Notifications System
*   **Real-time Alerts**: No Firebase Cloud Messaging (FCM) or local notification setup.
*   **Notification Center**: No UI to view past notifications.

### 3. Smart Scanning Features
*   **Scan History**: Ability to view past scans is missing.
*   **Batch Scanning**: Scanning multiple cards in one session is not implemented.

### 4. Data Management
*   **Import Contacts**: No functionality to import CSV/VCF files.
*   **Advanced Export**: Export is limited to basic dialog; no recurring reports.

### 5. Analytics
*   **User Analytics**: No tracking of contact growth or engagement metrics.
