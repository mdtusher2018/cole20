import 'package:flutter/material.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/core/commonWidgets.dart';

class EditProfileScreen extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: commonText("My Profile",
            size: 20, isBold: true, color: AppColors.white),
        centerTitle: true,
      ),
      bottomSheet: SizedBox(
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              // Profile Picture with Edit Icon
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://images.squarespace-cdn.com/content/v1/5cfb0f8783523500013c5639/2f93ecab-2aaa-4b12-af29-d0cb0eb2e368/Professional-Headshot-Vancouver?format=750w', // Replace with your image URL
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        // Handle edit profile picture logic
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            border:
                                Border.all(width: 3, color: AppColors.berry),
                            borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.edit, color: AppColors.berry),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Full Name Field
              commonTextfield(
                fullNameController,
                hintText: "Full Name",
                borderColor: AppColors.green,
              ),
              const SizedBox(height: 15),

              // Email Field
              commonTextfield(
                emailController,
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
                borderColor: AppColors.green,
              ),
              const SizedBox(height: 15),

              // Phone Field
              commonTextfield(
                phoneController,
                hintText: "Phone",
                keyboardType: TextInputType.phone,
                borderColor: AppColors.green,
              ),

              // Gender Dropdown
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   decoration: BoxDecoration(
              //     border: Border.all(color: AppColors.green),
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: DropdownButtonFormField<String>(
              //     value: null,
              //     decoration: const InputDecoration(
              //       border: InputBorder.none,
              //     ),
              //     hint: commonText("Gender",
              //         size: 14, color: AppColors.black.withOpacity(0.6)),
              //     items: ["Male", "Female", "Other"]
              //         .map((gender) => DropdownMenuItem<String>(
              //               value: gender,
              //               child: commonText(gender, size: 14),
              //             ))
              //         .toList(),
              //     onChanged: (value) {
              //       // Handle gender selection logic
              //     },
              //   ),
              // ),

              Spacer(),
              // Save Button
              commonButton(
                "Save",
                color: AppColors.green,
                textColor: AppColors.white,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
