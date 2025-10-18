import 'package:cole20/features/rituals/application/homepage_state.dart';
import 'package:cole20/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/core/commonWidgets.dart';
import 'package:cole20/features/rituals/presentation/root_page.dart';
import 'package:cole20/features/meditation/presentation/meditation_timer_page.dart';
import 'package:cole20/features/meditation/presentation/notifications_screen.dart';
import 'package:cole20/features/rituals/domain/ritual_category_model.dart';
import 'package:cole20/core/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  int? currentDay;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notifier = ref.read(homePageNotifierProvider(0).notifier);
      final today = await notifier.fetchCurrentDay() ?? 1;

      setState(() {
        currentDay = today;
      });

      await ref
          .read(homePageNotifierProvider(today).notifier)
          .fetchRituals(day: today);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentDay == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final ritualState = ref.watch(homePageNotifierProvider(currentDay!));
    final ritualController = ref.read(
      homePageNotifierProvider(currentDay!).notifier,
    );

    final isFirstLoad = ritualState.isLoading && ritualState.categories.isEmpty;

    if (isFirstLoad) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final categories = ritualState.categories;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 24),
          ListTile(
            title: Row(
              children: [
                Image.asset("assets/logo.png", width: 30, height: 30),
                commonText(" 45 cole20", size: 18.0, color: AppColors.gold),
              ],
            ),
            subtitle: FutureBuilder<String>(
              future: ritualController.fetchName(), // async call
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return commonText("Loading...", size: 14.0);
                }

                final fullName = snapshot.data ?? "User";
                return commonText("Good Morning, $fullName!", size: 14.0);
              },
            ),

            trailing: InkWell(
              onTap: () {
                slideNavigationPushAndRemoveUntil(
                  const NotificationScreen(),
                  onlypush: true,
                  context,
                );
              },
              child:
                  ritualState.unreadNotification > 0
                      ? Icon(Icons.notifications_active)
                      : Icon(
                        Icons.notifications,
                        color: Colors.amberAccent,
                        size: 32,
                      ),
            ),
          ),
          Divider(color: AppColors.black.withOpacity(0.5)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10,
              ),
              child: ListView(
                padding: EdgeInsets.all(0),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      commonText("Today's Rituals", size: 18.0, isBold: true),
                      commonButton(
                        "Day ${currentDay}",
                        color: AppColors.gray,
                        textColor: AppColors.black,
                        width: 80,
                        height: 30,
                        textSize: 14,
                      ),
                    ],
                  ),

                  ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 21);
                    },
                    padding: EdgeInsets.symmetric(vertical: 16),
                    itemCount: categories.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return buildCategorySection(
                        categories[index],
                        ritualState,
                      );
                    },
                  ),

                  Center(
                    child: InkWell(
                      onTap: () {
                        RootPage.selectedIndex = 2;
                        slideNavigationPushAndRemoveUntil(RootPage(), context);
                      },
                      child: commonText("See All Available Rituals", size: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ).withRefresh(() async {
                ritualController.fetchCurrentDay().then((value) {
                  ritualController.fetchRituals(
                    day: value ?? 0,
                    hardRefresh: true,
                  );
                });
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategorySection(RitualCategory category, HomepageState state) {
    final color = hexToColor(category.colorCode);
    int completedCount =
        category.rituals.where((r) => r.isComplete).length; // progress
    int totalCount = category.rituals.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Image.network(
                    getFullImagePath(category.icon),
width: 32,
                    errorBuilder:
                        (context, error, stackTrace) => Icon(
                          Icons.broken_image_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                  ),
                  const SizedBox(width: 8),
                  commonText(
                    category.categoryName,
                    size: 18,
                    color: AppColors.white,
                    isBold: true,
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: commonText(
                      "$completedCount/$totalCount",
                      color: AppColors.white,
                      size: 14,
                      isBold: true,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: totalCount == 0 ? 0 : completedCount / totalCount,
                  backgroundColor: Colors.white.withOpacity(0.5),
                  minHeight: 8,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        const SizedBox(height: 8),
        for (var ritual in category.rituals)
          InkWell(
            onTap: () {
              slideNavigationPushAndRemoveUntil(
                MeditationTimerPage(ritual: ritual, currentDay: currentDay??1),
                onlypush: true,
                context,
              );
            },
            child: taskItem(
              ritual.title,
              (ritual.duration != null) ? Icons.access_time_filled : null,
              ischecked: ritual.isComplete,
              color: color,
            ),
          ),
        if (category.rituals.length < 2)
          InkWell(
            onTap: () {
              RootPage.selectedIndex = 2;
              slideNavigationPushAndRemoveUntil(RootPage(), context);
            },
            child: taskItem("Add Rituals", null, addbutton: true, color: color),
          ),
      ],
    );
  }

  Widget taskItem(
    String title,
    IconData? icon, {
    bool addbutton = false,
    bool ischecked = false,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              addbutton
                  ? Icon(Icons.add, color: color)
                  : Icon(
                    (ischecked)
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: color,
                  ),
              const SizedBox(width: 8),
              commonText(title, color: color, size: 12),
            ],
          ),
          icon != null ? Icon(icon, color: color) : const SizedBox(),
        ],
      ),
    );
  }


}
