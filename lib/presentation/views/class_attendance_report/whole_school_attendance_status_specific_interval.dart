import 'package:ezskool/core/services/logger.dart';
import 'package:ezskool/data/repo/student_repo.dart';
import 'package:ezskool/data/viewmodels/class_attendance/class_attendance_home_viewmodel.dart';
import 'package:ezskool/data/viewmodels/class_attendance/student_listing_viewmodel.dart';
import 'package:ezskool/presentation/widgets/custom_buttons.dart';
import 'package:ezskool/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../drawers/calendar_bottom_drawer.dart';
import 'class_attendance_status.dart';
// Adjust import path as needed

class WholeSchoolAttendanceStatusSpecificIntervalScreen extends StatefulWidget {
  const WholeSchoolAttendanceStatusSpecificIntervalScreen({super.key});

  @override
  State<WholeSchoolAttendanceStatusSpecificIntervalScreen> createState() =>
      _WholeSchoolAttendanceStatusSpecificIntervalScreenState();
}

class _WholeSchoolAttendanceStatusSpecificIntervalScreenState
    extends State<WholeSchoolAttendanceStatusSpecificIntervalScreen> {
  // late List<AttendanceData> attendanceData;
  //DateTime? selectedDate;

  //List<AttendanceData> attendanceData = [];
  final stRepo = StudentRepository();
  bool isLoading = true;
  bool isLoadingMain = false;

  // Date and shift management
  DateTime? selectedDate;
  String? formattedDate;

  DateTime? selectedDateFrom;
  DateTime? selectedDateTo;
  String? formattedDateFrom;
  String? formattedDateTo;

  String? selectedCls;
  String? selectedShift;
  final List<String> shiftOptions = ['Morning Shift', 'Evening Shift'];
  final Map<String, String> shiftValues = {
    'Morning Shift': '1',
    'Evening Shift': '2',
  };

  int? selectedClassId;
  List<Map<String, dynamic>> cardData = [];
  int? classId;

  List<DateAttendanceData> dateAttendanceData = [];
  bool isLoadingReport = false;

  @override
  void initState() {
    super.initState();
    // Initialize the attendance data

    //selectedShift = shiftOptions[0];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      openCalFrom();
    });

    // attendanceData = _getMockData();
  }

  Future<void> fetchWholeSchoolAttendanceReport() async {
    if (selectedDateFrom == null || selectedDateTo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select both start and end dates"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoadingReport = true;
    });

    final dateFrom = DateFormat('yyyy-MM-dd').format(selectedDateFrom!);
    final dateTo = DateFormat('yyyy-MM-dd').format(selectedDateTo!);
    final shiftId = shiftValues[selectedShift] ?? '1';

    try {
      final apiData = await stRepo.fetchWholeSchoolAttendanceReport(
          dateFrom, dateTo, shiftId);

      List<DateAttendanceData> newData = [];

      for (var item in apiData) {
        String date = item['date'];
        List<ShiftAttendance> shiftAttendanceList = [];

        for (var shiftData in item['att']) {
          if (shiftData['shift_id'].toString() == shiftId) {
            String att = shiftData['att'];
            List<String> parts = att.split(',');

            int present = 0;
            int absent = 0;
            int total = 0;

            if (parts.length >= 3) {
              present = int.tryParse(parts[0]) ?? 0;
              absent = int.tryParse(parts[1]) ?? 0;
              total = int.tryParse(parts[2]) ?? 0;
            }

            shiftAttendanceList.add(ShiftAttendance(
                shiftId: shiftData['shift_id'],
                shiftName: shiftData['shift'],
                present: present,
                absent: absent,
                total: total));
          }
        }

        //Only add dates that have attendance data (not 0,0,0)
        if (shiftAttendanceList.isNotEmpty) {
          newData.add(DateAttendanceData(
              date: DateFormat('dd-MM-yyyy').format(DateTime.parse(date)),
              shiftAttendance: shiftAttendanceList));
        }
      }

      setState(() {
        dateAttendanceData = newData;
        isLoadingReport = false;
        isLoading = false;
        isLoadingMain = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading attendance data: ${e.toString()}"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );

      setState(() {
        dateAttendanceData = [];
        isLoadingReport = false;
        isLoading = false;
        isLoadingMain = false;
      });
    }
  }

  void openCalFrom({bool isOnly = false}) {
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
            hintText: 'Select Starting Date',
            initialDate: selectedDateFrom ?? DateTime.now(),
            onDateSelected: (newDate) {
              setState(() {
                selectedDateFrom = newDate;
                formattedDateFrom =
                    DateFormat('dd-MM-yyyy').format(selectedDateFrom!);
              });

              if (isOnly) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pop(context);
                  _showFilterDialog();
                });
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  openCalTo();
                });
              }
            },
          ),
        ),
      ),
    );
  }

  void openCalTo({bool isOnly = false}) {
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
            hintText: 'Select Ending Date',
            initialDate: selectedDateTo ?? selectedDateFrom ?? DateTime.now(),
            minimumDate: selectedDateFrom,
            onDateSelected: (newDate) {
              setState(() {
                selectedDateTo = newDate;
                formattedDateTo =
                    DateFormat('dd-MM-yyyy').format(selectedDateTo!);
              });
              // Reopen the filter dialog after date selection
              // Navigator.pop(context);
              //Navigator.pop(context);

              if (isOnly) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pop(context);
                  _showFilterDialog();
                });
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showFilterDialog();
                });
              }

              // Log.d('filter dialog opened');
              // _showFilterDialog();
            },
          ),
        ),
      ),
    );
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
                  hint: 'From',
                  text: formattedDateFrom ?? 'From',
                  leadingIcon: Icons.date_range,
                  onTap: () {
                    openCalFrom(isOnly: true);
                  },
                ),
                SizedBox(height: 16.h),
                SelectorWidget(
                  hint: 'To',
                  text: formattedDateTo ?? 'To',
                  leadingIcon: Icons.date_range,
                  onTap: () {
                    openCalTo(isOnly: true);
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
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        if (selectedDateFrom != null &&
                            selectedDateTo != null) {
                          Navigator.of(context).pop();
                          setState(() {
                            isLoadingMain = true;
                          });
                          fetchWholeSchoolAttendanceReport();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Please select both start and end dates"),
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }

                        // Navigator.of(context).pop();
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
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: ClampingScrollPhysics(),
            children: [
              SizedBox(height: 15.h),
              Text(
                textAlign: TextAlign.center,
                "Whole School Attendance Over a Period",
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
                            '${formattedDateFrom ?? ""} ${formattedDateTo != null && formattedDateTo != '' ? 'to' : ''} ${formattedDateTo ?? ""}',
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
              SizedBox(height: 5.h),

              if (selectedShift != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.view_day_rounded,
                      size: 20.w,
                      color: const Color(0xFF494949),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      selectedShift?.split(' ')[0] ?? "",
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
              SizedBox(height: 10.h),
              Divider(
                // indent: 2.w,
                // endIndent: 2.w,
                color: Colors.grey[400],
                thickness: 1,
                height: 1.h,
              ),
              SizedBox(height: 10.h),
              SizedBox(
                child: isLoadingMain
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Color(0xFFED7902),
                      ))
                    : ClassAttendanceSummary(
                        dateAttendanceData: dateAttendanceData,
                        isLoadingMain: isLoadingMain,
                      ),
              ),
              // if (isLoading || dateAttendanceData.isEmpty) ...[
              //   SizedBox(height: 540.h),
              // ] else ...[

              // ],
              // SizedBox(height: 2.h),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Divider(
          indent: 20.w,
          endIndent: 20.w,
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
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
      ]),
    );
  }
}

class ClassAttendanceSummary extends StatelessWidget {
  final List<DateAttendanceData> dateAttendanceData;
  final bool isLoadingMain;

  const ClassAttendanceSummary({
    super.key,
    this.dateAttendanceData = const [],
    this.isLoadingMain = true,
  });

  @override
  Widget build(BuildContext context) {
    bool hasData = dateAttendanceData.isNotEmpty;

    // if (!hasData) {
    //   return Container(
    //     width: 348.w,
    //     height: 100.h,
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.circular(4.r),
    //       border: Border.all(color: const Color(0xFFDADADA), width: 0.5),
    //       boxShadow: [
    //         BoxShadow(
    //           color: Colors.black.withOpacity(0.1),
    //           blurRadius: 8.8,
    //           offset: const Offset(0, 3),
    //         ),
    //       ],
    //     ),
    //     child: Center(
    //       child: Text(
    //         "No attendance data available",
    //         style: TextStyle(
    //           fontSize: 14.sp,
    //           fontWeight: FontWeight.w500,
    //           color: Colors.grey,
    //         ),
    //       ),
    //     ),
    //   );
    // }

    return Container(
      width: 348.w,
      //height: 570.h,
      constraints: BoxConstraints(
        maxHeight: 529.h, // Maximum height constraint
      ),
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Add this to prevent unbounded height
        children: [
          _buildHeader(),
          Flexible(
            // Wrap the data table in an Expanded to take remaining space
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              // Make only the data table scrollable
              child: SizedBox(
                // Match the width of the parent
                width: 348.w,
                child: _buildDateDataTable(),
              ),
            ),
          ), // Remove the Expanded wrapper
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
          _buildHeaderCell('Date', flex: 2),
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

  Widget _buildDateDataTable() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        dateAttendanceData.length,
        (index) => _buildDateTableRow(dateAttendanceData[index], index),
      ),
    );
  }

  Widget _buildDateTableRow(DateAttendanceData data, int index) {
    // Get the first shift's data (or use defaults if list is empty)
    ShiftAttendance shiftData = data.shiftAttendance.isNotEmpty
        ? data.shiftAttendance.first
        : ShiftAttendance(
            shiftId: 0, shiftName: "", present: 0, absent: 0, total: 0);

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
            data.date,
            flex: 2,
          ),
          _buildVerticalDivider(),
          _buildTableCell(
            shiftData.present == 0 &&
                    shiftData.absent == 0 &&
                    shiftData.total == 0
                ? '-'
                : shiftData.present.toString(),
            flex: 1,
            textColor: const Color(0xFF0AB331),
          ),
          _buildVerticalDivider(),
          _buildTableCell(
            shiftData.present == 0 &&
                    shiftData.absent == 0 &&
                    shiftData.total == 0
                ? '-'
                : shiftData.absent.toString(),
            flex: 1,
            textColor: const Color(0xFFF34235),
          ),
          _buildVerticalDivider(),
          _buildTableCell(
            shiftData.present == 0 &&
                    shiftData.absent == 0 &&
                    shiftData.total == 0
                ? '-'
                : shiftData.total.toString(),
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

class DateAttendanceData {
  final String date;
  final List<ShiftAttendance> shiftAttendance;

  DateAttendanceData({
    required this.date,
    required this.shiftAttendance,
  });
}

class ShiftAttendance {
  final int shiftId;
  final String shiftName;
  final int present;
  final int absent;
  final int total;

  ShiftAttendance({
    required this.shiftId,
    required this.shiftName,
    required this.present,
    required this.absent,
    required this.total,
  });
}
