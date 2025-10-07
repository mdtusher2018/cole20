import 'dart:async';
import 'package:cole20/core/colors.dart';
import 'package:cole20/features/rituals/domain/ritual_model.dart';
import 'package:cole20/features/rituals/presentation/edit_ritual.dart';
import 'package:cole20/features/rituals/presentation/task.dart';
import 'package:flutter/material.dart';
import 'package:cole20/core/commonWidgets.dart';


class MeditationTimerPage extends StatefulWidget {
  final Ritual ritual;
  final int currentDay;
  const MeditationTimerPage({super.key, required this.ritual,required this.currentDay});

  @override
  _MeditationTimerPageState createState() => _MeditationTimerPageState();
}
class _MeditationTimerPageState extends State<MeditationTimerPage> {
  double progress = 0.0; 
  Duration totalTime = Duration.zero; 
  Duration remainingTime = Duration.zero; 
  Duration elapsedTime = Duration.zero; 
  Timer? timer;
  bool isPaused = false;
  bool isCountdown = true; // Flag to decide count direction

  @override
  void initState() {
    super.initState();

    if (widget.ritual.duration != null) {
      // Countdown mode
      totalTime = Duration(minutes: widget.ritual.duration!);
      remainingTime = totalTime;
      isCountdown = true;
      progress = 1.0;
    } else {
      // Count-up mode
      elapsedTime = Duration.zero;
      isCountdown = false;
      progress = 0.0;
    }

    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!isPaused) {
        setState(() {
          if (isCountdown) {
            if (remainingTime > Duration.zero) {
              remainingTime -= const Duration(seconds: 1);
              progress = remainingTime.inSeconds / totalTime.inSeconds;
            } else {
              t.cancel();
            }
          } else {
            // Count up
            elapsedTime += const Duration(seconds: 1);
            progress = 1; // Example: progress as fraction of 1 hour
          }
        });
      }
    });
  }

  void pauseTimer() {
    setState(() => isPaused = true);
  }

  void resumeTimer() {
    setState(() => isPaused = false);
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      if (isCountdown) {
        remainingTime = totalTime;
        progress = 1.0;
      } else {
        elapsedTime = Duration.zero;
        progress = 0.0;
      }
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
    final displayTime = isCountdown ? remainingTime : elapsedTime;

    return Scaffold(
      appBar: AppBar(
  
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
  

      actions: [
          PopupMenuButton<String>(
            iconColor: Colors.black,
            onSelected: (value) {
              if (value == "Completed") {
                slideNavigationPushAndRemoveUntil(
                  TaskDetailScreen(),
                  context,
                  onlypush: true,
                );
              } else if (value == "Edit") {
                slideNavigationPushAndRemoveUntil(
                  EditRitualScreen(ritual: widget.ritual,currentDay: widget.currentDay,),
                  context,
                  onlypush: true,
                );
              } else if (value == "Delete") {
                showDeleteTaskDialog(context, () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                });
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
                    commonText((widget.ritual.duration!=null)?"Meditation (${widget.ritual.duration} Min)":"Workout", size: 20, isBold: true),
       
          const SizedBox(height: 40),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: RoundedCapProgressIndicator(progress: progress),
              ),
              commonText(formatTime(displayTime), size: 24, isBold: true),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (isPaused) resumeTimer();
                  else pauseTimer();
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(isPaused ? Icons.play_arrow : Icons.pause, size: 24),
                ),
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: const Icon(Icons.refresh, size: 36),
                onPressed: resetTimer,
              ),
            ],
          ),
        ],
      ),
    );
  }

Future<void> showDeleteTaskDialog(
  BuildContext context,
  VoidCallback onDelete,
) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: commonText("Do you want to delete this Ritual?", size: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              SizedBox(width: 10),
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
