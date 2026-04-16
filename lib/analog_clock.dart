import 'package:flutter/material.dart';
import 'microfluidic_painter.dart';
import 'theme_config.dart';

class AnalogClock extends StatelessWidget {
  final DateTime dateTime;
  final FluidTheme theme;
  final double animationValue;

  const AnalogClock({
    super.key,
    required this.dateTime,
    required this.theme,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: CustomPaint(
            painter: MicrofluidicPainter(
              dateTime: dateTime,
              theme: theme,
              animationValue: animationValue,
            ),
          ),
        ),
      ),
    );
  }
}
