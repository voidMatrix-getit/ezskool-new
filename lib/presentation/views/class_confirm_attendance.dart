// import 'package:ezskool/data/viewmodels/attendance_viewmodel.dart';
// import 'package:ezskool/presentation/views/base_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class ClassConfirmAttendanceScreen extends StatelessWidget {
//   final AttendanceViewModel viewModel = AttendanceViewModel();
//   final List<bool> attendanceList = List.generate(
//     50,
//     (index) =>
//         index % 2 == 0, // Example data: Mark alternate roll numbers as present
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     final attendanceData = viewModel.getAttendanceData();
//
//     return BaseScreen(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // SVG for calendar
//                 SvgPicture.asset(
//                   'assets/cal.svg',
//                   width: 18,
//                   height: 18,
//                 ),
//                 SizedBox(width: 5),
//                 // Date Text
//                 Text(
//                   '${attendanceData.currentDate} Wednesday',
//                   style: const TextStyle(
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w500,
//                     fontSize: 14,
//                     color: Color(0xFF494949),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 // SVG for class
//                 SvgPicture.asset(
//                   'assets/cls.svg',
//                   width: 14,
//                   height: 17,
//                   color: Color(0xFF494949),
//                 ),
//                 SizedBox(width: 7),
//                 // Class Text
//                 Text(
//                   attendanceData.currentClass,
//                   style: const TextStyle(
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w500,
//                     fontSize: 14,
//                     color: Color(0xFF494949),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 24),
//             // Note Text
//             // Text(
//             //   'Note - All students are marked present by default. Tap the roll number boxes to mark them absent.',
//             //   textAlign: TextAlign.center,
//             //   style: const TextStyle(
//             //     fontFamily: 'Poppins',
//             //     fontWeight: FontWeight.w400,
//             //     fontSize: 11,
//             //     color: Color(0xFFA29595),
//             //   ),
//             // ),
//
//             MyStatefulWidget(),
//
//             const SizedBox(height: 34),
//             // Roll number grid
//             SizedBox(
//               height: 300,
//               child: GridView.builder(
//                 padding: const EdgeInsets.all(8.0),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 9, // Number of boxes in a row
//                   crossAxisSpacing: 10.0,
//                   mainAxisSpacing: 20.0,
//                 ),
//                 itemCount: attendanceList.length,
//                 itemBuilder: (context, index) {
//                   final isPresent = attendanceList[index];
//                   return GestureDetector(
//                     onTap: () {
//                       // Handle tap to toggle attendance
//                       attendanceList[index] = !isPresent;
//                     },
//                     child: Container(
//                       width: 28.52,
//                       height: 28.52,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF5F5F7),
//                         border: Border.all(
//                           color: const Color(0xFF33CC99),
//                           width: 1,
//                         ),
//                         borderRadius: BorderRadius.circular(3),
//                       ),
//                       child: Center(
//                         child: Text(
//                           (index + 1).toString(),
//                           style: const TextStyle(
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16,
//                             color: Color(0xFF494949),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             const SizedBox(height: 20,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // First Card - Present
//                 _buildCard(
//                   color: Color(0xFFF5F5F7),
//                   borderColor: Color(0xFF33CC99),
//                   shadowColor: Colors.black.withOpacity(0.25),
//                   number: "46",
//                   label: "Present",
//                   textColor: Color(0xFF33CC99),
//                 ),
//                 SizedBox(width: 21), // Space between cards
//                 // Second Card - Absent
//                 _buildCard(
//                   color: Color(0xFFF5F5F7),
//                   borderColor: Color(0xFFDD3E2B),
//                   shadowColor: Colors.black.withOpacity(0.25),
//                   number: "12",
//                   label: "Absent",
//                   textColor: Color(0xFFDD3E2B),
//                 ),
//                 SizedBox(width: 21), // Space between cards
//                 // Third Card - Late
//                 _buildCard(
//                   color: Color(0xFFF5F5F7),
//                   borderColor: Color(0xFFFBCB99),
//                   shadowColor: Colors.black.withOpacity(0.25),
//                   number: "58",
//                   label: "Total",
//                   textColor: Colors.black,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 40,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Button 1: Gray background
//                 ElevatedButton(
//                   onPressed: () {
//                     // Button 1 action
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xF5F5F5F5),
//                     // Gray background
//                     shadowColor: Colors.black.withOpacity(0.5),
//                     // Drop shadow
//                     elevation: 4,
//                     // Shadow elevation
//                     shape: RoundedRectangleBorder(
//                       borderRadius:
//                       BorderRadius.circular(5), // Rounded corners
//                     ),
//                     padding: EdgeInsets.symmetric(
//                         horizontal: 22, vertical: 10),
//                   ),
//                   child: Text(
//                     "Cancel", // Replace with actual text
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w500,
//                       fontSize: 14,
//                       letterSpacing: 0.4,
//                       color: Color(0xFF494949), // Text color
//                     ),
//                   ),
//                 ),
//                 // Button 2: Orange background
//                 SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Button 2 action
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFFED7902),
//                     // Orange background
//                     shadowColor: Colors.black.withOpacity(0.5),
//                     // Drop shadow
//                     elevation: 4,
//                     // Shadow elevation
//                     shape: RoundedRectangleBorder(
//                       borderRadius:
//                       BorderRadius.circular(5), // Rounded corners
//                     ),
//                     padding: EdgeInsets.symmetric(
//                         horizontal: 22, vertical: 10),
//                   ),
//                   child: Text(
//                     "Confirm", // Replace with actual text
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w500,
//                       fontSize: 14,
//                       letterSpacing: 0.4,
//                       color: Color(0xFFFAECEC), // Text color
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCard({
//     required Color color,
//     required Color borderColor,
//     required Color shadowColor,
//     required String number,
//     required String label,
//     required Color textColor,
//   }) {
//     return Container(
//       width: 94,
//       height: 102,
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(7),
//         border: Border.all(color: borderColor),
//         boxShadow: [
//           BoxShadow(
//             color: shadowColor,
//             offset: Offset(0, 4),
//             blurRadius: 8.4,
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             number,
//             style: TextStyle(
//               fontFamily: 'Inter',
//               fontWeight: FontWeight.w500,
//               fontSize: 40,
//               height: 1.2,
//               color: textColor,
//               letterSpacing: 0.4,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             label,
//             style: TextStyle(
//               fontFamily: 'Inter',
//               fontWeight: FontWeight.w500,
//               fontSize: 14,
//               height: 1.2,
//               color: textColor,
//               letterSpacing: 0.4,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class MyStatefulWidget extends StatefulWidget {
//   @override
//   _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
// }
//
// class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//   bool isPresentSelected = true; // Default state
//
//   @override
//   Widget build(BuildContext context) {
//     return ToggleOptions(
//       isPresentSelected: isPresentSelected,
//       onToggle: (bool value) {
//         setState(() {
//           isPresentSelected = value; // Update the state
//         });
//       },
//     );
//   }
// }
//
// class ToggleOptions extends StatelessWidget {
//   final bool isPresentSelected; // Current toggle state
//   final Function(bool) onToggle; // Callback for toggle change
//
//   ToggleOptions({required this.isPresentSelected, required this.onToggle});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Present Option
//             GestureDetector(
//               onTap: () => onToggle(true),
//               child: Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
//                     child: Text(
//                       "Present(47)",
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16,
//                         height: 1.5,
//                         // Equivalent to line-height
//                         color: isPresentSelected
//                             ? Color(0xFFED7902) // Highlighted color
//                             : Color(0xFF1E1E1E), // Normal black color
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: 121,
//                     height: 2,
//                     color: isPresentSelected
//                         ? Color(0xFFED7902) // Highlighted line color
//                         : Color(0xFFE0E4EC), // Dimmed line color
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: 8), // Space between the toggles
//             // Absent Option
//             GestureDetector(
//               onTap: () => onToggle(false),
//               child: Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
//                     child: Text(
//                       "Absent(12)",
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16,
//                         height: 1.5,
//                         // Equivalent to line-height
//                         color: !isPresentSelected
//                             ? Color(0xFFED7902) // Highlighted color
//                             : Color(0xFF1E1E1E), // Normal black color
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: 113,
//                     height: 2,
//                     color: !isPresentSelected
//                         ? Color(0xFFED7902) // Highlighted line color
//                         : Color(0xFFE0E4EC), // Dimmed line color
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }



import 'package:ezskool/data/viewmodels/class_confirm_attendance_viewmodel.dart';
import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ClassConfirmAttendanceScreen extends StatelessWidget {
  const ClassConfirmAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassConfirmAttendanceViewModel>(context);
    final attendanceData = viewModel.getAttendanceData();
    final isPresentSelected = viewModel.isPresentSelected;
    final rollNumbersToShow = isPresentSelected
        ? viewModel.presentRollNumbers
        : viewModel.absentRollNumbers;

    return BaseScreen(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Date and Class Info
                SvgPicture.asset('assets/cal.svg', width: 18, height: 18),
                SizedBox(width: 5),
                Text('${attendanceData.currentDate} Wednesday'),
                SizedBox(width: 16),
                SvgPicture.asset('assets/vec.svg', width: 14, height: 17),
                // Image.asset('assets/vec.png', height: 18, width: 18,),
                SizedBox(width: 7),
                Text(attendanceData.currentClass),
              ],
            ),
            SizedBox(height: 24),
            // Toggle Section (Merged into ClassConfirmAttendanceScreen)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => viewModel.toggleOption(true),
                  child: Column(
                    children: [
                      Text(
                        "Present(${viewModel.presentRollNumbers.length})",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: isPresentSelected
                              ? Color(0xFFED7902)
                              : Color(0xFF1E1E1E),
                        ),
                      ),
                      Container(
                        width: 121,
                        height: 2,
                        color: isPresentSelected
                            ? Color(0xFFED7902)
                            : Color(0xFFE0E4EC),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () => viewModel.toggleOption(false),
                  child: Column(
                    children: [
                      Text(
                        "Absent(${viewModel.absentRollNumbers.length})",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: !isPresentSelected
                              ? Color(0xFFED7902)
                              : Color(0xFF1E1E1E),
                        ),
                      ),
                      Container(
                        width: 113,
                        height: 2,
                        color: !isPresentSelected
                            ? Color(0xFFED7902)
                            : Color(0xFFE0E4EC),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 34),
            // Roll number grid
            SizedBox(
              height: 300,
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 20.0,
                ),
                itemCount: rollNumbersToShow.length,
                itemBuilder: (context, index) {
                  final rollNo = rollNumbersToShow[index];
                  final isPresent = viewModel.attendanceList[rollNo];
                  return GestureDetector(
                    onTap: () {
                      viewModel.toggleAttendance(rollNo);
                    },
                    child: Container(
                      width: 28.52,
                      height: 28.52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F7), // Light red for absent
                        border: Border.all(
                          color: isPresent
                              ? Color(0xFF33CC99) // Green for present
                              : Color(0xFFDD3E2B), // Red for absent
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Center(
                        child: Text(
                          (rollNo + 1).toString(),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: isPresent
                                ? const Color(0xFF494949)
                                : const Color(0xFF494949),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Other UI components like cards, buttons...
          ],
        ),
      ),
    );
  }
}

