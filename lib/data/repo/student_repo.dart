import 'package:drift/drift.dart';
import 'package:ezskool/core/services/http_service.dart';
import 'package:ezskool/data/datasources/local/dao/class/class_dao.dart';
import 'package:ezskool/data/datasources/local/dao/student//student_dao.dart';
import 'package:ezskool/data/datasources/local/db/app_database.dart';

import '../../core/bloc/auth_bloc.dart';
import '../../core/constants/api.dart';
import '../../core/services/logger.dart';

class StudentRepository extends HttpService {
  static final AppDatabase _db = AppDatabase.instance;
  static final studentDao = StudentDao(_db);
  static final classDao = ClassDao(_db);

  static Future<void> storeStudentData(
      List<Map<String, String>> apiData) async {
    for (var studentMap in apiData) {
      final student = StudentsCompanion(
        id: Value(studentMap['id'] ?? ''),
        fullName: Value(studentMap['full_name'] ?? ''),
        pgIds: Value(studentMap['pg_ids'] ?? ''),
        currentClassId: Value(studentMap['current_class_id'] ?? ''),
        currentRollNo: Value(studentMap['current_roll_no'] ?? ''),
        status: Value(studentMap['status'] ?? ''),
        ppsp: Value(studentMap['ppsp'] ?? ''),
      );
      await studentDao.insertStudent(student);
    }
  }

  static Future<Student?> fetchStudentData(String id) async {
    // Fetch the student using the provided ID
    final student = await studentDao.getStudentById(id);

    // Return the result (or null if not found)
    return student;
  }

  //classes
  Future<void> fetchAllClasses() async {
    final tkn = await getBearerToken();

    final data = await post(
      API.buildUrl(API.getLoginSync),
      data: {'sync_req': 'class'},
      headers: {
        'Authorization': 'Bearer $tkn',
      },
    );
    final apiData = data['data']['class'];
    Log.d(apiData);

    for (var classMap in apiData) {
      final cls = ClassesCompanion(
        id: Value(classMap['id'] ?? ''),
        stdId: Value(classMap['std_id'] ?? ''),
        division: Value(classMap['division'] ?? ''),
        className: Value(classMap['class_name'] ?? ''),
      );
      await classDao.insertClass(cls);
    }

    // final classData = await classDao.getAllClasses();
    //
    // List<Map<String, dynamic>> cardData = classData.map((classData) {
    //   return {
    //     'classId': classData.id,
    //     'title': classData.className.replaceAll('-', ' '), // Formatting title
    //     'count': 0, // Default value (replace with actual student count)
    //     'label': 'Students',
    //   };
    // }).toList();
    //
    //
    // Log.d(cardData);
    // //
    // // Log.d(lr);
    // return cardData;
  }

  Future<dynamic> getAllClasses() async {
    final classData = await classDao.getAllClasses();

    List<Map<String, dynamic>> cardData = classData.map((classData) {
      return {
        'classId': classData.id,
        'title': classData.className.replaceAll('-', ' '), // Formatting title
        'count': 0, // Default value (replace with actual student count)
        'label': 'Students',
      };
    }).toList();

    Log.d(cardData);
    //
    // Log.d(lr);
    return cardData;
  }

  Future<dynamic> fetchAllStudents(String classId) async {
    final tkn = await getBearerToken();
    final data = await get(
      API.buildUrl(API.getClassStudentList),
      queryParameters: {'class_id': classId},
      headers: {
        'Authorization': 'Bearer $tkn',
      },
    );
    final apiData = data['data'];
    Log.d(apiData);

    return apiData;
  }

  Future<dynamic> fetchStudent(String studId) async {
    final tkn = await getBearerToken();
    final data = await post(
      API.buildUrl(API.getStudentDetails),
      data: {'student_id': studId},
      headers: {
        'Authorization': 'Bearer $tkn',
      },
    );
    final apiData = data;
    Log.d(apiData);

    return apiData;
  }

  Future<List<Map<String, dynamic>>> fetchParents(String studId) async {
    final tkn = await getBearerToken();

    final data = await get(
      API.buildUrl(API.getParentsContact),
      queryParameters: {'student_id': studId},
      headers: {
        'Authorization': 'Bearer $tkn',
      },
    );

    Log.d(data['parents']);

    if (data['parents'] is List) {
      return List<Map<String, dynamic>>.from(data['parents']);
    } else {
      throw Exception("Unexpected API response format: ${data['parents']}");
    }

    // return data['parents'];
  }

  Future<dynamic> fetchBirthdays(String fromDate, String toDate) async {
    final tkn = await getBearerToken();

    final data = await post(
      API.buildUrl(API.getBirthdays),
      data: {'from_date': fromDate, 'to_date': toDate},
      headers: {
        'Authorization': 'Bearer $tkn',
      },
    );
    final apiData = data;
    Log.d(apiData);

    return apiData;
  }

  Future<dynamic> fetchClassAttendanceReport(String shift, String date) async {
    final tkn = await getBearerToken();

    final data = await post(
      API.buildUrl(API.getAttReport),
      data: {'shift_id': shift, 'att_date': date},
      headers: {
        'Authorization': 'Bearer $tkn',
      },
    );
    final apiData = data;
    Log.d('ApiData: $apiData');

    return apiData;
  }
}
