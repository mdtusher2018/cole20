import 'package:flutter/material.dart';
import 'package:cole20/features/rituals/presentation/calender.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/features/rituals/presentation/home_page.dart';
import 'package:cole20/features/profile/presentation/profile.dart';
import 'package:cole20/features/rituals/presentation/root_task.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});
  static int selectedIndex = 0;
  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  // Pages for each tab
  final List<Widget> _pages = [
    const HomeScreen(),
    CalendarScreen(),
    const RootTaskScreen(),
    const ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      RootPage.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[RootPage.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: RootPage.selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'TenorSans',
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontFamily: 'TenorSans',
        ),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/home.png'),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/root_calender.png',
            ),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/retuals.png',
            ),
            label: "Rituals",
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/profile.png'),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
