import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/core/commonWidgets.dart';
import 'package:cole20/features/task/presentation/edit_task.dart';
import 'package:cole20/features/task/presentation/task.dart';

class MeditationTimerPage extends StatefulWidget {
  @override
  _MeditationTimerPageState createState() => _MeditationTimerPageState();
}

class _MeditationTimerPageState extends State<MeditationTimerPage> {
  double progress = 1.0; // Full progress (100%)
  Duration totalTime = Duration(minutes: 1); // Total meditation time
  Duration remainingTime = Duration(minutes: 1); // Remaining time
  Timer? timer;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (!isPaused && remainingTime > Duration.zero) {
        setState(() {
          remainingTime -= Duration(seconds: 1);
          progress = remainingTime.inSeconds / totalTime.inSeconds;
        });
      } else {
        t.cancel();
      }
    });
  }

  void pauseTimer() {
    setState(() {
      isPaused = true;
      startTimer();
    });
  }

  void resumeTimer() {
    setState(() {
      isPaused = false;
      startTimer();
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      remainingTime = totalTime;
      progress = 1.0;
      isPaused = false;
    });
    startTimer();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.black)),
        actions: [
          PopupMenuButton<String>(
            iconColor: Colors.black,
            onSelected: (value) {
              if (value == "Completed") {
                slideNavigationPushAndRemoveUntil(TaskDetailScreen(), context,
                    onlypush: true);
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
      body: Column(
        children: [
          commonText("Meditation (10 Min)", size: 20, isBold: true),
          SizedBox(height: 40),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                  width: 200,
                  height: 200,
                  child: RoundedCapProgressIndicator(progress: progress)),
              //   CircularProgressIndicator(
              //     value: progress,
              //     strokeWidth: 20,
              //     backgroundColor: Colors.grey,
              //     valueColor: AlwaysStoppedAnimation<Color>(AppColors.green),
              //   ),
              // ),
              commonText(formatTime(remainingTime), size: 24, isBold: true),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (isPaused) {
                    resumeTimer();
                  } else {
                    pauseTimer();
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    isPaused ? Icons.play_arrow : Icons.pause,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(width: 40),
              IconButton(
                icon: Icon(Icons.refresh, size: 36),
                onPressed: resetTimer,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> showDeleteTaskDialog(
    BuildContext context, VoidCallback onDelete) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: commonText("Do you want to delete this Ritual?", size: 16),
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
