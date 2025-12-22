import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Back button to return to Login
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
              const AuthHeader(), // Your existing Logo/Header
              const SizedBox(height: 30),
              
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Register as a new user",
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.secondaryText,
                ),
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
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // UI Action: Print values to console for now
                    print("Registering as: User");
                    print("Name: ${_nameController.text}");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Matches your seed color
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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