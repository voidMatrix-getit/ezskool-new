class API {
  static late final String baseURL;

  // auth
  static const register = 'inquiry/create';
  static const login = 'login';
  static const logout = 'logout';

  static const getDataStudent = 'get_student_master_atd';
  static const getLoginSync = 'get_login_sync';
  static const getClassStudent = 'get_class_students_att';
  static const markClassAttendance = 'mark_class_att';
  static const getClassStudentList = 'get_class_student_list';
  static const getStudentDetails = 'get_student_details';
  static const getParentsContact = 'get_parents_contact';
  static const getBirthdays = 'get_student_bday';
  static const getAttReport = 'get_shift_att';
  static const getWholeSchoolAttReport = 'get_shift_wise_school_att';
  static const getClassAttSummary = 'get_class_att_summary';

  static void setBaseURL(String url) {
    baseURL = url;
  }

  static String buildUrl(String endpoint) => '$baseURL$endpoint';

  // static Future<String?> getBaseURL() async {
  //     return await secureStorage.read(key: 'baseURL');
  // }
  //
  // static Future<String?> getBearerToken() async {
  //     return await secureStorage.read(key: 'bearerToken');
  // }
}
