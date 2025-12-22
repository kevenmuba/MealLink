import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'features/auth/screens/login_screen.dart';

void main() {
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
