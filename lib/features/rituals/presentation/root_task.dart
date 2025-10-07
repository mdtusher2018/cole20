import 'package:cole20/features/rituals/application/homepage_state.dart';
import 'package:cole20/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/core/commonWidgets.dart';
import 'package:cole20/features/rituals/domain/ritual_category_model.dart';
import 'package:cole20/core/providers.dart';
import 'package:cole20/features/rituals/presentation/add_ritual.dart';
import 'package:cole20/features/meditation/presentation/meditation_timer_page.dart';

class RootTaskScreen extends ConsumerStatefulWidget {
  const RootTaskScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RootTaskScreen> createState() => _RootTaskScreenState();
}

class _RootTaskScreenState extends ConsumerState<RootTaskScreen> {
  int? currentDay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notifier = ref.read(homePageNotifierProvider(0).notifier);
      final today = await notifier.fetchCurrentDay() ?? 1;

      setState(() => currentDay = today);

      await ref
          .read(homePageNotifierProvider(today).notifier)
          .fetchRituals(day: today);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentDay == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final ritualState = ref.watch(homePageNotifierProvider(currentDay!));

    if (ritualState.isLoading && ritualState.categories.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final categories = ritualState.categories;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        centerTitle: true,
        title: commonText(
          "Available Rituals",
          size: 20,
          isBold: true,
          color: AppColors.black,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add Your Own Task Button
            GestureDetector(
              onTap: () {
                slideNavigationPushAndRemoveUntil(
                  AddRitualScreen(currentDay: ritualState.today,),
                  onlypush: true,
                  context,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: AppColors.black),
                    const SizedBox(width: 10),
                    commonText(
                      "Add your own ritual",
                      size: 16,
                      color: AppColors.black,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Dynamically render each category
            ListView.builder(
              itemCount: categories.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              itemBuilder: (context, index) {
                final category = categories[index];
                return _buildCategoryTasks(category,ritualState);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTasks(RitualCategory category,HomepageState state) {
    final color = _hexToColor(category.colorCode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            commonText(category.categoryName, size: 18),
            // commonText("See all", color: AppColors.black.withOpacity(0.7)),
          ],
        ),

        // Rituals
        ...category.rituals.map((r) {
          return _buildTaskItem(
            r.title,
            r.duration != null
                ? const Icon(Icons.access_time_filled, color: AppColors.white)
                : Image.network(
                  getFullImagePath(category.icon),
                  errorBuilder:
                      (context, error, stackTrace) => Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                ),
            color,
            () {
              slideNavigationPushAndRemoveUntil(
                MeditationTimerPage(ritual: r,currentDay: state.today,),
                onlypush: true,
                context,
              );
            },
          );
        }),

        // Add Rituals if less than 2
        // if (category.rituals.length < 2)
        //   _buildTaskItem(
        //     "Add Rituals",
        //     const Icon(Icons.add, color: AppColors.white),
        //     color,
        //     () {
        //       slideNavigationPushAndRemoveUntil(AddTaskScreen(),
        //           onlypush: true, context);
        //     },
        //   ),
        const SizedBox(height: 10),
        // Progress bar
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(10),
        //   child: LinearProgressIndicator(
        //     value: total == 0 ? 0 : completed / total,
        //     backgroundColor: Colors.grey.shade300,
        //     color: color,
        //     minHeight: 8,
        //   ),
        // ),
      ],
    );
  }

  Widget _buildTaskItem(
    String taskName,
    Widget icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray.withOpacity(0.2),
            blurRadius: 5.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            Expanded(
              child: commonText(
                taskName,
                size: 16,
                color: AppColors.white,
                isBold: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    final cleanHex = hex.replaceAll("#", "");
    return Color(int.parse("FF$cleanHex", radix: 16));
  }
}
