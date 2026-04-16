# 🧪 Air-Powered Microfluidic Clock

> A Flutter clock application inspired by the visual language of air-powered microfluidic lab-on-chip devices — featuring fluid-filled tube hands, glowing channel dials, and animated digit fills in a deep orange-on-black aesthetic.

---

## 📸 Preview

| Digital Mode | Analog Mode |
|---|---|
| Fluid-filled digit channels with bubble ticker | Tube hands with flowing shimmer on dark dial |

> *Both modes share the same microfluidic design language — etched grooves, pressurized nodes, and glowing fluid.*

---

## ✨ Features

### 🔢 Digital Clock Mode
- Real-time `HH:MM:SS` display in an LCD/monospaced microfluidic font
- Each digit is enclosed in an **etched rectangular micro-channel frame**
- Animated **fluid fill effect** — orange gradient rises as digit values change
- **Bubble-travel animation** pulses along the `:` separators every second

### 🕰️ Analog Clock Mode
- Full `CustomPainter`-rendered clock face with an **engraved circular channel ring**
- **Hour, Minute & Second hands** rendered as semi-transparent fluid-filled tubes
- Shimmer gradient runs along each tube hand to simulate pressurized fluid flow
- Second hand fluid **visibly travels** along its tube on every tick
- Hour markers displayed as **bubble-shaped etched dots**
- Center pivot rendered as a **glowing pressurized node**

### 🎨 Color Theme Picker
Six built-in themes with instant re-theming across all animations:

| Theme | Primary | Accent |
|---|---|---|
| 🔥 Lava *(default)* | `#FF6600` | `#8B2500` |
| 🧊 Arctic | `#00CFFF` | `#004F7C` |
| ☣️ Venom | `#39FF14` | `#1A5C00` |
| ⚡ Plasma | `#BF00FF` | `#4B0082` |
| 🩸 Crimson | `#FF1744` | `#7F0000` |
| ✨ Gold | `#FFD700` | `#8B6914` |

### 🔋 Battery Optimization
- Single `Timer.periodic` at 1-second intervals — no unnecessary sub-second timers
- `RepaintBoundary` isolates clock repaints from the rest of the UI
- `CustomPainter.shouldRepaint` only triggers on actual time changes
- OLED-safe near-black background (`#0D0D0D`) minimizes pixel power on AMOLED screens
- All `AnimationController`s are properly disposed to prevent memory leaks
- `Color.withOpacity()` used directly in paint calls — no costly `Opacity` widgets
- `const` constructors used wherever possible to reduce widget rebuilds

---

## 🗂️ Project Structure

```
lib/
├── main.dart                  # App entry point, MaterialApp setup
├── clock_screen.dart          # Main screen — toggle switch + color picker
├── digital_clock.dart         # Digital clock widget with fluid fill animation
├── analog_clock.dart          # Analog clock widget wrapper
├── microfluidic_painter.dart  # CustomPainter — clock face, tube hands, nodes
└── theme_config.dart          # ClockTheme data class + 6 preset themes
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `3.10` or higher
- Dart with sound null safety enabled
- A physical or emulated device running:
    - Android API `21+`
    - iOS `13+`

### Installation

**1. Clone the repository**
```bash
git clone https://github.com/Jawad52/microfluidic-clock.git
cd microfluidic-clock
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Run the app**
```bash
# Android
flutter run

# iOS
flutter run -d iphone
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0        # Optional — Share Tech Mono for digital digits
```

> No animation libraries (Rive, Lottie) are used. All animations are built with Flutter's native `AnimationController` and `CustomPainter`.

---

## 🧱 Architecture Notes

### Clock Mode Toggle
The `ClockScreen` widget manages a `bool isDigital` state. Tapping the pill toggle calls `setState()` to swap between `DigitalClock` and `AnalogClock` widgets.

### Theme System
`ThemeConfig` is a lightweight data class holding `primaryColor` and `accentColor`. It is passed down to both clock widgets and the `CustomPainter`. Changing theme triggers a single `setState()` at the screen level — no `InheritedWidget` or state management package needed.

### Analog Painter
`MicrofluidicPainter` extends `CustomPainter` and accepts the current `DateTime` and `ThemeConfig`. It draws:
1. Background fill and outer channel ring
2. Hour bubble markers
3. Hour, Minute, Second tube hands (with shimmer gradient)
4. Center pressurized node

`shouldRepaint` compares `DateTime` by second — repaints only when the time changes.

### Digital Animation
Each digit widget uses an `AnimationController` driven by `Tween<double>(begin: 0.0, end: 1.0)`. On digit change, it animates a `LinearGradient` fill upward using a `ClipRect` + `CustomPaint` approach. The seconds bubble uses a `CurvedAnimation` with `Curves.easeInOut`.

---

## 🎨 Design System

| Token | Value | Usage |
|---|---|---|
| Background | `#0D0D0D` | App & clock background (OLED safe) |
| Channel Groove | `#1A1A1A` | Etched ring and digit frames |
| Fluid Glow | `MaskFilter.blur(BlurStyle.normal, 6)` | Tube hand and digit glow |
| Border Radius | `12px` | All channel frames and containers |
| Font | `Share Tech Mono` / monospace | Digital digit display |

---

## ⚙️ Configuration

You can extend or modify the theme list in `theme_config.dart`:

```dart
static const List<ClockTheme> presets = [
  ClockTheme(name: 'Lava',    primary: Color(0xFFFF6600), accent: Color(0xFF8B2500)),
  ClockTheme(name: 'Arctic',  primary: Color(0xFF00CFFF), accent: Color(0xFF004F7C)),
  ClockTheme(name: 'Venom',   primary: Color(0xFF39FF14), accent: Color(0xFF1A5C00)),
  ClockTheme(name: 'Plasma',  primary: Color(0xFFBF00FF), accent: Color(0xFF4B0082)),
  ClockTheme(name: 'Crimson', primary: Color(0xFFFF1744), accent: Color(0xFF7F0000)),
  ClockTheme(name: 'Gold',    primary: Color(0xFFFFD700), accent: Color(0xFF8B6914)),
];
```

---

## 🔬 Microfluidic Design Inspiration

This project is visually inspired by **pneumatically actuated microfluidic chips** — transparent PDMS devices where pressurized air drives colored fluid through etched micro-channels. The aesthetic borrows:

- **Channel grooves** → engraved clock ring and digit borders
- **Fluid-filled tubes** → clock hands with shimmer gradients
- **Pressurized nodes** → center pivot and bubble hour markers
- **Bioluminescent glow** → `MaskFilter.blur` on the Canvas

---

## 📋 Roadmap

- [ ] Alarm / timer functionality
- [ ] Seconds-only minimal mode (screensaver)
- [ ] Custom color picker (full HSV wheel)
- [ ] Widget support (Android home screen)
- [ ] Haptic feedback on hour tick

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/fluid-alarm`
3. Commit your changes: `git commit -m 'Add fluid alarm animation'`
4. Push to the branch: `git push origin feature/fluid-alarm`
5. Open a Pull Request

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

Built with Flutter & 🧪 microfluidic imagination.

> *"Time flows like fluid through a pressurized channel — one bubble at a time."*