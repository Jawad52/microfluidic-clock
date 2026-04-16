import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'clock_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Set preferred orientations to portrait and hide status bar for immersive feel
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Color(0xFF0D0D0D),
  ));
  
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
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
      ),
      home: const ClockScreen(),
    );
  }
}
