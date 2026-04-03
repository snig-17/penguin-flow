import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../home/home_screen.dart';
import '../timer/timer_screen.dart';
import '../island/island_screen.dart';
import '../social/social_feed_screen.dart';
import '../profile/profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    TimerScreen(),
    IslandScreen(),
    SocialFeedScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_rounded),
            label: AppStrings.timer,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.landscape_rounded),
            label: AppStrings.island,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_rounded),
            label: AppStrings.social,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}
