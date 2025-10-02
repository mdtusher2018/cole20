import 'package:flutter/material.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/core/commonWidgets.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: commonText(
          "Notifications",
          size: 21,
          isBold: true,
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return _buildNotificationItem(
            message: "Don’t you want to take any Ritual today??",
            timeAgo: "16 minutes ago",
            isHighlighted: index == 0, // Highlight the first item
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem({
    required String message,
    required String timeAgo,
    bool isHighlighted = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isHighlighted ? Color(0x0ff7E9B8C) : AppColors.white,
        border: Border.all(
          color: isHighlighted ? Color(0x0ff7E9B8C) : Colors.transparent,
          width: isHighlighted ? 1 : 0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/notification.png"),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonText(
                  message,
                  size: 16,
                ),
                const SizedBox(height: 4),
                commonText(
                  timeAgo,
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
