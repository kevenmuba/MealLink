import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class WaitingApprovalScreen extends StatelessWidget {
  const WaitingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.hourglass_empty_rounded, size: 80, color: Colors.orange),
            const SizedBox(height: 24),
            const Text(
              "Pending Approval",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              "Your account has been created successfully. Please wait for the admin to approve your account before you can access the dashboard.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.secondaryText, fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () async {
                // await FirebaseAuth.instance.signOut();
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text("Back to Login", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}