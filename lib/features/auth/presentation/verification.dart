import 'package:flutter/material.dart';
import 'package:cole20/core/assets.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/features/auth/presentation/reset_pass.dart';
import '../../../core/commonWidgets.dart';

class VerificationScreen extends StatelessWidget {
  final List<TextEditingController> otpControllers =
      List.generate(4, (_) => TextEditingController());

  VerificationScreen({super.key});

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
      ),
      bottomSheet: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 16,
              ),
              Image.asset(
                ImagePaths.logo,
                height: 80,
              ),
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
                  GestureDetector(
                    onTap: () {},
                    child: commonText(
                      "Resend",
                      size: 12.0,
                      color: Colors.red,
                      isBold: true,
                    ),
                  ),
                ],
              ),
              Spacer(),

              // Verify Button
              commonButton(
                "Verify",
                color: AppColors.green,
                textColor: Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResetPasswordScreen()),
                  );
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
