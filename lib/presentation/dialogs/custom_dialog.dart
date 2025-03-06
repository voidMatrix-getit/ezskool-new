import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    this.messageColor = const Color(0xFF949495), this.hasCancelButton = false, this.cancelButtonText = '',
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

                  if(hasMessage)
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

                        if(hasCancelButton)...[


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
                                MaterialPageRoute(builder: (context) => redirectToScreen!),
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
                    )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
