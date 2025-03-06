import 'package:drift/drift.dart';
import 'package:ezskool/data/datasources/local/db/app_database.dart';
import 'package:ezskool/data/datasources/local/db/tables.dart';

part 'standard_dao.g.dart';

@DriftAccessor(tables: [Standards])
class StandardDao extends DatabaseAccessor<AppDatabase> with _$StandardDaoMixin {
  StandardDao(AppDatabase db) : super(db);

  /// Insert or replace a standard
  Future<void> insertStandard(StandardsCompanion standardCompanion) async {
    await into(standards).insert(standardCompanion, mode: InsertMode.insertOrReplace);
  }

  /// Get all standards
  Future<List<Standard>> getAllStandards() async {
    final standardRows = await select(standards).get();
    return standardRows.map((row) {
      return Standard(
        id: row.id,
        std: row.std,
        sectionId: row.sectionId,
        shiftId: row.shiftId,
      );
    }).toList();
  }

  /// Delete all standards
  Future<void> deleteAllStandards() async {
    await delete(standards).go();
  }

  /// Get a specific standard by ID
  Future<Standard?> getStandardById(int id) async {
    final query = select(standards)..where((tbl) => tbl.id.equals(id));
    final standardRow = await query.getSingleOrNull();
    if (standardRow != null) {
      return Standard(
        id: standardRow.id,
        std: standardRow.std,
        sectionId: standardRow.sectionId,
        shiftId: standardRow.shiftId,
      );
    }
    return null;
  }
}
