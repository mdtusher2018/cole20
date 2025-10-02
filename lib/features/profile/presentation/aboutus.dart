import 'package:flutter/material.dart';
import 'package:cole20/core/assets.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/core/commonWidgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        title: commonText(
          "About",
          size: 20,
          isBold: true,
          color: AppColors.white,
        ),
        centerTitle: true,
      ),
      bottomSheet: SizedBox(
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                ImagePaths.aboutLogo,
              ),
              const SizedBox(height: 20),
              commonText("https://nicolewillisconsulting.com", size: 16),

              const SizedBox(height: 20),
              commonText(
                "Version 2.22.18",
                size: 16,
                color: Colors.grey.shade700,
              ),
              const SizedBox(height: 5),

              // Copyright
              commonText(
                "©2022 TaskWan",
                size: 14,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
