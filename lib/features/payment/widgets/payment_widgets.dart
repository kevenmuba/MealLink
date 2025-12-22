import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PaymentHeader extends StatelessWidget {
  const PaymentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // In a real app this would pop, but since we are in a tab, maybe it switches tabs or does nothing?
              // The design shows a back button, implying this might be a pushed screen or just visual.
              // For now, I'll leaving it as a visual element since we are in a bottom nav wrapper.
            },
          ),
        ),
        const SizedBox(width: 16),
        const Text(
          'Payment',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }
}

class PlanSummaryCard extends StatelessWidget {
  const PlanSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(
          0xFFFBEFE7,
        ), // Slightly darker peach than background, matching design
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Monthly Plan',
            style: TextStyle(color: AppColors.secondaryText, fontSize: 14),
          ),
          SizedBox(height: 8),
          Text(
            '3,000 Birr',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Includes 30 meals per month',
            style: TextStyle(color: AppColors.secondaryText, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class PlanDetailsCard extends StatelessWidget {
  const PlanDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Plan Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              _buildDetailRow('Daily meal price', '90 Birr'),
              const SizedBox(height: 16),
              _buildDetailRow('Meals included', '30 meals'),
              const SizedBox(height: 16),
              _buildDetailRow('Validity', '30 days'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(height: 1, color: Colors.black12),
              ),
              _buildDetailRow('Total', '3,000 Birr', isBold: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14, // Slightly larger
            color: isBold ? Colors.black : Colors.grey[600],
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class PayWithChapaButton extends StatelessWidget {
  const PayWithChapaButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cardOrange, // Peach color
              foregroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.credit_card, size: 20),
                SizedBox(width: 8),
                Text(
                  'Pay with Chapa',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.shield_outlined, size: 16, color: Colors.grey),
            SizedBox(width: 6),
            Text(
              'Secured by Chapa',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
