// models/class_model.dart
class TestClassModel {
  final int? classId;
  final String className;
  final bool isAttendanceDone;

  TestClassModel({
    this.classId,
    required this.className,
    required this.isAttendanceDone,
  });

  // From JSON
  factory TestClassModel.fromJson(Map<String, dynamic> json) {
    return TestClassModel(
      classId: json['class_id'],
      className: json['class_name'],
      isAttendanceDone: json['is_att_done'] == 1,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
      'class_name': className,
      'is_att_done': isAttendanceDone ? 1 : 0,
    };
  }
}