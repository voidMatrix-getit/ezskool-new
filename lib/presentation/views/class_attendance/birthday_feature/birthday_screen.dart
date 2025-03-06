import 'package:ezskool/data/repo/student_repo.dart';
import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:ezskool/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../data/repo/home_repo.dart';
import '../../../../data/viewmodels/class_attendance/class_attendance_home_viewmodel.dart';
import '../../../../data/viewmodels/class_attendance/student_listing_viewmodel.dart';

class ClassesData {
  final int id;
  final int stdId;
  final String division;
  final String className;

  ClassesData({
    required this.id,
    required this.stdId,
    required this.division,
    required this.className,
  });
}

class Student {
  final int studentId;
  final String name;
  final DateTime dob;
  final String className;
  final int gender;
  final int classId; // Added classId

  Student({
    required this.studentId,
    required this.name,
    required this.dob,
    required this.className,
    required this.gender,
    required this.classId,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['student_id'],
      name: json['name'],
      dob: DateTime.parse(json['dob']),
      className: json['class'],
      gender: json['gender'],
      classId: json['class_id'],
    );
  }
}

class BirthdaySearchScreen extends StatefulWidget {
  const BirthdaySearchScreen({super.key});

  @override
  State<BirthdaySearchScreen> createState() => _BirthdaySearchScreenState();
}

class _BirthdaySearchScreenState extends State<BirthdaySearchScreen> {
  String selectedFilter = 'This Week';
  DateTime? fromDate;
  DateTime? toDate;
  List<Student> allStudents = [];
  List<Student> filteredStudents = [];
  List<ClassesData> allClasses = [];
  ClassesData? selectedClass;
  final homeRepo = HomeRepo();
  final stRepo = StudentRepository();
  List<String> standards = List.generate(10, (index) => '${index + 1}');

  bool isLoading = true; //
  List<Map<String, dynamic>> cardData = [];
  String? tempClass = '';
  int? classId;

  @override
  void initState() {
    super.initState();

    // loadAll();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadAll();
    });
  }

  Future<void> loadAll() async {
    setState(() {
      isLoading = true;
    });

    // Parse API data when received

    Provider.of<ClassAttendanceHomeViewModel>(context, listen: false)
        .updateClass('');

    // String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // loadClasses();
    // parseApiData(currentDate,currentDate);
    // applyFilters();
    _setDatesBasedOnFilter('This Week');
    // final now = DateTime.now();
    // final firstDayOfMonth = DateTime(now.year, now.month, 1);
    // final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    //
    // // Format dates for API
    // final fromDateStr = DateFormat('yyyy-MM-dd').format(firstDayOfMonth);
    // final toDateStr = DateFormat('yyyy-MM-dd').format(lastDayOfMonth);

    // parseApiData(fromDateStr, toDateStr).then((_) {
    //   applyFilters();  // Apply filters after data is loaded
    // });
    //_fetchDataForCurrentFilter();

    await Future.wait([
      loadClasses(),
      _fetchDataForCurrentFilter(),
    ]);

    //await loadClasses();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadClasses() async {
    final cls = await stRepo.getAllClasses();

    setState(() {
      cardData = cls;
    });
  }

  void _setDatesBasedOnFilter(String filter) {
    final now = DateTime.now();

    setState(() {
      switch (filter) {
        case 'Today':
          fromDate = now;
          toDate = now;
          break;
        case 'Tomorrow':
          final tomorrow = now.add(const Duration(days: 1));
          fromDate = tomorrow;
          toDate = tomorrow;
          break;
        case 'This Week':
          // Calculate the date range for the current week
          final currentWeekday = now.weekday;
          fromDate = now;
          toDate = now.add(Duration(days: 6 - currentWeekday + 1));
          break;
        default:
          fromDate = now;
          toDate = now;
      }
    });
  }

  Future<void> _fetchDataForCurrentFilter() async {
    if (fromDate != null && toDate != null) {
      final fromDateStr = DateFormat('yyyy-MM-dd').format(fromDate!);
      final toDateStr = DateFormat('yyyy-MM-dd').format(toDate!);
      parseApiData(fromDateStr, toDateStr).then((_) {
        applyFilters();
      });
    }
  }

  // Update the filter selection handler
  void onFilterSelected(String filter) {
    setState(() {
      selectedFilter = filter;
      _setDatesBasedOnFilter(filter);
      // if (filter != '') {
      //   fromDate = null;
      //   toDate = null;
      // }
      _fetchDataForCurrentFilter();
      // fromDate = null;  // Clear date selection
      // toDate = null;    // Clear date selection
      //
      // // Load appropriate date range based on filter
      // final now = DateTime.now();
      // String fromDateStr;
      // String toDateStr;
      //
      // switch (filter) {
      //   case 'Today':
      //     fromDateStr = toDateStr = DateFormat('yyyy-MM-dd').format(now);
      //     break;
      //   case 'Tomorrow':
      //     final tomorrow = now.add(const Duration(days: 1));
      //     fromDateStr = toDateStr = DateFormat('yyyy-MM-dd').format(tomorrow);
      //     break;
      //   case 'This Week':
      //     final weekStart = now.subtract(Duration(days: now.weekday - 1));
      //     final weekEnd = weekStart.add(const Duration(days: 6));
      //     fromDateStr = DateFormat('yyyy-MM-dd').format(weekStart);
      //     toDateStr = DateFormat('yyyy-MM-dd').format(weekEnd);
      //     break;
      //   case 'This Month':
      //     final firstDayOfMonth = DateTime(now.year, now.month, 1);
      //     final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
      //     fromDateStr = DateFormat('yyyy-MM-dd').format(firstDayOfMonth);
      //     toDateStr = DateFormat('yyyy-MM-dd').format(lastDayOfMonth);
      //     break;
      //   default:
      //     return;
      // }
      //
      // // Fetch new data based on selected filter
      // parseApiData(fromDateStr, toDateStr).then((_) {
      //   applyFilters();
      // });
    });
  }

  // Future<void> loadClasses() async {
  //   try {
  //     // Assuming you have access to your database helper or repository
  //     final classes = await StudentRepository.classDao.getAllClasses();
  //     setState(() {
  //       allClasses = classes.cast<ClassesData>();
  //     });
  //   } catch (e) {
  //     print('Error loading classes: $e');
  //   }
  // }

  Future<void> parseApiData(String fromDate, String toDate) async {
    Map<String, dynamic> apiResponse =
        await stRepo.fetchBirthdays(fromDate, toDate);
    if (apiResponse['success'] == true && apiResponse['data'] != null) {
      allStudents = [];
      for (var dateData in apiResponse['data']) {
        for (var classData in dateData['classes']) {
          final classId = classData['class_id'];
          for (var studentData in classData['students']) {
            studentData['class_id'] = classId;
            allStudents.add(Student.fromJson(studentData));
          }
        }
      }
    }
  }

  void applyFilters() {
    final viewModel =
        Provider.of<ClassAttendanceHomeViewModel>(context, listen: false);
    setState(() {
      filteredStudents = allStudents.where((student) {
        // Apply class filter if selected
        if (viewModel.selectedClass.isNotEmpty) {
          final selectedClass = viewModel.selectedClass.replaceAll(' ', '-');
          if (student.className != selectedClass) {
            return false;
          }
        }

        final birthday =
            DateTime(DateTime.now().year, student.dob.month, student.dob.day);
        final now = DateTime.now();

        // If a custom date range is selected
        if (selectedFilter.isEmpty && fromDate != null && toDate != null) {
          return isDateInRange(birthday, fromDate!, toDate!, checkYear: false);
        }

        // Apply radio button filters
        switch (selectedFilter) {
          case 'Today':
            final today = DateTime(now.year, now.month, now.day);
            final studentBirthday =
                DateTime(now.year, student.dob.month, student.dob.day);
            return studentBirthday.isAtSameMomentAs(today);

          case 'Tomorrow':
            final tomorrow = DateTime(now.year, now.month, now.day + 1);
            final studentBirthday =
                DateTime(now.year, student.dob.month, student.dob.day);
            return studentBirthday.isAtSameMomentAs(tomorrow);

          case 'This Week':
            final weekStart = now.subtract(Duration(days: now.weekday - 1));
            final weekEnd = weekStart.add(const Duration(days: 6));
            final studentBirthday =
                DateTime(now.year, student.dob.month, student.dob.day);
            return studentBirthday
                    .isAfter(weekStart.subtract(const Duration(days: 1))) &&
                studentBirthday.isBefore(weekEnd.add(const Duration(days: 1)));

          case 'This Month':
            return student.dob.month == now.month;

          default:
            return true;
        }
      }).toList();

      // Sort by upcoming birthday
      filteredStudents.sort((a, b) {
        final now = DateTime.now();
        final aDate = DateTime(now.year, a.dob.month, a.dob.day);
        final bDate = DateTime(now.year, b.dob.month, b.dob.day);

        // If birthday has already passed this year, consider it for next year
        final adjustedADate = aDate.isBefore(now)
            ? DateTime(now.year + 1, a.dob.month, a.dob.day)
            : aDate;
        final adjustedBDate = bDate.isBefore(now)
            ? DateTime(now.year + 1, b.dob.month, b.dob.day)
            : bDate;

        return adjustedADate.compareTo(adjustedBDate);
      });
    });
  }

  //  void applyFilters() {
  //   final viewModel = Provider.of<ClassAttendanceHomeViewModel>(context, listen: false);
  //   setState(() {
  //     filteredStudents = allStudents.where((student) {
  //
  //       if (viewModel.selectedStandard.isNotEmpty && viewModel.selectedDivision.isNotEmpty) {
  //         final selectedClass = '${viewModel.selectedStandard}-${viewModel.selectedDivision}';
  //         if (student.className != selectedClass) {
  //           return false;
  //         }
  //       }
  //
  //
  //
  //       final birthday = DateTime(DateTime.now().year, student.dob.month, student.dob.day);
  //       final now = DateTime.now();
  //
  //       if (selectedFilter.isEmpty && fromDate != null && toDate != null) {
  //         return isDateInRange(birthday, fromDate!, toDate!, checkYear: false);
  //       }
  //
  //
  //       switch (selectedFilter) {
  //         case 'Today':
  //           return birthday.month == now.month && birthday.day == now.day;
  //         case 'Tomorrow':
  //           final tomorrow = now.add(const Duration(days: 1));
  //           return birthday.month == tomorrow.month && birthday.day == tomorrow.day;
  //         case 'This Week':
  //           final weekStart = now.subtract(Duration(days: now.weekday - 1));
  //           final weekEnd = weekStart.add(const Duration(days: 6));
  //           return isDateInRange(birthday, weekStart, weekEnd, checkYear: false);
  //         case 'This Month':
  //           return birthday.month == now.month;
  //         default:
  //           if (fromDate != null && toDate != null) {
  //             return isDateInRange(birthday, fromDate!, toDate!, checkYear: false);
  //           }
  //           return true;
  //       }
  //
  //
  //
  //     }).toList();
  //
  //     // Sort by upcoming birthday
  //     filteredStudents.sort((a, b) {
  //       final now = DateTime.now();
  //       final aDate = DateTime(now.year, a.dob.month, a.dob.day);
  //       final bDate = DateTime(now.year, b.dob.month, b.dob.day);
  //       return aDate.compareTo(bDate);
  //     });
  //   });
  // }

  bool isDateInRange(DateTime date, DateTime start, DateTime end,
      {required bool checkYear}) {
    final compareDate =
        checkYear ? date : DateTime(start.year, date.month, date.day);
    final compareStart =
        checkYear ? start : DateTime(start.year, start.month, start.day);
    final compareEnd =
        checkYear ? end : DateTime(start.year, end.month, end.day);
    return compareDate
            .isAfter(compareStart.subtract(const Duration(days: 1))) &&
        compareDate.isBefore(compareEnd.add(const Duration(days: 1)));
  }

  Map<String, List<Student>> groupStudentsByDate(List<Student> students) {
    final groupedStudents = <String, List<Student>>{};
    for (var student in students) {
      final dateStr = DateFormat('dd-MM-yyyy').format(student.dob);
      groupedStudents.putIfAbsent(dateStr, () => []).add(student);
    }
    return groupedStudents;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassAttendanceHomeViewModel>(context);
    final groupedStudents = groupStudentsByDate(filteredStudents);
    final sortedDates = groupedStudents.keys.toList()..sort();
    final stvm = Provider.of<StudentViewModel>(context);

    // if(viewModel.selectedStandard.isNotEmpty &&
    //     viewModel.selectedDivision.isNotEmpty ){
    //       viewModel.selectedStandard = '';
    //       viewModel.selectedDivision = '';
    // }

    return BaseScreen(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Search Birthdays',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.cake,
                  size: 20.r,
                  color: Color(0xFF626262),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['Today', 'Tomorrow', 'This Week']
                  .map((filter) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = filter;
                          onFilterSelected(selectedFilter);
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
                          Text(
                            filter,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                          SizedBox(width: 12.w),
                        ],
                      )))
                  .toList(),
            ),
            //),

            SizedBox(
              height: 24.h,
            ),

            // Updated Date Range Selectors
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      showCalendarBottomSheet(
                          context, fromDate ?? DateTime.now(),
                          (DateTime selectedDate) {
                        setState(() {
                          fromDate = selectedDate;
                          selectedFilter = '';
                        });

                        if (toDate != null) {
                          startShowing(context);
                          parseApiData(
                                  DateFormat('yyyy-MM-dd').format(fromDate!),
                                  DateFormat('yyyy-MM-dd').format(toDate!))
                              .then((_) {
                            applyFilters();
                            stopShowing(context);
                          });
                        }
                      });

                      // final picked = await showDatePicker(
                      //   context: context,
                      //   barrierColor: Color(0xFFED7902).withOpacity(0.5),
                      //   initialDate: fromDate ?? DateTime.now(),
                      //   firstDate: DateTime(2000),
                      //   lastDate: DateTime(2101),
                      // );
                      //
                      // if (picked != null) {
                      //   setState(() {
                      //     fromDate = picked;
                      //     selectedFilter = '';
                      //   });
                      //
                      //   if(toDate != null){
                      //     startShowing(context);
                      //
                      //     await parseApiData(DateFormat('yyyy-MM-dd').format(fromDate!), DateFormat('yyyy-MM-dd').format(toDate!));
                      //
                      //     applyFilters();
                      //
                      //     stopShowing(context);
                      //   }
                      //
                      // }
                    },
                    child: _buildDateSelector('From', fromDate),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      showCalendarBottomSheet(context, toDate ?? DateTime.now(),
                          (DateTime selectedDate) {
                        setState(() {
                          toDate = selectedDate;
                          selectedFilter = '';
                        });

                        if (fromDate != null) {
                          startShowing(context);
                          parseApiData(
                                  DateFormat('yyyy-MM-dd').format(fromDate!),
                                  DateFormat('yyyy-MM-dd').format(toDate!))
                              .then((_) {
                            applyFilters();
                            stopShowing(context);
                          });
                        }
                      });
                      // final picked = await showDatePicker(
                      //   context: context,
                      //   barrierColor: Color(0xFFED7902).withOpacity(0.5),
                      //   initialDate: toDate ?? DateTime.now(),
                      //   firstDate: DateTime(2000),
                      //   lastDate: DateTime(2101),
                      // );
                      // if (picked != null) {
                      //   setState(() {
                      //     toDate = picked;
                      //     selectedFilter = '';
                      //   });
                      //
                      //   if(fromDate != null){
                      //     startShowing(context);
                      //
                      //     await parseApiData(DateFormat('yyyy-MM-dd').format(fromDate!), DateFormat('yyyy-MM-dd').format(toDate!));
                      //
                      //     applyFilters();
                      //
                      //     stopShowing(context);
                      //   }
                      // }
                    },
                    child: _buildDateSelector('To', toDate),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            GestureDetector(
              onTap: () async {
                openBottomDrawerDropDown(context, stvm);
              },
              child: Container(
                height: 38.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF969AB8),
                    width: 0.5.w,
                  ),
                  borderRadius: BorderRadius.circular(6.r),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        viewModel.selectedClass.isNotEmpty
                            ? 'Class : ${viewModel.selectedClass.replaceAll(' ', '-')}'
                            : 'Select Class',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: viewModel.selectedClass.isNotEmpty
                              ? Color(0xFF1E1E1E)
                              : Color(0xFF969AB8),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_right,
                        color: Color(0xFF969AB8),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Birthday List
            Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Color(0xFFED7902),
                      ))
                    : filteredStudents.isNotEmpty
                        ? ListView.builder(
                            itemCount: sortedDates.length,
                            itemBuilder: (context, index) {
                              final date = sortedDates[index];
                              final studentList = groupedStudents[date] ?? [];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(3.r),
                                    child: Text(
                                      date,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2400FF),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: studentList.map((student) {
                                      return ListTile(
                                        leading: Icon(
                                          student.gender == 1
                                              ? Icons.man
                                              : Icons.woman,
                                          color: student.gender == 1
                                              ? Colors.blue
                                              : Colors.pink,
                                          size: 20.r,
                                        ),
                                        title: Text(
                                          student.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        trailing: Text(
                                          student.className,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  if (index != sortedDates.length - 1)
                                    Divider(
                                        thickness: 1, color: Colors.grey[300]),
                                ],
                              );
                            },
                          )
                        : Center(
                            child: Text('No birthdays found!',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFA19595),
                                )))),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(String label, DateTime? selectedDate) {
    return Container(
      height: 38.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF969AB8),
          width: 0.5.w,
        ),
        borderRadius: BorderRadius.circular(6.r),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? DateFormat('dd-MM-yyyy').format(selectedDate)
                  : label,
              style: TextStyle(
                fontSize: 14.sp,
                color: selectedDate != null
                    ? Colors.black
                    : const Color(0xFF969AB8),
              ),
            ),
            Icon(
              Icons.date_range,
              size: 20.r,
              color: Color(0xFFB8BCCA),
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
                            if (tempClass != null) {
                              viewModel.updateClass(tempClass!);
                            }

                            applyFilters();
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

// Update the showCalendarBottomSheet function
void showCalendarBottomSheet(BuildContext context, DateTime initialDate,
    Function(DateTime) onDateSelected) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(36.r)),
    ),
    builder: (context) => CalendarBottomSheet(
      initialDate: initialDate,
      onDateSelected: onDateSelected,
    ),
  );
}

class CalendarBottomSheet extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarBottomSheet({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  _CalendarBottomSheetState createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  void _changeMonth(int offset) {
    setState(() {
      selectedDate = DateTime(
          selectedDate.year, selectedDate.month + offset, selectedDate.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentMonth = DateFormat('MMMM yyyy').format(selectedDate);
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDayOfMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0);
    final days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    final firstWeekdayOfMonth = firstDayOfMonth.weekday % 7;
    final totalDays = firstWeekdayOfMonth + lastDayOfMonth.day;
    final totalWeeks = ((totalDays + 6) ~/ 7);

    return Container(
      padding: EdgeInsets.all(24.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4.h,
            width: 164.w,
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(22.r),
            ),
          ),
          SizedBox(height: 20.h),
          // Month navigation row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left, color: Colors.black),
                onPressed: () => _changeMonth(-1),
              ),
              Text(
                currentMonth,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_right, color: Colors.black),
                onPressed: () => _changeMonth(1),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Days of the week header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.map((day) {
              final currentWeekday = selectedDate.weekday % 7;
              final isSelectedDay = days.indexOf(day) == currentWeekday;

              return Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        isSelectedDay ? Color(0xFFED7902) : Colors.transparent,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isSelectedDay ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 8.h),
          // Calendar grid
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 7,
            childAspectRatio: 1.0,
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 8.w,
            children: List.generate(totalWeeks * 7, (index) {
              final dayOffset = index - firstWeekdayOfMonth;
              if (dayOffset < 0 || dayOffset >= lastDayOfMonth.day) {
                return Container(); // Empty space
              }

              final date = DateTime(
                  selectedDate.year, selectedDate.month, dayOffset + 1);
              final isSelected = selectedDate.year == date.year &&
                  selectedDate.month == date.month &&
                  selectedDate.day == date.day;

              return InkWell(
                onTap: () {
                  setState(() {
                    selectedDate = date;
                  });
                  widget.onDateSelected(selectedDate);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFFED7902) : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "${dayOffset + 1}",
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

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
//     DateTime(selectedDate.year, selectedDate.month + 1, 0);
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
//                   padding: EdgeInsets.symmetric(vertical: 4.h),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color:
//                     isSelectedDay ? Color(0xFFED7902) : Colors.transparent,
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
//                   setState(() {
//                     selectedDate = date;
//                   });
//                   widget.onDateSelected(selectedDate);
//                   Navigator.pop(context); // Close the bottom sheet
//                 },
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
//                       isSelected ? FontWeight.bold : FontWeight.normal,
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

// import 'package:ezskool/presentation/views/base_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../data/repo/home_repo.dart';
// import '../../../../data/viewmodels/class_attendance/class_attendance_home_viewmodel.dart';
// import '../../../drawers/custom_bottom_drawers.dart';
//
// class Student {
//   final String name;
//   final String birthdate; // Format: 'dd-MM-yyyy'
//   final String section;
//
//   Student({required this.name, required this.birthdate, required this.section});
// }
//
// class BirthdaySearchScreen extends StatefulWidget {
//   const BirthdaySearchScreen({Key? key}) : super(key: key);
//
//   @override
//   State<BirthdaySearchScreen> createState() => _BirthdaySearchScreenState();
// }
//
// class _BirthdaySearchScreenState extends State<BirthdaySearchScreen> {
//   String selectedFilter = 'This Week'; // Default selected filter
//   final List<Student> students = [
//     Student(
//         name: "Neha Kumar Chaturvedi", birthdate: "21-04-2024", section: "5A"),
//     Student(name: "Ravi Shankar Patel", birthdate: "21-04-2024", section: "5A"),
//     Student(
//         name: "Neha Kumar Chaturvedi", birthdate: "25-04-2024", section: "5A"),
//     Student(name: "Ravi Shankar Patel", birthdate: "25-04-2024", section: "5A"),
//     Student(
//         name: "Neha Kumar Chaturvedi", birthdate: "26-04-2024", section: "5A"),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<ClassAttendanceHomeViewModel>(context);
//
//     Map<String, List<Student>> groupedStudents = {};
//     for (var student in students) {
//       groupedStudents.putIfAbsent(student.birthdate, () => []).add(student);
//     }
//
//     List<String> sortedDates = groupedStudents.keys.toList()..sort();
//
//     return BaseScreen(
//         child: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Search Birthday Header
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Search Birthdays',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Icon(
//                 Icons.cake,
//                 size: 20,
//                 color: Color(0xFF626262),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),
//
//           // Filter Buttons
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: ['Today', 'Tomorrow', 'This Week', 'This Month']
//                   .map((filter) => GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedFilter = filter;
//                         });
//                       },
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 18,
//                             height: 18,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: selectedFilter == filter
//                                     ? const Color(0xFFED7902)
//                                     : const Color(0xFF969AB8),
//                                 width: 1,
//                               ),
//                               borderRadius: BorderRadius.circular(13),
//                             ),
//                             child: selectedFilter == filter
//                                 ? Center(
//                                     child: Container(
//                                       width: 12,
//                                       height: 12,
//                                       decoration: const BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: Color(0xFFED7902),
//                                       ),
//                                     ),
//                                   )
//                                 : null,
//                           ),
//                           const SizedBox(width: 2),
//                           Text(
//                             filter,
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xFF1E1E1E),
//                             ),
//                           ),
//                           const SizedBox(width: 2),
//                         ],
//                       )))
//                   .toList(),
//               // children: [
//               //   _buildFilterOption('Today'),
//               //   // const SizedBox(width: 2),
//               //   _buildFilterOption('Tomorrow'),
//               //   // const SizedBox(width: 2),
//               //   _buildFilterOption('This Week'),
//               //   // const SizedBox(width: 2),
//               //   _buildFilterOption('This Month'),
//               // ],
//             ),
//           ),
//           const SizedBox(height: 24),
//
//           // Date Range Selectors
//           Row(
//             children: [
//               Expanded(
//                 child: _buildDateSelector('From'),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: _buildDateSelector('To'),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//
//           // Standard & Division Dropdown
//           GestureDetector(
//             onTap: () async {
//               final divisions =
//                   await HomeRepo.dropdownDao.getDropdownValues('div');
//               viewModel.setDivisions(divisions);
//
//               Future.delayed(Duration(seconds: 2));
//               openBottomDrawerDropDown(context);
//             },
//             child: Container(
//               height: 38,
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: const Color(0xFF969AB8),
//                   width: 0.5,
//                 ),
//                 borderRadius: BorderRadius.circular(6),
//                 color: Colors.white,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       viewModel.selectedStandard.isNotEmpty &&
//                               viewModel.selectedDivision.isNotEmpty
//                           ? 'Class : ${viewModel.selectedStandard} - ${viewModel.selectedDivision}'
//                           : 'Select Standard & Division',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Color(0xFF969AB8),
//                       ),
//                     ),
//                     Icon(
//                       Icons.arrow_right,
//                       color: Color(0xFF969AB8),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           SizedBox(height: 16),
//
//           // Birthday List
//           Expanded(
//             child: ListView.builder(
//               itemCount: sortedDates.length,
//               itemBuilder: (context, index) {
//                 String date = sortedDates[index];
//                 List<Student> studentList = groupedStudents[date] ?? [];
//
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Date Header
//                     Padding(
//                       padding: const EdgeInsets.all(3.0),
//                       child: Text(
//                         date, // Date as header
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF2400FF),
//                         ),
//                       ),
//                     ),
//                     // Student List
//                     Column(
//                       children: studentList.map((student) {
//                         return ListTile(
//
//                           leading: Icon(Icons.person, size: 20),
//                           title: Text(student.name, style: TextStyle(fontWeight:FontWeight.w600, fontSize: 14),),
//                           trailing: Text(student.section,
//                               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                     // Divider if there are more dates
//                     if (index != sortedDates.length - 1)
//                       Divider(thickness: 1, color: Colors.grey[300]),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     ));
//   }
//
//   Widget _buildFilterOption(String text) {
//     final isSelected = selectedFilter == text;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedFilter = text;
//         });
//       },
//       child: Row(
//         children: [
//           Container(
//             width: 18,
//             height: 18,
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: isSelected
//                     ? const Color(0xFFED7902)
//                     : const Color(0xFF969AB8),
//                 width: 1,
//               ),
//               borderRadius: BorderRadius.circular(13),
//             ),
//             child: isSelected
//                 ? Center(
//                     child: Container(
//                       width: 12,
//                       height: 12,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color(0xFFED7902),
//                       ),
//                     ),
//                   )
//                 : null,
//           ),
//           const SizedBox(width: 2),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF1E1E1E),
//             ),
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDateSelector(String label) {
//     return Container(
//       height: 38,
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: const Color(0xFF969AB8),
//           width: 0.5,
//         ),
//         borderRadius: BorderRadius.circular(6),
//         color: Colors.white,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Color(0xFF969AB8),
//               ),
//             ),
//             Icon(
//               Icons.calendar_today,
//               size: 20,
//               color: Color(0xFFB8BCCA),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
