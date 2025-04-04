import 'dart:async';
import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ezskool/core/services/logger.dart';
import 'package:ezskool/data/repo/class_student_repo.dart';
import 'package:ezskool/data/viewmodels/class_attendance/student_listing_viewmodel.dart';
import 'package:ezskool/presentation/drawers/calendar_bottom_drawer.dart';
import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:ezskool/presentation/views/class_attendance/new_class_attendance_home_screen.dart';
import 'package:ezskool/presentation/widgets/custom_buttons.dart';
import 'package:ezskool/presentation/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../data/repo/student_repo.dart';

class SelectorDropdownWidget extends StatelessWidget {
  final String hint;
  final String text;
  final IconData leadingIcon;
  final List<String> items;
  final Function(String?) onChanged;
  final double width;
  final double dx;
  final double dy;

  const SelectorDropdownWidget({
    super.key,
    this.hint = '',
    this.text = "Select Option",
    this.leadingIcon = Icons.list,
    required this.items,
    required this.onChanged,
    this.width = 342,
    this.dx = 0,
    this.dy = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 3.9,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                alignment: Alignment.centerLeft,
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
          value: items.contains(text) ? text : null,
          onChanged: onChanged,
          buttonStyleData: ButtonStyleData(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.r),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            width: width.w,
            offset: Offset(dx, dy),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 3.9,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
          ),
          customButton: SizedBox(
            width: 342.w,
            height: 48.h,
            child: Stack(
              children: [
                // Leading icon
                Positioned(
                  left: 20.w,
                  top: 13.h,
                  child: Icon(
                    leadingIcon,
                    size: 20.w,
                    color: text == hint ? Color(0xFF969AB8) : Color(0xFF494949),
                  ),
                ),

                // Text
                Positioned(
                  left: 50.w,
                  top: 13.h,
                  child: Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      height: 1.5,
                      color:
                          text == hint ? Color(0xFF969AB8) : Color(0xFF494949),
                      textBaseline: TextBaseline.alphabetic,
                    ),
                  ),
                ),

                // Trailing icon
                Positioned(
                  right: 11.w,
                  top: 13.h,
                  child: Icon(
                    CupertinoIcons.chevron_down,
                    size: 20.w,
                    color: text == hint ? Color(0xFF969AB8) : Color(0xFF494949),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SelectorWidget extends StatelessWidget {
  final String hint;
  final String text;
  final IconData leadingIcon;
  final VoidCallback onTap;

  const SelectorWidget({
    super.key,
    this.hint = '',
    this.text = "Select Date",
    this.leadingIcon = Icons.calendar_today,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 342.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 3.9,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Leading icon
            Positioned(
              left: 20.w,
              top: 13.h,
              child: Icon(
                leadingIcon,
                size: 20.w,
                color: text == hint ? Color(0xFF969AB8) : Color(0xFF494949),
              ),
            ),

            // Text
            Positioned(
              left: 50.w,
              top: 13.h,
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  height: 1.5.h,
                  color: text == hint ? Color(0xFF969AB8) : Color(0xFF494949),
                  textBaseline: TextBaseline.alphabetic,
                ),
              ),
            ),

            // Trailing icon
            Positioned(
              right: 11.w,
              top: 13.h,
              child: Icon(
                CupertinoIcons.chevron_down,
                size: 20.w,
                color: text == hint ? Color(0xFF969AB8) : Color(0xFF494949),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceStatusScreen extends StatefulWidget {
  const AttendanceStatusScreen({super.key});

  @override
  AttendanceStatusScreenState createState() => AttendanceStatusScreenState();
}

class AttendanceStatusScreenState extends State<AttendanceStatusScreen> {
  // List<Map<String, dynamic>> cardData = [];
  // final stRepo = StudentRepository();
  // bool isLoading = true;

  // List<bool> isToggled = []; // Move isToggled to class level

  // DateTime? selectedDate;

  List<Map<String, dynamic>> cardData = [];
  final stRepo = StudentRepository();
  bool isLoading = false;
  List<bool> isToggled = [];
  DateTime selectedDate = DateTime.now();
  String? formattedDate;
  Map<int, Map<String, dynamic>> attendanceData = {};

  // Define shift options
  String? selectedShift;
  final List<String> shiftOptions = ['Morning Shift', 'Evening Shift'];
  final Map<String, String> shiftValues = {
    'Morning Shift': '1',
    'Evening Shift': '2',
  };

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          builder: (context) => SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: CalendarBottomSheet(
                      initialDate: selectedDate,
                      onDateSelected: (newDate) async {
                        setState(() {
                          selectedDate = newDate;
                          formattedDate =
                              DateFormat('EEE, dd MMM, yyyy').format(newDate);
                          // isLoading = true;
                        });

                        // Fetch attendance data for the selected date
                        // await fetchAttendanceData(
                        //     DateFormat('yyyy-MM-dd').format(newDate),
                        //     shiftValues[selectedShift] ?? '1');

                        // setState(() {
                        //   isLoading = false;
                        // });
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          //Navigator.pop(context);
                          _showFilterDialog();
                        });
                      },
                    )),
              ));
    });

    // selectedShift = shiftOptions[0];
    // load();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Close current dialog
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Select Date and Shift",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Color(0xFF494949),
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SelectorWidget(
                  hint: 'Select Date',
                  text: formattedDate ?? 'Select Date',
                  leadingIcon: Icons.date_range,
                  onTap: () {
                    // Navigator.pop(context);
                    showModalBottomSheet(
                      backgroundColor: Colors.white,
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.r)),
                      ),
                      builder: (context) => SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: CalendarBottomSheet(
                            initialDate: selectedDate ?? DateTime.now(),
                            onDateSelected: (newDate) {
                              setState(() {
                                selectedDate = newDate;
                                formattedDate = DateFormat('EEE, dd MMM, yyyy')
                                    .format(selectedDate);
                              });
                              // Reopen the filter dialog after date selection

                              //Navigator.pop(context);

                              // Log.d('filter dialog opened');
                              // _showFilterDialog();
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.pop(context);
                                _showFilterDialog();
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                SelectorDropdownWidget(
                  width: 250.0,
                  hint: 'Select Shift',
                  text: selectedShift ?? "Select Shift",
                  leadingIcon: Icons.view_day_rounded,
                  items: shiftOptions,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedShift = newValue;
                      });
                      Navigator.pop(context);
                      _showFilterDialog();
                    }
                  },
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Cancel Button
                    CustomActionButton(
                      text: 'Cancel',
                      backgroundColor: const Color(0xFFF5F5F5),
                      textColor: Color(0xFF494949),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: 9.w),

                    // Submit Button
                    CustomActionButton(
                      text: 'Apply',
                      backgroundColor: const Color(0xFFED7902),
                      textColor: Colors.white,
                      onPressed: () async {
                        HapticFeedback.heavyImpact();
                        //startShowing(context);
                        setState(() {
                          isLoading = true;
                        });
                        await fetchAttendanceData(
                            DateFormat('yyyy-MM-dd').format(selectedDate),
                            shiftValues[selectedShift] ?? '1');
                        //stopShowing(context);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        );
      },
    );
  }

  Future<void> load() async {
    // Fetch attendance data for current date
    await fetchAttendanceData(DateFormat('yyyy-MM-dd').format(selectedDate),
        shiftValues[selectedShift] ?? '1');

    setState(() {
      isLoading = false;
    });
  }

  // Method to fetch attendance data and classes
  Future<void> fetchAttendanceData(String date, String shift) async {
    try {
      final apiData = await stRepo.fetchClassAttendanceReport(shift, date);

      Log.d(apiData);

      // Clear previous data
      attendanceData.clear();
      cardData.clear();
      // if (apiData is Map && apiData.containsKey('error')) {
      //   // Show error message if API returns an error
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text(apiData['error'] ?? "An error occurred"),
      //       duration: Duration(seconds: 3),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      //   // Keep cardData empty
      //   return;
      // }

      // // Check if the API returned an empty list
      // if (apiData is List && apiData.isEmpty) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text("No classes found for the given shift."),
      //       duration: Duration(seconds: 3),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      //   // Keep cardData empty
      //   return;
      // }
      // Process the API response (example: [{"class_id":1,"class_name":"10","att":null},{"class_id":2,"class_name":"1-A","att":"12,1,13"},...])
      for (var item in apiData) {
        int classId = item['class_id'];
        String className = item['class_name'];
        String? att = item['att'];
        String dateTime = item['lut'] ?? '';

        // Store the attendance data
        attendanceData[classId] = {
          'className': className,
          'att': att,
          'hasAttendance': att != null
        };

        // Add to card data for displaying classes
        cardData.add({'classId': classId, 'title': className, 'dt': dateTime});
      }

      Log.d('Here-> : $cardData');

      // Initialize toggle state for all classes
      isToggled = List.filled(cardData.length, false);
    } catch (e) {
      setState(() {
        attendanceData.clear();
        cardData.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading classes: No Classes found"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Get attendance status for a class
  bool hasAttendanceMarked(int classId) {
    return attendanceData[classId]?['hasAttendance'] ?? false;
  }

  // Parse attendance data to get counts
  Map<String, int> getAttendanceCounts(int classId) {
    Map<String, int> counts = {'present': 0, 'absent': 0, 'total': 0};

    String? att = attendanceData[classId]?['att'];
    if (att != null && att.isNotEmpty) {
      List<String> parts = att.split(',');
      if (parts.length >= 3) {
        counts['present'] = int.tryParse(parts[0]) ?? 0;
        counts['absent'] = int.tryParse(parts[1]) ?? 0;
        counts['total'] = int.tryParse(parts[2]) ?? 0;
      }
    }

    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      resize: true,
      trailing: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.account_tree, color: Colors.white),
          onPressed: () {
            HapticFeedback.mediumImpact();

            // Ensure the Scaffold exists in the widget tree
            final scaffold = Scaffold.maybeOf(context);
            if (scaffold != null && scaffold.hasEndDrawer) {
              scaffold.openEndDrawer();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('End drawer not available!')),
              );
            }
          },
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Class Attendance Status Overview",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF494949),
              ),
            ),
            SizedBox(height: 10.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SizedBox(
                //height: 60.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Date section
                    Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          size: 20.w,
                          color: const Color(0xFF494949),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          DateFormat('EEE, dd MMM, yyyy')
                              .format(selectedDate ?? DateTime.now()),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            height: 1.5,
                            color: const Color(0xFF494949),
                          ),
                        ),
                      ],
                    ),

                    // Spacer between date and shift
                    SizedBox(width: 24.w),

                    // Shift section
                    Row(
                      children: [
                        Icon(
                          Icons.view_day_rounded,
                          size: 20.w,
                          color: const Color(0xFF494949),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          selectedShift?.split(' ')[0] ?? "Morning",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            height: 1.5,
                            color: const Color(0xFF494949),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // SelectorWidget(
            //     text: DateFormat('EEE, dd MMM, yyyy').format(selectedDate),
            //     leadingIcon: Icons.calendar_today,
            //     onTap: () {
            //       showModalBottomSheet(
            //           backgroundColor: Colors.white,
            //           context: context,
            //           isScrollControlled: true,
            //           shape: RoundedRectangleBorder(
            //             borderRadius:
            //                 BorderRadius.vertical(top: Radius.circular(20.r)),
            //           ),
            //           builder: (context) => SingleChildScrollView(
            //                 child: Container(
            //                     padding: EdgeInsets.only(
            //                       bottom:
            //                           MediaQuery.of(context).viewInsets.bottom,
            //                     ),
            //                     child: CalendarBottomSheet(
            //                       initialDate: selectedDate,
            //                       onDateSelected: (newDate) async {
            //                         setState(() {
            //                           selectedDate = newDate;
            //                           isLoading = true;
            //                         });

            //                         // Fetch attendance data for the selected date
            //                         await fetchAttendanceData(
            //                             DateFormat('yyyy-MM-dd')
            //                                 .format(newDate),
            //                             shiftValues[selectedShift] ?? '1');

            //                         setState(() {
            //                           isLoading = false;
            //                         });
            //                       },
            //                     )),
            //               ));
            //     }),
            // SizedBox(height: 16.h),
            // // SelectorWidget(
            // //     text: "Select Shift",
            // //     leadingIcon: Icons.view_day_rounded,
            // //     onTap: () {}),
            // // For the shift selector (using the new dropdown widget)
            // SelectorDropdownWidget(
            //   text: selectedShift ?? "Select Shift",
            //   leadingIcon: Icons.view_day_rounded,
            //   items: shiftOptions,
            //   onChanged: (String? newValue) async {
            //     if (newValue != null) {
            //       setState(() {
            //         selectedShift = newValue;
            //         isLoading = true;
            //       });

            //       // Fetch attendance data for the selected shift
            //       await fetchAttendanceData(
            //           DateFormat('yyyy-MM-dd').format(selectedDate),
            //           shiftValues[newValue] ?? '1');

            //       setState(() {
            //         isLoading = false;
            //       });
            //     }
            //   },
            // ),
            SizedBox(height: 10.h),
            Divider(
              indent: 10.w,
              endIndent: 10.w,
              color: Colors.grey[400],
              thickness: 1,
              height: 1.h,
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Color(0xFFED7902),
                      ))
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 24.w,
                          mainAxisSpacing: 24.h,
                        ),
                        itemCount: cardData.length,
                        itemBuilder: (context, index) {
                          final data = cardData[index];
                          final classId = data['classId'];
                          final hasAttendance = hasAttendanceMarked(classId);

                          return StatefulBuilder(
                            builder: (context, setState) {
                              return GestureDetector(
                                onTap: () async {
                                  if (!hasAttendance) {
                                    // Show snackbar if attendance not marked
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Please first mark attendance for the selected date.'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                    return;
                                  }

                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20.r)),
                                    ),
                                    context: context,
                                    builder: (context) {
                                      // Get attendance counts
                                      Map<String, int> counts =
                                          getAttendanceCounts(classId);

                                      return buildAttendanceReportBottomDrawer(
                                        data['title'],
                                        data['dt'],
                                        context,
                                        counts['present'].toString(),
                                        counts['absent'].toString(),
                                        counts['total'].toString(),
                                        classId,
                                        DateFormat('yyyy-MM-dd')
                                            .format(selectedDate),
                                      );
                                    },
                                  );
                                },
                                child:
                                    Stack(clipBehavior: Clip.none, children: [
                                  AnimatedContainer(
                                    width: double.infinity,
                                    duration: const Duration(milliseconds: 300),
                                    decoration: BoxDecoration(
                                      color: isToggled[index]
                                          ? Color(0xFF33CC99)
                                          : const Color(0xFFED7902),
                                      border: Border.all(
                                          color: const Color(0xFFE2E2E2),
                                          width: 1.w),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 40.w,
                                          height: 1.h,
                                          color: Colors.white,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 4.h),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          data['title'].toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Container(
                                          width: 40.w,
                                          height: 1.h,
                                          color: Colors.white,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 4.h),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: -9.h,
                                    right: 4.w,
                                    child: Container(
                                      height: 18.h,
                                      width: 18.w,
                                      decoration: BoxDecoration(
                                        color: hasAttendance
                                            ? Color(0xFF00BFFF)
                                            : Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 1.w),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          hasAttendance
                                              ? Icons.check
                                              : Icons.error,
                                          color: hasAttendance
                                              ? Colors.white
                                              : Colors.red,
                                          size: 18.r,
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                              );
                            },
                          );
                        },
                      ),
              ),
            ),

            SizedBox(height: 30.h),
            Divider(
              indent: 10.w,
              endIndent: 10.w,
              color: Colors.grey[400],
              thickness: 1,
              height: 1.h,
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.only(bottom: 5.h),
              child: TextButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  _showFilterDialog();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFED7902),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    side: BorderSide(color: Colors.grey.shade100, width: 1.0),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  "Change Date/Shift",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget buildAttendanceReportBottomDrawer(
    String className,
    String dateTime,
    BuildContext context,
    String presentCount,
    String absentCount,
    String totalCount,
    int classId,
    String selectedDate) {
  return ClipRRect(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(27.r),
      topRight: Radius.circular(27.r),
    ),
    child: Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.date_range, color: Color(0xFF494949), size: 20.r),
                  SizedBox(width: 5.w),
                  Text(
                    dateTime.split(' ')[0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: Color(0xFF494949),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Icon(Icons.class_outlined,
              //         color: Color(0xFFED7902), size: 20.r),
              //     SizedBox(width: 5.w),
              //     Text(
              //       className,
              //       style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         fontSize: 16.sp,
              //         color: Color(0xFFED7902),
              //       ),
              //       textAlign: TextAlign.center,
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.access_time_rounded,
                      color: Color(0xFF494949), size: 20.r),
                  SizedBox(width: 5.w),
                  Text(
                    '${dateTime.split(' ')[1]} ${dateTime.split(' ')[2]}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: Color(0xFF494949),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
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
          SizedBox(height: 15.h),
          Container(
            width: 90.w,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Color(0xFFED7902),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white70, width: 2.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.class_outlined, color: Colors.white, size: 20.r),
                SizedBox(width: 5.w),
                Text(
                  className,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),
          Divider(
            indent: 20.w,
            endIndent: 20.w,
            color: Colors.grey[400],
            thickness: 1,
            height: 1.h,
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // First Card - Present
              GestureDetector(
                onTap: () async {
                  // Fetch students for the selected class
                  fetchStudents(
                      'Present',
                      context,
                      classId.toString(),
                      selectedDate,
                      className,
                      dateTime,
                      int.parse(presentCount),
                      int.parse(absentCount));
                },
                child: _buildCard(
                  color: Color(0xFFF5F5F7),
                  borderColor: Color(0xFF33CC99),
                  shadowColor: Colors.black.withOpacity(0.25),
                  number: presentCount,
                  label: "Present",
                  textColor: Color(0xFF33CC99),
                ),
              ),

              SizedBox(width: 21.w), // Space between cards
              // Second Card - Absent
              GestureDetector(
                onTap: () async {
                  // Fetch students for the selected class
                  fetchStudents(
                      'Absent',
                      context,
                      classId.toString(),
                      selectedDate,
                      className,
                      dateTime,
                      int.parse(presentCount),
                      int.parse(absentCount));
                },
                child: _buildCard(
                  color: Color(0xFFF5F5F7),
                  borderColor: Color(0xFFDD3E2B),
                  shadowColor: Colors.black.withOpacity(0.25),
                  number: absentCount,
                  label: "Absent",
                  textColor: Color(0xFFDD3E2B),
                ),
              ),

              SizedBox(width: 21.w), // Space between cards
              // Third Card - Total
              GestureDetector(
                onTap: () async {
                  // Fetch students for the selected class
                  fetchStudents(
                      'All',
                      context,
                      classId.toString(),
                      selectedDate,
                      className,
                      dateTime,
                      int.parse(presentCount),
                      int.parse(absentCount));
                },
                child: _buildCard(
                  color: Color(0xFFF5F5F7),
                  borderColor: Color(0xFFFBCB99),
                  shadowColor: Colors.black.withOpacity(0.25),
                  number: totalCount,
                  label: "Total",
                  textColor: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Divider(
            indent: 20.w,
            endIndent: 20.w,
            color: Colors.grey[400],
            thickness: 1,
            height: 1.h,
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cancel Button
              CustomActionButton(
                text: 'Cancel',
                backgroundColor: const Color(0xFFF5F5F5),
                textColor: Color(0xFF494949),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(width: 9.w),

              // Submit Button
              CustomActionButton(
                text: 'Open List',
                backgroundColor: const Color(0xFFED7902),
                textColor: Colors.white,
                onPressed: () async {
                  // Fetch students for the selected class
                  fetchStudents(
                      'All',
                      context,
                      classId.toString(),
                      selectedDate,
                      className,
                      dateTime,
                      int.parse(presentCount),
                      int.parse(absentCount));
                  ;
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void fetchStudents(
    String filter,
    BuildContext context,
    String classId,
    String selectedDate,
    String className,
    String dateTime,
    int presentCount,
    int absentCount) async {
  startShowing(context);

  try {
    // Get the class ID from the current card data

    // Fetch data using your provided function
    final data = await ClassStudentRepo()
        .fetchTestClassStudentData(classId, selectedDate);

    // Stop showing loading indicator
    stopShowing(context);

    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      context: context,
      builder: (context) {
        Map<int, String> students = {};
        Map<int, bool> attendance = {};
        Map<int, int> gender = {};

        // Loop through students array and build the required maps
        for (var student in data['students']) {
          int rollNo = student['roll_no'];
          students[rollNo] = student['name'];
          // att_status 1 = present, 2 = absent
          attendance[rollNo] = student['att_status'] == 1;
          gender[rollNo] = student['gender'];
        }

        return ClassAttendanceBottomSheetDrawer(
          students: students,
          attendance: attendance,
          gender: gender,
          className: className,
          dateTime: dateTime,
          filter: filter,
          totalPresent: presentCount,
          totalAbsent: absentCount,
        );
      },
    );
  } catch (e) {
    // Stop showing loading indicator in case of error
    stopShowing(context);

    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error fetching student data: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
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
    width: 90.w,
    height: 94.h,
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
        //SizedBox(height: 4.h),
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

class ClassAttendanceBottomSheetDrawer extends StatefulWidget {
  final Map<int, String> students; // Roll No -> Name
  final Map<int, bool> attendance; // Roll No -> Present (true/false)
  final Map<int, int> gender; // Roll No -> Gender ID (1 for male, 2 for female)
  final String className;
  final String dateTime;
  final int totalPresent;
  final int totalAbsent;
  final String filter;

  const ClassAttendanceBottomSheetDrawer({
    super.key,
    required this.students,
    required this.attendance,
    required this.gender,
    required this.className,
    required this.dateTime,
    required this.totalPresent,
    required this.totalAbsent,
    this.filter = 'All',
  });

  @override
  State<ClassAttendanceBottomSheetDrawer> createState() =>
      _ClassAttendanceBottomSheetDrawerState();
}

class _ClassAttendanceBottomSheetDrawerState
    extends State<ClassAttendanceBottomSheetDrawer> {
  late String selectedFilter;
  late Map<int, String> filteredStudents;

  @override
  void initState() {
    super.initState();
    // Initialize filteredStudents with all students
    setState(() {
      selectedFilter = widget.filter;
    });

    applyFilters();
  }

  void applyFilters() {
    setState(() {
      filteredStudents = {};
      widget.students.forEach((rollNo, name) {
        bool isPresent = widget.attendance[rollNo] ?? false;

        // Apply the filter
        if (selectedFilter == 'All' ||
            (selectedFilter == 'Present' && isPresent) ||
            (selectedFilter == 'Absent' && !isPresent)) {
          filteredStudents[rollNo] = name;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(27.r),
        topRight: Radius.circular(27.r),
      ),
      child: Container(
        height: 600.h,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Icon(Icons.class_outlined,
                //         color: Color(0xFFED7902), size: 20.r),
                //     SizedBox(width: 5.w),
                //     Text(
                //       widget.className,
                //       style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 16.sp,
                //         color: Color(0xFFED7902),
                //       ),
                //       textAlign: TextAlign.center,
                //     ),
                //   ],
                // ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.date_range,
                        color: Color(0xFF494949), size: 20.r),
                    SizedBox(width: 5.w),
                    Text(
                      widget.dateTime.split(' ')[0],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Color(0xFF494949),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time_rounded,
                        color: Color(0xFF494949), size: 20.r),
                    SizedBox(width: 5.w),
                    Text(
                      '${widget.dateTime.split(' ')[1]} ${widget.dateTime.split(' ')[2]}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Color(0xFF494949),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
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
            SizedBox(height: 15.h),
            Container(
              width: 90.w,
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Color(0xFFED7902), // Light orange background color
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white70, width: 2.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Make row wrap its content
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.class_outlined, color: Colors.white, size: 20.r),
                  SizedBox(width: 5.w),
                  Text(
                    widget.className,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Icon(Icons.class_outlined,
            //         color: Color(0xFFED7902), size: 20.r),
            //     SizedBox(width: 5.w),
            //     Text(
            //       widget.className,
            //       style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //         fontSize: 16.sp,
            //         color: Color(0xFFED7902),
            //       ),
            //       textAlign: TextAlign.center,
            //     ),
            //   ],
            // ),
            // Divider(
            //   // indent: 20.w,
            //   // endIndent: 20.w,
            //   color: Colors.grey[400],
            //   thickness: 1,
            //   height: 1.h,
            // ),
            SizedBox(height: 15.h),
            Divider(
              indent: 20.w,
              endIndent: 20.w,
              color: Colors.grey[400],
              thickness: 1,
              height: 1.h,
            ),
            SizedBox(height: 15.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterOption('All', '(${widget.students.length})'),
                SizedBox(width: 15.w),
                _buildFilterOption('Present', '(${widget.totalPresent})'),
                SizedBox(width: 15.w),
                _buildFilterOption('Absent', '(${widget.totalAbsent})'),
              ],
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   spacing: 25.w,
            //   children: ['All', 'Present', 'Absent']
            //       .map((filter) => GestureDetector(
            //           onTap: () {
            //             setState(() {
            //               selectedFilter = filter;
            //               //onFilterSelected(selectedFilter);
            //             });
            //             applyFilters();
            //           },
            //           child: Row(
            //             children: [
            //               Container(
            //                 width: 18.w,
            //                 height: 18.h,
            //                 decoration: BoxDecoration(
            //                   border: Border.all(
            //                     color: selectedFilter == filter
            //                         ? const Color(0xFFED7902)
            //                         : const Color(0xFF969AB8),
            //                     width: 1,
            //                   ),
            //                   borderRadius: BorderRadius.circular(13.r),
            //                 ),
            //                 child: selectedFilter == filter
            //                     ? Center(
            //                         child: Container(
            //                           width: 12.w,
            //                           height: 12.h,
            //                           decoration: const BoxDecoration(
            //                             shape: BoxShape.circle,
            //                             color: Color(0xFFED7902),
            //                           ),
            //                         ),
            //                       )
            //                     : null,
            //               ),
            //               SizedBox(width: 2.w),
            //               Text(
            //                 filter,
            //                 style: TextStyle(
            //                   fontSize: 14.sp,
            //                   fontWeight: FontWeight.bold,
            //                   color: Color(0xFF1E1E1E),
            //                 ),
            //               ),
            //             ],
            //           )))
            //       .toList(),
            // ),

            SizedBox(
              height: 15.h,
            ),
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
                  final studentGender = widget.gender[rollNo] == 1
                      ? "male"
                      : "female"; // Assuming 1 for male and 2 for female
                  final isPresent = widget.attendance[rollNo] ?? false;
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
                                color:
                                    isPresent ? Color(0xFF00BFFF) : Colors.red,
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

            Divider(
              color: Colors.grey[400],
              thickness: 2,
              height: 1.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String filter, String countText) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = filter;
        });
        applyFilters();
      },
      child: Row(
        children: [
          Container(
            width: 18.w,
            height: 18.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedFilter == filter
                    ? const Color(0xFFED7902)
                    : const Color(0xFF969AB8),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: selectedFilter == filter
                ? Center(
                    child: Container(
                      width: 12.w,
                      height: 12.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFED7902),
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: 2.w),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: filter,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                TextSpan(
                  text: ' $countText',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF494949),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


//   Future<void> load() async {
//     setState(() {
//       isLoading = true;
//     });

//     // final cls = await stRepo.getAllClasses();

//     // cardData = cls;

//     // isToggled = List.filled(cls.length, false);
//     await fetchAttendanceData(DateFormat('yyyy-MM-dd').format(selectedDate));

//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<void> fetchAttendanceData(String date) async {
//     try {
//       final apiData = await stRepo.fetchClassAttendanceReport('', date);

//       // Clear previous data
//       attendanceData.clear();
//       cardData.clear();

//       // Process the API response
//       for (var item in apiData) {
//         int classId = item['class_id'];
//         String className = item['class_name'];
//         String? att = item['att'];

//         // Store the attendance data
//         attendanceData[classId] = {
//           'className': className,
//           'att': att,
//           'hasAttendance': att != null
//         };

//         // Add to card data for displaying classes
//         cardData.add({
//           'classId': classId,
//           'title': className
//         });
//       }

//       // Initialize toggle state for all classes
//       isToggled = List.filled(cardData.length, false);

//     } catch (e) {
//       print("Error fetching attendance data: $e");
//     }
//   }

//   // Get attendance status for a class
//   bool hasAttendanceMarked(int classId) {
//     return attendanceData[classId]?.['hasAttendance'] ?? false;
//   }

//   // Parse attendance data to get counts
//   Map<String, int> getAttendanceCounts(int classId) {
//     Map<String, int> counts = {
//       'present': 0,
//       'absent': 0,
//       'total': 0
//     };

//     String? att = attendanceData[classId]?.['att'];
//     if (att != null && att.isNotEmpty) {
//       List<String> parts = att.split(',');
//       if (parts.length >= 3) {
//         counts['present'] = int.tryParse(parts[0]) ?? 0;
//         counts['absent'] = int.tryParse(parts[1]) ?? 0;
//         counts['total'] = int.tryParse(parts[2]) ?? 0;
//       }
//     }

//     return counts;
//   }

//   Future<void> fetchAndLoadStudents(
//       StudentViewModel viewModel, String classId) async {
//     try {
//       final jsonData =
//           await stRepo.fetchAllStudents(classId); // Await the result
//       Log.d(jsonData);
//       viewModel.loadStudents(
//           jsonData); // Now, jsonData contains the resolved API response
//     } catch (e) {
//       print("Error fetching students: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<StudentViewModel>(context);

//     // if(viewModel.cardData.isNotEmpty){
//     //   viewModel.cardData.clear();
//     // }

//     viewModel.cardData = cardData;
//     return BaseScreen(
//       resize: true,
//       trailing: Builder(
//         builder: (context) => IconButton(
//           icon: Icon(Icons.account_tree, color: Colors.white),
//           onPressed: () {
//             HapticFeedback.mediumImpact();

//             // Ensure the Scaffold exists in the widget tree
//             final scaffold = Scaffold.maybeOf(context);
//             if (scaffold != null && scaffold.hasEndDrawer) {
//               scaffold.openEndDrawer();
//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('End drawer not available!')),
//               );
//             }
//           },
//         ),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16.r),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               "Class Attendance Status Overview",
//               style: TextStyle(
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF494949),
//               ),
//             ),
//             SizedBox(height: 16.h),
//             SelectorWidget(
//                 text: selectedDate != null
//                     ? DateFormat('EEE, dd MMM, yyyy').format(selectedDate!)
//                     : "Select Date",
//                 leadingIcon: Icons.calendar_today,
//                 onTap: () {
//                   showModalBottomSheet(
//                       backgroundColor: Colors.white,
//                       context: context,
//                       isScrollControlled: true,
//                       shape: RoundedRectangleBorder(
//                         borderRadius:
//                             BorderRadius.vertical(top: Radius.circular(20.r)),
//                       ),
//                       builder: (context) => SingleChildScrollView(
//                             child: Container(
//                                 padding: EdgeInsets.only(
//                                   bottom:
//                                       MediaQuery.of(context).viewInsets.bottom,
//                                 ),
//                                 child: CalendarBottomSheet(
//                                   initialDate: DateTime.now(),
//                                   onDateSelected: (selectedDate) {
//                                     // viewModel.date = selectedDate;
//                                     // Update the ViewModel with the selected date
//                                     setState(() {
//                                       this.selectedDate = selectedDate;
//                                     });
//                                   },
//                                 )),
//                           ));
//                 }),
//             SizedBox(height: 16.h),
//             SelectorWidget(
//                 text: "Select Shift",
//                 leadingIcon: Icons.view_day_rounded,
//                 onTap: () {}),
//             SizedBox(height: 16.h),
//             Padding(
//               padding: EdgeInsets.all(16.r),
//               child: isLoading
//                   ? Center(
//                       child: CircularProgressIndicator(
//                       color: Color(0xFFED7902),
//                     ))
//                   : GridView.builder(
//                       shrinkWrap: true,
//                       physics:
//                           AlwaysScrollableScrollPhysics(), // Prevents inner scrolling
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 4, // Three cards per row
//                         crossAxisSpacing: 24.w, // Spacing between columns
//                         mainAxisSpacing: 24.h, // Spacing between rows
//                         //childAspectRatio: 80 / 77, // Card width-to-height ratio
//                       ),
//                       itemCount: cardData.length,
//                       itemBuilder: (context, index) {
//                         List<bool> isToggled =
//                             List.filled(cardData.length, false);
//                         final data = cardData[index];
//                         return StatefulBuilder(
//                           builder: (context, setState) {
//                             // To track card color state
//                             return GestureDetector(
//                               onTap: () async {
//                                 // startShowing(context);
//                                 // setState(() {
//                                 //   isToggled[index] = isToggled[index];
//                                 // });
//                                 // await Future.delayed(
//                                 //     const Duration(milliseconds: 80));

//                                 // Log.d(data['title']);

//                                 // viewModel.setClassName(data['title']);

//                                 // // final id = await StudentRepository.classDao.getClassIdByName(data['title'].replaceAll(" ", "-"));

//                                 // //fetchAndLoadStudents(viewModel, data['classId'].toString());

//                                 // stopShowing(context);

//                                 // setState(() {
//                                 //   isToggled[index] = isToggled[index];
//                                 // });

//                                 // Navigator.push(
//                                 //   context,
//                                 //   MaterialPageRoute(
//                                 //     builder: (context) => StudentListScreen(
//                                 //       title: data['title'],
//                                 //       count: data['count'],
//                                 //       label: data['label'],
//                                 //       classId: data['classId'].toString(),
//                                 //     ),
//                                 //   ),
//                                 // );
//                                 showModalBottomSheet(
//                                   isScrollControlled: true,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.vertical(
//                                         top: Radius.circular(20.r)),
//                                   ),
//                                   context: context,
//                                   builder: (context) {
//                                     return buildAttendanceReportBottomDrawer(
//                                         data['title'].replaceAll("-", " "),
//                                         context);
//                                   },
//                                 );
//                               },
//                               child: Stack(
//                                   clipBehavior: Clip
//                                       .none, // Important to allow children to overflow
//                                   children: [
//                                     AnimatedContainer(
//                                       width: double.infinity,
//                                       duration:
//                                           const Duration(milliseconds: 300),
//                                       decoration: BoxDecoration(
//                                         color: isToggled[index]
//                                             ? Color(0xFF33CC99)
//                                             : const Color(0xFFED7902),
//                                         border: Border.all(
//                                             color: const Color(0xFFE2E2E2),
//                                             width: 1.w),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color:
//                                                 Colors.black.withOpacity(0.25),
//                                             offset: const Offset(0, 2),
//                                             blurRadius: 4,
//                                             spreadRadius: 1,
//                                           ),
//                                         ],
//                                         borderRadius:
//                                             BorderRadius.circular(5.r),
//                                       ),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Container(
//                                             width: 40.w, // Line width
//                                             height: 1.h, // Line height
//                                             color: Colors.white, // Line color
//                                             margin: EdgeInsets.symmetric(
//                                                 vertical: 4.h),
//                                           ),
//                                           SizedBox(height: 4.h),
//                                           Text(
//                                             cardData[index]['title']
//                                                 .toString()
//                                                 .replaceAll(' ', '-'),
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 24.sp,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                           SizedBox(height: 4.h),
//                                           Container(
//                                             width: 40.w, // Line width
//                                             height: 1.h, // Line height
//                                             color: Colors.white, // Line color
//                                             margin: EdgeInsets.symmetric(
//                                                 vertical: 4.h),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     if (Random().nextBool()) ...[
//                                       // Randomly show for testing
//                                       Positioned(
//                                         top: -9
//                                             .h, // Position half outside (-9 puts half outside for an 18 size icon)
//                                         right:
//                                             4.w, // 10 units from the right edge
//                                         child: Container(
//                                           height: 18.h,
//                                           width: 18.w,
//                                           decoration: BoxDecoration(
//                                             color: Color(
//                                                 0xFF533DDC), // Randomly blue or red
//                                             shape: BoxShape.circle,
//                                             border: Border.all(
//                                                 color: Colors.white,
//                                                 width: 1.w),
//                                           ),
//                                           child: Center(
//                                             child: Icon(
//                                               Icons.check,
//                                               // Check or pending icon
//                                               color: Colors.white,
//                                               size: 18
//                                                   .r, // Icon slightly smaller than container
//                                             ),
//                                           ),
//                                         ),
//                                       )
//                                     ] else ...[
//                                       Positioned(
//                                         top: -9
//                                             .h, // Position half outside (-9 puts half outside for an 18 size icon)
//                                         right:
//                                             4.w, // 10 units from the right edge
//                                         child: Container(
//                                           height: 18.h,
//                                           width: 18.w,
//                                           decoration: BoxDecoration(
//                                             color: Colors
//                                                 .white, // Randomly blue or red
//                                             shape: BoxShape.circle,
//                                             border: Border.all(
//                                                 color: Colors.white,
//                                                 width: 1.w),
//                                           ),
//                                           child: Center(
//                                             child: Icon(
//                                               Icons
//                                                   .error, // Check or pending icon
//                                               color: Colors.red,
//                                               size: 18
//                                                   .r, // Icon slightly smaller than container
//                                             ),
//                                           ),
//                                         ),
//                                       )
//                                     ]
//                                   ]),
//                             );
//                           },
//                         );
//                       },
//                     ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

