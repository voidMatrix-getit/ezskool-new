import 'package:drift/drift.dart';
import 'package:ezskool/data/datasources/local/db/app_database.dart';
import 'package:ezskool/data/datasources/local/db/tables.dart';

part 'class_dao.g.dart';

@DriftAccessor(tables: [Classes])
class ClassDao extends DatabaseAccessor<AppDatabase> with _$ClassDaoMixin {
  ClassDao(AppDatabase db) : super(db);

  /// Insert or replace a class
  Future<void> insertClass(ClassesCompanion classCompanion) async {
    await into(classes).insert(classCompanion, mode: InsertMode.insertOrReplace);
  }

  /// Get all classes
  Future<List<ClassesData>> getAllClasses() async {
    final classRows = await select(classes).get();
    return classRows.map((row) {
      return ClassesData(
        id: row.id,
        stdId: row.stdId,
        division: row.division,
        className: row.className,
      );
    }).toList();
  }

  /// Delete all classes
  Future<void> deleteAllClasses() async {
    await delete(classes).go();
  }

  /// Get a specific class by ID
  Future<ClassesData?> getClassById(int id) async {
    final query = select(classes)..where((tbl) => tbl.id.equals(id));
    final classRow = await query.getSingleOrNull();
    if (classRow != null) {
      return ClassesData(
        id: classRow.id,
        stdId: classRow.stdId,
        division: classRow.division,
        className: classRow.className,
      );
    }
    return null;
  }

  Future<int?> getClassIdByName(String className) async {
    final query = select(classes)..where((tbl) => tbl.className.equals(className));
    final classRow = await query.getSingleOrNull();

    return classRow?.id; // Return ID if found, otherwise return null
  }

  Future<String?> getClassNameById(int classId) async {
    final query = select(classes)..where((tbl) => tbl.id.equals(classId));
    final classRow = await query.getSingleOrNull();

    return classRow?.className; // Return class name if found, otherwise return null
  }


}
