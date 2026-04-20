import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'theme_config.dart';

class MicrofluidicAnalogPainter extends CustomPainter {
  final DateTime time;
  final ClockTheme theme;
  final double shimmerOffset; // 0..1 animated shimmer position

  const MicrofluidicAnalogPainter({
    required this.time,
    required this.theme,
    required this.shimmerOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;

    _drawFace(canvas, center, radius);
    _drawHourMarkers(canvas, center, radius);
    _drawHands(canvas, center, radius);
    _drawCenterNode(canvas, center);
  }

  void _drawFace(Canvas canvas, Offset center, double radius) {
    // Outer ring — channel groove
    final outerPaint = Paint()
      ..color = theme.sunkColor.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.09;

    canvas.drawCircle(center, radius, outerPaint);

    // Inner ring highlight
    final innerRingPaint = Paint()
      ..color = theme.fluidColor.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.035;

    canvas.drawCircle(center, radius - radius * 0.045, innerRingPaint);
    canvas.drawCircle(center, radius + radius * 0.045, innerRingPaint);
  }

  void _drawHourMarkers(Canvas canvas, Offset center, double radius) {
    final markerR = radius * 0.86;
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * math.pi / 180;
      final dx = center.dx + markerR * math.cos(angle);
      final dy = center.dy + markerR * math.sin(angle);

      final isQuarter = i % 3 == 0;
      final dotR = isQuarter ? radius * 0.048 : radius * 0.028;

      // Sunken channel hole
      final holePaint = Paint()
        ..color = theme.sunkColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(dx, dy), dotR, holePaint);

      // Fluid bubble inside
      final bubblePaint = Paint()
        ..color = theme.fluidColor.withOpacity(isQuarter ? 0.9 : 0.6)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(dx, dy), dotR * 0.65, bubblePaint);

      // Highlight
      final hlPaint = Paint()
        ..color = theme.surfaceColor.withOpacity(0.5)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(dx - dotR * 0.18, dy - dotR * 0.2),
        dotR * 0.25,
        hlPaint,
      );
    }
  }

  void _drawHands(Canvas canvas, Offset center, double radius) {
    final seconds = time.second + time.millisecond / 1000;
    final minutes = time.minute + seconds / 60;
    final hours = (time.hour % 12) + minutes / 60;

    // Hour hand
    _drawTubeHand(
      canvas,
      center,
      hours * 30 - 90,
      radius * 0.52,
      radius * 0.045,
      theme.fluidColor,
      shimmerOffset,
    );

    // Minute hand
    _drawTubeHand(
      canvas,
      center,
      minutes * 6 - 90,
      radius * 0.73,
      radius * 0.032,
      theme.fluidColor.withOpacity(0.9),
      (shimmerOffset + 0.33) % 1.0,
    );

    // Second hand — thinner, faster shimmer
    _drawTubeHand(
      canvas,
      center,
      seconds * 6 - 90,
      radius * 0.82,
      radius * 0.018,
      theme.surfaceColor,
      (shimmerOffset + 0.66) % 1.0,
    );
  }

  void _drawTubeHand(
      Canvas canvas,
      Offset center,
      double angleDeg,
      double length,
      double thickness,
      Color fluidColor,
      double shimmer,
      ) {
    final angle = angleDeg * math.pi / 180;
    final tip = Offset(
      center.dx + length * math.cos(angle),
      center.dy + length * math.sin(angle),
    );

    // Draw tube outer (dark channel)
    final tubePaint = Paint()
      ..color = theme.sunkColor.withOpacity(0.8)
      ..strokeWidth = thickness * 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(center, tip, tubePaint);

    // Draw fluid fill inside tube
    final fluidPaint = Paint()
      ..color = fluidColor
      ..strokeWidth = thickness * 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(center, tip, fluidPaint);

    // Draw shimmer highlight traveling along tube
    final shimmerPos = shimmer;
    final shimmerStart = Offset(
      center.dx + length * shimmerPos * 0.85 * math.cos(angle),
      center.dy + length * shimmerPos * 0.85 * math.sin(angle),
    );
    final shimmerEnd = Offset(
      center.dx + length * (shimmerPos * 0.85 + 0.12) * math.cos(angle),
      center.dy + length * (shimmerPos * 0.85 + 0.12) * math.sin(angle),
    );

    final shimmerPaint = Paint()
      ..color = theme.surfaceColor.withOpacity(0.65)
      ..strokeWidth = thickness * 0.7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(shimmerStart, shimmerEnd, shimmerPaint);
  }

  void _drawCenterNode(Canvas canvas, Offset center) {
    final nodeR = 10.0;

    // Outer dark channel ring
    final outerPaint = Paint()
      ..color = theme.sunkColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, nodeR, outerPaint);

    // Fluid fill
    final fluidPaint = Paint()
      ..color = theme.fluidColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, nodeR * 0.72, fluidPaint);

    // Highlight
    final hlPaint = Paint()
      ..color = theme.surfaceColor.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx - nodeR * 0.2, center.dy - nodeR * 0.25),
      nodeR * 0.28,
      hlPaint,
    );
  }

  @override
  bool shouldRepaint(MicrofluidicAnalogPainter old) =>
      old.time != time ||
          old.theme != theme ||
          old.shimmerOffset != shimmerOffset;
}