import 'package:flutter/material.dart';
import '../widgets/profile_widgets.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'update_payment_screen.dart';
import 'help_support_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const ProfileHeader(),
          const SizedBox(height: 24),
          const UserInfoCard(),
          const SizedBox(height: 24),
          MenuTile(
            title: 'Settings',
            icon: Icons.settings_outlined,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EditProfileScreen())),
          ),
          MenuTile(
            title: 'Change Password',
            icon: Icons.lock_outline,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChangePasswordScreen())),
          ),
          MenuTile(
            title: 'Payment Method',
            icon: Icons.payment_outlined,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UpdatePaymentScreen())),
          ),
          MenuTile(
            title: 'Help & Support',
            icon: Icons.help_outline,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HelpSupportScreen())),
          ),

          const SizedBox(height: 24),
          const SignOutButton(),
          const SizedBox(height: 30),
          const VersionFooter(),
        ],
      ),
    );
  }
}
