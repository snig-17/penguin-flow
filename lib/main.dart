import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'models/user_model.dart';
import 'models/session_model.dart';
import 'models/achievement_model.dart';
import 'models/island_model.dart';

/// Main entry point for PenguinFlow app
/// Sets up Hive database and initializes the app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Register Hive adapters for data models
  // Note: In a real app, you'd run build_runner to generate these
  // Hive.registerAdapter(UserModelAdapter());
  // Hive.registerAdapter(SessionModelAdapter());
  // Hive.registerAdapter(AchievementModelAdapter());
  // Hive.registerAdapter(IslandModelAdapter());
  // Hive.registerAdapter(BuildingModelAdapter());
  // Hive.registerAdapter(DecorationModelAdapter());

  // Open Hive boxes for data storage
  await Hive.openBox<UserModel>('users');
  await Hive.openBox<SessionModel>('sessions');
  await Hive.openBox('app_data');

  // Set preferred orientations (mobile-first design)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style (status bar, navigation bar)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const PenguinFlowApp());
}
