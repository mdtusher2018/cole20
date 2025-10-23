// ignore_for_file: must_be_immutable
import 'dart:io';
import 'package:cole20/core/providers.dart';
import 'package:cole20/features/auth/application/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:cole20/core/assets.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/features/rituals/presentation/root_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/commonWidgets.dart';

/// Local providers for UI-only states (not global app state)
final selectedGenderProvider = StateProvider<String?>((ref) => null);
final pickedImageProvider = StateProvider<File?>((ref) => null);

class CompleteProfileScreen extends ConsumerWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final selectedGender = ref.watch(selectedGenderProvider);
    final pickedImage = ref.watch(pickedImageProvider);

    // Listen for auth state changes
    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next.isProfileCompleted) {
        showSnackBar(
          context: context,
          message: "Profile completed successfully!",
          title: "Success",
        );
        slideNavigationPushAndRemoveUntil(RootPage(), context);
      } else if (next.hasError) {
        showSnackBar(
          context: context,
          message: next.errorMessage ?? "Failed to complete profile",
          title: "Error",
        );
      }
    });

    Future<void> pickImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        ref.read(pickedImageProvider.notifier).state = File(image.path);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.green,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
                Image.asset(ImagePaths.logo, height: 80),
                const SizedBox(height: 10),
                commonText("45 Higher", size: 24.0, isBold: true),
                const SizedBox(height: 10),
                commonText(
                  "Now Complete Your\nProfile to Continue.",
                  size: 18.0,
                ),
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
                      backgroundImage:
                          pickedImage != null ? FileImage(pickedImage) : null,
                      child:
                          pickedImage == null
                              ? Image.asset(ImagePaths.compleateProfileIcon)
                              : null,
                    ),
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 3, color: AppColors.green),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: AppColors.green,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Full Name
                commonTextfield(fullNameController, hintText: "Full Name"),
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
                      hint: commonText(
                        "Gender",
                        size: 14.0,
                        color: Colors.grey,
                      ),
                      value: selectedGender,
                      items:
                          <String>["Male", "Female", "Other"]
                              .map(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: commonText(value, size: 14.0),
                                ),
                              )
                              .toList(),
                      onChanged: (newValue) {
                        ref.read(selectedGenderProvider.notifier).state =
                            newValue;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Phone
                commonTextfield(
                  phoneController,
                  hintText: "Phone",
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 30),

                // Continue Button
                
                    commonButton(
                      "Continue",
                      isLoading: authState.isLoading,
                      color: AppColors.green,
                      textColor: Colors.white,
                      onTap: () {
                        final fullName = fullNameController.text.trim();
                        final phone = phoneController.text.trim();
                        final gender = selectedGender;
                        final image = pickedImage;

                        if (fullName.isEmpty ||
                            phone.isEmpty ||
                            gender == null) {
                          showSnackBar(
                            context: context,
                            message:
                                "Please fill all fields",
                            title: "Incomplete",
                          );
                          return;
                        }

                        // Call API
                        ref
                            .read(authNotifierProvider.notifier)
                            .completeProfile(
                              fullName: fullName,
                              phone: phone,
                              gender: gender.toLowerCase(),
                              image: image,
                            );
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
