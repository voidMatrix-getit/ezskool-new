import 'package:ezskool/presentation/screens/loginscreen.dart';
import 'package:ezskool/presentation/views/class_attendance/class_attendance_new.dart';
import 'package:ezskool/presentation/views/class_attendance/new_class_attendance_home_screen.dart';
import 'package:ezskool/presentation/views/class_attendance_report/class_attendance_status.dart';
import 'package:ezskool/presentation/views/class_attendance_report/class_attendance_status_specific_interval.dart';
import 'package:ezskool/presentation/views/class_attendance_report/class_wise_attendance_summary.dart';
import 'package:ezskool/presentation/views/class_attendance_report/student_wise_attendance_summary.dart';
import 'package:ezskool/presentation/views/class_attendance_report/whole_school_attendance_status_specific_interval.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/repo/auth_repo.dart';
import '../../data/viewmodels/class_attendance/class_attendance_home_viewmodel.dart';
import '../dialogs/custom_dialog.dart';
import '../widgets/loading.dart';
import 'class_attendance/birthday_feature/birthday_screen.dart';
import 'class_attendance/student_listing/student_listing.dart';
import 'home/home_screen.dart';

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
      drawer: buildCustomDrawer(context),

      // buildDrawer(context),
      endDrawer: trailing != null ? buildEndDrawer(context) : null,
      body: isBody
          ? Material(
              color: Colors.white,
              child: isSafeArea ? SafeArea(child: child) : child)
          : child, // The body content will be passed to this widget
    );
  }
}

Widget buildCustomDrawer(BuildContext context) {
  // Get user data from your auth provider or any storage mechanism
  final String userName = "Navya Sharma"; // Replace with actual user name
  final String userRole = "Teacher"; // Replace with actual user role

  return Drawer(
    child: Container(
      color: Colors.white,
      child: Column(
        children: [
          // Orange header with profile
          Container(
            color: const Color(0xFFED7902),
            padding: EdgeInsets.only(
                top: 50.h, bottom: 20.h, left: 10.w, right: 10.w),
            child: Row(
              children: [
                // Profile image
                // Container(
                //   width: 65.r,
                //   height: 65.r,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     shape: BoxShape.circle,
                //     border:
                //         Border.all(color: const Color(0xFFED7902), width: 2),
                //     image: const DecorationImage(
                //       image: AssetImage('assets/Frame.png'),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                Container(
                  width: 65.r,
                  height: 65.r,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFFED7902), width: 2),
                  ),
                  child: ClipOval(
                    child: SvgPicture.asset(
                      'assets/Frame.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                // Name and role
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      userRole,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu items
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'My Profile',
                    onTap: () {
                      HapticFeedback.selectionClick();
                      //Navigator.pop(context);
                      // Navigate to profile screen (implement this)
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.home,
                    title: 'Home',
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.library_add_check_rounded,
                    title: 'Mark Class Attendance',
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ClassAttendanceScreen()));
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.class_,
                    title: 'Students',
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentListingScreen()));
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.cake,
                    title: 'Birthdays',
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BirthdaySearchScreen()));
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.fact_check_rounded,
                    title: 'Attendance Status',
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AttendanceStatusScreen()));
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.rate_review_outlined,
                    title: 'Rate & Review Application',
                    onTap: () {
                      HapticFeedback.selectionClick();
                      // Navigator.pop(context);
                      // Implement rate & review functionality
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.password_outlined,
                    title: 'Reset Password',
                    onTap: () {
                      HapticFeedback.selectionClick();
                      //Navigator.pop(context);
                      // Implement password reset functionality
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.share_outlined,
                    title: 'Share App',
                    onTap: () {
                      HapticFeedback.selectionClick();

                      // Share.share(
                      //   subject: 'ezskool App',
                      //   'Check out this amazing ezskool app: Your one-stop solution for managing school operations.',
                      // );
                    },
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),

          // Punch In button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.selectionClick();

                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => PunchInOutScreen()));
                // Implement punch in functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED7902),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                minimumSize: Size(double.infinity, 45.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner, color: Colors.white, size: 16.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Punch In',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Logout option
          Padding(
            padding: EdgeInsets.only(left: 20.w, bottom: 20.h, top: 10.h),
            child: InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialog2(
                        title: "Log Out ?",
                        message: "Are you sure you want to log out ?",
                        negativeButtonText: "No",
                        positiveButtonText: "Yes",
                        onNegativePressed: () => Navigator.of(context).pop(),
                        onPositivePressed: () {
                          startShowing(context);
                          final clvm =
                              Provider.of<ClassAttendanceHomeViewModel>(context,
                                  listen: false);
                          clvm.resetSelections();
                          AuthRepository().logout(context);
                        },
                      );

                      // CustomDialog(
                      //   title: 'Log Out',
                      //   height: 350.h,
                      //   hasMessage: true,
                      //   message: 'Are you sure you want to log out?',
                      //   buttonText: 'OK',
                      //   icon: Icons.question_mark,
                      //   iconColor: Color(0xFFED7902),
                      //   backgroundColor: Color(0xFFED7902),
                      //   onButtonPressed: () {
                      //     startShowing(context);
                      //     final clvm =
                      //         Provider.of<ClassAttendanceHomeViewModel>(context,
                      //             listen: false);
                      //     clvm.resetSelections();
                      //     AuthRepository().logout(context);
                      //   },
                      // );
                    });
              },
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Color(0xFFD10000),
                    size: 21.sp,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: Color(0xFFD10000),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildMenuItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  bool isLast = false,
}) {
  return Column(
    children: [
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 8.w),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Icon(
                  icon,
                  size: 20.sp,
                  color: Colors.black87,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: Color(0xFF494949),
                ),
              ),
            ],
          ),
        ),
      ),
      if (!isLast)
        Divider(
          height: 1,
          thickness: 0.5,
          color: Color(0xFFDADADA),
        ),
    ],
  );
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
                  return CustomDialog2(
                    title: "Log Out?",
                    message: "Are you sure you want to log out?",
                    negativeButtonText: "No",
                    positiveButtonText: "Yes",
                    onNegativePressed: () => Navigator.of(context).pop(),
                    onPositivePressed: () async {
                      startShowing(context);

                      final result = await AuthRepository().logout2();

                      if (result['success']) {
                        final clvm = Provider.of<ClassAttendanceHomeViewModel>(
                            context,
                            listen: false);
                        clvm.resetSelections();
                        stopShowing(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Logged out successfully'),
                              duration: Duration(seconds: 1),
                              backgroundColor: Colors.green),
                        );
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (route) => false,
                        );
                      } else {
                        stopShowing(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Failed to logout. Please try again!'),
                          ),
                        );
                      }
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
