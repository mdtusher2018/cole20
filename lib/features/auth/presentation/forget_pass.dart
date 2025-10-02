import 'package:cole20/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:cole20/core/assets.dart';

import 'package:cole20/features/auth/presentation/verification.dart';
import '../../../core/commonWidgets.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

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
              const SizedBox(height: 10),
              Image.asset(
                ImagePaths.logo,
                height: 80,
              ),
              const SizedBox(height: 10),
              commonText("45 cole20", size: 24.0, isBold: true),
              const SizedBox(height: 10),
              commonText("Forget Your Password?", size: 18.0),
              const SizedBox(height: 5),
              commonText(
                "Enter your email address to reset your password.",
                size: 14.0,
              ),
              const SizedBox(height: 30),

              // Email TextField
              commonTextfield(
                emailController,
                hintText: "Email",
                assetIconPath: ImagePaths.emailIcon,
                keyboardType: TextInputType.emailAddress,
              ),
              Spacer(),

              commonButton(
                "Get Verification Code",
                textColor: Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VerificationScreen()),
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
