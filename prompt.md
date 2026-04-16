Here is your Flutter developer prompt:

---

# 🧪 Flutter Prompt: Air-Powered Microfluidic Clock

---

## 🎯 Objective

Write a complete Flutter/Dart application that displays a **real-time clock** with an **air-powered microfluidic visual aesthetic**. The UI should feel like a living lab-on-chip device — with fluid flowing through etched channels, glowing tubes, and pressurized movement. The default color palette is **orange and dark orange on a near-black background**.

---

## 📱 Platform Target
- ✅ Android & iOS
- Use `flutter/material.dart` and `dart:async` only
- Avoid heavy packages to preserve battery life

---

## 🕐 Feature 1 — Dual Clock Mode (Toggle Switch)

Implement a **toggle button** to switch between two display modes:

### 🔢 Digital Mode
- Display time as `HH:MM:SS` in a **custom microfluidic-style font**
- Each digit should appear to be **filled with flowing orange fluid** from bottom to top — simulate this with an animated gradient fill that rises and falls per digit change
- Digits are enclosed in **etched rectangular micro-channel frames** with rounded corners and a faint inner shadow
- Seconds ticker should pulse with a **bubble-travel animation** moving left to right between separators (`:`)
- Use `TextStyle` with a monospaced or LCD-style font (use `GoogleFonts.sharetech` or fallback to monospace)

### 🕰️ Analog Mode
- Draw the clock face using **CustomPainter**
- Clock face = dark background with **engraved circular micro-channel ring** as the dial
- **Hour, Minute, and Second hands = fluid-filled tubes:**
    - Each hand is a rounded-cap line rendered as a **semi-transparent tube**
    - The tube appears filled with flowing orange fluid using an animated **shimmer gradient** running along its length
    - The second hand fluid should visibly **flow/travel** along the tube every tick
- Hour markers = small **bubble-shaped dots** etched into the channel ring
- Center pivot = a glowing **pressurized node** circle in dark orange

---

## 🎨 Feature 2 — Color Customization

- Provide a **color picker row** with at least **6 preset color themes:**

| Theme Name | Primary | Accent |
|---|---|---|
| Lava (default) | `#FF6600` | `#8B2500` |
| Arctic | `#00CFFF` | `#004F7C` |
| Venom | `#39FF14` | `#1A5C00` |
| Plasma | `#BF00FF` | `#4B0082` |
| Crimson | `#FF1744` | `#7F0000` |
| Gold | `#FFD700` | `#8B6914` |

- Tapping a color swatch instantly **re-themes** all fluid, tube glow, and digit fill animations
- Active swatch should have a glowing ring border using `BoxShadow`
- Store selected theme in `setState` (no persistence needed)

---

## 🔋 Feature 3 — Battery Optimization

Apply ALL of the following techniques to minimize power draw:

1. **Single `Timer.periodic` at 1-second intervals** — no sub-second timers unless animating
2. Use **`RepaintBoundary`** around the clock widget to isolate repaints
3. For analog mode, use **`shouldRepaint`** in `CustomPainter` — only return `true` when time actually changes
4. All animations must use **`AnimationController` with `vsync`** tied to the widget's `TickerProviderStateMixin` — dispose all controllers in `dispose()`
5. **Dark background (`Color(0xFF0D0D0D)`)** — OLED-friendly to minimize pixel-level power on AMOLED screens
6. Avoid `opacity` widgets — use `Color.withOpacity()` directly in paint calls
7. Use **`const` constructors** wherever possible

---

## 🧱 Code Structure Requirements

```
lib/
├── main.dart                  # App entry, MaterialApp setup
├── clock_screen.dart          # Main screen with toggle + color picker
├── digital_clock.dart         # Digital clock widget
├── analog_clock.dart          # Analog clock with CustomPainter
├── microfluidic_painter.dart  # CustomPainter for analog face & hands
└── theme_config.dart          # Color theme data class & presets
```

---

## 🎨 Visual Style Reference

- Background: `Color(0xFF0D0D0D)` — near black (OLED safe)
- Channel grooves: subtle `Color(0xFF1A1A1A)` etched lines with inner shadow
- Fluid glow: use `MaskFilter.blur(BlurStyle.normal, 6)` on Canvas for tube glow
- All edges: `BorderRadius.circular(12)` for microfluidic channel feel
- Toggle switch: styled pill button, not default Material toggle

---

## ⚙️ Technical Constraints

- Dart null safety (`sound null safety`)
- Minimum Flutter SDK: `3.10+`
- No third-party animation libraries (no Rive, Lottie)
- `GoogleFonts` is the only allowed external package (optional, for digit font)
- All `AnimationController`s must be properly **initialized in `initState`** and **disposed in `dispose`**
- The app must run without errors on both **Android API 21+** and **iOS 13+**

---

## ✅ Deliverable

A **single self-contained response** with all `.dart` files written in full, properly separated by filename headers, ready to copy-paste into a Flutter project with zero modifications beyond `pubspec.yaml` package declarations (which should also be provided).

---