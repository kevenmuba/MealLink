import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/alert_widgets.dart';

class AlertScreen extends StatelessWidget {
  const AlertScreen({super.key});

  /// Helper to format the timestamp into "time ago" string
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final dt = timestamp.toDate();
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inDays > 7) {
      return '${dt.day}/${dt.month}/${dt.year}';
    } else if (diff.inDays > 1) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays == 1) {
      return '1 day ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hours ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  /// Helper to determine icon and colors based on notification type
  Map<String, dynamic> _getStyle(String? type) {
    switch (type) {
      case 'warning':
      case 'low_balance':
        return {
          'icon': Icons.account_balance_wallet_outlined,
          'color': Colors.orange,
          'bgColor': const Color(0xFFFFF4E8), // Very light peach
        };
      case 'missed':
      case 'error':
        return {
          'icon': Icons.warning_amber_rounded,
          'color': Colors.orangeAccent,
          'bgColor': const Color(0xFFFFF8E1), // Light yellow
        };
      case 'approved':
      case 'success':
      default:
        // Default to green/check
        return {
          'icon': Icons.check_circle_outline,
          'color': Colors.green,
          'bgColor': AppColors.cardGreen,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Column(
        children: [
          // Header remains static content, but inside scrollable area if needed.
          // However, keeping it outside the listbuilder makes it sticky or just part of column.
          // The original code had it inside the ListView. Let's keep it inside or above.
          // The StreamBuilder should be flexible.
          Expanded(
            child: user == null
                ? const Center(
                    child: Text('Please log in to see notifications'),
                  )
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('notifications')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      // 1. Loading State
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // 2. Error State
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      // 3. Empty State
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return ListView(
                          padding: const EdgeInsets.all(20),
                          children: const [
                            AlertHeader(),
                            SizedBox(height: 40),
                            Center(
                              child: Text(
                                'No notifications yet',
                                style: TextStyle(
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      final docs = snapshot.data!.docs;

                      return ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: docs.length + 1, // +1 for Header
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [AlertHeader(), SizedBox(height: 24)],
                            );
                          }

                          final data =
                              docs[index - 1].data() as Map<String, dynamic>;
                          final style = _getStyle(data['type'] as String?);

                          return NotificationCard(
                            title: data['title'] ?? 'Notification',
                            description:
                                data['description'] ?? data['body'] ?? '',
                            time: _formatTimestamp(
                              data['createdAt'] as Timestamp?,
                            ),
                            icon: style['icon'],
                            iconColor: style['color'],
                            iconBgColor: style['bgColor'],
                            isUnread: data['isUnread'] ?? false,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
