import 'package:flutter/material.dart';

class ClockTheme {
  final String name;
  final Color fluidColor;
  final Color darkFluid;
  final Color surfaceColor;
  final Color sunkColor;

  const ClockTheme({
    required this.name,
    required this.fluidColor,
    required this.darkFluid,
    required this.surfaceColor,
    required this.sunkColor,
  });

  static const List<ClockTheme> presets = [
    ClockTheme(
      name: 'Lava',
      fluidColor: Color(0xFFFF5500),
      darkFluid: Color(0xFFCC3300),
      surfaceColor: Color(0xFFFF6B1A),
      sunkColor: Color(0xFF7A1A00),
    ),
    ClockTheme(
      name: 'Arctic',
      fluidColor: Color(0xFF00CFFF),
      darkFluid: Color(0xFF007FAA),
      surfaceColor: Color(0xFF33D9FF),
      sunkColor: Color(0xFF003850),
    ),
    ClockTheme(
      name: 'Venom',
      fluidColor: Color(0xFF39FF14),
      darkFluid: Color(0xFF1A8A00),
      surfaceColor: Color(0xFF55FF33),
      sunkColor: Color(0xFF0A3A00),
    ),
    ClockTheme(
      name: 'Plasma',
      fluidColor: Color(0xFFBF00FF),
      darkFluid: Color(0xFF7000AA),
      surfaceColor: Color(0xFFCF33FF),
      sunkColor: Color(0xFF3A0060),
    ),
    ClockTheme(
      name: 'Crimson',
      fluidColor: Color(0xFFFF1744),
      darkFluid: Color(0xFFAA0020),
      surfaceColor: Color(0xFFFF4466),
      sunkColor: Color(0xFF500010),
    ),
    ClockTheme(
      name: 'Gold',
      fluidColor: Color(0xFFFFD700),
      darkFluid: Color(0xFFAA8800),
      surfaceColor: Color(0xFFFFE033),
      sunkColor: Color(0xFF4A3800),
    ),
  ];
}