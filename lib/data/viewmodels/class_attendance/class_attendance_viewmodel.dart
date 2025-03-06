import 'package:ezskool/core/services/logger.dart';
import 'package:ezskool/data/datasources/local/db/app_database.dart';
import 'package:ezskool/data/repo/home_repo.dart';
import 'package:ezskool/data/repo/student_repo.dart';
import 'package:ezskool/data/viewmodels/class_attendance/class_attendance_home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../repo/class_student_repo.dart';

class ClassAttendanceViewModel extends ChangeNotifier {
  final BuildContext context;

  final ClassStudentRepo clstrepo = ClassStudentRepo();
  bool isLoading = true;
  // Attendance data
  final Map<int, bool> attendanceList =
      {}; // RollNo: true (present), false (absent)
  final Map<int, String> getStudentsList = {};
  final Map<int, int> getGender = {};
  final List<TestStudent> getStudents = [];

  int? classAttId;

  int? selectedRollNo;

  bool isPresentSelected = true;

  String? classId;

  ClassAttendanceViewModel(this.context) {
    //initializeAttendanceList();
  }

  // String get studentName => getStudentsList[];
  TestStudent get getStudent =>
      getStudents.firstWhere((student) => student.rollNo == selectedRollNo);

  String get className {
    final classHome =
        Provider.of<ClassAttendanceHomeViewModel>(context, listen: false);
    return classHome.selectedClass.trim().replaceAll(' ', '-');
  }

  Future<int> getStudentsLen(String className) async {
    getStudents.clear();
    final students = await ClassStudentRepo.getAllTestStudentsByClassName(
        int.parse(classId!));
    return students!.length;
  }

  Future<void> syncDatabase() async {
    getStudents.clear();
    final students = await ClassStudentRepo.getAllTestStudentsByClassName(
        int.parse(classId!));
    for (final student in students!) {
      Log.d(student as Object);
      if (student != null) {
        getStudents.add(student);
      }
    }
    notifyListeners();
  }

  Future<void> initializeAttendanceList(String id) async {
    try {
      final classHome =
          Provider.of<ClassAttendanceHomeViewModel>(context, listen: false);

      classAttId = null;

      // Clear existing data first
      await deleteDatabase();

      await StudentRepository().fetchAllClasses();

      // Fetch new data
      final data = await clstrepo.fetchTestClassStudentData(
          id, DateFormat('yyyy-MM-dd').format(classHome.date));
      Log.d(data);

      classAttId = data['class_att_id'];
      Log.d(classAttId.toString());
      // final className = data['class_name'];

      await ClassStudentRepo.storeClass({
        'class_id': int.parse(classId!),
        'class_name': className,
        'class_att_id': int.parse(classAttId.toString())
      });

      // Explicit null check with early return
      if (data['students'] == null) {
        throw Exception('No data found for this class');
      }

      // Reset all state variables before processing new data
      attendanceList.clear();
      getStudentsList.clear();
      getStudents.clear();
      getGender.clear();
      isPresentSelected = true;
      isLoading = true;
      notifyListeners();

      // Store the data only if we have valid data
      await ClassStudentRepo.storeTestClassStudentData(data);
      await HomeRepo().loginSyncLrDiv();

      Log.d('ClassName: $className');
      bool? attDone = await ClassStudentRepo.getClassIsAttDone(className);
      Log.d('isAttDone: $attDone');

      final students =
          await ClassStudentRepo.getAllTestStudentsByClassName(int.parse(id));

      if (students == null || students.isEmpty) {
        throw Exception('No students found in the database');
      }

      for (final student in students) {
        if (student != null) {
          getGender[student.rollNo] = student.gender;
          getStudents.add(student);
          getStudentsList[student.rollNo] = student.name;
          attendanceList[student.rollNo] =
              !attDone! || student.attendanceStatus == 1;
        }
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception('No Data Found for this Class: ${e.toString()}');
    }
  }

  // Future<void> initializeAttendanceList(String id) async{
  //   final classHome = Provider.of<ClassAttendanceHomeViewModel>(context, listen: false);
  //   // Assume roll numbers 0 to 99 (for example) are the students
  //   await deleteDatabase();
  //   final data = await clstrepo.fetchTestClassStudentData(
  //       id, DateFormat('yyyy-MM-dd').format(classHome.date));
  //
  //   if(data['students'] == null){
  //     throw Exception('No data found');
  //   }
  //
  //   await ClassStudentRepo.storeTestClassStudentData(data);
  //
  //   await HomeRepo().loginSyncLrDiv();
  //
  //   Log.d(data);
  //   attendanceList.clear();
  //   getStudentsList.clear();
  //   getStudents.clear();
  //   getGender.clear();
  //   isPresentSelected = true;
  //   isLoading = true;
  //   notifyListeners();
  //
  //   bool attDone = await ClassStudentRepo.getClassIsAttDone(className);
  //
  //   Log.d('isAttDone: $attDone');
  //
  //   final students = await ClassStudentRepo.getAllTestStudentsByClassName(className);
  //
  //
  //
  //   for(final student in students!){
  //     Log.d(student as Object);
  //     if(student != null){
  //       getGender[student.rollNo] = student.gender;
  //       getStudents.add(student);
  //       getStudentsList[student.rollNo] = student.name;
  //       if(!attDone){
  //         attendanceList[student.rollNo] = true;
  //       }
  //       else{
  //         attendanceList[student.rollNo] = student.attendanceStatus == 1;
  //       }
  //
  //     }
  //
  //     Log.d(attendanceList);
  //     Log.d(getStudentsList);
  //   }
  //   // for (int rollNo = 0; rollNo < 50; rollNo++) {
  //   //   attendanceList[rollNo] = true; // Default: All present
  //   // }
  //   isLoading = false;
  //   notifyListeners();
  // }

  List<int> get presentRollNumbers =>
      attendanceList.entries.where((e) => e.value).map((e) => e.key).toList();

  List<int> get absentRollNumbers =>
      attendanceList.entries.where((e) => !e.value).map((e) => e.key).toList();

  void toggleOption(bool showPresent) {
    isPresentSelected = showPresent;
    notifyListeners();
  }

  void toggleAttendance(int rollNo) {
    attendanceList[rollNo] =
        !(attendanceList[rollNo] ?? true); // Toggle attendance
    notifyListeners();
  }

  // AttendanceData getAttendanceData() {
  //   final classHome = Provider.of<ClassAttendanceHomeViewModel>(context, listen: false);
  //   final cls;
  //   if(classHome.selectedStandard == '1'){
  //      cls = '${classHome.selectedStandard}st ${classHome.selectedDivision}';
  //   }
  //   else if(classHome.selectedStandard == '2'){
  //      cls = '${classHome.selectedStandard}nd ${classHome.selectedDivision}';
  //   }else if(classHome.selectedStandard == '3'){
  //     cls = '${classHome.selectedStandard}rd ${classHome.selectedDivision}';
  //   }
  //   else{
  //     cls = '${classHome.selectedStandard}th ${classHome.selectedDivision}';
  //   }
  //   return AttendanceData(
  //     currentDate: DateFormat('dd MMM yyyy').format(DateTime.now()),
  //     currentClass: cls,
  //   );
  // }

  AttendanceData getAttendanceData() {
    final classHome =
        Provider.of<ClassAttendanceHomeViewModel>(context, listen: false);
    String cls;
    final cl = classHome.selectedClass.split(' ');
    Log.d(cl);

    if (cl.isEmpty) {
      cls =
          classHome.selectedClass; // Use the original string if no split occurs
    } else if (cl.length == 1) {
      // Add ordinal suffix for single-digit numbers
      String classSuffix;
      switch (cl[0]) {
        case '1':
          classSuffix = 'st';
          break;
        case '2':
          classSuffix = 'nd';
          break;
        case '3':
          classSuffix = 'rd';
          break;
        default:
          classSuffix = 'th';
      }
      cls =
          '${cl[0]}$classSuffix'; // Only the number with suffix if no additional text
    } else {
      // Ordinal suffix logic for multi-word class names
      String classSuffix;
      switch (cl[0]) {
        case '1':
          classSuffix = 'st';
          break;
        case '2':
          classSuffix = 'nd';
          break;
        case '3':
          classSuffix = 'rd';
          break;
        default:
          classSuffix = 'th';
      }

      cls = '${cl[0]}$classSuffix ${cl[1]}';
    }
    return AttendanceData(
      currentDate: DateFormat('dd MMM yyyy').format(DateTime.now()),
      currentClass: cls,
    );
  }
}

class AttendanceData {
  final String currentDate;
  final String currentClass;

  AttendanceData({required this.currentDate, required this.currentClass});
}
