import 'package:flutter/material.dart';
import '../widgets/profile_widgets.dart';

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
            onTap: () {},
          ),
          MenuTile(
            title: 'Help & Support',
            icon: Icons.help_outline,
            onTap: () {},
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
