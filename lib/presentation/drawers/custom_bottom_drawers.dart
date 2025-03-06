import 'package:ezskool/data/viewmodels/class_attendance/class_attendance_home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<String> standards = List.generate(10, (index) => '${index + 1}');

void openBottomDrawerDropDown(BuildContext context) {
  final viewModel =
      Provider.of<ClassAttendanceHomeViewModel>(context, listen: false);

  String? tempStandard = viewModel.selectedStandard;
  String? tempDivision = viewModel.selectedDivision;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            height: 550,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(36),
                topRight: Radius.circular(36),
              ),
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(height: 13),
                Container(
                  height: 4,
                  width: 164,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                SizedBox(height: 20),

                Text(
                  'Select Standard',
                  style: TextStyle(
                    // fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    height: 1.5,
                    color: Color(0xFF181818),
                  ),
                ),
                SizedBox(height: 15),

                SizedBox(
                  height: 230,
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 42),
                    shrinkWrap: true,
                    itemCount: standards.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      final isSelected = tempStandard == standards[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            tempStandard = standards[index];
                          });
                        },
                        child: Container(
                          height: 51,
                          width: 58,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(0xFFED7902)
                                : Color(0xFFFFE8D1),
                            border: Border.all(color: Color(0xFFE2E2E2)),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              standards[index],
                              style: TextStyle(
                                // fontFamily: GoogleFonts.poppinsTextTheme(),
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                height: 1.5,
                                color: isSelected
                                    ? Color(0xFFF5F5F7)
                                    : Color(0xFF494949),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 20),

                Text(
                  'Select Division',
                  style: TextStyle(
                    // fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    height: 1.5,
                    color: Color(0xFF181818),
                  ),
                ),
                SizedBox(height: 15),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 42),
                    shrinkWrap: true,
                    itemCount: viewModel.divisions.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      final isSelected =
                          tempDivision == viewModel.divisions[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            tempDivision = viewModel.divisions[index];
                          });
                        },
                        child: Container(
                          height: 51,
                          width: 58,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(0xFFED7902)
                                : Color(0xFFFFE8D1),
                            border: Border.all(color: Color(0xFFE2E2E2)),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              viewModel.divisions[index],
                              style: TextStyle(
                                  // fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                  height: 1.5,
                                  color: isSelected
                                      ? Color(0xFFF5F5F7)
                                      : Color(0xFF494949)
                                  // Color(0x49494949),
                                  ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                Divider(
                  indent: 20,
                  endIndent: 20,
                  color: Colors.grey[400],
                  thickness: 1,
                  height: 1,
                ),
                // SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Button 1: Gray background
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xF5F5F5F5),
                          // Gray background
                          shadowColor: Colors.black.withOpacity(0.5),
                          // Drop shadow
                          elevation: 4,
                          // Shadow elevation
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(5), // Rounded corners
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 22, vertical: 10),
                        ),
                        child: Text(
                          "Cancel", // Replace with actual text
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            letterSpacing: 0.4,
                            color: Color(0xFF494949), // Text color
                          ),
                        ),
                      ),
                      // Button 2: Orange background
                      SizedBox(width: 20),

                      ElevatedButton(
                        onPressed: () {
                          if (tempStandard != null && tempDivision != null) {
                            viewModel.updateStandard(tempStandard!);
                            viewModel.updateDivision(tempDivision!);
                          }
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFED7902),
                          // Orange background
                          shadowColor: Colors.black.withOpacity(0.5),
                          // Drop shadow
                          elevation: 4,
                          // Shadow elevation
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(5), // Rounded corners
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 22, vertical: 10),
                        ),
                        child: Text(
                          "OK", // Replace with actual text
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            letterSpacing: 0.4,
                            color: Color(0xFFFAECEC), // Text color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
    },
  );
}

//
// void openBottomDrawerDropDown(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     builder: (BuildContext context) {
//       return GestureDetector(
//         onTap: () {},
//         child: Container(
//           height: 520, // Increased height to fit both sections and the buttons
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(36),
//               topRight: Radius.circular(36),
//             ),
//             color: Colors.white,
//           ),
//           child: Column(
//             children: [
//               SizedBox(height: 13),
//               Container(
//                 height: 4,
//                 width: 162,
//                 decoration: BoxDecoration(
//                   color: Color(0xFFED7902),
//                   borderRadius: BorderRadius.circular(22),
//                 ),
//               ),
//               SizedBox(height: 20),
//
//               // Select Standard Section
//               Text(
//                 'Select Standard',
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w400,
//                   fontSize: 18,
//                   height: 1.5,
//                   color: Color(0xFF181818),
//                 ),
//               ),
//               SizedBox(height: 20),
//               SizedBox(
//                 height: 230,
//                 child: GridView.builder(
//                   padding: EdgeInsets.symmetric(horizontal: 42),
//                   shrinkWrap: true,
//                   itemCount: standards.length,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 4,
//                     crossAxisSpacing: 20,
//                     mainAxisSpacing: 20,
//                   ),
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () {
//
//                       },
//                       child: Container(
//                         height: 51,
//                         width: 58,
//                         decoration: BoxDecoration(
//                           color: true ? Color(0xFF33CC99) :Color(0xFFED7902),
//                           border: Border.all(color: Color(0xFFE2E2E2)),
//                           borderRadius: BorderRadius.circular(5),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.25),
//                               offset: Offset(0, 2),
//                               blurRadius: 4,
//                             ),
//                           ],
//                         ),
//                         child: Center(
//                           child: Text(
//                             standards[index],
//                             style: TextStyle(
//                               fontFamily: 'Poppins',
//                               fontWeight: FontWeight.w600,
//                               fontSize: 24,
//                               height: 1.5,
//                               color: Color(0xFFFAECEC),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//
//               SizedBox(height: 10),
//
//               // Select Division Section
//               Text(
//                 'Select Division',
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w400,
//                   fontSize: 18,
//                   height: 1.5,
//                   color: Color(0xFF181818),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Expanded(
//                 child: GridView.builder(
//                   padding: EdgeInsets.symmetric(horizontal: 42),
//                   shrinkWrap: true,
//                   itemCount: divisions.length,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 4,
//                     crossAxisSpacing: 20,
//                     mainAxisSpacing: 20,
//                   ),
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () {
//
//                         // Navigator.pop(context); // Close the dropdown
//                       },
//                       child: Container(
//                         height: 51,
//                         width: 58,
//                         decoration: BoxDecoration(
//                           color: true ? Color(0xFF33CC99) :Color(0xFFED7902),
//                           border: Border.all(color: Color(0xFFE2E2E2)),
//                           borderRadius: BorderRadius.circular(5),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.25),
//                               offset: Offset(0, 2),
//                               blurRadius: 4,
//                             ),
//                           ],
//                         ),
//                         child: Center(
//                           child: Text(
//                             divisions[index],
//                             style: TextStyle(
//                               fontFamily: 'Poppins',
//                               fontWeight: FontWeight.w600,
//                               fontSize: 24,
//                               height: 1.5,
//                               color: Color(0xFFFAECEC),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Button 1: Gray background
//                     ElevatedButton(
//                       onPressed: () {
//                         // Button 1 action
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xF5F5F5F5),
//                         // Gray background
//                         shadowColor: Colors.black.withOpacity(0.5),
//                         // Drop shadow
//                         elevation: 4,
//                         // Shadow elevation
//                         shape: RoundedRectangleBorder(
//                           borderRadius:
//                           BorderRadius.circular(5), // Rounded corners
//                         ),
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 22, vertical: 10),
//                       ),
//                       child: Text(
//                         "Cancel", // Replace with actual text
//                         style: TextStyle(
//                           fontFamily: 'Inter',
//                           fontWeight: FontWeight.w500,
//                           fontSize: 14,
//                           letterSpacing: 0.4,
//                           color: Color(0xFF494949), // Text color
//                         ),
//                       ),
//                     ),
//                     // Button 2: Orange background
//                     SizedBox(width: 20),
//                     ElevatedButton(
//                       onPressed: () {
//                         // Button 2 action
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFFED7902),
//                         // Orange background
//                         shadowColor: Colors.black.withOpacity(0.5),
//                         // Drop shadow
//                         elevation: 4,
//                         // Shadow elevation
//                         shape: RoundedRectangleBorder(
//                           borderRadius:
//                           BorderRadius.circular(5), // Rounded corners
//                         ),
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 22, vertical: 10),
//                       ),
//                       child: Text(
//                         "OK", // Replace with actual text
//                         style: TextStyle(
//                           fontFamily: 'Inter',
//                           fontWeight: FontWeight.w500,
//                           fontSize: 14,
//                           letterSpacing: 0.4,
//                           color: Color(0xFFFAECEC), // Text color
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
