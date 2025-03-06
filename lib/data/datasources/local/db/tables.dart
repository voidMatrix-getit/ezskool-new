import 'package:drift/drift.dart';

class Students extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text().named('full_name')();
  TextColumn get pgIds => text().named('pg_ids')();
  TextColumn get currentClassId => text().named('current_class_id')();
  TextColumn get currentRollNo => text().named('current_roll_no')();
  TextColumn get status => text()();
  TextColumn get ppsp => text()();

  @override
  Set<Column> get primaryKey => {id}; // Set 'id' as the primary key
}

class Classes extends Table {
  IntColumn get id => integer()();
  IntColumn get stdId => integer()();
  TextColumn get division => text()();
  TextColumn get className => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Standards extends Table {
  IntColumn get id => integer()();
  TextColumn get std => text()();
  IntColumn get sectionId => integer()();
  IntColumn get shiftId => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class TestClasses extends Table {
  IntColumn get classId => integer()();
  TextColumn get className => text().withLength(min: 1, max: 50)();
  BoolColumn get isAttendanceDone => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {classId};

}

class TestStudents extends Table {
  IntColumn get studentId => integer()();
  IntColumn get classId =>
      integer().customConstraint('REFERENCES TestClasses(classId) NOT NULL')();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get rollNo => integer()();
  IntColumn get gender => integer()();
  IntColumn get attendanceStatus => integer().nullable()(); // 1: Present, 2: Absent, 3: Leave
  TextColumn get leaveReason => text().nullable()();

  @override
  Set<Column> get primaryKey => {studentId};
}


class DropdownOptions extends Table {
  TextColumn get key => text()(); // "lr" or "div"
  TextColumn get value => text()(); // Individual values (e.g., "Sick", "Family Occasion", etc.)

  @override
  Set<Column> get primaryKey => {key, value}; // Unique combination
}


