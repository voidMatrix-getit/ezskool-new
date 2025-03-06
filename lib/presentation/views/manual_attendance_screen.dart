import 'package:ezskool/data/viewmodels/attendance_viewmodel.dart';
import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ManualAttendanceScreen extends StatelessWidget {
  final AttendanceViewModel viewModel = AttendanceViewModel();
  final List<bool> attendanceList = List.generate(
    50,
        (index) => index % 2 == 0, // Example data: Mark alternate roll numbers as present
  );

  ManualAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final attendanceData = viewModel.getAttendanceData();

    return BaseScreen(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SVG for calendar
                SvgPicture.asset(
                  'assets/cal.svg',
                  width: 18,
                  height: 18,
                ),
                SizedBox(width: 5),
                // Date Text
                Text(
                  attendanceData.currentDate,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF494949),
                  ),
                ),
                SizedBox(width: 16),
                // SVG for class
                SvgPicture.asset(
                  'assets/cls.svg',
                  width: 14,
                  height: 17,
                  color: Color(0xFF494949),
                ),
                SizedBox(width: 7),
                // Class Text
                Text(
                  attendanceData.currentClass,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF494949),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            // Note Text
            Text(
              'Note - All students are marked present by default. Tap the roll number boxes to mark them absent.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 11,
                color: Color(0xFFA29595),
              ),
            ),

            const SizedBox(height: 34),
            // Roll number grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9, // Number of boxes in a row
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 20.0,
                ),
                itemCount: attendanceList.length,
                itemBuilder: (context, index) {
                  final isPresent = attendanceList[index];
                  return GestureDetector(
                    onTap: () {
                      // Handle tap to toggle attendance
                      attendanceList[index] = !isPresent;
                    },
                    child: Container(
                      width: 28.52,
                      height: 28.52,
                      decoration: BoxDecoration(
                        color: isPresent ? const Color(0xFFF5F5F7) : Color(0xFFFFF3AB),
                        border: Border.all(
                          color: isPresent
                              ? const Color(0xFF33CC99)
                              : const Color(0xFFFFDF27),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xFF494949),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
