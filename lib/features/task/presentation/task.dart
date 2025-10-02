import 'package:flutter/material.dart';
import 'package:cole20/features/task/presentation/edit_task.dart';
import 'package:intl/intl.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/core/commonWidgets.dart';

class TaskDetailScreen extends StatelessWidget {
  final TextEditingController titleController =
      TextEditingController(text: "50 Push-ups");
  final TextEditingController durationController =
      TextEditingController(text: "15 Min");
  final String? selectedCategory = "Physical";
  final DateTime startDate = DateTime(2024, 12, 12);
  final DateTime endDate = DateTime(2024, 12, 12);

  TaskDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.black)),
        centerTitle: true,
        title: commonText("50 Push-ups", size: 20.0, isBold: true),
        actions: [
          PopupMenuButton<String>(
            iconColor: Colors.black,
            onSelected: (value) {
              if (value == "Completed") {
                Navigator.popUntil(context, (route) => route.isFirst);
              } else if (value == "Edit") {
                slideNavigationPushAndRemoveUntil(EditTaskScreen(), context,
                    onlypush: true);
              } else if (value == "Delete") {
                showDeleteTaskDialog(
                  context,
                  () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Completed', 'Edit', 'Delete'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Center(child: commonText(choice)),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Field
            commonText("Title", size: 16.0),
            const SizedBox(height: 5),
            commonTextfield(
              titleController,
              hintText: "Enter title",
            ),
            const SizedBox(height: 20),

            // Category Dropdown
            commonText("Category", size: 16.0),
            const SizedBox(height: 5),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.green, width: 1.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: commonText("Select Category",
                      size: 14.0, color: Colors.grey),
                  value: selectedCategory,
                  items: <String>["Physical", "Mental", "Spiritual"]
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: commonText(value, size: 14.0),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    // Handle category change
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Start Date and End Date
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      commonText("Date", size: 16.0),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          // Handle Start Date Selection
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 15.0),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.green, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month_outlined,
                                  color: AppColors.green, size: 16.0),
                              const SizedBox(width: 10),
                              commonText(
                                  DateFormat("dd - MM - yyyy")
                                      .format(startDate),
                                  size: 14.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(width: 10),
                // Expanded(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       commonText("End Date", size: 16.0),
                //       const SizedBox(height: 5),
                //       GestureDetector(
                //         onTap: () {
                //           // Handle End Date Selection
                //         },
                //         child: Container(
                //           padding: const EdgeInsets.symmetric(
                //               horizontal: 12.0, vertical: 15.0),
                //           decoration: BoxDecoration(
                //             border:
                //                 Border.all(color: AppColors.green, width: 1.0),
                //             borderRadius: BorderRadius.circular(10.0),
                //           ),
                //           child: Row(
                //             children: [
                //               const Icon(Icons.calendar_month_outlined,
                //                   color: AppColors.green, size: 16.0),
                //               const SizedBox(width: 10),
                //               commonText(
                //                   DateFormat("dd - MM - yyyy").format(endDate),
                //                   size: 14.0),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 20),

            // Duration Field
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                commonText("Duration", size: 16.0),
                commonText("(optional)")
              ],
            ),
            const SizedBox(height: 5),
            commonTextfield(
              durationController,
              prrfixIcon: Icon(Icons.watch_later_outlined),
              hintText: "Enter duration",
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> showDeleteTaskDialog(
      BuildContext context, VoidCallback onDelete) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: commonText("Do you want to delete this task?", size: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: commonButton(
                    "Cancel",
                    color: Colors.grey.shade300,
                    textColor: Colors.black,
                    height: 40,
                    width: 100,
                    onTap: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: commonButton(
                    "Delete",
                    color: AppColors.goldShades[600]!,
                    textColor: Colors.white,
                    height: 40,
                    width: 100,
                    onTap: () {
                      Navigator.of(context).pop(); // Close the dialog
                      onDelete(); // Perform the delete action
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
