import 'package:ezskool/core/services/logger.dart';
import 'package:ezskool/data/repo/class_student_repo.dart';
import 'package:ezskool/data/repo/student_repo.dart';
import 'package:ezskool/data/viewmodels/class_attendance/class_attendance_home_viewmodel.dart';
import 'package:ezskool/data/viewmodels/class_attendance/student_listing_viewmodel.dart';
import 'package:ezskool/presentation/views/class_attendance/new_class_attendance_home_screen.dart';
import 'package:ezskool/presentation/widgets/custom_buttons.dart';
import 'package:ezskool/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StudentWiseAttendanceSummaryScreen extends StatefulWidget {
  const StudentWiseAttendanceSummaryScreen({Key? key}) : super(key: key);

  @override
  State<StudentWiseAttendanceSummaryScreen> createState() =>
      _StudentWiseAttendanceSummaryScreenState();
}

class _StudentWiseAttendanceSummaryScreenState
    extends State<StudentWiseAttendanceSummaryScreen> {
  List<StudentAttendanceData> attendanceData = [];
  final classStudentRepo = ClassStudentRepo();
  final stRepo = StudentRepository();
  bool isLoading = true;
  bool isLoadingMain = false;

  // Date, shift, and class management
  DateTime? selectedDate;
  String? formattedDate;
  String? selectedShift;
  String? selectedClass;
  int? selectedClassId;
  final List<String> shiftOptions = ['Morning Shift', 'Evening Shift'];
  final Map<String, String> shiftValues = {
    'Morning Shift': '1',
    'Evening Shift': '2',
  };

  List<Map<String, dynamic>> cardData = [];
  int? classId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch all classes

      loadClasses();

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

                // Navigator.pop(context);

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  openBottomDrawerDropDown(context, cardData);
                });

                // openBottomDrawerDropDown(context, cardData);
                // _showFilterDialog();
                // Log.d('filter dialog opened');
                // _showFilterDialog();
              },
            ),
          ),
        ),
      );
    });
  }

  Future<void> loadClasses() async {
    final cls = await stRepo.getAllClasses();

    setState(() {
      cardData = cls;
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
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
                SelectorWidget(
                  text: selectedClass ?? 'Select Class',
                  leadingIcon: Icons.class_outlined,
                  onTap: () {
                    // Keep this empty as requested
                    Navigator.pop(context);

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      openBottomDrawerDropDown(context, cardData);
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
                        //startShowing(context);
                        setState(() {
                          isLoadingMain = true;
                        });

                        if (selectedDate != null && selectedClassId != null) {
                          fetchStudentAttendanceData(
                            selectedClassId.toString(),
                            DateFormat('yyyy-MM-dd').format(selectedDate!),
                          );
                          //stopShowing(context);
                          //Navigator.pop(context);
                        } else {
                          //stopShowing(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please select date and class"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }

                        Navigator.pop(context);
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

  Future<void> fetchStudentAttendanceData(String classId, String date) async {
    setState(() {
      isLoading = true;
    });

    try {
      final data =
          await classStudentRepo.fetchTestClassStudentData(classId, date);

      Log.d('classId: $classId, date: $date');
      Log.d('data: $data');

      if (data != null) {
        List<StudentAttendanceData> newData = [];

        // Process the student data
        for (var student in data['students']) {
          int rollNo = student['roll_no'];
          String name = student['name'];
          bool isPresent = student['att_status'] == 1;
          int gender = student['gender'];

          newData.add(StudentAttendanceData(
            rollNo: rollNo,
            name: name,
            isPresent: isPresent,
            gender: gender,
          ));
        }

        setState(() {
          attendanceData = newData;
          isLoading = false;
          isLoadingMain = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No data available for this class'),
            backgroundColor: Colors.red,
          ),
        );

        setState(() {
          attendanceData = [];
          isLoading = false;
          isLoadingMain = false;
        });
      }
    } catch (e) {
      setState(() {
        attendanceData = [];
        isLoading = false;
        isLoadingMain = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading attendance data: ${e.toString()}"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );

      // setState(() {
      //   attendanceData = [];
      //   isLoading = false;
      //   isLoadingMain = false;
      // });
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
                "Student-Wise Attendance Summary",
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

                      // Spacer between date and class
                      SizedBox(width: 24.w),

                      // Class section
                      Row(
                        children: [
                          Icon(
                            Icons.class_outlined,
                            size: 20.w,
                            color: const Color(0xFFB8BCCA),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            selectedClass ?? "Selected Class",
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
                        ),
                      )
                    : StudentAttendanceSummary(
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
                  "Change Date/Class",
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

  void openBottomDrawerDropDown(
      BuildContext context, List<Map<String, dynamic>> cardData) {
    final viewModel =
        Provider.of<ClassAttendanceHomeViewModel>(context, listen: false);
    StudentViewModel stvm =
        Provider.of<StudentViewModel>(context, listen: false);

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

                              setState(() {
                                tempClass = cardData[index]['title'];
                              });

                              classId = cardData[index]['classId'];
                              setState(() {
                                selectedClass = cardData[index]['title'];
                                selectedClassId = cardData[index]['classId'];
                              });
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
                        SizedBox(width: 20),

                        ElevatedButton(
                          onPressed: () {
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
}

class StudentAttendanceSummary extends StatelessWidget {
  final List<StudentAttendanceData> attendanceData;

  const StudentAttendanceSummary({
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
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildTable(),
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
          _buildHeaderCell('Roll No.', flex: 1),
          _buildVerticalDivider(),
          _buildHeaderCell('Name', flex: 3),
          _buildVerticalDivider(),
          _buildHeaderCell('Status', flex: 1),
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
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        attendanceData.length,
        (index) => _buildTableRow(attendanceData[index], index),
      ),
    );
  }

  Widget _buildTableRow(StudentAttendanceData data, int index) {
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
            data.rollNo.toString(),
            flex: 1,
            fontWeight: FontWeight.w500,
          ),
          _buildVerticalDivider(),
          _buildNameCell(
            data.name,
            data.gender == 1 ? "male" : "female",
            flex: 3,
          ),
          _buildVerticalDivider(),
          _buildStatusIconCell(
            data.isPresent,
            flex: 1,
          )
        ],
      ),
    );
  }

  Widget _buildStatusIconCell(bool isPresent, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Container(
        alignment: Alignment.center,
        child: Icon(
          isPresent ? Icons.check_circle : Icons.cancel,
          color: isPresent ? Color(0xFF00BFFF) : Colors.red,
        ),
      ),
    );
  }

  Widget _buildNameCell(String name, String gender, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Image.asset(
              gender == "male" ? 'assets/bb.png' : 'assets/g.png',
              width: 12.w,
              height: 14.h,
              alignment: Alignment.center,
              color: gender == "male" ? Colors.blue : Colors.pink,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E1E1E),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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

class StudentAttendanceData {
  final int rollNo;
  final String name;
  final bool isPresent;
  final int gender;

  StudentAttendanceData({
    required this.rollNo,
    required this.name,
    required this.isPresent,
    required this.gender,
  });
}

class SelectorWidget extends StatelessWidget {
  final String text;
  final IconData leadingIcon;
  final VoidCallback onTap;

  const SelectorWidget({
    Key? key,
    required this.text,
    required this.leadingIcon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250.w,
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFFDADADA)),
        ),
        child: Row(
          children: [
            Icon(
              leadingIcon,
              size: 20.w,
              color: const Color(0xFFB8BCCA),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF969AB8),
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20.w,
              color: const Color(0xFFB8BCCA),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectorDropdownWidget extends StatelessWidget {
  final String text;
  final IconData leadingIcon;
  final List<String> items;
  final Function(String?) onChanged;
  final double width;

  const SelectorDropdownWidget({
    Key? key,
    required this.text,
    required this.leadingIcon,
    required this.items,
    required this.onChanged,
    this.width = 200.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFDADADA)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 20.w,
            color: const Color(0xFFB8BCCA),
          ),
          hint: Row(
            children: [
              Icon(
                leadingIcon,
                size: 20.w,
                color: const Color(0xFFB8BCCA),
              ),
              SizedBox(width: 12.w),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF969AB8),
                ),
              ),
            ],
          ),
          isExpanded: true,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF969AB8),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
