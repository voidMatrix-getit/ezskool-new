import 'dart:convert';

import 'package:ezskool/core/services/logger.dart';
import 'package:ezskool/data/repo/class_student_repo.dart';
import 'package:ezskool/data/repo/home_repo.dart';
import 'package:ezskool/data/repo/student_repo.dart';
import 'package:ezskool/data/viewmodels/class_attendance/class_attendance_viewmodel.dart';
import 'package:ezskool/data/viewmodels/class_attendance/student_listing_viewmodel.dart';
import 'package:ezskool/presentation/dialogs/class_attendance_dialog.dart';
import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:ezskool/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/datasources/local/db/app_database.dart';
import '../../../data/viewmodels/class_attendance/class_attendance_home_viewmodel.dart';
import '../../../main.dart';
import '../../dialogs/custom_dialog.dart';
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

void showAttendanceNotification(
    String date,
    String className,
    String total,
    String totalPresent,
    String totalAbsent,
    String presentRollNumbers,
    String absentRollNumbers,
    String message) async {
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
    'Date: $date\nClass: $className\nTotal: $total\nPresent: $totalPresent\nAbsent: $totalAbsent ${presentRollNumbers.isEmpty ? '' : '\nPresent Roll no: $presentRollNumbers'} ${absentRollNumbers.isEmpty ? '' : '\nAbsent Roll no: $absentRollNumbers'}\n$message',
    // Body
    notificationDetails,
  );
}

class ClassAttendanceScreen extends StatefulWidget {
  const ClassAttendanceScreen({super.key});

  @override
  State<ClassAttendanceScreen> createState() => _ClassAttendanceScreenState();
}

class _ClassAttendanceScreenState extends State<ClassAttendanceScreen> {
  bool isInitialized = false;

  List<Map<String, dynamic>> cardData = [];
  final stRepo = StudentRepository();
  bool isLoading = false; //

  final repoClassStudent = ClassStudentRepo();
  final homeRepo = HomeRepo();
  DateTime selectedDate = DateTime.now();

  String? selectedStandard;
  String? selectedDivision;
  String? selectedClass;
  bool isDropdownOpen = false;

  // Sample list for dropdown boxes
  List<String> standards = List.generate(12, (index) => '${index + 1}');
  List<String> divisions = [];

  String? tempStandard = '';
  String? tempDivision = '';
  String? tempClass = '';
  int? classId;

  final date = DateFormat('EEE, dd MMM, yyyy').format(DateTime.now());

  static final bool _isFirstLaunch = true;

  ClassAttendanceHomeViewModel clhvm =
      Provider.of<ClassAttendanceHomeViewModel>(
          navigatorKey.currentState!.context,
          listen: false);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // clhvm.setLoading(true);
      // checkFirstLaunch();
      clhvm.setInitialized(false);
      final stvm = Provider.of<StudentViewModel>(context, listen: false);
      // Log.d('cardData: $cardData');
      await loadClasses();
      // Log.d('cardData: $cardData');
      // clhvm.setLoading(false);
      if (cardData.isEmpty) {
        startShowing(context);

        await loadLD();
        await stRepo.fetchAllClasses();
        await loadClasses().then((value) {
          openBottomDrawerDropDown(context, stvm);
        });
      } else {
        openBottomDrawerDropDown(context, stvm);
      }
    });
  }

  Future<void> checkFirstLaunch() async {
    // setState(() {
    //   isLoading = true;
    // });
    // final prefs = await SharedPreferences.getInstance();
    // bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    // if (isFirstLaunch) {
    //   await loadLD();
    //   await stRepo.fetchAllClasses(); // Fetch fresh data only on first launch
    //   await prefs.setBool('isFirstLaunch', false);
    // }

    // await loadClasses(); // Always load classes to update UI
    setState(() {
      isLoading = true;
    });

    clhvm.setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

      if (isFirstLaunch) {
        await loadLD();
        await stRepo.fetchAllClasses();
        await prefs.setBool('isFirstLaunch', false);
      }

      // await loadClasses(); // This sets isLoading to false when successful
    } catch (e) {
      // Handle any errors
      Log.d('Error in checkFirstLaunch: $e');

      // Make sure to set isLoading to false even if there's an error
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isFirstLaunch', true); // Reset on app close
    }
  }

  Future<void> loadClasses() async {
    // final cls = await stRepo.getAllClasses();
    // Log.d(cardData);

    // setState(() {
    //   cardData = cls;
    //   Log.d(cardData);
    //   isLoading = false;
    //   Log.d(isLoading);
    // });
    clhvm.setLoading(true);
    try {
      final cls = await stRepo.getAllClasses();
      Log.d(cardData);

      setState(() {
        cardData = cls;
        Log.d(cardData);
        isLoading = false;
        Log.d(isLoading);
      });
      clhvm.setLoading(false);
    } catch (e) {
      Log.d('Error loading classes: $e');

      setState(() {
        isLoading = false; // Ensure isLoading is set to false even on error
      });
    }
  }

  Future<void> loadLD() async {
    // await homeRepo.loginSyncLrDiv();
    // divisions = await HomeRepo.dropdownDao.getDropdownValues('div');

    // Provider.of<ClassAttendanceHomeViewModel>(
    //         navigatorKey.currentState!.context,
    //         listen: false)
    //     .setDivisions(divisions);

    //isLoading = false;
    try {
      await homeRepo.loginSyncLrDiv();
      divisions = await HomeRepo.dropdownDao.getDropdownValues('div');

      Provider.of<ClassAttendanceHomeViewModel>(
              navigatorKey.currentState!.context,
              listen: false)
          .setDivisions(divisions);

      // setState not needed here as loadClasses will handle it
    } catch (e) {
      Log.d('Error in loadLD: $e');
      // No need to set isLoading = false here, as it will be handled in the calling function
    }
  }

  Future<void> getLoginSync(String id) async {
    final data = await repoClassStudent.fetchTestClassStudentData(
        id, DateFormat('yyyy-MM-dd').format(selectedDate));
    Log.d(data);
    await ClassStudentRepo.storeTestClassStudentData(data);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassAttendanceViewModel>(context);
    final stvm = Provider.of<StudentViewModel>(context, listen: false);

    final attendanceData = viewModel.getAttendanceData();
    final isPresentSelected = viewModel.isPresentSelected;
    final rollNumbersToShow = isPresentSelected
        ? viewModel.presentRollNumbers
        : viewModel.absentRollNumbers;
    final total = viewModel.presentRollNumbers.length +
        viewModel.absentRollNumbers.length;

    final date = DateFormat('EEE, dd MMM, yyyy').format(DateTime.now());

    return BaseScreen(
        child: !clhvm.isInitialized
            ? Container()
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Mark Class Attendance",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF494949),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Date and Class Info
                          SvgPicture.asset('assets/cal.svg',
                              width: 18.w, height: 18.h),
                          SizedBox(width: 5.w),
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF494949),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          GestureDetector(
                              onTap: () {
                                //openBottomDrawerDropDown(context, stvm);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/vec.svg',
                                      width: 14.w, height: 17.h),
                                  SizedBox(width: 7.w),
                                  Text(
                                    attendanceData.currentClass,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF494949),
                                    ),
                                  ),
                                ],
                              )),

                          // Image.asset('assets/vec.png', height: 18, width: 18,),
                        ],
                      ),

                      SizedBox(height: 10.h),
                      Divider(
                        // indent: 20.w,
                        // endIndent: 20.w,
                        color: Colors.grey[400],
                        thickness: 1,
                        height: 1.h,
                      ),
                      SizedBox(height: 10.h),

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
                      SizedBox(height: 16.h),
                      // Roll number grid
                      SizedBox(
                        height: 250.h,
                        child: GridView.builder(
                          padding: EdgeInsets.all(8.r),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                                    viewModel.getStudentsList[rollNo]
                                        .toString(),
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
                                      viewModel.getStudentsList[rollNo]
                                          .toString(),
                                      viewModel.getGender[rollNo]!,
                                      viewModel.getStudent.leaveReason
                                          .toString());
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
                        height: 80.h,
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
                                    filter:
                                        'Present', // Show present students only
                                  );
                                },
                              );
                            },
                            child: _buildCard(
                              color: Color(0xFFF5F5F7),
                              borderColor: Color(0xFF33CC99),
                              shadowColor: Colors.black.withOpacity(0.25),
                              number: viewModel.presentRollNumbers.length
                                  .toString(),
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
                                    filter:
                                        'Absent', // Show present students only
                                  );
                                },
                              );
                            },
                            child: _buildCard(
                              color: Color(0xFFF5F5F7),
                              borderColor: Color(0xFFDD3E2B),
                              shadowColor: Colors.black.withOpacity(0.25),
                              number:
                                  viewModel.absentRollNumbers.length.toString(),
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
                        height: 40.h,
                      ),

                      Divider(
                        // indent: 20.w,
                        // endIndent: 20.w,
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
                                borderRadius: BorderRadius.circular(
                                    5.r), // Rounded corners
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
                            onPressed: () async {
                              HapticFeedback.heavyImpact();

                              startShowing(context);

                              final cahvm =
                                  Provider.of<ClassAttendanceHomeViewModel>(
                                      context,
                                      listen: false);
                              bool? attDone =
                                  await ClassStudentRepo.getClassIsAttDone(
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
                              String desiredFormat =
                                  "yyyy-MM-dd"; // Desired format.

                              DateTime parsedDate =
                                  DateFormat("EEE, dd MMM, yyyy")
                                      .parse(cahvm.selectedDate);

                              // Format it to the desired output.
                              String formattedDate =
                                  DateFormat("yyyy-MM-dd").format(parsedDate);

                              Log.d('formattedDate: $formattedDate');

                              final List<
                                  Map<String, String?>> absentData = viewModel
                                      .absentRollNumbers.isEmpty
                                  ? [
                                      {"rno": "0", "lr": ""}
                                    ] // Return default values when no absent students
                                  : viewModel.absentRollNumbers.map((rollNo) {
                                      final student =
                                          viewModel.getStudents.firstWhere(
                                        (s) => s.rollNo == rollNo,
                                        //orElse: () => TestStudent(rno: rollNo, leaveReason: s.,gender: ), // Default case
                                      );
                                      return {
                                        "rno": student.rollNo.toString(),
                                        "lr": student.leaveReason
                                                .toString()
                                                .isNotEmpty
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
                                      jsonEncode(absentData.length
                                              .toString()
                                              .isNotEmpty
                                          ? absentData
                                          : []),
                                      viewModel.presentRollNumbers.join(","),
                                      action,
                                      viewModel.classAttId.toString(),
                                      viewModel.absentRollNumbers.length
                                          .toString(),
                                      viewModel.presentRollNumbers.length
                                          .toString());

                              if (response['success']) {
                                await deleteDatabase();

                                showAttendanceNotification(
                                  cahvm.selectedDate,
                                  viewModel.className,
                                  total.toString(),
                                  viewModel.presentRollNumbers.length
                                      .toString(),
                                  viewModel.absentRollNumbers.length.toString(),
                                  viewModel.presentRollNumbers.join(", "),
                                  viewModel.absentRollNumbers.join(", "),
                                  response['message'],
                                );

                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(response['message']),
                                  duration: Duration(seconds: 1),
                                  backgroundColor: Colors.green,
                                ));
                                Navigator.pop(context);
                              } else {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(response['message']),
                                  duration: Duration(seconds: 1),
                                  backgroundColor: Colors.red,
                                ));
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFED7902),
                              // Orange background
                              shadowColor: Colors.black.withOpacity(0.5),
                              // Drop shadow
                              elevation: 4,
                              // Shadow elevation
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5.r), // Rounded corners
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 22.w, vertical: 10.h),
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

  void openBottomDrawerDropDown(BuildContext context, StudentViewModel stvm) {
    final viewModel =
        Provider.of<ClassAttendanceHomeViewModel>(context, listen: false);
    final clvmdl =
        Provider.of<ClassAttendanceViewModel>(context, listen: false);

    String? tempStandard = viewModel.selectedStandard;
    String? tempDivision = viewModel.selectedDivision;
    String? tempClass = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              height: 620.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36.r),
                  topRight: Radius.circular(36.r),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(height: 16.h),
                  Text(
                    "Mark Class Attendance",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF494949),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Date and Class Info
                      SvgPicture.asset('assets/cal.svg',
                          width: 18.w, height: 18.h),
                      SizedBox(width: 5.w),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF494949),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 13.h),
                  // Container(
                  //   height: 4.h,
                  //   width: 264.w,
                  //   decoration: BoxDecoration(
                  //     color: Color(0xFFD9D9D9),
                  //     borderRadius: BorderRadius.circular(22.r),
                  //   ),
                  // ),
                  Text(
                    'Select Class',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      height: 1.5.h,
                      color: Color(0xFFA29595),
                    ),
                  ),

                  SizedBox(height: 13.h),

                  Expanded(
                    child: SizedBox(
                        // height: 450.h,
                        // width: double.infinity.w,
                        child: Column(children: [
                      Divider(
                        indent: 20.w,
                        endIndent: 20.w,
                        color: Colors.grey[400],
                        thickness: 1,
                        height: 1.h,
                      ),
                      // SizedBox(height: 20),

                      clhvm.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                              color: Color(0xFFED7902),
                            ))
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32.w, vertical: 16.h),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: AlwaysScrollableScrollPhysics(),
                                // Prevents inner scrolling
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  // Three cards per row
                                  crossAxisSpacing: 16.w,
                                  // Spacing between columns
                                  mainAxisSpacing: 16.h,
                                  // Spacing between rows
                                  childAspectRatio:
                                      80 / 77, // Card width-to-height ratio
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

                                      classId = cardData[index]['classId'];
                                      stopShowing(context);
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Color(0xFF33CC99)
                                            : Color(0xFFED7902),
                                        border: Border.all(
                                            color: const Color(0xFFE2E2E2),
                                            width: 1.w),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.25),
                                            offset: const Offset(0, 2),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 40.w, // Line width
                                            height: 1.h, // Line height
                                            color: Colors.white, // Line color
                                            margin: EdgeInsets.symmetric(
                                                vertical: 4.h),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            cardData[index]['title'].toString(),
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
                                            margin: EdgeInsets.symmetric(
                                                vertical: 4.w),
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
                            ),
                    ])),
                  ),

                  // SizedBox(
                  //   height: 15.h,
                  // ),

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
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.pop(context);
                              //Navigator.pop(context);
                            });
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
                        SizedBox(width: 20),

                        ElevatedButton(
                          onPressed: () async {
                            HapticFeedback.mediumImpact();
                            startShowing(context);
                            if (tempClass != null) {
                              viewModel.updateClass(tempClass!);
                              setState(() {
                                tempClass = '';
                              });
                            }

                            if (viewModel.selectedClass.isNotEmpty) {
                              // await deleteDatabase();
                              //await getLoginSync(classId.toString());
                              try {
                                clvmdl.classId = classId.toString();
                                await clvmdl.initializeAttendanceList(
                                    classId.toString());
                                viewModel.updateDate(
                                    DateFormat('EEE, dd MMM, yyyy')
                                        .format(selectedDate));
                                clhvm.setInitialized(true);

                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();

                                  Navigator.pop(context);
                                });
                              } catch (e) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('No Data Found for this Class'),
                                  duration: Duration(seconds: 1),
                                  backgroundColor: Colors.red,
                                ));
                              }
                            } else {
                              Navigator.of(context, rootNavigator: true).pop();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialog(
                                      title: 'Class Not Selected',
                                      height: 360.h,
                                      message:
                                          'Please select a class before proceeding with attendance.',
                                      buttonText: 'Ok',
                                      icon: Icons.error_outline,
                                      iconColor: Color(0xFFED7902),
                                      backgroundColor: Color(0xFFED7902),
                                      // Consistent error theme
                                      onButtonPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog and allow retry
                                      },
                                    );
                                  });
                            }
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
                  ),
                ],
              ),
            ),
          );
        });
      },
    ).then((value) {
      // This will be called when the bottom sheet is dismissed
      if (!clhvm.isInitialized) {
        // Only pop if the screen wasn't initialized
        Navigator.pop(context);
      }
    });
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
