import 'package:flutter/material.dart';
import 'package:cole20/core/assets.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/features/auth/presentation/forget_pass.dart';
import 'package:cole20/features/home/presentation/root_page.dart';
import 'package:cole20/features/auth/presentation/signup.dart';
import '../../../core/commonWidgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      bottomSheet: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
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
                commonText("Welcome Back!", size: 18.0),
                const SizedBox(height: 5),
                commonText(
                  "Enter your email address and password",
                  size: 14.0,
                  color: Colors.grey,
                ),
                const SizedBox(height: 30),

                // Email TextField
                commonTextfield(
                  emailController,
                  hintText: "Email",
                  assetIconPath: ImagePaths.emailIcon,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),

                // Password TextField with Visibility Toggle
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

                // Remember Me and Forgot Password Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                        ),
                        commonText("Remember me", size: 12.0),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen()),
                        );
                      },
                      child: commonText(
                        "Forgot Password",
                        size: 12.0,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Sign In Button
                commonButton(
                  "Sign In",
                  onTap: () {
                    slideNavigationPushAndRemoveUntil(RootPage(), context);
                  },
                ),
                const SizedBox(height: 20),

                // Or Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: AppColors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: commonText("Or", size: 16.0),
                    ),
                    Expanded(
                      child: Divider(color: AppColors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Sign In with Google
                commonBorderButton(
                  "Sign In With Google",
                  imagePath: ImagePaths.googleIcon,
                  borderColor: AppColors.gold,
                  onTap: () {
                    // Handle Google Sign In
                  },
                ),
                const SizedBox(height: 15),

                // Sign In with Facebook
                commonBorderButton(
                  "Sign In With Facebook",
                  imagePath: ImagePaths.facebookIcon,
                  borderColor: AppColors.gold,
                  onTap: () {
                    // Handle Facebook Sign In
                  },
                ),
                const SizedBox(height: 30),

                // Already have an account? Sign In
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    commonText("Don't have an account? ", size: 12.0),
                    GestureDetector(
                      onTap: () {
                        slideNavigationPushAndRemoveUntil(
                            SignUpScreen(), context);
                      },
                      child: commonText("Sign Up",
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
    );
  }
}
