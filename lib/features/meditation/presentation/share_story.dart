import 'package:flutter/material.dart';
import 'package:cole20/core/colors.dart'; // Assuming this is where you define your color constants
import 'package:cole20/core/commonWidgets.dart'; // Assuming this is where the commonText is defined

class ShareStory extends StatelessWidget {
  const ShareStory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.popUntil(
                context,
                (route) => route.isFirst,
              );
            }),
        actions: [
          IconButton(
              icon:
                  const Icon(Icons.file_download_outlined, color: Colors.black),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset(
              "assets/logo.png",
              scale: 1.5,
            ),
            commonText('45 cole20', size: 21, color: AppColors.gold),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white, // Background color of the grid container
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.green, width: 2), // Border color and width
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                      image: DecorationImage(
                        image: AssetImage("assets/calender_background.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: commonText("Day 9",
                            size: 50, color: AppColors.white)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GridView.count(
                    crossAxisCount: 7,
                    childAspectRatio: 1.5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(45, (index) {
                      return Center(
                        child: Container(
                          child: commonText('${index + 1}',
                              size: 18, color: AppColors.black, isBold: true),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  commonText(
                    "Today’s Accomplishments",
                    size: 21,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  accomplishmentItem(
                      'Thought Journal',
                      'Other Mental Ritual',
                      Image.asset(
                        "assets/MentalIcon 1.png",
                        color: AppColors.berry,
                        scale: 2,
                      ),
                      AppColors.berry),
                  accomplishmentItem(
                      'Meditation',
                      'Pray',
                      Image.asset(
                        "assets/SpiritualIcon 1.png",
                        color: AppColors.gold,
                        scale: 2,
                      ),
                      AppColors.gold),
                  accomplishmentItem(
                      'Yoga',
                      'Other Physical Ritual',
                      Image.asset(
                        "assets/PhysicalIcon 1.png",
                        color: AppColors.green,
                        scale: 2,
                      ),
                      AppColors.green),
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: AppColors.black),
                      borderRadius: BorderRadius.circular(20)),
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  child: LinearProgressIndicator(
                    value: 0.2,
                    minHeight: 16,
                    borderRadius: BorderRadius.circular(16),
                    backgroundColor: AppColors.white,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.green),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 2,
                  child: commonText(
                    '20% Completed',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.green),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/instragram.png"),
                    const SizedBox(width: 16),
                    commonText("Create Instagram Story",
                        size: 16, color: AppColors.white)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40)
          ],
        ),
      ),
    );
  }

  Widget accomplishmentItem(
      String text1, String text2, Widget icon, Color color) {
    return Row(
      children: [
        Expanded(
            child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: icon,
            ),
            commonText(text1, color: color),
          ],
        )),
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: icon,
            ),
            commonText(text2, color: color),
          ],
        ))
      ],
    );
  }
}
