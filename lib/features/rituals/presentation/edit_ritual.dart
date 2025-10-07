// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:cole20/core/providers.dart';
import 'package:cole20/features/rituals/application/homepage_state.dart';
import 'package:cole20/features/rituals/domain/category_name_model.dart';
import 'package:cole20/features/rituals/domain/ritual_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/core/commonWidgets.dart';
import 'package:intl/intl.dart';

class EditRitualScreen extends ConsumerStatefulWidget {
  final int currentDay;
  final Ritual ritual; // The ritual to edit

  EditRitualScreen({super.key, required this.currentDay, required this.ritual});

  @override
  ConsumerState<EditRitualScreen> createState() => _EditRitualScreenState();
}

class _EditRitualScreenState extends ConsumerState<EditRitualScreen> {
  late TextEditingController titleController;
  late TextEditingController durationController;

  String? selectedCategoryId;
  DateTime? selectedStartDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.ritual.title);
    durationController = TextEditingController(
      text: widget.ritual.duration?.toString() ?? "",
    );
    selectedCategoryId = widget.ritual.categoryId;
    log(selectedCategoryId.toString());
    selectedStartDate = DateTime.now().add(
      Duration(days: widget.ritual.startDay - widget.currentDay),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    durationController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate(HomepageState state) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedStartDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 45 - state.today)),
    );
    if (pickedDate != null) {
      setState(() {
        selectedStartDate = pickedDate;
      });
    }
  }

  void _updateRitual(HomepageState state) async {
    if (titleController.text.isEmpty ||
        selectedCategoryId == null ||
        selectedStartDate == null) {
      showSnackBar(
        context: context,
        title: "Empty",
        message: "Title, Category & Start Date are required",
      );
      return;
    }

    await ref
        .read(homePageNotifierProvider(widget.currentDay).notifier)
        .editRitual(
          Ritual(
            id: widget.ritual.id,
            title: titleController.text.trim(),
            categoryId: selectedCategoryId!,
            startDay:
                selectedStartDate!.difference(DateTime.now()).inDays +
                widget.currentDay +
                1,
            duration: int.tryParse(durationController.text),
            createdByUser: widget.ritual.createdByUser,
            createdAt: widget.ritual.createdAt,
            creatorRole: widget.ritual.creatorRole,
            isComplete: widget.ritual.isComplete,
          ),
        );

    // Close screen if no error
    if (!ref.read(homePageNotifierProvider(widget.currentDay)).hasError) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ritualState = ref.watch(homePageNotifierProvider(widget.currentDay));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: commonText("Edit Ritual", size: 20.0, isBold: true),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            commonText("Title", size: 16.0),
            const SizedBox(height: 5),
            commonTextfield(titleController, hintText: "Enter title"),
            const SizedBox(height: 20),

            // Category Dropdown
            commonText("Category", size: 16.0),
            const SizedBox(height: 5),
            ritualState.fetchingCategory
                ? const Center(child: CircularProgressIndicator())
                : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.green, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: commonText(
                        "Select Category",
                        size: 14.0,
                        color: Colors.grey,
                      ),
                      value:
                          ritualState.categoryName.any(
                                (cat) => cat.id == selectedCategoryId,
                              )
                              ? selectedCategoryId
                              : null, // ✅ Only assign if exists
                      items:
                          ritualState.categoryName.map((
                            RitualCategoryNameModel cat,
                          ) {
                            return DropdownMenuItem<String>(
                              value: cat.id,
                              child: commonText(cat.name, size: 14.0),
                            );
                          }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedCategoryId = newValue;
                        });
                      },
                    ),
                  ),
                ),

            const SizedBox(height: 20),

            // Start Date Picker
            commonText("Start Date", size: 16.0),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () => _pickStartDate(ritualState),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 15.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.green, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: AppColors.green,
                      size: 16.0,
                    ),
                    const SizedBox(width: 10),
                    commonText(
                      selectedStartDate == null
                          ? "Select Start Date"
                          : DateFormat(
                            "dd - MM - yyyy",
                          ).format(selectedStartDate!),
                      size: 14.0,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Duration
            commonText("Duration (optional)", size: 16.0),
            const SizedBox(height: 5),
            commonTextfield(
              durationController,
              prrfixIcon: const Icon(Icons.watch_later_outlined),
              hintText: "Enter duration in min",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 40),

            // Update Button
            commonButton(
              "Update Ritual",
              isLoading: ritualState.isSubmitting,
              onTap: () => _updateRitual(ritualState),
            ),
          ],
        ),
      ),
    );
  }
}
