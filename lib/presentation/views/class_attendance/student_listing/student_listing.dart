import 'dart:async';

import 'package:ezskool/core/services/logger.dart';
import 'package:ezskool/data/viewmodels/class_attendance/student_listing_viewmodel.dart';
import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:ezskool/presentation/views/class_attendance/student_listing/student_list.dart';
import 'package:ezskool/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../data/repo/student_repo.dart';

class StudentListingScreen extends StatefulWidget {
  const StudentListingScreen({super.key});

  @override
  _StudentListingScreenState createState() => _StudentListingScreenState();
}

class _StudentListingScreenState extends State<StudentListingScreen> {
  List<Map<String, dynamic>> cardData = [];
  final stRepo = StudentRepository();
  bool isLoading = true;

  List<bool> isToggled = []; // Move isToggled to class level

  late Timer _timer;

  //List<bool>? isToggled;

  @override
  void initState() {
    super.initState();

    load();

    // startPeriodicRequest();
  }

  void startPeriodicRequest() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      load(); // Fetch new data every 5 seconds
    });
  }

  // @override
  // void dispose() {
  //   _timer.cancel(); // Cancel the timer when the widget is disposed
  //   super.dispose();
  // }

  Future<void> load() async {
    setState(() {
      isLoading = true;
    });

    final cls = await stRepo.getAllClasses();

    cardData = cls;

    isToggled = List.filled(cls.length, false);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchAndLoadStudents(
      StudentViewModel viewModel, String classId) async {
    try {
      final jsonData =
          await stRepo.fetchAllStudents(classId); // Await the result
      Log.d(jsonData);
      viewModel.loadStudents(
          jsonData); // Now, jsonData contains the resolved API response
    } catch (e) {
      print("Error fetching students: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StudentViewModel>(context);

    // if(viewModel.cardData.isNotEmpty){
    //   viewModel.cardData.clear();
    // }

    viewModel.cardData = cardData;
    return BaseScreen(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Student Listing",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF494949),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "Select Class",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xFF494949),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.all(16.r),
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      color: Color(0xFFED7902),
                    ))
                  : GridView.builder(
                      shrinkWrap: true,
                      physics:
                          AlwaysScrollableScrollPhysics(), // Prevents inner scrolling
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // Three cards per row
                        crossAxisSpacing: 16.w, // Spacing between columns
                        mainAxisSpacing: 16.h, // Spacing between rows
                        childAspectRatio: 80 / 77, // Card width-to-height ratio
                      ),
                      itemCount: cardData.length,
                      itemBuilder: (context, index) {
                        List<bool> isToggled =
                            List.filled(cardData.length, false);
                        final data = cardData[index];
                        return StatefulBuilder(
                          builder: (context, setState) {
                            // To track card color state
                            return GestureDetector(
                              onTap: () async {
                                startShowing(context);
                                setState(() {
                                  isToggled[index] = isToggled[index];
                                });
                                await Future.delayed(
                                    const Duration(milliseconds: 80));

                                Log.d(data['title']);

                                viewModel.setClassName(data['title']);

                                // final id = await StudentRepository.classDao.getClassIdByName(data['title'].replaceAll(" ", "-"));

                                //fetchAndLoadStudents(viewModel, data['classId'].toString());

                                stopShowing(context);

                                setState(() {
                                  isToggled[index] = isToggled[index];
                                });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StudentListScreen(
                                      title: data['title'],
                                      count: data['count'],
                                      label: data['label'],
                                      classId: data['classId'].toString(),
                                    ),
                                  ),
                                );
                              },
                              child: AnimatedContainer(
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 40.w, // Line width
                                      height: 1.h, // Line height
                                      color: Colors.white, // Line color
                                      margin:
                                          EdgeInsets.symmetric(vertical: 4.h),
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
                                      margin:
                                          EdgeInsets.symmetric(vertical: 4.h),
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
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
