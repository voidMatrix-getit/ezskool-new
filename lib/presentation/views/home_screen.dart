import 'package:ezskool/core/services/logger.dart';
import 'package:ezskool/data/repo/home_repo.dart';
import 'package:ezskool/data/repo/student_repo.dart';
import 'package:ezskool/data/viewmodels/home_viewmodel.dart';
import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: BaseScreen(
          child: Consumer<HomeViewModel>(
            builder: (context, viewModel, child) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Mark Attendance",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF494949),
                        ),
                      ),
                      SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: viewModel.currentView == ViewState.calendar
                            ? _buildCalendar(viewModel)
                            : viewModel.currentView == ViewState.qrScanner
                            ? _buildQRScanner(viewModel)
                            : _buildManualAttendance(viewModel),
                      ),
                      SizedBox(height: 24),
                      Text(
                        "Select Attendance Mode",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF494949),
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildAttendanceMode(viewModel),
                    ],
                  ),
                );
            },
          ),
      )
    );
  }

  Widget _buildCalendar(HomeViewModel viewModel) {
    final currentMonth = DateFormat('MMMM yyyy').format(viewModel.selectedDate);
    final firstDayOfMonth =
        DateTime(viewModel.selectedDate.year, viewModel.selectedDate.month, 1);
    final lastDayOfMonth = DateTime(
        viewModel.selectedDate.year, viewModel.selectedDate.month + 1, 0);
    final daysInMonth = List<DateTime>.generate(
      lastDayOfMonth.day,
      (i) => DateTime(
          viewModel.selectedDate.year, viewModel.selectedDate.month, i + 1),
    );

    final days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    final firstWeekdayOfMonth = (firstDayOfMonth.weekday % 7);

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left, color: Colors.black),
                  onPressed: () => viewModel.changeMonth(-1),
                ),
                InkWell(
                  onTap: () {}, // Add year change logic here if needed
                  child: Text(
                    currentMonth,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right, color: Colors.black),
                  onPressed: () => viewModel.changeMonth(1),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: days.map((day) {
                return Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: viewModel.selectedDate.weekday == days.indexOf(day)
                          ? Color(0xFFED7902)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            viewModel.selectedDate.weekday == days.indexOf(day)
                                ? Colors.white
                                : Colors.black54,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: List.generate(firstWeekdayOfMonth, (index) {
                return Container(
                  width: 40,
                  height: 40,
                  color: Colors.transparent,
                );
              })
                ..addAll(daysInMonth.map((date) {
                  final isSelected = viewModel.selectedDate.day == date.day &&
                      viewModel.selectedDate.month == date.month &&
                      viewModel.selectedDate.year == date.year;

                  return InkWell(
                    onTap: () {
                      viewModel.changeView(
                          ViewState.calendar); // Change logic as needed
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xFFED7902) : Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "${date.day}",
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRScanner(HomeViewModel viewModel) {
    return SizedBox(
        width: 284,
        height: 305,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: MobileScanner(
            onDetect: (barcodeCapture) {
              final List<Barcode> barcodes = barcodeCapture.barcodes;
              final String code = barcodes.isNotEmpty
                  ? barcodes.first.rawValue ?? '---'
                  : '---';

              // viewModel.onQRScanned(code);
            },
          ),
        ));
  }

  Widget _buildManualAttendance(HomeViewModel viewModel) {
    return Column(
      children: [
        Text(
          "Manual Attendance",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        // Add any further logic or widgets needed for manual attendance
      ],
    );
  }


  Widget _buildAttendanceMode(HomeViewModel viewModel) {
    final homeRepo = HomeRepo();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildModeCard(
          color: Color(0xFFFFF3E5), //0xFFFFE8D1
          svgPath: 'assets/qr.svg',
          label: "Scan QR Code",
          textColor: Color(0xFFED7902),
          onTap: () async {
            // showStudentNotFoundErrorDialog(context);
            final stud = await homeRepo.fetchStudentData();
            print(stud);
            Log.d(stud);

            await StudentRepository.storeStudentData(stud);

            // showAttendanceDialog(context);
            //
            // _changeView(ViewState.qrScanner);
          },
        ),
        _buildModeCard(
            color: Colors.white,
            svgPath: 'assets/hum.svg',
            label: "Manual Attendance",
            textColor: Colors.black,
            onTap: () {
              viewModel.changeView(ViewState.manualAttendance);
              // showAttendanceDialog(context);
            }),
      ],
    );
  }


  Widget _buildModeCard({
    Color? color,
    String? svgPath,
    String? label,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 4,
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 140,
          height: 140,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                svgPath!,
                width: 58,
                height: 58,
                // color: textColor,
              ),
              SizedBox(height: 8),
              Text(
                label!,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
