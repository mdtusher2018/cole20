import 'package:cole20/core/providers.dart';
import 'package:cole20/features/auth/presentation/email_verify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:cole20/core/assets.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/features/auth/presentation/signin.dart';
import '../../../core/commonWidgets.dart';

// Providers for local UI state
final isPasswordVisibleProvider = StateProvider<bool>((ref) => false);
final isConfirmPasswordVisibleProvider = StateProvider<bool>((ref) => false);
final isAgreeProvider = StateProvider<bool>((ref) => false);

final fullNameControllerProvider = Provider.autoDispose(
  (ref) => TextEditingController(),
);
final emailControllerProvider = Provider.autoDispose(
  (ref) => TextEditingController(),
);
final passwordControllerProvider = Provider.autoDispose(
  (ref) => TextEditingController(),
);
final confirmPasswordControllerProvider = Provider.autoDispose(
  (ref) => TextEditingController(),
);

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  void _signup(BuildContext context, WidgetRef ref) async {
    final fullName = ref.read(fullNameControllerProvider).text.trim();
    final email = ref.read(emailControllerProvider).text.trim();
    final password = ref.read(passwordControllerProvider).text.trim();
    final confirmPassword =
        ref.read(confirmPasswordControllerProvider).text.trim();
    final isAgree = ref.read(isAgreeProvider);

    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showSnackBar(
        context: context,
        message: "Please fill all fields",
        title: "Empty",
      );
      return;
    }

    if (password != confirmPassword) {
      showSnackBar(
        context: context,
        message: "Passwords do not match",
        title: "Error",
      );
      return;
    }

    if (!isAgree) {
      showSnackBar(
        context: context,
        message: "You must agree to the terms & conditions",
        title: "Invalid",
      );
      return;
    }

    // Call the signup method from notifier
    await ref
        .read(authNotifierProvider.notifier)
        .signup(email, password, fullName);

    final state = ref.read(authNotifierProvider);
    if (state.isEmailVerificationPending) {
      slideNavigationPushAndRemoveUntil(
        EmailVerificationScreen(),
        context,
        onlypush: true,
      );
    } else if (state.hasError) {
      showSnackBar(
        context: context,
        message: state.errorMessage ?? "Signup failed",
        title: "Error",
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isPasswordVisible = ref.watch(isPasswordVisibleProvider);
    final isConfirmPasswordVisible = ref.watch(
      isConfirmPasswordVisibleProvider,
    );
    final isAgree = ref.watch(isAgreeProvider);

    final fullNameController = ref.watch(fullNameControllerProvider);
    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);
    final confirmPasswordController = ref.watch(
      confirmPasswordControllerProvider,
    );

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
                  Image.asset(ImagePaths.logo, height: 80),
                  const SizedBox(height: 10),
                  commonText("45 Higher", size: 24.0, isBold: true),
                  const SizedBox(height: 10),
                  commonText("Welcome Here!", size: 18.0),
                  const SizedBox(height: 5),
                  commonText(
                    "Create your account.",
                    size: 14.0,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 30),

                  // Full Name
                  commonTextfield(
                    fullNameController,
                    hintText: "Full Name",
                    assetIconPath: ImagePaths.userIcon,
                  ),
                  const SizedBox(height: 15),

                  // Email
                  commonTextfield(
                    emailController,
                    hintText: "Email",
                    assetIconPath: ImagePaths.emailIcon,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),

                  // Password
                  commonTextfield(
                    passwordController,
                    hintText: "Password",
                    assetIconPath: ImagePaths.lockIcon,
                    isEnable: true,
                    isPasswordVisible: isPasswordVisible,
                    issuffixIconVisible: true,
                    changePasswordVisibility: () {
                      ref.read(isPasswordVisibleProvider.notifier).state =
                          !isPasswordVisible;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Confirm Password
                  commonTextfield(
                    confirmPasswordController,
                    hintText: "Confirm Password",
                    assetIconPath: ImagePaths.lockIcon,
                    isEnable: true,
                    isPasswordVisible: isConfirmPasswordVisible,
                    issuffixIconVisible: true,
                    changePasswordVisibility: () {
                      ref
                          .read(isConfirmPasswordVisibleProvider.notifier)
                          .state = !isConfirmPasswordVisible;
                    },
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Checkbox(
                        value: isAgree,
                        onChanged: (value) {
                          ref.read(isAgreeProvider.notifier).state = value!;
                        },
                      ),
                      commonText(
                        "I agree with terms & conditions.",
                        size: 12.0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Sign Up Button
                  authState.isLoading
                      ? const CircularProgressIndicator()
                      : commonButton(
                        "Sign Up",
                        onTap: () => _signup(context, ref),
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

                  // Sign Up With Google
                  commonBorderButton(
                    "Sign Up With Google",
                    imagePath: ImagePaths.googleIcon,
                    borderColor: AppColors.gold,
                    onTap: () {},
                  ),
                  const SizedBox(height: 15),

                  // Sign Up With Facebook
                  commonBorderButton(
                    "Sign Up With Facebook",
                    imagePath: ImagePaths.facebookIcon,
                    borderColor: AppColors.gold,
                    onTap: () {},
                  ),
                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      commonText("Already have an account? ", size: 12.0),
                      GestureDetector(
                        onTap: () {
                          slideNavigationPushAndRemoveUntil(
                            SignInScreen(),
                            context,
                          );
                        },
                        child: commonText(
                          "Sign In",
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
      ),
    );
  }
}
