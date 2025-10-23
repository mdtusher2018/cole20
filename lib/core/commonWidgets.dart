import 'package:cole20/core/providers.dart';
import 'package:cole20/features/meditation/presentation/share_story.dart';
import 'package:cole20/features/rituals/domain/ritual_category_model.dart';
import 'package:cole20/features/rituals/presentation/calender.dart';
import 'package:flutter/material.dart';
import 'package:cole20/core/colors.dart';
import 'dart:math' as math;
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

Widget commonText(
  String text, {
  double size = 12.0,
  Color color = Colors.black,
  bool isBold = false,
  softwarp,
  int maxLine = 1000,
  TextAlign textAlign = TextAlign.left,
}) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    maxLines: maxLine,
    softWrap: softwarp,
    textAlign: textAlign,
    style: TextStyle(
      fontSize: size,
      color: color,
      fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
      fontFamily: 'TenorSans',
    ),
  );
}

Widget commonTextfield(
  TextEditingController controller, {
  String hintText = "",
  TextInputType keyboardType = TextInputType.text,
  String? assetIconPath,
  prrfixIcon,
  VoidCallback? onTap,
  bool isEnable = true,
  bool isPasswordVisible = false, // For password visibility toggle
  bool issuffixIconVisible = false, // To show or hide the suffix icon
  VoidCallback? changePasswordVisibility, // Callback to toggle visibility
  Color borderColor = AppColors.green,
  int maxLine = 1,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(color: borderColor, width: 1.0),
    ),
    child: TextField(
      onTap: onTap,
      enabled: isEnable,
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLine,
      obscureText: isPasswordVisible, // Toggle password visibility
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12.0),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 12,
          color: AppColors.black,
          fontFamily: 'TenorSans',
        ),
        border: InputBorder.none,
        prefixIcon:
            assetIconPath != null
                ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ImageIcon(AssetImage(assetIconPath), size: 24.0),
                )
                : (prrfixIcon != null)
                ? prrfixIcon
                : null,
        suffixIcon:
            issuffixIconVisible
                ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.black,
                  ),
                  onPressed: changePasswordVisibility,
                )
                : null,
      ),
    ),
  );
}

void showSnackBar({
  required BuildContext context,
  required String title,
  required String message,
  bool isTop = false,
  Color backgroundColor = Colors.red,
  Color textColor = Colors.white,
  Duration duration = const Duration(seconds: 3),
}) {
  Flushbar(
    title: title,
    message: message,
    duration: duration,
    backgroundColor: backgroundColor,
    flushbarPosition: FlushbarPosition.TOP, // This shows it at top
    margin: EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    titleColor: textColor,
    messageColor: textColor,
  ).show(context);

  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Widget commonTextfieldWithTitle(
  String title,
  TextEditingController controller, {
  FocusNode? focusNode,
  String hintText = "",
  bool isBold = true,
  bool issuffixIconVisible = false,
  bool isPasswordVisible = false,
  enable,
  textSize = 14.0,
  borderWidth = 0.0,
  changePasswordVisibility,
  TextInputType keyboardType = TextInputType.text,
  String? assetIconPath,
  Color borderColor = Colors.grey,
  int maxLine = 1,
  String? Function(String?)? onValidate,
  Function(String?)? onFieldSubmit,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      commonText(title, size: textSize, isBold: isBold),
      const SizedBox(height: 5),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: TextFormField(
            controller: controller,
            enabled: enable,
            focusNode: focusNode,
            validator: onValidate,
            onFieldSubmitted: onFieldSubmit,
            keyboardType: keyboardType,
            maxLines: maxLine,
            obscureText: isPasswordVisible,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(12.0),
              hintText: hintText,
              fillColor: AppColors.white,
              filled: true,
              hintStyle: TextStyle(
                fontSize: 12,
                color: AppColors.white,
                fontFamily: 'TenorSans',
              ),
              border: InputBorder.none,
              suffixIcon:
                  (issuffixIconVisible)
                      ? (!isPasswordVisible)
                          ? InkWell(
                            onTap: changePasswordVisibility,
                            child: Icon(Icons.visibility),
                          )
                          : InkWell(
                            onTap: changePasswordVisibility,
                            child: Icon(Icons.visibility_off_outlined),
                          )
                      : null,
              prefixIcon:
                  assetIconPath != null
                      ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ImageIcon(AssetImage(assetIconPath), size: 24.0),
                      )
                      : null,
            ),
          ),
        ),
      ),
    ],
  );
}

Future<dynamic> slideNavigationPushAndRemoveUntil(
  Widget page,
  BuildContext context, {
  bool onlypush = false,
}) {
  if (onlypush) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  } else {
    return Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
      (Route<dynamic> route) => false,
    );
  }
}

Widget commonButton(
  String title, {
  Color color = AppColors.green,
  Color textColor = Colors.white,
  double textSize = 18,
  double width = double.infinity,
  double height = 50,
  VoidCallback? onTap,
  bool isLoading = false,
}) {
  return GestureDetector(
    onTap: isLoading ? null : onTap,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: color,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child:
              isLoading
                  ? const CircularProgressIndicator()
                  : commonText(
                    title,
                    size: textSize,
                    color: textColor,
                    isBold: true,
                  ),
        ),
      ),
    ),
  );
}

Widget commonBorderButton(
  String title, {
  double width = double.infinity,
  VoidCallback? onTap,
  Color borderColor = AppColors.gold,
  double borderWidth = 1.0,
  String? imagePath, // Optional image parameter
  double imageSize = 24.0,
  Color textColor = AppColors.black,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 50,
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null) ...[
              Image.asset(
                imagePath,
                height: imageSize,
                width: imageSize,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8), // Space between image and text
            ],
            commonText(title, size: 18, color: textColor, isBold: true),
          ],
        ),
      ),
    ),
  );
}

Widget buildOTPTextField(
  TextEditingController controller,
  int index,
  BuildContext context,
) {
  return SizedBox(
    width: 55,
    height: 55,
    child: TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      cursorColor: Colors.black,
      style: const TextStyle(fontSize: 20, fontFamily: 'TenorSans'),
      maxLength: 1,
      decoration: InputDecoration(
        counterText: '',
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.black),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: (value) {
        if (value.length == 1 && index < 5) {
          FocusScope.of(context).nextFocus();
        } else if (value.isEmpty && index > 0) {
          FocusScope.of(context).previousFocus();
        }
      },
    ),
  );
}

class RoundedCapProgressIndicator extends StatelessWidget {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  const RoundedCapProgressIndicator({
    super.key,
    required this.progress, // Progress must be a value between 0.0 and 1.0
    this.backgroundColor = Colors.grey,
    this.progressColor = AppColors.green,
    this.strokeWidth = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RoundedCapPainter(
        progress: progress,
        backgroundColor: backgroundColor,
        progressColor: progressColor,
        strokeWidth: strokeWidth,
      ),
      child: SizedBox(width: 120, height: 120),
    );
  }
}

class _RoundedCapPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  _RoundedCapPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final backgroundPaint =
        Paint()
          ..color = backgroundColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    // Draw the background circle
    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    final progressPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [progressColor, progressColor], // Gradient color effect
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..strokeCap =
              StrokeCap
                  .round // This is where the rounded caps are defined
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    // Draw the progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      math.pi * 1.5,
      math.pi * 2 * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

Future<void> showLottieDialog({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final ritualState = ref.watch(
    homePageNotifierProvider((CalendarScreen.selectedIndex ?? 0) + 1),
  );
  await showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (context) {
      return Stack(
        children: [
          // Positioned at bottom center
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    "assets/animations/party.json",
                    width: 150,
                    height: 150,
                    repeat: false,
                    fit: BoxFit.cover,
                    onLoaded: (composition) {
                      Future.delayed(composition.duration, () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }

                        showModalBottomSheet(
                          context: context,
                          builder:
                              (context) => shareBottomSheet(
                                context,
                                ritualState.categories,
                                (CalendarScreen.selectedIndex ?? 0) + 1,
                              ),
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget shareBottomSheet(
  BuildContext context,
  List<RitualCategory> todayRituals,
  int today,
) {
  return Container(
    padding: const EdgeInsets.all(16),
    width: MediaQuery.sizeOf(context).width,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
          child: commonText('Share!', size: 16, textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: commonText(
            'Share your journy progress!',
            size: 16,
            textAlign: TextAlign.center,
          ),
        ),
        InkWell(
          onTap: () {
            slideNavigationPushAndRemoveUntil(
              ShareStory(
                todayRituals: (todayRituals),
                today: math.min(today, 45),
              ),
              onlypush: true,
              context,
            );
          },
          child: Container(
            height: 50,
            width: MediaQuery.sizeOf(context).width * 0.8,
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
  );
}
