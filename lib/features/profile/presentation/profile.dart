import 'package:cole20/core/providers.dart';
import 'package:cole20/features/auth/presentation/signin.dart';
import 'package:cole20/features/profile/application/profile_state.dart';
import 'package:cole20/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:cole20/core/commonWidgets.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/features/profile/presentation/edit_profile.dart';
import 'package:cole20/features/profile/presentation/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // ✅ Fetch profile when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);

    ref.listenManual(profileNotifierProvider, (previous, next) {});

    ref.listen<ProfileState>(profileNotifierProvider, (previous, next) {
      if (next.hasError) {
        showSnackBar(
          context: context,
          message: next.errorMessage ?? "Failed to fetch profile",
          title: "Error",
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.green,
      body:
          profileState.isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : _buildProfileContent(context, ref, profileState),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    WidgetRef ref,
    ProfileState state,
  ) {
    final user = state.profile;
    final name = user?.fullName ?? "User Name";
    final email = user?.email ?? "N/A";
    final imageUrl =
        user?.profileImage != null && user!.profileImage!.isNotEmpty
            ? getFullImagePath(user.profileImage!)
            : "https://www.w3schools.com/howto/img_avatar.png";

    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            height: MediaQuery.sizeOf(context).height * 0.8,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 16),
                children: [
                  // Profile Card
                  state.hasError
                      ? Center(
                        child: commonText(
                          state.errorMessage ?? "Something went wrong",
                          size: 16,
                          color: Colors.white,
                        ),
                      )
                      : Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            commonText(
                              name,
                              size: 18,
                              isBold: true,
                              color: AppColors.green,
                            ),
                            const SizedBox(height: 5),
                            commonText(
                              email,
                              size: 14,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(height: 15),
              
                            // Fake Task Stats
                            commonText(
                              "Task Completed",
                              size: 16,
                              isBold: true,
                              color: AppColors.black,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...state.ritualProgress.map((category) {
                                  return _buildStatCard(
                                    category.completedRituals.toString(),
                                    category.categoryName,
                                    hexToColor(category.colorCode),
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
              
                  // Menu Section
                  Column(
                    children: [
                      _buildMenuItem(
                        icon: Image.asset(
                          "assets/images/profile.png",
                          width: 24,
                          color: AppColors.green,
                        ),
                        title: "My Profile",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(),
                            ),
                          );
                        },
                      ),
                      // _buildMenuItem(
                      //   icon: Image.asset(
                      //     "assets/images/Chart.png",
                      //     width: 24,
                      //     color: AppColors.green,
                      //   ),
                      //   title: "Statistic",
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => StatisticsScreen(),
                      //       ),
                      //     );
                      //   },
                      // ),
                      _buildMenuItem(
                        icon: Image.asset(
                          "assets/images/Setting.png",
                          width: 24,
                          color: AppColors.green,
                        ),
                        title: "Settings",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      _buildMenuItem(
                        icon: Image.asset(
                          "assets/images/Logout.png",
                          width: 24,
                          color: AppColors.green,
                        ),
                        title: "Logout",
                        onTap: () {
                          showLogoutDialog(context, () async {
                            slideNavigationPushAndRemoveUntil(
                              SignInScreen(),
                              context,
                            );
                            await ref
                                .read(authNotifierProvider.notifier)
                                .signout(ref);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ).withRefresh(() async{
                  ref.read(profileNotifierProvider.notifier).fetchProfile();
                },),
            ),
          ),

          // Profile Avatar (top circle)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                elevation: 8,
                shape: const CircleBorder(),
                shadowColor: Colors.black87,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String number, String title, Color color) {
    return Expanded(
      child: Column(
        children: [
          commonText(number, size: 16, isBold: true),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: commonText(title, size: 14, color: AppColors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required Widget icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            commonText(title, size: 16, color: AppColors.black),
          ],
        ),
      ),
    );
  }

  Future<void> showLogoutDialog(
    BuildContext context,
    VoidCallback onLogout,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: commonText("Do you want to Logout?", size: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: commonButton(
                    "Cancel",
                    color: Colors.grey.shade300,
                    textColor: Colors.black,
                    height: 40,
                    width: 100,
                    onTap: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: commonButton(
                    "Logout",
                    color: AppColors.goldShades[600]!,
                    textColor: Colors.white,
                    height: 40,
                    width: 100,
                    onTap: () {
                      Navigator.of(context).pop(); // Close the dialog
                      onLogout(); // Perform the delete action
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
