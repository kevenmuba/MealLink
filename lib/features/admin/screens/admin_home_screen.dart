import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../home/widgets/home_widgets.dart';
import '../widgets/admin_home_widgets.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  /// =========================
  /// RECORD MEAL TRANSACTION
  /// =========================
  Future<void> _recordMeal(
    String userId,
    String userName,
    double currentBalance,
    double mealCost,
  ) async {
    if (currentBalance < mealCost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Insufficient balance")),
      );
      return;
    }

    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final mealRef = FirebaseFirestore.instance.collection('meal_history').doc();

    try {
      await FirebaseFirestore.instance.runTransaction((tx) async {
        tx.update(userRef, {
          'balance': currentBalance - mealCost,
        });

        tx.set(mealRef, {
          'userId': userId,
          'userName': userName,
          'amount': mealCost,
          'date': FieldValue.serverTimestamp(),
          'type': 'meal',
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$userName marked as eaten")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  /// =========================
  /// UI
  /// =========================
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          /// HEADER
          const Padding(
            padding: EdgeInsets.all(20),
            child: HomeHeader(),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                /// =========================
                /// CUSTOMER SEARCH (TOP)
                /// =========================
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search customer by name",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (v) {
                    setState(() {
                      _searchQuery = v.toLowerCase();
                    });
                  },
                ),
                const SizedBox(height: 15),

                /// =========================
                /// SEARCH RESULTS
                /// =========================
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('role', isEqualTo: 'customer')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final users = snapshot.data!.docs.where((doc) {
                      final name =
                          (doc['name'] ?? '').toString().toLowerCase();
                      return name.contains(_searchQuery);
                    }).toList();

                    if (_searchQuery.isNotEmpty && users.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("No users found"),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final data =
                            users[index].data() as Map<String, dynamic>;
                        final uid = users[index].id;
                        final balance =
                            (data['balance'] ?? 0).toDouble();

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            title: Text(data['name']),
                            subtitle: Text(
                              "Balance: ${balance.toStringAsFixed(2)} Birr",
                            ),
                            trailing: ElevatedButton(
                              onPressed: () => _showMealAmountDialog(
                                uid,
                                data['name'],
                                balance,
                              ),
                              child: const Text("Mark Eaten"),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 30),

                /// =========================
                /// SYSTEM OVERVIEW (BOTTOM)
                /// =========================
                const TodayStatusSection(),
                const SizedBox(height: 20),
                const AdminStatsGrid(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// =========================
  /// MEAL AMOUNT DIALOG
  /// =========================
  void _showMealAmountDialog(String uid, String name, double balance) {
    final controller = TextEditingController(text: "100");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Record meal for $name"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration:
              const InputDecoration(labelText: "Meal cost (Birr)"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final amount =
                  double.tryParse(controller.text) ?? 100;
              Navigator.pop(context);
              _recordMeal(uid, name, balance, amount);
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
