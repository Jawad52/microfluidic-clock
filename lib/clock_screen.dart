import 'dart:async';
import 'package:flutter/material.dart';
import 'theme_config.dart';
import 'digital_clock.dart';
import 'analog_clock.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> with SingleTickerProviderStateMixin {
  late DateTime _dateTime;
  late Timer _timer;
  late AnimationController _animationController;
  
  FluidTheme _currentTheme = ThemePresets.themes[0];
  bool _isDigital = true;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
    _updateTime();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        const Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Header / Toggle
            _buildToggleSwitch(),
            
            const Spacer(),
            
            // Clock Display
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _isDigital
                    ? DigitalClock(
                        dateTime: _dateTime,
                        theme: _currentTheme,
                        animationValue: _animationController.value,
                      )
                    : AnalogClock(
                        dateTime: _dateTime,
                        theme: _currentTheme,
                        animationValue: _animationController.value,
                      ),
              ),
            ),
            
            const Spacer(),
            
            // Color Picker
            _buildColorPicker(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSwitch() {
    return GestureDetector(
      onTap: () => setState(() => _isDigital = !_isDigital),
      child: Container(
        width: 160,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: _currentTheme.primary.withOpacity(0.3)),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: _isDigital ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: 80,
                height: 50,
                decoration: BoxDecoration(
                  color: _currentTheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: _currentTheme.primary.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'DIGITAL',
                      style: TextStyle(
                        color: _isDigital ? _currentTheme.primary : Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'ANALOG',
                      style: TextStyle(
                        color: !_isDigital ? _currentTheme.primary : Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ThemePresets.themes.map((theme) {
          final isSelected = _currentTheme == theme;
          return GestureDetector(
            onTap: () => setState(() => _currentTheme = theme),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: theme.primary.withOpacity(0.6),
                          blurRadius: 12,
                          spreadRadius: 2,
                        )
                      ]
                    : [],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
