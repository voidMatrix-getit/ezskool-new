import 'package:drift/drift.dart';
import 'package:ezskool/data/datasources/local/db/app_database.dart';
import 'package:ezskool/data/datasources/local/db/tables.dart';

part 'student_dao.g.dart';

@DriftAccessor(tables: [Students])
class StudentDao extends DatabaseAccessor<AppDatabase> with _$StudentDaoMixin {
  StudentDao(super.db);

  Future<void> insertStudent(StudentsCompanion student) async {
    await into(students).insert(student, mode: InsertMode.insertOrReplace);
  }

  Future<List<Student>> getAllStudents() async {
    final studentRows = await select(students).get();
    return studentRows.map((row) {
      return Student(
        id: row.id,
        fullName: row.fullName,
        pgIds: row.pgIds,
        currentClassId: row.currentClassId,
        currentRollNo: row.currentRollNo,
        status: row.status,
        ppsp: row.ppsp,
      );
    }).toList();
  }

  Future<void> deleteAllStudents() async {
    await delete(students).go();
  }

  /// Get a specific student by ID
  Future<Student?> getStudentById(String id) async {
    final query = select(students)..where((tbl) => tbl.id.equals(id));
    final studentRow =
        await query.getSingleOrNull(); // Returns null if not found
    if (studentRow != null) {
      return Student(
        id: studentRow.id,
        fullName: studentRow.fullName,
        pgIds: studentRow.pgIds,
        currentClassId: studentRow.currentClassId,
        currentRollNo: studentRow.currentRollNo,
        status: studentRow.status,
        ppsp: studentRow.ppsp,
      );
    }
    return null; // No matching student found
  }
}
