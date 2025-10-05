import 'package:cole20/core/providers.dart';
import 'package:flutter/material.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/core/commonWidgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/profile_state.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isCurrentPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() async {
    final oldPass = currentPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      showSnackBar(
        context: context,
        message: "All fields are required",
        title: "Error",
      );
      return;
    }

    if (newPass != confirmPass) {
      showSnackBar(
        context: context,
        message: "New password and confirm password do not match",
        title: "Error",
      );
      return;
    }

    await ref
        .read(profileNotifierProvider.notifier)
        .changePassword(oldPass, newPass);
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);

    ref.listen<ProfileState>(profileNotifierProvider, (prev, next) {
      if (next.status == ProfileStatus.loaded) {
        showSnackBar(
          context: context,
          message: "Password changed successfully",
          title: "Success",
          backgroundColor: Colors.green,
        );
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      } else if (next.hasError) {
        showSnackBar(
          context: context,
          message: next.errorMessage ?? "Failed to change password",
          title: "Error",
        );
      }
    });

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
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          children: [
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
            Spacer(),
            commonButton(
              "Change Password",
              color: AppColors.green,
              textColor: AppColors.white,
              isLoading: profileState.status == ProfileStatus.changingPassword,
              onTap: _changePassword,
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
            borderSide: const BorderSide(width: 1),
          ),
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
