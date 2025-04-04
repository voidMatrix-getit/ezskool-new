import 'package:drift/drift.dart';
import '../../db/app_database.dart';
import '../../db/tables.dart';

part 'dropdown_options_dao.g.dart';

@DriftAccessor(tables: [DropdownOptions])
class DropdownDao extends DatabaseAccessor<AppDatabase>
    with _$DropdownDaoMixin {
  DropdownDao(super.db);

  // Insert options into the database
  Future<void> insertDropdownOptions(List<Map<String, String>> options) async {
    await batch((batch) {
      batch.deleteWhere(dropdownOptions,
          (tbl) => const Constant(true)); // Clear existing data
      batch.insertAll(
        dropdownOptions,
        options.map((entry) {
          return DropdownOptionsCompanion(
            key: Value(entry['key']!),
            value: Value(entry['value']!),
          );
        }).toList(),
      );
    });
  }

  // Retrieve dropdown values for a specific key (e.g., "lr" or "div")
  Future<List<String>> getDropdownValues(String key) async {
    // final query = select(dropdownOptions)..where((tbl) => tbl.key.equals(key));
    // final results = await query.get();
    // return results.map((row) => row.value).toList();
    final query = select(dropdownOptions)
      ..where((tbl) => tbl.key.equals(key))
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.rowId)]);
    final results = await query.map((row) => row.value).get();
    return results;
  }
}
