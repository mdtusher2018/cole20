import 'package:flutter/material.dart';
import 'package:cole20/core/commonWidgets.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/features/profile/presentation/edit_profile.dart';
import 'package:cole20/features/profile/presentation/settings.dart';
import 'package:cole20/features/profile/presentation/statistic.dart';
import 'package:cole20/features/auth/presentation/signin.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      // appBar: AppBar(
      //   backgroundColor: AppColors.green,
      //   title: commonText(
      //     "Profile",
      //     size: 20,
      //     isBold: true,
      //     color: AppColors.white,
      //   ),
      //   centerTitle: true,
      // ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24))),
              height: MediaQuery.sizeOf(context).height * 0.8,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profile Card
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.only(
                            top: 16, bottom: 16, left: 16, right: 16.0),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            commonText("Phillip Williamson",
                                size: 18, isBold: true, color: AppColors.green),
                            const SizedBox(height: 5),

                            // Location and Task Count
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.location_on,
                                      color: AppColors.green, size: 16),
                                  commonText("Dhaka, Bangladesh",
                                      size: 14, color: Colors.grey.shade700),
                                  const SizedBox(width: 10),
                                  Container(
                                    width: 1,
                                    height: 15,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(width: 10),
                                  Icon(Icons.task_alt,
                                      color: AppColors.green, size: 16),
                                  commonText("2653 Task Completed",
                                      size: 14, color: Colors.grey.shade700),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Task Completed Stats
                            commonText("Task Completed",
                                size: 16, isBold: true, color: AppColors.black),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildStatCard("10", "Mental", AppColors.berry),
                                const SizedBox(width: 10),
                                _buildStatCard(
                                    "10", "Physical", AppColors.green),
                                const SizedBox(width: 10),
                                _buildStatCard(
                                    "10", "Spiritual", AppColors.gold),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Column(
                        children: [
                          // Menu Items
                          _buildMenuItem(
                            icon: Image.asset(
                              "assets/images/profile.png",
                              width: 24,
                              color: AppColors.green,
                            ),
                            title: "My Profile",
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return EditProfileScreen();
                                },
                              ));
                            },
                          ),
                          _buildMenuItem(
                            icon: Image.asset(
                              "assets/images/Chart.png",
                              width: 24,
                              color: AppColors.green,
                            ),
                            title: "Statistic",
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return StatisticsScreen();
                                },
                              ));
                            },
                          ),

                          _buildMenuItem(
                            icon: Image.asset(
                              "assets/images/Setting.png",
                              width: 24,
                              color: AppColors.green,
                            ),
                            title: "Settings",
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return SettingsScreen();
                                },
                              ));
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          _buildMenuItem(
                            icon: Image.asset(
                              "assets/images/Logout.png",
                              width: 24,
                              color: AppColors.green,
                            ),
                            title: "Logout",
                            onTap: () {
                              slideNavigationPushAndRemoveUntil(
                                  SignInScreen(), context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  elevation: 8,
                  shape: CircleBorder(),
                  shadowColor: Colors.black87,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://images.squarespace-cdn.com/content/v1/5cfb0f8783523500013c5639/2f93ecab-2aaa-4b12-af29-d0cb0eb2e368/Professional-Headshot-Vancouver?format=750w', // Replace with your image URL
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String number, String title, Color color) {
    return Expanded(
      child: Column(
        children: [
          commonText(number, size: 16, isBold: true),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: commonText(title, size: 14, color: AppColors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required Widget icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            commonText(title, size: 16, color: AppColors.black),
          ],
        ),
      ),
    );
  }
}
