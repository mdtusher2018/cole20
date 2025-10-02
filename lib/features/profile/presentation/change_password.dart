import 'package:flutter/material.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/core/commonWidgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isCurrentPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: commonText(
          "Security",
          size: 20,
          isBold: true,
          color: AppColors.white,
        ),
        centerTitle: true,
      ),
      bottomSheet: Container(
        height: double.infinity,
        child: Column(
          children: [
            const Spacer(
              flex: 1,
            ),

            // Current Password Field
            _buildPasswordField(
              controller: currentPasswordController,
              label: "Current Password",
              isPasswordVisible: isCurrentPasswordVisible,
              onVisibilityToggle: () {
                setState(() {
                  isCurrentPasswordVisible = !isCurrentPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 15),

            // New Password Field
            _buildPasswordField(
              controller: newPasswordController,
              label: "New Password",
              isPasswordVisible: isNewPasswordVisible,
              onVisibilityToggle: () {
                setState(() {
                  isNewPasswordVisible = !isNewPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 15),

            // Confirm New Password Field
            _buildPasswordField(
              controller: confirmPasswordController,
              label: "Confirm New Password",
              isPasswordVisible: isConfirmPasswordVisible,
              onVisibilityToggle: () {
                setState(() {
                  isConfirmPasswordVisible = !isConfirmPasswordVisible;
                });
              },
            ),

            const Spacer(
              flex: 6,
            ),
            // Change Password Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: commonButton(
                "Change Password",
                color: AppColors.green,
                textColor: AppColors.white,
                onTap: () {
                  // Handle change password logic here
                  print("Password changed!");
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isPasswordVisible,
    required VoidCallback onVisibilityToggle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: controller,
        obscureText: !isPasswordVisible,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 1,
              )),
          labelText: label,
          labelStyle: const TextStyle(
            fontFamily: 'TenorSans',
            fontSize: 14,
            color: Colors.black,
          ),
          prefixIcon: const Icon(Icons.lock, color: AppColors.green),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: onVisibilityToggle,
          ),
        ),
      ),
    );
  }
}
