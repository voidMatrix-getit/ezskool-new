import 'package:flutter/material.dart';

class ClassAttendanceHomeViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool initialized = false;

  bool get isLoading => _isLoading;
  bool get isInitialized => initialized;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setInitialized(bool init) {
    initialized = init;
    notifyListeners();
  }

  List<String> divisions = [];
  String _selectedStandard = '';

  set selectedStandard(String value) {
    _selectedStandard = value;
  }

  String _selectedDivision = '';
  String _selectedDate = '';

  String _selectedClass = '';

  set selectedClass(String value) {
    _selectedClass = value;
    notifyListeners();
  }

  String get selectedClass => _selectedClass;

  DateTime date = DateTime.now();

  String get selectedStandard => _selectedStandard;
  String get selectedDivision => _selectedDivision;
  String get selectedDate => _selectedDate;

  void updateClass(String className) {
    _selectedClass = className;
    notifyListeners();
  }

  void updateStandard(String standard) {
    _selectedStandard = standard;
    notifyListeners();
  }

  void setDivisions(List<String> divisions) {
    this.divisions = divisions;
    notifyListeners();
  }

  void updateDivision(String division) {
    _selectedDivision = division;
    notifyListeners();
  }

  void updateDate(String date) {
    _selectedDate = date;
    notifyListeners();
  }

  void resetSelections() {
    _selectedStandard = '';
    _selectedDivision = '';
    notifyListeners();
  }

  set selectedDivision(String value) {
    _selectedDivision = value;
  }
}
