import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/alert_widgets.dart';

class AlertScreen extends StatelessWidget {
  const AlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          AlertHeader(),
          SizedBox(height: 24),
          NotificationCard(
            title: 'Meal Approved',
            description: 'Your meal for today has been approved by the admin.',
            time: '10 minutes ago',
            icon: Icons.check_circle_outline,
            iconColor: Colors.green,
            iconBgColor: AppColors.cardGreen,
            isUnread: true,
          ),
          NotificationCard(
            title: 'Low Balance',
            description:
                'Your balance is running low. Only 5 meal days remaining.',
            time: '2 hours ago',
            icon: Icons.account_balance_wallet_outlined,
            iconColor: Colors.orange, // Closest match to design
            iconBgColor: Color(0xFFFFF4E8), // Very light peach
            isUnread: true,
          ),
          NotificationCard(
            title: 'Meal Missed',
            description: 'You didn\'t claim your meal yesterday.',
            time: '1 day ago',
            icon: Icons.warning_amber_rounded,
            iconColor: Colors.orangeAccent,
            iconBgColor: Color(0xFFFFF8E1), // Light yellow
          ),
        ],
      ),
    );
  }
}
