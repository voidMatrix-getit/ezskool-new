import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final bool hasMessage;
  final String message;
  final Color messageColor;
  final String buttonText;
  final bool hasCancelButton;
  final String cancelButtonText;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final bool showCloseButton;
  final bool useBlurBackground;
  final VoidCallback onButtonPressed;
  final bool hasSecondParagraph;
  final String? secondParagraph;
  final Widget? redirectToScreen;
  final double height;

  const CustomDialog({
    super.key,
    required this.title,
    this.hasMessage = false,
    this.message = '',
    required this.buttonText,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.onButtonPressed,
    this.showCloseButton = true,
    this.useBlurBackground = false,
    this.hasSecondParagraph = false,
    this.secondParagraph,
    this.redirectToScreen,
    this.height = 500,
    this.messageColor = const Color(0xFF949495),
    this.hasCancelButton = false,
    this.cancelButtonText = '',
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Background blur
          if (useBlurBackground)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          // Dialog box
          Center(
            // top: 80, for Positioned
            // left: 20,
            // right: 20,
            child: Container(
              height: height,
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Close Button
                  if (showCloseButton)
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  SizedBox(height: 10.h),
                  // Icon Circle
                  Container(
                    width: 64.w,
                    height: 64.h,
                    decoration: BoxDecoration(
                      color: iconColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 32.r,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),

                  if (hasMessage)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        message,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: messageColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  if (hasSecondParagraph) SizedBox(height: 10.h),
                  if (hasSecondParagraph)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        secondParagraph ?? '',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Color(0xFF949495),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Spacer(), // Pushes the OK button to the bottom
                  // OK Button
                  Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (hasCancelButton) ...[
                            ElevatedButton(
                              onPressed: () {
                                // If a custom redirect screen is provided, navigate there
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF5F5F5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                minimumSize: Size(99.w, 37.h),
                              ),
                              child: Text(
                                cancelButtonText,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF494949),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                          ],
                          ElevatedButton(
                            onPressed: () {
                              // If a custom redirect screen is provided, navigate there
                              if (redirectToScreen != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => redirectToScreen!),
                                );
                              } else {
                                onButtonPressed(); // Otherwise, execute the custom action
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: backgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              minimumSize: Size(99.w, 37.h),
                            ),
                            child: Text(
                              buttonText,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDialog2 extends StatelessWidget {
  final String title;
  final String message;
  final String negativeButtonText;
  final String positiveButtonText;
  final VoidCallback onNegativePressed;
  final VoidCallback onPositivePressed;
  final Color positiveButtonColor;
  final Color negativeButtonColor;
  final Color titleColor;
  final Color messageColor;

  const CustomDialog2({
    super.key,
    required this.title,
    required this.message,
    required this.negativeButtonText,
    required this.positiveButtonText,
    required this.onNegativePressed,
    required this.onPositivePressed,
    this.positiveButtonColor = const Color(0xFFED7902),
    this.negativeButtonColor = const Color(0xFFF5F5F5),
    this.titleColor = const Color(0xFF494949),
    this.messageColor = const Color(0xFF6A7D94),
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.r),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      //width: 273.w,
      //height: 152.h,
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 15.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            widthFactor: 2.68.w,
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                    height: 1.49.h,
                  ),
              textAlign: TextAlign.left,
            ),
          ),

          SizedBox(height: 4.h),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: messageColor,
              letterSpacing: 0.01,
              height: 1.5.h,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildButton(
                  context,
                  negativeButtonText,
                  negativeButtonColor,
                  const Color(0xFF494949),
                  onNegativePressed,
                ),
                SizedBox(width: 9.w),
                _buildButton(
                  context,
                  positiveButtonText,
                  positiveButtonColor,
                  Colors.white,
                  onPositivePressed,
                ),
              ],
            ),
          ),

          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [

          //     // Padding(
          //     //   padding: EdgeInsets.symmetric(horizontal: 28.w),
          //     //child:

          //     // Spacer(),

          //     //),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    Color backgroundColor,
    Color textColor,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 71.w,
        height: 37.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: textColor,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }
}
