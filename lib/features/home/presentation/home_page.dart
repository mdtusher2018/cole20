// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:cole20/core/colors.dart';
// import 'package:cole20/core/commonWidgets.dart';
// import 'package:cole20/features/meditation/presentation/notifications.dart';
// import 'package:cole20/features/home/presentation/root_page.dart';
// import 'package:lottie/lottie.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with SingleTickerProviderStateMixin {
//   // Maintain the state of each task (selected/unselected)
//   final Map<String, bool> availableTasks = {
//     "Work Out": true,
//     "Reading a Book": false,
//     "Meditation": true,
//     "Prayer": false,
//   };

//   late final AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this);
//     // Start repeating _handleTap every 5 seconds
//     Timer.periodic(Duration(seconds: 10), (timer) {
//       _handleTap();
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _handleTap() {
//     // Restart the animation on tap
//     _controller.reset();
//     _controller.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           SizedBox(
//             height: 16,
//           ),
//           ListTile(
//             title: Row(
//               children: [
//                 Image.asset(
//                   "assets/logo.png",
//                   width: 30,
//                   height: 30,
//                 ),
//                 commonText(" 45 cole20", size: 18.0, color: AppColors.gold),
//               ],
//             ),
//             subtitle: commonText(
//               "Good Morning, Sakib Al Hasan!",
//               size: 14.0,
//             ),
//             trailing: InkWell(
//                 onTap: () {
//                   slideNavigationPushAndRemoveUntil(
//                       const NotificationScreen(), onlypush: true, context);
//                 },
//                 child: Image.asset("assets/images/notification.png")),
//           ),
//           Divider(color: AppColors.black.withOpacity(0.5)),
//           Expanded(
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 20.0, vertical: 10),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             commonText("Today's Rituals",
//                                 size: 18.0, isBold: true),
//                             commonButton("Day 25",
//                                 color: AppColors.gray,
//                                 textColor: AppColors.black,
//                                 width: 80,
//                                 height: 30,
//                                 textSize: 14)
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         InkWell(onTap: () {}, child: mantalTaskWidget()),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         physicalTaskWidget(),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         spiritualTaskWidget(),
//                         const SizedBox(
//                           height: 8,
//                         ),
//                         Center(
//                             child: InkWell(
//                           onTap: () {
//                             RootPage.selectedIndex = 2;
//                             slideNavigationPushAndRemoveUntil(
//                                 RootPage(), context);
//                           },
//                           child:
//                               commonText("See All Available Rituals", size: 16),
//                         )),
//                         const SizedBox(
//                           height: 8,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 100,
//                   child: IgnorePointer(
//                     ignoring: true,
//                     child: SizedBox(
//                       width: 100,
//                       height: 100,
//                       child: FittedBox(
//                         child: Lottie.asset(
//                           'assets/animations/party.json',
//                           controller: _controller,
//                           fit: BoxFit.cover,
//                           onLoaded: (composition) {
//                             _controller
//                               ..duration = composition.duration
//                               ..stop(); // Start paused
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget mantalTaskWidget() {
//     int taskCompleted = 1; // Number of completed tasks
//     int totalTasks = 2; // Total number of tasks

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         InkWell(
//           onTap: _handleTap,
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: AppColors.berry, // Gold Color
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Image.asset(
//                           "assets/MentalIcon 1.png",
//                           scale: 0.9,
//                         ),
//                         const SizedBox(width: 8),
//                         commonText("Mental",
//                             size: 18, color: AppColors.white, isBold: true),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: commonText("$taskCompleted/$totalTasks",
//                       color: Colors.white, size: 14, isBold: true),
//                 ),
//                 const SizedBox(height: 4),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: LinearProgressIndicator(
//                     value: taskCompleted /
//                         totalTasks, // Dynamically update progress
//                     backgroundColor: Colors.white.withOpacity(0.5),
//                     minHeight: 8,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 8),
//         taskItem(
//           "Thought Journal (15 min)",
//           Icons.access_time_filled_sharp,
//           color: AppColors.berry,
//         ),
//         if (taskCompleted < totalTasks)
//           InkWell(
//             onTap: () {
//               RootPage.selectedIndex = 2;
//               slideNavigationPushAndRemoveUntil(RootPage(), context);
//             },
//             child: taskItem("Add Rituals", null,
//                 addbutton: true, color: AppColors.berry),
//           ),
//       ],
//     );
//   }

//   Widget spiritualTaskWidget() {
//     int taskCompleted = 2; // Number of completed tasks
//     int totalTasks = 2; // Total number of tasks

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: AppColors.gold, // Gold Color
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Image.asset(
//                         "assets/SpiritualIcon 1.png",
//                         scale: 0.9,
//                       ),
//                       const SizedBox(width: 8),
//                       commonText("Spiritual",
//                           size: 18, color: AppColors.white, isBold: true),
//                     ],
//                   ),
//                 ],
//               ),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: commonText("$taskCompleted/$totalTasks",
//                     color: Colors.white, size: 14, isBold: true),
//               ),
//               const SizedBox(height: 4),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: LinearProgressIndicator(
//                   value:
//                       taskCompleted / totalTasks, // Dynamically update progress
//                   backgroundColor: Colors.white.withOpacity(0.5),
//                   minHeight: 8,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         taskItem("Pray", null, color: AppColors.gold),
//         taskItem("Meditation (10 Min)", Icons.access_time_filled,
//             color: AppColors.gold),

//         // Show "Add Rituals" button only if progress is not full
//         if (taskCompleted < totalTasks)
//           InkWell(
//               onTap: () {
//                 RootPage.selectedIndex = 2;
//                 slideNavigationPushAndRemoveUntil(RootPage(), context);
//               },
//               child: taskItem("Add Rituals", null,
//                   addbutton: true, color: AppColors.gold)),
//       ],
//     );
//   }

//   Widget physicalTaskWidget() {
//     int taskCompleted = 0; // Number of completed tasks
//     int totalTasks = 2; // Total number of tasks

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: AppColors.green, // Gold Color
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Image.asset(
//                         "assets/PhysicalIcon 1.png",
//                         scale: 0.9,
//                       ),
//                       const SizedBox(width: 8),
//                       commonText("Physical",
//                           size: 18, color: AppColors.white, isBold: true),
//                     ],
//                   ),
//                 ],
//               ),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: commonText("$taskCompleted/$totalTasks",
//                     color: Colors.white, size: 14, isBold: true),
//               ),
//               const SizedBox(height: 4),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: LinearProgressIndicator(
//                   value:
//                       taskCompleted / totalTasks, // Dynamically update progress
//                   backgroundColor: Colors.white.withOpacity(0.5),
//                   minHeight: 8,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         taskItem(
//           "Yoga",
//           Icons.access_time_filled_sharp,
//           color: AppColors.green,
//         ),
//         if (taskCompleted < totalTasks)
//           InkWell(
//             onTap: () {
//               RootPage.selectedIndex = 2;
//               slideNavigationPushAndRemoveUntil(RootPage(), context);
//             },
//             child: taskItem("Add Rituals", null,
//                 addbutton: true, color: AppColors.green),
//           ),
//       ],
//     );
//   }

//   Widget taskItem(String title, IconData? icon,
//       {bool addbutton = false, required Color color}) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         border: Border.all(color: color),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               (addbutton)
//                   ? Icon(Icons.add, color: color)
//                   : Icon(Icons.check_box_outline_blank, color: color),
//               const SizedBox(width: 8),
//               commonText(title, color: color, size: 12),
//             ],
//           ),
//           icon != null
//               ? Icon(icon, color: color)
//               : const SizedBox(), // Hide icon if null
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/core/commonWidgets.dart';
import 'package:cole20/features/home/presentation/root_page.dart';
import 'package:cole20/features/meditation/presentation/meditation_timer_page.dart';
import 'package:cole20/features/meditation/presentation/notifications.dart';
import 'package:cole20/features/home/domain/ritual_category_model.dart';
import 'package:cole20/core/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notifier = ref.read(homePageNotifierProvider(0).notifier);
      await notifier.fetchCurrentDay(); // fetch today & rituals
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final ritualState = ref.watch(homePageNotifierProvider(0));

    bool isFirstLoad =
        ritualState.isLoading && (ritualState.categories.isEmpty);

    if (isFirstLoad) {
      return const Center(child: CircularProgressIndicator());
    }

    final categories = ritualState.categories;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 16),
          ListTile(
            title: Row(
              children: [
                Image.asset("assets/logo.png", width: 30, height: 30),
                commonText(" 45 cole20", size: 18.0, color: AppColors.gold),
              ],
            ),
            subtitle: commonText(
              "Good Morning, Sakib Al Hasan!",
              size: 14.0,
            ),
            trailing: InkWell(
              onTap: () {
                slideNavigationPushAndRemoveUntil(
                    const NotificationScreen(), onlypush: true, context);
              },
              child: Image.asset("assets/images/notification.png"),
            ),
          ),
          Divider(color: AppColors.black.withOpacity(0.5)),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            commonText("Today's Rituals",
                                size: 18.0, isBold: true),
                            commonButton(
                              "Day ${ritualState.today}",
                              color: AppColors.gray,
                              textColor: AppColors.black,
                              width: 80,
                              height: 30,
                              textSize: 14,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Mental Category
                        if (categories.any(
                            (c) => c.categoryName.toLowerCase() == "mental"))
                          buildCategorySection(categories
                              .firstWhere((c) =>
                                  c.categoryName.toLowerCase() == "mental")),
                        const SizedBox(height: 20),

                        // Physical Category
                        if (categories.any(
                            (c) => c.categoryName.toLowerCase() == "physical"))
                          buildCategorySection(categories
                              .firstWhere((c) =>
                                  c.categoryName.toLowerCase() == "physical")),
                        const SizedBox(height: 20),

                        // Spiritual Category
                        if (categories.any(
                            (c) => c.categoryName.toLowerCase() == "spiritual"))
                          buildCategorySection(categories
                              .firstWhere((c) =>
                                  c.categoryName.toLowerCase() == "spiritual")),
                        const SizedBox(height: 8),

                        Center(
                          child: InkWell(
                            onTap: () {
                              RootPage.selectedIndex = 2;
                              slideNavigationPushAndRemoveUntil(
                                  RootPage(), context);
                            },
                            child:
                                commonText("See All Available Rituals", size: 16),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategorySection(RitualCategory category) {
    final color = _hexToColor(category.colorCode);
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  commonText(category.categoryName,
                      size: 18, color: AppColors.white, isBold: true),
                  Align(
                    alignment: Alignment.centerRight,
                    child: commonText("$completedCount/$totalCount",
                        color: AppColors.white, size: 14, isBold: true),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: totalCount == 0 ? 0 : completedCount / totalCount,
                  backgroundColor: Colors.white.withOpacity(0.5),
                  minHeight: 8,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        for (var ritual in category.rituals)
          InkWell(
            onTap: () {
              slideNavigationPushAndRemoveUntil(
                  MeditationTimerPage(), onlypush: true, context);
            },
            child: taskItem(ritual.title, Icons.access_time_filled, color: color),
          ),
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

  Widget taskItem(String title, IconData? icon,
      {bool addbutton = false, required Color color}) {
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
                  : Icon(Icons.check_box_outline_blank, color: color),
              const SizedBox(width: 8),
              commonText(title, color: color, size: 12),
            ],
          ),
          icon != null ? Icon(icon, color: color) : const SizedBox(),
        ],
      ),
    );
  }

  Color _hexToColor(String hex) {
    final cleanHex = hex.replaceAll("#", "");
    return Color(int.parse("FF$cleanHex", radix: 16));
  }
}
