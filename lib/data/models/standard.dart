class Standard {
  final int id;
  final String std;
  final int sectionId;
  final int shiftId;

  Standard({
    required this.id,
    required this.std,
    required this.sectionId,
    required this.shiftId,
  });

  factory Standard.fromMap(Map<String, dynamic> map) {
    return Standard(
      id: map['id'] ?? 0,
      std: map['std'] ?? '',
      sectionId: map['section_id'] ?? 0,
      shiftId: map['shift_id'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'std': std,
      'section_id': sectionId,
      'shift_id': shiftId,
    };
  }
}
