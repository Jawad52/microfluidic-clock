import 'package:flutter/material.dart';
import 'theme_config.dart';
import 'microfluidic_painter.dart';

class AnalogClock extends StatefulWidget {
  final ClockTheme theme;

  const AnalogClock({super.key, required this.theme});

  @override
  State<AnalogClock> createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock>
    with SingleTickerProviderStateMixin {
  late AnimationController _tickerController;

  @override
  void initState() {
    super.initState();

    // Use a single AnimationController to drive both the shimmer and the continuous clock update
    _tickerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _tickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _tickerController,
        builder: (_, __) => CustomPaint(
          painter: MicrofluidicAnalogPainter(
            time: DateTime.now(),
            theme: widget.theme,
            shimmerOffset: _tickerController.value,
          ),
        ),
      ),
    );
  }
}