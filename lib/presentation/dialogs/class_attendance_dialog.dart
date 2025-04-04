import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ezskool/core/services/logger.dart';
import 'package:ezskool/data/repo/student_repo.dart';
import 'package:ezskool/data/viewmodels/class_attendance/class_attendance_viewmodel.dart';
import 'package:ezskool/presentation/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/repo/class_student_repo.dart';
import '../../data/repo/home_repo.dart';
import '../../main.dart';
import '../drawers/parent_contact_bottom_drawer.dart';

final studRepo = StudentRepository();

//Drawers

// Example of how to show the bottom drawer
void showMarkAbsentBottomDrawer(
    BuildContext context, int rollNo, String name, int gender) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (context) => MarkAbsentBottomDrawer(
      rollNo: rollNo,
      name: name,
      gender: gender,
    ),
  );
}

class MarkAbsentBottomDrawer extends StatefulWidget {
  final int rollNo;
  final String name;
  final int gender;

  const MarkAbsentBottomDrawer({
    super.key,
    required this.rollNo,
    required this.name,
    required this.gender,
  });

  @override
  _MarkAbsentBottomDrawerState createState() => _MarkAbsentBottomDrawerState();
}

class _MarkAbsentBottomDrawerState extends State<MarkAbsentBottomDrawer> {
  String selectedReason = '';
  bool showOtherTextField = false;
  final TextEditingController otherReasonController = TextEditingController();
  late final ClassAttendanceViewModel clvmdl;
  List<DropdownMenuItem<String>> _dropdownItems = [];

  late List<Map<String, dynamic>> parents = [];

  bool show = false;
  bool noParents = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    clvmdl =
        Provider.of<ClassAttendanceViewModel>(navigatorKey.currentContext!);
    _loadDropdownValues();
  }

  Future<void> _loadDropdownValues() async {
    try {
      final lr = await HomeRepo.dropdownDao.getDropdownValues('lr');
      setState(() {
        _dropdownItems = [
          DropdownMenuItem<String>(
            value: 'None',
            child: Text("Select Reason"),
          ),
          ...lr.map((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }),
        ];
      });
    } catch (e) {
      print('Error fetching dropdown values: $e');
    }
  }

  String getRelationLabel(int relation) {
    switch (relation) {
      case 1:
        return "Father";
      case 2:
        return "Mother";
      case 3:
        return "Guardian";
      default:
        return "N/A";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Student Info Card

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  //width: 284.w,
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: Color(0xFFFAECEC),
                    border: Border.all(color: Color(0xFFDD3E2B), width: 0.4),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Row(
                    children: [
                      // Student details section
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 16.w),
                        child: Row(
                          children: [
                            // Student image
                            Container(
                              width: 36.w,
                              height: 49.h,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    widget.gender == 1
                                        ? 'assets/bb.png'
                                        : 'assets/g.png',
                                  ),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    widget.gender == 1
                                        ? Colors.blue
                                        : Colors.pink,
                                    BlendMode.srcATop,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            // Student name and roll number
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.sp,
                                    color: Color(0xE6222222),
                                  ),
                                ),
                                Text(
                                  "Roll No | ${widget.rollNo}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                    color: Color(0xE6222222),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 5.w),
              // Call button
              Container(
                width: 60.w,
                height: 79.h,
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: show ? Colors.black : Color(0xFF029A67),
                  borderRadius: BorderRadius.circular(4.r),

                  // BorderRadius.only(
                  //   topRight: Radius.circular(4.r),
                  //   bottomRight: Radius.circular(4.r),
                  // ),
                ),
                child: IconButton(
                  icon: Icon(show ? Icons.cancel_outlined : Icons.call,
                      color: Colors.white, size: 24.r),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (show) {
                      setState(() {
                        show = false;
                      });
                    } else {
                      final List<Map<String, dynamic>> apiData = await studRepo
                          .fetchParents(clvmdl.getStudent.studentId.toString());

                      setState(() {
                        parents = apiData;

                        show = true;
                      });
                    }

                    setState(() {
                      isLoading = false;
                    });

                    // Navigator.pop(context); // Close current bottom sheet

                    // showModalBottomSheet(
                    //   isScrollControlled: true,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius:
                    //         BorderRadius.vertical(top: Radius.circular(20.r)),
                    //   ),
                    //   context: context,
                    //   builder: (context) {
                    //     return ParentContactBottomSheet(
                    //       parents: apiData,
                    //       name: widget.name,
                    //       rollNo: widget.rollNo.toString(),
                    //       gender: widget.gender,
                    //     );
                    //   },
                    // );
                  },
                ),
              ),
            ],
          ),

          // Mark Absent Text
          Center(
            child: Text(
              "Mark Absent?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: Color(0xFFDD3E2B),
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // DropdownButtonFormField<String>(
          //   // value: selectedReason,
          //   value: _dropdownItems
          //           .any((item) => item.value == clvmdl.getStudent.leaveReason)
          //       ? clvmdl.getStudent.leaveReason
          //       : null,
          //   hint: Text('Select'),
          //   items: _dropdownItems,
          //   onChanged: (value) {
          //     setState(() {
          //       selectedReason = value!;
          //       showOtherTextField = value == 'Others';
          //       Log.d(selectedReason);
          //       Log.d(showOtherTextField);
          //     });
          //   },
          //   decoration: InputDecoration(
          //     constraints: BoxConstraints(
          //       // minHeight: 50.h, // Minimum height
          //       maxHeight: 33.h, // Maximum height
          //       // minWidth: 200.w, // Minimum width
          //       maxWidth: 309.w, // Maximum width
          //     ),
          //     contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(5.r),
          //       borderSide: BorderSide(
          //         color: Color(0xFFA29595),
          //         width: 0.5.w,
          //       ),
          //     ),
          //     suffixIcon: Icon(CupertinoIcons.chevron_down),
          //   ),
          //   icon: Container(),
          // ),
          DropdownButtonFormField2<String>(
            value: _dropdownItems
                    .any((item) => item.value == clvmdl.getStudent.leaveReason)
                ? clvmdl.getStudent.leaveReason
                : null,
            isExpanded: true,
            iconStyleData: IconStyleData(iconSize: 0),
            decoration: InputDecoration(
              constraints: BoxConstraints(
                maxHeight: 40.h, // Keeping the same height
                maxWidth: 309.w, // Keeping the same width
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  color: Color(0xFFA29595),
                  width: 0.5.w,
                ),
              ),
              suffixIcon: Icon(CupertinoIcons.chevron_down),
            ),
            dropdownStyleData: DropdownStyleData(offset: Offset(0, 262.h)
                //maxHeight: 200.h, // Limit dropdown height
                // Forces dropdown menu to appear above
                ),
            hint: Text('Select Reason'),
            items: _dropdownItems,
            onChanged: (value) {
              setState(() {
                selectedReason = value!;
                showOtherTextField = value == 'Others';
                Log.d(selectedReason);
                Log.d(showOtherTextField);
              });
            },
          ),

          SizedBox(height: showOtherTextField ? 8.h : 0.h),

          if (showOtherTextField)
            SizedBox(
              width: 309.w, // Setting width to 309
              child: TextField(
                controller: otherReasonController,
                decoration: InputDecoration(
                  labelText: "Reason",
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFF626262),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.r),
                    borderSide: BorderSide(
                      color: Color(0xFFA29595),
                      width: 0.5.w,
                    ),
                  ),
                ),
              ),
            ),

          // Dropdown
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 8.w),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     border: Border.all(color: Color(0xFF969AB8), width: 0.5),
          //     borderRadius: BorderRadius.circular(5.r),
          //   ),
          //   child: DropdownButtonHideUnderline(
          //     child: DropdownButton<String>(
          //       value: _dropdownItems.any(
          //               (item) => item.value == clvmdl.getStudent.leaveReason)
          //           ? clvmdl.getStudent.leaveReason
          //           : 'None',
          //       isExpanded: true,
          //       icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF969AB8)),
          //       items: _dropdownItems,
          //       onChanged: (value) {
          //         setState(() {
          //           selectedReason = value!;
          //           showOtherTextField = value == 'Others';
          //           Log.d(selectedReason);
          //           Log.d(showOtherTextField);
          //         });
          //       },
          //       style: TextStyle(
          //         fontWeight: FontWeight.w400,
          //         fontSize: 14.sp,
          //         color: Color(0xFF969AB8),
          //       ),
          //     ),
          //   ),
          // ),

          // "Other" reason text field (conditional)
          // if (showOtherTextField)
          //   Container(
          //     margin: EdgeInsets.only(top: 12.h),
          //     child: TextField(
          //       controller: otherReasonController,
          //       decoration: InputDecoration(
          //         labelText: "Reason",
          //         labelStyle: TextStyle(
          //           fontSize: 14.sp,
          //           color: Color(0xFF626262),
          //         ),
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(5.r),
          //           borderSide: BorderSide(
          //             color: Color(0xFFA29595),
          //             width: 0.5.w,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),

          // SizedBox(height: 20.h),

          if (show) ...[
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: Color(0xFFED7902),
                  ))
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                        //mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20.h),
                          Text(
                            'Parent Contact Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: Color(0xFF1E1E1E),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            height: 2.h,
                            width: 250.w,
                            decoration: BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                //mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: parents.any((parent) =>
                                        parent['contact_no'] != null)
                                    ? parents
                                        .where((parent) =>
                                            parent['contact_no'] !=
                                            null) // Filtering non-null contacts
                                        .map((parent) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.w, vertical: 8.h),
                                          child: ContactInfoSection(
                                            label:
                                                '${parent.containsKey('name') ? parent['name'] : (parent.containsKey('parent_name') ? parent['parent_name'] : 'N/A')} (${getRelationLabel(parent.containsKey('relation') ? (parent['relation'].toString().length == 1 ? parent['relation'] : -1) : (parent.containsKey('rel') ? (parent['rel'].toString().length == 1 ? parent['rel'] : -1) : -1))})',
                                            phoneNumber:
                                                parent['contact_no'].toString(),
                                          ),
                                        );
                                      }).toList()
                                    : [
                                        Padding(
                                          padding: EdgeInsets.all(16
                                              .h), // Spacing for better appearance
                                          child: Text(
                                            "No contacts available",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ],
                              ),
                            ],
                          ),
                        ]),
                  ),
          ],

          SizedBox(
            height: 15.h,
          ),

          Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      // No button
                      Expanded(
                        child: Container(
                          height: 47.h,
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F5F7),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "No",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: Color(0xFF494949),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Yes button
                      Expanded(
                        child: Container(
                          height: 47.h,
                          decoration: BoxDecoration(
                            color: Color(0xFFD43F2D),
                            borderRadius: BorderRadius.circular(5.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 1.3,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () async {
                              HapticFeedback.lightImpact();
                              startShowing(context);
                              final student = clvmdl.getStudent;
                              await ClassStudentRepo.storeStudent({
                                'student_id': student.studentId,
                                'class_id': student.classId,
                                'name': student.name,
                                'roll_no': student.rollNo,
                                'gender': student.gender,
                                'att_status': selectedReason.isNotEmpty ? 3 : 2,
                                'leave_reason':
                                    otherReasonController.text.isNotEmpty
                                        ? otherReasonController.text
                                        : selectedReason
                              });
                              await clvmdl.syncDatabase();
                              clvmdl.toggleAttendance(widget.rollNo);
                              stopShowing(context);
                              Navigator.of(context).pop();

                              // if (selectedReason == 'None' || selectedReason == '') {
                              //   stopShowing(context);
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //       content: Text('Please select a reason'),
                              //       duration: Duration(seconds: 2),
                              //       backgroundColor: Colors.red,
                              //     ),
                              //   );

                              // } else {
                              //   final student = clvmdl.getStudent;
                              //   await ClassStudentRepo.storeStudent({
                              //     'student_id': student.studentId,
                              //     'class_id': student.classId,
                              //     'name': student.name,
                              //     'roll_no': student.rollNo,
                              //     'gender': student.gender,
                              //     'att_status':
                              //         selectedReason.isNotEmpty ? 3 : 2,
                              //     'leave_reason':
                              //         otherReasonController.text.isNotEmpty
                              //             ? otherReasonController.text
                              //             : selectedReason
                              //   });
                              //   await clvmdl.syncDatabase();
                              //   clvmdl.toggleAttendance(widget.rollNo);
                              //   stopShowing(context);
                              //   Navigator.of(context).pop();
                              // }
                            },
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),

          // Action Buttons
        ],
      ),
    );
  }
}

void showMarkPresentBottomDrawer(
    BuildContext context, int rollNo, String name, int gender, String reason) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (context) => MarkPresentBottomDrawer(
      rollNo: rollNo,
      name: name,
      gender: gender,
      reason: reason,
    ),
  );
}

class MarkPresentBottomDrawer extends StatefulWidget {
  final int rollNo;
  final String name;
  final int gender;
  final String reason;

  const MarkPresentBottomDrawer({
    super.key,
    required this.rollNo,
    required this.name,
    required this.gender,
    required this.reason,
  });

  @override
  _MarkPresentBottomDrawerState createState() =>
      _MarkPresentBottomDrawerState();
}

class _MarkPresentBottomDrawerState extends State<MarkPresentBottomDrawer> {
  // final clvmdl =
  //     Provider.of<ClassAttendanceViewModel>(navigatorKey.currentContext!);

  String selectedReason = '';
  bool showOtherTextField = false;
  final TextEditingController otherReasonController = TextEditingController();
  late final ClassAttendanceViewModel clvmdl;
  List<DropdownMenuItem<String>> _dropdownItems = [];

  late List<Map<String, dynamic>> parents = [];

  bool show = false;
  bool noParents = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    clvmdl =
        Provider.of<ClassAttendanceViewModel>(navigatorKey.currentContext!);
    _loadDropdownValues();
  }

  // Future<void> _loadDropdownValues() async {
  //   try {
  //     final lr = await HomeRepo.dropdownDao.getDropdownValues('lr');
  //     setState(() {
  //       _dropdownItems = [
  //         DropdownMenuItem<String>(
  //           value: 'None',
  //           child: Text("Select Reason"),
  //         ),
  //         ...lr.map((value) {
  //           return DropdownMenuItem<String>(
  //             value: value,
  //             child: Text(value),
  //           );
  //         }),
  //       ];
  //     });
  //   } catch (e) {
  //     print('Error fetching dropdown values: $e');
  //   }
  // }
  Future<void> _loadDropdownValues() async {
    try {
      final lr = await HomeRepo.dropdownDao.getDropdownValues('lr');
      setState(() {
        _dropdownItems = lr.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList();
      });

      Log.d('in load: $_dropdownItems');
      Log.d(widget.reason);
      Log.d(_dropdownItems);
      _dropdownItems.any((item) => item.value == widget.reason)
          ? setState(() {
              showOtherTextField = widget.reason == 'Others' ? true : false;
            })
          : setState(() {
              showOtherTextField = widget.reason.isNotEmpty ? true : false;
              otherReasonController.text = widget.reason;
            });

      Log.d('showOtherTextField: $showOtherTextField');
    } catch (e) {
      // Handle errors if necessary
      print('Error fetching dropdown values: $e');
    }
  }

  String getRelationLabel(int relation) {
    switch (relation) {
      case 1:
        return "Father";
      case 2:
        return "Mother";
      case 3:
        return "Guardian";
      default:
        return "N/A";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Student Info Card

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  //width: 284.w,
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: Color(0xFFFAECEC),
                    border: Border.all(color: Color(0xFFDD3E2B), width: 0.4),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Row(
                    children: [
                      // Student details section
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 16.w),
                        child: Row(
                          children: [
                            // Student image
                            Container(
                              width: 36.w,
                              height: 49.h,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    widget.gender == 1
                                        ? 'assets/bb.png'
                                        : 'assets/g.png',
                                  ),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    widget.gender == 1
                                        ? Colors.blue
                                        : Colors.pink,
                                    BlendMode.srcATop,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            // Student name and roll number
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.sp,
                                    color: Color(0xE6222222),
                                  ),
                                ),
                                Text(
                                  "Roll No | ${widget.rollNo}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                    color: Color(0xE6222222),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 5.w),
              // Call button
              Container(
                width: 60.w,
                height: 79.h,
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: show ? Colors.black : Color(0xFF029A67),
                  borderRadius: BorderRadius.circular(4.r),

                  // BorderRadius.only(
                  //   topRight: Radius.circular(4.r),
                  //   bottomRight: Radius.circular(4.r),
                  // ),
                ),
                child: IconButton(
                  icon: Icon(show ? Icons.cancel_outlined : Icons.call,
                      color: Colors.white, size: 24.r),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (show) {
                      setState(() {
                        show = false;
                      });
                    } else {
                      final List<Map<String, dynamic>> apiData = await studRepo
                          .fetchParents(clvmdl.getStudent.studentId.toString());

                      setState(() {
                        parents = apiData;

                        show = true;
                      });
                    }

                    setState(() {
                      isLoading = false;
                    });

                    // Navigator.pop(context); // Close current bottom sheet

                    // showModalBottomSheet(
                    //   isScrollControlled: true,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius:
                    //         BorderRadius.vertical(top: Radius.circular(20.r)),
                    //   ),
                    //   context: context,
                    //   builder: (context) {
                    //     return ParentContactBottomSheet(
                    //       parents: apiData,
                    //       name: widget.name,
                    //       rollNo: widget.rollNo.toString(),
                    //       gender: widget.gender,
                    //     );
                    //   },
                    // );
                  },
                ),
              ),
            ],
          ),

          Center(
            child: Text(
              "Edit Reason",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16.sp,
                color: Color(0xFF626262),
              ),
            ),
          ),

          SizedBox(height: 8.h),

          // DropdownButtonFormField<String>(
          //   // value: selectedReason,
          //   value: _dropdownItems
          //           .any((item) => item.value == clvmdl.getStudent.leaveReason)
          //       ? clvmdl.getStudent.leaveReason
          //       : null,
          //   hint: Text('Select'),
          //   items: _dropdownItems,
          //   onChanged: (value) {
          //     setState(() {
          //       selectedReason = value!;
          //       showOtherTextField = value == 'Others';
          //       Log.d(selectedReason);
          //       Log.d(showOtherTextField);
          //     });
          //   },
          //   decoration: InputDecoration(
          //     constraints: BoxConstraints(
          //       // minHeight: 50.h, // Minimum height
          //       maxHeight: 33.h, // Maximum height
          //       // minWidth: 200.w, // Minimum width
          //       maxWidth: 309.w, // Maximum width
          //     ),
          //     contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(5.r),
          //       borderSide: BorderSide(
          //         color: Color(0xFFA29595),
          //         width: 0.5.w,
          //       ),
          //     ),
          //     suffixIcon: Icon(CupertinoIcons.chevron_down),
          //   ),
          //   icon: Container(),
          // ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButtonFormField2<String>(
                value: _dropdownItems.any(
                        (item) => item.value == clvmdl.getStudent.leaveReason)
                    ? clvmdl.getStudent.leaveReason
                    : showOtherTextField
                        ? 'Others'
                        : null,
                // clvmdl.getStudent.leaveReason != null
                //     ? "Select Reason"
                //     : null,
                isExpanded: true,
                iconStyleData: IconStyleData(iconSize: 0),
                decoration: InputDecoration(
                  constraints: BoxConstraints(
                    maxHeight: 40.h, // Keeping the same height
                    maxWidth: 281.w, // Keeping the same width
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.r),
                    borderSide: BorderSide(
                      color: Color(0xFFA29595),
                      width: 0.5.w,
                    ),
                  ),
                  suffixIcon: Icon(CupertinoIcons.chevron_down),
                ),
                dropdownStyleData: DropdownStyleData(offset: Offset(0, 212.h)
                    //maxHeight: 200.h, // Limit dropdown height
                    // Forces dropdown menu to appear above
                    ),
                hint: Text('Select Reason'),
                items: _dropdownItems,
                onChanged: (value) {
                  setState(() {
                    selectedReason = value!;
                    showOtherTextField = value == 'Others';
                    Log.d(selectedReason);
                    Log.d(showOtherTextField);
                  });
                },
              ),
              GestureDetector(
                onTap: () async {
                  HapticFeedback.mediumImpact();
                  final student = clvmdl.getStudent;
                  await ClassStudentRepo.storeStudent({
                    'student_id': student.studentId,
                    'class_id': student.classId,
                    'name': student.name,
                    'roll_no': student.rollNo,
                    'gender': student.gender,
                    'att_status': selectedReason.isNotEmpty ? 3 : 2,
                    'leave_reason': otherReasonController.text.isNotEmpty
                        ? otherReasonController.text
                        : selectedReason
                  });
                  clvmdl.syncDatabase();
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 59.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFED7902),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: showOtherTextField ? 8.h : 0.h),

          if (showOtherTextField)
            SizedBox(
              width: 350.w, // Setting width to 309
              child: TextField(
                controller: otherReasonController,
                decoration: InputDecoration(
                  labelText: "Reason",
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFF626262),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.r),
                    borderSide: BorderSide(
                      color: Color(0xFFA29595),
                      width: 0.5.w,
                    ),
                  ),
                ),
              ),
            ),

          // Dropdown
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 8.w),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     border: Border.all(color: Color(0xFF969AB8), width: 0.5),
          //     borderRadius: BorderRadius.circular(5.r),
          //   ),
          //   child: DropdownButtonHideUnderline(
          //     child: DropdownButton<String>(
          //       value: _dropdownItems.any(
          //               (item) => item.value == clvmdl.getStudent.leaveReason)
          //           ? clvmdl.getStudent.leaveReason
          //           : 'None',
          //       isExpanded: true,
          //       icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF969AB8)),
          //       items: _dropdownItems,
          //       onChanged: (value) {
          //         setState(() {
          //           selectedReason = value!;
          //           showOtherTextField = value == 'Others';
          //           Log.d(selectedReason);
          //           Log.d(showOtherTextField);
          //         });
          //       },
          //       style: TextStyle(
          //         fontWeight: FontWeight.w400,
          //         fontSize: 14.sp,
          //         color: Color(0xFF969AB8),
          //       ),
          //     ),
          //   ),
          // ),

          // "Other" reason text field (conditional)
          // if (showOtherTextField)
          //   Container(
          //     margin: EdgeInsets.only(top: 12.h),
          //     child: TextField(
          //       controller: otherReasonController,
          //       decoration: InputDecoration(
          //         labelText: "Reason",
          //         labelStyle: TextStyle(
          //           fontSize: 14.sp,
          //           color: Color(0xFF626262),
          //         ),
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(5.r),
          //           borderSide: BorderSide(
          //             color: Color(0xFFA29595),
          //             width: 0.5.w,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),

          // SizedBox(height: 20.h),

          if (show) ...[
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: Color(0xFFED7902),
                  ))
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                        //mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20.h),
                          Text(
                            'Parent Contact Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: Color(0xFF1E1E1E),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            height: 2.h,
                            width: 250.w,
                            decoration: BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                //mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: parents.any((parent) =>
                                        parent['contact_no'] != null)
                                    ? parents
                                        .where((parent) =>
                                            parent['contact_no'] !=
                                            null) // Filtering non-null contacts
                                        .map((parent) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.w, vertical: 8.h),
                                          child: ContactInfoSection(
                                            label:
                                                '${parent.containsKey('name') ? parent['name'] : (parent.containsKey('parent_name') ? parent['parent_name'] : 'N/A')} (${getRelationLabel(parent.containsKey('relation') ? (parent['relation'].toString().length == 1 ? parent['relation'] : -1) : (parent.containsKey('rel') ? (parent['rel'].toString().length == 1 ? parent['rel'] : -1) : -1))})',
                                            phoneNumber:
                                                parent['contact_no'].toString(),
                                          ),
                                        );
                                      }).toList()
                                    : [
                                        Padding(
                                          padding: EdgeInsets.all(16
                                              .h), // Spacing for better appearance
                                          child: Text(
                                            "No contacts available",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ],
                              ),
                            ],
                          ),
                        ]),
                  ),
          ],

          SizedBox(
            height: 15.h,
          ),

          Center(
            child: Text(
              "Mark Present?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: Color(0xFF029A67),
              ),
            ),
          ),

          SizedBox(
            height: 15.h,
          ),

          Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      // No button
                      Expanded(
                        child: Container(
                          height: 47.h,
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F5F7),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "No",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: Color(0xFF494949),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Yes button
                      Expanded(
                        child: Container(
                          height: 47.h,
                          decoration: BoxDecoration(
                            color: Color(0xFF029A67),
                            borderRadius: BorderRadius.circular(5.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 1.3,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () async {
                              HapticFeedback.lightImpact();

                              final student = clvmdl.getStudent;
                              await ClassStudentRepo.storeStudent({
                                'student_id': student.studentId,
                                'class_id': student.classId,
                                'name': student.name,
                                'roll_no': student.rollNo,
                                'gender': student.gender,
                                'att_status': 1,
                                'leave_reason': null
                              });
                              clvmdl.syncDatabase();
                              clvmdl.toggleAttendance(widget.rollNo);
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),

          // Action Buttons
        ],
      ),
    );
  }
}

//Dialogs
class MarkAbsentDialog extends StatefulWidget {
  int rollNO;
  String name;
  int gender;

  MarkAbsentDialog({
    super.key,
    required this.rollNO,
    required this.name,
    required this.gender,
  });

  @override
  _MarkAbsentDialogState createState() => _MarkAbsentDialogState();
}

class _MarkAbsentDialogState extends State<MarkAbsentDialog> {
  String selectedReason = '';
  bool showOtherTextField = false;
  final TextEditingController otherReasonController = TextEditingController();
  final clvmdl =
      Provider.of<ClassAttendanceViewModel>(navigatorKey.currentContext!);
  List<DropdownMenuItem<String>> _dropdownItems = [];

  @override
  void initState() {
    super.initState();
    _loadDropdownValues();
  }

  Future<void> _loadDropdownValues() async {
    try {
      final lr = await HomeRepo.dropdownDao.getDropdownValues('lr');
      setState(() {
        _dropdownItems = [
          DropdownMenuItem<String>(
            value: 'None', // This represents the "None" option (empty value)
            child: Text("Select"),
          ),
          // Convert the fetched values into DropdownMenuItems
          ...lr.map((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }),
        ];
        // _dropdownItems = lr.map((value) {
        //   return DropdownMenuItem<String>(
        //     value: value,
        //     child: Text(value),
        //   );
        // }).toList();
      });
    } catch (e) {
      // Handle errors if necessary
      print('Error fetching dropdown values: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.r),
      ),
      backgroundColor: Colors.white,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Adjusts dynamically
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Mark Absent" text

                  Center(
                    child: Text(
                      "Mark Absent",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp,
                        color: Color(0xFFDD3E2B),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      textAlign: TextAlign.center,
                      widget.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24.sp,
                        color: Color(0xFF533DDC),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Row with SVG Icon, Name, Roll Number, and Dropdown
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // SVG Icon
                      // SvgPicture.asset(
                      //   'assets/Frame.svg',
                      //   width: 50.w,
                      //   height: 90.h,
                      // ),
                      // SizedBox(width: 2.w),
                      Image.asset(
                        widget.gender == 1 ? 'assets/bb.png' : 'assets/g.png',
                        color: widget.gender == 1 ? Colors.blue : Colors.pink,
                        width: 60.w,
                        height: 90.h,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      // Column with Name and Roll Number
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Roll Number
                            Text(
                              'Roll No | ${widget.rollNO}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                                color: Color(0xFF494949),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            // Dropdown for reasons
                            DropdownButtonFormField<String>(
                              // value: selectedReason,
                              value: _dropdownItems.any((item) =>
                                      item.value ==
                                      clvmdl.getStudent.leaveReason)
                                  ? clvmdl.getStudent.leaveReason
                                  : null,
                              hint: Text('Select'),
                              items: _dropdownItems,
                              onChanged: (value) {
                                setState(() {
                                  selectedReason = value!;
                                  showOtherTextField = value == 'Others';
                                  Log.d(selectedReason);
                                  Log.d(showOtherTextField);
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12.w),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.r),
                                  borderSide: BorderSide(
                                    color: Color(0xFFA29595),
                                    width: 0.5.w,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: showOtherTextField ? 16.h : 0.h),
                  // TextField for "Other" reason (conditionally shown)
                  if (showOtherTextField)
                    TextField(
                      controller: otherReasonController,
                      decoration: InputDecoration(
                        labelText: "Reason",
                        labelStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xFF626262),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.r),
                          borderSide: BorderSide(
                            color: Color(0xFFA29595),
                            width: 0.5.w,
                          ),
                        ),
                      ),
                    ),

                  SizedBox(height: 16.h),
                  // Row with Call Button, Cancel, and OK
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Call Button
                      // SizedBox(
                      //   width: 14.w,
                      // ),
                      GestureDetector(
                        onTap: () async {
                          startShowing(context);

                          final List<Map<String, dynamic>> apiData =
                              await studRepo.fetchParents(
                                  clvmdl.getStudent.studentId.toString());

                          stopShowing(context);
                          showModalBottomSheet(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.r)),
                            ),
                            context: context,
                            builder: (context) {
                              return ParentContactBottomSheet(
                                parents: apiData,
                                name: widget.name,
                                rollNo: widget.rollNO.toString(),
                                gender: widget.gender,
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 62.w, // Button width
                          height: 40.h, // Button height
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            border: Border.all(
                              color: Color(0xFFED7902), // Border color
                              width: 1.w,
                            ),
                            borderRadius:
                                BorderRadius.circular(5.r), // Rounded corners
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            // Centers the child in the button
                            children: [
                              // Call icon
                              Center(
                                // Centered vertically inside the button
                                child: Icon(
                                  Icons.call, // Call icon
                                  color: Color(0xFFED7902),
                                  // Icon color
                                  size: 24.r, // Icon size
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Spacer(),
                      // Cancel Button
                      SizedBox(width: 12.w),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Color(0xFFA29595),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xFF626262),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      // OK Button
                      ElevatedButton(
                        onPressed: () async {
                          HapticFeedback.lightImpact();

                          startShowing(context);
                          if (selectedReason == 'None') {
                            stopShowing(context);
                            Navigator.pop(context);
                          } else {
                            final student = clvmdl.getStudent;
                            await ClassStudentRepo.storeStudent({
                              'student_id': student.studentId,
                              'class_id': student.classId,
                              'name': student.name,
                              'roll_no': student.rollNo,
                              'gender': student.gender,
                              'att_status': selectedReason.isNotEmpty ? 3 : 2,
                              'leave_reason':
                                  otherReasonController.text.isNotEmpty
                                      ? otherReasonController.text
                                      : selectedReason
                            });
                            await clvmdl.syncDatabase();
                            clvmdl.toggleAttendance(widget.rollNO);
                            stopShowing(context);
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFED7902),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                        child: Text(
                          "   OK   ",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MarkPresentDialog extends StatefulWidget {
  int rollNO;
  String name;
  String reason;
  int gender;

  MarkPresentDialog({
    super.key,
    required this.rollNO,
    required this.name,
    required this.reason,
    required this.gender,
  });

  @override
  _MarkPresentDialogState createState() => _MarkPresentDialogState();
}

class _MarkPresentDialogState extends State<MarkPresentDialog> {
  String selectedReason = '';
  bool showOtherTextField = false;
  final TextEditingController otherReasonController = TextEditingController();
  final clvmdl =
      Provider.of<ClassAttendanceViewModel>(navigatorKey.currentContext!);
  List<DropdownMenuItem<String>> _dropdownItems = [];

  @override
  void initState() {
    super.initState();
    _loadDropdownValues();
  }

  Future<void> _loadDropdownValues() async {
    try {
      final lr = await HomeRepo.dropdownDao.getDropdownValues('lr');
      setState(() {
        _dropdownItems = lr.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList();
      });

      Log.d('in load: $_dropdownItems');
      Log.d(widget.reason);
      Log.d(_dropdownItems);
      _dropdownItems.any((item) => item.value == widget.reason)
          ? setState(() {
              showOtherTextField = widget.reason == 'Others' ? true : false;
            })
          : setState(() {
              showOtherTextField = widget.reason.isNotEmpty ? true : false;
              otherReasonController.text = widget.reason;
            });

      Log.d('showOtherTextField: $showOtherTextField');
    } catch (e) {
      // Handle errors if necessary
      print('Error fetching dropdown values: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.r),
      ),
      backgroundColor: Colors.white,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Adjusts dynamically
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "Mark Absent" text

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    Text(
                      "Mark Present",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp,
                        color: Colors.green,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.cancel,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),

                SizedBox(height: 16.h),

                Align(
                  alignment: Alignment.center,
                  child: Text(
                    textAlign: TextAlign.center,
                    widget.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24.sp,
                      color: Color(0xFF533DDC),
                    ),
                  ),
                ),

                SizedBox(height: 8.h),
                // Row with SVG Icon, Name, Roll Number, and Dropdown
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SVG Icon
                    // SvgPicture.asset(
                    //   'assets/Frame.svg',
                    //   width: 40.w,
                    //   height: 80.h,
                    // ),
                    Image.asset(
                      widget.gender == 1 ? 'assets/bb.png' : 'assets/g.png',
                      color: widget.gender == 1 ? Colors.blue : Colors.pink,
                      width: 60.w,
                      height: 90.h,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    // Column with Name and Roll Number
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name

                          // Roll Number
                          Text(
                            'Roll No | ${widget.rollNO}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: Color(0xFF494949),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // Dropdown for reasons
                          DropdownButtonFormField<String>(
                            // value: selectedReason,
                            value: _dropdownItems.any((item) =>
                                    item.value == clvmdl.getStudent.leaveReason)
                                ? clvmdl.getStudent.leaveReason
                                : clvmdl.getStudent.leaveReason!.isNotEmpty
                                    ? "Others"
                                    : null,
                            // Ensure value exists in items
                            hint: Text('Select'),
                            items: _dropdownItems,
                            onChanged: (value) {
                              setState(() {
                                selectedReason = value!;
                                showOtherTextField = value == 'Others';
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 12.w),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.r),
                                borderSide: BorderSide(
                                  color: Color(0xFFA29595),
                                  width: 0.5.w,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: showOtherTextField ? 16.h : 0.h),
                // TextField for "Other" reason (conditionally shown)
                if (showOtherTextField)
                  TextField(
                    controller: otherReasonController,
                    decoration: InputDecoration(
                      labelText: "Reason",
                      labelStyle: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xFF626262),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.r),
                        borderSide: BorderSide(
                          color: Color(0xFFA29595),
                          width: 0.5.w,
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: 16.h),
                // Row with Call Button, Cancel, and OK
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Call Button
                    // SizedBox(
                    //   width: 7.w,
                    // ),
                    GestureDetector(
                      onTap: () async {
                        startShowing(context);

                        final apiData = await studRepo.fetchParents(
                            clvmdl.getStudent.studentId.toString());

                        stopShowing(context);
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.r)),
                          ),
                          builder: (context) {
                            return ParentContactBottomSheet(
                              parents: apiData,
                              name: widget.name,
                              rollNo: widget.rollNO.toString(),
                              gender: widget.gender,
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 62.w, // Button width
                        height: 40.h, // Button height
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color
                          border: Border.all(
                            color: Color(0xFFED7902), // Border color
                            width: 1.w,
                          ),
                          borderRadius:
                              BorderRadius.circular(5.r), // Rounded corners
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          // Centers the child in the button
                          children: [
                            // Call icon
                            Center(
                              // Centered vertically inside the button
                              child: Icon(
                                Icons.call, // Call icon
                                color: Color(0xFFED7902),
                                // Icon color
                                size: 24.sp, // Icon size
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Spacer(),
                    // Cancel Button
                    SizedBox(width: 12.w),

                    GestureDetector(
                      onTap: () async {
                        HapticFeedback.lightImpact();

                        final student = clvmdl.getStudent;
                        await ClassStudentRepo.storeStudent({
                          'student_id': student.studentId,
                          'class_id': student.classId,
                          'name': student.name,
                          'roll_no': student.rollNo,
                          'gender': student.gender,
                          'att_status': 1,
                          'leave_reason': null
                        });
                        clvmdl.syncDatabase();
                        clvmdl.toggleAttendance(widget.rollNO);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 110.w,
                        // Responsive width
                        height: 35.h,
                        // Responsive height
                        decoration: BoxDecoration(
                          color: Color(0xFF33CC99),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Mark Present",
                          style: TextStyle(
                            fontSize: 14.sp, // Responsive font size
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 4.w), // Responsive spacing

                    // Save Button
                    GestureDetector(
                      onTap: () async {
                        HapticFeedback.mediumImpact();
                        final student = clvmdl.getStudent;
                        await ClassStudentRepo.storeStudent({
                          'student_id': student.studentId,
                          'class_id': student.classId,
                          'name': student.name,
                          'roll_no': student.rollNo,
                          'gender': student.gender,
                          'att_status': selectedReason.isNotEmpty ? 3 : 2,
                          'leave_reason': otherReasonController.text.isNotEmpty
                              ? otherReasonController.text
                              : selectedReason
                        });
                        clvmdl.syncDatabase();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 80.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                          color: Color(0xFFED7902),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     final student = clvmdl.getStudent;
                    //     await ClassStudentRepo.storeStudent({
                    //       'student_id': student.studentId,
                    //       'class_id': student.classId,
                    //       'name': student.name,
                    //       'roll_no': student.rollNo,
                    //       'gender': student.gender,
                    //       'att_status': 1,
                    //       'leave_reason': null
                    //     });
                    //     clvmdl.syncDatabase();
                    //     clvmdl.toggleAttendance(widget.rollNO);
                    //     Navigator.of(context).pop();
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Color(0xFF33CC99),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(5),
                    //     ),
                    //     minimumSize: Size(50, 35),
                    //   ),
                    //   child: Text(
                    //     "Mark Present",
                    //     style: TextStyle(
                    //       fontSize: 14,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(width: 2),
                    //
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     final student = clvmdl.getStudent;
                    //     await ClassStudentRepo.storeStudent({
                    //       'student_id': student.studentId,
                    //       'class_id': student.classId,
                    //       'name': student.name,
                    //       'roll_no': student.rollNo,
                    //       'gender': student.gender,
                    //       'att_status': selectedReason.isNotEmpty ? 3 : 2,
                    //       'leave_reason': selectedReason
                    //     });
                    //     clvmdl.syncDatabase();
                    //     Navigator.of(context).pop();
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Color(0xFFED7902),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(5),
                    //     ),
                    //     minimumSize: Size(50, 35),
                    //   ),
                    //   child: Text(
                    //     "Save",
                    //     style: TextStyle(
                    //       fontSize: 14,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                    // OK Button
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
