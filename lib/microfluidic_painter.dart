import 'dart:math';
import 'package:flutter/material.dart';
import 'theme_config.dart';

class MicrofluidicPainter extends CustomPainter {
  final DateTime dateTime;
  final FluidTheme theme;
  final double animationValue;

  MicrofluidicPainter({
    required this.dateTime,
    required this.theme,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.08;

    // Draw background etched channel ring
    final channelPaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 4;
    canvas.drawCircle(center, radius - strokeWidth, channelPaint);

    // Draw hour markers (bubbles)
    final bubblePaint = Paint()
      ..color = theme.accent.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 12; i++) {
      final angle = i * 30 * pi / 180;
      final offset = Offset(
        center.dx + (radius - strokeWidth) * cos(angle),
        center.dy + (radius - strokeWidth) * sin(angle),
      );
      canvas.drawCircle(offset, 4, bubblePaint);
    }

    // Draw Hands
    _drawHand(canvas, center, radius * 0.5, (dateTime.hour % 12 + dateTime.minute / 60) * 30, strokeWidth * 1.5, theme, false);
    _drawHand(canvas, center, radius * 0.7, (dateTime.minute + dateTime.second / 60) * 6, strokeWidth, theme, false);
    _drawHand(canvas, center, radius * 0.85, dateTime.second * 6, strokeWidth * 0.5, theme, true);

    // Center pivot (pressurized node)
    final pivotPaint = Paint()
      ..color = theme.accent
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(center, 8, pivotPaint);
    
    final pivotInnerPaint = Paint()..color = theme.primary;
    canvas.drawCircle(center, 4, pivotInnerPaint);
  }

  void _drawHand(Canvas canvas, Offset center, double length, double angleDegrees, double width, FluidTheme theme, bool isSecondHand) {
    final angle = (angleDegrees - 90) * pi / 180;
    final end = Offset(
      center.dx + length * cos(angle),
      center.dy + length * sin(angle),
    );

    // Tube background (etched channel)
    final tubeBasePaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..strokeWidth = width + 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(center, end, tubeBasePaint);

    // Fluid glow
    final glowPaint = Paint()
      ..color = theme.primary.withOpacity(0.3)
      ..strokeWidth = width + 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawLine(center, end, glowPaint);

    // Fluid fill with shimmer/flow
    final fluidPaint = Paint()
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final gradient = LinearGradient(
      colors: [theme.accent, theme.primary, theme.accent],
      stops: const [0.0, 0.5, 1.0],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      transform: GradientRotation(isSecondHand ? animationValue * 2 * pi : angle),
    );

    fluidPaint.shader = gradient.createShader(Rect.fromPoints(center, end));
    canvas.drawLine(center, end, fluidPaint);
  }

  @override
  bool shouldRepaint(covariant MicrofluidicPainter oldDelegate) {
    return oldDelegate.dateTime != dateTime || oldDelegate.animationValue != animationValue || oldDelegate.theme != theme;
  }
}
