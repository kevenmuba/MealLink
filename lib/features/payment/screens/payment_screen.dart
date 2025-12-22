import 'package:flutter/material.dart';
import '../widgets/payment_widgets.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          PaymentHeader(),
          SizedBox(height: 24),
          PlanSummaryCard(),
          SizedBox(height: 30),
          PlanDetailsCard(),
          SizedBox(height: 30),
          PayWithChapaButton(),
        ],
      ),
    );
  }
}
