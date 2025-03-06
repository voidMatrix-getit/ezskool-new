import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class TaskDetailsScreen extends StatelessWidget {
  TaskDetailsScreen({super.key});

  final date = DateFormat('EEE, dd MMM yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date and Class Info

                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios,
                          color: Color(0xFF494949), size: 20.r),
                    ),
                    SizedBox(width: 5.w),
                    SvgPicture.asset('assets/cal.svg',
                        width: 18.w, height: 18.h),
                    SizedBox(width: 5.w),
                    Text(date,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xFF494949),
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.edit, color: Color(0xFF626262), size: 20.r),
                    SizedBox(width: 5.w),
                    Icon(Icons.delete, color: Color(0xFFDD3E2B), size: 20.r),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              width: 341.w,
              // height: 354.h,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 6,
                    offset: Offset(0, 1),
                  ),
                ],
                borderRadius: BorderRadius.circular(2.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 330.w,
                      height: 34.h,
                      decoration: BoxDecoration(
                        color: Color(0xFFFAECEC),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 6.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.class_,
                                    size: 18.r, color: Color(0xFF979797)),
                                SizedBox(width: 5.w),
                                Text(
                                  "6th A",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF494949),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.hourglass_top_rounded,
                                    size: 18.r, color: Color(0xFF979797)),
                                // SvgPicture.asset(
                                //   'assets/sandwatch.svg',
                                //   width: 18.w,
                                //   height: 18.h,
                                // ),
                                SizedBox(width: 5.w),
                                Text(
                                  "25-01-2025",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Color(0xFF626262),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Mathematics",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF494949),
                      ),
                    ),
                    Divider(
                      color: Color(0xFFD2D2D7),
                      thickness: 1,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "Task",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF494949),
                      ),
                    ),
                    Container(
                      width: 311.w,
                      //height: 75.h,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xFF969AB8), width: 0.5.w),
                        borderRadius: BorderRadius.circular(6.r),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Text(
                          "Solve exercises 5.1 and 5.2 from your textbook. Complete the worksheet on fractions and bring it for review",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xFF626262),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Attachments",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF494949),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      width: 311.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xFF969AB8), width: 0.5.w),
                        borderRadius: BorderRadius.circular(6.r),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Class_problems.pdf",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Color(0xFF626262),
                              ),
                            ),
                            Icon(Icons.file_download,
                                color: Color(0xFF9D9D9D), size: 20.r),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
