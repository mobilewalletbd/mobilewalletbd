# ============================================================================
# MOBILE WALLET - BUSINESS COLLABORATION DESIGN
# BNR Integration & Bank Partnership Design Document
# ============================================================================

**App Name:** Mobile Wallet  
**Document Version:** 1.0  
**Last Updated:** December 2024  
**Design Type:** Business Integration & Collaboration Architecture

---

# ============================================================================
# DOCUMENT OVERVIEW
# ============================================================================

## Purpose
This design document outlines the strategic and structural changes required to integrate Bangladesh's three major Mobile Financial Services (bKash, Nagad, Rocket - collectively "BNR") into the Mobile Wallet application, and establishes the framework for banking partnerships with 5 major financial institutions.

## Scope
- BNR payment gateway integration design
- New pages and modified existing pages analysis
- Bank collaboration framework design
- User experience flow for financial integrations
- API orchestration architecture
- Security and compliance framework

## Target Audience
- Investors and banking partners
- Product and design teams
- Technical architects
- Business development stakeholders

---

# ============================================================================
# TABLE OF CONTENTS
# ============================================================================

## PART A: BNR INTEGRATION DESIGN
1. Integration Overview & Strategy
2. Impact Analysis on Existing Design
3. New Pages Required (Detailed Design)
4. Existing Pages Modifications
5. Payment Flow Architecture
6. User Experience Journeys
7. Security & Compliance Design

## PART B: BANK COLLABORATION DESIGN
8. Bank Partnership Framework
9. Additional Design Requirements for Banks
10. Corporate Banking Features
11. Trust & Credibility Elements
12. Demonstration & Pitch Materials Design

---

# ============================================================================
# PART A: BNR INTEGRATION DESIGN
# ============================================================================

# 1. INTEGRATION OVERVIEW & STRATEGY

## 1.1 Strategic Positioning

### Integration Philosophy
Mobile Wallet positions itself as a **complementary aggregator** rather than a competitor to bKash, Nagad, and Rocket. The application acts as a unified interface that enhances user experience by consolidating multiple payment methods with contact management.

### Value Proposition
- **For Users:** Single app to manage all payment wallets + contacts
- **For MFS Providers:** Access to professional user segment, increased transaction volume
- **For Mobile Wallet:** Transaction fee revenue, partnership opportunities

## 1.2 Integration Model

### Technical Approach
The system employs a **Payment Orchestration Layer** that provides:
- Unified API interface to multiple MFS providers
- Adapter pattern for provider-specific implementations
- Fallback mechanisms and load balancing
- Transaction routing based on user preference and availability

### Integration Phases

| Phase | Duration | Focus | Deliverables |
|-------|----------|-------|--------------|
| Phase 1 | Months 1-3 | Core Integration | Add money, send money, basic wallet operations |
| Phase 2 | Months 4-6 | Enhanced Features | QR payments, merchant payments, transaction history sync |
| Phase 3 | Months 7-9 | Advanced Integration | Auto-routing, split payments, loyalty integration |
| Phase 4 | Months 10-12 | Optimization | Performance tuning, analytics, predictive features |

---

# 2. IMPACT ANALYSIS ON EXISTING DESIGN

## 2.1 Quantitative Impact

### Summary of Changes

| Category | New Pages | Modified Pages | Total Affected |
|----------|-----------|----------------|----------------|
| Wallet Module | 8 | 5 | 13 |
| Settings Module | 2 | 3 | 5 |
| Home/Dashboard | 0 | 2 | 2 |
| Contact Module | 0 | 2 | 2 |
| Authentication | 1 | 1 | 2 |
| **TOTAL** | **11** | **13** | **24** |

### Page Count Analysis
- **Original Design:** 60 pages
- **New Pages Added:** 11 pages
- **Updated Total:** 71 pages
- **Percentage Increase:** 18.3%

## 2.2 Module-Level Impact

### HIGH IMPACT - Wallet Module
**Why:** Direct integration point for all payment operations

**Changes Required:**
- Complete redesign of wallet home to accommodate multiple MFS accounts
- New flows for linking/unlinking MFS accounts
- Enhanced transaction history with multi-source support
- New payment routing logic interface

### MEDIUM IMPACT - Settings Module
**Why:** New configuration options for payment preferences

**Changes Required:**
- Payment provider management settings
- Transaction limit configurations per provider
- Default payment method selection
- Auto-routing preferences

### LOW IMPACT - Other Modules
**Why:** Indirect integration through payment touchpoints

**Changes Required:**
- Contact detail page: Send money button enhancement
- Home dashboard: Wallet balance aggregation display
- Minor UI adjustments for payment option selections

---

# 3. NEW PAGES REQUIRED (DETAILED DESIGN)

## 3.1 NEW PAGE LIST

### Wallet Module - New Pages (8 pages)

| Page # | Page Name | Purpose | Priority |
|--------|-----------|---------|----------|
| W-1 | Link MFS Account - Selection | Choose which MFS to link | Critical |
| W-2 | Link bKash Account | bKash-specific linking flow | Critical |
| W-3 | Link Nagad Account | Nagad-specific linking flow | Critical |
| W-4 | Link Rocket Account | Rocket-specific linking flow | Critical |
| W-5 | MFS Account Management | Manage all linked accounts | Critical |
| W-6 | Payment Method Selector | Choose payment source for transactions | Critical |
| W-7 | Add Money - Source Selection | Select which MFS to add money from | High |
| W-8 | Cash Out to MFS | Withdraw to linked MFS account | High |

### Settings Module - New Pages (2 pages)

| Page # | Page Name | Purpose | Priority |
|--------|-----------|---------|----------|
| S-1 | Payment Preferences | Configure payment routing and defaults | High |
| S-2 | Transaction Limits | Set limits per provider | Medium |

### Authentication Module - New Pages (1 page)

| Page # | Page Name | Purpose | Priority |
|--------|-----------|---------|----------|
| A-1 | MFS PIN/OTP Verification | Verify transactions with MFS provider auth | Critical |

---

## 3.2 DETAILED PAGE DESIGNS

### PAGE W-1: Link MFS Account - Selection

#### Purpose
First screen when user wants to link an MFS account, presenting available provider options.

#### Layout Structure

```
┌─────────────────────────────────────┐
│ ← Link Payment Account             │  Navigation Bar
├─────────────────────────────────────┤
│                                     │
│   Connect your mobile wallet       │  Header Text
│   Choose a provider to link         │  Subheader
│                                     │
│   ┌───────────────────────────┐    │
│   │  📱 bKash                 │    │  Provider Card 1
│   │  Bangladesh's #1 MFS      │    │
│   │  75M+ users              ●│→   │
│   └───────────────────────────┘    │
│                                     │
│   ┌───────────────────────────┐    │
│   │  📱 Nagad                 │    │  Provider Card 2
│   │  Fast & reliable          │    │
│   │  50M+ users              ●│→   │
│   └───────────────────────────┘    │
│                                     │
│   ┌───────────────────────────┐    │
│   │  📱 Rocket                │    │  Provider Card 3
│   │  Dutch-Bangla Bank backed │    │
│   │  20M+ users              ●│→   │
│   └───────────────────────────┘    │
│                                     │
│   Already linked: bKash ✓          │  Status Indicator
│                                     │
└─────────────────────────────────────┘
```

#### Visual Specifications

**Component Details:**
- **Provider Cards:** 
  - Height: 88px
  - Background: White (#FFFFFF)
  - Border Radius: 16px
  - Shadow: 0 2px 12px rgba(0,0,0,0.08)
  - Padding: 16px
  - Gap between cards: 16px

- **Provider Logo/Icon:**
  - Size: 48×48px
  - Position: Left aligned
  - Each provider has brand colors:
    - bKash: Pink circle (#E2136E)
    - Nagad: Orange circle (#F47920)
    - Rocket: Purple circle (#8E44AD)

- **Provider Text:**
  - Name: Inter SemiBold 18px, Black (#1A1A2E)
  - Description: Inter Regular 14px, Dark Gray (#4A4A5A)
  - User count: Inter Regular 12px, Medium Gray (#8E8E9A)

- **Linked Indicator:**
  - Badge: Primary Green background, White text
  - Checkmark icon
  - Positioned bottom of screen

#### Interaction Flow
1. User taps "Link Account" from Wallet settings or initial setup
2. System displays available MFS providers
3. Shows which providers are already linked
4. User selects a provider card
5. Navigates to provider-specific linking page

#### Business Rules
- Users can link multiple MFS accounts
- Maximum 3 MFS accounts (one of each type)
- If provider already linked, show "Manage" instead of "Link"
- Disable selection if maximum limit reached

---

### PAGE W-2: Link bKash Account

#### Purpose
Dedicated flow for linking user's bKash account to Mobile Wallet.

#### Layout Structure

```
┌─────────────────────────────────────┐
│ ← Link bKash Account            Skip│  Navigation Bar
├─────────────────────────────────────┤
│                                     │
│        [bKash Logo - 80×80px]       │  Provider Branding
│                                     │
│   Connect your bKash account       │  Headline
│                                     │
│   ┌───────────────────────────┐    │
│   │ bKash Account Number      │    │  Input Label
│   │ ┌─────────────────────┐   │    │
│   │ │ +880 17              │   │    │  Phone Input
│   │ └─────────────────────┘   │    │
│   └───────────────────────────┘    │
│                                     │
│   ✓ Your bKash PIN will be         │  Security Notice
│     required for verification       │
│                                     │
│   ✓ We never store your PIN        │  Privacy Assurance
│                                     │
│   [ ] I agree to share my bKash    │  Consent Checkbox
│       transaction data              │
│                                     │
│   ┌───────────────────────────┐    │
│   │    CONTINUE TO VERIFY       │    │  Primary Button
│   └───────────────────────────┘    │
│                                     │
│   Why link bKash?                  │  Information Link
│                                     │
└─────────────────────────────────────┘
```

#### Visual Specifications

**Component Details:**
- **bKash Logo:**
  - Size: 80×80px
  - Centered at top
  - Official bKash brand colors and logo

- **Phone Input Field:**
  - Height: 56px
  - Background: Off White (#F5F5F7)
  - Border: 1px Light Gray (#E5E5E5)
  - Border Radius: 12px
  - Pre-filled: +880 country code (Bangladesh)
  - Font: Inter Regular 16px
  - Input mask: +880 XX XXX XXXX format

- **Security Notices:**
  - Green checkmark icon (16px)
  - Text: Inter Regular 14px, Dark Gray
  - Left-aligned with icon spacing

- **Consent Checkbox:**
  - Size: 24×24px
  - Border: 2px Primary Green when checked
  - Required for proceeding

- **Continue Button:**
  - Disabled state until phone number complete and checkbox checked
  - Primary Green background
  - Full-width with 24px margins

#### Interaction Flow
1. User enters bKash-registered mobile number
2. System validates number format
3. User checks consent checkbox
4. Taps "Continue to Verify"
5. System initiates OAuth flow with bKash API
6. Redirects to bKash authentication (external/webview)
7. bKash prompts user for PIN/OTP
8. Upon successful auth, returns to Mobile Wallet
9. Displays success confirmation

#### API Integration Points
- bKash Token Grant API: `/token/grant`
- bKash User Verify API: `/user/verify`
- OAuth 2.0 flow implementation

#### Error Scenarios
- Invalid phone number format
- Number not registered with bKash
- bKash service unavailable
- User cancels authentication
- Authorization denied

---

### PAGE W-3: Link Nagad Account

#### Purpose
Dedicated flow for linking user's Nagad account.

#### Layout Structure
Similar to bKash linking page (W-2) with Nagad branding:

```
┌─────────────────────────────────────┐
│ ← Link Nagad Account            Skip│
├─────────────────────────────────────┤
│                                     │
│        [Nagad Logo - 80×80px]       │
│                                     │
│   Connect your Nagad account       │
│                                     │
│   ┌───────────────────────────┐    │
│   │ Nagad Account Number      │    │
│   │ ┌─────────────────────┐   │    │
│   │ │ +880 17              │   │    │
│   │ └─────────────────────┘   │    │
│   └───────────────────────────┘    │
│                                     │
│   ✓ Secure API integration         │
│   ✓ No password stored             │
│                                     │
│   [ ] I agree to Nagad integration │
│       terms                         │
│                                     │
│   ┌───────────────────────────┐    │
│   │    CONTINUE TO VERIFY       │    │
│   └───────────────────────────┘    │
│                                     │
│   Why link Nagad?                  │
│                                     │
└─────────────────────────────────────┘
```

#### Visual Specifications
- **Nagad Logo:** Official orange and white branding
- **Color Accents:** Nagad Orange (#F47920) for highlights
- **API Approach:** API Key + Secret authentication
- All other specifications match bKash page structure

#### Technical Notes
- Nagad uses API Key/Secret model (not OAuth)
- User verification via OTP sent by Nagad
- Integration flow slightly different from bKash

---

### PAGE W-4: Link Rocket Account

#### Purpose
Dedicated flow for linking Rocket (Dutch-Bangla Bank) account.

#### Layout Structure
Similar structure with Rocket branding:

```
┌─────────────────────────────────────┐
│ ← Link Rocket Account           Skip│
├─────────────────────────────────────┤
│                                     │
│        [Rocket Logo - 80×80px]      │
│                                     │
│   Connect your Rocket account      │
│                                     │
│   ┌───────────────────────────┐    │
│   │ Rocket Account Number     │    │
│   │ ┌─────────────────────┐   │    │
│   │ │ +880 18              │   │    │
│   │ └─────────────────────┘   │    │
│   └───────────────────────────┘    │
│                                     │
│   💳 Link DBBL bank account?       │
│      [Yes] [No]                    │
│                                     │
│   ✓ Enhanced transaction limits    │
│   ✓ Bank integration available     │
│                                     │
│   [ ] I agree to Rocket integration│
│                                     │
│   ┌───────────────────────────┐    │
│   │    CONTINUE TO VERIFY       │    │
│   └───────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

#### Visual Specifications
- **Rocket Logo:** Purple branding (#8E44AD)
- **Unique Feature:** Option to link DBBL bank account simultaneously
- **Banking Integration Toggle:** Radio buttons or toggle switch

#### Technical Notes
- Rocket backed by Dutch-Bangla Bank (DBBL)
- Can enable higher transaction limits with bank account linking
- OAuth 2.0 flow similar to bKash
- Additional banking API endpoints available

---

### PAGE W-5: MFS Account Management

#### Purpose
Central hub for managing all linked MFS accounts, viewing balances, and account settings.

#### Layout Structure

```
┌─────────────────────────────────────┐
│ ← Payment Accounts              +   │  Nav: Back + Add New
├─────────────────────────────────────┤
│                                     │
│   Linked Accounts                  │  Section Header
│                                     │
│   ┌───────────────────────────┐    │
│   │ 📱 bKash              ●●●  │    │  Account Card 1
│   │ +880 17•••••234            │    │
│   │ Balance: ৳ 5,240.00        │    │
│   │ ┌──────┐  ┌──────┐        │    │
│   │ │Manage│  │Remove│        │    │  Action Buttons
│   │ └──────┘  └──────┘        │    │
│   └───────────────────────────┘    │
│                                     │
│   ┌───────────────────────────┐    │
│   │ 📱 Nagad              ●●●  │    │  Account Card 2
│   │ +880 18•••••567            │    │
│   │ Balance: ৳ 1,850.00        │    │
│   │ ┌──────┐  ┌──────┐        │    │
│   │ │Manage│  │Remove│        │    │
│   │ └──────┘  └──────┘        │    │
│   └───────────────────────────┘    │
│                                     │
│   Available to Link                │  Section Header
│                                     │
│   ┌───────────────────────────┐    │
│   │ 📱 Rocket                  │    │  Available Provider
│   │ Link your account      →   │    │
│   └───────────────────────────┘    │
│                                     │
│   Settings                         │  Quick Settings
│   • Default payment method: bKash  │
│   • Auto-refresh balance: On       │
│                                     │
└─────────────────────────────────────┘
```

#### Visual Specifications

**Account Cards:**
- Height: 140px
- Background: White with subtle gradient
- Border Radius: 16px
- Shadow: 0 2px 12px rgba(0,0,0,0.08)
- Padding: 16px
- Gap: 16px between cards

**Provider Indicator:**
- Circle avatar with provider brand color
- Size: 48×48px
- Provider logo/icon inside

**Balance Display:**
- Font: Inter SemiBold 20px
- Color: Primary Green (#00A86B)
- Refresh icon (24px) next to balance (tappable)

**Masked Phone Number:**
- Format: +880 XX•••••XXX (show first 2 and last 3 digits)
- Font: Inter Regular 14px
- Color: Dark Gray

**Action Buttons:**
- Height: 36px
- Width: 48% each (side by side)
- Border Radius: 8px
- Manage: Secondary button style
- Remove: Coral Accent text

**Menu Icon (•••):**
- Size: 24×24px
- Top right of card
- Opens context menu: Set as default, Refresh balance, View transactions, Remove

#### Interaction Flow
1. User views all linked MFS accounts
2. Can see masked account numbers and current balances
3. Tap "Refresh" to update balances from MFS providers
4. Tap "Manage" to view detailed account settings
5. Tap "Remove" to unlink an account (with confirmation)
6. Tap "+ Add New" to link another MFS account
7. Long-press or tap menu icon for additional options

#### Data Refresh Strategy
- Balances cached locally
- Auto-refresh every 5 minutes when app active
- Manual refresh via button
- Pull-to-refresh gesture supported

#### Business Rules
- Must have at least one linked account to use payment features
- Cannot remove last remaining account without warning
- Default payment method must be from linked accounts
- Balance refresh rate-limited to prevent API abuse

---

### PAGE W-6: Payment Method Selector

#### Purpose
Modal/bottom sheet that appears when user initiates a payment, allowing them to choose which MFS account or card to use.

#### Layout Structure

```
┌─────────────────────────────────────┐
│                 ─                   │  Sheet Handle
│                                     │
│   Choose Payment Method            │  Sheet Title
│                                     │
│   Mobile Wallets                   │  Section Header
│                                     │
│   ┌───────────────────────────┐    │
│   │ ○ 📱 bKash                │    │  Option 1 - Radio
│   │    +880 17•••••234         │    │
│   │    Available: ৳5,240       │    │
│   └───────────────────────────┘    │
│                                     │
│   ┌───────────────────────────┐    │
│   │ ● 📱 Nagad    [DEFAULT]   │    │  Option 2 - Selected
│   │    +880 18•••••567         │    │
│   │    Available: ৳1,850       │    │
│   └───────────────────────────┘    │
│                                     │
│   Payment Cards                    │  Section Header
│                                     │
│   ┌───────────────────────────┐    │
│   │ ○ 💳 Visa •••• 4532       │    │  Option 3 - Radio
│   │    Expires: 12/25          │    │
│   └───────────────────────────┘    │
│                                     │
│   + Add New Payment Method         │  Add New Link
│                                     │
│   ┌───────────────────────────┐    │
│   │        CONFIRM              │    │  Confirm Button
│   └───────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

#### Visual Specifications

**Bottom Sheet:**
- Background: White
- Border Radius: 24px (top corners only)
- Max Height: 70% screen height
- Handle: 36×4px, Light Gray, centered at top
- Padding: 24px

**Payment Option Cards:**
- Height: 72px
- Background: Off White (#F5F5F7)
- Border Radius: 12px
- Padding: 12px
- Border: 2px solid Primary Green when selected
- Gap: 12px between options

**Radio Selection:**
- Size: 24×24px
- Filled circle when selected (Primary Green)
- Empty circle when unselected (Light Gray)

**Default Badge:**
- Background: Warm Gold (#FFB84D)
- Text: White, Inter SemiBold 10px
- Border Radius: 4px
- Padding: 4px 8px

**Balance/Info Text:**
- Available balance: Inter Regular 14px, Primary Green
- Account details: Inter Regular 12px, Medium Gray

**Confirm Button:**
- Full-width within sheet
- Primary Green background
- Fixed at bottom of sheet
- Disabled if no selection made

#### Interaction Flow
1. User initiates payment (e.g., "Send Money")
2. Sheet slides up from bottom
3. User sees all available payment methods
4. Current default pre-selected
5. User taps to select different method
6. Selection visually highlighted with green border
7. User taps "Confirm" to proceed with selected method
8. Sheet dismisses and payment continues

#### Smart Features
- **Insufficient Balance:** Grayed out with "Insufficient balance" text
- **Offline Indicator:** Shows if unable to fetch current balance
- **Recent Usage:** Sorts by most recently used (optional)
- **Quick Set Default:** Long-press option to set as new default

#### Context-Aware Display
- If sending to a contact with known MFS number (e.g., bKash), highlight matching provider
- If merchant payment, only show relevant methods
- If international transaction, filter to international cards only

---

### PAGE W-7: Add Money - Source Selection

#### Purpose
Allow user to add money to their Mobile Wallet from linked MFS accounts or other sources.

#### Layout Structure

```
┌─────────────────────────────────────┐
│ ← Add Money to Wallet               │  Navigation Bar
├─────────────────────────────────────┤
│                                     │
│   Current Balance                  │  Balance Section
│   ৳ 320.50                         │
│                                     │
│   ┌───────────────────────────┐    │
│   │ Amount to Add              │    │  Amount Input
│   │ ┌─────────────────────┐   │    │
│   │ │  ৳                   │   │    │  Large Input
│   │ └─────────────────────┘   │    │
│   └───────────────────────────┘    │
│                                     │
│   Quick Amounts                    │
│   [৳500] [৳1000] [৳2000] [৳5000]   │  Chip Buttons
│                                     │
│   Select Source                    │  Section Header
│                                     │
│   ┌───────────────────────────┐    │
│   │ ● 📱 bKash                │    │  Source Option 1
│   │    +880 17•••••234         │    │
│   │    Fee: ৳5 (1.5%)          │    │
│   └───────────────────────────┘    │
│                                     │
│   ┌───────────────────────────┐    │
│   │ ○ 📱 Nagad                │    │  Source Option 2
│   │    +880 18•••••567         │    │
│   │    Fee: ৳3 (1%)            │    │
│   └───────────────────────────┘    │
│                                     │
│   ┌───────────────────────────┐    │
│   │ ○ 💳 Bank Transfer         │    │  Source Option 3
│   │    DBBL Account            │    │
│   │    Fee: ৳0                 │    │
│   └───────────────────────────┘    │
│                                     │
│   You will receive: ৳ 995.00       │  Net Amount Display
│                                     │
│   ┌───────────────────────────┐    │
│   │      ADD MONEY              │    │  Confirm Button
│   └───────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

#### Visual Specifications

**Amount Input:**
- Height: 80px
- Background: Off White (#F5F5F7)
- Border: 2px Light Gray, focus: Primary Green
- Border Radius: 16px
- Font: Inter SemiBold 32px
- Taka symbol (৳) prefix
- Numeric keyboard

**Quick Amount Chips:**
- Height: 40px
- Background: White with Primary Green border
- Border Radius: 20px (pill shape)
- Padding: 8px 16px
- Horizontal scrollable
- Selected: Primary Green background, White text

**Source Option Cards:**
- Height: 80px
- Same style as Payment Method Selector
- Shows transaction fee transparently
- Radio button selection

**Fee Display:**
- Color: Coral Accent (#FF6B6B) if fee > 0
- Color: Success Green (#28A745) if fee = 0
- Font: Inter Regular 12px
- Format: "Fee: ৳X (Y%)"

**Net Amount Display:**
- Background: Light Green tint
- Border Radius: 8px
- Padding: 12px
- Font: Inter SemiBold 16px, Primary Green
- Calculation: Amount - Fee

#### Interaction Flow
1. User navigates to Add Money
2. Enters desired amount or taps quick amount
3. System calculates fees for each source and displays
4. User selects preferred source
5. System shows net amount to be received
6. User taps "Add Money"
7. Redirects to MFS provider for authentication
8. Provider prompts for PIN/OTP
9. Upon success, money added to wallet
10. Returns to wallet with success message

#### Business Rules
- Minimum add amount: ৳50
- Maximum add amount: ৳25,000 per transaction (regulatory limit)
- Daily limit: ৳50,000 aggregate
- Fees vary by provider and may be promotional (0% during campaigns)
- Must have linked MFS account to add money

---

### PAGE W-8: Cash Out to MFS

#### Purpose
Allow user to withdraw money from Mobile Wallet balance to their linked MFS account.

#### Layout Structure

```
┌─────────────────────────────────────┐
│ ← Cash Out                          │  Navigation Bar
├─────────────────────────────────────┤
│                                     │
│   Wallet Balance                   │  Balance Section
│   ৳ 5,680.00                       │
│                                     │
│   ┌───────────────────────────┐    │
│   │ Amount to Withdraw         │    │  Amount Input
│   │ ┌─────────────────────┐   │    │
│   │ │  ৳                   │   │    │
│   │ └─────────────────────┘   │    │
│   │ Withdraw All               │    │  Helper Link
│   └───────────────────────────┘    │
│                                     │
│   Select Destination               │  Section Header
│                                     │
│   ┌───────────────────────────┐    │
│   │ ● 📱 bKash                │    │  Destination Option
│   │    +880 17•••••234         │    │
│   │    Fee: ৳8.50 (1.85%)      │    │
│   │    Processing: Instant     │    │
│   └───────────────────────────┘    │
│                                     │
│   ┌───────────────────────────┐    │
│   │ ○ 📱 Nagad                │    │
│   │    +880 18•••••567         │    │
│   │    Fee: ৳7.00 (1.5%)       │    │
│   │    Processing: Instant     │    │
│   └───────────────────────────┘    │
│                                     │
│   ⚠️  Cash-out limits apply:       │  Info Notice
│      Max ৳25,000/transaction       │
│      Max ৳200,000/month            │
│                                     │
│   You will receive: ৳ 991.50       │  Net Amount
│                                     │
│   ┌───────────────────────────┐    │
│   │      CASH OUT               │    │  Confirm Button
│   └───────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

#### Visual Specifications
- Similar to Add Money page (W-7) but inverted flow
- Withdrawal direction: Mobile Wallet → MFS account
- Shows regulatory cash-out limits clearly
- Processing time indicator (Instant vs 24 hours)

#### Interaction Flow
1. User enters withdrawal amount
2. Selects destination MFS account
3. System validates against limits and balance
4. Shows net amount after fees
5. User confirms cash-out
6. System processes withdrawal
7. Sends confirmation to both wallet and MFS
8. Updates balance immediately

#### Business Rules
- Must have sufficient wallet balance
- Bangladesh Bank regulatory limits apply
- Cash-out fees typically higher than cash-in
- KYC verification may be required for large amounts
- Transaction history recorded for compliance

---

### PAGE S-1: Payment Preferences

#### Purpose
Settings page for configuring payment defaults, routing preferences, and transaction behaviors.

#### Layout Structure

```
┌─────────────────────────────────────┐
│ ← Payment Preferences               │  Navigation Bar
├─────────────────────────────────────┤
│                                     │
│   Default Payment Method           │  Section Header
│                                     │
│   For Sending Money                │  Subsection
│   [ bKash +880 17•••••234      ▼]  │  Dropdown Selector
│                                     │
│   For Merchant Payments            │  Subsection
│   [ Nagad +880 18•••••567      ▼]  │  Dropdown Selector
│                                     │
│   ─────────────────────────────    │  Divider
│                                     │
│   Smart Payment Routing            │  Section Header
│                                     │
│   [✓] Auto-select cheapest option  │  Checkbox Toggle
│       Save on transaction fees      │  Description
│                                     │
│   [✓] Prefer MFS matching recipient│  Checkbox Toggle
│       Use same provider as receiver │  Description
│                                     │
│   [ ] Always ask before payment    │  Checkbox Toggle
│       Show payment method selector  │  Description
│                                     │
│   ─────────────────────────────    │  Divider
│                                     │
│   Transaction Confirmations        │  Section Header
│                                     │
│   Require PIN for                  │  Subsection
│   [ Transactions above ৳500    ▼]  │  Amount Selector
│                                     │
│   [✓] Biometric authentication     │  Toggle
│       Use Face ID / Fingerprint     │  Description
│                                     │
│   ─────────────────────────────    │  Divider
│                                     │
│   Receipt & Notifications          │  Section Header
│                                     │
│   [✓] Email receipts               │  Toggle
│   [✓] SMS confirmation             │  Toggle
│   [✓] Push notifications           │  Toggle
│                                     │
└─────────────────────────────────────┘
```

#### Visual Specifications

**Section Headers:**
- Font: Inter SemiBold 14px
- Color: Medium Gray (#8E8E9A)
- Text transform: Uppercase
- Background: Off White (#F5F5F7)
- Padding: 12px 16px

**Dropdown Selectors:**
- Height: 56px
- Background: White
- Border: 1px Light Gray
- Border Radius: 12px
- Chevron icon right-aligned
- Shows provider icon and masked number

**Checkbox Toggles:**
- Toggle switch: 51×31px
- On: Primary Green
- Off: Light Gray
- Aligned to right
- Label text on left

**Description Text:**
- Font: Inter Regular 12px
- Color: Dark Gray (#4A4A5A)
- Below main label, indented

**Dividers:**
- Height: 1px
- Color: Light Gray (#E5E5E5)
- Margin: 16px vertical

#### Smart Routing Logic

**Auto-select Cheapest Option:**
- System calculates fees across all linked MFS providers
- Automatically selects provider with lowest total cost
- Shows savings: "Saved ৳2 using Nagad instead of bKash"

**Prefer Matching Provider:**
- If recipient is bKash user, suggests sending via bKash
- Reduces inter-operator fees
- Better success rate for same-provider transactions

**Always Ask:**
- Overrides automatic selection
- Shows payment method selector for every transaction
- Gives user full control

#### Business Value
- Optimizes transaction costs for users
- Increases user satisfaction through automation
- Transparent control over payment behaviors
- Builds trust through explicit permission model

---

### PAGE S-2: Transaction Limits

#### Purpose
Display and configure transaction limits per MFS provider and compliance boundaries.

#### Layout Structure

```
┌─────────────────────────────────────┐
│ ← Transaction Limits                │  Navigation Bar
├─────────────────────────────────────┤
│                                     │
│   ℹ️  Limits set by Bangladesh Bank │  Info Banner
│      and MFS provider policies      │
│                                     │
│   bKash Account                    │  Provider Section
│   +880 17•••••234                  │
│                                     │
│   Single Transaction               │  Limit Type
│   ৳10,000 / ৳25,000 max            │  Current / Max
│   ▓▓▓▓▓░░░░░░░ 40%                 │  Visual Bar
│                                     │
│   Daily Limit                      │  Limit Type
│   ৳15,000 / ৳50,000 max            │  Current / Max
│   ▓▓▓▓░░░░░░░░░ 30%                │  Visual Bar
│                                     │
│   Monthly Limit                    │  Limit Type
│   ৳120,000 / ৳200,000 max          │  Current / Max
│   ▓▓▓▓▓▓▓▓░░░░ 60%                 │  Visual Bar
│                                     │
│   [  Increase Limits  ]            │  Action Button
│                                     │
│   ─────────────────────────────    │  Divider
│                                     │
│   Nagad Account                    │  Provider Section
│   +880 18•••••567                  │
│                                     │
│   Single Transaction               │
│   ৳5,000 / ৳25,000 max             │
│   ▓▓░░░░░░░░░░░ 20%                │
│                                     │
│   Daily Limit                      │
│   ৳8,000 / ৳50,000 max             │
│   ▓▓░░░░░░░░░░░ 16%                │
│                                     │
│   Monthly Limit                    │
│   ৳35,000 / ৳200,000 max           │
│   ▓▓░░░░░░░░░░░ 18%                │
│                                     │
│   [  Increase Limits  ]            │
│                                     │
│   ─────────────────────────────    │
│                                     │
│   ⚠️  How to Increase Limits       │  Help Section
│   • Complete KYC verification      │
│   • Link National ID card          │
│   • Maintain good transaction      │
│     history                         │
│                                     │
│   [ Complete KYC Verification ]    │  CTA Button
│                                     │
└─────────────────────────────────────┘
```

#### Visual Specifications

**Limit Progress Bars:**
- Height: 8px
- Background: Light Gray (#E5E5E5)
- Fill: Primary Green (#00A86B)
- Border Radius: 4px
- Shows current usage as percentage

**Warning States:**
- 75-90% usage: Bar turns Warm Gold (#FFB84D)
- 90-100% usage: Bar turns Coral Accent (#FF6B6B)
- Near-limit warning appears

**Limit Text:**
- Current: Inter SemiBold 16px, Black
- Max: Inter Regular 16px, Medium Gray
- Format: ৳X / ৳Y max

**Increase Limits Button:**
- Secondary button style (outlined)
- Opens in-app guide or redirects to provider

#### Data Sources
- Real-time limit data from MFS provider APIs
- Cached locally with daily refresh
- Manual refresh option via pull-to-refresh

#### Limit Categories

| Limit Type | Description | Typical Values |
|------------|-------------|----------------|
| Single Transaction | Maximum amount per transaction | ৳25,000 |
| Daily Limit | Maximum total per 24 hours | ৳50,000 |
| Monthly Limit | Maximum total per calendar month | ৳200,000 |
| Cash-Out Limit | Specific limit for withdrawals | ৳150,000/month |

#### KYC Tiers

| Tier | Verification | Limits |
|------|--------------|--------|
| Basic | Phone only | Low limits |
| Standard | Phone + NID | Medium limits |
| Full | NID + Selfie + Utility bill | High limits |

---

### PAGE A-1: MFS PIN/OTP Verification

#### Purpose
Secure authentication page for confirming transactions with MFS provider's PIN or OTP.

#### Layout Structure

```
┌─────────────────────────────────────┐
│ ← Verify Payment                    │  Navigation Bar
├─────────────────────────────────────┤
│                                     │
│        [bKash Logo - 64px]          │  Provider Logo
│                                     │
│   Confirm with bKash PIN           │  Header
│                                     │
│   ┌───────────────────────────┐    │
│   │ Transaction Details        │    │  Info Card
│   │                            │    │
│   │ Recipient: John Doe        │    │
│   │ Amount: ৳ 1,500.00         │    │
│   │ Fee: ৳ 7.50                │    │
│   │ Total: ৳ 1,507.50          │    │
│   └───────────────────────────┘    │
│                                     │
│   Enter your bKash PIN             │  Instruction
│                                     │
│   ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐   │  PIN Input Boxes
│   │ • │ │ • │ │ • │ │ • │ │   │   │  (5 boxes)
│   └───┘ └───┘ └───┘ └───┘ └───┘   │
│                                     │
│   ✓ Encrypted connection           │  Security Indicators
│   ✓ Transaction secured by bKash   │
│                                     │
│   ┌───────────────────────────┐    │
│   │        CONFIRM PAYMENT      │    │  Submit Button
│   └───────────────────────────┘    │
│                                     │
│   Use OTP instead?                 │  Alternative Option
│                                     │
│   Cancel Transaction               │  Cancel Link
│                                     │
└─────────────────────────────────────┘
```

#### Visual Specifications

**Provider Logo:**
- Size: 64×64px
- Centered at top
- Provider brand colors

**Transaction Details Card:**
- Background: Off White (#F5F5F7)
- Border Radius: 12px
- Padding: 16px
- Font: Inter Regular 14px
- Amount in bold: Inter SemiBold 18px
- Total highlighted in Primary Green

**PIN Input Boxes:**
- Size: 48×56px each
- Gap: 12px between
- Border: 2px Light Gray
- Border Radius: 12px
- Active border: Primary Green
- Font: Password dots (hidden)
- Numeric keyboard only
- Auto-focus and auto-advance

**Security Indicators:**
- Green checkmark icons
- Small text: Inter Regular 12px
- Color: Success Green (#28A745)

**Confirm Button:**
- Disabled until all PIN digits entered
- Primary Green background
- Shows loading spinner when processing

#### Interaction Flow

**PIN Flow:**
1. User completes payment setup
2. Navigates to MFS verification
3. Enters PIN digits
4. System sends encrypted PIN to MFS API
5. MFS validates PIN
6. Returns success/failure
7. Shows result screen

**OTP Flow (Alternative):**
1. User taps "Use OTP instead"
2. System requests OTP from MFS
3. OTP sent to user's registered phone
4. User enters OTP code
5. Validation and completion

#### Security Measures
- PIN never stored locally
- Transmitted via HTTPS only
- Encrypted using provider's public key
- Session timeout after 3 minutes
- Limited retry attempts (3 tries)
- Account locked after failed attempts

#### Error Scenarios
- Wrong PIN: "Incorrect PIN. X attempts remaining"
- Expired session: "Session expired. Please try again"
- Network error: "Connection failed. Please check your internet"
- Account locked: "Too many failed attempts. Contact bKash support"

---

# 4. EXISTING PAGES MODIFICATIONS

## 4.1 MODIFICATION SUMMARY

| Module | Page | Modification Type | Effort |
|--------|------|-------------------|--------|
| Wallet | Wallet Home (P-30) | Major | High |
| Wallet | Send Money (P-34) | Major | High |
| Wallet | Receive Money (P-35) | Medium | Medium |
| Wallet | Transaction History (P-37) | Medium | Medium |
| Wallet | Add Payment Card (P-31) | Minor | Low |
| Home | Home Dashboard (P-9) | Medium | Medium |
| Contact | Contact Details (P-20) | Medium | Medium |
| Settings | Settings Home (P-46) | Minor | Low |
| Settings | Account Settings (P-48) | Minor | Low |
| Settings | Security (P-49) | Medium | Medium |
| Authentication | Register (P-4) | Minor | Low |
| Search | Search Results (P-29) | Minor | Low |
| Share | Your Digital Business Card (P-38) | Minor | Low |

---

## 4.2 DETAILED MODIFICATIONS

### MODIFIED PAGE 1: Wallet Home (P-30)

**Original Design:**
- Balance card showing single wallet balance
- Quick action tiles: Add Card, Send, Receive, Scan QR
- Saved payment cards section
- Recent transactions

**Required Changes:**

**CHANGE 1: Multi-Wallet Balance Display**

Replace single balance card with aggregated balance section:

```
┌─────────────────────────────────────┐
│   Total Balance                    │  New Section
│   ৳ 18,590.00                      │  Aggregated
│                                     │
│   ┌──────────┬──────────┬───────┐  │  Balance Pills
│   │  MW      │  bKash   │ Nagad │  │  (Horizontal Scroll)
│   │ ৳320     │ ৳5,240   │৳1,850 │  │
│   └──────────┴──────────┴───────┘  │
│                                     │
│   Manage Accounts →                │  New Link
└─────────────────────────────────────┘
```

**Visual Specifications:**
- Total balance: Large, Inter Bold 32px, Black
- Individual wallet pills: 100px width, scrollable horizontally
- Each pill shows: Wallet name, Balance, Provider icon
- Active wallet highlighted with green border
- Tappable to show/hide individual wallets

**CHANGE 2: Enhanced Quick Actions**

Modify quick action tiles to include MFS options:

```
Original:
[ Add Card ] [ Send ] [ Receive ] [ Scan QR ]

Modified:
[ Add Money ] [ Send ] [ Receive ] [ Cash Out ]
[ Link MFS  ] [ Scan QR ] [ Pay Bill ] [ More... ]
```

- Tiles expand to 4×2 grid (8 actions)
- "Add Money" replaces "Add Card"
- "Link MFS" new action (prominent during onboarding)
- "Cash Out" new action

**CHANGE 3: Transaction Source Indicators**

In recent transactions list, add visual indicators for transaction source:

```
Before:
[Icon] John Doe     -৳500     2h ago

After:
[📱 bKash] John Doe -৳500     2h ago
           ↳ via bKash
```

- Small provider icon badge
- Source label below transaction
- Color-coded by provider (pink for bKash, orange for Nagad, purple for Rocket)

**Effort Estimation:**
- Design: 4 hours
- Implementation: 12 hours
- Testing: 4 hours
- **Total: 20 hours (High)**

---

### MODIFIED PAGE 2: Send Money (P-34)

**Original Design:**
- Amount input
- Quick amounts
- Recipient selection (contact list)
- From card selector
- Note field
- Send button

**Required Changes:**

**CHANGE 1: Payment Method Selection Integration**

Replace "From card selector" with enhanced payment method chooser:

```
Before:
From: [ Visa •••• 4532 ▼ ]

After:
Payment Method:
┌─────────────────────────────────┐
│ 📱 bKash (+880 17•••••234)     │  Selected Method
│ Available: ৳5,240  Change →     │  with Balance
└─────────────────────────────────┘
```

- Shows selected payment method with balance
- "Change" link opens Payment Method Selector (W-6)
- Displays transaction fee if applicable
- Warning if insufficient balance

**CHANGE 2: Smart Recipient Detection**

Add intelligent recipient suggestion based on their linked MFS:

```
New UI Element:
┌─────────────────────────────────┐
│ ℹ️  John Doe uses bKash         │  Info Banner
│    Send via bKash for instant   │
│    delivery and lower fees      │
│    [ Use bKash ]  [ Use Other ] │
└─────────────────────────────────┘
```

- Detects recipient's preferred/available MFS from contact data
- Suggests optimal payment method
- Shows benefits: "Save ৳3 in fees"
- One-tap to switch to suggested method

**CHANGE 3: Fee Transparency**

Add real-time fee calculation display:

```
New Section (before Send button):
┌─────────────────────────────────┐
│ Summary                          │
│ Amount:        ৳ 1,500.00        │
│ Fee:           ৳    7.50 (0.5%)  │
│ ────────────────────────────────│
│ Total:         ৳ 1,507.50        │
│                                  │
│ Recipient receives: ৳1,500.00    │
└─────────────────────────────────┘
```

- Breakdown of amount + fee
- Total deducted from sender
- Amount received by recipient
- Updates live as amount changes

**CHANGE 4: Multi-Provider Send Options**

For users with multiple MFS accounts, show comparison:

```
Optional Feature (tap "Compare"):
┌─────────────────────────────────┐
│ Choose Best Option:              │
│                                  │
│ ● bKash    ৳1,507.50  Instant   │  Cheapest
│   Fee: ৳7.50                     │
│                                  │
│ ○ Nagad    ৳1,515.00  Instant   │
│   Fee: ৳15.00                    │
│                                  │
│ ○ Rocket   ৳1,510.00  Instant   │
│   Fee: ৳10.00                    │
└─────────────────────────────────┘
```

- Side-by-side comparison of costs
- Highlights cheapest option
- Shows processing time
- One-tap selection

**Effort Estimation:**
- Design: 6 hours
- Implementation: 16 hours
- API Integration: 8 hours
- Testing: 6 hours
- **Total: 36 hours (High)**

---

### MODIFIED PAGE 3: Receive Money (P-35)

**Original Design:**
- Large QR code for receiving
- Wallet ID/phone display
- Share QR button
- Amount request option

**Required Changes:**

**CHANGE 1: Multi-Provider QR Options**

Add selector for which MFS account to receive to:

```
New UI Element (above QR code):
Receive to:
[  Mobile Wallet  ▼ ]  Dropdown Selector

Options:
- Mobile Wallet (default)
- bKash (+880 17•••••234)
- Nagad (+880 18•••••567)
- Rocket (+880 19•••••890)
```

- QR code updates based on selected account
- Different QR format per provider
- Mobile Wallet QR can accept from any MFS

**CHANGE 2: Provider-Specific QR Display**

When MFS provider selected, show branded QR:

```
┌─────────────────────────────────┐
│       [bKash Logo]               │
│                                  │
│   ┌─────────────────────┐       │
│   │                     │       │  QR with bKash
│   │    [QR CODE]        │       │  branding
│   │                     │       │
│   └─────────────────────┘       │
│                                  │
│   +880 17•••••234                │
│   Scan with bKash app            │
└─────────────────────────────────┘
```

- QR code includes provider branding
- Instructions specific to provider
- Direct link for non-QR payment (phone/wallet number)

**CHANGE 3: Request Specific Amount**

Enhanced amount request feature:

```
Modified Section:
┌─────────────────────────────────┐
│ Request Amount (Optional)        │
│ ┌─────────────────┐              │
│ │ ৳               │              │
│ └─────────────────┘              │
│                                  │
│ Add Note:                        │
│ ┌─────────────────┐              │
│ │ For lunch       │              │
│ └─────────────────┘              │
│                                  │
│ [ Generate Payment Link ]        │  New Button
└─────────────────────────────────┘
```

- Amount pre-filled in generated QR/link
- Includes note/description
- Creates shareable payment link
- Link opens directly in payer's MFS app

**Effort Estimation:**
- Design: 3 hours
- Implementation: 10 hours
- QR generation logic: 6 hours
- Testing: 4 hours
- **Total: 23 hours (Medium)**

---

### MODIFIED PAGE 4: Transaction History (P-37)

**Original Design:**
- Filter chips: All, Sent, Received, Pending
- Transaction list grouped by date
- Direction icon, name, amount, time
- Status badges

**Required Changes:**

**CHANGE 1: Provider Filter**

Add MFS provider filter chips:

```
Before:
[All] [Sent] [Received] [Pending]

After:
[All] [Sent] [Received] [Pending]
[bKash] [Nagad] [Rocket] [Wallet] [Cards]
```

- Second row of filter chips
- Filter by payment source/provider
- Combination filters (e.g., "Sent via bKash")
- Chip badges show transaction count

**CHANGE 2: Enhanced Transaction Details**

Expand transaction list items with provider info:

```
Before:
[↓] John Doe    +৳500    2h ago

After:
[↓] John Doe    +৳500    2h ago
    From bKash  Fee: ৳2.50
    Ref: BKX123456789    [↗ Details]
```

- Provider icon and name
- Transaction reference number
- Fee charged (if any)
- Tap for full details modal

**CHANGE 3: Export by Provider**

Add export functionality with provider filtering:

```
New UI Element (top right):
[⋮ Menu]
  ↳ Export All
  ↳ Export bKash Transactions
  ↳ Export Nagad Transactions
  ↳ Export by Date Range
  ↳ Download Monthly Statement
```

- Export to CSV/PDF per provider
- Monthly statements for accounting
- Date range selection
- Email delivery option

**Effort Estimation:**
- Design: 2 hours
- Implementation: 8 hours
- Testing: 3 hours
- **Total: 13 hours (Medium)**

---

### MODIFIED PAGE 5: Home Dashboard (P-9)

**Original Design:**
- Header with greeting
- Profile section
- Category tabs
- Contact cards grid
- FAB cluster

**Required Changes:**

**CHANGE 1: Wallet Balance Widget**

Add wallet balance summary to dashboard:

```
New Section (between Profile and Categories):
┌─────────────────────────────────┐
│ 💰 Wallet Balance    [View →]   │  Widget Header
│                                  │
│ ৳ 18,590.00                     │  Total Balance
│                                  │
│ [📱₿] ৳5,240  [📱ℕ] ৳1,850     │  Quick Balances
└─────────────────────────────────┘
```

- Collapsible widget
- Shows total across all accounts
- Quick view of individual MFS balances
- Tap to open full Wallet
- Optional: Hide balance (show •••••)

**CHANGE 2: Quick Send Money to Contact**

Add payment shortcut to contact cards:

```
Modified Contact Card:
┌─────────────────────┐
│  [Card Image]        │
│                      │
│  John Doe            │
│  ABC Company         │
│                      │
│  [Front] [Back]      │  Original Buttons
│  [💸 Send Money]     │  New Button
└─────────────────────┘
```

- New "Send Money" button on each contact card
- Appears only if contact has payment info
- Quick-action without opening contact details
- One-tap to initiate payment flow

**Effort Estimation:**
- Design: 2 hours
- Implementation: 6 hours
- Testing: 2 hours
- **Total: 10 hours (Medium)**

---

### MODIFIED PAGE 6: Contact Details (P-20)

**Original Design:**
- Card image preview
- Contact info
- Quick action buttons (Call, Message, Email)
- Details list
- QR code preview
- Share button

**Required Changes:**

**CHANGE 1: Payment Information Section**

Add dedicated payment info section:

```
New Section (after Communication details):
┌─────────────────────────────────┐
│ Payment Information              │  Section Header
│                                  │
│ 📱 bKash: +880 17•••••234       │  MFS Details
│    ✓ Verified                    │
│                                  │
│ 📱 Nagad: Not linked            │  
│    [Request Payment Info]        │
│                                  │
│ 💳 Preferred: bKash             │  Preference
└─────────────────────────────────┘
```

- Lists contact's MFS accounts (if shared)
- Verification status
- Request payment info if not available
- Shows preferred payment method

**CHANGE 2: Enhanced Quick Actions**

Add payment quick action button:

```
Before:
[📞 Call] [💬 Message] [📧 Email]

After:
[📞 Call] [💬 Message] [📧 Email] [💸 Pay]
```

- "Pay" button added to quick actions
- Opens Send Money flow with pre-filled recipient
- Shows optimal payment method
- Disabled if no payment info available

**CHANGE 3: Transaction History with Contact**

Add mini transaction history section:

```
New Section (before Share button):
┌─────────────────────────────────┐
│ Recent Transactions  [View All]  │  Section Header
│                                  │
│ Sent ৳1,500    Dec 20, 2024     │  Transaction 1
│ via bKash                        │
│                                  │
│ Received ৳800  Dec 15, 2024     │  Transaction 2
│ via Nagad                        │
│                                  │
│ Sent ৳2,000    Dec 10, 2024     │  Transaction 3
│ via bKash                        │
└─────────────────────────────────┘
```

- Shows last 3 transactions with this contact
- Tap "View All" for complete history
- Quick reference for payment relationship
- Includes amounts, dates, methods

**Effort Estimation:**
- Design: 3 hours
- Implementation: 8 hours
- Data aggregation: 4 hours
- Testing: 3 hours
- **Total: 18 hours (Medium)**

---

### MODIFIED PAGE 7: Settings Home (P-46)

**Original Design:**
- Grouped settings sections
- Account, Preferences, Data, Support
- Profile section at top

**Required Changes:**

**CHANGE 1: Payment Settings Section**

Add new settings group for payments:

```
New Section (after ACCOUNT group):
┌─────────────────────────────────┐
│ PAYMENTS                         │  New Group Header
│                                  │
│ Payment Accounts         →       │  To W-5
│ Payment Preferences      →       │  To S-1
│ Transaction Limits       →       │  To S-2
│ Payment History          →       │  To W-37 filtered
└─────────────────────────────────┘
```

- Dedicated payment management section
- Links to new payment pages
- Icon: Wallet icon (24px, Primary Green)

**Effort Estimation:**
- Design: 1 hour
- Implementation: 2 hours
- Testing: 1 hour
- **Total: 4 hours (Low)**

---

### MODIFIED PAGE 8: Account Settings (P-48)

**Original Design:**
- Email, Phone, Password rows
- Linked Accounts (social)
- Danger zone

**Required Changes:**

**CHANGE 1: Linked MFS Accounts Row**

Add entry for managing MFS accounts:

```
New Row (after Linked Accounts):
┌─────────────────────────────────┐
│ MFS Accounts                  →  │
│ bKash, Nagad linked              │  Status Text
└─────────────────────────────────┘
```

- Shows count/names of linked accounts
- Navigates to MFS Account Management (W-5)
- Badge indicator if account needs re-auth

**Effort Estimation:**
- Design: 0.5 hours
- Implementation: 2 hours
- Testing: 0.5 hours
- **Total: 3 hours (Low)**

---

### MODIFIED PAGE 9: Security (P-49)

**Original Design:**
- PIN Lock toggle
- Biometrics toggle
- Two-Factor Auth
- Login notifications
- Active sessions

**Required Changes:**

**CHANGE 1: Payment Security Section**

Add payment-specific security settings:

```
New Section (after Biometrics):
┌─────────────────────────────────┐
│ Payment Security                 │  Section Header
│                                  │
│ Transaction PIN      [On]        │  Toggle
│ Require for payments over ৳500   │  Description
│                                  │
│ Payment Biometrics   [On]        │  Toggle
│ Use Face ID for payments         │  Description
│                                  │
│ Daily Spend Limit               →│  Link
│ Set maximum daily spending       │  Description
└─────────────────────────────────┘
```

- Separate PIN for payments (optional)
- Biometric confirmation for transactions
- Daily spending limit configuration
- Payment notification preferences

**CHANGE 2: Trusted Devices for Payments**

Add trusted device management:

```
New Section:
┌─────────────────────────────────┐
│ Trusted Devices                  │  Section Header
│                                  │
│ This Device (iPhone 13)          │  Current Device
│ Skip PIN for payments  [On]      │  Toggle
│                                  │
│ Other Devices                   →│  Link
│ Manage trusted devices           │  Description
└─────────────────────────────────┘
```

- Trust current device to skip repeated PIN entry
- Manage other trusted devices
- Revoke trust remotely

**Effort Estimation:**
- Design: 2 hours
- Implementation: 8 hours
- Security implementation: 8 hours
- Testing: 4 hours
- **Total: 22 hours (Medium)**

---

### MODIFIED PAGE 10: Register (P-4)

**Original Design:**
- Full Name, Contact Number, Email, DOB, Password fields
- Register button
- Already have account link

**Required Changes:**

**CHANGE 1: Optional MFS Linking**

Add optional MFS account linking during registration:

```
New Section (after Password field):
┌─────────────────────────────────┐
│ Link Payment Account (Optional)  │  Section Header
│                                  │
│ [  Select MFS Provider  ▼  ]    │  Dropdown
│                                  │
│ Link your bKash, Nagad, or       │  Description
│ Rocket account to start paying   │
│ instantly.                       │
│                                  │
│ [ Skip for now ]                 │  Skip Link
└─────────────────────────────────┘
```

- Optional step during registration
- Can skip and link later
- Speeds up onboarding for payment users
- Pre-fills if coming from MFS partner referral

**Effort Estimation:**
- Design: 1 hour
- Implementation: 4 hours
- Testing: 2 hours
- **Total: 7 hours (Low)**

---

### MODIFIED PAGES 11-13: Minor Changes

**PAGE: Search Results (P-29)**
- Add filter for payment transactions
- Show payment-related results in separate tab
- Effort: 4 hours (Low)

**PAGE: Your Digital Business Card (P-38)**
- Add payment QR code option (bKash/Nagad/Rocket QR)
- Include MFS numbers on digital card
- Effort: 3 hours (Low)

**PAGE: Privacy Settings (P-56)**
- Add toggle for sharing payment info with contacts
- MFS data privacy settings
- Effort: 3 hours (Low)

---

# 5. PAYMENT FLOW ARCHITECTURE

## 5.1 System Architecture Overview

### Architectural Pattern
Mobile Wallet employs a **Payment Orchestration Layer** architecture that abstracts MFS provider complexities behind a unified interface.

### High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                   MOBILE WALLET APPLICATION                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   UI Layer  │  │ Business    │  │  Data Layer │         │
│  │  (Flutter)  │→ │   Logic     │→ │   (Local)   │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│         │                 │                  │               │
│         └─────────────────┼──────────────────┘               │
│                           ↓                                  │
│              ┌─────────────────────────┐                     │
│              │  PAYMENT ORCHESTRATION  │                     │
│              │         LAYER           │                     │
│              └───────────┬─────────────┘                     │
│                          │                                   │
│         ┌────────────────┼────────────────┐                 │
│         │                │                │                 │
│         ↓                ↓                ↓                 │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐        │
│  │    bKash     │ │    Nagad     │ │    Rocket    │        │
│  │   Adapter    │ │   Adapter    │ │   Adapter    │        │
│  └──────┬───────┘ └──────┬───────┘ └──────┬───────┘        │
│         │                │                │                 │
└─────────┼────────────────┼────────────────┼─────────────────┘
          │                │                │
          │    HTTPS/API   │                │
          │                │                │
          ↓                ↓                ↓
┌─────────────────────────────────────────────────────────────┐
│            EXTERNAL MFS PROVIDER APIs                       │
│                                                             │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐        │
│  │ bKash API    │ │ Nagad API    │ │ Rocket API   │        │
│  │ Gateway      │ │ Gateway      │ │ Gateway      │        │
│  └──────────────┘ └──────────────┘ └──────────────┘        │
└─────────────────────────────────────────────────────────────┘
```

## 5.2 Payment Orchestration Layer

### Purpose
The orchestration layer provides:
- **Abstraction:** Unified API regardless of underlying provider
- **Routing:** Intelligent selection of payment provider
- **Retry Logic:** Automatic fallback if primary method fails
- **Caching:** Local storage of balances and transaction states
- **Security:** Encryption, tokenization, secure credential storage

### Core Components

| Component | Responsibility |
|-----------|----------------|
| Payment Router | Selects optimal payment provider based on rules |
| Transaction Manager | Handles transaction lifecycle and state |
| Provider Registry | Maintains list of available MFS providers |
| Credential Vault | Securely stores API keys and user tokens |
| Balance Aggregator | Fetches and consolidates balances |
| Transaction Logger | Records all payment activities |
| Error Handler | Manages failures and retry logic |

### Provider Adapter Interface

Each MFS provider has a dedicated adapter implementing a common interface:

**Interface Definition:**

```
Interface: PaymentProviderAdapter

Methods:
- authenticate(credentials) → AuthToken
- getBalance(userToken) → Balance
- sendMoney(userToken, recipient, amount) → TransactionResult
- receiveMoney(userToken, amount) → PaymentRequest
- getTransactionHistory(userToken, dateRange) → Transaction[]
- refundTransaction(transactionId) → RefundResult
- verifyAccount(accountNumber) → VerificationResult
```

**Adapter Implementations:**

| Provider | Auth Method | Rate Limit | Special Features |
|----------|-------------|------------|------------------|
| bKash | OAuth 2.0 | 100 req/min | Merchant payments, Webhooks |
| Nagad | API Key/Secret | 200 req/min | Government integrations |
| Rocket | OAuth 2.0 | 50 req/min | Bank account linking (DBBL) |

## 5.3 Transaction State Machine

### Transaction Lifecycle

```
                 ┌──────────────┐
                 │  INITIATED   │  User starts payment
                 └──────┬───────┘
                        │
                        ↓
                 ┌──────────────┐
                 │  VALIDATING  │  Check balance, limits
                 └──────┬───────┘
                        │
                        ↓
                 ┌──────────────┐
                 │  AUTHORIZED  │  User confirms with PIN/OTP
                 └──────┬───────┘
                        │
                        ↓
                 ┌──────────────┐
                 │  PROCESSING  │  API call to MFS provider
                 └──────┬───────┘
                        │
              ┌─────────┼─────────┐
              │                   │
              ↓                   ↓
       ┌──────────────┐    ┌──────────────┐
       │  COMPLETED   │    │    FAILED    │
       └──────────────┘    └──────┬───────┘
                                  │
                                  ↓
                           ┌──────────────┐
                           │   REFUNDED   │  (if applicable)
                           └──────────────┘
```

### State Descriptions

| State | Description | User Action | System Action |
|-------|-------------|-------------|---------------|
| INITIATED | Payment request created | Enter amount & recipient | Validate inputs |
| VALIDATING | Checking eligibility | Wait | Check balance, limits, recipient |
| AUTHORIZED | User confirmed | Enter PIN/biometric | Store authorization |
| PROCESSING | Sent to MFS API | Wait | API call, monitor status |
| COMPLETED | Success | View receipt | Update balance, notify |
| FAILED | Error occurred | Retry or cancel | Log error, rollback |
| REFUNDED | Money returned | None | Reverse transaction |

### Timeout Handling
- Validation: 10 seconds max
- Authorization: 3 minutes (user input)
- Processing: 30 seconds max
- Auto-cancel after 5 minutes of inactivity

## 5.4 Payment Routing Logic

### Routing Decision Factors

| Factor | Weight | Description |
|--------|--------|-------------|
| User Preference | 40% | Default payment method set by user |
| Cost Optimization | 30% | Lowest transaction fee |
| Recipient Match | 20% | Same provider as recipient |
| Availability | 10% | Provider uptime and balance |

### Routing Algorithm

**Step 1: Availability Filter**
- Remove providers with insufficient balance
- Remove providers currently offline
- Remove unlinked providers

**Step 2: User Preference Check**
- If user has set "Always use X", select X (unless unavailable)
- If user enabled "Always ask", skip auto-routing

**Step 3: Cost Analysis**
- Calculate total cost (amount + fee) for each available provider
- Rank by lowest cost

**Step 4: Recipient Optimization**
- If recipient uses specific MFS, boost that provider's score
- Benefit: Faster processing, lower inter-operator fees

**Step 5: Final Selection**
- Apply weighted scoring
- Select highest-scoring provider
- Present to user for confirmation (unless auto-confirm enabled)

### Example Routing Scenario

**Scenario:**
User wants to send ৳1,000 to John Doe.

**Context:**
- User has: bKash (৳5,000), Nagad (৳2,000), Rocket (not linked)
- John Doe uses: bKash
- User preference: Auto-select cheapest
- Fees: bKash 0.5%, Nagad 1%, Rocket N/A

**Routing Calculation:**

| Provider | Available | Balance OK | Fee | Total Cost | Recipient Match | Score |
|----------|-----------|------------|-----|------------|-----------------|-------|
| bKash | Yes | Yes | ৳5 | ৳1,005 | Yes (+20) | 90 |
| Nagad | Yes | Yes | ৳10 | ৳1,010 | No | 65 |
| Rocket | No | - | - | - | - | 0 |

**Result:** bKash selected automatically
**User Notification:** "Sending via bKash to save ৳5 in fees"

## 5.5 Security Architecture

### End-to-End Security Flow

```
┌──────────────────────────────────────────────────────────────┐
│  USER DEVICE (Mobile Wallet App)                             │
│                                                              │
│  1. User Input (Amount, PIN)                                 │
│         │                                                    │
│         ↓                                                    │
│  2. Local Encryption (AES-256)                               │
│         │                                                    │
│         ↓                                                    │
│  3. Secure Storage (Keychain/Keystore)                       │
│         │                                                    │
│         ↓                                                    │
│  4. HTTPS Request (TLS 1.3)                                  │
│         │                                                    │
└─────────┼────────────────────────────────────────────────────┘
          │
          ↓
┌──────────────────────────────────────────────────────────────┐
│  MOBILE WALLET BACKEND SERVER                                │
│                                                              │
│  5. API Gateway (Rate limiting, Authentication)              │
│         │                                                    │
│         ↓                                                    │
│  6. Request Validation & Sanitization                        │
│         │                                                    │
│         ↓                                                    │
│  7. Decrypt User PIN (One-way hash for comparison)           │
│         │                                                    │
│         ↓                                                    │
│  8. Provider-Specific Encryption (Provider's public key)     │
│         │                                                    │
└─────────┼────────────────────────────────────────────────────┘
          │
          ↓
┌──────────────────────────────────────────────────────────────┐
│  MFS PROVIDER API                                            │
│                                                              │
│  9. OAuth/API Key Validation                                 │
│         │                                                    │
│         ↓                                                    │
│  10. Transaction Processing                                  │
│         │                                                    │
│         ↓                                                    │
│  11. Response (Encrypted)                                    │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### Security Measures

| Layer | Security Control | Implementation |
|-------|------------------|----------------|
| Data at Rest | AES-256 Encryption | Sensitive data encrypted in local storage |
| Data in Transit | TLS 1.3 | All API calls over HTTPS |
| Authentication | Multi-Factor | PIN + Biometric + OTP |
| Authorization | Token-Based | JWT with short expiry (15 min) |
| API Keys | Secure Vault | Stored in platform keychain (iOS Keychain, Android Keystore) |
| PINs | Never Stored | One-way hash only, compared server-side |
| Tokenization | Payment Tokens | Replace sensitive card data with tokens |
| Rate Limiting | API Gateway | Prevent brute force and DoS attacks |
| Audit Logging | Immutable Logs | All transactions logged for forensics |

### Compliance Framework

**Bangladesh Bank Guidelines:**
- KYC verification for accounts over ৳25,000 monthly
- Transaction monitoring for anti-money laundering (AML)
- Daily transaction limit enforcement
- Customer due diligence (CDD)

**PCI-DSS Compliance:**
- Applicable if handling international cards
- Secure cardholder data storage
- Regular security audits

**GDPR/Privacy:**
- User consent for data sharing
- Right to data export and deletion
- Anonymized analytics only

---

# 6. USER EXPERIENCE JOURNEYS

## 6.1 Journey 1: First-Time User Linking bKash

### Scenario
New Mobile Wallet user wants to link their bKash account to start making payments.

### User Journey Map

**STEP 1: Onboarding Prompt**
- **Screen:** Post-registration welcome screen
- **Element:** "Link your bKash account to start paying" card
- **CTA:** "Link bKash" button
- **User Feeling:** 😊 Excited to set up

**STEP 2: Provider Selection**
- **Screen:** Link MFS Account - Selection (W-1)
- **Action:** User taps "bKash" card
- **User Feeling:** 😊 Clear options

**STEP 3: bKash Number Entry**
- **Screen:** Link bKash Account (W-2)
- **Action:** User enters phone number (+880 17XXXXXXXX)
- **System:** Validates number format
- **Action:** User checks consent checkbox
- **Action:** Taps "Continue to Verify"
- **User Feeling:** 😐 Cautious about data sharing

**STEP 4: Redirect to bKash**
- **Screen:** External - bKash app/webview
- **System:** Opens bKash OAuth flow
- **bKash:**