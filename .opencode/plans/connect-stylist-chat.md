# Plan: Integrate Stylist Chat Screen

## Goal
Create a stylist chat screen styled in Monograph aesthetic and connect it to the existing stylist booking flow.

## Files

### 1. NEW: `lib/features/stylist/screens/stylist_chat_screen.dart`

Based on user's StylistChatScreen code, adapted to Monograph design:

**Styling changes (user's code → Monograph):**

| Element | Original | Monograph |
|---|---|---|
| Background | `Colors.white` | `_bg` (0xFFF7F6F4) |
| AppBar bg | `Colors.white` | `Colors.white` (keep clean) |
| Chat bubble (stylist) | `Colors.grey.shade100` | `Colors.white` with `_lightGrey` border |
| Chat bubble (user) | `Colors.black` | `_black` (same) |
| Date badge | `Colors.grey.shade100` | `Colors.white` + `_lightGrey` border |
| Input bg | `Colors.grey.shade100` | `Colors.white` + `_lightGrey` border |
| Product card border | `Colors.grey.shade300` | `_lightGrey` |
| Send btn bg | `Colors.black` | `_black` (same) |
| Back btn | `Navigator.pop(context)` | `context.pop()` (GoRouter) |
| Font sizes | 16/13 | Keep + Georgia for product card title |
| Palette constants | Inline | `_black` / `_grey` / `_lightGrey` / `_bg` / `_red` |

**Structural changes:**
- Keep custom AppBar (not MonographHeader) — chat needs stylist avatar, name, online status, and action icons
- Back button uses `context.pop()` (GoRouter) instead of `Navigator.pop()`
- Replace `Color(0xFF...)` and `Colors.grey.shadeX` with our constants
- Add `import 'package:go_router/go_router.dart';`
- Product card image → use a real Unsplash URL
- "ADD TO SELECTION" button → navigates to cart or product detail

### 2. MODIFY: `lib/navigation/app_router.dart`

Add new route outside ShellRoute (pushed screen, not a tab):

```dart
GoRoute(path: '/stylist-chat', builder: (_, _) => const StylistChatScreen()),
```

### 3. MODIFY: `lib/features/stylist/screens/stylist_booking_screen.dart`

Connect chat to booking flow:
- After tapping "BOOK APPOINTMENT" → navigate to `/stylist-chat` instead of showing SnackBar
- Pass selected stylist name so chat can show the right stylist

**Option A (simple):** Navigate to chat on "BOOK APPOINTMENT":
```dart
onTap: () => context.push('/stylist-chat'),
```

**Option B (richer):** Add a "CHAT" button on each stylist card so user can start chatting before booking. Keep "BOOK APPOINTMENT" separate.

I recommend **Option A** — simplest integration. If user wants to add more, we can extend later.

## Verification
- `flutter analyze` — zero issues
- Tap Stylist tab → Booking screen → Book Appointment → Chat screen opens
- Chat screen shows Monograph styling with proper back navigation
