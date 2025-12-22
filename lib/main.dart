import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'features/main/screens/main_wrapper.dart';

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
        fontFamily:
            'Inter', // Assuming Inter or system font, adding standard config
      ),
      home: const MainWrapper(),
    );
  }
}
