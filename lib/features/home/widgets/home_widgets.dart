import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/theme/app_colors.dart';

const int kPricePerMeal = 100; // price per single food (Birr)

String _formatCurrency(int value) {
  final s = value.toString();
  return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
} 

double _parseAmount(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  if (value is String) {
    // remove currency symbols, commas and other non numeric characters
    final cleaned = value.replaceAll(RegExp(r"[^0-9.\-]"), '');
    return double.tryParse(cleaned) ?? 0;
  }
  if (value is Map) return _extractAmountFromMap(Map<String, dynamic>.from(value));
  if (value is List) {
    for (final v in value) {
      final p = _parseAmount(v);
      if (p > 0) return p;
    }
  }
  return 0;
}

double _extractAmountFromMap(Map<String, dynamic> map) {
  final lcKeys = map.keys.map((k) => k.toLowerCase()).toList();
  // common amount keys
  const candidates = ['amount', 'amt', 'price', 'total', 'balance', 'paid'];
  for (final c in candidates) {
    final idx = lcKeys.indexOf(c);
    if (idx != -1) {
      final key = map.keys.elementAt(idx);
      return _parseAmount(map[key]);
    }
  }
  // recursively search nested maps/lists for any numeric value
  for (final value in map.values) {
    final p = _parseAmount(value);
    if (p > 0) return p;
  }
  return 0;
} 

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'We made fresh and Healthy food',
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Delicious Food',
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
            hintText: 'Search contracts, vendors, or food items...',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class TodayStatusSection extends StatelessWidget {
  const TodayStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Today's Status",
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.availableChip,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black12),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle_outline, size: 16, color: Colors.black87),
              SizedBox(width: 4),
              Text(
                'Available',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TodayMealCard extends StatelessWidget {
  const TodayMealCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Placeholder
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Injera_wide.jpg/1200px-Injera_wide.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: const Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 10,
                  child: Text(
                    "Injera with Doro Wat", // Visual placeholder for the "Injera..." text in image if it was overlay, but design has it below.
                    // Actually the design has it inside the white card below the image.
                    style: TextStyle(
                      color: Colors.transparent,
                    ), // Hidden, just for accessibility if needed
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "TODAY'S MEAL",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Injera with Doro Wat",
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '1 meal / day',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                '$kPricePerMeal Birr',
                style: const TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class IAteTodayButton extends StatelessWidget {
  const IAteTodayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentBlack,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        onPressed: () {},
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, size: 20),
            SizedBox(width: 10),
            Text(
              'I Ate Today',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class StatsGrid extends StatefulWidget {
  const StatsGrid({super.key});

  @override
  _StatsGridState createState() => _StatsGridState();
}

class _StatsGridState extends State<StatsGrid> {
  int balance = 0;
  int remainingDays = 0;
  int daysEaten = 0;
  int daysMissed = 0;
  bool loading = true;

  int paymentDocs = 0;
  String fetchDebug = ''; 

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  Future<void> _fetchBalance() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        if (kDebugMode) {
          print('[payments] no signed-in user');
        }
        setState(() {
          loading = false;
        });
        return;
      }

      final email = user.email!;
      final uid = user.uid;
      final ref = FirebaseFirestore.instance.collection('payments');

      List<DocumentSnapshot> found = [];

      // 1) Try querying common email/uid fields
      final checks = [
        {'field': 'useremail', 'value': email},
        {'field': 'userEmail', 'value': email},
        {'field': 'email', 'value': email},
        {'field': 'userId', 'value': uid},
        {'field': 'uid', 'value': uid},
      ];

      for (final c in checks) {
        try {
          final q = await ref.where(c['field'] as String, isEqualTo: c['value']).get();
          if (q.docs.isNotEmpty) {
            found = q.docs;
            if (kDebugMode) print('[payments] found ${q.docs.length} docs by ${c['field']}');
            break;
          }
        } catch (e) {
          // ignore errors (field may not exist or not indexed)
          if (kDebugMode) print('[payments] query error for ${c['field']}: $e');
        }
      }

      // 2) Try doc id equals uid or email
      if (found.isEmpty) {
        final dUid = await ref.doc(uid).get();
        if (dUid.exists) {
          found.add(dUid);
          if (kDebugMode) print('[payments] found doc by uid');
        }
        final dEmail = await ref.doc(email).get();
        if (dEmail.exists) {
          found.add(dEmail);
          if (kDebugMode) print('[payments] found doc by email');
        }
      }

      // 3) Last resort: fetch a page of documents and filter locally (use with caution)
      if (found.isEmpty) {
        final all = await ref.limit(500).get();
        for (final d in all.docs) {
          final data = d.data();
          if (data is Map<String, dynamic>) {
            final lowerJoined = data.values
                .map((v) => v?.toString().toLowerCase() ?? '')
                .join(' ');
            // try matching email or uid or uid token
            if (lowerJoined.contains(email.toLowerCase()) || lowerJoined.contains(uid) || lowerJoined.contains(uid.split(' ').first)) {
              found.add(d);
            } else {
              // also check userId field that may contain extra text
              final rawUserId = (data['userId'] ?? data['userid'] ?? data['uid'] ?? data['user_id']);
              if (rawUserId is String) {
                final token = rawUserId.split(RegExp(r"\s+"))[0];
                if (token.isNotEmpty && (token == uid || token == uid.split(' ').first)) {
                  found.add(d);
                }
              }
            }
          }
        }
        if (kDebugMode) print('[payments] local filtered docs found: ${found.length}');
      }

      // parse amounts
      double sum = 0;
      for (final doc in found) {
        final data = doc.data();
        if (data is Map<String, dynamic>) {
          final amt = _extractAmountFromMap(data);
          sum += amt;
          if (kDebugMode) print('[payments] parsed ${doc.id} -> $amt');
        } else if (data != null) {
          final parsed = _parseAmount(data);
          sum += parsed;
          if (kDebugMode) print('[payments] parsed ${doc.id} raw -> $parsed');
        }
      }

      final int bal = sum.round();
      setState(() {
        balance = bal;
        remainingDays = (balance / kPricePerMeal).floor();
        paymentDocs = found.length;
        fetchDebug = 'found ${found.length} doc(s)';
        loading = false;
      });
    } catch (e, st) {
      if (kDebugMode) print('[payments] fetch error: $e\n$st');
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Your Balance",
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Balance',
                value: loading ? 'Loading...' : '${_formatCurrency(balance)} Birr',
                subValue: loading ? null : (paymentDocs > 0 ? '$paymentDocs payment(s)' : 'No payments found'),
                bgColor: AppColors.cardOrange,
                iconBgColor: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                icon: Icons.calendar_today_outlined,
                title: 'Remaining\nDays',
                value: loading ? '-' : remainingDays.toString(),
                subValue: 'meal days left',
                bgColor: AppColors.cardWhite,
                iconBgColor: Colors.white, // Actually outline in design?
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                icon: Icons.check_circle_outline,
                title: 'Days Eaten',
                value: loading ? '-' : daysEaten.toString(),
                bgColor: AppColors.cardGreen,
                iconBgColor: Colors.white.withOpacity(0.5), // Subtle
                isGreenIcon: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                icon: Icons.cancel_outlined,
                title: 'Days Missed',
                value: loading ? '-' : daysMissed.toString(),
                bgColor: AppColors.cardWhite,
                iconBgColor: Colors.grey[200]!,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    String? subValue,
    required Color bgColor,
    required Color iconBgColor,
    bool isGreenIcon = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: isGreenIcon ? Colors.green : Colors.black87,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subValue != null)
                  Text(
                    subValue,
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 

class MonthlyPlanCard extends StatelessWidget {
  const MonthlyPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.payment, color: AppColors.cardOrange),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pay Monthly Plan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '${kPricePerMeal * 30} Birr / month',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
