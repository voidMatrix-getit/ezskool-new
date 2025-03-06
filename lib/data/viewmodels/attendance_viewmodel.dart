import 'package:ezskool/data/models/atttendance.dart';
import 'package:intl/intl.dart';

class AttendanceViewModel {
  AttendanceModel getAttendanceData() {
    String currentDate = DateFormat('dd MMM yyyy').format(DateTime.now());
    String currentClass = "6th A"; // Replace with dynamic class if needed
    return AttendanceModel(currentDate: currentDate, currentClass: currentClass);
  }
}
