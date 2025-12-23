import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_colors.dart';

class AdminStatsGrid extends StatelessWidget {
  const AdminStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, userSnap) {
        if (userSnap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!userSnap.hasData) {
          return const SizedBox();
        }

        final users = userSnap.data!.docs;

        int totalCustomers = 0;
        int pendingCustomers = 0;
        double totalBalance = 0;

        for (final doc in users) {
          final data = doc.data() as Map<String, dynamic>;

          if (data['role'] == 'customer') {
            totalCustomers++;
            final balance = (data['balance'] ?? 0).toDouble();
            totalBalance += balance;

            if (balance <= 0) {
              pendingCustomers++;
            }
          }
        }

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('meal_history')
              .where(
                'date',
                isGreaterThan:
                    DateTime.now().subtract(const Duration(hours: 24)),
              )
              .snapshots(),
          builder: (context, mealSnap) {
            final activeToday =
                mealSnap.hasData ? mealSnap.data!.docs.length : 0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "System Overview",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 12),

                /// Row 1
                Row(
                  children: [
                    _statCard(
                      icon: Icons.group,
                      title: "Customers",
                      value: totalCustomers.toString(),
                      bgColor: AppColors.cardWhite,
                    ),
                    const SizedBox(width: 12),
                    _statCard(
                      icon: Icons.restaurant,
                      title: "Active Today",
                      value: activeToday.toString(),
                      bgColor: AppColors.cardGreen,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// Row 2
                Row(
                  children: [
                    _statCard(
                      icon: Icons.account_balance_wallet,
                      title: "Total Balance",
                      value: "${totalBalance.toStringAsFixed(0)} Birr",
                      bgColor: AppColors.cardOrange,
                    ),
                    const SizedBox(width: 12),
                    _statCard(
                      icon: Icons.warning_amber_rounded,
                      title: "Pending",
                      value: pendingCustomers.toString(),
                      bgColor: AppColors.cardWhite,
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// =========================
  /// STAT CARD
  /// =========================
  static Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color bgColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(icon),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
