import 'package:ezskool/core/services/logger.dart';
import 'package:ezskool/data/repo/home_repo.dart';
import 'package:ezskool/data/viewmodels/class_attendance/class_attendance_home_viewmodel.dart';
import 'package:ezskool/presentation/dialogs/custom_dialog.dart';
import 'package:ezskool/presentation/drawers/calendar_bottom_drawer.dart';
import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/repo/class_student_repo.dart';
import '../../../data/repo/student_repo.dart';
import '../../../data/viewmodels/class_attendance/class_attendance_viewmodel.dart';
import '../../../data/viewmodels/class_attendance/student_listing_viewmodel.dart';
import '../../../main.dart';
import '../../widgets/loading.dart';
import 'class_attendance.dart';

class NewClassAttendanceHomeScreen extends StatefulWidget {
  const NewClassAttendanceHomeScreen({super.key});

  @override
  _NewClassAttendanceHomeScreenState createState() =>
      _NewClassAttendanceHomeScreenState();
}

class _NewClassAttendanceHomeScreenState
    extends State<NewClassAttendanceHomeScreen> {
  //from class listing
  List<Map<String, dynamic>> cardData = [];
  final stRepo = StudentRepository();
  bool isLoading = true; //

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

  static final bool _isFirstLaunch = true;

  // List<String> standards = List.generate(10, (index) => '${index + 1}');

  // final List<String> _days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

  @override
  void initState() {
    super.initState();

    checkFirstLaunch();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final stvm = Provider.of<StudentViewModel>(context, listen: false);
      openBottomDrawerDropDown(context, stvm);
    });
  }

  Future<void> checkFirstLaunch() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      await loadLD();
      await stRepo.fetchAllClasses(); // Fetch fresh data only on first launch
      await prefs.setBool('isFirstLaunch', false);
    }

    await loadClasses(); // Always load classes to update UI
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
    final cls = await stRepo.getAllClasses();

    setState(() {
      cardData = cls;
      isLoading = false;
    });
  }

  Future<void> loadLD() async {
    await homeRepo.loginSyncLrDiv();
    divisions = await HomeRepo.dropdownDao.getDropdownValues('div');

    Provider.of<ClassAttendanceHomeViewModel>(
            navigatorKey.currentState!.context,
            listen: false)
        .setDivisions(divisions);

    //isLoading = false;
  }

  Future<void> getLoginSync(String id) async {
    final data = await repoClassStudent.fetchTestClassStudentData(
        id, DateFormat('yyyy-MM-dd').format(selectedDate));
    Log.d(data);
    await ClassStudentRepo.storeTestClassStudentData(data);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassAttendanceHomeViewModel>(context);
    final clvmdl = Provider.of<ClassAttendanceViewModel>(context);
    final stvm = Provider.of<StudentViewModel>(context);

    //viewModel.setStandards(divisions);

    return BaseScreen(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Attendance",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF494949),
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                'Select date',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15.sp,
                  color: Color(0xFFA29595),
                ),
              ),
              SizedBox(height: 16.h),

              Container(
                width: 268.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFED7902), // Orange background
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: Colors.white,
                    width: 2.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 7.1.r,
                      offset: Offset(0.w, 3.h),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.mediumImpact();

                      showModalBottomSheet(
                          backgroundColor: Colors.white,
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.r)),
                          ),
                          builder: (context) => SingleChildScrollView(
                                child: Container(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    child: CalendarBottomSheet(
                                      initialDate: selectedDate,
                                      onDateSelected: (selectedDate) {
                                        viewModel.date = selectedDate;

                                        // Update the ViewModel with the selected date
                                        setState(() {
                                          this.selectedDate = selectedDate;
                                        });
                                      },
                                    )),
                              ));
                    },
                    borderRadius: BorderRadius.circular(6.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Icon at the left
                          Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                          ),
                          // Date text in the center
                          Text(
                            DateFormat('EEE, dd MMM, yyyy')
                                .format(viewModel.date),
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              SizedBox(
                height: 450.h,
                width: double.infinity.w,
                child: Column(
                  children: [
                    _buildDropdownField(() {
                      HapticFeedback.mediumImpact();
                      openBottomDrawerDropDown(context, stvm);
                    }, viewModel),
                    // Text(
                    //   'Select Class',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.w400,
                    //     fontSize: 16.sp,
                    //     height: 1.5.h,
                    //     color: Color(0xFFA29595),
                    //   ),
                    // ),
                    // // SizedBox(height: 20),
                    // Padding(
                    //   padding: EdgeInsets.all(16.r),
                    //   child: isLoading
                    //       ? Center(
                    //           child: CircularProgressIndicator(
                    //           color: Color(0xFFED7902),
                    //         ))
                    //       : GridView.builder(
                    //           shrinkWrap: true,
                    //           physics: const NeverScrollableScrollPhysics(),
                    //           // Prevents inner scrolling
                    //           gridDelegate:
                    //               SliverGridDelegateWithFixedCrossAxisCount(
                    //             crossAxisCount: 4, // Three cards per row
                    //             crossAxisSpacing:
                    //                 16.w, // Spacing between columns
                    //             mainAxisSpacing: 16.h, // Spacing between rows
                    //             childAspectRatio:
                    //                 80 / 77, // Card width-to-height ratio
                    //           ),
                    //           itemCount: cardData.length,
                    //           itemBuilder: (context, index) {
                    //             List<bool> isToggled =
                    //                 List.filled(cardData.length, false);
                    //             final isSelected =
                    //                 tempClass == cardData[index]['title'];
                    //             final data = cardData[index];
                    //             // To track card color state
                    //             return GestureDetector(
                    //               onTap: () async {
                    //                 HapticFeedback.selectionClick();
                    //                 startShowing(context);
                    //                 setState(() {
                    //                   tempClass = cardData[index]['title'];
                    //                 });
                    //                 viewModel.selectedClass = tempClass!;
                    //                 // await Future.delayed(
                    //                 //     const Duration(milliseconds: 80));

                    //                 stvm.setClassName(data['title']);

                    //                 classId = cardData[index]['classId'];
                    //                 stopShowing(context);
                    //               },
                    //               child: AnimatedContainer(
                    //                 duration: const Duration(milliseconds: 300),
                    //                 decoration: BoxDecoration(
                    //                   color: isSelected
                    //                       ? Color(0xFF33CC99)
                    //                       : Color(0xFFED7902),
                    //                   border: Border.all(
                    //                       color: const Color(0xFFE2E2E2),
                    //                       width: 1.w),
                    //                   boxShadow: [
                    //                     BoxShadow(
                    //                       color: Colors.black.withOpacity(0.25),
                    //                       offset: const Offset(0, 2),
                    //                       blurRadius: 4,
                    //                       spreadRadius: 1,
                    //                     ),
                    //                   ],
                    //                   borderRadius: BorderRadius.circular(5.r),
                    //                 ),
                    //                 child: Column(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.center,
                    //                   children: [
                    //                     Container(
                    //                       width: 40.w, // Line width
                    //                       height: 1.h, // Line height
                    //                       color: Colors.white, // Line color
                    //                       margin: EdgeInsets.symmetric(
                    //                           vertical: 4.h),
                    //                     ),
                    //                     SizedBox(height: 4.h),
                    //                     Text(
                    //                       cardData[index]['title']
                    //                           .toString()
                    //                           .replaceAll(' ', '-'),
                    //                       style: TextStyle(
                    //                         fontWeight: FontWeight.w600,
                    //                         fontSize: 24.sp,
                    //                         color: Colors.white,
                    //                       ),
                    //                     ),
                    //                     SizedBox(height: 4.h),
                    //                     Container(
                    //                       width: 40.w, // Line width
                    //                       height: 1.h, // Line height
                    //                       color: Colors.white, // Line color
                    //                       margin: EdgeInsets.symmetric(
                    //                           vertical: 4.w),
                    //                     ),
                    //                     // Text(
                    //                     //   '${cardData[index]['count']}',
                    //                     //   style: const TextStyle(
                    //                     //     fontWeight: FontWeight.w500,
                    //                     //     fontSize: 14,
                    //                     //     color: Colors.white,
                    //                     //   ),
                    //                     // ),
                    //                     // const SizedBox(height: 4),
                    //                     // Text(
                    //                     //   cardData[index]['label'],
                    //                     //   style: const TextStyle(
                    //                     //     fontWeight: FontWeight.w400,
                    //                     //     fontSize: 10,
                    //                     //     color: Color(0xFFE2E2E2),
                    //                     //   ),
                    //                     // ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             );
                    //           },
                    //         ),

                    //   // GridView.builder(
                    //   //   padding: EdgeInsets.symmetric(
                    //   //     horizontal: 32.w,),
                    //   //   shrinkWrap: true,
                    //   //   itemCount: standards.length,
                    //   //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //   //     crossAxisCount: 4,
                    //   //     crossAxisSpacing: 20.w,
                    //   //     mainAxisSpacing: 20.h,
                    //   //   ),
                    //   //   itemBuilder: (context, index) {
                    //   //     final isSelected = tempStandard == standards[index];
                    //   //     return GestureDetector(
                    //   //       onTap: () {
                    //   //         setState(() {
                    //   //           tempStandard = standards[index];
                    //   //         });
                    //   //         viewModel.selectedStandard = tempStandard!;
                    //   //       },
                    //   //       child: Container(
                    //   //         height: 51.h,
                    //   //         width: 58.w,
                    //   //         decoration: BoxDecoration(
                    //   //           color: isSelected
                    //   //               ? Color(0xFFED7902)
                    //   //               : Color(0xFFFFE8D1),
                    //   //           border: Border.all(color: Color(0xFFE2E2E2)),
                    //   //           borderRadius: BorderRadius.circular(
                    //   //               5.r),
                    //   //           boxShadow: [
                    //   //             BoxShadow(
                    //   //               color: Colors.black
                    //   //                   .withOpacity(0.25),
                    //   //               offset: Offset(0.w,
                    //   //                   2.h),
                    //   //               blurRadius: 4.r,
                    //   //             ),
                    //   //           ],
                    //   //         ),
                    //   //         child: Center(
                    //   //           child: Text(
                    //   //             standards[index],
                    //   //             style: TextStyle(
                    //   //               fontWeight: FontWeight.w600,
                    //   //               fontSize: 24.sp,
                    //   //               height: 1.5.h,
                    //   //               color: isSelected
                    //   //                   ? Color(0xFFF5F5F7)
                    //   //                   : Color(0xFF494949),
                    //   //             ),
                    //   //           ),
                    //   //         ),
                    //   //       ),
                    //   //     );
                    //   //   },
                    //   // ),
                    // )
                  ],
                ),
              ),

              SizedBox(
                height: 50.h,
              ),

              Divider(
                indent: 20.w,
                endIndent: 20.w,
                color: Colors.grey[400],
                thickness: 1,
                height: 1.h,
              ),

              // Spacer(),

              SizedBox(
                height: 10.h,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Button 1: Gray background
                    ElevatedButton(
                      onPressed: () {
                        //Navigator.pop(context);
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
                            horizontal: 22.w,
                            vertical: 10.h,
                          )),
                      child: Text(
                        "Close", // Replace with actual text
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          letterSpacing: 0.4,
                          color: Color(0xFF494949), // Text color
                        ),
                      ),
                    ),
                    // Button 2: Orange background
                    SizedBox(width: 20.w),

                    ElevatedButton(
                      onPressed: () async {
                        HapticFeedback.mediumImpact();
                        startShowing(context);
                        if (viewModel.selectedClass.isNotEmpty) {
                          // await deleteDatabase();
                          //await getLoginSync(classId.toString());
                          try {
                            clvmdl.classId = classId.toString();
                            await clvmdl
                                .initializeAttendanceList(classId.toString());
                            viewModel.updateDate(DateFormat('EEE, dd MMM, yyyy')
                                .format(selectedDate));
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ClassAttendanceScreen()));
                          } catch (e) {
                            Navigator.of(context, rootNavigator: true).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                            horizontal: 22.w,
                            vertical: 10.h,
                          )),
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
              // SizedBox(height: 16.h,),

              // Spacer(),
            ]),
      ),
    );
  }

  Widget _buildDropdownField(
      VoidCallback onTap, ClassAttendanceHomeViewModel viewModel) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        height: 48.h,
        width: 268.w,
        decoration: BoxDecoration(
          color: Color(0xFFED7902),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: Colors.white,
            width: 2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 7.1.r,
              offset: Offset(0.w, 3.h),
            ),
          ],
        ),
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 10.w),
            Text(
              viewModel.selectedClass.isNotEmpty
                  ? 'Class : ${viewModel.selectedClass}'
                  : 'Select Class',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 12.w),
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

  void openBottomDrawerDropDown(BuildContext context, StudentViewModel stvm) {
    final viewModel =
        Provider.of<ClassAttendanceHomeViewModel>(context, listen: false);

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
                            if (tempClass != null) {
                              viewModel.updateClass(tempClass!);
                            }

                            Navigator.pop(context);
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

// class CalendarBottomSheet extends StatefulWidget {
//   final DateTime initialDate;
//   final ValueChanged<DateTime> onDateSelected;
//   final String hintText;

//   const CalendarBottomSheet(
//       {super.key,
//       required this.initialDate,
//       required this.onDateSelected,
//       this.hintText = ''});

//   @override
//   _CalendarBottomSheetState createState() => _CalendarBottomSheetState();
// }

// class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
//   late DateTime selectedDate;

//   @override
//   void initState() {
//     super.initState();
//     selectedDate = widget.initialDate;
//   }

//   void _changeMonth(int offset) {
//     setState(() {
//       selectedDate = DateTime(
//           selectedDate.year, selectedDate.month + offset, selectedDate.day);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentMonth = DateFormat('MMMM yyyy').format(selectedDate);
//     final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
//     final lastDayOfMonth =
//         DateTime(selectedDate.year, selectedDate.month + 1, 0);
//     final days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

//     final firstWeekdayOfMonth = firstDayOfMonth.weekday % 7;
//     final totalDays = firstWeekdayOfMonth + lastDayOfMonth.day;
//     final totalWeeks = ((totalDays + 6) ~/ 7);
//     final today = DateTime.now();

//     return Container(
//       padding: EdgeInsets.all(24.r),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             height: 4.h,
//             width: 164.w,
//             decoration: BoxDecoration(
//               color: Color(0xFFD9D9D9),
//               borderRadius: BorderRadius.circular(22.r),
//             ),
//           ),

//           if (widget.hintText.isNotEmpty) ...[
//             SizedBox(height: 15.h),
//             Text(
//               widget.hintText,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 15.sp,
//                 color: Color(0xFF494949),
//               ),
//             ),
//           ],

//           SizedBox(height: 20.h),
//           // Month navigation row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.arrow_left, color: Colors.black),
//                 onPressed: () => _changeMonth(-1),
//               ),
//               Text(
//                 currentMonth,
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.arrow_right, color: Colors.black),
//                 onPressed: () => _changeMonth(1),
//               ),
//             ],
//           ),
//           SizedBox(height: 16.h),
//           // Days of the week header
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: days.map((day) {
//               // Convert weekday to match the days list index (Sunday = 0)
//               final currentWeekday = selectedDate.weekday % 7;
//               final isSelectedDay = days.indexOf(day) == currentWeekday;

//               return Expanded(
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 4.h),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color:
//                         isSelectedDay ? Color(0xFFED7902) : Colors.transparent,
//                     borderRadius: BorderRadius.circular(5.r),
//                   ),
//                   child: Text(
//                     day,
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: isSelectedDay ? Colors.white : Colors.black54,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//           SizedBox(height: 8.h),
//           // Calendar grid
//           GridView.count(
//             shrinkWrap: true,
//             crossAxisCount: 7,
//             childAspectRatio: 1.0,
//             mainAxisSpacing: 8,
//             crossAxisSpacing: 8,
//             children: List.generate(totalWeeks * 7, (index) {
//               final dayOffset = index - firstWeekdayOfMonth;
//               if (dayOffset < 0 || dayOffset >= lastDayOfMonth.day) {
//                 return Container(); // Empty space
//               }

//               final date = DateTime(
//                   selectedDate.year, selectedDate.month, dayOffset + 1);
//               final isSelected = selectedDate.year == date.year &&
//                   selectedDate.month == date.month &&
//                   selectedDate.day == date.day;

//               final isFutureDate = date.isAfter(today);

//               return InkWell(
//                 onTap: isFutureDate
//                     ? null
//                     : () {
//                         setState(() {
//                           selectedDate = date;
//                         });
//                         widget.onDateSelected(selectedDate);
//                         Navigator.pop(context); // Close the bottom sheet
//                       },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: isSelected
//                         ? Color(0xFFED7902)
//                         : (isFutureDate ? Colors.grey.shade200 : Colors.white),
//                     shape: BoxShape.circle,
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     "${dayOffset + 1}",
//                     style: TextStyle(
//                       color: isSelected
//                           ? Colors.white
//                           : (isFutureDate ? Colors.grey : Colors.black),
//                       fontWeight:
//                           isSelected ? FontWeight.bold : FontWeight.normal,
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           ),
//           SizedBox(height: 20.h),
//         ],
//       ),
//     );
//   }
// }

// import 'package:ezskool/core/services/logger.dart';
// import 'package:ezskool/data/repo/home_repo.dart';
// import 'package:ezskool/data/viewmodels/class_attendance/class_attendance_home_viewmodel.dart';
// import 'package:ezskool/presentation/dialogs/custom_dialog.dart';
// import 'package:ezskool/presentation/views/base_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:ezskool/presentation/drawers/custom_bottom_drawers.dart';
// import 'package:provider/provider.dart';
//
// import '../../../data/datasources/local/db/app_database.dart';
// import '../../../data/repo/class_student_repo.dart';
// import '../../../data/viewmodels/class_attendance/class_attendance_viewmodel.dart';
// import '../../../main.dart';
// import '../../responsiveness/screen_utils.dart';
//
// class NewClassAttendanceHomeScreen extends StatefulWidget {
//   const NewClassAttendanceHomeScreen({super.key});
//
//   @override
//   _NewClassAttendanceHomeScreenState createState() =>
//       _NewClassAttendanceHomeScreenState();
// }
//
// enum ViewState { calendar, qrScanner, manualAttendance }
//
// class _NewClassAttendanceHomeScreenState
//     extends State<NewClassAttendanceHomeScreen> {
//   final repoClassStudent = ClassStudentRepo();
//   final homeRepo = HomeRepo();
//   DateTime selectedDate = DateTime.now();
//   ViewState _currentView = ViewState.calendar;
//
//   String? selectedStandard;
//   String? selectedDivision;
//   bool isDropdownOpen = false;
//
//   bool isLoading = true;
//
//   // Sample list for dropdown boxes
//   List<String> standards = List.generate(12, (index) => '${index + 1}');
//   List<String> divisions = [];
//
//   String? tempStandard = '';
//   String? tempDivision = '';
//
//   // List<String> standards = List.generate(10, (index) => '${index + 1}');
//
//   // final List<String> _days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
//
//   @override
//   void initState() {
//     super.initState();
//     getLoginSync();
//     loadLD();
//   }
//
//   Future<void> loadLD() async {
//     await homeRepo.loginSyncLrDiv();
//     divisions = await HomeRepo.dropdownDao.getDropdownValues('div');
//
//     Provider.of<ClassAttendanceHomeViewModel>(
//             navigatorKey.currentState!.context,
//             listen: false)
//         .setDivisions(divisions);
//
//     isLoading = false;
//   }
//
//   Future<void> getLoginSync() async {
//     final data = await repoClassStudent.fetchTestClassStudentData(
//         '2', DateFormat('yyyy-MM-dd').format(selectedDate));
//     await ClassStudentRepo.storeTestClassStudentData(data);
//
//     Log.d(data);
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<ClassAttendanceHomeViewModel>(context);
//     final clvmdl = Provider.of<ClassAttendanceViewModel>(context);
//
//     //viewModel.setStandards(divisions);
//
//     return BaseScreen(
//       child: SingleChildScrollView(
//         padding: EdgeInsets.all(16.r),
//         child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Attendance",
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF494949),
//                 ),
//               ),
//               SizedBox(height: 14.h),
//               Text(
//                 'Select a date and class',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontWeight: FontWeight.w400,
//                   fontSize: 15.sp,
//                   color: Color(0xFFA29595),
//                 ),
//               ),
//               SizedBox(height: 16.h),
//
//               Container(
//                 width: 268.w,
//                 height: 44.h,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFED7902), // Orange background
//                   borderRadius: BorderRadius.circular(6.r),
//                   border: Border.all(
//                     color: Colors.white,
//                     width: 2.w,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.25),
//                       blurRadius: 7.1.r,
//                       offset:
//                           Offset(0.w, 3.h),
//                     ),
//                   ],
//                 ),
//                 child: Material(
//                   color: Colors.transparent,
//                   child: InkWell(
//                     onTap: () {
//                       showModalBottomSheet(
//                           context: context,
//                           isScrollControlled: true,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.vertical(
//                                 top: Radius.circular(20.r)),
//                           ),
//                           builder: (context) => SingleChildScrollView(
//                                 child: Container(
//                                     padding: EdgeInsets.only(
//                                       bottom: MediaQuery.of(context)
//                                           .viewInsets
//                                           .bottom,
//                                     ),
//                                     child: CalendarBottomSheet(
//                                       initialDate: selectedDate,
//                                       onDateSelected: (selectedDate) {
//                                         viewModel.date = selectedDate;
//                                         // Update the ViewModel with the selected date
//                                         setState(() {
//                                           this.selectedDate = selectedDate;
//                                         });
//                                       },
//                                     )),
//                               ));
//                     },
//                     borderRadius: BorderRadius.circular(6.r),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 20.w),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           // Icon at the left
//                           Icon(
//                             Icons.calendar_month,
//                             color: Colors.white,
//                           ),
//                           // Date text in the center
//                           Text(
//                             DateFormat('EEE, dd MMM, yyyy')
//                                 .format(viewModel.date),
//                             style: TextStyle(
//                               fontSize: 20.sp,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16.h),
//               SizedBox(
//                 height: 450.h,
//                 width: double.infinity.w,
//                 // decoration: BoxDecoration(
//                 //   borderRadius: BorderRadius.only(
//                 //     topLeft: Radius.circular(36),
//                 //     topRight: Radius.circular(36),
//                 //   ),
//                 //   color: Colors.white,
//                 // ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // SizedBox(height: 13),
//                     // Container(
//                     //   height: 4,
//                     //   width: 164,
//                     //   decoration: BoxDecoration(
//                     //     color: Color(0xFFD9D9D9),
//                     //     borderRadius: BorderRadius.circular(22),
//                     //   ),
//                     // ),
//                     // SizedBox(height: 10),
//                     //Spacer(),
//
//                     Text(
//                       'Select Standard',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w400,
//                         fontSize: 16.sp,
//                         height: 1.5.h,
//                         color: Color(0xFFA29595),
//                       ),
//                     ),
//                     // SizedBox(height: 20),
//
//                     SizedBox(
//                       height: 250.h,
//                       child: GridView.builder(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 32.w,),
//                         shrinkWrap: true,
//                         itemCount: standards.length,
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 4,
//                           crossAxisSpacing: 20.w,
//                           mainAxisSpacing: 20.h,
//                         ),
//                         itemBuilder: (context, index) {
//                           final isSelected = tempStandard == standards[index];
//                           return GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 tempStandard = standards[index];
//                               });
//                               viewModel.selectedStandard = tempStandard!;
//                             },
//                             child: Container(
//                               height: 51.h,
//                               width: 58.w,
//                               decoration: BoxDecoration(
//                                 color: isSelected
//                                     ? Color(0xFFED7902)
//                                     : Color(0xFFFFE8D1),
//                                 border: Border.all(color: Color(0xFFE2E2E2)),
//                                 borderRadius: BorderRadius.circular(
//                                     5.r),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black
//                                         .withOpacity(0.25),
//                                     offset: Offset(0.w,
//                                         2.h),
//                                     blurRadius: 4.r,
//                                   ),
//                                 ],
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   standards[index],
//                                   style: TextStyle(
//                                     // fontFamily: GoogleFonts.poppinsTextTheme(),
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 24.sp,
//                                     height: 1.5.h,
//                                     color: isSelected
//                                         ? Color(0xFFF5F5F7)
//                                         : Color(0xFF494949),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//
//                     //SizedBox(height: 10)),
//                     // Spacer(),
//                     Text(
//                       'Select Division',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w400,
//                         fontSize: 16.sp,
//                         height: 1.5.h,
//                         color: Color(0xFFA29595),
//                       ),
//                     ),
//                     // SizedBox(height: 20),
//
//                     SizedBox(
//                       height: 80.h,
//                       child: isLoading
//                           ? Center(
//                               child: CircularProgressIndicator(
//                               color: Color(0xFFED7902),
//                             ))
//                           : GridView.builder(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 32.w),
//                               shrinkWrap: true,
//                               itemCount: viewModel.divisions.length,
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 4,
//                                 crossAxisSpacing: 20.w,
//                                 mainAxisSpacing: 20.h,
//                               ),
//                               itemBuilder: (context, index) {
//                                 final isSelected =
//                                     tempDivision == viewModel.divisions[index];
//                                 return GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       tempDivision = viewModel.divisions[index];
//                                     });
//                                     viewModel.selectedDivision = tempDivision!;
//                                     Log.d(viewModel.selectedDivision);
//                                   },
//                                   child: Container(
//                                     height: 51.h,
//                                     width: 58.w,
//                                     decoration: BoxDecoration(
//                                       color: isSelected
//                                           ? Color(0xFFED7902)
//                                           : Color(0xFFFFE8D1),
//                                       border:
//                                           Border.all(color: Color(0xFFE2E2E2)),
//                                       borderRadius: BorderRadius.circular(
//                                           5.r),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black.withOpacity(
//                                               0.25),
//                                           offset: Offset(0.w,
//                                               2.h),
//                                           blurRadius: 4.r,
//                                         ),
//                                       ],
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         viewModel.divisions[index],
//                                         style: TextStyle(
//                                             // fontFamily: 'Poppins',
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 24.sp,
//                                             height: 1.5.h,
//                                             color: isSelected
//                                                 ? Color(0xFFF5F5F7)
//                                                 : Color(0xFF494949)
//                                             // Color(0x49494949),
//                                             ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                     ),
//
//                     //SizedBox(height: 20,),
//                     // Spacer(),
//                   ],
//                 ),
//               ),
//
//               SizedBox(
//                 height: 50.h,
//               ),
//
//               Divider(
//                 indent: 20.w,
//                 endIndent: 20.w,
//                 color: Colors.grey[400],
//                 thickness: 1,
//                 height: 1.h,
//               ),
//
//               // Spacer(),
//
//               SizedBox(height: 10.h,),
//               Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // Button 1: Gray background
//                       ElevatedButton(
//                         onPressed: () {
//                           // viewModel.selectedDivision = '';
//                           // viewModel.selectedStandard = '';
//                           // setState(() {
//                           //   tempDivision = '';
//                           //   tempStandard = '';
//                           // });
//
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xF5F5F5F5),
//                           // Gray background
//                           shadowColor:
//                           Colors.black.withOpacity(0.5),
//                           // Drop shadow
//                           elevation: 4,
//                           // Shadow elevation
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(
//                                 5.r), // Rounded corners
//                           ),
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 22.w,
//                               vertical: 10.h,)
//                         ),
//                         child: Text(
//                           "Close", // Replace with actual text
//                           style: TextStyle(
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14.sp,
//                             letterSpacing: 0.4,
//                             color: Color(0xFF494949), // Text color
//                           ),
//                         ),
//                       ),
//                       // Button 2: Orange background
//                       SizedBox(width: 20.w),
//
//                       ElevatedButton(
//                         onPressed: () async {
//                           showDialog(
//                             context: context,
//                             barrierDismissible: false,
//                             builder: (BuildContext context) {
//                               return Center(
//                                 child: CircularProgressIndicator(
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                       Color(0xFFED7902)),
//                                   strokeWidth: 5,
//                                   backgroundColor: Colors.white.withOpacity(0.3),
//                                 ),
//                               );
//                             },
//                           );
//                           if (viewModel.selectedStandard.isNotEmpty &&
//                               viewModel.selectedDivision.isNotEmpty) {
//                             // await deleteDatabase();
//                             // await getLoginSync();
//                             try {
//                               await clvmdl.initializeAttendanceList();
//                               viewModel.updateDate(DateFormat('d MMM yyyy, EEEE')
//                                   .format(selectedDate));
//                               Navigator.of(context, rootNavigator: true).pop();
//                               Navigator.pushNamed(context, '/clsatt');
//                             } catch (e) {
//                               Navigator.of(context, rootNavigator: true).pop();
//                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                   content:
//                                   Text('Data Not Found for this Class')));
//                             }
//                           } else {
//                             Navigator.of(context, rootNavigator: true).pop();
//                             showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return CustomDialog(
//                                     title: 'Class Not Selected',
//                                     height: 360.h,
//                                     message:
//                                     'Please select a class before proceeding with attendance.',
//                                     buttonText: 'Ok',
//                                     icon: Icons.error_outline,
//                                     iconColor: Color(0xFFED7902),
//                                     backgroundColor: Color(0xFFED7902),
//                                     // Consistent error theme
//                                     onButtonPressed: () {
//                                       Navigator.pop(
//                                           context); // Close the dialog and allow retry
//                                     },
//                                   );
//                                 });
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFFED7902),
//                           // Orange background
//                           shadowColor:
//                           Colors.black.withOpacity(0.5),
//                           // Drop shadow
//                           elevation: 4,
//                           // Shadow elevation
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5.r), // Rounded corners
//                           ),
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 22.w,
//                               vertical: 10.h,)
//                         ),
//                         child: Text(
//                           "Confirm", // Replace with actual text
//                           style: TextStyle(
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14.sp,
//                             letterSpacing: 0.4.w,
//                             color: Color(0xFFFAECEC), // Text color
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//               ),
//               // SizedBox(height: 16.h,),
//
//               // Spacer(),
//             ]),
//       ),
//     );
//   }
// }
//
// void showCalendarBottomSheet(
//     BuildContext context, ClassAttendanceHomeViewModel vm) {}
//
// class CalendarBottomSheet extends StatefulWidget {
//   final DateTime initialDate;
//   final ValueChanged<DateTime> onDateSelected;
//
//   const CalendarBottomSheet({
//     Key? key,
//     required this.initialDate,
//     required this.onDateSelected,
//   }) : super(key: key);
//
//   @override
//   _CalendarBottomSheetState createState() => _CalendarBottomSheetState();
// }
//
// class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
//   late DateTime selectedDate;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedDate = widget.initialDate;
//   }
//
//   void _changeMonth(int offset) {
//     setState(() {
//       selectedDate = DateTime(
//           selectedDate.year, selectedDate.month + offset, selectedDate.day);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final currentMonth = DateFormat('MMMM yyyy').format(selectedDate);
//     final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
//     final lastDayOfMonth =
//         DateTime(selectedDate.year, selectedDate.month + 1, 0);
//     final days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
//
//     final firstWeekdayOfMonth = firstDayOfMonth.weekday % 7;
//     final totalDays = firstWeekdayOfMonth + lastDayOfMonth.day;
//     final totalWeeks = ((totalDays + 6) ~/ 7);
//     final today = DateTime.now();
//
//     return Container(
//       padding: EdgeInsets.all(24.r),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             height: 4.h,
//             width: 164.w,
//             decoration: BoxDecoration(
//               color: Color(0xFFD9D9D9),
//               borderRadius: BorderRadius.circular(22.r),
//             ),
//           ),
//           SizedBox(height: 20.h),
//           // Month navigation row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.arrow_left, color: Colors.black),
//                 onPressed: () => _changeMonth(-1),
//               ),
//               Text(
//                 currentMonth,
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.arrow_right, color: Colors.black),
//                 onPressed: () => _changeMonth(1),
//               ),
//             ],
//           ),
//           SizedBox(height: 16.h),
//           // Days of the week header
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: days.map((day) {
//               // Convert weekday to match the days list index (Sunday = 0)
//               final currentWeekday = selectedDate.weekday % 7;
//               final isSelectedDay = days.indexOf(day) == currentWeekday;
//
//               return Expanded(
//                 child: Container(
//                   padding:
//                       EdgeInsets.symmetric(vertical: 4.h),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color:
//                         isSelectedDay ? Color(0xFFED7902) : Colors.transparent,
//                     borderRadius: BorderRadius.circular(5.r),
//                   ),
//                   child: Text(
//                     day,
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: isSelectedDay ? Colors.white : Colors.black54,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//           SizedBox(height: 8.h),
//           // Calendar grid
//           GridView.count(
//             shrinkWrap: true,
//             crossAxisCount: 7,
//             childAspectRatio: 1.0,
//             mainAxisSpacing: 8,
//             crossAxisSpacing: 8,
//             children: List.generate(totalWeeks * 7, (index) {
//               final dayOffset = index - firstWeekdayOfMonth;
//               if (dayOffset < 0 || dayOffset >= lastDayOfMonth.day) {
//                 return Container(); // Empty space
//               }
//
//               final date = DateTime(
//                   selectedDate.year, selectedDate.month, dayOffset + 1);
//               final isSelected = selectedDate.year == date.year &&
//                   selectedDate.month == date.month &&
//                   selectedDate.day == date.day;
//
//               final isFutureDate = date.isAfter(today);
//
//               return InkWell(
//                 onTap: isFutureDate
//                     ? null
//                     : () {
//                         setState(() {
//                           selectedDate = date;
//                         });
//                         widget.onDateSelected(selectedDate);
//                         Navigator.pop(context); // Close the bottom sheet
//                       },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: isSelected
//                         ? Color(0xFFED7902)
//                         : (isFutureDate ? Colors.grey.shade200 : Colors.white),
//                     shape: BoxShape.circle,
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     "${dayOffset + 1}",
//                     style: TextStyle(
//                       color: isSelected
//                           ? Colors.white
//                           : (isFutureDate ? Colors.grey : Colors.black),
//                       fontWeight:
//                           isSelected ? FontWeight.bold : FontWeight.normal,
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           ),
//           SizedBox(height: 20.h),
//         ],
//       ),
//     );
//   }
// }
