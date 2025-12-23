import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Profile',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryText,
        ),
      ),
    );
  }
}

class UserInfoCard extends StatefulWidget {
  const UserInfoCard({super.key});

  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  bool loading = true;
  String name = '';
  String email = '';
  String phone = '';
  String role = '';
  String status = '';
  int balance = 0;
  int totalPaid = 0;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          loading = false;
        });
        return;
      }

      // first try document by uid
      final uid = user.uid;
      final ref = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot<Map<String, dynamic>>? doc;

      final byId = await ref.doc(uid).get();
      if (byId.exists) {
        doc = byId;
      } else if (user.email != null) {
        // fallback query by email
        final q = await ref.where('email', isEqualTo: user.email).limit(1).get();
        if (q.docs.isNotEmpty) {
          doc = q.docs.first;
        }
      }

      if (doc != null && doc.exists) {
        final data = doc.data() ?? {};
        setState(() {
          name = (data['name'] ?? user.displayName ?? '') as String;
          email = (data['email'] ?? user.email ?? '') as String;
          phone = (data['phone'] ?? '') as String;
          role = (data['role'] ?? '') as String;
          status = (data['status'] ?? '') as String;
          balance = (data['balance'] is num) ? (data['balance'] as num).toInt() : int.tryParse('${data['balance']}') ?? 0;
          totalPaid = (data['totalPaid'] is num) ? (data['totalPaid'] as num).toInt() : int.tryParse('${data['totalPaid']}') ?? 0;
          loading = false;
        });
      } else {
        // no user doc, use auth data
        setState(() {
          name = user.displayName ?? '';
          email = user.email ?? '';
          loading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) print('[profile] load user error: $e');
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final initials = (name.isNotEmpty) ? name.trim().split(' ').map((s) => s.isNotEmpty ? s[0] : '').take(2).join() : '?';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFFBEFE7), // Light peach
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isNotEmpty ? name : 'No name',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.email_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        email.isNotEmpty ? email : 'No email',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      phone.isNotEmpty ? phone : 'No phone',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      role.isNotEmpty ? role : '',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    if (status.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: status == 'active' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(color: status == 'active' ? Colors.green : Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                // contact info and role/status. Use Wrap to avoid overflow.
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.phone, size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(phone.isNotEmpty ? phone : 'No phone', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                    if (role.isNotEmpty)
                      Chip(label: Text(role, style: const TextStyle(fontSize: 12))),
                    if (status.isNotEmpty)
                      Chip(
                        label: Text(status, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        backgroundColor: status == 'active' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                        labelStyle: TextStyle(color: status == 'active' ? Colors.green : Colors.orange),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const MenuTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: Colors.grey[700]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD32F2F), // Red
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        onPressed: () async {
          try {
            await FirebaseAuth.instance.signOut();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signed out')));
            // You may want to navigate to the login screen here.
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign out failed: $e')));
          }
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              size: 20,
              color: Colors.white,
            ), // Image has exit icon
            SizedBox(width: 10),
            Text(
              'Sign Out',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class VersionFooter extends StatelessWidget {
  const VersionFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Text(
            'MealLink v1.0.0',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          SizedBox(height: 2),
          Text(
            '© 2024 Nile Food',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
