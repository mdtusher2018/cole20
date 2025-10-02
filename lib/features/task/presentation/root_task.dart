import 'package:flutter/material.dart';
import 'package:cole20/features/task/presentation/add_task.dart';
import 'package:cole20/core/commonWidgets.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/features/meditation/presentation/meditation_timer_page.dart';

class RootTaskScreen extends StatefulWidget {
  const RootTaskScreen({Key? key}) : super(key: key);

  @override
  State<RootTaskScreen> createState() => _RootTaskScreenState();
}

class _RootTaskScreenState extends State<RootTaskScreen> {
  // Track the selected state of tasks
  Map<String, bool> taskSelections = {
    "Thought Journal (15 Min)": true,
    "Mental Exercise (10 Min)": false,
    "Yoga": true,
    "Push-up": false,
    "Pray": false,
    "Meditation (10 Min)": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        centerTitle: true,
        title: commonText("Available Rituals",
            size: 20, isBold: true, color: AppColors.black),
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
                    AddTaskScreen(), onlypush: true, context);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: AppColors.black),
                    const SizedBox(width: 10),
                    commonText("Add Your own ritual",
                        size: 16, color: AppColors.black),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryTasks(
                  category: "Mental",
                  color: AppColors.berry,
                  tasks: [
                    _buildTaskItem(
                        "Thought Journal (15 Min)",
                        Icon(Icons.access_time_filled, color: AppColors.white),
                        AppColors.berry, () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MeditationTimerPage();
                      }));
                    }),
                    _buildTaskItem(
                        "Mental Exercise (10 Min)",
                        Icon(Icons.access_time_filled, color: AppColors.white),
                        AppColors.berry, () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MeditationTimerPage();
                      }));
                    }),
                  ],
                ),
                _buildCategoryTasks(
                  category: "Physical",
                  color: AppColors.green,
                  tasks: [
                    _buildTaskItem(
                        "Yoga",
                        Image.asset("assets/images/yoga.png"),
                        AppColors.green, () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MeditationTimerPage();
                      }));
                    }),
                    _buildTaskItem(
                        "Push up",
                        Image.asset("assets/images/pushup.png"),
                        AppColors.green, () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MeditationTimerPage();
                      }));
                    }),
                  ],
                ),
                _buildCategoryTasks(
                  category: "Spiritual",
                  color: AppColors.gold,
                  tasks: [
                    _buildTaskItem(
                        "Pray",
                        Image.asset("assets/images/pray.png"),
                        AppColors.gold, () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MeditationTimerPage();
                      }));
                    }),
                    _buildTaskItem(
                        "Meditation (10 Min)",
                        Icon(
                          Icons.access_time_filled,
                          color: AppColors.white,
                        ),
                        AppColors.gold, () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MeditationTimerPage();
                      }));
                    }),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTasks({
    required String category,
    required Color color,
    required List<Widget> tasks,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [commonText(category, size: 18), commonText("See all")],
        ),
        const SizedBox(height: 10),
        ...tasks,
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTaskItem(String taskName, Widget icon, Color color, ontap) {
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
                child: commonText(taskName, size: 16, color: AppColors.white)),
          ],
        ),
      ),
    );
  }
}
