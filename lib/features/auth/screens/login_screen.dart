import 'package:flutter/material.dart';
import '../../main/screens/main_wrapper.dart';
import '../widgets/auth_widgets.dart';
import '../../../core/theme/app_colors.dart';

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
              const CustomTextField(
                label: 'Email Address',
                hintText: 'aymen@example.com',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: 'Password',
                hintText: '••••••••',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
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
              SignInButton(
                onPressed: () {
                  // Navigate to MainWrapper (Home)
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const MainWrapper(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.black12)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(color: AppColors.secondaryText),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.black12)),
                ],
              ),
              const SizedBox(height: 30),
              const Row(
                children: [
                  SocialButton(
                    label: 'Google',
                    icon: Icons.g_mobiledata,
                    iconColor: Colors.blue,
                  ), // Replaced with text/icon for now
                  SizedBox(width: 16),
                  SocialButton(
                    label: 'Apple',
                    icon: Icons.apple,
                    iconColor: Colors.black,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: AppColors.secondaryText),
                  ),
                  GestureDetector(
                    onTap: () {},
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
