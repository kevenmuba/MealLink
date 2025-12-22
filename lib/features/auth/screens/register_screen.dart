import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/auth_widgets.dart';
import '../../../core/theme/app_colors.dart';

class RegisterScreen extends StatefulWidget {
const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers for the UI fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Loading state to disable button and show progress
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Create User in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. Store user profile in Firestore with Step 1 requirements
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'role': 'customer',             // Changed from 'user' to 'customer'
        'status': 'pending',            // 🔴 The gatekeeper status
        'totalPaid': 0.0,               // Initial financial state
        'balance': 0.0,                 // Initial financial state
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3. Success Feedback
      if (mounted) {
        // Log out immediately so they don't stay logged in after registration
        await FirebaseAuth.instance.signOut(); 

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration successful. Please wait for admin approval."),
            backgroundColor: Colors.orange, // Orange suggests "waiting/pending"
            duration: Duration(seconds: 5),
          ),
        );
        
        // Redirect to Login Screen
        Navigator.pop(context); 
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.message ?? "An error occurred";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Dynamic Header from your auth_widgets.dart
              const AuthHeader(
                title: "Create Account",
                subtitle: "Register as a new user to get started",
              ),
              
              const SizedBox(height: 35),
              
              // --- FORM FIELDS ---
              CustomTextField(
                label: 'Full Name',
                hintText: 'Enter your name',
                icon: Icons.person_outline,
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              
              CustomTextField(
                label: 'Mobile Number',
                hintText: '05XX XX XX XX',
                icon: Icons.phone_android_rounded,
                controller: _phoneController,
              ),
              const SizedBox(height: 20),
              
              CustomTextField(
                label: 'Email Address',
                hintText: 'example@mail.com',
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
              
              const SizedBox(height: 40),
              
              // --- SIGN UP BUTTON ---
              _isLoading 
              ? const CircularProgressIndicator(color: Colors.deepPurple)
              : SignInButton(
                  text: "Create Account",
                  onPressed: _handleRegister,
                ),
              
              const SizedBox(height: 25),
              
              // --- FOOTER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: AppColors.secondaryText),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}