import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import 'home_screen.dart';
import 'timer_screen.dart';
import 'island_screen.dart';
import 'social_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _goToTimer() {
    setState(() => _currentIndex = 1);
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      HomeScreen(onStartTimer: _goToTimer),
      const TimerScreen(),
      const IslandScreen(),
      const SocialScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        elevation: AppDimensions.cardElevation,
        items: const [
          BottomNavigationBarItem(
            icon: Text('🏠', style: TextStyle(fontSize: 22)),
            activeIcon: Text('🏠', style: TextStyle(fontSize: 26)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Text('⏱️', style: TextStyle(fontSize: 22)),
            activeIcon: Text('⏱️', style: TextStyle(fontSize: 26)),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Text('🏝️', style: TextStyle(fontSize: 22)),
            activeIcon: Text('🏝️', style: TextStyle(fontSize: 26)),
            label: 'Island',
          ),
          BottomNavigationBarItem(
            icon: Text('🐧', style: TextStyle(fontSize: 22)),
            activeIcon: Text('🐧', style: TextStyle(fontSize: 26)),
            label: 'Social',
          ),
          BottomNavigationBarItem(
            icon: Text('🪪', style: TextStyle(fontSize: 22)),
            activeIcon: Text('🪪', style: TextStyle(fontSize: 26)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
