import 'dart:developer';
import 'dart:io';
import 'package:cole20/core/colors.dart';
import 'package:cole20/core/commonWidgets.dart';
import 'package:cole20/core/providers.dart';
import 'package:cole20/features/profile/application/profile_state.dart';
import 'package:cole20/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

/// Local providers for UI-only states (not global app state)
final selectedGenderProvider = StateProvider<String?>((ref) => null);
final pickedImageProvider = StateProvider<File?>((ref) => null);

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController fullNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController genderController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileNotifierProvider).profile;

    fullNameController = TextEditingController(text: profile?.fullName ?? "");
    emailController = TextEditingController(text: profile?.email ?? "");
    phoneController = TextEditingController(text: profile?.phone ?? "");
    genderController = TextEditingController(
      text: profile?.gender?.capitalize() ?? "",
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    genderController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    log("message");
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ref.read(pickedImageProvider.notifier).state = File(image.path);
      log("message1");
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final pickedImage = ref.watch(pickedImageProvider);
    final imageUrl =
        profileState.profile?.profileImage != null &&
                profileState.profile!.profileImage!.isNotEmpty
            ? getFullImagePath(profileState.profile!.profileImage!)
            : "https://www.w3schools.com/howto/img_avatar.png";

ref.listen<ProfileState>(profileNotifierProvider, (previous, next) {
      if (next.errorMessage != null && next.status == ProfileStatus.error) {
        showSnackBar(
          context: context,
          title: "Error",
          message: next.errorMessage!,
        );
      } else if (previous?.status == ProfileStatus.updating &&
          next.status == ProfileStatus.loaded) {
        showSnackBar(
          context: context,
          title: "Success",
          message: "Profile updated successfully",
          backgroundColor: Colors.green,
        );
      }
    });



    return Scaffold(
      backgroundColor: AppColors.green,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: commonText(
          "My Profile",
          size: 20,
          isBold: true,
          color: AppColors.white,
        ),
        centerTitle: true,
      ),
      bottomSheet:
          profileState.isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    // Profile Image
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              pickedImage != null
                                  ? FileImage(pickedImage) as ImageProvider
                                  : NetworkImage(imageUrl),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                border: Border.all(
                                  width: 3,
                                  color: AppColors.berry,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: AppColors.berry,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    commonTextfield(fullNameController, hintText: "Full Name"),
                    const SizedBox(height: 15),
                    commonTextfield(
                      emailController,
                      hintText: "Email",
                      isEnable: false,
                    ),
                    const SizedBox(height: 15),
                    commonTextfield(
                      phoneController,
                      hintText: "Phone",
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 15),

                    // Gender Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonFormField<String>(
                        value:
                            genderController.text.isNotEmpty
                                ? genderController.text
                                : null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        hint: commonText(
                          "Gender",
                          size: 14,
                          color: AppColors.black.withOpacity(0.6),
                        ),
                        items:
                            ["Male", "Female", "Other"]
                                .map(
                                  (gender) => DropdownMenuItem(
                                    value: gender,
                                    child: commonText(gender, size: 14),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          genderController.text = value ?? "";
                          setState(
                            () {},
                          ); // optional to refresh dropdown display
                        },
                      ),
                    ),
                    const SizedBox(height: 40),

                    commonButton(
                      "Save",
                      color: AppColors.green,
                      isLoading: profileState.isUpdating,
                      textColor: AppColors.white,
                      onTap: () async {
                        await ref
                            .read(profileNotifierProvider.notifier)
                            .updateProfile(
                              fullName: fullNameController.text.trim(),
                              phone: phoneController.text.trim(),
                              gender:
                                  genderController.text.trim().toLowerCase(),
                                  image: pickedImage
                            );
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
    );
  }
}

// Helper
extension StringExtension on String {
  String capitalize() =>
      isEmpty ? this : "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
}
