import 'package:flutter/material.dart';
import 'features/home/screens/home_screen.dart'; // <-- point to your HomeScreen

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}
