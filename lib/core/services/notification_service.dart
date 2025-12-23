import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class NotificationService {
  // Singleton Pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription? _userSubscription;
  int? _previousBalance;
  DateTime? _lastMealTime;

  /// Call this when the app starts or user logs in
  void init() {
    debugPrint("NotificationService: Initializing...");
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        debugPrint("NotificationService: User logged in ${user.uid}");
        _startListening(user.uid);
      } else {
        debugPrint("NotificationService: User logged out");
        _stopListening();
      }
    });
  }

  void _stopListening() {
    _userSubscription?.cancel();
    _userSubscription = null;
    _previousBalance = null;
    _lastMealTime = null;
  }

  void _startListening(String uid) {
    _stopListening();

    final userDocRef = _firestore.collection('users').doc(uid);

    _userSubscription = userDocRef.snapshots().listen((snapshot) async {
      if (!snapshot.exists) {
        debugPrint("NotificationService: User document does not exist");
        return;
      }

      final data = snapshot.data();
      if (data == null) return;

      final int currentBalance = (data['balance'] as num?)?.toInt() ?? 0;
      final Timestamp? lastMealTs = data['last_meal_at'] as Timestamp?;

      debugPrint(
        "NotificationService: Stream update. Balance: $currentBalance, LastMeal: $lastMealTs",
      );

      // Always sync local state with Firestore
      if (lastMealTs != null) {
        _lastMealTime = lastMealTs.toDate();
      }

      // 0. Seed Welcome
      await _checkAndSeedWelcome(uid);

      // 1. Check Low Balance
      await _checkLowBalance(currentBalance, uid);

      // 2. Check Meal Approved (Balance decreased by ~100)
      if (_previousBalance != null) {
        await _checkMealApproved(_previousBalance!, currentBalance, uid);
      }

      // Update previous balance
      _previousBalance = currentBalance;

      // 3. Check Meal Missed (Balance not decreased/updated in 24h)
      await _checkMealMissed(uid);
    });
  }

  Future<void> _checkAndSeedWelcome(String uid) async {
    try {
      final query = await _firestore
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .limit(1)
          .get();
      if (query.docs.isEmpty) {
        debugPrint("NotificationService: Seeding welcome notification");
        await _addNotification(
          uid: uid,
          title: 'Welcome to MealLink',
          body:
              'You will receive notifications here about your meals and balance.',
          type: 'success',
        );
      }
    } catch (e) {
      debugPrint("NotificationService error seeding welcome: $e");
    }
  }

  Future<void> _checkLowBalance(int currentBalance, String uid) async {
    // Logic: Low balance is < 1500
    if (currentBalance < 1500) {
      final latestNotif = await _firestore
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (latestNotif.docs.isNotEmpty) {
        final lastData = latestNotif.docs.first.data();
        if (lastData['type'] == 'low_balance' &&
            lastData['createdAt'] != null &&
            (lastData['createdAt'] as Timestamp)
                    .toDate()
                    .difference(DateTime.now())
                    .inHours <
                24) {
          return; // Already notified today
        }
      }

      debugPrint("NotificationService: Triggering Low Balance");
      await _addNotification(
        uid: uid,
        title: 'Low Balance',
        body: 'Your balance is running low ($currentBalance Birr).',
        type: 'low_balance',
      );
    }
  }

  Future<void> _checkMealApproved(int prev, int current, String uid) async {
    final diff = prev - current;
    // Assuming meal cost is roughly 100
    if (diff >= 100 && diff <= 110) {
      debugPrint("NotificationService: Meal Approved Detected");
      await _addNotification(
        uid: uid,
        title: 'Meal Approved',
        body: 'Your meal for today has been approved. Enjoy!',
        type: 'approved',
      );

      // Update last_meal_at explicitly if it wasn't updated by the backend?
      // Usually backend does this. But we can do it to be safe/responsive.
      // NOTE: Updating it here might trigger another snapshot!
      // Ensure infinite loops are avoided. The snapshot will come back with new 'last_meal_at',
      // which updates _lastMealTime. Correct.
      await _firestore.collection('users').doc(uid).update({
        'last_meal_at': FieldValue.serverTimestamp(),
      });
      _lastMealTime = DateTime.now();
    }
  }

  Future<void> _checkMealMissed(String uid) async {
    if (_lastMealTime == null) {
      debugPrint(
        "NotificationService: No last used meal time found. Skipping missed check.",
      );
      return;
    }

    final now = DateTime.now();
    final difference = now.difference(_lastMealTime!);

    if (difference.inHours > 24) {
      debugPrint(
        "NotificationService: Meal Missed Condition Met (${difference.inHours} hours)",
      );

      // Check if already notified about missing
      final latestNotif = await _firestore
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .where('type', isEqualTo: 'missed')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (latestNotif.docs.isNotEmpty) {
        final lastMissed =
            (latestNotif.docs.first.data()['createdAt'] as Timestamp).toDate();
        if (now.difference(lastMissed).inHours < 24) {
          debugPrint(
            "NotificationService: Already notified missed meal recently.",
          );
          return;
        }
      }

      await _addNotification(
        uid: uid,
        title: 'Meal Missed',
        body: 'You didn\'t claim your meal yesterday.',
        type: 'missed',
      );
    }
  }

  Future<void> _addNotification({
    required String uid,
    required String title,
    required String body,
    required String type,
  }) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .add({
          'title': title,
          'body': body,
          'description': body,
          'type': type,
          'isUnread': true,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }
}
