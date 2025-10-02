import 'package:flutter/material.dart';
import 'package:cole20/core/assets.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/features/profile/presentation/compleate_profile.dart';
import 'package:cole20/features/auth/presentation/signin.dart';

import '../../../core/commonWidgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isAgree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      bottomSheet: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    ImagePaths.logo,
                    height: 80,
                  ),
                  const SizedBox(height: 10),
                  commonText("45 cole20", size: 24.0, isBold: true),
                  const SizedBox(height: 10),
                  commonText("Welcome Here!", size: 18.0),
                  const SizedBox(height: 5),
                  commonText("Create your account.",
                      size: 14.0, color: Colors.grey),
                  const SizedBox(height: 30),

                  // Full Name TextField
                  commonTextfield(
                    fullNameController,
                    hintText: "Full Name",
                    assetIconPath: ImagePaths.userIcon,
                  ),
                  const SizedBox(height: 15),

                  // Email TextField
                  commonTextfield(
                    emailController,
                    hintText: "Email",
                    assetIconPath: ImagePaths.emailIcon,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),

                  // Password TextField
                  commonTextfield(
                    passwordController,
                    hintText: "Password",
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

                  // Confirm Password TextField
                  commonTextfield(
                    confirmPasswordController,
                    hintText: "Confirm Password",
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
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Checkbox(
                        value: isAgree,
                        onChanged: (value) {
                          setState(() {
                            isAgree = value!;
                          });
                        },
                      ),
                      commonText("I agree with terms & conditions.",
                          size: 12.0),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Sign Up Button
                  commonButton("Sign Up", onTap: () {
                    slideNavigationPushAndRemoveUntil(
                        CompleteProfileScreen(), context);
                  }),
                  const SizedBox(height: 20),

                  // Or Divider
                  Row(
                    children: [
                      Expanded(
                          child: Divider(
                        color: AppColors.black,
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: commonText("Or", size: 16.0),
                      ),
                      Expanded(
                          child: Divider(
                        color: AppColors.black,
                      )),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Sign Up with Google
                  commonBorderButton(
                    "Sign Up With Google",
                    imagePath: ImagePaths.googleIcon,
                    borderColor: AppColors.gold,
                    onTap: () {},
                  ),

                  const SizedBox(height: 15),

                  // Sign Up with Facebook
                  commonBorderButton(
                    "Sign Up With Facebook",
                    imagePath: ImagePaths.facebookIcon,
                    borderColor: AppColors.gold,
                    onTap: () {
                      // Handle tap
                    },
                  ),

                  const SizedBox(height: 30),

                  // Already have an account? Sign In
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      commonText("Already have an account? ", size: 12.0),
                      GestureDetector(
                        onTap: () {
                          slideNavigationPushAndRemoveUntil(
                              SignInScreen(), context);
                        },
                        child: commonText("Sign In",
                            size: 12.0, color: AppColors.berry, isBold: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
