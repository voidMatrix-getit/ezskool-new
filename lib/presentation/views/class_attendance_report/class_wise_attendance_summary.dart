import 'package:ezskool/core/services/logger.dart';
import 'package:ezskool/data/repo/student_repo.dart';
import 'package:ezskool/presentation/views/class_attendance/new_class_attendance_home_screen.dart';
import 'package:ezskool/presentation/widgets/custom_buttons.dart';
import 'package:ezskool/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:intl/intl.dart';
import 'class_attendance_status.dart';
// Adjust import path as needed

class ClasswiseAttendanceSummaryScreen extends StatefulWidget {
  const ClasswiseAttendanceSummaryScreen({Key? key}) : super(key: key);

  @override
  State<ClasswiseAttendanceSummaryScreen> createState() =>
      _ClasswiseAttendanceSummaryScreenState();
}

class _ClasswiseAttendanceSummaryScreenState
    extends State<ClasswiseAttendanceSummaryScreen> {
  // late List<AttendanceData> attendanceData;
  //DateTime? selectedDate;

  List<AttendanceData> attendanceData = [];
  final stRepo = StudentRepository();
  bool isLoading = true;
  bool isLoadingMain = false;

  // Date and shift management
  DateTime? selectedDate;
  String? formattedDate;
  String? selectedShift;
  final List<String> shiftOptions = ['Morning Shift', 'Evening Shift'];
  final Map<String, String> shiftValues = {
    'Morning Shift': '1',
    'Evening Shift': '2',
  };

  @override
  void initState() {
    super.initState();
    // Initialize the attendance data

    //selectedShift = shiftOptions[0];

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
              initialDate: selectedDate ?? DateTime.now(),
              onDateSelected: (newDate) {
                setState(() {
                  selectedDate = newDate;
                  formattedDate =
                      DateFormat('EEE, dd MMM, yyyy').format(selectedDate!);
                });
                // Reopen the filter dialog after date selection

                //Navigator.pop(context);

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showFilterDialog();
                });
              },
            ),
          ),
        ),
      );
    });

    // attendanceData = _getMockData();
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
                  text: formattedDate ?? 'Select Date',
                  leadingIcon: Icons.date_range,
                  onTap: () {
                    Navigator.pop(context);
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
                                    .format(selectedDate!);
                              });
                              // Reopen the filter dialog after date selection

                              WidgetsBinding.instance.addPostFrameCallback((_) {
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
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: 9.w),

                    // Submit Button
                    CustomActionButton(
                      text: 'Apply',
                      backgroundColor: const Color(0xFFED7902),
                      textColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          isLoadingMain = true;
                        });
                        // startShowing(context);
                        fetchAttendanceData(
                            DateFormat('yyyy-MM-dd').format(selectedDate!),
                            shiftValues[selectedShift] ?? '1');
                        // stopShowing(context);
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

  Future<void> fetchAttendanceData(String date, String shift) async {
    setState(() {
      isLoading = true;
    });

    try {
      final apiData = await stRepo.fetchClassAttendanceReport(shift, date);

      Log.d(apiData);

      List<AttendanceData> newData = [];

      // Process the API response
      for (var item in apiData) {
        int classId = item['class_id'];
        String className = item['class_name'];
        String? att = item['att'];

        // Parse attendance data if available
        int present = 0;
        int absent = 0;
        int total = 0;

        if (att != null && att.isNotEmpty) {
          List<String> parts = att.split(',');
          if (parts.length >= 3) {
            present = int.tryParse(parts[0]) ?? 0;
            absent = int.tryParse(parts[1]) ?? 0;
            total = int.tryParse(parts[2]) ?? 0;
          }
        }

        newData.add(AttendanceData(
          className: className,
          present: att != null ? present : -1,
          absent: att != null ? absent : -1,
          total: att != null ? total : -1,
        ));
      }

      setState(() {
        attendanceData = newData;
        isLoading = false;
        isLoadingMain = false;
      });
    } catch (e) {
      setState(() {
        attendanceData = [];
        isLoading = false;
        isLoadingMain = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading attendance data: No classes found"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );

      setState(() {
        attendanceData = [];
        isLoading = false;
      });
    }
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
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 15.h),
              Text(
                "Class-Wise Attendance Summary",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF494949),
                ),
              ),
              SizedBox(height: 15.h),
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
                            color: const Color(0xFFB8BCCA),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            DateFormat('EEE, dd MMM, yyyy')
                                .format(selectedDate ?? DateTime.now()),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              height: 1.5,
                              color: const Color(0xFF969AB8),
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
                            color: const Color(0xFFB8BCCA),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            selectedShift?.split(' ')[0] ?? "Morning",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              height: 1.5,
                              color: const Color(0xFF969AB8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              SizedBox(
                child: isLoadingMain
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Color(0xFFED7902),
                      ))
                    : ClassAttendanceSummary(
                        attendanceData: attendanceData,
                      ),
              ),
              if (isLoading || attendanceData.isEmpty) ...[
                SizedBox(height: 540.h),
              ] else ...[
                SizedBox(height: 2.h),
              ],
              TextButton(
                onPressed: _showFilterDialog,
                child: Text(
                  "Change Date/Shift",
                  style: TextStyle(
                    color: Color(0xFFED7902),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Mock data for demonstration
  List<AttendanceData> _getMockData() {
    return [
      AttendanceData(className: '1 A', present: 45, absent: 5, total: 50),
      AttendanceData(className: '1 B', present: 50, absent: 2, total: 52),
      AttendanceData(className: '2 A', present: 52, absent: 4, total: 56),
      AttendanceData(className: '2 B', present: 48, absent: 7, total: 55),
      AttendanceData(className: '3 A', present: 49, absent: 1, total: 50),
      AttendanceData(className: '3 B', present: 46, absent: 4, total: 50),
      AttendanceData(className: '4 A', present: 46, absent: 4, total: 50),
      AttendanceData(className: '4 B', present: 45, absent: 5, total: 50),
      AttendanceData(className: '5 A', present: 50, absent: 2, total: 52),
      AttendanceData(className: '5 B', present: 52, absent: 4, total: 56),
      AttendanceData(className: '6 A', present: 48, absent: 7, total: 55),
    ];
  }
}

class ClassAttendanceSummary extends StatelessWidget {
  final List<AttendanceData> attendanceData;

  const ClassAttendanceSummary({
    Key? key,
    required this.attendanceData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 348.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: const Color(0xFFDADADA), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Add this to prevent unbounded height
        children: [
          _buildHeader(),
          _buildTable(), // Remove the Expanded wrapper
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 38.h,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFDADADA), width: 0.6),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell('Class', flex: 1),
          _buildVerticalDivider(),
          _buildHeaderCell('Present', flex: 1),
          _buildVerticalDivider(),
          _buildHeaderCell('Absent', flex: 1),
          _buildVerticalDivider(),
          _buildHeaderCell('Total', flex: 1),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2400FF),
          ),
        ),
      ),
    );
  }

  Widget _buildTable() {
    return Column(
      mainAxisSize: MainAxisSize.min, // Add this to prevent unbounded height
      children: List.generate(
        attendanceData.length,
        (index) => _buildTableRow(attendanceData[index], index),
      ),
    );
  }

  Widget _buildTableRow(AttendanceData data, int index) {
    return Container(
      height: 42.h,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFFDADADA), width: 0.6),
        ),
      ),
      child: Row(
        children: [
          _buildTableCell(
            data.className.replaceAll('-', ' '),
            flex: 1,
          ),
          _buildVerticalDivider(),
          _buildTableCell(
            data.present == -1 ? '-' : data.present.toString(),
            flex: 1,
            textColor: const Color(0xFF0AB331),
          ),
          _buildVerticalDivider(),
          _buildTableCell(
            data.absent == -1 ? '-' : data.absent.toString(),
            flex: 1,
            textColor: const Color(0xFFF34235),
          ),
          _buildVerticalDivider(),
          _buildTableCell(
            data.total == -1 ? '-' : data.total.toString(),
            flex: 1,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildTableCell(
    String text, {
    required int flex,
    Color? textColor,
    FontWeight fontWeight = FontWeight.w500,
    Alignment alignment = Alignment.center,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: padding,
        alignment: alignment,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: fontWeight,
            color: textColor ?? const Color(0xFF1E1E1E),
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 0.6,
      color: const Color(0xFFDADADA),
    );
  }
}

class AttendanceData {
  final String className;
  final int present;
  final int absent;
  final int total;

  AttendanceData({
    required this.className,
    required this.present,
    required this.absent,
    required this.total,
  });
}




  // @override
  // Widget build(BuildContext context) {
  //   return BaseScreen(
  //     child: SingleChildScrollView(
  //       child: Column(
  //         children: [
  //           // Your other widgets will go here
  //           SizedBox(height: 20.h),
  //           ClassAttendanceSummary(
  //             attendanceData: attendanceData,
  //           ),
  //           SizedBox(height: 20.h),
  //         ],
  //       ),
  //     ),
  //   );
  // }


// Container(
              //   padding: EdgeInsets.symmetric(horizontal: 20.w),
              //   width: double.infinity,
              //   height: 60.h,
              //   child: Stack(
              //     children: [
              //       // Date calendar icon
              //       Positioned(
              //         left: 50.w,
              //         top: 151.h - 130.h,
              //         child: Icon(
              //           Icons.calendar_today,
              //           size: 20.w,
              //           color: const Color(0xFFB8BCCA),
              //         ),
              //       ),

              //       // Date text
              //       Positioned(
              //         left: MediaQuery.of(context).size.width / 2 -
              //             82.w / 2 -
              //             66.5.w,
              //         top: 152.h - 130.h,
              //         child: Text(
              //           DateFormat('EEE, dd MMM, yyyy')
              //               .format(selectedDate ?? DateTime.now()),
              //           style: TextStyle(
              //             fontWeight: FontWeight.w500,
              //             fontSize: 14.sp,
              //             height: 1.5,
              //             textBaseline: TextBaseline.alphabetic,
              //             color: const Color(0xFF969AB8),
              //           ),
              //         ),
              //       ),

              //       // Shift text
              //       Positioned(
              //         left: MediaQuery.of(context).size.width / 2 -
              //             59.w / 2 +
              //             86.w,
              //         top: 151.h - 130.h,
              //         child: Text(
              //           selectedShift?.split(' ')[0] ?? "Morning",
              //           style: TextStyle(
              //             fontWeight: FontWeight.w500,
              //             fontSize: 14.sp,
              //             height: 1.5,
              //             textBaseline: TextBaseline.alphabetic,
              //             color: const Color(0xFF969AB8),
              //           ),
              //         ),
              //       ),

              //       // Shift icon
              //       Positioned(
              //         left: MediaQuery.of(context).size.width * 0.5493,
              //         top: 151.h - 130.h,
              //         child: Icon(
              //           Icons.view_day_rounded,
              //           size: 20.w,
              //           color: const Color(0xFFB8BCCA),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SelectorWidget(
              //     text: selectedDate != null
              //         ? DateFormat('EEE, dd MMM, yyyy').format(selectedDate!)
              //         : "Select Date",
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
              //                       bottom: MediaQuery.of(context)
              //                           .viewInsets
              //                           .bottom,
              //                     ),
              //                     child: CalendarBottomSheet(
              //                       initialDate: DateTime.now(),
              //                       onDateSelected: (selectedDate) {
              //                         // viewModel.date = selectedDate;
              //                         // Update the ViewModel with the selected date
              //                         setState(() {
              //                           this.selectedDate = selectedDate;
              //                         });
              //                       },
              //                     )),
              //               ));
              //     }),
              // SizedBox(height: 15.h),
              // SelectorWidget(
              //     text: "Select Shift",
              //     leadingIcon: Icons.view_day_rounded,
              //     onTap: () {}),
