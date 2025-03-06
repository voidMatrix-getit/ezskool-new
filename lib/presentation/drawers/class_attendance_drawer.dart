import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClassAttendanceBottomSheetDrawer extends StatelessWidget {
  final Map<int, String> students; // Roll No -> Name
  final Map<int, bool> attendance; // Roll No -> Present (true/false)
  final Map<int, int> gender; // Roll No -> Gender ID (1 for male, 2 for female)
  final String
      filter; // Filter for attendance status: "All", "Present", or "Absent"

  const ClassAttendanceBottomSheetDrawer({
    super.key,
    required this.students,
    required this.attendance,
    required this.gender,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    // Filter students based on the selected attendance filter
    Map<int, String> filteredStudents = {};
    students.forEach((rollNo, name) {
      bool isPresent = attendance[rollNo] ?? false;
      bool isFiltered = false;

      // Apply the filter
      if (filter == 'All' ||
          (filter == 'Present' && isPresent) ||
          (filter == 'Absent' && !isPresent)) {
        filteredStudents[rollNo] = name;
      }
    });

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(27.r),
        topRight: Radius.circular(27.r),
      ),
      child: Container(
        height: 600.h,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.list,
                  color: Color(0xFFED7902),
                ),
                Text(
                  filter == 'Present'
                      ? 'Present Students'
                      : (filter == 'Absent'
                          ? 'Absent Students'
                          : 'All Students'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Color(0xFFED7902),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // Header Row for Student Info
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  // SizedBox(width: 2.w),
                  Expanded(
                    flex: -2,
                    child: Image.asset(
                      'assets/id.png',
                      width: 21.w,
                      height: 16.h,
                    ),
                  ),

                  SizedBox(width: 35.w),
                  Expanded(
                    flex: 5,
                    child: Text(
                      "Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 120.w,
                  // ),
                  Expanded(
                    flex: -2,
                    child: Image.asset(
                      'assets/at.png',
                      width: 21.w,
                      height: 21.h,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[400],
              thickness: 2,
              height: 16.h,
            ),
            // Scrollable Content
            Expanded(
              child: ListView.builder(
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  final rollNo = filteredStudents.keys.elementAt(index);
                  final name = filteredStudents[rollNo]!;
                  final studentGender = gender[rollNo] == 1
                      ? "male"
                      : "female"; // Assuming 1 for male and 2 for female
                  final isPresent = attendance[rollNo] ?? false;
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 5.w),
                            Expanded(
                              child: Text(
                                rollNo.toString(),
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),

                            //SizedBox(width: 30.w),
                            Expanded(
                                flex: 5,
                                child: Row(
                                  children: [
                                    Image.asset(
                                      studentGender == "male"
                                          ? 'assets/bb.png'
                                          : 'assets/g.png',
                                      width: 12.w,
                                      height: 14.h,
                                      alignment: Alignment.center,
                                      color: studentGender == "male"
                                          ? Colors.blue
                                          : Colors.pink,
                                    ),
                                    SizedBox(width: 2.w),
                                    // Icon(
                                    //   studentGender == "male"
                                    //       ? Icons.male
                                    //       : Icons.female,
                                    //   color: studentGender == "male"
                                    //       ? Colors.blue
                                    //       : Colors.pink,
                                    //   //size: 18.r,
                                    // ),
                                    // Expanded(
                                    //   flex: 3,
                                    //   child:
                                    Text(
                                      name,
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    // ),
                                  ],
                                )),
                            Expanded(
                              flex: 0,
                              child: Icon(
                                isPresent ? Icons.check_circle : Icons.cancel,
                                color: isPresent ? Colors.green : Colors.red,
                                //size: 20.r,
                              ),
                            ),
                            // Green Tick / Red Cross Icon (Rightmost Column)
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey[300],
                        thickness: 2,
                        height: 16.h,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
