import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_colors.dart';

class AdminCustomersScreen extends StatelessWidget {
  const AdminCustomersScreen({super.key});

  // Function to Approve User and Create Payment
  Future<void> _approveUser(BuildContext context, String uid, String name, String email) async {
    final TextEditingController amountController = TextEditingController();

    // 1. Show Dialog to enter amount
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.accentBlack,
        title: Text("Approve $name", style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Enter the initial payment amount for this user:",
                style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 15),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "e.g. 500",
                hintStyle: const TextStyle(color: Colors.white24),
                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white24), borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (amountController.text.isEmpty) return;
              
              Navigator.pop(context); // Close dialog
              _processApproval(uid, email, amountController.text);
            },
            child: const Text("Activate"),
          ),
        ],
      ),
    );
  }

  // 2. Transaction to update Status and Create Payment Record
  Future<void> _processApproval(String uid, String email, String amount) async {
    final firestore = FirebaseFirestore.instance;

    try {
      await firestore.runTransaction((transaction) async {
        // Update User Status
        DocumentReference userRef = firestore.collection('users').doc(uid);
        transaction.update(userRef, {'status': 'active'});

        // Create Payment Record
        DocumentReference paymentRef = firestore.collection('payments').doc(); // Auto ID
        transaction.set(paymentRef, {
          'userId': uid,
          'userEmail': email,
          'amount': double.parse(amount),
          'date': FieldValue.serverTimestamp(),
          'type': 'Initial Activation',
        });
      });
    } catch (e) {
      debugPrint("Error during approval: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Manage Customers", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'customer')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No customers found", style: TextStyle(color: Colors.white60)));
          }

          final customers = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final doc = customers[index];
              final data = doc.data() as Map<String, dynamic>;
              final bool isActive = data['status'] == 'active';

              return GestureDetector(
                onTap: isActive ? null : () => _approveUser(context, doc.id, data['name'], data['email']),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accentBlack,
                    borderRadius: BorderRadius.circular(20),
                    border: isActive ? null : Border.all(color: Colors.orange.withOpacity(0.5), width: 1),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: isActive ? Colors.white10 : Colors.orange.withOpacity(0.1),
                        child: Text(data['name'][0].toUpperCase(), 
                          style: TextStyle(color: isActive ? Colors.white : Colors.orange)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(data['email'], style: const TextStyle(color: Colors.white60, fontSize: 12)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isActive ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              data['status'].toString().toUpperCase(),
                              style: TextStyle(
                                color: isActive ? Colors.green : Colors.orange,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (!isActive)
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text("Tap to Activate", style: TextStyle(color: Colors.orange, fontSize: 10)),
                            )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}