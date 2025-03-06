import 'package:drift/drift.dart';
import 'package:ezskool/core/services/http_service.dart';
import 'package:ezskool/core/services/logger.dart';
import '../../core/bloc/auth_bloc.dart';
import '../../core/constants/api.dart';
import '../../core/services/secure_storage_service.dart';
import '../datasources/local/dao/test_class/test_class_dao.dart';
import '../datasources/local/dao/test_student/test_student_dao.dart';
import '../datasources/local/db/app_database.dart';

class ClassStudentRepo extends HttpService {
  static final AppDatabase _db = AppDatabase.instance;
  static final testStudentDao = TestStudentDao(_db);
  static final testClassDao = TestClassDao(_db);
  @override
  final storage = SecureStorageService();

  Future<Map<String, dynamic>> sendMarkAttendanceData(
      String attDate,
      String ayId,
      String shiftId,
      String classId,
      String absentRollNo,
      String action,
      String classAttId,
      String totalAbsent,
      String totalPresent) async {
    final data;

    final tkn = await getBearerToken();

    if (action == '1') {
      data = await post(
        API.buildUrl(API.markClassAttendance),
        data: {
          'att_date': attDate,
          'ay_id': ayId,
          if (shiftId.isNotEmpty) 'shift_id': shiftId,
          'class_id': classId,
          'absent_roll_no': absentRollNo,
          if (action.isNotEmpty) 'action': action,
          'ta': totalAbsent,
          'tp': totalPresent
        },
        headers: {
          'Authorization': 'Bearer $tkn',
        },
      );
    } else {
      data = await post(
        API.buildUrl(API.markClassAttendance),
        data: {
          'att_date': attDate,
          'ay_id': ayId,
          if (shiftId.isNotEmpty) 'shift_id': shiftId,
          'class_id': classId,
          'absent_roll_no': absentRollNo,
          if (action.isNotEmpty) 'action': action,
          if (action.isNotEmpty) 'class_att_id': classAttId,
          'ta': totalAbsent,
          'tp': totalPresent
        },
        headers: {
          'Authorization': 'Bearer $tkn',
        },
      );
    }

    Log.d(data);
    if (data['success']) {
      await storage.write('attendance_id', data['attendance_id'].toString());
    }
    Future.delayed(Duration(seconds: 2));
    return {'success': data['success'], 'message': data['message']};
  }

  Future<Map<String, dynamic>> fetchTestClassStudentData(
      String classId, String attDate) async {
    // var tkn = await getBearerToken();

    // print('Brearer token: $tkn');
    final tkn = await getBearerToken();
    final data = await get(
      API.buildUrl(API.getClassStudent),
      queryParameters: {'class_id': classId, 'att_date': attDate},
      headers: {
        'Authorization': 'Bearer $tkn',
      },
    );

    return data;
  }

  static Future<void> storeStudent(Map<String, dynamic> data) async {
    await testStudentDao.insertStudent(TestStudentsCompanion(
        studentId: Value(data['student_id']),
        classId: Value(data['class_id']),
        name: Value(data['name']),
        rollNo: Value(data['roll_no']),
        gender: Value(data['gender']),
        attendanceStatus: Value(data['att_status']),
        leaveReason: Value(data['leave_reason'])));
  }

  static Future<void> storeClass(Map<String, dynamic> data) async {
    await testClassDao.insertClass(TestClassesCompanion(
        classId: Value(data['class_id']),
        className: Value(data['class_name']),
        isAttendanceDone: Value(data['class_att_id'] == 0 ? false : true)));
  }

  static Future<bool?> getClassIsAttDone(String className) async {
    final testClass = await testClassDao.getClassByName(className);

    return testClass?.isAttendanceDone;
  }

  static Future<void> storeTestClassStudentData(
      Map<String, dynamic> apiData) async {
    // print(apiData);
    await testClassDao.insertClass(TestClassesCompanion(
        classId: Value(apiData['class_id']),
        className: Value(apiData['class_name']),
        isAttendanceDone: Value(apiData['class_att_id'] == 0 ? false : true)));
    for (var student in apiData['students']) {
      await testStudentDao.insertStudent(TestStudentsCompanion(
          studentId: Value(student['student_id']),
          classId: Value(apiData['class_id']),
          name: Value(student['name']),
          rollNo: Value(student['roll_no']),
          gender: Value(student['gender']),
          attendanceStatus: Value(student['att_status']),
          leaveReason: Value(student['leave_reason'])));
    }
  }

  static Future<List<TestStudent?>?> getAllTestStudentsByClassName(
      int classId) async {
    // final testClass = await testClassDao.getClassByName(className);

    final students = await testStudentDao.getAllStudentsByClassId(classId);

    for (var student in students!) {
      Log.d(student as Object);
    }
    return students;
  }
}
