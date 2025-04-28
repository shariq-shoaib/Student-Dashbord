// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../utils/app_design_system.dart';
import 'attendance_screen.dart';
import 'assessments_screen.dart';
import 'chat_rooms_screen.dart';
import 'settings_screen.dart';
import 'home_screen_content.dart'; // New Home Content

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 2; // Home center

  final List<Widget> _pages = [
    AttendanceScreen(),
    AssessmentsScreen(),
    HomeScreenContent(), // Your main dashboard
    ChatRoomsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: AppDesignSystem.fancyBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        context: context,
      ),
    );
  }
}
