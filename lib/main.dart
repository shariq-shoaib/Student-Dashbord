import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const LGCApp());
}

class LGCApp extends StatelessWidget {
  const LGCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Township Girls Campus',
      debugShowCheckedModeBanner: false,
      theme: colorfulTheme,
      home: const HomeScreen(),
    );
  }
}
