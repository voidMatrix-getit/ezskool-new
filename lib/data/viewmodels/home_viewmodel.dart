import 'package:flutter/material.dart';

enum ViewState { calendar, qrScanner, manualAttendance }

class HomeViewModel extends ChangeNotifier {
  // State variables
  DateTime selectedDate = DateTime.now();
  ViewState currentView = ViewState.calendar;
  String? selectedStandard;
  String? selectedDivision;
  bool isDropdownOpen = false;
  TextEditingController rollnoController = TextEditingController();

  List<String> standards = List.generate(10, (index) => '${index + 1}');
  List<String> divisions = ['A', 'B', 'C', 'D'];

  // Methods to update state
  void changeMonth(int direction) {
    selectedDate = DateTime(selectedDate.year, selectedDate.month + direction);
    notifyListeners();
  }

  void changeView(ViewState view) {
    currentView = view;
    notifyListeners();
  }

  void selectDropdown(String field, String value) {
    if (field == 'Select Standard') {
      selectedStandard = value;
    } else if (field == 'Select Division') {
      selectedDivision = value;
    }
    notifyListeners();
  }

  Future<void> onOkButtonPressed(BuildContext context) async {
    // Perform action on "OK" button press
    // Example: Fetch student data and display a dialog
    // Replace this logic with your actual implementation
    String rollno = rollnoController.text;
    if (rollno.isNotEmpty) {
      // Simulate fetching student data
      await Future.delayed(Duration(seconds: 1));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student data fetched for roll no: $rollno')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Roll number is empty')),
      );
    }
  }
}
