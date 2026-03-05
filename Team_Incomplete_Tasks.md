# ✅ Team Management — Incomplete Tasks Checklist
**Project:** Smart Contact Wallet (Mobile Wallet BD)
**Source:** `TeamDetailed.txt` + `MASTER_PROJECT_PLAN_V1.txt`
**Last Updated:** 2026-03-04

---

## 📋 Legend
- `[ ]` — Not started
- `[/]` — In progress / Partially done
- `[x]` — Completed (already in code)

---

## 🏗️ 1. DATA MODEL

| # | Task | Status | Notes |
|---|------|--------|-------|
| 1.1 | `Team` entity — id, name, description, photoUrl, ownerId, members, timestamps | `[x]` | Done via Freezed |
| 1.2 | `TeamMember` entity — userId, role, joinedAt, status | `[x]` | Done via Freezed |
| 1.3 | Add `category` field to Team (e.g. Sales & Marketing) | `[x]` | Added to Team model |
| 1.4 | Add `totalExpenses` field to Team | `[x]` | Added to Team model |
| 1.5 | Create `TeamExpense` entity model | `[x]` | Support Wallet tab |
| 1.6 | Create `TeamChatMessage` entity model | `[x]` | Support Group Chat |
| 1.7 | Create `TeamActivityLog` entity model | `[x]` | Support Recent Activity feed |
| 1.8 | Add `jobTitle` field to TeamMember | `[x]` | Added to TeamMember model |
| 1.9 | Handle `role` enum properly (OWNER, ADMIN, CO-ADMIN, MEMBER, VIEWER) | `[/]` | Using Strings currently in UI |
| 1.10 | Add `stats` field to Team: `sharedContactsCount` | `[x]` | Added to Team model |
| 1.11 | Add `inviteCode` or email-invite token system to Team | `[x]` | Added to Team model |

---

## 🔥 2. FIRESTORE / BACKEND

| # | Task | Status | Notes |
|---|------|--------|-------|
| 2.1 | `teamsCollection` reference in `FirestoreService` | `[x]` | Used in impl |
| 2.2 | Firestore security rules for `teams` collection | `[x]` | Added to `firestore.rules` |
| 2.3 | Firestore index for `memberIds arrayContains` query | `[x]` | Added to `firestore.indexes.json` |
| 2.4 | Firestore rule: Only owner can delete team | `[x]` | Enforced in code and firestore rules |
| 2.5 | Firestore rule: Only owner/admin can add/remove members | `[x]` | Added rule restrict member modifications to owners |
| 2.6 | Cloud Function / trigger: notify members when added to a team | `[ ]` | Planned team-invite notification flow |
| 2.7 | Cascade delete: when team is deleted, remove shared contact references | `[x]` | Batch delete implemented |
| 2.8 | Stream-based real-time team updates (instead of one-shot `FutureProvider`) | `[x]` | Migrated to `StreamProvider` |

---

## 🧩 3. DOMAIN / REPOSITORY

| # | Task | Status | Notes |
|---|------|--------|-------|
| 3.1 | `createTeam` — all CRUD methods | `[x]` | Done |
| 3.2 | `getUserTeams` — query by memberIds | `[x]` | Done |
| 3.3 | `addMember` / `removeMember` / `deleteTeam` | `[x]` | Done |
| 3.4 | `updateTeam` — update name, description, photoUrl | `[x]` | Done (but not connected to any UI) |
| 3.5 | `leaveTeam` (via removeMember on self) | `[x]` | Done in TeamNotifier |
| 3.6 | `inviteMember` by email — send email invite (not just user ID lookup) | `[x]` | Plan page 44: "Enter Email → Send Invite" |
| 3.7 | `acceptInvite` / `rejectInvite` flow for pending members | `[x]` | Status: `'pending'`: Added UI to TeamListScreen |
| 3.8 | `updateMemberRole` — promote/demote member (Admin ↔ Member) | `[x]` | Implemented in TeamRepositoryImpl + TeamNotifier |
| 3.9 | `getSharedContacts(teamId)` on team repository | `[ ]` | Currently lives in contacts feature; should be on team repo |
| 3.10 | Pagination for large teams / shared contact lists | `[ ]` | Master plan requires pagination on all lists |
| 3.11 | `addTeamExpense` / `getTeamExpenses` repository methods | `[x]` | Implemented in TeamRepositoryImpl |
| 3.12 | `sendTeamChatMessage` / `getTeamChatStream` methods | `[x]` | Implemented in TeamRepositoryImpl |
| 3.13 | `getTeamActivityStream` to fetch audit logs | `[x]` | Implemented in TeamRepositoryImpl |

---

## 🎯 4. STATE MANAGEMENT (PROVIDERS)

| # | Task | Status | Notes |
|---|------|--------|-------|
| 4.1 | `userTeamsProvider` (FutureProvider) | `[x]` | Done |
| 4.2 | `teamDetailsProvider(teamId)` (FutureProvider.family) | `[x]` | Done |
| 4.3 | `teamNotifierProvider` (StateNotifier — create, add, remove, delete, leave) | `[x]` | Done |
| 4.4 | Convert `userTeamsProvider` to `StreamProvider` for real-time updates | `[x]` | Done |
| 4.5 | Convert `teamDetailsProvider` to StreamProvider.family | `[x]` | Done |
| 4.6 | `teamMembersProvider(teamId)` — separate provider to watch only member list | `[x]` | Implemented |
| 4.7 | `pendingInvitesProvider` — list teams the user has been invited to | `[x]` | Required for invite accept/reject flow |
| 4.8 | `updateMemberRole` action in `TeamNotifier` | `[x]` | Needed for Role Management page (page 45) |
| 4.9 | `updateTeamProfile` action in `TeamNotifier` (name, description, photo) | `[x]` | Implemented in TeamNotifier; wired to Settings Tab Edit button |
| 4.10 | `teamWalletProvider(teamId)` (StreamProvider) to fetch expenses | `[x]` | Implemented as `teamExpensesProvider` |
| 4.11 | `teamChatProvider(teamId)` (StreamProvider) for live chat messages | `[x]` | Implemented |
| 4.12 | `teamActivityProvider(teamId)` (StreamProvider) for recent events | `[x]` | Implemented |

---

## 📱 5. SCREENS & PAGES

### 5A. Team Dashboard (Overview)
| # | Task | Status | Notes |
|---|------|--------|-------|
| 5.1 | Team overview header: Avatar, Name, Member count, Total Expenses | `[x]` | Green header implemented |
| 5.2 | Dashboard Tabs: [Members] [Wallet] [Settings] | `[x]` | Tabs implemented in TeamDetailsScreen |
| 5.3 | Stats Row: Shared Contacts, Active Members, Recent Activity counts | `[x]` | Stats row implemented |
| 5.4 | Quick Action Buttons: Pill-shaped "+ Add Member", "Share Contacts" | `[x]` | Quick actions implemented |
| 5.5 | Recent Activity Feed UI | `[x]` | Chat tab and activity feed wired to live streams on TeamDetailsScreen |
|- [ ] 5. Build UI Screens
  - [x] Team Dashboard / Overview
  - [x] Team Wallet
  - [x] Team Directory & Members
  - [x] Team Settings Tab
  - [x] Invite Member Screen
  - [x] Polished Create Team Screen
  - [x] Polished Team List Screen| Notes |
|---|------|--------|-------|
| 5.7 | Directory App Bar: Filter (funnel) icon on the right | `[x]` | Filter popup in TeamDirectoryTab |
| 5.8 | Prominent rounded search bar below app bar | `[x]` | Rounded search field implemented |
| 5.9 | Organized member list (Group by Admins vs Members) | `[x]` | Two sections: Admins & Owners / Members |
| 5.10 | Member indicators: Online status dot, Crown for owner, Role badge | `[x]` | All 3 indicators implemented |
| 5.11 | Show Member Job Title | `[x]` | Shown in subtitle |
| 5.12 | Direct chat bubble icon next to member | `[x]` | Chat icon with snackbar placeholder |
| 5.13 | Green FAB (+) for Search, Filter, and quick chat | `[x]` | Search toggle FAB implemented |

### 5C. Team Wallet
| # | Task | Status | Notes |
|---|------|--------|-------|
| 5.14 | UI: Large balance display "Total Expenses" | `[x]` | Implemented in TeamWalletTab |
| 5.15 | Action row: "Add Expense", "Deposit", "Withdraw" | `[x]` | Built `_WalletActionButton` row |
| 5.16 | "Recent Transactions" list view | `[x]` | Stream builder implemented |
| 5.17 | Map UI to list of `TeamExpense` objects | `[x]` | Displays title, category icon, date, amount |
| 5.18 | Backend: `teamExpensesProvider` to fetch from Firestore | `[x]` | Done in `team_provider.dart` |
| 5.19 | "Add Expense" dialog and backend logic | `[x]` | Form built, batch commit implemented |

### 5D. Invite Member (Page 44)
| # | Task | Status | Notes |
|---|------|--------|-------|
| 5.20 | `InviteMemberScreen` — Multi-select checkbox UI | `[x]` | Done with sticky "Send Invites" button |
| 5.21 | Search bar for global users/contacts | `[x]` | Implemented with auto-search |
| 5.22 | Show user email address in the selection list | `[x]` | Included in UI |

### 5E. Team Settings & Role Management
| # | Task | Status | Notes |
|---|------|--------|-------|
| 5.21 | "Manage Roles" screen/action | `[x]` | Per-member role dropdown in Settings tab |
| 5.22 | "Delete Team" solid red button at bottom | `[x]` | In Danger Zone section |

### 5F. Create Team Screen
| # | Task | Status | Notes |
|---|------|--------|-------|
| 5.23 | Large circular dotted "Upload Logo" area | `[x]` | Built UI with placeholder logic |
| 5.24 | "Category" dropdown selector (e.g. Sales & Marketing) | `[x]` | Implemented with kTeamCategories |
| 5.25 | Image picker → Storage upload backend connection | `[x]` | Implemented with image_picker + Firebase Storage upload |

### 5G. Team List Screen (My Teams)
| # | Task | Status | Notes |
|---|------|--------|-------|
| 5.26 | Pill-shaped Role Badge on team card (e.g. "Admin") | `[x]` | Implemented in _TeamCard |
| 5.27 | Prominent green FAB (+) to create/join team | `[x]` | Added to TeamListScreen |
| 5.28 | Show pending invite badge on team list items | `[x]` | Added pending dot indicator |

---

## 🔗 6. CROSS-FEATURE INTEGRATION

| # | Task | Status | Notes |
|---|------|--------|-------|
| 6.1 | Share digital card with team via `ShareOptionsSheet` | `[x]` | Done — `_showTeamSelectionDialog` |
| 6.2 | Unshare digital card from team in `_SharedCardsTab` | `[x]` | Done |
| 6.3 | Share contacts with team via `_ShareContactDialog` | `[x]` | Done |
| 6.4 | Unshare contact from team in `_SharedContactsTab` | `[x]` | Done |
| 6.5 | "Teams" quick action on Home Screen | `[x]` | Done — `context.push('/settings/teams')` |
| 6.6 | "My Teams" in Settings → Collaboration section | `[x]` | Done |
| 6.7 | View shared card details/preview from `_SharedCardsTab` | `[ ]` | `TODO:` comment at `team_details_screen.dart:337` |
| 6.8 | Shared contact → full contact detail view (read-only) for non-owners | `[ ]` | No navigation on shared contacts tab |
| 6.9 | Notifications page (page 13): show "Team invite" notifications | `[ ]` | Notification center not integrated with team invites |
| 6.10 | Recent Activity (page 12): log "Joined team [X]" / "Added [User] to team" | `[x]` | Activity log integration complete |
| 6.11 | Contact's `sharedWithTeams` field properly updated on share/unshare | `[/]` | Implemented via `shareContact()` but not fully validated |
| 6.12 | `cardsSharedWithTeam` provider uses `card.sharedWithTeams` field | `[x]` | Done via `card_design_provider.dart` |
| 6.13 | Contacts feature: `sharedContactsProvider(teamId)` provider | `[x]` | Referenced in `_SharedContactsTab` |

---

## 🛡️ 7. SECURITY & ACCESS CONTROL

| # | Task | Status | Notes |
|---|------|--------|-------|
| 7.1 | Firestore rule: Read team only if user is in `memberIds` | `[x]` | Enforced in firestore.rules |
| 7.2 | Firestore rule: Write/update only by owner or admin | `[x]` | Owner enforced in firestore.rules; full admin requires Cloud Function |
| 7.3 | Firestore rule: Members can only read, not write team doc | `[x]` | Enforced except join/leave which requires memberIds update |
| 7.4 | Client-side guard: disable admin actions if current user is not owner | `[/]` | Partially done (`isOwner` checks in UI) |
| 7.5 | Prevent non-members from accessing team data via direct URL/ID | `[x]` | Client guard implemented |

---

## 🎨 8. UI / UX POLISH

| # | Task | Status | Notes |
|---|------|--------|-------|
| 8.1 | Shimmer/skeleton loading for team list (not just spinner) | `[x]` | Shimmer skeleton implemented in TeamListScreen |
| 8.2 | Empty state illustration for "No teams" screen | `[x]` | Polished empty state added |
| 8.3 | Pull-to-refresh on Team List and Team Details | `[x]` | RefreshIndicator already in TeamListScreen |
| 8.4 | Haptic feedback on team creation success | `[x]` | Added HapticFeedback |
| 8.5 | Proper transitions: slide animation when entering team detail | `[x]` | Added CustomTransitionPage |
| 8.6 | "Copy invite link" / share team invite link | `[ ]` | No invite link feature exists |
| 8.7 | Team member count badge on Settings → My Teams tile | `[x]` | Dynamic count via userTeamsProvider |
| 8.8 | Bottom Sheet for share/filter in team screens (not center dialogs) | `[x]` | Refactored Add Member and Share to bottom sheets |
| 8.9 | Resolve member avatar + display name in members list | `[x]` | Implemented using `teamMemberProfileProvider` |
| 8.10 | Pagination / infinite scroll in shared contacts/cards tabs | `[ ]` | All lists load everything at once |

---

## 🧪 9. TESTING

| # | Task | Status | Notes |
|---|------|--------|-------|
| 9.1 | Unit tests for `TeamRepositoryImpl` (mock Firestore) | `[ ]` | No tests exist in `test/` for team feature |
| 9.2 | Unit tests for `TeamNotifier` | `[ ]` | — |
| 9.3 | Widget tests for `TeamListScreen` | `[ ]` | — |
| 9.4 | Widget tests for `CreateTeamScreen` | `[ ]` | — |
| 9.5 | Integration test: Create team → Add member → Share contact flow | `[ ]` | — |

---

## 📊 SUMMARY

| Category | Total | Completed | Incomplete |
|---|---|---|---|
| Data Model | 11 | 10 | 1 |
| Firestore/Backend | 8 | 7 | 1 |
| Domain/Repository | 13 | 8 | 5 |
| State Management | 12 | 9 | 3 |
| Screens & Pages | 28 | 24 | 4 |
| Cross-Feature | 13 | 7 | 6 |
| Security | 5 | 1 | 4 |
| UI/UX Polish | 10 | 5 | 5 |
| Testing | 5 | 0 | 5 |
| **TOTAL** | **105** | **72** | **33** |

---

## 🚨 TOP PRIORITY ITEMS (Do First)

1. **[x] 5.13** — Green FAB for search/filter in Team Directory.
2. **[ ] 6.7 / 6.8** — View shared card/contact details from the team tabs.
3. **[ ] 3.6 / 3.7** — Implement `inviteMember` by email + `acceptInvite` / `rejectInvite` flow.
4. **[ ] 4.7** — `pendingInvitesProvider` for invites the user has received.

