# Plan: Replace Account Page with Settings Screen

## Goal
Replace the current Account page (`lib/features/profile/screens/profile_screen.dart`) with a Monograph-styled settings screen matching the user's provided design, while keeping the shared `MonographHeader` and editorial palette.

## Changes (single file)

**File:** `lib/features/profile/screens/profile_screen.dart`

### What's removed
- Old `ProfileScreen` (StatelessWidget) with:
  - CircleAvatar + name/email
  - Edit Profile / Orders / Logout ListTiles
  - `AppStrings.profile` import
  - `AppColors` import

### What's added
- New `ProfileScreen` (StatefulWidget) with sections:

| Section | Items | Widget |
|---|---|---|
| Title | "Account Settings" + subtitle | Georgia 26pt + grey body text |
| Personal Info | FULL NAME / EMAIL / PHONE (read-only + "EDIT" label) | `_infoRow()` |
| Security | Change Password (subtitle, chevron) | `_settingsTile()` |
| Notifications | 3 toggles (Newsletter, Order Updates, Stylist Alerts) | `_notificationRow()` with `Switch` |
| Preferences | Language selector (English UK, dropdown) | Container with row |
| Legal | Terms of Service, Privacy Policy, Cookie Preferences | `_legalTile()` with `open_in_new` icon |
| Delete Account | Centered red "DELETE ACCOUNT" + warning text | Column |

### Styling (Monograph palette — matches Stylist screen)
- `_bg` = Color(0xFFF7F6F4) — scaffold background
- `_black` = Color(0xFF111111) — text, switches, icons
- `_grey` = Color(0xFF888888) — labels, subtitles, secondary text
- `_lightGrey` = Color(0xFFE8E6E1) — borders
- `_red` = Color(0xFFB94040) — delete account
- `Colors.white` — card backgrounds for tiles

### Layout structure
```
Scaffold(backgroundColor: _bg)
  SafeArea
    Column
      MonographHeader()          ← fixed top, shared widget
      Expanded
        SingleChildScrollView    ← scrollable settings content
          sections...
```

### State management
- 3 local `bool` fields: `newsletter`, `orderUpdates`, `stylistAlerts`
- `setState()` on toggle changes — same pattern as Stylist booking screen

### What stays the same
- Route: `/account` → `ProfileScreen` (no router changes needed)
- Nav tab: Account at index 3 → `/account` (no changes to `_routes`)
- No new files, no new imports needed beyond `MonographHeader`

## Verification
- `flutter analyze` must pass with zero issues
- Navigation: all 4 tabs (Home, Lookbook, Stylist, Account) load correctly with shared header
