import 'package:ezskool/core/services/logger.dart';
import 'package:ezskool/data/repo/home_repo.dart';
import 'package:ezskool/data/viewmodels/class_attendance/class_attendance_home_viewmodel.dart';
import 'package:ezskool/presentation/dialogs/custom_dialog.dart';
import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ezskool/presentation/drawers/custom_bottom_drawers.dart';
import 'package:provider/provider.dart';

import '../../../data/repo/class_student_repo.dart';
import '../../../data/viewmodels/class_attendance/class_attendance_viewmodel.dart';

class ClassAttendanceHomeScreen extends StatefulWidget {
  const ClassAttendanceHomeScreen({super.key});

  @override
  _ClassAttendanceHomeScreenState createState() =>
      _ClassAttendanceHomeScreenState();
}

enum ViewState { calendar, qrScanner, manualAttendance }

class _ClassAttendanceHomeScreenState extends State<ClassAttendanceHomeScreen> {
  final repoClassStudent = ClassStudentRepo();
  final homeRepo = HomeRepo();
  DateTime selectedDate = DateTime.now();
  ViewState _currentView = ViewState.calendar;

  String? selectedStandard;
  String? selectedDivision;
  bool isDropdownOpen = false;

  // Sample list for dropdown boxes
  List<String> standards = List.generate(10, (index) => '${index + 1}');
  List<String> divisions = [];

  // final List<String> _days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

  @override
  void initState() {
    super.initState();
    getLoginSync();
  }

  Future<void> getLoginSync() async {
    final data = await repoClassStudent.fetchTestClassStudentData(
        '2', DateFormat('yyyy-MM-dd').format(selectedDate));
    await ClassStudentRepo.storeTestClassStudentData(data);

    await homeRepo.loginSyncLrDiv();

    Log.d(data);
  }

  void _changeMonth(int direction) {
    setState(() {
      selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month + direction,
      );
    });
  }

  void _changeYear() {
    // Add year selection functionality if needed
  }

  void _changeView(ViewState view) {
    setState(() {
      _currentView = view;
    });
  }

  void _onQRScanned(String code) {
    print("QR Code: $code");
    // Return to calendar after QR scanning
    Future.delayed(Duration(seconds: 1), () {
      _changeView(ViewState.calendar);
    });
  }

  Widget _buildDropdownField(
      VoidCallback onTap, ClassAttendanceHomeViewModel viewModel) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.0),
        height: 48,
        width: 306,
        decoration: BoxDecoration(
          color: Color(0xFFED7902),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 18.1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 10),
            Text(
              viewModel.selectedStandard.isNotEmpty &&
                      viewModel.selectedDivision.isNotEmpty
                  ? 'Class : ${viewModel.selectedStandard} - ${viewModel.selectedDivision}'
                  : 'Select Standard & Division',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassAttendanceHomeViewModel>(context);
    final clvmdl = Provider.of<ClassAttendanceViewModel>(context);

    return BaseScreen(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Attendance",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF494949),
              ),
            ),
            SizedBox(height: 16.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Date and Class Info
                SvgPicture.asset('assets/cal.svg', width: 18.w, height: 18.h),
                SizedBox(width: 5.w),
                Text(DateFormat('d MMM yyyy, EEEE').format(DateTime.now())),
              ],
            ),
            SizedBox(height: 16.h),

            AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: _buildCalendar(viewModel)),
            // SizedBox(height: 24),

            SizedBox(height: 16.h),
            // _buildDropdownField(() {
            //   setState(() {
            //     isDropdownOpen = !isDropdownOpen;
            //   });
            //   openBottomDrawerDropDown(context);
            // }),
            _buildDropdownField(() async {
              final divisions =
                  await HomeRepo.dropdownDao.getDropdownValues('div');
              viewModel.setDivisions(divisions);

              Future.delayed(Duration(seconds: 2));
              openBottomDrawerDropDown(context);
            }, viewModel),
            SizedBox(height: 16.h),

            // Text(
            //   "Select Attendance Mode",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //     color: Color(0xFF494949),
            //   ),
            // ),
            // SizedBox(height: 16),
            _buildAttendanceMode(context, viewModel, clvmdl),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(ClassAttendanceHomeViewModel vm) {
    final currentMonth = DateFormat('MMMM yyyy').format(selectedDate);

    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDayOfMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0);

    final daysInMonth = List<DateTime>.generate(
      lastDayOfMonth.day,
      (i) => DateTime(selectedDate.year, selectedDate.month, i + 1),
    );

    final days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    // Adjust weekday to align with the custom day list
    final firstWeekdayOfMonth = (firstDayOfMonth.weekday %
        7); // Adjust for Sunday = 0, Monday = 1, ..., Saturday = 6

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Row for Month and Year with navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left, color: Colors.black),
                  onPressed: () => _changeMonth(-1),
                ),
                InkWell(
                  onTap: _changeYear,
                  child: Text(
                    currentMonth, // Show month name and year
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right, color: Colors.black),
                  onPressed: () => _changeMonth(1),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Row for Weekdays (Sun, Mon, Tue, etc.)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: days.map((day) {
                return Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectedDate.weekday == days.indexOf(day)
                          ? Color(0xFFED7902) // Highlight selected day
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: selectedDate.weekday == days.indexOf(day)
                            ? Colors.white
                            : Colors.black54,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 8),

            // Grid of Dates (using the first weekday offset)
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: List.generate(firstWeekdayOfMonth, (index) {
                // Empty containers before the start of the month (for alignment)
                return Container(
                  width: 40,
                  height: 40,
                  color: Colors.transparent,
                );
              })
                ..addAll(daysInMonth.map((date) {
                  final isSelected = selectedDate.day == date.day &&
                      selectedDate.month == date.month &&
                      selectedDate.year == date.year;

                  return InkWell(
                    onTap: () async {
                      setState(() {
                        selectedDate = date;
                      });
                      vm.date = selectedDate;
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xFFED7902) : Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "${date.day}",
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceMode(BuildContext context,
      ClassAttendanceHomeViewModel viewModel, ClassAttendanceViewModel cl) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isNarrow = constraints.maxWidth < 600;
      double cardWidth =
          isNarrow ? constraints.maxWidth * 0.4 : constraints.maxWidth * 0.3;
      double cardHeight = isNarrow ? 141 : 161;

      return Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,

        // children: [
        //   Row(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildModeCard(
            color: Color(0xFFFFE8D1),
            //Color(0xFFFFF3E5), //0xFFFFE8D1
            svgPath: 'assets/class.svg',
            label: "Manual Attendance",
            textColor: Color(0xFFED7902),
            width: cardWidth,
            height: cardHeight,
            //Color(0xFFED7902),
            onTap: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFED7902)),
                      strokeWidth: 5,
                      backgroundColor: Colors.white.withOpacity(0.3),
                    ),
                  );
                },
              );
              if (viewModel.selectedStandard.isNotEmpty &&
                  viewModel.selectedDivision.isNotEmpty) {
                // await deleteDatabase();
                // await getLoginSync();
                try {
                  await cl.initializeAttendanceList('');
                  viewModel.updateDate(
                      DateFormat('d MMM yyyy, EEEE').format(selectedDate));
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.pushNamed(context, '/clsatt');
                } catch (e) {
                  Navigator.of(context, rootNavigator: true).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Data Not Found for this Class')));
                }
              } else {
                Navigator.of(context, rootNavigator: true).pop();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialog(
                        title: 'Class Not Selected',
                        height: 360,
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
          ),
          _buildModeCard(
              color: Colors.white,
              //Colors.white,
              svgPath: 'assets/appoint.svg',
              label: "Confirm Attendance",
              textColor: Colors.black,
              width: cardWidth,
              height: cardHeight,
              onTap: () {
                //_changeView(ViewState.manualAttendance);
                // showAttendanceDialog(context);
              }),
        ],
        //)
        //]
      );
    });
  }

  Widget _buildModeCard({
    Color? color,
    String? svgPath,
    String? label,
    Color? textColor,
    double? width,
    double? height,
    required VoidCallback onTap,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isNarrow = constraints.maxWidth < 600;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Card(
            elevation: 4,
            color: color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              width: width ?? 164,
              height: height ?? 141,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    svgPath!,
                    width: isNarrow ? 58 : 68,
                    height: isNarrow ? 58 : 68,
                    color: textColor,
                  ),
                  // SizedBox(height: 8),
                  Text(
                    label!,
                    style: TextStyle(
                      color: textColor,
                      fontSize: isNarrow ? 12 : 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Widget _buildAttendanceMode(BuildContext context,
//     ClassAttendanceHomeViewModel viewModel, ClassAttendanceViewModel cl) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       _buildModeCard(
//         color: Color(0xFFFFE8D1),
//         //Color(0xFFFFF3E5), //0xFFFFE8D1
//         svgPath: 'assets/class.svg',
//         label: "Manual Attendance",
//         textColor: Color(0xFFED7902),
//         //Color(0xFFED7902),
//         onTap: () async {
//           showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (BuildContext context) {
//               return Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFED7902)),
//                   strokeWidth: 5,
//                   backgroundColor: Colors.white.withOpacity(0.3),
//                 ),
//               );
//             },
//           );
//           if (viewModel.selectedStandard.isNotEmpty &&
//               viewModel.selectedDivision.isNotEmpty) {
//             // await deleteDatabase();
//             // await getLoginSync();
//             try {
//               await cl.initializeAttendanceList();
//               viewModel.updateDate(
//                   DateFormat('d MMM yyyy, EEEE').format(selectedDate));
//               Navigator.of(context, rootNavigator: true).pop();
//               Navigator.pushNamed(context, '/clsatt');
//             } catch (e) {
//               Navigator.of(context, rootNavigator: true).pop();
//               ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Data Not Found for this Class')));
//             }
//           }else{
//             Navigator.of(context, rootNavigator: true).pop();
//             showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return CustomDialog(
//                     title: 'Class Not Selected',
//                     height: 360,
//                     message:
//                     'Please select a class before proceeding with attendance.',
//                     buttonText: 'Ok',
//                     icon: Icons.error_outline,
//                     iconColor: Color(0xFFED7902),
//                     backgroundColor: Color(0xFFED7902),
//                     // Consistent error theme
//                     onButtonPressed: () {
//                       Navigator.pop(
//                           context); // Close the dialog and allow retry
//                     },
//                   );
//                 });
//           }
//
//         },
//       ),
//       _buildModeCard(
//           color: Colors.white,
//           //Colors.white,
//           svgPath: 'assets/appoint.svg',
//           label: "Confirm Attendance",
//           textColor: Colors.black,
//           onTap: () {
//             //_changeView(ViewState.manualAttendance);
//             // showAttendanceDialog(context);
//           }),
//     ],
//   );
// }

// Widget _buildModeCard({
//   Color? color,
//   String? svgPath,
//   String? label,
//   Color? textColor,
//   required VoidCallback onTap,
// }) {
//   return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: onTap,
//       child: InkWell(
//         // onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Card(
//           elevation: 4,
//           color: color,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           child: Container(
//             width: 164,
//             height: 141,
//             alignment: Alignment.center,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SvgPicture.asset(
//                   svgPath!,
//                   width: 58,
//                   height: 58,
//                   color: textColor,
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   label!,
//                   style: TextStyle(
//                     color: textColor,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ));
// }
