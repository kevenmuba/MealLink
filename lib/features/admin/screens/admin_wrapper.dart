import 'package:flutter/material.dart';
import '../../home/screens/home_screen.dart';
import 'admin_customers_screen.dart'; // Ensure this matches your file path
import '../../alert/screens/alert_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../../core/theme/app_colors.dart';

class AdminWrapper extends StatefulWidget {
  const AdminWrapper({super.key});

  @override
  State<AdminWrapper> createState() => _AdminWrapperState();
}

class _AdminWrapperState extends State<AdminWrapper> {
  int _currentIndex = 0;

  // Swapped PaymentScreen with AdminCustomersScreen
  final List<Widget> _screens = [
    const HomeScreen(),
    const AdminCustomersScreen(), 
    const AlertScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Current selected screen
      body: _screens[_currentIndex],
      
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.accentBlack,
          borderRadius: BorderRadius.circular(30),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: AppColors.accentBlack,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white60,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: const [
              // Home Item
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(Icons.home, color: Colors.black),
                ),
                label: 'Home',
              ),
              
              // Customers Item (Previously Payment)
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(Icons.people, color: Colors.black),
                ),
                label: 'Customers',
              ),
              
              // Notifications Item
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_none),
                activeIcon: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(Icons.notifications, color: Colors.black),
                ),
                label: 'Alert',
              ),
              
              // Profile Item
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(Icons.person, color: Colors.black),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}