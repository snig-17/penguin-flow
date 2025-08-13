import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'providers/user_provider.dart';
import 'providers/timer_provider.dart';
import 'providers/island_provider.dart';
import 'providers/gamification_provider.dart';
import 'screens/splash_screen.dart';

/// Main PenguinFlow application widget
/// Sets up providers, theme, and navigation
class PenguinFlowApp extends StatelessWidget {
  const PenguinFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // User data and authentication
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),

        // Timer functionality
        ChangeNotifierProvider(
          create: (context) => TimerProvider(),
        ),

        // Island building and visualization
        ChangeNotifierProvider(
          create: (context) => IslandProvider(),
        ),

        // Gamification system (XP, levels, achievements)
        ChangeNotifierProvider(
          create: (context) => GamificationProvider(),
        ),
      ],
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,

            // Theme configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: userProvider.user?.darkModeEnabled == true 
                ? ThemeMode.dark 
                : ThemeMode.light,

            // Initial route
            home: const SplashScreen(),

            // Global navigation and route configuration
            navigatorKey: GlobalKey<NavigatorState>(),

            // App-wide material configuration
            builder: (context, child) {
              return MediaQuery(
                // Ensure text doesn't scale beyond readable limits
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2)),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
