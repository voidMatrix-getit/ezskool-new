import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:ezskool/core/services/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

import 'tables.dart'; // Import the table definitions

part 'app_database.g.dart';

@DriftDatabase(tables: [
  DropdownOptions,
  TestClasses,
  TestStudents,
  Students,
  Standards,
  Classes,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());

  static final AppDatabase instance = AppDatabase._();

  @override
  int get schemaVersion => 1; // Bump this when changing the schema

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll(); // Creates all defined tables
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Add table-specific migration logic if needed
          if (from < 2) {
            await m.createTable(dropdownOptions);
          }
        },
      );
}

// static QueryExecutor _openConnection() {
//   return driftDatabase(
//     name: 'my_database',
//     native: const DriftNativeOptions(
//       // By default, `driftDatabase` from `package:drift_flutter` stores the
//       // database files in `getApplicationDocumentsDirectory()`.
//       databaseDirectory: getApplicationSupportDirectory,
//     ),
//   );

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase(file, logStatements: true, setup: (db) {
      // Explicitly set write permissions if needed
      db.execute('PRAGMA journal_mode=WAL;');
    });
  });
}

Future<void> deleteDatabase() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File('${dbFolder.path}/app_database.sqlite');
  if (await file.exists()) {
    await file.delete();
    Log.d('Database deleted.');
  }
}
