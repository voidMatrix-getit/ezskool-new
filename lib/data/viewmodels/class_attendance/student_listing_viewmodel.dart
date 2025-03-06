import 'package:ezskool/core/services/logger.dart';
import 'package:flutter/material.dart';

class StudentModel {
  final int id;
  final int gender;
  final int rollNo;
  final String name;

  StudentModel({
    required this.id,
    required this.gender,
    required this.rollNo,
    required this.name,
  });

  // Factory method to create StudentModel from JSON
  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      gender: json['gender'],
      rollNo: json['roll_no'],
      name: json['name'],
    );
  }
}



class StudentViewModel extends ChangeNotifier {
  List<StudentModel> _students = [];
  List<Map<String, dynamic>> cardData = [];

  String className = '';

  List<StudentModel> get students => _students;


  String getClassNameById(int id) {
    try {

      Log.d(cardData);
      // Using firstWhere to find the map with the matching id
      var result = cardData.firstWhere((map) => map['id'] == id, orElse: () => {});

      // Return the className if found, otherwise return a default message
      return result != null ? result['className'] : 'Class not found';
    } catch (e) {
      return 'Error: $e';
    }
  }

  String formatClass(String className){

    if (className.isEmpty) return '';

    final List<String> cl = className.trim().split(' ');
    if (cl.isEmpty) return '';

    String numberPart = cl[0];
    String suffix;

    // Handle the numeric portion
    switch (numberPart) {
      case '1':
        suffix = 'st';
        break;
      case '2':
        suffix = 'nd';
        break;
      case '3':
        suffix = 'rd';
        break;
      default:
        suffix = 'th';
    }

    // Combine with section if present
    if (cl.length > 1) {
      return '$numberPart$suffix ${cl[1]}';
    }

    return '$numberPart$suffix';

    // final String cls;
    // final cl = className.split(' ');
    // Log.d(cl);
    // if(cl.length == 1){
    //   if(cl[0] == '1'){
    //     cls = '${cl[0]}st';
    //   }
    //   else if(cl[0] == '2'){
    //     cls = '${cl[0]}nd';
    //   }else if(cl[0] == '3'){
    //     cls = '${cl[0]}rd';
    //   }else{
    //     cls = '${cl[0]}th';
    //   }
    //
    // }
    // else if(cl[0] == '1'){
    //   cls = '${cl[0]}st ${cl[1]}';
    // }
    // else if(cl[0] == '2'){
    //   cls = '${cl[0]}nd ${cl[1]}';
    // }else if(cl[0] == '3'){
    //   cls = '${cl[0]}rd ${cl[1]}';
    // }
    // else{
    //   cls = '${cl[0]}th ${cl[1]}';
    // }
    //
    // return cls;
  }


  void setClassName(String clsName){
    className = clsName;
    notifyListeners();
  }

  // Function to load students from JSON
  void loadStudents(List<dynamic> jsonData) {
    _students = jsonData.map((e) => StudentModel.fromJson(e)).toList();
    notifyListeners(); // Notify UI to rebuild
  }


  // Add methods for sorting
  void sortByRollNo({bool ascending = true}) {
    _students.sort((a, b) => ascending
        ? a.rollNo.compareTo(b.rollNo)
        : b.rollNo.compareTo(a.rollNo));
    notifyListeners();
  }

  void sortByName({bool ascending = true}) {
    _students.sort((a, b) => ascending
        ? a.name.compareTo(b.name)
        : b.name.compareTo(a.name));
    notifyListeners();
  }

  // Add method for searching
  List<StudentModel> searchStudents(String query) {
    if (query.isEmpty) return _students;

    final lowercaseQuery = query.toLowerCase();
    return _students.where((student) {
      return student.name.toLowerCase().contains(lowercaseQuery) ||
          student.rollNo.toString().contains(lowercaseQuery);
    }).toList();
  }
}
