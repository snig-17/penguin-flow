import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'services/storage_service.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/timer_provider.dart';
import 'providers/island_provider.dart';
import 'providers/gamification_provider.dart';
import 'providers/social_provider.dart';
import 'screens/auth/splash_screen.dart';

class PenguinFlowApp extends StatefulWidget {
  const PenguinFlowApp({super.key});

  @override
  State<PenguinFlowApp> createState() => _PenguinFlowAppState();
}

class _PenguinFlowAppState extends State<PenguinFlowApp> {
  final StorageService _storageService = StorageService();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _storageService.init();
    setState(() => _initialized = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(_storageService)),
        ChangeNotifierProvider(create: (_) => UserProvider(_storageService)),
        ChangeNotifierProvider(create: (_) => TimerProvider(_storageService)),
        ChangeNotifierProvider(create: (_) => IslandProvider(_storageService)),
        ChangeNotifierProvider(create: (_) => GamificationProvider()),
        ChangeNotifierProvider(create: (_) => SocialProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
}
