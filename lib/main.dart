import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'core/theme/app_colors.dart';
import 'features/auth/screens/login_screen.dart';

Future<void> main() async {
  // 1. Ensure Flutter framework is ready
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Initialize Firebase with a success message for the terminal
  try {
    await Firebase.initializeApp();
    // This will only print if the line above succeeds
    print("========================================");
    print("🔥 FIREBASE CONNECTED SUCCESSFULLY! 🔥");
    print("Project ID: ${Firebase.app().options.projectId}");
    print("========================================");
  } catch (e) {
    print("❌ FIREBASE CONNECTION FAILED: $e");
  }

  runApp(const MealLinkApp());
}

class MealLinkApp extends StatelessWidget {
  const MealLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MealLink',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const LoginScreen(),
    );
  }
}