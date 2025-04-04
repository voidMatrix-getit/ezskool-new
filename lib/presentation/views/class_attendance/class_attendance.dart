import 'dart:convert';

import 'package:ezskool/core/services/logger.dart';
import 'package:ezskool/data/repo/class_student_repo.dart';
import 'package:ezskool/data/viewmodels/class_attendance/class_attendance_viewmodel.dart';
import 'package:ezskool/presentation/dialogs/class_attendance_dialog.dart';
import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:ezskool/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/datasources/local/db/app_database.dart';
import '../../../data/viewmodels/class_attendance/class_attendance_home_viewmodel.dart';
import '../../../main.dart';
import '../../drawers/class_attendance_drawer.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Student {
  String rollNo;
  String leaveReason;

  Student({required this.rollNo, required this.leaveReason});

  // Convert a TestStudent object to a Map (useful for JSON encoding)
  Map<String, String> toJson() {
    return {
      "rno": rollNo,
      "lr": leaveReason,
    };
  }

  // Factory constructor to create a TestStudent from a Map (useful for JSON decoding)
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      rollNo: json["rno"] ?? "0",
      leaveReason: json["lr"] ?? "",
    );
  }
}

void showAttendanceNotification(String date, String className,
    String absentRollNumbers, String message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'attendance_channel', // Unique ID for the channel
    'Attendance Notifications',
    channelDescription: 'Shows notifications for attendance confirmation',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    styleInformation: BigTextStyleInformation(''),
    // actions: <AndroidNotificationAction>[
    //   AndroidNotificationAction(
    //     'dismiss_action', // Unique action ID
    //     'OK', // Button text
    //     cancelNotification:
    //         true, // This will dismiss the notification when clicked
    //   ),
    // ], // Expands message for better visibility
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    'Attendance Confirmed', // Title
    'Date: $date\nClass: $className\nAbsent: $absentRollNumbers\n$message',
    // Body
    notificationDetails,
  );
}

class ClassAttendanceScreen extends StatelessWidget {
  const ClassAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassAttendanceViewModel>(context);

    final attendanceData = viewModel.getAttendanceData();
    final isPresentSelected = viewModel.isPresentSelected;
    final rollNumbersToShow = isPresentSelected
        ? viewModel.presentRollNumbers
        : viewModel.absentRollNumbers;
    final total = viewModel.presentRollNumbers.length +
        viewModel.absentRollNumbers.length;

    final date =
        Provider.of<ClassAttendanceHomeViewModel>(context).selectedDate;

    return BaseScreen(
        child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Date and Class Info
                SvgPicture.asset('assets/cal.svg', width: 18.w, height: 18.h),
                SizedBox(width: 5.w),
                Text(date),
                SizedBox(width: 16.w),
                SvgPicture.asset('assets/vec.svg', width: 14.w, height: 17.h),
                // Image.asset('assets/vec.png', height: 18, width: 18,),
                SizedBox(width: 7.w),
                Text(attendanceData.currentClass),
              ],
            ),
            SizedBox(height: 24.h),

            Text(
              'Note - All students are marked present by default. Tap the roll number boxes to mark them absent.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 11.sp,
                color: Color(0xFFA29595),
              ),
            ),

            SizedBox(
              height: 20.h,
            ),
            // Toggle Section (Merged into ClassConfirmAttendanceScreen)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    viewModel.toggleOption(true);
                    HapticFeedback.selectionClick();
                  },
                  child: Column(
                    children: [
                      Text(
                        "Present(${viewModel.presentRollNumbers.length})",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          color: isPresentSelected
                              ? Color(0xFFED7902)
                              : Color(0xFF1E1E1E),
                        ),
                      ),
                      Container(
                        width: 121.w,
                        height: 2.h,
                        color: isPresentSelected
                            ? Color(0xFFED7902)
                            : Color(0xFFE0E4EC),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    viewModel.toggleOption(false);
                    HapticFeedback.selectionClick();
                  },
                  child: Column(
                    children: [
                      Text(
                        "Absent(${viewModel.absentRollNumbers.length})",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          color: !isPresentSelected
                              ? Color(0xFFED7902)
                              : Color(0xFF1E1E1E),
                        ),
                      ),
                      Container(
                        width: 113.w,
                        height: 2.h,
                        color: !isPresentSelected
                            ? Color(0xFFED7902)
                            : Color(0xFFE0E4EC),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // Roll number grid
            SizedBox(
              height: 250.h,
              child: GridView.builder(
                padding: EdgeInsets.all(8.r),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 20.h,
                ),
                itemCount: rollNumbersToShow.length,
                itemBuilder: (context, index) {
                  final rollNo = rollNumbersToShow[index];
                  final isPresent = viewModel.attendanceList[rollNo];
                  return GestureDetector(
                    onTap: () async {
                      HapticFeedback.mediumImpact();

                      viewModel.selectedRollNo = rollNo;

                      if (isPresent!) {
                        showMarkAbsentBottomDrawer(
                          context,
                          rollNo,
                          viewModel.getStudentsList[rollNo].toString(),
                          viewModel.getGender[rollNo]!,
                        );
                        // showDialog(
                        //   context: context,
                        //   builder: (context) => MarkAbsentDialog(
                        //     rollNO: rollNo,
                        //     name: viewModel.getStudentsList[rollNo].toString(),
                        //     gender: viewModel.getGender[rollNo]!,
                        //   ),
                        // );
                      } else {
                        showMarkPresentBottomDrawer(
                            context,
                            rollNo,
                            viewModel.getStudentsList[rollNo].toString(),
                            viewModel.getGender[rollNo]!,
                            viewModel.getStudent.leaveReason.toString());
                        // showDialog(
                        //   context: context,
                        //   builder: (context) => MarkPresentDialog(
                        //       rollNO: rollNo,
                        //       name:
                        //           viewModel.getStudentsList[rollNo].toString(),
                        //       reason:
                        //           viewModel.getStudent.leaveReason.toString(),
                        //       gender: viewModel.getGender[rollNo]!),
                        // );
                      }

                      //viewModel.toggleAttendance(rollNo);
                    },
                    child: Container(
                      width: 28.52.w,
                      height: 28.52.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F7),
                        // Light red for absent
                        border: Border.all(
                          color: isPresentSelected
                              ? Color(0xFF33CC99) // Green for present
                              : Color(0xFFDD3E2B), // Red for absent
                          width: 1.w,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Center(
                        child: Text(
                          rollNo.toString(),
                          style: TextStyle(
                            // fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: !isPresentSelected
                                ? const Color(0xFF494949)
                                : const Color(0xFF494949),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 60.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // First Card - Present
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return ClassAttendanceBottomSheetDrawer(
                          students: viewModel.getStudentsList,
                          attendance: viewModel.attendanceList,
                          gender: viewModel.getGender,
                          filter: 'Present', // Show present students only
                        );
                      },
                    );
                  },
                  child: _buildCard(
                    color: Color(0xFFF5F5F7),
                    borderColor: Color(0xFF33CC99),
                    shadowColor: Colors.black.withOpacity(0.25),
                    number: viewModel.presentRollNumbers.length.toString(),
                    label: "Present",
                    textColor: Color(0xFF33CC99),
                  ),
                ),

                SizedBox(width: 21.w), // Space between cards
                // Second Card - Absent
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return ClassAttendanceBottomSheetDrawer(
                          students: viewModel.getStudentsList,
                          attendance: viewModel.attendanceList,
                          gender: viewModel.getGender,
                          filter: 'Absent', // Show present students only
                        );
                      },
                    );
                  },
                  child: _buildCard(
                    color: Color(0xFFF5F5F7),
                    borderColor: Color(0xFFDD3E2B),
                    shadowColor: Colors.black.withOpacity(0.25),
                    number: viewModel.absentRollNumbers.length.toString(),
                    label: "Absent",
                    textColor: Color(0xFFDD3E2B),
                  ),
                ),

                SizedBox(width: 21.w), // Space between cards
                // Third Card - Total
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return ClassAttendanceBottomSheetDrawer(
                          students: viewModel.getStudentsList,
                          attendance: viewModel.attendanceList,
                          gender: viewModel.getGender,
                          filter: 'All', // Show present students only
                        );
                      },
                    );
                  },
                  child: _buildCard(
                    color: Color(0xFFF5F5F7),
                    borderColor: Color(0xFFFBCB99),
                    shadowColor: Colors.black.withOpacity(0.25),
                    number: total.toString(),
                    label: "Total",
                    textColor: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 80.h,
            ),

            Divider(
              indent: 20.w,
              endIndent: 20.w,
              color: Colors.grey[400],
              thickness: 1,
              height: 1.h,
            ),

            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Button 1: Gray background
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // showModalBottomSheet(
                    //
                    //   context: context,
                    //   isScrollControlled: true,
                    //   builder: (context) {
                    //     return ParentContactBottomSheet();
                    //   },
                    // );
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
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
                  onPressed: () async {
                    HapticFeedback.heavyImpact();

                    startShowing(context);

                    final cahvm = Provider.of<ClassAttendanceHomeViewModel>(
                        context,
                        listen: false);
                    bool? attDone = await ClassStudentRepo.getClassIsAttDone(
                        viewModel.className);
                    Log.d('attdone: $attDone');
                    String action = '';
                    Log.d('action: $action');
                    String? classAttId = '';
                    Log.d('classAttId: $classAttId');
                    if (!attDone!) {
                      action = '1';
                      Log.d('inside if of !attdone');
                      // await ClassStudentRepo.storeClass({
                      //   'class_id': viewModel.getStudent.classId,
                      //   'class_name': viewModel.className,
                      //   'class_att_id': viewModel.classAttId
                      // });
                    } else {
                      action = '2';
                    }
                    Log.d('action: $action');
                    if (action == '2') {
                      classAttId = await viewModel.clstrepo.storage
                          .read('attendance_id');
                    }
                    Log.d('classAttId: $classAttId');

                    Log.d(cahvm.selectedDate);
                    String originalFormat =
                        "EEE, dd MMM, yyyy"; // Original format.
                    String desiredFormat = "yyyy-MM-dd"; // Desired format.

                    DateTime parsedDate = DateFormat("EEE, dd MMM, yyyy")
                        .parse(cahvm.selectedDate);

                    // Format it to the desired output.
                    String formattedDate =
                        DateFormat("yyyy-MM-dd").format(parsedDate);

                    Log.d('formattedDate: $formattedDate');

                    final List<Map<String, String?>> absentData = viewModel
                            .absentRollNumbers.isEmpty
                        ? [
                            {"rno": "0", "lr": ""}
                          ] // Return default values when no absent students
                        : viewModel.absentRollNumbers.map((rollNo) {
                            final student = viewModel.getStudents.firstWhere(
                              (s) => s.rollNo == rollNo,
                              //orElse: () => TestStudent(rno: rollNo, leaveReason: s.,gender: ), // Default case
                            );
                            return {
                              "rno": student.rollNo.toString(),
                              "lr": student.leaveReason.toString().isNotEmpty
                                  ? student.leaveReason.toString()
                                  : "",
                              // Assuming leaveReason is available in TestStudent
                            };
                          }).toList();

                    Log.d('Absent data: $absentData');

                    // Log.d('DataToSend:\n'
                    //     '$formattedDate\n'
                    //     '1\n'
                    //     '2\n'
                    //     '${viewModel.getStudent.classId.toString()}\n'
                    //     '${viewModel.absentRollNumbers.toString()}:-> ${jsonEncode(absentData)}\n'
                    //     '$action\n'
                    //     '${viewModel.classAttId}');

                    final response = await viewModel.clstrepo
                        .sendMarkAttendanceData(
                            formattedDate,
                            '1',
                            '2',
                            viewModel.classId!,
                            jsonEncode(absentData.length.toString().isNotEmpty
                                ? absentData
                                : []),
                            action,
                            '',
                            viewModel.classAttId.toString(),
                            viewModel.absentRollNumbers.length.toString(),
                            viewModel.presentRollNumbers.length.toString());

                    if (response['success']) {
                      await deleteDatabase();

                      showAttendanceNotification(
                        cahvm.selectedDate,
                        viewModel.className,
                        viewModel.absentRollNumbers.join(", "),
                        response['message'],
                      );

                      Navigator.of(context, rootNavigator: true).pop();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(response['message']),
                        duration: Duration(seconds: 1),
                        backgroundColor: Colors.green,
                      ));
                      Navigator.pop(context);
                    } else {
                      Navigator.of(context, rootNavigator: true).pop();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(response['message']),
                        duration: Duration(seconds: 1),
                        backgroundColor: Colors.red,
                      ));
                      Navigator.pop(context);
                    }

                    // showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return CustomDialog(
                    //         title: 'Mark Attendance?',
                    //         height: 450.h,
                    //         message:
                    //             'Summary\nDate: $date\nClass: ${attendanceData.currentClass}\nPresent(${viewModel.presentRollNumbers.length}) | \tAbsent(${viewModel.absentRollNumbers.length})\nTotal($total)\nAbsent roll no: ${viewModel.attendanceList.entries.where((entry) => entry.value == false) // Get only absent roll numbers
                    //                 .map((entry) => entry.key).join(', ')}',
                    //         messageColor: Colors.black,
                    //         buttonText: 'Confirm & Mark',
                    //         icon: Icons.question_mark,
                    //         iconColor: Color(0xFFED7902),
                    //         backgroundColor: Color(0xFFED7902),
                    //         // Consistent error theme
                    //         onButtonPressed: () async {
                    //           // Navigator.pop(context);
                    //           HapticFeedback.mediumImpact();

                    //           startShowing(context);

                    //           final cahvm =
                    //               Provider.of<ClassAttendanceHomeViewModel>(
                    //                   context,
                    //                   listen: false);
                    //           bool? attDone =
                    //               await ClassStudentRepo.getClassIsAttDone(
                    //                   viewModel.className);
                    //           Log.d('attdone: $attDone');
                    //           String action = '';
                    //           Log.d('action: $action');
                    //           String? classAttId = '';
                    //           Log.d('classAttId: $classAttId');
                    //           if (!attDone!) {
                    //             action = '1';
                    //             Log.d('inside if of !attdone');
                    //             // await ClassStudentRepo.storeClass({
                    //             //   'class_id': viewModel.getStudent.classId,
                    //             //   'class_name': viewModel.className,
                    //             //   'class_att_id': viewModel.classAttId
                    //             // });
                    //           } else {
                    //             action = '2';
                    //           }
                    //           Log.d('action: $action');
                    //           if (action == '2') {
                    //             classAttId = await viewModel.clstrepo.storage
                    //                 .read('attendance_id');
                    //           }
                    //           Log.d('classAttId: $classAttId');

                    //           Log.d(cahvm.selectedDate);
                    //           String originalFormat =
                    //               "dd MMM yyyy, EEEE"; // Original format.
                    //           String desiredFormat =
                    //               "yyyy-MM-dd"; // Desired format.

                    //           DateTime parsedDate =
                    //               DateFormat("dd MMM yyyy, EEEE")
                    //                   .parse(cahvm.selectedDate);

                    //           // Format it to the desired output.
                    //           String formattedDate =
                    //               DateFormat("yyyy-MM-dd").format(parsedDate);

                    //           final List<Map<String, String?>> absentData =
                    //               viewModel.absentRollNumbers.map((rollNo) {
                    //             final student =
                    //                 viewModel.getStudents.firstWhere(
                    //               (s) => s.rollNo == rollNo,
                    //               //orElse: () => TestStudent(rno: rollNo, leaveReason: "Unknown"), // Default case
                    //             );
                    //             return {
                    //               "rno": student.rollNo.toString(),
                    //               "lr": student.leaveReason.toString(),
                    //               // Assuming leaveReason is available in TestStudent
                    //             };
                    //           }).toList();

                    //           Log.d('DataToSend:\n'
                    //               '$formattedDate\n'
                    //               '1\n'
                    //               '2\n'
                    //               '${viewModel.getStudent.classId.toString()}\n'
                    //               '${viewModel.absentRollNumbers.toString()}:-> ${jsonEncode(absentData)}\n'
                    //               '$action\n'
                    //               '${viewModel.classAttId}');

                    //           final response = await viewModel.clstrepo
                    //               .sendMarkAttendanceData(
                    //                   formattedDate,
                    //                   '1',
                    //                   '2',
                    //                   viewModel.getStudent.classId.toString(),
                    //                   jsonEncode(absentData),
                    //                   action,
                    //                   viewModel.classAttId.toString(),
                    //                   viewModel.absentRollNumbers.length
                    //                       .toString(),
                    //                   viewModel.presentRollNumbers.length
                    //                       .toString());

                    //           if (response['success']) {
                    //             await deleteDatabase();

                    //             showAttendanceNotification(
                    //               formattedDate,
                    //               viewModel.className,
                    //               viewModel.absentRollNumbers.join(", "),
                    //               response['message'],
                    //             );

                    //             Navigator.of(context, rootNavigator: true)
                    //                 .pop();
                    //             ScaffoldMessenger.of(context)
                    //                 .showSnackBar(SnackBar(
                    //               content: Text(response['message']),
                    //               duration: Duration(seconds: 1),
                    //               backgroundColor: Colors.green,
                    //             ));
                    //             Navigator.pop(context);
                    //           } else {
                    //             Navigator.of(context, rootNavigator: true)
                    //                 .pop();
                    //             ScaffoldMessenger.of(context)
                    //                 .showSnackBar(SnackBar(
                    //               content: Text(response['message']),
                    //               duration: Duration(seconds: 1),
                    //               backgroundColor: Colors.red,
                    //             ));
                    //             Navigator.pop(context);
                    //           }
                    //         },
                    //       );
                    //     });
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                  ),
                  child: Text(
                    "Confirm", // Replace with actual text
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
          ],
        ),
      ),
    ));
  }

  Widget _buildCard({
    required Color color,
    required Color borderColor,
    required Color shadowColor,
    required String number,
    required String label,
    required Color textColor,
  }) {
    return Container(
      width: 94.w,
      height: 102.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: Offset(0.w, 4.h),
            blurRadius: 8.4.r,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 40.sp,
              height: 1.2.h,
              color: textColor,
              letterSpacing: 0.4.w,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              height: 1.2.h,
              color: textColor,
              letterSpacing: 0.4.w,
            ),
          ),
        ],
      ),
    );
  }
}
