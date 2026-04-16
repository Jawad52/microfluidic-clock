import 'package:flutter/material.dart';
import 'theme_config.dart';
import 'digital_clock.dart';
import 'analog_clock.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  bool _isDigital = true;
  int _selectedThemeIndex = 0;

  ClockTheme get _theme => ClockTheme.presets[_selectedThemeIndex];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: isLandscape
              ? _buildLandscape()
              : _buildPortrait(),
        ),
      ),
    );
  }

  Widget _buildPortrait() {
    return Column(
      children: [
        _buildTopBar(),
        const SizedBox(height: 20),
        Expanded(
          child: Center(
            child: _isDigital
                ? DigitalClock(theme: _theme)
                : AspectRatio(
              aspectRatio: 1,
              child: AnalogClock(theme: _theme),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildColorPicker(),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildLandscape() {
    return Row(
      children: [
        // Clock area
        Expanded(
          flex: 3,
          child: Center(
            child: _isDigital
                ? DigitalClock(theme: _theme)
                : AnalogClock(theme: _theme),
          ),
        ),
        // Controls column
        SizedBox(
          width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildModeToggle(),
              const SizedBox(height: 24),
              _buildColorPickerVertical(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_buildModeToggle()],
    );
  }

  Widget _buildModeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: _theme.darkFluid.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleOption('Digital', true),
          _toggleOption('Analog', false),
        ],
      ),
    );
  }

  Widget _toggleOption(String label, bool isDigital) {
    final isSelected = _isDigital == isDigital;
    return GestureDetector(
      onTap: () => setState(() => _isDigital = isDigital),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _theme.fluidColor : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: _theme.darkFluid.withOpacity(0.6),
              blurRadius: 0,
              offset: const Offset(0, 3),
            ),
          ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF1A0800)
                : _theme.fluidColor.withOpacity(0.6),
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        ClockTheme.presets.length,
            (i) => _colorSwatch(i, horizontal: true),
      ),
    );
  }

  Widget _buildColorPickerVertical() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        ClockTheme.presets.length,
            (i) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: _colorSwatch(i, horizontal: false),
        ),
      ),
    );
  }

  Widget _colorSwatch(int index, {required bool horizontal}) {
    final theme = ClockTheme.presets[index];
    final isSelected = _selectedThemeIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedThemeIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: horizontal
            ? const EdgeInsets.symmetric(horizontal: 6)
            : EdgeInsets.zero,
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: theme.fluidColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: theme.fluidColor.withOpacity(0.7),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ]
              : null,
        ),
        child: isSelected
            ? Icon(
          Icons.check,
          size: 16,
          color: theme.sunkColor,
        )
            : null,
      ),
    );
  }
}