class Student {
  final String id;
  final String fullName;
  final String pgIds;
  final String currentClassId;
  final String currentRollNo;
  final String status;
  final String ppsp;

  Student({
    required this.id,
    required this.fullName,
    required this.pgIds,
    required this.currentClassId,
    required this.currentRollNo,
    required this.status,
    required this.ppsp,
  });

  factory Student.fromMap(Map<String, String> map) {
    return Student(
      id: map['id'] ?? '',
      fullName: map['full_name'] ?? '',
      pgIds: map['pg_ids'] ?? '',
      currentClassId: map['current_class_id'] ?? '',
      currentRollNo: map['current_roll_no'] ?? '',
      status: map['status'] ?? '',
      ppsp: map['ppsp'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'pg_ids': pgIds,
      'current_class_id': currentClassId,
      'current_roll_no': currentRollNo,
      'status': status,
      'ppsp': ppsp,
    };
  }
}
