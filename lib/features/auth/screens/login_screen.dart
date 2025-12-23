import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../main/screens/main_wrapper.dart';
import '../../admin/screens/admin_wrapper.dart';
import 'waiting_approval_screen.dart';
import '../widgets/auth_widgets.dart';
import '../../../core/theme/app_colors.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
  if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
    _showMessage("Please fill in all fields");
    return;
  }

  setState(() => _isLoading = true);

  try {
    // 1. Sign in with Firebase Auth
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // 2. Fetch User Data
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();

    if (!mounted) return;

    // 3. Robust Routing Logic
    if (userDoc.exists) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      String role = data['role'] ?? 'user';
      String status = data['status'] ?? 'pending';

      if (role == 'admin') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminWrapper()));
      } else if (status == 'active') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainWrapper()));
      } else {
        // This explicitly catches 'pending' or any other status
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const WaitingApprovalScreen()));
      }
    } else {
      // If Auth succeeded but no Firestore doc exists, treat as pending or error
      _showMessage("Profile setup incomplete. Please contact admin.");
    }

  } on FirebaseAuthException catch (e) {
    // This catches wrong password/user not found
    _showMessage(e.message ?? "Authentication failed");
  } catch (e) {
    // This catches Firestore or other unexpected errors
    _showMessage("An error occurred: $e");
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const AuthHeader(),
              const SizedBox(height: 40),
              CustomTextField(
                label: 'Email Address',
                hintText: 'aymen@example.com',
                icon: Icons.email_outlined,
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Password',
                hintText: '••••••••',
                icon: Icons.lock_outline,
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : SignInButton(onPressed: _handleLogin),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ",
                      style: TextStyle(color: AppColors.secondaryText)),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen())),
                    child: const Text('Sign Up',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryText)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}