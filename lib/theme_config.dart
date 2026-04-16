import 'package:flutter/material.dart';

class FluidTheme {
  final String name;
  final Color primary;
  final Color accent;

  const FluidTheme({
    required this.name,
    required this.primary,
    required this.accent,
  });
}

class ThemePresets {
  static const List<FluidTheme> themes = [
    FluidTheme(
      name: 'Lava',
      primary: Color(0xFFFF6600),
      accent: Color(0xFF8B2500),
    ),
    FluidTheme(
      name: 'Arctic',
      primary: Color(0xFF00CFFF),
      accent: Color(0xFF004F7C),
    ),
    FluidTheme(
      name: 'Venom',
      primary: Color(0xFF39FF14),
      accent: Color(0xFF1A5C00),
    ),
    FluidTheme(
      name: 'Plasma',
      primary: Color(0xFFBF00FF),
      accent: Color(0xFF4B0082),
    ),
    FluidTheme(
      name: 'Crimson',
      primary: Color(0xFFFF1744),
      accent: Color(0xFF7F0000),
    ),
    FluidTheme(
      name: 'Gold',
      primary: Color(0xFFFFD700),
      accent: Color(0xFF8B6914),
    ),
  ];
}
