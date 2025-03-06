class Class {
  final int id;
  final int stdId;
  final String division;
  final String className;

  Class({
    required this.id,
    required this.stdId,
    required this.division,
    required this.className,
  });

  factory Class.fromMap(Map<String, dynamic> map) {
    return Class(
      id: map['id'] ?? 0,
      stdId: map['std_id'] ?? 0,
      division: map['division'] ?? '',
      className: map['class_name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'std_id': stdId,
      'division': division,
      'class_name': className,
    };
  }
}
