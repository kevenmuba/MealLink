import 'package:flutter/material.dart';
import '../../main/screens/main_wrapper.dart';
import '../widgets/auth_widgets.dart';
import '../../../core/theme/app_colors.dart';
import 'register_screen.dart'; // Ensure this import matches your file path

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const AuthHeader(),
              const SizedBox(height: 40),
              
              // Email Field
              const CustomTextField(
                label: 'Email Address',
                hintText: 'aymen@example.com',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),
              
              // Password Field
              const CustomTextField(
                label: 'Password',
                hintText: '••••••••',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              
              const SizedBox(height: 12),
              
              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement Forgot Password logic
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Login Button
              SignInButton(
                onPressed: () {
                  // Temporarily navigate to MainWrapper
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const MainWrapper(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 60), // Increased spacing since social buttons are gone
              
              // Sign Up Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: AppColors.secondaryText),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Register Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
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