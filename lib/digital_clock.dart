import 'package:flutter/material.dart';
import 'theme_config.dart';

class DigitalClock extends StatelessWidget {
  final DateTime dateTime;
  final FluidTheme theme;
  final double animationValue;

  const DigitalClock({
    super.key,
    required this.dateTime,
    required this.theme,
    required this.animationValue,
  });

  String _formatDigit(int value) => value.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDigitGroup(_formatDigit(dateTime.hour)),
        _buildSeparator(),
        _buildDigitGroup(_formatDigit(dateTime.minute)),
        _buildSeparator(),
        _buildDigitGroup(_formatDigit(dateTime.second)),
      ],
    );
  }

  Widget _buildDigitGroup(String digits) {
    return Row(
      children: digits.split('').map((d) => _buildDigit(d)).toList(),
    );
  }

  Widget _buildDigit(String digit) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A1A1A), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(-1, -1),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Background "empty" channel
          Text(
            digit,
            style: TextStyle(
              fontSize: 64,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              color: theme.primary.withOpacity(0.1),
            ),
          ),
          // Fluid filling
          ClipRect(
            clipper: _FluidClipper(animationValue),
            child: Text(
              digit,
              style: TextStyle(
                fontSize: 64,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                color: theme.primary,
                shadows: [
                  Shadow(
                    color: theme.primary.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBubble(),
          const SizedBox(height: 16),
          _buildBubble(),
        ],
      ),
    );
  }

  Widget _buildBubble() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.primary,
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(0.5),
            blurRadius: 8,
          ),
        ],
      ),
    );
  }
}

class _FluidClipper extends CustomClipper<Rect> {
  final double progress;
  _FluidClipper(this.progress);

  @override
  Rect getClip(Size size) {
    // Simulate filling from bottom to top
    // We use animationValue to oscillate slightly or just stay full
    // For "real-time" we might want it to respond to the digit change
    return Rect.fromLTRB(0, size.height * (1 - progress), size.width, size.height);
  }

  @override
  bool shouldReclip(_FluidClipper oldClipper) => oldClipper.progress != progress;
}
