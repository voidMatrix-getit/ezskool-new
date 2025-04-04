import 'package:ezskool/core/services/logger.dart';
import 'package:ezskool/data/repo/student_repo.dart';
import 'package:ezskool/data/viewmodels/class_attendance/class_attendance_home_viewmodel.dart';
import 'package:ezskool/data/viewmodels/class_attendance/student_listing_viewmodel.dart';
import 'package:ezskool/presentation/drawers/calendar_bottom_drawer.dart';
import 'package:ezskool/presentation/widgets/custom_buttons.dart';
import 'package:ezskool/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'class_attendance_status.dart';
// Adjust import path as needed

class ClassAttendanceStatusSpecificIntervalScreen extends StatefulWidget {
  const ClassAttendanceStatusSpecificIntervalScreen({super.key});

  @override
  State<ClassAttendanceStatusSpecificIntervalScreen> createState() =>
      _ClassAttendanceStatusSpecificIntervalScreenState();
}

class _ClassAttendanceStatusSpecificIntervalScreenState
    extends State<ClassAttendanceStatusSpecificIntervalScreen> {
  // late List<AttendanceData> attendanceData;
  //DateTime? selectedDate;

  List<AttendanceData> attendanceData = [];
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

  @override
  void initState() {
    super.initState();
    // Initialize the attendance data

    //selectedShift = shiftOptions[0];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadClasses();
      openCalFrom();
    });

    // attendanceData = _getMockData();
  }

  Future<void> loadClasses() async {
    final cls = await stRepo.getAllClasses();

    setState(() {
      cardData = cls;
    });
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
                  _showFilterDialog();
                });
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  openBottomDrawerDropDown(context, cardData,
                      onClassSelected: (newClass) {
                    setState(() {
                      selectedCls = newClass;
                    });
                  });
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
            "Select Date and Class",
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
                    Navigator.pop(context);
                    openCalFrom(isOnly: true);
                  },
                ),
                SizedBox(height: 16.h),
                SelectorWidget(
                  hint: 'To',
                  text: formattedDateTo ?? 'To',
                  leadingIcon: Icons.date_range,
                  onTap: () {
                    Navigator.pop(context);
                    openCalTo(isOnly: true);
                  },
                ),
                SizedBox(height: 16.h),
                SelectorWidget(
                  hint: 'Selected Class',
                  text: selectedCls ?? 'Selected Class',
                  leadingIcon: Icons.class_outlined,
                  onTap: () {
                    // Keep this empty as requested
                    Navigator.pop(context);
                    openBottomDrawerDropDown(context, cardData,
                        onClassSelected: (newClass) {
                      setState(() {
                        selectedCls = newClass;
                      });
                    });
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
                        if (selectedClassId != null &&
                            selectedDateFrom != null &&
                            selectedDateTo != null) {
                          setState(() {
                            isLoadingMain = true;
                          });

                          // Call the new API with selected class and dates
                          fetchClassAttendanceSummary(
                            selectedClassId.toString(),
                            DateFormat('yyyy-MM-dd').format(selectedDateFrom!),
                            DateFormat('yyyy-MM-dd').format(selectedDateTo!),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text("Please select class and date range"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
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

  Future<void> fetchClassAttendanceSummary(
      String classId, String dateFrom, String dateTo) async {
    setState(() {
      isLoading = true;
    });

    try {
      final apiData =
          await stRepo.fetchClassAttendanceSummary(classId, dateFrom, dateTo);

      Log.d('Class attendance summary: $apiData');

      // Process the API response
      if (apiData != null && apiData['class_id'] != null) {
        String className = apiData['class_name'] ?? '';
        List<dynamic> attendanceList = apiData['attendance'] ?? [];

        List<AttendanceData> newData = [];

        // Process each day's attendance data
        for (var item in attendanceList) {
          String date = item['dt'] ?? '';
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

          // Format the date for display
          DateTime dateObj = DateTime.parse(date);
          String displayDate = DateFormat('dd-MM-yyyy').format(dateObj);

          Log.d('Date: $displayDate, Present: $present, Absent: $absent');

          newData.add(AttendanceData(
            className: displayDate, // Using date as the row identifier
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
      } else {
        // Handle empty or invalid response
        setState(() {
          attendanceData = [];
          isLoading = false;
          isLoadingMain = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No attendance data found for selected period"),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      Log.d('Error fetching attendance summary: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading attendance data"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );

      setState(() {
        attendanceData = [];
        isLoading = false;
        isLoadingMain = false;
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
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: ClampingScrollPhysics(),
            children: [
              SizedBox(height: 15.h),
              Text(
                textAlign: TextAlign.center,
                "Class Attendance Over a Period",
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
                          SizedBox(width: 4.w),
                          Text(
                            // DateFormat('EEE, dd MMM, yyyy')
                            //     .format(selectedDateFrom ?? ),
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

                      // Spacer between date and class
                      SizedBox(width: 16.w),

                      // Class section
                      Row(
                        children: [
                          Icon(
                            Icons.class_outlined,
                            size: 20.w,
                            color: const Color(0xFF494949),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            selectedCls ?? '',
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
              Divider(
                // indent: 20.w,
                // endIndent: 20.w,
                color: Colors.grey[400],
                thickness: 1,
                height: 1.h,
              ),
              SizedBox(height: 8.h),
              SizedBox(
                //height: 570.h,
                child: isLoadingMain
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Color(0xFFED7902),
                      ))
                    : ClassAttendanceSummary(
                        attendanceData: attendanceData,
                        onButtonPressed: _showFilterDialog,
                      ),
              ),
              // if (isLoading) ...[
              //   SizedBox(height: 540.h),
              // ] else ...[
              //   SizedBox(height: 2.h),
              // ],
              //SizedBox(height: 2.h),
            ],
          ),
        ),

        //Spacer(),
        Divider(
          indent: 20.w,
          endIndent: 20.w,
          color: Colors.grey[400],
          thickness: 1,
          height: 1.h,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10.h, top: 10.h),
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
              "Change Date/Class",
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

  void openBottomDrawerDropDown(
      BuildContext context, List<Map<String, dynamic>> cardData,
      {Function(String? newClass)? onClassSelected}) {
    final viewModel =
        Provider.of<ClassAttendanceHomeViewModel>(context, listen: false);
    StudentViewModel stvm =
        Provider.of<StudentViewModel>(context, listen: false);

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
              height: 520.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36.r),
                  topRight: Radius.circular(36.r),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  // Container(
                  //   height: 4.h,
                  //   width: 164.w,
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

                  SizedBox(
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 32.w, vertical: 16.h),
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
                              //startShowing(context);
                              setState(() {
                                tempClass = cardData[index]['title'];
                              });
                              //viewModel.selectedClass = tempClass!;
                              // await Future.delayed(
                              //     const Duration(milliseconds: 80));

                              //stvm.setClassName(data['title']);

                              classId = cardData[index]['classId'];
                              setState(() {
                                selectedCls = cardData[index]['title'];
                                selectedClassId = cardData[index]['classId'];
                              });

                              Log.d('Selected class: $selectedCls');

                              //stopShowing(context);
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
                    height: 30.h,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.r, vertical: 10.h),
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
                        SizedBox(width: 20),

                        ElevatedButton(
                          onPressed: () {
                            // if (tempClass != null) {
                            //   viewModel.updateClass(tempClass!);
                            // }

                            setState(() {
                              selectedCls = tempClass;
                            });

                            // Call the callback to update parent state
                            if (onClassSelected != null) {
                              onClassSelected(tempClass);
                            }

                            Navigator.pop(context);

                            _showFilterDialog();
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
  final VoidCallback? onButtonPressed;

  const ClassAttendanceSummary({
    super.key,
    required this.attendanceData,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 348.w,
        //height: 570.h,
        constraints: BoxConstraints(
          maxHeight: 560.h, // Maximum height constraint
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
          crossAxisAlignment: CrossAxisAlignment
              .stretch, // Add this to prevent unbounded height
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
                  child: _buildTable(),
                ),
              ),
            ),
          ],
          // IntrinsicHeight(
          //   child:
          //),
        ));
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
            data.className,
            flex: 2,
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
