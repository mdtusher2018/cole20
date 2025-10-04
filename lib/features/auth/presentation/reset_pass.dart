
import 'package:cole20/core/providers.dart';
import 'package:cole20/features/auth/application/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:cole20/core/assets.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/features/auth/presentation/signin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/commonWidgets.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next.isResetPassword) {
        slideNavigationPushAndRemoveUntil(SignInScreen(), context);
      } else if (next.hasError) {
        showSnackBar(
          context: context,
          message: next.errorMessage ?? "Error",
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
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset(ImagePaths.logo, height: 80),
                const SizedBox(height: 10),
                commonText("45 cole20", size: 24.0, isBold: true),
                const SizedBox(height: 10),
                commonText("Now Reset Your Password.", size: 18.0),
                const SizedBox(height: 5),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 250),
                  child: commonText(
                    "Password  must have 8 characters with 1 symbol and 1 number.",
                    size: 14.0,
                    textAlign: TextAlign.center,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),

                // New Password TextField
                commonTextfield(
                  newPasswordController,
                  hintText: "New Password",
                  assetIconPath: ImagePaths.lockIcon,
                  isEnable: true,
                  isPasswordVisible: isPasswordVisible,
                  issuffixIconVisible: true,
                  changePasswordVisibility: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 15),

                // Confirm New Password TextField
                commonTextfield(
                  confirmPasswordController,
                  hintText: "Confirm New Password",
                  assetIconPath: ImagePaths.lockIcon,
                  isEnable: true,

                  isPasswordVisible: isConfirmPasswordVisible,
                  issuffixIconVisible: true,
                  changePasswordVisibility: () {
                    setState(() {
                      isConfirmPasswordVisible = !isConfirmPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 30),

                // Reset Password Button
                commonButton(
                  "Reset Password",
                  isLoading: authState.isLoading,
                  color: AppColors.green,
                  textColor: Colors.white,
                  onTap: () {
                    final newPass = newPasswordController.text.trim();
                    final confirmPass = confirmPasswordController.text.trim();

                    if (newPass.isEmpty || confirmPass.isEmpty) {
                      showSnackBar(
                        context: context,
                        message: "Please fill all fields",
                        title: "Empty",
                      );
                      return;
                    }
                    if (newPass != confirmPass) {
                      showSnackBar(
                        context: context,
                        message: "Passwords do not match",
                        title: "Error",
                      );
                      return;
                    }
                    ref
                        .read(authNotifierProvider.notifier)
                        .resetPassword(newPass, confirmPass);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
