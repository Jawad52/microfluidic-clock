import 'package:flutter/material.dart';
import 'dart:async';
import 'theme_config.dart';
import 'segment_digit_painter.dart';

class DigitalClock extends StatefulWidget {
  final ClockTheme theme;

  const DigitalClock({super.key, required this.theme});

  @override
  State<DigitalClock> createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock>
    with TickerProviderStateMixin {
  late DateTime _now;
  late Timer _timer;
  late AnimationController _colonPulse;
  int _selectedColonIndex = 0; // 0 for H:M colon, 1 for M:S colon

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();

    _colonPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _colonPulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Convert to 12-hour format
    int hour = _now.hour % 12;
    if (hour == 0) hour = 12;
    
    final h = hour.toString().padLeft(2, '0');
    final m = _now.minute.toString().padLeft(2, '0');
    final s = _now.second.toString().padLeft(2, '0');

    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final available = constraints.maxWidth;
          // Each digit ~110 wide, colons ~28, padding
          final digitW = (available - 80) / 8;
          final digitH = digitW * 1.7;

          return Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: widget.theme.fluidColor,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: widget.theme.darkFluid.withOpacity(0.7),
                    blurRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: widget.theme.darkFluid.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 4,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildDigit(int.parse(h[0]), digitW, digitH),
                  SizedBox(width: digitW * 0.08),
                  _buildDigit(int.parse(h[1]), digitW, digitH),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() => _selectedColonIndex = 0),
                    child: _buildColon(digitW * 0.28, digitH, isActive: _selectedColonIndex == 0),
                  ),
                  _buildDigit(int.parse(m[0]), digitW, digitH),
                  SizedBox(width: digitW * 0.08),
                  _buildDigit(int.parse(m[1]), digitW, digitH),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() => _selectedColonIndex = 1),
                    child: _buildColon(digitW * 0.28, digitH, isActive: _selectedColonIndex == 1),
                  ),
                  _buildDigit(int.parse(s[0]), digitW, digitH),
                  SizedBox(width: digitW * 0.08),
                  _buildDigit(int.parse(s[1]), digitW, digitH),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDigit(int digit, double w, double h) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: widget.theme.fluidColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomPaint(
        painter: SegmentDigitPainter(
          digit: digit,
          theme: widget.theme,
          animValue: 1.0,
          invertColors: true, // Use dark color for digits
        ),
      ),
    );
  }

  Widget _buildColon(double w, double h, {required bool isActive}) {
    return AnimatedBuilder(
      animation: _colonPulse,
      builder: (_, __) {
        // Since the main background is bright (fluidColor), 
        // the "sucking" colon dots should also be dark when active.
        final double opacity = isActive ? 0.7 + (_colonPulse.value * 0.3) : 0.15;
        final double scale = isActive ? 1.0 + (_colonPulse.value * 0.12) : 0.75;
        final dotSize = w * 0.55 * scale;

        return SizedBox(
          width: w,
          height: h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _colonDot(dotSize, opacity, isActive: isActive),
              SizedBox(height: h * 0.18),
              _colonDot(dotSize, opacity, isActive: isActive),
            ],
          ),
        );
      },
    );
  }

  Widget _colonDot(double size, double opacity, {required bool isActive}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: widget.theme.sunkColor.withOpacity(opacity),
        shape: BoxShape.circle,
        // Remove glow effect since it's dark fluid on bright background
        boxShadow: isActive ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, size * 0.1),
          ),
        ] : null,
      ),
    );
  }
}