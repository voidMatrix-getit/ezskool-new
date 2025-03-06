// dao/student_dao.dart
import 'package:drift/drift.dart';
import 'package:ezskool/data/datasources/local/db/app_database.dart';
import 'package:ezskool/data/datasources/local/db/tables.dart';

part 'test_student_dao.g.dart';

@DriftAccessor(tables: [TestStudents])
class TestStudentDao extends DatabaseAccessor<AppDatabase>
    with _$TestStudentDaoMixin {
  TestStudentDao(AppDatabase db) : super(db);

  Future<void> insertStudent(TestStudentsCompanion testStudent) async {
    await into(testStudents)
        .insert(testStudent, mode: InsertMode.insertOrReplace);
  }

  Future<List<TestStudent>> getAllStudents() async {
    final studentRows = await select(testStudents).get();
    return studentRows.map((row) {
      return TestStudent(
        studentId: row.studentId,
        classId: row.classId,
        name: row.name,
        rollNo: row.rollNo,
        gender: row.gender,
        attendanceStatus: row.attendanceStatus,
        leaveReason: row.leaveReason,
      );
    }).toList();
  }

  Future<void> deleteAllStudents() async {
    await delete(testStudents).go();
  }

  Future<List<TestStudent?>?> getAllStudentsByClassId(int classId) async {
    final query = select(testStudents)
      ..where((tbl) => tbl.classId.equals(classId))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.rollNo)]);
    final studentRows = await query.get(); // Returns null if not found
    return studentRows.map((row) {
      return TestStudent(
        studentId: row.studentId,
        classId: row.classId,
        name: row.name,
        rollNo: row.rollNo,
        gender: row.gender,
        attendanceStatus: row.attendanceStatus,
        leaveReason: row.leaveReason,
      );
    }).toList();
    return null; // No matching student found
  }

  /// Get a specific student by ID
  Future<TestStudent?> getStudentById(String id) async {
    final query = select(testStudents)
      ..where((tbl) => tbl.studentId.equals(id as int));
    final studentRow =
        await query.getSingleOrNull(); // Returns null if not found
    if (studentRow != null) {
      return TestStudent(
        studentId: studentRow.studentId,
        classId: studentRow.classId,
        name: studentRow.name,
        rollNo: studentRow.rollNo,
        gender: studentRow.gender,
        attendanceStatus: studentRow.attendanceStatus,
        leaveReason: studentRow.leaveReason,
      );
    }
    return null; // No matching student found
  }
}
