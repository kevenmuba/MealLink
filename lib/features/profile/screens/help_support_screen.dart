import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _ctrl = TextEditingController();
  bool _sending = false;

  Future<void> _createTicket() async {
    final message = _ctrl.text.trim();
    if (message.isEmpty) return;
    setState(() => _sending = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      final data = {
        'message': message,
        'uid': user?.uid,
        'email': user?.email,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'open',
      };
      final ref = await FirebaseFirestore.instance.collection('support_tickets').add(data);
      if (!mounted) return;
      _ctrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ticket created: ${ref.id}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Create ticket failed: $e')));
    } finally {
      setState(() => _sending = false);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('FAQ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('- How do I update my profile? Use Settings > Edit Profile.'),
            const SizedBox(height: 6),
            const Text('- How are payments processed? Payments are tracked in your account.'),
            const SizedBox(height: 12),
            const Text('Create a support ticket', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _ctrl,
              maxLines: 4,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Describe your issue...'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _sending ? null : _createTicket, child: _sending ? const CircularProgressIndicator() : const Text('Create Ticket')),
            ),
          ],
        ),
      ),
    );
  }
}