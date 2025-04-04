// dao/class_dao.dart
import 'package:drift/drift.dart';
import 'package:ezskool/data/datasources/local/db/app_database.dart';
import 'package:ezskool/data/datasources/local/db/tables.dart';

part 'test_class_dao.g.dart';

@DriftAccessor(tables: [TestClasses])
class TestClassDao extends DatabaseAccessor<AppDatabase>
    with _$TestClassDaoMixin {
  TestClassDao(super.db);

  Future<void> insertClass(TestClassesCompanion classCompanion) async {
    await into(testClasses)
        .insert(classCompanion, mode: InsertMode.insertOrReplace);
  }

  /// Get all classes
  Future<List<TestClassesData>> getAllClasses() async {
    final classRows = await select(testClasses).get();
    return classRows.map((row) {
      return TestClassesData(
          classId: row.classId,
          className: row.className,
          isAttendanceDone: row.isAttendanceDone);
    }).toList();
  }

  /// Delete all classes
  Future<void> deleteAllClasses() async {
    await delete(testClasses).go();
  }

  /// Get a specific class by ID
  Future<TestClassesData?> getClassByName(String className) async {
    final query = select(testClasses)
      ..where((tbl) => tbl.className.equals(className));
    final classRow = await query.getSingleOrNull();
    if (classRow != null) {
      return TestClassesData(
          classId: classRow.classId,
          className: classRow.className,
          isAttendanceDone: classRow.isAttendanceDone);
    }
    return null;
  }
}
