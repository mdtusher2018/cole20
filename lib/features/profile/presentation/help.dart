import 'package:flutter/material.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/core/commonWidgets.dart';

class HelpScreen extends StatelessWidget {
  final TextEditingController messageController = TextEditingController();

  HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: commonText(
          "Help",
          size: 20,
          isBold: true,
          color: AppColors.white,
        ),
        centerTitle: true,
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            commonText("Tell us how can we help",
                size: 16, isBold: true, color: AppColors.green),
            const SizedBox(height: 20),

            // Text Input Box
            Container(
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.green),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: messageController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Type some message.......",
                  hintStyle: TextStyle(color: Colors.grey,
                    fontFamily: 'TenorSans',
                  ),
                ),
              ),
            ),
            const Spacer(),

            // Send Button
            commonButton(
              "Send",
              color: AppColors.green,
              textColor: AppColors.white,
              onTap: () {
                // Handle message submission
                print("Message sent: ${messageController.text}");
              },
            ),
          ],
        ),
      ),
    );
  }
}
