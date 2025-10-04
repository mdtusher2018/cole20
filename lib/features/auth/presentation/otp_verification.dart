import 'package:cole20/core/providers.dart';
import 'package:cole20/features/auth/application/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:cole20/core/assets.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/features/auth/presentation/reset_pass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/commonWidgets.dart';

class OtpVerificationScreen extends ConsumerWidget {
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  String getOTP() => otpControllers.map((e) => e.text.trim()).join();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.isAuthenticated) {
        slideNavigationPushAndRemoveUntil(
          ResetPasswordScreen(),
          context,
          onlypush: true,
        );
      } else if (next.isOtpResent && previous?.isOtpResent != true) {
        showSnackBar(
          context: context,
          message: "OTP resent successfully!",
          title: "Success",
        );
      } else if (next.hasError) {
        showSnackBar(
          context: context,
          message: next.errorMessage ?? "Verification failed",
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
      bottomSheet: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Image.asset(ImagePaths.logo, height: 80),
              const SizedBox(height: 10),
              commonText("45 cole20", size: 24.0, isBold: true),
              const SizedBox(height: 10),
              commonText("Enter Verification Code.", size: 18.0),
              const SizedBox(height: 5),
              commonText(
                "Enter the code that was sent to your email.",
                size: 14.0,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),

              // OTP Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: buildOTPTextField(
                      otpControllers[index],
                      index,
                      context,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Resend Code
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  commonText(
                    "Didn't receive the code? ",
                    size: 12.0,
                    color: Colors.grey,
                  ),
                  Builder(
                    builder: (context) {
                      final authState = ref.watch(authNotifierProvider);

                      if (authState.resendCooldown > 0) {
                        // ⏳ Show countdown instead of button
                        return commonText(
                          "Resend in ${authState.resendCooldown}s",
                          size: 12.0,
                          color: Colors.black,
                        );
                      }

                      // 🔁 Show Resend button when cooldown is finished
                      return GestureDetector(
                        onTap: () {
                          ref.read(authNotifierProvider.notifier).resendOtp();
                        },
                        child: commonText(
                          "Resend",
                          size: 12.0,
                          color: Colors.red,
                          isBold: true,
                        ),
                      );
                    },
                  ),
                ],
              ),

              const Spacer(),

              // Verify Button
              authState.isLoading
                  ? const CircularProgressIndicator()
                  : commonButton(
                    "Verify",
                    color: AppColors.green,
                    textColor: Colors.white,
                    onTap: () {
                      final otp = getOTP();
                      if (otp.length < 4) {
                        showSnackBar(
                          context: context,
                          message: "Please enter complete OTP",
                          title: "Empty",
                        );
                        return;
                      }

                      // Call verifyEmail in AuthNotifier
                      ref.read(authNotifierProvider.notifier).verifyOTP(otp);
                    },
                  ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
