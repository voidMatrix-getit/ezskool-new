// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DropdownOptionsTable extends DropdownOptions
    with TableInfo<$DropdownOptionsTable, DropdownOption> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DropdownOptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dropdown_options';
  @override
  VerificationContext validateIntegrity(Insertable<DropdownOption> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key, value};
  @override
  DropdownOption map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DropdownOption(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $DropdownOptionsTable createAlias(String alias) {
    return $DropdownOptionsTable(attachedDatabase, alias);
  }
}

class DropdownOption extends DataClass implements Insertable<DropdownOption> {
  final String key;
  final String value;
  const DropdownOption({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  DropdownOptionsCompanion toCompanion(bool nullToAbsent) {
    return DropdownOptionsCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory DropdownOption.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DropdownOption(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  DropdownOption copyWith({String? key, String? value}) => DropdownOption(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  DropdownOption copyWithCompanion(DropdownOptionsCompanion data) {
    return DropdownOption(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DropdownOption(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DropdownOption &&
          other.key == this.key &&
          other.value == this.value);
}

class DropdownOptionsCompanion extends UpdateCompanion<DropdownOption> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const DropdownOptionsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DropdownOptionsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<DropdownOption> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DropdownOptionsCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return DropdownOptionsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DropdownOptionsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TestClassesTable extends TestClasses
    with TableInfo<$TestClassesTable, TestClassesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TestClassesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _classIdMeta =
      const VerificationMeta('classId');
  @override
  late final GeneratedColumn<int> classId = GeneratedColumn<int>(
      'class_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _classNameMeta =
      const VerificationMeta('className');
  @override
  late final GeneratedColumn<String> className = GeneratedColumn<String>(
      'class_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _isAttendanceDoneMeta =
      const VerificationMeta('isAttendanceDone');
  @override
  late final GeneratedColumn<bool> isAttendanceDone = GeneratedColumn<bool>(
      'is_attendance_done', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_attendance_done" IN (0, 1))'),
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns => [classId, className, isAttendanceDone];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'test_classes';
  @override
  VerificationContext validateIntegrity(Insertable<TestClassesData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('class_id')) {
      context.handle(_classIdMeta,
          classId.isAcceptableOrUnknown(data['class_id']!, _classIdMeta));
    }
    if (data.containsKey('class_name')) {
      context.handle(_classNameMeta,
          className.isAcceptableOrUnknown(data['class_name']!, _classNameMeta));
    } else if (isInserting) {
      context.missing(_classNameMeta);
    }
    if (data.containsKey('is_attendance_done')) {
      context.handle(
          _isAttendanceDoneMeta,
          isAttendanceDone.isAcceptableOrUnknown(
              data['is_attendance_done']!, _isAttendanceDoneMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {classId};
  @override
  TestClassesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TestClassesData(
      classId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}class_id'])!,
      className: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}class_name'])!,
      isAttendanceDone: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_attendance_done'])!,
    );
  }

  @override
  $TestClassesTable createAlias(String alias) {
    return $TestClassesTable(attachedDatabase, alias);
  }
}

class TestClassesData extends DataClass implements Insertable<TestClassesData> {
  final int classId;
  final String className;
  final bool isAttendanceDone;
  const TestClassesData(
      {required this.classId,
      required this.className,
      required this.isAttendanceDone});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['class_id'] = Variable<int>(classId);
    map['class_name'] = Variable<String>(className);
    map['is_attendance_done'] = Variable<bool>(isAttendanceDone);
    return map;
  }

  TestClassesCompanion toCompanion(bool nullToAbsent) {
    return TestClassesCompanion(
      classId: Value(classId),
      className: Value(className),
      isAttendanceDone: Value(isAttendanceDone),
    );
  }

  factory TestClassesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TestClassesData(
      classId: serializer.fromJson<int>(json['classId']),
      className: serializer.fromJson<String>(json['className']),
      isAttendanceDone: serializer.fromJson<bool>(json['isAttendanceDone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'classId': serializer.toJson<int>(classId),
      'className': serializer.toJson<String>(className),
      'isAttendanceDone': serializer.toJson<bool>(isAttendanceDone),
    };
  }

  TestClassesData copyWith(
          {int? classId, String? className, bool? isAttendanceDone}) =>
      TestClassesData(
        classId: classId ?? this.classId,
        className: className ?? this.className,
        isAttendanceDone: isAttendanceDone ?? this.isAttendanceDone,
      );
  TestClassesData copyWithCompanion(TestClassesCompanion data) {
    return TestClassesData(
      classId: data.classId.present ? data.classId.value : this.classId,
      className: data.className.present ? data.className.value : this.className,
      isAttendanceDone: data.isAttendanceDone.present
          ? data.isAttendanceDone.value
          : this.isAttendanceDone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TestClassesData(')
          ..write('classId: $classId, ')
          ..write('className: $className, ')
          ..write('isAttendanceDone: $isAttendanceDone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(classId, className, isAttendanceDone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TestClassesData &&
          other.classId == this.classId &&
          other.className == this.className &&
          other.isAttendanceDone == this.isAttendanceDone);
}

class TestClassesCompanion extends UpdateCompanion<TestClassesData> {
  final Value<int> classId;
  final Value<String> className;
  final Value<bool> isAttendanceDone;
  const TestClassesCompanion({
    this.classId = const Value.absent(),
    this.className = const Value.absent(),
    this.isAttendanceDone = const Value.absent(),
  });
  TestClassesCompanion.insert({
    this.classId = const Value.absent(),
    required String className,
    this.isAttendanceDone = const Value.absent(),
  }) : className = Value(className);
  static Insertable<TestClassesData> custom({
    Expression<int>? classId,
    Expression<String>? className,
    Expression<bool>? isAttendanceDone,
  }) {
    return RawValuesInsertable({
      if (classId != null) 'class_id': classId,
      if (className != null) 'class_name': className,
      if (isAttendanceDone != null) 'is_attendance_done': isAttendanceDone,
    });
  }

  TestClassesCompanion copyWith(
      {Value<int>? classId,
      Value<String>? className,
      Value<bool>? isAttendanceDone}) {
    return TestClassesCompanion(
      classId: classId ?? this.classId,
      className: className ?? this.className,
      isAttendanceDone: isAttendanceDone ?? this.isAttendanceDone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (classId.present) {
      map['class_id'] = Variable<int>(classId.value);
    }
    if (className.present) {
      map['class_name'] = Variable<String>(className.value);
    }
    if (isAttendanceDone.present) {
      map['is_attendance_done'] = Variable<bool>(isAttendanceDone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TestClassesCompanion(')
          ..write('classId: $classId, ')
          ..write('className: $className, ')
          ..write('isAttendanceDone: $isAttendanceDone')
          ..write(')'))
        .toString();
  }
}

class $TestStudentsTable extends TestStudents
    with TableInfo<$TestStudentsTable, TestStudent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TestStudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<int> studentId = GeneratedColumn<int>(
      'student_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _classIdMeta =
      const VerificationMeta('classId');
  @override
  late final GeneratedColumn<int> classId = GeneratedColumn<int>(
      'class_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES TestClasses(classId) NOT NULL');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _rollNoMeta = const VerificationMeta('rollNo');
  @override
  late final GeneratedColumn<int> rollNo = GeneratedColumn<int>(
      'roll_no', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<int> gender = GeneratedColumn<int>(
      'gender', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _attendanceStatusMeta =
      const VerificationMeta('attendanceStatus');
  @override
  late final GeneratedColumn<int> attendanceStatus = GeneratedColumn<int>(
      'attendance_status', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _leaveReasonMeta =
      const VerificationMeta('leaveReason');
  @override
  late final GeneratedColumn<String> leaveReason = GeneratedColumn<String>(
      'leave_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [studentId, classId, name, rollNo, gender, attendanceStatus, leaveReason];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'test_students';
  @override
  VerificationContext validateIntegrity(Insertable<TestStudent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    }
    if (data.containsKey('class_id')) {
      context.handle(_classIdMeta,
          classId.isAcceptableOrUnknown(data['class_id']!, _classIdMeta));
    } else if (isInserting) {
      context.missing(_classIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('roll_no')) {
      context.handle(_rollNoMeta,
          rollNo.isAcceptableOrUnknown(data['roll_no']!, _rollNoMeta));
    } else if (isInserting) {
      context.missing(_rollNoMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('attendance_status')) {
      context.handle(
          _attendanceStatusMeta,
          attendanceStatus.isAcceptableOrUnknown(
              data['attendance_status']!, _attendanceStatusMeta));
    }
    if (data.containsKey('leave_reason')) {
      context.handle(
          _leaveReasonMeta,
          leaveReason.isAcceptableOrUnknown(
              data['leave_reason']!, _leaveReasonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {studentId};
  @override
  TestStudent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TestStudent(
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}student_id'])!,
      classId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}class_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      rollNo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}roll_no'])!,
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gender'])!,
      attendanceStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attendance_status']),
      leaveReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}leave_reason']),
    );
  }

  @override
  $TestStudentsTable createAlias(String alias) {
    return $TestStudentsTable(attachedDatabase, alias);
  }
}

class TestStudent extends DataClass implements Insertable<TestStudent> {
  final int studentId;
  final int classId;
  final String name;
  final int rollNo;
  final int gender;
  final int? attendanceStatus;
  final String? leaveReason;
  const TestStudent(
      {required this.studentId,
      required this.classId,
      required this.name,
      required this.rollNo,
      required this.gender,
      this.attendanceStatus,
      this.leaveReason});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['student_id'] = Variable<int>(studentId);
    map['class_id'] = Variable<int>(classId);
    map['name'] = Variable<String>(name);
    map['roll_no'] = Variable<int>(rollNo);
    map['gender'] = Variable<int>(gender);
    if (!nullToAbsent || attendanceStatus != null) {
      map['attendance_status'] = Variable<int>(attendanceStatus);
    }
    if (!nullToAbsent || leaveReason != null) {
      map['leave_reason'] = Variable<String>(leaveReason);
    }
    return map;
  }

  TestStudentsCompanion toCompanion(bool nullToAbsent) {
    return TestStudentsCompanion(
      studentId: Value(studentId),
      classId: Value(classId),
      name: Value(name),
      rollNo: Value(rollNo),
      gender: Value(gender),
      attendanceStatus: attendanceStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(attendanceStatus),
      leaveReason: leaveReason == null && nullToAbsent
          ? const Value.absent()
          : Value(leaveReason),
    );
  }

  factory TestStudent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TestStudent(
      studentId: serializer.fromJson<int>(json['studentId']),
      classId: serializer.fromJson<int>(json['classId']),
      name: serializer.fromJson<String>(json['name']),
      rollNo: serializer.fromJson<int>(json['rollNo']),
      gender: serializer.fromJson<int>(json['gender']),
      attendanceStatus: serializer.fromJson<int?>(json['attendanceStatus']),
      leaveReason: serializer.fromJson<String?>(json['leaveReason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'studentId': serializer.toJson<int>(studentId),
      'classId': serializer.toJson<int>(classId),
      'name': serializer.toJson<String>(name),
      'rollNo': serializer.toJson<int>(rollNo),
      'gender': serializer.toJson<int>(gender),
      'attendanceStatus': serializer.toJson<int?>(attendanceStatus),
      'leaveReason': serializer.toJson<String?>(leaveReason),
    };
  }

  TestStudent copyWith(
          {int? studentId,
          int? classId,
          String? name,
          int? rollNo,
          int? gender,
          Value<int?> attendanceStatus = const Value.absent(),
          Value<String?> leaveReason = const Value.absent()}) =>
      TestStudent(
        studentId: studentId ?? this.studentId,
        classId: classId ?? this.classId,
        name: name ?? this.name,
        rollNo: rollNo ?? this.rollNo,
        gender: gender ?? this.gender,
        attendanceStatus: attendanceStatus.present
            ? attendanceStatus.value
            : this.attendanceStatus,
        leaveReason: leaveReason.present ? leaveReason.value : this.leaveReason,
      );
  TestStudent copyWithCompanion(TestStudentsCompanion data) {
    return TestStudent(
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      classId: data.classId.present ? data.classId.value : this.classId,
      name: data.name.present ? data.name.value : this.name,
      rollNo: data.rollNo.present ? data.rollNo.value : this.rollNo,
      gender: data.gender.present ? data.gender.value : this.gender,
      attendanceStatus: data.attendanceStatus.present
          ? data.attendanceStatus.value
          : this.attendanceStatus,
      leaveReason:
          data.leaveReason.present ? data.leaveReason.value : this.leaveReason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TestStudent(')
          ..write('studentId: $studentId, ')
          ..write('classId: $classId, ')
          ..write('name: $name, ')
          ..write('rollNo: $rollNo, ')
          ..write('gender: $gender, ')
          ..write('attendanceStatus: $attendanceStatus, ')
          ..write('leaveReason: $leaveReason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      studentId, classId, name, rollNo, gender, attendanceStatus, leaveReason);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TestStudent &&
          other.studentId == this.studentId &&
          other.classId == this.classId &&
          other.name == this.name &&
          other.rollNo == this.rollNo &&
          other.gender == this.gender &&
          other.attendanceStatus == this.attendanceStatus &&
          other.leaveReason == this.leaveReason);
}

class TestStudentsCompanion extends UpdateCompanion<TestStudent> {
  final Value<int> studentId;
  final Value<int> classId;
  final Value<String> name;
  final Value<int> rollNo;
  final Value<int> gender;
  final Value<int?> attendanceStatus;
  final Value<String?> leaveReason;
  const TestStudentsCompanion({
    this.studentId = const Value.absent(),
    this.classId = const Value.absent(),
    this.name = const Value.absent(),
    this.rollNo = const Value.absent(),
    this.gender = const Value.absent(),
    this.attendanceStatus = const Value.absent(),
    this.leaveReason = const Value.absent(),
  });
  TestStudentsCompanion.insert({
    this.studentId = const Value.absent(),
    required int classId,
    required String name,
    required int rollNo,
    required int gender,
    this.attendanceStatus = const Value.absent(),
    this.leaveReason = const Value.absent(),
  })  : classId = Value(classId),
        name = Value(name),
        rollNo = Value(rollNo),
        gender = Value(gender);
  static Insertable<TestStudent> custom({
    Expression<int>? studentId,
    Expression<int>? classId,
    Expression<String>? name,
    Expression<int>? rollNo,
    Expression<int>? gender,
    Expression<int>? attendanceStatus,
    Expression<String>? leaveReason,
  }) {
    return RawValuesInsertable({
      if (studentId != null) 'student_id': studentId,
      if (classId != null) 'class_id': classId,
      if (name != null) 'name': name,
      if (rollNo != null) 'roll_no': rollNo,
      if (gender != null) 'gender': gender,
      if (attendanceStatus != null) 'attendance_status': attendanceStatus,
      if (leaveReason != null) 'leave_reason': leaveReason,
    });
  }

  TestStudentsCompanion copyWith(
      {Value<int>? studentId,
      Value<int>? classId,
      Value<String>? name,
      Value<int>? rollNo,
      Value<int>? gender,
      Value<int?>? attendanceStatus,
      Value<String?>? leaveReason}) {
    return TestStudentsCompanion(
      studentId: studentId ?? this.studentId,
      classId: classId ?? this.classId,
      name: name ?? this.name,
      rollNo: rollNo ?? this.rollNo,
      gender: gender ?? this.gender,
      attendanceStatus: attendanceStatus ?? this.attendanceStatus,
      leaveReason: leaveReason ?? this.leaveReason,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    if (classId.present) {
      map['class_id'] = Variable<int>(classId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rollNo.present) {
      map['roll_no'] = Variable<int>(rollNo.value);
    }
    if (gender.present) {
      map['gender'] = Variable<int>(gender.value);
    }
    if (attendanceStatus.present) {
      map['attendance_status'] = Variable<int>(attendanceStatus.value);
    }
    if (leaveReason.present) {
      map['leave_reason'] = Variable<String>(leaveReason.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TestStudentsCompanion(')
          ..write('studentId: $studentId, ')
          ..write('classId: $classId, ')
          ..write('name: $name, ')
          ..write('rollNo: $rollNo, ')
          ..write('gender: $gender, ')
          ..write('attendanceStatus: $attendanceStatus, ')
          ..write('leaveReason: $leaveReason')
          ..write(')'))
        .toString();
  }
}

class $StudentsTable extends Students with TableInfo<$StudentsTable, Student> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pgIdsMeta = const VerificationMeta('pgIds');
  @override
  late final GeneratedColumn<String> pgIds = GeneratedColumn<String>(
      'pg_ids', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currentClassIdMeta =
      const VerificationMeta('currentClassId');
  @override
  late final GeneratedColumn<String> currentClassId = GeneratedColumn<String>(
      'current_class_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currentRollNoMeta =
      const VerificationMeta('currentRollNo');
  @override
  late final GeneratedColumn<String> currentRollNo = GeneratedColumn<String>(
      'current_roll_no', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ppspMeta = const VerificationMeta('ppsp');
  @override
  late final GeneratedColumn<String> ppsp = GeneratedColumn<String>(
      'ppsp', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, fullName, pgIds, currentClassId, currentRollNo, status, ppsp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students';
  @override
  VerificationContext validateIntegrity(Insertable<Student> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('pg_ids')) {
      context.handle(
          _pgIdsMeta, pgIds.isAcceptableOrUnknown(data['pg_ids']!, _pgIdsMeta));
    } else if (isInserting) {
      context.missing(_pgIdsMeta);
    }
    if (data.containsKey('current_class_id')) {
      context.handle(
          _currentClassIdMeta,
          currentClassId.isAcceptableOrUnknown(
              data['current_class_id']!, _currentClassIdMeta));
    } else if (isInserting) {
      context.missing(_currentClassIdMeta);
    }
    if (data.containsKey('current_roll_no')) {
      context.handle(
          _currentRollNoMeta,
          currentRollNo.isAcceptableOrUnknown(
              data['current_roll_no']!, _currentRollNoMeta));
    } else if (isInserting) {
      context.missing(_currentRollNoMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('ppsp')) {
      context.handle(
          _ppspMeta, ppsp.isAcceptableOrUnknown(data['ppsp']!, _ppspMeta));
    } else if (isInserting) {
      context.missing(_ppspMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Student map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Student(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      pgIds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pg_ids'])!,
      currentClassId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}current_class_id'])!,
      currentRollNo: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}current_roll_no'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      ppsp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ppsp'])!,
    );
  }

  @override
  $StudentsTable createAlias(String alias) {
    return $StudentsTable(attachedDatabase, alias);
  }
}

class Student extends DataClass implements Insertable<Student> {
  final String id;
  final String fullName;
  final String pgIds;
  final String currentClassId;
  final String currentRollNo;
  final String status;
  final String ppsp;
  const Student(
      {required this.id,
      required this.fullName,
      required this.pgIds,
      required this.currentClassId,
      required this.currentRollNo,
      required this.status,
      required this.ppsp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['full_name'] = Variable<String>(fullName);
    map['pg_ids'] = Variable<String>(pgIds);
    map['current_class_id'] = Variable<String>(currentClassId);
    map['current_roll_no'] = Variable<String>(currentRollNo);
    map['status'] = Variable<String>(status);
    map['ppsp'] = Variable<String>(ppsp);
    return map;
  }

  StudentsCompanion toCompanion(bool nullToAbsent) {
    return StudentsCompanion(
      id: Value(id),
      fullName: Value(fullName),
      pgIds: Value(pgIds),
      currentClassId: Value(currentClassId),
      currentRollNo: Value(currentRollNo),
      status: Value(status),
      ppsp: Value(ppsp),
    );
  }

  factory Student.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Student(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      pgIds: serializer.fromJson<String>(json['pgIds']),
      currentClassId: serializer.fromJson<String>(json['currentClassId']),
      currentRollNo: serializer.fromJson<String>(json['currentRollNo']),
      status: serializer.fromJson<String>(json['status']),
      ppsp: serializer.fromJson<String>(json['ppsp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String>(fullName),
      'pgIds': serializer.toJson<String>(pgIds),
      'currentClassId': serializer.toJson<String>(currentClassId),
      'currentRollNo': serializer.toJson<String>(currentRollNo),
      'status': serializer.toJson<String>(status),
      'ppsp': serializer.toJson<String>(ppsp),
    };
  }

  Student copyWith(
          {String? id,
          String? fullName,
          String? pgIds,
          String? currentClassId,
          String? currentRollNo,
          String? status,
          String? ppsp}) =>
      Student(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        pgIds: pgIds ?? this.pgIds,
        currentClassId: currentClassId ?? this.currentClassId,
        currentRollNo: currentRollNo ?? this.currentRollNo,
        status: status ?? this.status,
        ppsp: ppsp ?? this.ppsp,
      );
  Student copyWithCompanion(StudentsCompanion data) {
    return Student(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      pgIds: data.pgIds.present ? data.pgIds.value : this.pgIds,
      currentClassId: data.currentClassId.present
          ? data.currentClassId.value
          : this.currentClassId,
      currentRollNo: data.currentRollNo.present
          ? data.currentRollNo.value
          : this.currentRollNo,
      status: data.status.present ? data.status.value : this.status,
      ppsp: data.ppsp.present ? data.ppsp.value : this.ppsp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Student(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('pgIds: $pgIds, ')
          ..write('currentClassId: $currentClassId, ')
          ..write('currentRollNo: $currentRollNo, ')
          ..write('status: $status, ')
          ..write('ppsp: $ppsp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, fullName, pgIds, currentClassId, currentRollNo, status, ppsp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Student &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.pgIds == this.pgIds &&
          other.currentClassId == this.currentClassId &&
          other.currentRollNo == this.currentRollNo &&
          other.status == this.status &&
          other.ppsp == this.ppsp);
}

class StudentsCompanion extends UpdateCompanion<Student> {
  final Value<String> id;
  final Value<String> fullName;
  final Value<String> pgIds;
  final Value<String> currentClassId;
  final Value<String> currentRollNo;
  final Value<String> status;
  final Value<String> ppsp;
  final Value<int> rowid;
  const StudentsCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.pgIds = const Value.absent(),
    this.currentClassId = const Value.absent(),
    this.currentRollNo = const Value.absent(),
    this.status = const Value.absent(),
    this.ppsp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentsCompanion.insert({
    required String id,
    required String fullName,
    required String pgIds,
    required String currentClassId,
    required String currentRollNo,
    required String status,
    required String ppsp,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        fullName = Value(fullName),
        pgIds = Value(pgIds),
        currentClassId = Value(currentClassId),
        currentRollNo = Value(currentRollNo),
        status = Value(status),
        ppsp = Value(ppsp);
  static Insertable<Student> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? pgIds,
    Expression<String>? currentClassId,
    Expression<String>? currentRollNo,
    Expression<String>? status,
    Expression<String>? ppsp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (pgIds != null) 'pg_ids': pgIds,
      if (currentClassId != null) 'current_class_id': currentClassId,
      if (currentRollNo != null) 'current_roll_no': currentRollNo,
      if (status != null) 'status': status,
      if (ppsp != null) 'ppsp': ppsp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? fullName,
      Value<String>? pgIds,
      Value<String>? currentClassId,
      Value<String>? currentRollNo,
      Value<String>? status,
      Value<String>? ppsp,
      Value<int>? rowid}) {
    return StudentsCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      pgIds: pgIds ?? this.pgIds,
      currentClassId: currentClassId ?? this.currentClassId,
      currentRollNo: currentRollNo ?? this.currentRollNo,
      status: status ?? this.status,
      ppsp: ppsp ?? this.ppsp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (pgIds.present) {
      map['pg_ids'] = Variable<String>(pgIds.value);
    }
    if (currentClassId.present) {
      map['current_class_id'] = Variable<String>(currentClassId.value);
    }
    if (currentRollNo.present) {
      map['current_roll_no'] = Variable<String>(currentRollNo.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (ppsp.present) {
      map['ppsp'] = Variable<String>(ppsp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('pgIds: $pgIds, ')
          ..write('currentClassId: $currentClassId, ')
          ..write('currentRollNo: $currentRollNo, ')
          ..write('status: $status, ')
          ..write('ppsp: $ppsp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StandardsTable extends Standards
    with TableInfo<$StandardsTable, Standard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StandardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _stdMeta = const VerificationMeta('std');
  @override
  late final GeneratedColumn<String> std = GeneratedColumn<String>(
      'std', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sectionIdMeta =
      const VerificationMeta('sectionId');
  @override
  late final GeneratedColumn<int> sectionId = GeneratedColumn<int>(
      'section_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _shiftIdMeta =
      const VerificationMeta('shiftId');
  @override
  late final GeneratedColumn<int> shiftId = GeneratedColumn<int>(
      'shift_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, std, sectionId, shiftId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'standards';
  @override
  VerificationContext validateIntegrity(Insertable<Standard> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('std')) {
      context.handle(
          _stdMeta, std.isAcceptableOrUnknown(data['std']!, _stdMeta));
    } else if (isInserting) {
      context.missing(_stdMeta);
    }
    if (data.containsKey('section_id')) {
      context.handle(_sectionIdMeta,
          sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta));
    } else if (isInserting) {
      context.missing(_sectionIdMeta);
    }
    if (data.containsKey('shift_id')) {
      context.handle(_shiftIdMeta,
          shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta));
    } else if (isInserting) {
      context.missing(_shiftIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Standard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Standard(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      std: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}std'])!,
      sectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}section_id'])!,
      shiftId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}shift_id'])!,
    );
  }

  @override
  $StandardsTable createAlias(String alias) {
    return $StandardsTable(attachedDatabase, alias);
  }
}

class Standard extends DataClass implements Insertable<Standard> {
  final int id;
  final String std;
  final int sectionId;
  final int shiftId;
  const Standard(
      {required this.id,
      required this.std,
      required this.sectionId,
      required this.shiftId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['std'] = Variable<String>(std);
    map['section_id'] = Variable<int>(sectionId);
    map['shift_id'] = Variable<int>(shiftId);
    return map;
  }

  StandardsCompanion toCompanion(bool nullToAbsent) {
    return StandardsCompanion(
      id: Value(id),
      std: Value(std),
      sectionId: Value(sectionId),
      shiftId: Value(shiftId),
    );
  }

  factory Standard.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Standard(
      id: serializer.fromJson<int>(json['id']),
      std: serializer.fromJson<String>(json['std']),
      sectionId: serializer.fromJson<int>(json['sectionId']),
      shiftId: serializer.fromJson<int>(json['shiftId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'std': serializer.toJson<String>(std),
      'sectionId': serializer.toJson<int>(sectionId),
      'shiftId': serializer.toJson<int>(shiftId),
    };
  }

  Standard copyWith({int? id, String? std, int? sectionId, int? shiftId}) =>
      Standard(
        id: id ?? this.id,
        std: std ?? this.std,
        sectionId: sectionId ?? this.sectionId,
        shiftId: shiftId ?? this.shiftId,
      );
  Standard copyWithCompanion(StandardsCompanion data) {
    return Standard(
      id: data.id.present ? data.id.value : this.id,
      std: data.std.present ? data.std.value : this.std,
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Standard(')
          ..write('id: $id, ')
          ..write('std: $std, ')
          ..write('sectionId: $sectionId, ')
          ..write('shiftId: $shiftId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, std, sectionId, shiftId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Standard &&
          other.id == this.id &&
          other.std == this.std &&
          other.sectionId == this.sectionId &&
          other.shiftId == this.shiftId);
}

class StandardsCompanion extends UpdateCompanion<Standard> {
  final Value<int> id;
  final Value<String> std;
  final Value<int> sectionId;
  final Value<int> shiftId;
  const StandardsCompanion({
    this.id = const Value.absent(),
    this.std = const Value.absent(),
    this.sectionId = const Value.absent(),
    this.shiftId = const Value.absent(),
  });
  StandardsCompanion.insert({
    this.id = const Value.absent(),
    required String std,
    required int sectionId,
    required int shiftId,
  })  : std = Value(std),
        sectionId = Value(sectionId),
        shiftId = Value(shiftId);
  static Insertable<Standard> custom({
    Expression<int>? id,
    Expression<String>? std,
    Expression<int>? sectionId,
    Expression<int>? shiftId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (std != null) 'std': std,
      if (sectionId != null) 'section_id': sectionId,
      if (shiftId != null) 'shift_id': shiftId,
    });
  }

  StandardsCompanion copyWith(
      {Value<int>? id,
      Value<String>? std,
      Value<int>? sectionId,
      Value<int>? shiftId}) {
    return StandardsCompanion(
      id: id ?? this.id,
      std: std ?? this.std,
      sectionId: sectionId ?? this.sectionId,
      shiftId: shiftId ?? this.shiftId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (std.present) {
      map['std'] = Variable<String>(std.value);
    }
    if (sectionId.present) {
      map['section_id'] = Variable<int>(sectionId.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<int>(shiftId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StandardsCompanion(')
          ..write('id: $id, ')
          ..write('std: $std, ')
          ..write('sectionId: $sectionId, ')
          ..write('shiftId: $shiftId')
          ..write(')'))
        .toString();
  }
}

class $ClassesTable extends Classes with TableInfo<$ClassesTable, ClassesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _stdIdMeta = const VerificationMeta('stdId');
  @override
  late final GeneratedColumn<int> stdId = GeneratedColumn<int>(
      'std_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _divisionMeta =
      const VerificationMeta('division');
  @override
  late final GeneratedColumn<String> division = GeneratedColumn<String>(
      'division', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _classNameMeta =
      const VerificationMeta('className');
  @override
  late final GeneratedColumn<String> className = GeneratedColumn<String>(
      'class_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, stdId, division, className];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'classes';
  @override
  VerificationContext validateIntegrity(Insertable<ClassesData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('std_id')) {
      context.handle(
          _stdIdMeta, stdId.isAcceptableOrUnknown(data['std_id']!, _stdIdMeta));
    } else if (isInserting) {
      context.missing(_stdIdMeta);
    }
    if (data.containsKey('division')) {
      context.handle(_divisionMeta,
          division.isAcceptableOrUnknown(data['division']!, _divisionMeta));
    } else if (isInserting) {
      context.missing(_divisionMeta);
    }
    if (data.containsKey('class_name')) {
      context.handle(_classNameMeta,
          className.isAcceptableOrUnknown(data['class_name']!, _classNameMeta));
    } else if (isInserting) {
      context.missing(_classNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClassesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClassesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      stdId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}std_id'])!,
      division: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}division'])!,
      className: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}class_name'])!,
    );
  }

  @override
  $ClassesTable createAlias(String alias) {
    return $ClassesTable(attachedDatabase, alias);
  }
}

class ClassesData extends DataClass implements Insertable<ClassesData> {
  final int id;
  final int stdId;
  final String division;
  final String className;
  const ClassesData(
      {required this.id,
      required this.stdId,
      required this.division,
      required this.className});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['std_id'] = Variable<int>(stdId);
    map['division'] = Variable<String>(division);
    map['class_name'] = Variable<String>(className);
    return map;
  }

  ClassesCompanion toCompanion(bool nullToAbsent) {
    return ClassesCompanion(
      id: Value(id),
      stdId: Value(stdId),
      division: Value(division),
      className: Value(className),
    );
  }

  factory ClassesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClassesData(
      id: serializer.fromJson<int>(json['id']),
      stdId: serializer.fromJson<int>(json['stdId']),
      division: serializer.fromJson<String>(json['division']),
      className: serializer.fromJson<String>(json['className']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'stdId': serializer.toJson<int>(stdId),
      'division': serializer.toJson<String>(division),
      'className': serializer.toJson<String>(className),
    };
  }

  ClassesData copyWith(
          {int? id, int? stdId, String? division, String? className}) =>
      ClassesData(
        id: id ?? this.id,
        stdId: stdId ?? this.stdId,
        division: division ?? this.division,
        className: className ?? this.className,
      );
  ClassesData copyWithCompanion(ClassesCompanion data) {
    return ClassesData(
      id: data.id.present ? data.id.value : this.id,
      stdId: data.stdId.present ? data.stdId.value : this.stdId,
      division: data.division.present ? data.division.value : this.division,
      className: data.className.present ? data.className.value : this.className,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClassesData(')
          ..write('id: $id, ')
          ..write('stdId: $stdId, ')
          ..write('division: $division, ')
          ..write('className: $className')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, stdId, division, className);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassesData &&
          other.id == this.id &&
          other.stdId == this.stdId &&
          other.division == this.division &&
          other.className == this.className);
}

class ClassesCompanion extends UpdateCompanion<ClassesData> {
  final Value<int> id;
  final Value<int> stdId;
  final Value<String> division;
  final Value<String> className;
  const ClassesCompanion({
    this.id = const Value.absent(),
    this.stdId = const Value.absent(),
    this.division = const Value.absent(),
    this.className = const Value.absent(),
  });
  ClassesCompanion.insert({
    this.id = const Value.absent(),
    required int stdId,
    required String division,
    required String className,
  })  : stdId = Value(stdId),
        division = Value(division),
        className = Value(className);
  static Insertable<ClassesData> custom({
    Expression<int>? id,
    Expression<int>? stdId,
    Expression<String>? division,
    Expression<String>? className,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (stdId != null) 'std_id': stdId,
      if (division != null) 'division': division,
      if (className != null) 'class_name': className,
    });
  }

  ClassesCompanion copyWith(
      {Value<int>? id,
      Value<int>? stdId,
      Value<String>? division,
      Value<String>? className}) {
    return ClassesCompanion(
      id: id ?? this.id,
      stdId: stdId ?? this.stdId,
      division: division ?? this.division,
      className: className ?? this.className,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (stdId.present) {
      map['std_id'] = Variable<int>(stdId.value);
    }
    if (division.present) {
      map['division'] = Variable<String>(division.value);
    }
    if (className.present) {
      map['class_name'] = Variable<String>(className.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassesCompanion(')
          ..write('id: $id, ')
          ..write('stdId: $stdId, ')
          ..write('division: $division, ')
          ..write('className: $className')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DropdownOptionsTable dropdownOptions =
      $DropdownOptionsTable(this);
  late final $TestClassesTable testClasses = $TestClassesTable(this);
  late final $TestStudentsTable testStudents = $TestStudentsTable(this);
  late final $StudentsTable students = $StudentsTable(this);
  late final $StandardsTable standards = $StandardsTable(this);
  late final $ClassesTable classes = $ClassesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        dropdownOptions,
        testClasses,
        testStudents,
        students,
        standards,
        classes
      ];
}

typedef $$DropdownOptionsTableCreateCompanionBuilder = DropdownOptionsCompanion
    Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$DropdownOptionsTableUpdateCompanionBuilder = DropdownOptionsCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$DropdownOptionsTableFilterComposer
    extends Composer<_$AppDatabase, $DropdownOptionsTable> {
  $$DropdownOptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$DropdownOptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $DropdownOptionsTable> {
  $$DropdownOptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$DropdownOptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DropdownOptionsTable> {
  $$DropdownOptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$DropdownOptionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DropdownOptionsTable,
    DropdownOption,
    $$DropdownOptionsTableFilterComposer,
    $$DropdownOptionsTableOrderingComposer,
    $$DropdownOptionsTableAnnotationComposer,
    $$DropdownOptionsTableCreateCompanionBuilder,
    $$DropdownOptionsTableUpdateCompanionBuilder,
    (
      DropdownOption,
      BaseReferences<_$AppDatabase, $DropdownOptionsTable, DropdownOption>
    ),
    DropdownOption,
    PrefetchHooks Function()> {
  $$DropdownOptionsTableTableManager(
      _$AppDatabase db, $DropdownOptionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DropdownOptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DropdownOptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DropdownOptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DropdownOptionsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              DropdownOptionsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DropdownOptionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DropdownOptionsTable,
    DropdownOption,
    $$DropdownOptionsTableFilterComposer,
    $$DropdownOptionsTableOrderingComposer,
    $$DropdownOptionsTableAnnotationComposer,
    $$DropdownOptionsTableCreateCompanionBuilder,
    $$DropdownOptionsTableUpdateCompanionBuilder,
    (
      DropdownOption,
      BaseReferences<_$AppDatabase, $DropdownOptionsTable, DropdownOption>
    ),
    DropdownOption,
    PrefetchHooks Function()>;
typedef $$TestClassesTableCreateCompanionBuilder = TestClassesCompanion
    Function({
  Value<int> classId,
  required String className,
  Value<bool> isAttendanceDone,
});
typedef $$TestClassesTableUpdateCompanionBuilder = TestClassesCompanion
    Function({
  Value<int> classId,
  Value<String> className,
  Value<bool> isAttendanceDone,
});

class $$TestClassesTableFilterComposer
    extends Composer<_$AppDatabase, $TestClassesTable> {
  $$TestClassesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get classId => $composableBuilder(
      column: $table.classId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get className => $composableBuilder(
      column: $table.className, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAttendanceDone => $composableBuilder(
      column: $table.isAttendanceDone,
      builder: (column) => ColumnFilters(column));
}

class $$TestClassesTableOrderingComposer
    extends Composer<_$AppDatabase, $TestClassesTable> {
  $$TestClassesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get classId => $composableBuilder(
      column: $table.classId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get className => $composableBuilder(
      column: $table.className, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAttendanceDone => $composableBuilder(
      column: $table.isAttendanceDone,
      builder: (column) => ColumnOrderings(column));
}

class $$TestClassesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TestClassesTable> {
  $$TestClassesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get classId =>
      $composableBuilder(column: $table.classId, builder: (column) => column);

  GeneratedColumn<String> get className =>
      $composableBuilder(column: $table.className, builder: (column) => column);

  GeneratedColumn<bool> get isAttendanceDone => $composableBuilder(
      column: $table.isAttendanceDone, builder: (column) => column);
}

class $$TestClassesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TestClassesTable,
    TestClassesData,
    $$TestClassesTableFilterComposer,
    $$TestClassesTableOrderingComposer,
    $$TestClassesTableAnnotationComposer,
    $$TestClassesTableCreateCompanionBuilder,
    $$TestClassesTableUpdateCompanionBuilder,
    (
      TestClassesData,
      BaseReferences<_$AppDatabase, $TestClassesTable, TestClassesData>
    ),
    TestClassesData,
    PrefetchHooks Function()> {
  $$TestClassesTableTableManager(_$AppDatabase db, $TestClassesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TestClassesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TestClassesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TestClassesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> classId = const Value.absent(),
            Value<String> className = const Value.absent(),
            Value<bool> isAttendanceDone = const Value.absent(),
          }) =>
              TestClassesCompanion(
            classId: classId,
            className: className,
            isAttendanceDone: isAttendanceDone,
          ),
          createCompanionCallback: ({
            Value<int> classId = const Value.absent(),
            required String className,
            Value<bool> isAttendanceDone = const Value.absent(),
          }) =>
              TestClassesCompanion.insert(
            classId: classId,
            className: className,
            isAttendanceDone: isAttendanceDone,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TestClassesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TestClassesTable,
    TestClassesData,
    $$TestClassesTableFilterComposer,
    $$TestClassesTableOrderingComposer,
    $$TestClassesTableAnnotationComposer,
    $$TestClassesTableCreateCompanionBuilder,
    $$TestClassesTableUpdateCompanionBuilder,
    (
      TestClassesData,
      BaseReferences<_$AppDatabase, $TestClassesTable, TestClassesData>
    ),
    TestClassesData,
    PrefetchHooks Function()>;
typedef $$TestStudentsTableCreateCompanionBuilder = TestStudentsCompanion
    Function({
  Value<int> studentId,
  required int classId,
  required String name,
  required int rollNo,
  required int gender,
  Value<int?> attendanceStatus,
  Value<String?> leaveReason,
});
typedef $$TestStudentsTableUpdateCompanionBuilder = TestStudentsCompanion
    Function({
  Value<int> studentId,
  Value<int> classId,
  Value<String> name,
  Value<int> rollNo,
  Value<int> gender,
  Value<int?> attendanceStatus,
  Value<String?> leaveReason,
});

class $$TestStudentsTableFilterComposer
    extends Composer<_$AppDatabase, $TestStudentsTable> {
  $$TestStudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get classId => $composableBuilder(
      column: $table.classId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rollNo => $composableBuilder(
      column: $table.rollNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attendanceStatus => $composableBuilder(
      column: $table.attendanceStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get leaveReason => $composableBuilder(
      column: $table.leaveReason, builder: (column) => ColumnFilters(column));
}

class $$TestStudentsTableOrderingComposer
    extends Composer<_$AppDatabase, $TestStudentsTable> {
  $$TestStudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get classId => $composableBuilder(
      column: $table.classId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rollNo => $composableBuilder(
      column: $table.rollNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attendanceStatus => $composableBuilder(
      column: $table.attendanceStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get leaveReason => $composableBuilder(
      column: $table.leaveReason, builder: (column) => ColumnOrderings(column));
}

class $$TestStudentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TestStudentsTable> {
  $$TestStudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<int> get classId =>
      $composableBuilder(column: $table.classId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get rollNo =>
      $composableBuilder(column: $table.rollNo, builder: (column) => column);

  GeneratedColumn<int> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<int> get attendanceStatus => $composableBuilder(
      column: $table.attendanceStatus, builder: (column) => column);

  GeneratedColumn<String> get leaveReason => $composableBuilder(
      column: $table.leaveReason, builder: (column) => column);
}

class $$TestStudentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TestStudentsTable,
    TestStudent,
    $$TestStudentsTableFilterComposer,
    $$TestStudentsTableOrderingComposer,
    $$TestStudentsTableAnnotationComposer,
    $$TestStudentsTableCreateCompanionBuilder,
    $$TestStudentsTableUpdateCompanionBuilder,
    (
      TestStudent,
      BaseReferences<_$AppDatabase, $TestStudentsTable, TestStudent>
    ),
    TestStudent,
    PrefetchHooks Function()> {
  $$TestStudentsTableTableManager(_$AppDatabase db, $TestStudentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TestStudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TestStudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TestStudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> studentId = const Value.absent(),
            Value<int> classId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> rollNo = const Value.absent(),
            Value<int> gender = const Value.absent(),
            Value<int?> attendanceStatus = const Value.absent(),
            Value<String?> leaveReason = const Value.absent(),
          }) =>
              TestStudentsCompanion(
            studentId: studentId,
            classId: classId,
            name: name,
            rollNo: rollNo,
            gender: gender,
            attendanceStatus: attendanceStatus,
            leaveReason: leaveReason,
          ),
          createCompanionCallback: ({
            Value<int> studentId = const Value.absent(),
            required int classId,
            required String name,
            required int rollNo,
            required int gender,
            Value<int?> attendanceStatus = const Value.absent(),
            Value<String?> leaveReason = const Value.absent(),
          }) =>
              TestStudentsCompanion.insert(
            studentId: studentId,
            classId: classId,
            name: name,
            rollNo: rollNo,
            gender: gender,
            attendanceStatus: attendanceStatus,
            leaveReason: leaveReason,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TestStudentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TestStudentsTable,
    TestStudent,
    $$TestStudentsTableFilterComposer,
    $$TestStudentsTableOrderingComposer,
    $$TestStudentsTableAnnotationComposer,
    $$TestStudentsTableCreateCompanionBuilder,
    $$TestStudentsTableUpdateCompanionBuilder,
    (
      TestStudent,
      BaseReferences<_$AppDatabase, $TestStudentsTable, TestStudent>
    ),
    TestStudent,
    PrefetchHooks Function()>;
typedef $$StudentsTableCreateCompanionBuilder = StudentsCompanion Function({
  required String id,
  required String fullName,
  required String pgIds,
  required String currentClassId,
  required String currentRollNo,
  required String status,
  required String ppsp,
  Value<int> rowid,
});
typedef $$StudentsTableUpdateCompanionBuilder = StudentsCompanion Function({
  Value<String> id,
  Value<String> fullName,
  Value<String> pgIds,
  Value<String> currentClassId,
  Value<String> currentRollNo,
  Value<String> status,
  Value<String> ppsp,
  Value<int> rowid,
});

class $$StudentsTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pgIds => $composableBuilder(
      column: $table.pgIds, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentClassId => $composableBuilder(
      column: $table.currentClassId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentRollNo => $composableBuilder(
      column: $table.currentRollNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ppsp => $composableBuilder(
      column: $table.ppsp, builder: (column) => ColumnFilters(column));
}

class $$StudentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pgIds => $composableBuilder(
      column: $table.pgIds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentClassId => $composableBuilder(
      column: $table.currentClassId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentRollNo => $composableBuilder(
      column: $table.currentRollNo,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ppsp => $composableBuilder(
      column: $table.ppsp, builder: (column) => ColumnOrderings(column));
}

class $$StudentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get pgIds =>
      $composableBuilder(column: $table.pgIds, builder: (column) => column);

  GeneratedColumn<String> get currentClassId => $composableBuilder(
      column: $table.currentClassId, builder: (column) => column);

  GeneratedColumn<String> get currentRollNo => $composableBuilder(
      column: $table.currentRollNo, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get ppsp =>
      $composableBuilder(column: $table.ppsp, builder: (column) => column);
}

class $$StudentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StudentsTable,
    Student,
    $$StudentsTableFilterComposer,
    $$StudentsTableOrderingComposer,
    $$StudentsTableAnnotationComposer,
    $$StudentsTableCreateCompanionBuilder,
    $$StudentsTableUpdateCompanionBuilder,
    (Student, BaseReferences<_$AppDatabase, $StudentsTable, Student>),
    Student,
    PrefetchHooks Function()> {
  $$StudentsTableTableManager(_$AppDatabase db, $StudentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<String> pgIds = const Value.absent(),
            Value<String> currentClassId = const Value.absent(),
            Value<String> currentRollNo = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> ppsp = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudentsCompanion(
            id: id,
            fullName: fullName,
            pgIds: pgIds,
            currentClassId: currentClassId,
            currentRollNo: currentRollNo,
            status: status,
            ppsp: ppsp,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String fullName,
            required String pgIds,
            required String currentClassId,
            required String currentRollNo,
            required String status,
            required String ppsp,
            Value<int> rowid = const Value.absent(),
          }) =>
              StudentsCompanion.insert(
            id: id,
            fullName: fullName,
            pgIds: pgIds,
            currentClassId: currentClassId,
            currentRollNo: currentRollNo,
            status: status,
            ppsp: ppsp,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StudentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StudentsTable,
    Student,
    $$StudentsTableFilterComposer,
    $$StudentsTableOrderingComposer,
    $$StudentsTableAnnotationComposer,
    $$StudentsTableCreateCompanionBuilder,
    $$StudentsTableUpdateCompanionBuilder,
    (Student, BaseReferences<_$AppDatabase, $StudentsTable, Student>),
    Student,
    PrefetchHooks Function()>;
typedef $$StandardsTableCreateCompanionBuilder = StandardsCompanion Function({
  Value<int> id,
  required String std,
  required int sectionId,
  required int shiftId,
});
typedef $$StandardsTableUpdateCompanionBuilder = StandardsCompanion Function({
  Value<int> id,
  Value<String> std,
  Value<int> sectionId,
  Value<int> shiftId,
});

class $$StandardsTableFilterComposer
    extends Composer<_$AppDatabase, $StandardsTable> {
  $$StandardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get std => $composableBuilder(
      column: $table.std, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sectionId => $composableBuilder(
      column: $table.sectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get shiftId => $composableBuilder(
      column: $table.shiftId, builder: (column) => ColumnFilters(column));
}

class $$StandardsTableOrderingComposer
    extends Composer<_$AppDatabase, $StandardsTable> {
  $$StandardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get std => $composableBuilder(
      column: $table.std, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sectionId => $composableBuilder(
      column: $table.sectionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get shiftId => $composableBuilder(
      column: $table.shiftId, builder: (column) => ColumnOrderings(column));
}

class $$StandardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StandardsTable> {
  $$StandardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get std =>
      $composableBuilder(column: $table.std, builder: (column) => column);

  GeneratedColumn<int> get sectionId =>
      $composableBuilder(column: $table.sectionId, builder: (column) => column);

  GeneratedColumn<int> get shiftId =>
      $composableBuilder(column: $table.shiftId, builder: (column) => column);
}

class $$StandardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StandardsTable,
    Standard,
    $$StandardsTableFilterComposer,
    $$StandardsTableOrderingComposer,
    $$StandardsTableAnnotationComposer,
    $$StandardsTableCreateCompanionBuilder,
    $$StandardsTableUpdateCompanionBuilder,
    (Standard, BaseReferences<_$AppDatabase, $StandardsTable, Standard>),
    Standard,
    PrefetchHooks Function()> {
  $$StandardsTableTableManager(_$AppDatabase db, $StandardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StandardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StandardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StandardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> std = const Value.absent(),
            Value<int> sectionId = const Value.absent(),
            Value<int> shiftId = const Value.absent(),
          }) =>
              StandardsCompanion(
            id: id,
            std: std,
            sectionId: sectionId,
            shiftId: shiftId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String std,
            required int sectionId,
            required int shiftId,
          }) =>
              StandardsCompanion.insert(
            id: id,
            std: std,
            sectionId: sectionId,
            shiftId: shiftId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StandardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StandardsTable,
    Standard,
    $$StandardsTableFilterComposer,
    $$StandardsTableOrderingComposer,
    $$StandardsTableAnnotationComposer,
    $$StandardsTableCreateCompanionBuilder,
    $$StandardsTableUpdateCompanionBuilder,
    (Standard, BaseReferences<_$AppDatabase, $StandardsTable, Standard>),
    Standard,
    PrefetchHooks Function()>;
typedef $$ClassesTableCreateCompanionBuilder = ClassesCompanion Function({
  Value<int> id,
  required int stdId,
  required String division,
  required String className,
});
typedef $$ClassesTableUpdateCompanionBuilder = ClassesCompanion Function({
  Value<int> id,
  Value<int> stdId,
  Value<String> division,
  Value<String> className,
});

class $$ClassesTableFilterComposer
    extends Composer<_$AppDatabase, $ClassesTable> {
  $$ClassesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stdId => $composableBuilder(
      column: $table.stdId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get division => $composableBuilder(
      column: $table.division, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get className => $composableBuilder(
      column: $table.className, builder: (column) => ColumnFilters(column));
}

class $$ClassesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClassesTable> {
  $$ClassesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stdId => $composableBuilder(
      column: $table.stdId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get division => $composableBuilder(
      column: $table.division, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get className => $composableBuilder(
      column: $table.className, builder: (column) => ColumnOrderings(column));
}

class $$ClassesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClassesTable> {
  $$ClassesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get stdId =>
      $composableBuilder(column: $table.stdId, builder: (column) => column);

  GeneratedColumn<String> get division =>
      $composableBuilder(column: $table.division, builder: (column) => column);

  GeneratedColumn<String> get className =>
      $composableBuilder(column: $table.className, builder: (column) => column);
}

class $$ClassesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClassesTable,
    ClassesData,
    $$ClassesTableFilterComposer,
    $$ClassesTableOrderingComposer,
    $$ClassesTableAnnotationComposer,
    $$ClassesTableCreateCompanionBuilder,
    $$ClassesTableUpdateCompanionBuilder,
    (ClassesData, BaseReferences<_$AppDatabase, $ClassesTable, ClassesData>),
    ClassesData,
    PrefetchHooks Function()> {
  $$ClassesTableTableManager(_$AppDatabase db, $ClassesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClassesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClassesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClassesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> stdId = const Value.absent(),
            Value<String> division = const Value.absent(),
            Value<String> className = const Value.absent(),
          }) =>
              ClassesCompanion(
            id: id,
            stdId: stdId,
            division: division,
            className: className,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int stdId,
            required String division,
            required String className,
          }) =>
              ClassesCompanion.insert(
            id: id,
            stdId: stdId,
            division: division,
            className: className,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ClassesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClassesTable,
    ClassesData,
    $$ClassesTableFilterComposer,
    $$ClassesTableOrderingComposer,
    $$ClassesTableAnnotationComposer,
    $$ClassesTableCreateCompanionBuilder,
    $$ClassesTableUpdateCompanionBuilder,
    (ClassesData, BaseReferences<_$AppDatabase, $ClassesTable, ClassesData>),
    ClassesData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DropdownOptionsTableTableManager get dropdownOptions =>
      $$DropdownOptionsTableTableManager(_db, _db.dropdownOptions);
  $$TestClassesTableTableManager get testClasses =>
      $$TestClassesTableTableManager(_db, _db.testClasses);
  $$TestStudentsTableTableManager get testStudents =>
      $$TestStudentsTableTableManager(_db, _db.testStudents);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db, _db.students);
  $$StandardsTableTableManager get standards =>
      $$StandardsTableTableManager(_db, _db.standards);
  $$ClassesTableTableManager get classes =>
      $$ClassesTableTableManager(_db, _db.classes);
}
