# PenguinFlow Figma Plugin — Screen Generator

Generates the complete PenguinFlow design system + 11 mobile screens in one click.

## How to Use

1. Open **Figma Desktop** (not browser — plugins from manifest require the desktop app)
2. Go to **Plugins → Development → Import plugin from manifest...**
3. Select the `manifest.json` file from this folder
4. Run the plugin: **Plugins → Development → PenguinFlow Screen Generator**

## What Gets Created

### 🎨 Design System Page
- Color palette (12 colors with swatches + hex codes)
- Typography scale (8 levels: H1–Overline)
- Buttons (primary, secondary, accent, outlined variants)
- Input fields
- Cards
- Spacing reference

### 📱 Mobile Screens (390×844 iPhone 14 frames)
| # | Screen | Description |
|---|--------|-------------|
| 01 | Splash | Penguin mascot, app title, loading bar |
| 02 | Login | Email/password form, social logins |
| 03 | Sign Up | Full registration with password strength |
| 04 | Home | Streak, quick-start timer, daily stats, activity feed |
| 05 | Timer | Dark mode, countdown ring, session controls |
| 06 | Session Complete | Celebration, earned rewards, stats summary |
| 07 | Island | Top-down island view, buildings, XP progress |
| 08 | Building Shop | Grid of purchasable buildings with coin prices |
| 09 | Social Feed | Community posts, likes, comments |
| 10 | Leaderboard | Podium + ranked list, weekly/monthly/all-time |
| 11 | Profile | Avatar, stats, achievements, settings |

## Design Tokens
- **Primary:** #58CC02 (green)
- **Secondary:** #1CB0F6 (blue)
- **Accent:** #FF9600 (orange)
- **Font:** Nunito (falls back to Inter in Figma if Nunito isn't installed)

## Notes
- The plugin uses **Inter** as the font family since it's built into Figma. To use **Nunito**, install Nunito on your system first, then change `FONT_FAMILY` in `code.js` to `"Nunito"`.
- All screens are laid out side-by-side with 60px gaps for easy comparison.
- Elements are individual shapes/text (not auto-layout components) — you can convert them to components after generation.
