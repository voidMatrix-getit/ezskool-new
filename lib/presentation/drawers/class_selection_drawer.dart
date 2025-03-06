import 'package:ezskool/data/viewmodels/class_attendance/class_attendance_home_viewmodel.dart';
import 'package:ezskool/data/viewmodels/class_attendance/student_listing_viewmodel.dart';
import 'package:ezskool/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void openBottomDrawerDropDown(BuildContext context, StudentViewModel stvm,
    List<Map<String, dynamic>> cardData) {
  final viewModel =
      Provider.of<ClassAttendanceHomeViewModel>(context, listen: false);

  String? tempStandard = viewModel.selectedStandard;
  String? tempDivision = viewModel.selectedDivision;
  String? tempClass = viewModel.selectedClass;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            height: 550.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(36.r),
                topRight: Radius.circular(36.r),
              ),
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(height: 13.h),
                Container(
                  height: 4.h,
                  width: 164.w,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                ),
                SizedBox(height: 20.h),

                SizedBox(
                    // height: 450.h,
                    // width: double.infinity.w,
                    child: Column(children: [
                  Text(
                    'Select Class',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      height: 1.5.h,
                      color: Color(0xFFA29595),
                    ),
                  ),
                  // SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(32.r),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      // Prevents inner scrolling
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        // Three cards per row
                        crossAxisSpacing: 16.w,
                        // Spacing between columns
                        mainAxisSpacing: 16.h,
                        // Spacing between rows
                        childAspectRatio: 80 / 77, // Card width-to-height ratio
                      ),
                      itemCount: cardData.length,
                      itemBuilder: (context, index) {
                        List<bool> isToggled =
                            List.filled(cardData.length, false);
                        final isSelected =
                            tempClass == cardData[index]['title'];
                        final data = cardData[index];
                        // To track card color state
                        return GestureDetector(
                          onTap: () async {
                            HapticFeedback.selectionClick();
                            startShowing(context);
                            setState(() {
                              tempClass = cardData[index]['title'];
                            });
                            viewModel.selectedClass = tempClass!;
                            // await Future.delayed(
                            //     const Duration(milliseconds: 80));

                            stvm.setClassName(data['title']);

                            stopShowing(context);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Color(0xFF33CC99)
                                  : Color(0xFFED7902),
                              border: Border.all(
                                  color: const Color(0xFFE2E2E2), width: 1.w),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40.w, // Line width
                                  height: 1.h, // Line height
                                  color: Colors.white, // Line color
                                  margin: EdgeInsets.symmetric(vertical: 4.h),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  cardData[index]['title']
                                      .toString()
                                      .replaceAll(' ', '-'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Container(
                                  width: 40.w, // Line width
                                  height: 1.h, // Line height
                                  color: Colors.white, // Line color
                                  margin: EdgeInsets.symmetric(vertical: 4.w),
                                ),
                                // Text(
                                //   '${cardData[index]['count']}',
                                //   style: const TextStyle(
                                //     fontWeight: FontWeight.w500,
                                //     fontSize: 14,
                                //     color: Colors.white,
                                //   ),
                                // ),
                                // const SizedBox(height: 4),
                                // Text(
                                //   cardData[index]['label'],
                                //   style: const TextStyle(
                                //     fontWeight: FontWeight.w400,
                                //     fontSize: 10,
                                //     color: Color(0xFFE2E2E2),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ])),

                SizedBox(
                  height: 15.h,
                ),

                Divider(
                  indent: 20.w,
                  endIndent: 20.w,
                  color: Colors.grey[400],
                  thickness: 1,
                  height: 1.h,
                ),
                // SizedBox(height: 5,),
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Button 1: Gray background
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xF5F5F5F5),
                          // Gray background
                          shadowColor: Colors.black.withOpacity(0.5),
                          // Drop shadow
                          elevation: 4,
                          // Shadow elevation
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(5.r), // Rounded corners
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 22.w, vertical: 10.h),
                        ),
                        child: Text(
                          "Cancel", // Replace with actual text
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            letterSpacing: 0.4.w,
                            color: Color(0xFF494949), // Text color
                          ),
                        ),
                      ),
                      // Button 2: Orange background
                      SizedBox(width: 20.w),

                      ElevatedButton(
                        onPressed: () {
                          if (tempClass != null) {
                            viewModel.updateClass(tempClass!);
                          }

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFED7902),
                          // Orange background
                          shadowColor: Colors.black.withOpacity(0.5),
                          // Drop shadow
                          elevation: 4,
                          // Shadow elevation
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(5.r), // Rounded corners
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 22.w, vertical: 10.h),
                        ),
                        child: Text(
                          "OK", // Replace with actual text
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            letterSpacing: 0.4.w,
                            color: Color(0xFFFAECEC), // Text color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
    },
  );
}
