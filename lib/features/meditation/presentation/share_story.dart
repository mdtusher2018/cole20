import 'dart:io';

import 'package:cole20/features/rituals/domain/ritual_category_model.dart';
import 'package:cole20/utils/helpers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cole20/core/colors.dart'; // Assuming this is where you define your color constants
import 'package:cole20/core/commonWidgets.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart'; // Assuming this is where the commonText is defined

class ShareStory extends StatelessWidget {
  final List<RitualCategory> todayRituals;
  final int today;

  ShareStory({super.key, required this.todayRituals, required this.today});

  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final completedRituals =
        todayRituals
            .expand(
              (category) => category.rituals
                  .where((ritual) => ritual.isComplete)
                  .map((ritual) => MapEntry(category, ritual)),
            )
            .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: Colors.black),
            onPressed: () {
              _captureAndSave(context, _screenshotController);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Screenshot(
              controller: _screenshotController,
              child: Container(
                color: AppColors.white,
                child: Column(
                  children: <Widget>[
                    Image.asset("assets/logo.png", scale: 1.5),
                    commonText('45 cole20', size: 21, color: AppColors.gold),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color:
                            Colors
                                .white, // Background color of the grid container
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.green,
                          width: 2,
                        ), // Border color and width
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
                                topRight: Radius.circular(8),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/calender_background.png",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: commonText(
                                "Day $today",
                                size: 50,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          GridView.count(
                            crossAxisCount: 7,
                            childAspectRatio: 1.5,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(45, (index) {
                              return Center(
                                child: Container(
                                  child: commonText(
                                    '${index + 1}',
                                    size: 18,
                                    color:
                                        index + 1 <= today
                                            ? AppColors.black
                                            : AppColors.gray,
                                    isBold: true,
                                  ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (completedRituals.isNotEmpty)
                            commonText("Today’s Accomplishments", size: 21),
                          const SizedBox(height: 10),

                          // Dynamic GridView for accomplishments
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 10,
                                ),
                            itemCount: completedRituals.length,
                            itemBuilder: (context, index) {
                              final entry = completedRituals[index];
                              final category = entry.key;
                              final ritual = entry.value;

                              return accomplishmentItem(
                                ritual.title,
                                Image.network(
                                  getFullImagePath(category.icon),
                                  color: hexToColor(category.colorCode),
                                  colorBlendMode: BlendMode.color,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.broken_image_outlined,
                                            size: 18,
                                          ),
                                  width: 16,
                                  height: 16,
                                ),
                                hexToColor(category.colorCode),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: AppColors.black,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: MediaQuery.sizeOf(context).width * 0.8,
                          child: LinearProgressIndicator(
                            value: (today / 45.0),
                            minHeight: 16,
                            borderRadius: BorderRadius.circular(16),
                            backgroundColor: AppColors.white,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.green,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 2,
                          child: commonText(
                            '${((today / 45.0) * 100).toStringAsFixed(0)}% Completed',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: _captureAndShare,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
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
      ),
    );
  }

  Future<void> _captureAndSave(
    BuildContext context,
    ScreenshotController _screenshotController,
  ) async {
    try {
      // 🟩 Capture the widget
      final image = await _screenshotController.capture();
      if (image == null) return;

      // 🟦 Ask user to pick a folder
      final selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('❌ No folder selected')));
        return;
      }

      // 🟧 Save the image to the chosen folder
      final filePath =
          '$selectedDirectory/cole20_story_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(image);

      // 🟩 Notify user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Saved to: $filePath'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      debugPrint("❌ Error saving screenshot: $e");
      showSnackBar(
        context: context,
        title: "Error",
        message: "Error saving image: $e",
      );
    }
  }

  Future<void> _captureAndShare() async {
    try {
      final image = await _screenshotController.capture();
      if (image == null) return;

      final tempDir = Directory.systemTemp;
      final file = await File('${tempDir.path}/story.png').create();
      await file.writeAsBytes(image);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: "Check out my Cole20 story!");
    } catch (e) {
      debugPrint("Error capturing screenshot: $e");
    }
  }

  Widget accomplishmentItem(String text1, Widget icon, Color color) {
    return Row(
      children: [
        Padding(padding: const EdgeInsets.only(right: 8.0), child: icon),
        Flexible(child: commonText(text1, color: color, maxLine: 1)),
      ],
    );
  }
}
