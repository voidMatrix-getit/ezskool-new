// models/student_model.dart
class TestStudentModel {
  final int studentId;
  final int classId;
  final String name;
  final int rollNo;
  final int gender;
  final int? attendanceStatus;
  final String? leaveReason;

  TestStudentModel({
    required this.studentId,
    required this.classId,
    required this.name,
    required this.rollNo,
    required this.gender,
    this.attendanceStatus,
    this.leaveReason,
  });

  // From JSON
  factory TestStudentModel.fromJson(Map<String, dynamic> json) {
    return TestStudentModel(
      studentId: json['student_id'],
      classId: json['class_id'],
      name: json['name'],
      rollNo: json['roll_no'],
      gender: json['gender'],
      attendanceStatus: json['att_status'],
      leaveReason: json['leave_reason'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'class_id': classId,
      'name': name,
      'roll_no': rollNo,
      'gender' : gender,
      'att_status': attendanceStatus,
      'leave_reason': leaveReason,
    };
  }
}
