import 'package:flutter/material.dart';
import '../widgets/home_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: const [
          HomeHeader(),
          SizedBox(height: 20), // Spacing after header/search
          TodayStatusSection(),
          SizedBox(height: 12),
          TodayMealCard(),
          SizedBox(height: 20),
          IAteTodayButton(),
          SizedBox(height: 20),
          StatsGrid(),
          SizedBox(height: 20),
          MonthlyPlanCard(),
          SizedBox(height: 20), // Bottom padding
        ],
      ),
    );
  }
}
