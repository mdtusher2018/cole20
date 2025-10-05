import 'package:cole20/core/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/core/commonWidgets.dart';
import 'package:cole20/features/meditation/presentation/meditation_timer_page.dart';
import 'package:cole20/features/meditation/presentation/share_story.dart';
import 'package:cole20/features/home/presentation/root_page.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  // 🔹 static selected index persists across navigation
  static int? selectedIndex;

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  final ScrollController _scrollController = ScrollController();

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 🔹 If static index is not yet set, fetch current day from API
      if (CalendarScreen.selectedIndex == null) {
        final notifier = ref.read(homePageNotifierProvider(0).notifier);
        final today = await notifier.fetchCurrentDay() ?? 0;

        if (today != 0) {
          setState(() {
            CalendarScreen.selectedIndex =
                today - 1; // adjust for zero-based index
          });

          // 🔹 Now fetch rituals for that day
          await notifier.fetchRituals(day: today);
        }
      } else {
        // 🔹 Already has a selected index -> fetch rituals directly
        ref
            .read(
              homePageNotifierProvider(
                (CalendarScreen.selectedIndex ?? 0) + 1,
              ).notifier,
            )
            .fetchRituals(day: (CalendarScreen.selectedIndex ?? 0) + 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ritualState = ref.watch(
      homePageNotifierProvider((CalendarScreen.selectedIndex ?? 0) + 1),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                commonText("Today", size: 14),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => createBottomSheet(context),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: AppColors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        commonText("Share your progress"),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.screen_share_outlined,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            commonText(
              DateFormat("EEEE, d MMM yyyy").format(DateTime.now()),
              size: 20,
            ),
          ],
        ),
      ),
      body:
          ritualState.isLoading && ritualState.categories.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 80,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: _scrollLeft,
                            child: const Icon(Icons.arrow_back_ios_new),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              itemCount: 45,
                              itemBuilder: (context, index) {
                                return _buildDayItem(
                                  (index + 1).toString(),
                                  isSelected:
                                      index == CalendarScreen.selectedIndex,
                                  onTap: () {
                                    setState(() {
                                      CalendarScreen.selectedIndex = index;
                                    });
                                    ref
                                        .read(
                                          homePageNotifierProvider(
                                            index + 1,
                                          ).notifier,
                                        )
                                        .fetchRituals(day: index + 1);
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: _scrollRight,
                            child: const Icon(Icons.arrow_forward_ios_outlined),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: commonText("Your Rituals", size: 20),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ritualState.hasError
                        ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: commonText(
                              ritualState.errorMessage ??
                                  "Failed to load rituals",
                              size: 18,
                              isBold: true,
                            ),
                          ),
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              ritualState.categories.map((category) {
                                final color = _hexToColor(category.colorCode);
                                return _buildCategoryTasks(
                                  categoryName: category.categoryName,
                                  color: color,
                                  tasks:
                                      category.rituals.map((ritual) {
                                          return _buildTaskItem(
                                            ritual.title,
                                            Icon(
                                              Icons.access_time_filled,
                                              color: AppColors.white,
                                            ),
                                            color,
                                            () {
                                              slideNavigationPushAndRemoveUntil(
                                                MeditationTimerPage(),
                                                onlypush: true,
                                                context,
                                              );
                                            },
                                          );
                                        }).toList()
                                        ..add(
                                          _buildAddTaskButton(color, () {
                                            RootPage.selectedIndex = 2;
                                            slideNavigationPushAndRemoveUntil(
                                              const RootPage(),
                                              context,
                                            );
                                          }),
                                        ),
                                );
                              }).toList(),
                        ),
                  ],
                ),
              ),
    );
  }

  Widget _buildDayItem(
    String day, {
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: isSelected ? 3 : 1,
              color: AppColors.black,
            ),
          ),
          child: Center(
            child: Column(
              children: [
                commonText(
                  "Day",
                  size: 16,
                  color: AppColors.black,
                  isBold: isSelected,
                ),
                commonText(
                  day,
                  size: 16,
                  color: AppColors.black,
                  isBold: isSelected,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTasks({
    required String categoryName,
    required Color color,
    required List<Widget> tasks,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonText(categoryName, size: 18),
        const SizedBox(height: 10),
        ...tasks,
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTaskItem(
    String taskName,
    Widget icon,
    Color color,
    VoidCallback ontap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
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
        onTap: ontap,
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            Expanded(
              child: commonText(taskName, size: 16, color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddTaskButton(Color color, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            const Icon(Icons.add, color: AppColors.white),
            const SizedBox(width: 10),
            commonText("Add Rituals", size: 16, color: AppColors.white),
          ],
        ),
      ),
    );
  }

  Widget createBottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
            child: commonText(
              'Congratulations!!',
              size: 16,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: commonText(
              'Your 45 days journey is completed!!',
              size: 16,
              textAlign: TextAlign.center,
            ),
          ),
          InkWell(
            onTap: () {
              slideNavigationPushAndRemoveUntil(
                ShareStory(),
                onlypush: true,
                context,
              );
            },
            child: Container(
              height: 50,
              width: MediaQuery.sizeOf(context).width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.green,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/instragram.png"),
                  const SizedBox(width: 16),
                  commonText(
                    "Create Instagram Story",
                    size: 16,
                    color: AppColors.white,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Color _hexToColor(String hex) {
    final cleanHex = hex.replaceAll("#", "");
    return Color(int.parse("FF$cleanHex", radix: 16));
  }
}
