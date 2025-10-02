// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:cole20/core/assets.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/features/home/presentation/root_page.dart';
import '../../../core/commonWidgets.dart';

class CompleteProfileScreen extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? selectedGender;

  CompleteProfileScreen({super.key});

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
                const SizedBox(height: 10),
                Image.asset(
                  ImagePaths.logo,
                  height: 80,
                ),
                const SizedBox(height: 10),
                commonText("45 cole20", size: 24.0, isBold: true),
                const SizedBox(height: 10),
                commonText("Now Complete Your\nProfile to Continue.",
                    size: 18.0),
                const SizedBox(height: 5),
                commonText(
                  "Fill in your information.",
                  size: 14.0,
                  color: Colors.grey,
                ),
                const SizedBox(height: 20),

                // Profile Image
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.green,
                        child: Image.asset(ImagePaths.compleateProfileIcon)),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 3, color: AppColors.green)),
                      child: const Icon(
                        Icons.edit,
                        color: AppColors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Full Name TextField
                commonTextfield(
                  fullNameController,
                  hintText: "Full Name",
                ),
                const SizedBox(height: 15),

                // Gender Dropdown
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint:
                          commonText("Gender", size: 14.0, color: Colors.grey),
                      value: selectedGender,
                      items: <String>["Male", "Female", "Other"]
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: commonText(value, size: 14.0),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        selectedGender = newValue;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Phone TextField
                commonTextfield(
                  phoneController,
                  hintText: "Phone",
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 30),

                // Continue Button
                commonButton(
                  "Continue",
                  color: AppColors.green,
                  textColor: Colors.white,
                  onTap: () {
                    slideNavigationPushAndRemoveUntil(RootPage(), context);
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
