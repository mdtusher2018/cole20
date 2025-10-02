import 'package:cole20/features/auth/application/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cole20/core/assets.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/features/auth/presentation/forget_pass.dart';
import 'package:cole20/features/home/presentation/root_page.dart';
import 'package:cole20/features/auth/presentation/signup.dart';
import 'package:cole20/core/commonWidgets.dart';
import 'package:cole20/core/providers.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController emailController = TextEditingController(text: "devrakibmia@gmail.com");
  final TextEditingController passwordController = TextEditingController(text: "123456");
  bool rememberMe = false;
  bool isPasswordVisible = false;

  void _login() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    await authNotifier.signin(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    final authState = ref.read(authNotifierProvider);

    if (authState.isAuthenticated) {
      slideNavigationPushAndRemoveUntil(RootPage(), context);
    } else if (authState.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authState.errorMessage.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthState  authState = ref.watch(authNotifierProvider);

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
                Image.asset(ImagePaths.logo, height: 80),
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

                // Remember Me & Forgot Password
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
                  isLoading: authState.isLoading,
                  onTap: _login,
                ),
                const SizedBox(height: 20),

                // Or Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.black)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: commonText("Or", size: 16.0),
                    ),
                    Expanded(child: Divider(color: AppColors.black)),
                  ],
                ),
                const SizedBox(height: 20),

                // Sign In with Google
                commonBorderButton(
                  "Sign In With Google",
                  imagePath: ImagePaths.googleIcon,
                  borderColor: AppColors.gold,
                  onTap: () {},
                ),
                const SizedBox(height: 15),

                // Sign In with Facebook
                commonBorderButton(
                  "Sign In With Facebook",
                  imagePath: ImagePaths.facebookIcon,
                  borderColor: AppColors.gold,
                  onTap: () {},
                ),
                const SizedBox(height: 30),

                // Sign Up Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    commonText("Don't have an account? ", size: 12.0),
                    GestureDetector(
                      onTap: () {
                        slideNavigationPushAndRemoveUntil(
                            SignUpScreen(), context);
                      },
                      child: commonText(
                        "Sign Up",
                        size: 12.0,
                        color: AppColors.berry,
                        isBold: true,
                      ),
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
