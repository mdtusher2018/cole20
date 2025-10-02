import 'package:flutter/material.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/core/commonWidgets.dart';

class StatisticsScreen extends StatelessWidget {
  final Map<String, double> monthlyData = {
    "January": 75,
    "February": 90,
    "March": 86,
    "April": 50,
    "May": 68,
    "June": 80,
    "July": 100,
    "August": 88,
  };

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
        title: commonText("Statistic",
            size: 20, isBold: true, color: AppColors.white),
        centerTitle: true,
      ),
      bottomSheet: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              children: [
                // Year Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.arrow_left, color: AppColors.green),
                      onPressed: () {
                        // Handle previous year action
                      },
                    ),
                    commonText("2019",
                        size: 18, isBold: true, color: AppColors.green),
                    IconButton(
                      icon:
                          const Icon(Icons.arrow_right, color: AppColors.green),
                      onPressed: () {
                        // Handle next year action
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Total and Completed Tasks
                Row(
                  children: [
                    _buildTaskSummaryCard("Total Tasks", "846"),
                    const SizedBox(width: 16),
                    _buildTaskSummaryCard("Completed Tasks", "625"),
                  ],
                ),
                const SizedBox(height: 20),

                // Monthly Completion Circles
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: monthlyData.length,
                  itemBuilder: (context, index) {
                    String month = monthlyData.keys.elementAt(index);
                    double percentage = monthlyData[month]!;
                    return _buildMonthlyProgressCard(month, percentage);
                  },
                ),
              ],
            ),
            Positioned(
                right: 8,
                top: 8,
                child: Image.asset(
                  "assets/share.png",
                  color: AppColors.black,
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildTaskSummaryCard(String title, String count) {
    return Expanded(
      child: Card(
        color: AppColors.white,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              commonText(title, size: 16, color: Colors.grey.shade700),
              const SizedBox(height: 8),
              commonText(count, size: 24, isBold: true, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyProgressCard(String month, double percentage) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        commonText(month, size: 16),
        const SizedBox(height: 20),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(
                value: percentage / 100,
                strokeWidth: 16,
                backgroundColor: Colors.grey.shade300,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.green),
              ),
            ),
            commonText("${percentage.toInt()}%",
                size: 14, isBold: true, color: Colors.black),
          ],
        ),
      ],
    );
  }
}
