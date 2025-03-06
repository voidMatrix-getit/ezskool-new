import 'package:ezskool/presentation/views/class_attendance/new_class_attendance_home_screen.dart';
import 'package:ezskool/presentation/views/class_attendance_report/class_attendance_status.dart';
import 'package:ezskool/presentation/views/class_attendance_report/class_attendance_status_specific_interval.dart';
import 'package:ezskool/presentation/views/class_attendance_report/class_wise_attendance_summary.dart';
import 'package:ezskool/presentation/views/class_attendance_report/student_wise_attendance_summary.dart';
import 'package:ezskool/presentation/views/class_attendance_report/whole_school_attendance_status_specific_interval.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/repo/auth_repo.dart';
import '../../data/viewmodels/class_attendance/class_attendance_home_viewmodel.dart';
import '../dialogs/custom_dialog.dart';
import '../widgets/loading.dart';
import 'assignment/assignment_screen.dart';
import 'class_attendance/birthday_feature/birthday_screen.dart';
import 'class_attendance/student_listing/student_listing.dart';
import 'intimation/new_intimation_screen.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final String title; // Add customizable title
  final bool resize;
  final bool isSafeArea;
  final bool isBody;
  final Widget? trailing;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // Constructor to pass child widget (specific content of each screen) and title
  BaseScreen({
    super.key,
    required this.child,
    this.title = 'ezskool', // Default title
    this.resize = false,
    this.isSafeArea = true,
    this.isBody = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: resize,
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
            HapticFeedback.mediumImpact();
          },
        ),
        actions: trailing != null ? [trailing!] : null,
        title: Row(
          children: [
            SizedBox(
              width: 80.w,
            ),
            Align(
              alignment: Alignment.center,
              // This ensures the title is centered
              child: Text(
                "ezskool",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFED7902),
        elevation: 0,
      ),
      drawer: buildDrawer(context),
      endDrawer: trailing != null ? buildEndDrawer(context) : null,
      body: isBody
          ? Material(
              color: Colors.white,
              child: isSafeArea ? SafeArea(child: child) : child)
          : child, // The body content will be passed to this widget
    );
  }
}

Widget buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Color(0xFFED7902),
          ),
          child: Text(
            'Welcome!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewClassAttendanceHomeScreen()));
            // Implement the logout functionality here
            // For example: AuthRepository().logout(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.class_),
          title: const Text('Students'),
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StudentListingScreen()));
          },
        ),

        ListTile(
          leading: const Icon(Icons.cake),
          title: const Text('Birthdays'),
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BirthdaySearchScreen()));
          },
        ),
        // ListTile(
        //   leading: const Icon(Icons.search),
        //   title: const Text('test search'),
        //   onTap: () {
        //     Navigator.pushNamed(context, '/test');
        //   },
        // ),
        ListTile(
          leading: const Icon(Icons.fact_check_outlined),
          title: const Text('Attendance status'),
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AttendanceStatusScreen()));
            // Implement the logout functionality here
            // For example: AuthRepository().logout(context);
          },
        ),
        // ListTile(
        //   leading: const Icon(Icons.notification_add),
        //   title: const Text('Intimation'),
        //   onTap: () {
        //     HapticFeedback.selectionClick();
        //     Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => NewIntimationScreen()));
        //     // Implement the logout functionality here
        //     // For example: AuthRepository().logout(context);
        //   },
        // ),
        // ListTile(
        //   leading: const Icon(Icons.assignment),
        //   title: const Text('Assignment'),
        //   onTap: () {
        //     HapticFeedback.selectionClick();
        //     Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => AssignmentScreen()));
        //     // Implement the logout functionality here
        //     // For example: AuthRepository().logout(context);
        //   },
        // ),

        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            HapticFeedback.selectionClick();
            // Implement the logout functionality here
            // For example:
            // Navigator.pushReplacementNamed(context, '/login');

            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(
                    title: 'Log Out',
                    height: 350.h,
                    message: 'Are you sure you want to log out?',
                    buttonText: 'OK',
                    icon: Icons.question_mark,
                    iconColor: Color(0xFFED7902),
                    backgroundColor: Color(0xFFED7902),
                    // Consistent error theme
                    onButtonPressed: () {
                      // Navigator.pop(context);
                      startShowing(context);
                      final clvm = Provider.of<ClassAttendanceHomeViewModel>(
                          context,
                          listen: false);
                      clvm.resetSelections();
                      AuthRepository()
                          .logout(context); // Close the dialog and allow retry
                    },
                  );
                });
          },
        ),
        // You can add more Drawer options here
      ],
    ),
  );
}

Widget buildEndDrawer(BuildContext context) {
  // You can customize this drawer according to your specific needs
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Color(0xFFED7902),
          ),
          child: Text(
            'Attendance Reports',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
            ),
          ),
        ),
        // Add your hierarchy-specific menu items here
        // Example:
        ListTile(
          leading: const Icon(Icons.fact_check_outlined),
          title: const Text('Attendance Status'),
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AttendanceStatusScreen()));
            // Navigate to hierarchy screen or perform hierarchy action
          },
        ),
        ListTile(
          leading: const Icon(Icons.class_),
          title: const Text('Class Wise Summary'),
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ClasswiseAttendanceSummaryScreen()));
            // Navigate to hierarchy screen or perform hierarchy action
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Student Wise Summary'),
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        StudentWiseAttendanceSummaryScreen()));
            // Navigate to hierarchy screen or perform hierarchy action
          },
        ),
        ListTile(
          leading: const Icon(Icons.data_exploration),
          title: const Text('Class Attendance Over A Period'),
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ClassAttendanceStatusSpecificIntervalScreen()));
            // Navigate to hierarchy screen or perform hierarchy action
          },
        ),
        ListTile(
          leading: const Icon(Icons.view_compact),
          title: const Text('Whole School Attendance Over A Period'),
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        WholeSchoolAttendanceStatusSpecificIntervalScreen()));
            // Navigate to hierarchy screen or perform hierarchy action
          },
        ),
        ListTile(
          leading: const Icon(Icons.arrow_back_ios_sharp),
          title: const Text('Back'),
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.pop(context);
            // Navigate to hierarchy screen or perform hierarchy action
          },
        ),
        // Add more hierarchy-related options
      ],
    ),
  );
}
