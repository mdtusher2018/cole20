import 'package:flutter/material.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/core/commonWidgets.dart';
import 'package:cole20/features/profile/presentation/aboutus.dart';
import 'package:cole20/features/profile/presentation/change_password.dart';
// import 'package:cole20/features/profile/presentation/help.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.green,
        elevation: 0,
        title: commonText(
          "Settings",
          size: 20,
          isBold: true,
          color: AppColors.white,
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.green,
      bottomSheet: SizedBox(
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Security
              _buildSettingOption(
                icon: "assets/images/lock.png",
                title: "Security",
                iconColor: AppColors.green,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ChangePasswordScreen();
                    },
                  ));
                },
              ),
              // Help
              // _buildSettingOption(
              //   icon: "assets/images/help.png",
              //   title: "Help",
              //   iconColor: AppColors.green,
              //   onTap: () {
              //     Navigator.push(context, MaterialPageRoute(
              //       builder: (context) {
              //         return HelpScreen();
              //       },
              //     ));
              //   },
              // ),
              // // About Us
              _buildSettingOption(
                icon: "assets/images/aboutus.png",
                title: "About Us",
                iconColor: AppColors.green,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return AboutScreen();
                    },
                  ));
                },
              ),
              // Delete Account
              _buildSettingOption(
                icon: "assets/images/delete.png",
                title: "Delete Account",
                iconColor: Colors.red,
                onTap: () {
                  showDeleteTaskDialog(
                    context,
                    () {
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingOption({
    required String icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        margin: const EdgeInsets.symmetric(vertical: 10),
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
            Image.asset(icon, color: iconColor, width: 24),
            const SizedBox(width: 10),
            commonText(title, size: 16, color: AppColors.black),
          ],
        ),
      ),
    );
  }

  Future<void> showDeleteTaskDialog(
      BuildContext context, VoidCallback onDelete) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: commonText("Do you want to delete your account?",
              size: 16, textAlign: TextAlign.center),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: commonButton(
                    "Cancel",
                    color: Colors.grey.shade300,
                    textColor: Colors.black,
                    height: 40,
                    width: 100,
                    onTap: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: commonButton(
                    "Delete",
                    color: AppColors.goldShades[600]!,
                    textColor: Colors.white,
                    height: 40,
                    width: 100,
                    onTap: () {
                      Navigator.of(context).pop(); // Close the dialog
                      onDelete(); // Perform the delete action
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
