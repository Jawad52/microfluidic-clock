import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'clock_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MicrofluidicClockApp());
}

class MicrofluidicClockApp extends StatelessWidget {
  const MicrofluidicClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Microfluidic Clock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF6600)),
        useMaterial3: true,
      ),
      home: const ClockScreen(),
    );
  }
}