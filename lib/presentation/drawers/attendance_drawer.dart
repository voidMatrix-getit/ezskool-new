import 'package:flutter/material.dart';

class AttendanceDialog extends StatefulWidget {

  final String studentName;
  final String studentId;

  const AttendanceDialog({
    super.key,
    required this.studentName,
    required this.studentId,
  });

  @override
  _AttendanceDialogState createState() => _AttendanceDialogState();
}

class _AttendanceDialogState extends State<AttendanceDialog> {
  // Declare the variable to toggle images
  String imagePath = 'assets/wm.png';
  String shown = 'assets/wm.png';
  String hidden = 'assets/el.png';
  bool visible = false;


  // Function to toggle the image
  void toggleImage() {
    setState(() {
      if(!visible){
        visible = true;
      }
      else{
        visible = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            width: 60,
            decoration: BoxDecoration(
              color: Color(0xFFED7902),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Student Details',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF181818),
            ),
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 50),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 241,
                    height: 158,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF3E5),
                      border: Border.all(
                        color: Color(0xFFED7902),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.studentName,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Std - 5',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                          Text(
                            'Class - A',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                          Text(
                            'Roll Number - ${widget.studentId}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: -65,
                    top: 30,
                    child: GestureDetector(
                      key: ValueKey(imagePath),
                      onTap: toggleImage,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF3E5),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFFED7902),
                            width: 2,
                          ),
                          image: DecorationImage(
                            image: visible ? AssetImage(hidden) : AssetImage(shown),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Confirm attendance for this student?',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xFF878687),
            ),
          ),
          SizedBox(height: 8),
          Row(
            // alignment: WrapAlignment.spaceBetween,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              SizedBox(width: 40),

              ElevatedButton(

                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(

                  backgroundColor: Color(0xFFF5F5F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                child: Row(

                  children: [
                    Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.cancel,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFED7902),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                child: Row(
                  children: [
                    Text(
                      'Mark Attendance',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Color(0xFFED7902),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showAttendanceDialog(BuildContext context,String studentName, String studentId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return AttendanceDialog(
        studentName: studentName,
        studentId: studentId,
      ); // Use the StatefulWidget
    },
  );
}






// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// void showAttendanceDialog(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     builder: (BuildContext context) {
//       return Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//
//               height: 4,
//               width: 60,
//               decoration: BoxDecoration(
//                 color: Color(0xFFED7902), // App theme color
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Student Details',
//               style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Color(0xFF181818),
//               ),
//             ),
//             SizedBox(height: 16),
//
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//
//                 SizedBox(width: 50,),
//                 Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     Container(
//                       width: 241,
//                       height: 158,
//                       decoration: BoxDecoration(
//                         color: Color(0xFFFFF3E5), // Light orange background
//                         border: Border.all(
//                           color: Color(0xFFED7902), // Border color
//                           width: 1,
//                         ),
//                         borderRadius: BorderRadius.circular(7),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Navya Sharma',
//                               style: TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                                 color: Color(0xFF1E1E1E),
//                               ),
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               'Std - 5',
//                               style: TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontWeight: FontWeight.normal,
//                                 fontSize: 14,
//                                 color: Color(0xFF1E1E1E),
//                               ),
//                             ),
//                             Text(
//                               'Class - A',
//                               style: TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontWeight: FontWeight.normal,
//                                 fontSize: 14,
//                                 color: Color(0xFF1E1E1E),
//                               ),
//                             ),
//                             Text(
//                               'Roll Number - 14',
//                               style: TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontWeight: FontWeight.normal,
//                                 fontSize: 14,
//                                 color: Color(0xFF1E1E1E),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       left: -60,
//                       top: 14,
//                       child: Container(
//                         width: 124,
//                         height: 124,
//                         decoration: BoxDecoration(
//                           color: Color(0xFFFFF3E5),
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: Color(0xFFED7902), // App theme border color
//                             width: 2,
//                           ),
//                           image: DecorationImage(
//                             image: AssetImage('assets/wm.png'),
//                             fit: BoxFit.cover,
//                             // alignment: Alignment.centerRight, // Crop left half
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//
//
//               ],
//
//
//             ),
//
//             SizedBox(height: 8),
//             Text(
//               'Confirm attendance for this student?',
//               style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//                 color: Color(0xFF878687),
//               ),
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context); // Close dialog
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFFF5F5F5),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                   ),
//                   child: Row(
//                     children: [
//                       Text(
//                         'Cancel',
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.normal,
//                           fontSize: 14,
//                           color: Colors.black,
//                         ),
//                       ),
//                       SizedBox(width: 8), // Spacing between text and icon
//                       Container(
//                         padding: EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           Icons.cancel,
//                           color: Colors.black,
//                           size: 20,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context); // Close dialog
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFFED7902),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                   ),
//                   child: Row(
//                     children: [
//                       Text(
//                         'Mark Attendance',
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.normal,
//                           fontSize: 14,
//                           color: Colors.white,
//                         ),
//                       ),
//                       SizedBox(width: 8), // Spacing between text and icon
//                       Container(
//                         padding: EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                           color: Color(0xFFED7902),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           Icons.check_circle,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
