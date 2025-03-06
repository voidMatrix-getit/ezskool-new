import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassConfirmAttendanceViewModel extends ChangeNotifier {
  // List of attendance statuses (true for present, false for absent)
  // List of all roll numbers (total of 50 students)
  List<bool> attendanceList = List.generate(50, (index) => index % 2 == 0);

  // Number of present and absent students
  List<int> presentRollNumbers = [];
  List<int> absentRollNumbers = [];

  // Toggle state for Present and Absent
  bool isPresentSelected = true;

  // Data for current class and date
  final String currentDate = DateFormat('dd MMM yyyy').format(DateTime.now());
  final String currentClass = "6th A";

  // Getter for attendance data
  AttendanceData getAttendanceData() {
    return AttendanceData(
      currentDate: currentDate,
      currentClass: currentClass,
    );
  }

  // Get list of present students based on attendanceList
  void generatePresentAbsentLists() {
    presentRollNumbers.clear();
    absentRollNumbers.clear();

    for (int i = 0; i < attendanceList.length; i++) {
      if (attendanceList[i]) {
        presentRollNumbers.add(i); // Add roll number if present
      } else {
        absentRollNumbers.add(i); // Add roll number if absent
      }
    }
    notifyListeners();
  }

  // Toggle between Present and Absent
  void toggleOption(bool isPresent) {
    isPresentSelected = isPresent;
    generatePresentAbsentLists(); // Update the lists when toggled
    notifyListeners(); // Notify listeners
  }

  // Toggle attendance for a specific roll number
  void toggleAttendance(int index) {
    attendanceList[index] = !attendanceList[index];
    generatePresentAbsentLists(); // Regenerate the lists after a change
    notifyListeners(); // Notify listeners of the change
  }
}

class AttendanceData {
  final String currentDate;
  final String currentClass;

  AttendanceData({required this.currentDate, required this.currentClass});
}
