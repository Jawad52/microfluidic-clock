import 'package:flutter/material.dart';
import 'theme_config.dart';

/// Segment indices:
///   0 = top
///   1 = top-right
///   2 = bottom-right
///   3 = bottom
///   4 = bottom-left
///   5 = top-left
///   6 = middle
const Map<int, List<bool>> _digitSegments = {
  0: [true,  true,  true,  true,  true,  true,  false],
  1: [false, true,  true,  false, false, false, false],
  2: [true,  true,  false, true,  true,  false, true],
  3: [true,  true,  true,  true,  false, false, true],
  4: [false, true,  true,  false, false, true,  true],
  5: [true,  false, true,  true,  false, true,  true],
  6: [true,  false, true,  true,  true,  true,  true],
  7: [true,  true,  true,  false, false, false, false],
  8: [true,  true,  true,  true,  true,  true,  true],
  9: [true,  true,  true,  true,  false, true,  true],
};

class SegmentDigitPainter extends CustomPainter {
  final int digit;
  final ClockTheme theme;
  final double animValue; // 0..1 for fluid fill animation
  final bool invertColors;

  const SegmentDigitPainter({
    required this.digit,
    required this.theme,
    required this.animValue,
    this.invertColors = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final segments = _digitSegments[digit] ?? _digitSegments[0]!;
    final w = size.width;
    final h = size.height;

    // Segment geometry
    final segThick = w * 0.14;
    final gap = w * 0.025;
    final capRadius = segThick / 2;
    final halfH = h / 2;

    // Draw each segment as a rounded capsule
    for (int i = 0; i < 7; i++) {
      final isActive = segments[i];
      _drawSegment(canvas, i, w, h, segThick, gap, capRadius, halfH, isActive, theme);
    }
  }

  void _drawSegment(
      Canvas canvas,
      int index,
      double w,
      double h,
      double thick,
      double gap,
      double capR,
      double halfH,
      bool active,
      ClockTheme theme,
      ) {
    // Determine colors based on inversion
    final Color sunkColor = invertColors 
        ? theme.surfaceColor.withOpacity(0.2) 
        : (active ? theme.darkFluid : theme.sunkColor);
        
    final Color activeFluidColor = invertColors 
        ? theme.sunkColor 
        : theme.fluidColor;

    final Color highlightColor = invertColors
        ? Colors.black.withOpacity(0.15)
        : theme.surfaceColor.withOpacity(0.6);

    // Sunken channel paint
    final sunkPaint = Paint()
      ..color = sunkColor
      ..style = PaintingStyle.fill;

    // Fluid paint
    final fluidPaint = Paint()
      ..color = activeFluidColor
      ..style = PaintingStyle.fill;

    Path path;

    switch (index) {
      case 0: // top horizontal
        path = _hSegPath(gap, gap, w - gap * 2, thick, capR);
        break;
      case 1: // top-right vertical
        path = _vSegPath(w - thick - gap, gap, thick, halfH - gap * 1.5, capR);
        break;
      case 2: // bottom-right vertical
        path = _vSegPath(w - thick - gap, halfH + gap * 0.5, thick, halfH - gap * 1.5, capR);
        break;
      case 3: // bottom horizontal
        path = _hSegPath(gap, h - thick - gap, w - gap * 2, thick, capR);
        break;
      case 4: // bottom-left vertical
        path = _vSegPath(gap, halfH + gap * 0.5, thick, halfH - gap * 1.5, capR);
        break;
      case 5: // top-left vertical
        path = _vSegPath(gap, gap, thick, halfH - gap * 1.5, capR);
        break;
      case 6: // middle horizontal
        path = _hSegPath(gap, halfH - thick / 2, w - gap * 2, thick, capR);
        break;
      default:
        return;
    }

    // Draw background of segment channel
    canvas.drawPath(path, sunkPaint);

    if (active) {
      // Draw fluid fill
      final inset = thick * 0.12;
      final innerPath = _insetPath(path, inset);
      canvas.drawPath(innerPath, fluidPaint);

      // Draw highlight
      final hlPaint = Paint()
        ..color = highlightColor
        ..style = PaintingStyle.fill;
      final hlPath = _insetPath(path, inset * 2.5);
      canvas.drawPath(hlPath, hlPaint);
    }
  }

  Path _hSegPath(double x, double y, double w, double h, double r) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, w, h),
        Radius.circular(r),
      ));
  }

  Path _vSegPath(double x, double y, double w, double h, double r) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, w, h),
        Radius.circular(r),
      ));
  }

  Path _insetPath(Path original, double inset) {
    final bounds = original.getBounds();
    if (bounds.width < inset * 2 + 2 || bounds.height < inset * 2 + 2) {
      return original;
    }
    final r = bounds.width < bounds.height
        ? bounds.width / 2 - inset
        : bounds.height / 2 - inset;
    return Path()
      ..addRRect(RRect.fromRectAndRadius(
        bounds.deflate(inset),
        Radius.circular(r.clamp(0, double.infinity)),
      ));
  }

  @override
  bool shouldRepaint(SegmentDigitPainter old) =>
      old.digit != digit || 
      old.theme != theme || 
      old.animValue != animValue ||
      old.invertColors != invertColors;
}