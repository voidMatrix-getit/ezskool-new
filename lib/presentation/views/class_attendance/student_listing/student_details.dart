import 'dart:convert';

import 'package:ezskool/core/services/logger.dart';
import 'package:ezskool/data/viewmodels/class_attendance/student_listing_viewmodel.dart';
import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../drawers/parent_contact_bottom_drawer.dart';

class StudentProfileScreen extends StatelessWidget {
  final Map<String, dynamic> studentData;
  final String className;

  const StudentProfileScreen(
      {super.key, required this.studentData, required this.className});

  @override
  Widget build(BuildContext context) {
    final stvm = Provider.of<StudentViewModel>(context);
    final List<dynamic> pgData = [];
    try {
      if (studentData['data']['pg_link'] != null) {
        final String pgLinkStr = studentData['data']['pg_link'];
        pgData.addAll(json.decode(pgLinkStr));
      }
    } catch (e) {
      Log.d('Error parsing pg_link: $e');
    }
    List<String> values = [];
    if (studentData['data']['hw'] != null) {
      values = studentData['data']['hw'].split(',');
    }

    // Parse siblings data
    final List<dynamic> siblings = studentData['data']['siblings'] ?? [];

    return BaseScreen(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              // Header Section
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back),
                  ),
                  SizedBox(width: 8.w),
                  CircleAvatar(
                    radius: 32.r,
                    backgroundColor: Colors.white,
                    //backgroundImage:
                    child: Image.asset(
                      studentData['data']['gender'] == 1
                          ? 'assets/bb.png'
                          : 'assets/g.png',
                      color: studentData['data']['gender'] == 1
                          ? Colors.blue
                          : Colors.pink,
                      width: 48.w,
                      height: 48.h,
                    ),
                  ),

                  //AssetImage(),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        studentData['data']['name'] ?? 'N/A',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(children: [
                        Text(
                          className,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Image.asset(
                          'assets/id.png',
                          width: 21.w,
                          height: 15.h,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "${studentData['data']['roll_no']}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[800],
                          ),
                        ),
                      ])
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              Expanded(
                  child: ListView(
                children: [
                  // Main Content
                  _buildInfoCard([
                    _buildRowContent(
                        "GR Number", studentData['data']['gr_no'] ?? 'N/A'),
                    _buildRowContent(
                        "Unique ID", studentData['data']['uid_no'] ?? 'N/A'),
                    _buildRowContent(
                        "PEN Number", studentData['data']['pen_no'] ?? 'N/A'),
                    _buildRowContent(
                        "APAAR ID", studentData['data']['apaar_id'] ?? 'N/A'),
                    _buildRowContent("Aadhaar Number",
                        studentData['data']['adhar_no'] ?? 'N/A'),
                  ]),
                  SizedBox(height: 5.h),

                  _buildInfoCard([
                    _buildRow([
                      _buildColumn(
                          "Gender",
                          studentData['data']['gender'] == 1
                              ? 'Male'
                              : 'Female'),
                      Spacer(),
                      _buildColumn(
                          "Blood Group", studentData['data']['bg'] ?? 'N/A'),
                    ]),
                    _buildRow([
                      _buildColumn("Date of Birth", studentData['data']['dob']),
                      Spacer(),
                      _buildColumn("Date of Joining",
                          studentData['data']['doj'] ?? 'N/A'),
                    ]),
                  ]),
                  SizedBox(height: 5.h),

                  _buildInfoCard([
                    _buildRow([
                      SizedBox(width: 15.w),
                      _buildColumn(
                          "Caste", studentData['data']['caste'] ?? 'N/A'),
                      _buildColumn(
                          "Religion", studentData['data']['religion'] ?? 'N/A'),
                      _buildColumn(
                          "Category",
                          studentData['data']['category_id'].toString() ??
                              'N/A'),
                    ])
                  ]),

                  SizedBox(height: 5.h),

                  _buildSectionHeader('Height & Weight Records'),
                  _buildInfoCard(values.isEmpty
                      ? [
                          _buildRow([
                            Spacer(),
                            _buildRowContent1("N/A"),
                            Spacer(),
                          ])
                        ]
                      : [
                          _buildRowContent("Height", '${values[0]} cm.'),
                          _buildRowContent("Weight", '${values[1]} kg.')
                          // SizedBox(width: 30),
                        ]),

                  SizedBox(height: 5.h),
                  _buildSectionHeader('Parent/Guardian Details'),
                  _buildInfoCard(
                    pgData.isEmpty
                        ? [
                            _buildRow([
                              Spacer(),
                              _buildRowContent1("N/A"),
                              Spacer(),
                            ])
                          ]
                        : pgData
                            .map((pg) => _buildRow([
                                  _buildRowContent(
                                      "${pg['rel'] == 1 ? 'Father' : pg['rel'] == 2 ? 'Mother' : 'Guardian'}  -  ",
                                      pg['name'] ?? 'N/A'),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Log.d(pgData);
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20.r)),
                                        ),
                                        context: context,
                                        builder: (context) {
                                          return ParentContactBottomSheet(
                                            parents: pgData
                                                .cast<Map<String, dynamic>>(),
                                            name: studentData['data']['name'],
                                            rollNo: studentData['data']
                                                    ['roll_no']
                                                .toString(),
                                            gender: studentData['data']
                                                ['gender'],
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(Icons.link),
                                  )
                                ]))
                            .toList(),
                  ),

                  // SizedBox(height: 5),
                  // _buildSectionHeader('Parent/Guardian Details'),
                  // _buildInfoCard([
                  //   _buildRow([
                  //     _buildRowContent("Father  -  ", "Chirag Karia"),
                  //     Spacer(),
                  //     GestureDetector(
                  //       onTap: () {},
                  //       child: Icon(Icons.link),
                  //     )
                  //   ]),
                  //   _buildRow([
                  //     _buildRowContent("Mother  -  ", "Pallavi Karia"),
                  //     Spacer(),
                  //     GestureDetector(
                  //       onTap: () {},
                  //       child: Icon(Icons.link),
                  //     )
                  //   ]),
                  //   _buildRow([
                  //     _buildRowContent("Guardian  -  ", "Chirag Karia"),
                  //     Spacer(),
                  //     GestureDetector(
                  //       onTap: () {},
                  //       child: Icon(Icons.link),
                  //     )
                  //   ]),
                  // ]),

                  SizedBox(height: 5.h),
                  _buildSectionHeader('Siblings'),
                  _buildInfoCard(
                    siblings.isEmpty
                        ? [
                            _buildRow([
                              Spacer(),
                              _buildRowContent1("N/A"),
                              Spacer(),
                            ])
                          ]
                        : siblings
                            .map((sibling) => _buildRow([
                                  Image.asset(
                                    sibling['gender'] == 1
                                        ? 'assets/bb.png'
                                        : 'assets/g.png',
                                    width: 13.w,
                                    height: 16.h,
                                    alignment: Alignment.center,
                                    color: sibling['gender'] == 1
                                        ? Colors.blue
                                        : Colors.pink,
                                  ),
                                  // Icon(
                                  //   sibling['gender'] == 1
                                  //       ? Icons.male
                                  //       : Icons.female,
                                  //   color: sibling['gender'] == 1
                                  //       ? Colors.blue
                                  //       : Colors.pink,
                                  // ),
                                  _buildRowContent1(sibling['name'] ?? 'N/A'),
                                  Spacer(),
                                  _buildRowContent1(
                                      "${sibling['class_name'].replaceAll('-', ' ')} - ${sibling['siblings_roll_no']}")
                                ]))
                            .toList(),
                  ),

                  // SizedBox(height: 5),
                  // _buildSectionHeader('Siblings'),
                  // _buildInfoCard([
                  //   _buildRow([
                  //     Icon(
                  //       Icons.male,
                  //       color: Colors.blue,
                  //     ),
                  //     _buildRowContent1("Rohit Sunil Sharma"),
                  //     Spacer(),
                  //     _buildRowContent1("6A - 14")
                  //   ]),
                  //   _buildRow([
                  //     Icon(
                  //       Icons.female,
                  //       color: Colors.pink,
                  //     ),
                  //     _buildRowContent1("Priya Sunil Sharma"),
                  //     Spacer(),
                  //     _buildRowContent1("5B - 42"),
                  //   ]),
                  // ]),

                  SizedBox(height: 5.h),
                  _buildSectionHeader('Special Remarks'),
                  _buildInfoCard([
                    studentData['data']['sp_remark'].toString().isEmpty ||
                            studentData['data']['sp_remark'] == null
                        ? _buildRow([
                            Spacer(),
                            _buildRowContent1("N/A"),
                            Spacer(),
                          ])
                        : _buildRemarkContent(studentData['data']['sp_remark']),
                  ]),

                  SizedBox(height: 20.h), // Bottom padding
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
          height: 1.5.h,
          color: Color(0xFF494949),
        ),
      ),
    );
  }

  // New method specifically for remarks
  Widget _buildRemarkContent(String remark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Text(
        remark,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }

  // Your existing helper methods remain the same
  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      margin: EdgeInsets.all(6.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }

  Widget _buildRowContent1(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowContent(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:ezskool/presentation/views/base_screen.dart';
// import 'package:flutter/material.dart';
//
// class StudentProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BaseScreen(
//       child: SingleChildScrollView(
//         child: ConstrainedBox(
//           constraints:
//               BoxConstraints(minHeight: MediaQuery.of(context).size.height),
//           child: IntrinsicHeight(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 20),
//                   // Header Section
//                   Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: Icon(Icons.arrow_back),
//                       ),
//                       SizedBox(
//                         width: 8,
//                       ),
//                       CircleAvatar(
//                         radius: 24,
//                         backgroundImage: AssetImage(
//                             'assets/Frame.png'), // Replace with your image path
//                       ),
//                       SizedBox(width: 16),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Priya Sumit Sharma",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             "5 A - 12",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[800],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//
//                   _buildInfoCard([
//                     _buildRowContent("GR Number", "SC0001"),
//                     _buildRowContent("Unique ID", "UID12345"),
//                     _buildRowContent("PEN Number", "PZ456S8214"),
//                     _buildRowContent("APAAR ID", "1234 2345 6124"),
//                     _buildRowContent("Aadhaar Number", "7389 3221 8632"),
//                   ]),
//                   SizedBox(height: 5),
//
//                   // Another Card with Custom Layout
//                   _buildInfoCard([
//                     // Single Row
//                     _buildRow([
//                       _buildColumn("Gender", "Male"),
//                       Spacer(),
//                       _buildColumn("Blood Group", "O+"),
//                     ]),
//                     // Row with 2 Columns (Date Info)
//                     _buildRow([
//                       _buildColumn("Date of Birth", "26-04-2006"),
//                       Spacer(),
//                       _buildColumn("Date of Joining", "15-05-2012"),
//                     ]),
//                   ]),
//                   SizedBox(height: 5),
//
//                   // Another Card (Column Inside Row)
//                   _buildInfoCard([
//                     _buildRow([
//                       SizedBox(
//                         width: 15,
//                       ),
//                       _buildColumn("Caste", "Maratha"),
//                       _buildColumn("Religion", "Hindu"),
//                       _buildColumn("Category", "General"),
//                     ])
//                   ]),
//
//                   SizedBox(height: 5),
//
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     child: Text(
//                       'Height & Weight Records', // The text to display
//                       style: TextStyle(
//                         fontStyle: FontStyle.normal,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14,
//                         height: 1.5,
//                         // 21px line-height ÷ 14px font size
//                         color: Color(0xFF494949),
//                       ),
//                     ),
//                   ),
//                   _buildInfoCard([
//                     _buildRow([
//                       _buildColumn("Date", "28-03-2021"),
//                       SizedBox(
//                         width: 30,
//                       ),
//                       _buildColumn("Height", "138.4 cm"),
//                       SizedBox(
//                         width: 30,
//                       ),
//                       _buildColumn("Weight", "28 kg"),
//                     ])
//                   ]),
//
//                   SizedBox(height: 5),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     child: Text(
//                       'Parent/Guardian Details', // The text to display
//                       style: TextStyle(
//                         fontStyle: FontStyle.normal,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14,
//                         height: 1.5,
//                         // 21px line-height ÷ 14px font size
//                         color: Color(0xFF494949),
//                       ),
//                     ),
//                   ),
//                   _buildInfoCard([
//                     _buildRowContent("Father", "Chirag Karia"),
//                     _buildRowContent("Mother", "Pallavi Karia"),
//                     _buildRowContent("Guardian", "Chirag Karia"),
//                   ]),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     child: Text(
//                       'Siblings', // The text to display
//                       style: TextStyle(
//                         fontStyle: FontStyle.normal,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14,
//                         height: 1.5,
//                         // 21px line-height ÷ 14px font size
//                         color: Color(0xFF494949),
//                       ),
//                     ),
//                   ),
//                   _buildInfoCard([
//                     _buildRowContent("Rohit Sunil Sharma", "6A - 14"),
//                     _buildRowContent("Priya Sunil Sharma", "5B - 42"),
//                   ]),
//
//                   SizedBox(height: 5),
//
//                   _buildInfoCard([
//                     _buildColumn("Special Remark", "Highly disciplined and punctual."),
//                   ]),
//
//                   // // Special Remark Section
//
//                   //
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Flexible Card
//   Widget _buildInfoCard(List<Widget> children) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       margin: const EdgeInsets.all(6),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(5),
//         color: Colors.white,
//         border: Border.all(color: Colors.grey.shade300),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: children,
//       ),
//     );
//   }
//
//   // Flexible Row Builder
//   Widget _buildRow(List<Widget> children) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: children,
//       ),
//     );
//   }
//
//   Widget _buildRowContent(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey[700],
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//               color: Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Flexible Column Builder
//   Widget _buildColumn(String label, String value) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey[700],
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//               color: Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
