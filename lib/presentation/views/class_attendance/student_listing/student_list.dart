import 'package:ezskool/data/viewmodels/class_attendance/student_listing_viewmodel.dart';
import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:ezskool/presentation/views/class_attendance/student_listing/student_details.dart';
import 'package:ezskool/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/logger.dart';
import '../../../../data/repo/student_repo.dart';
import '../../../../main.dart';
import '../../../dialogs/birthday_dialog.dart';

class StudentListScreen extends StatefulWidget {
  final String title;
  final int count;
  final String label;
  final String classId;

  const StudentListScreen({
    super.key,
    required this.title,
    required this.count,
    required this.label,
    required this.classId,
  });

  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final stRepo = StudentRepository();
  List<StudentModel> _sortedStudents = [];
  List<StudentModel> _filteredStudents = [];
  final List<StudentModel> _displayStudents = [];
  List<StudentModel> displayStudents = [];
  final bool _isRollNoSort = true;
  final bool _isAscendingSort = true;
  bool search = false;
  bool isSelected = false;

  bool isLoading = true;

  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _initializeData();
    // });
    _initializeData();
  }

  Future<void> fetchAndLoadStudents(
      StudentViewModel viewModel, String classId) async {
    try {
      final jsonData =
          await stRepo.fetchAllStudents(classId); // Await the result
      Log.d(jsonData);
      viewModel.loadStudents(
          jsonData); // Now, jsonData contains the resolved API response
    } catch (e) {
      print("Error fetching students: $e");
    }
  }

  Future<void> _initializeData() async {
    setState(() {
      isLoading = true;
    });
    // final stvm = Provider.of<StudentViewModel>(navigatorKey.currentState!.context, listen: false);
    final stvm = Provider.of<StudentViewModel>(
        navigatorKey.currentState!.context,
        listen: false);
    await fetchAndLoadStudents(stvm, widget.classId);
    setState(() {
      _sortedStudents = List.from(stvm.students);
      _filteredStudents = List.from(_sortedStudents);
      displayStudents = List.from(_filteredStudents);

      displayStudents =
          _filteredStudents.isNotEmpty ? _filteredStudents : _displayStudents;
    });

    _performSort(true, true);

    setState(() {
      isLoading = false;
    });

    // setState(() {
    //   displayStudents = _filteredStudents.isNotEmpty ? _filteredStudents :  _displayStudents;
    //   isLoading = false;
    // });
  }

  @override
  void dispose() {
    // Dispose focus node and controller
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _performSort(bool isByRollNo, bool isAscending) {
    final stvm = Provider.of<StudentViewModel>(context, listen: false);
    if (isByRollNo) {
      stvm.sortByRollNo(ascending: isAscending);
    } else {
      stvm.sortByName(ascending: isAscending);
    }
    setState(() {
      displayStudents = List.from(stvm.students);
    });
    // Log.d("inside perform sort");
    // setState(() {
    //   _isRollNoSort = isByRollNo;
    //   _isAscendingSort = isAscending;
    //
    //   final stvm = Provider.of<StudentViewModel>(context, listen: false);
    //   _sortedStudents = List.from(stvm.students);
    //
    //   if (isByRollNo) {
    //     _sortedStudents.sort((a, b) => a.rollNo.compareTo(b.rollNo));
    //   } else {
    //     _sortedStudents.sort((a, b) => a.name.compareTo(b.name));
    //   }
    //
    //   if (!isAscending) {
    //     _sortedStudents = _sortedStudents.reversed.toList();
    //   }
    //
    //   _filteredStudents = List.from(_sortedStudents);
    // });
  }

  void _filterStudents(String query) {
    final stvm = Provider.of<StudentViewModel>(context, listen: false);
    setState(() {
      _filteredStudents = stvm.searchStudents(query);
      displayStudents = List.from(_filteredStudents);
    });
    // setState(() {
    //   if (query.isEmpty) {
    //     _filteredStudents = List.from(_sortedStudents);
    //   } else {
    //     final lowercaseQuery = query.toLowerCase();
    //     _filteredStudents = _sortedStudents.where((student) {
    //       //final rollNoStr = student.rollNo.toString().toLowerCase();
    //       final nameStr = student.name.toLowerCase();
    //       //final genderStr = student.gender == 1 ? 'male' : 'female';
    //
    //       return //rollNoStr.contains(lowercaseQuery) ||
    //           nameStr.contains(lowercaseQuery); //||
    //       //genderStr.contains(lowercaseQuery);
    //     }).toList();
    //   }
    // });
  }

  void showSortOptions(BuildContext context, Offset position) {
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () => overlayEntry?.remove(),
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          SortOptionsDialog(
            position: position,
            themeColor: Color(0xFFED7902),
            onSortChanged: (isByRollNo, isAscending) {
              _performSort(isByRollNo, isAscending);
              //overlayEntry?.remove();
            },
            onClose: () => overlayEntry?.remove(),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    final stvm = Provider.of<StudentViewModel>(context);

    //_initializeData();

    // setState(() {
    //   isLoading = false;
    // });

    // Use _sortedStudents if it's not empty, otherwise use original students
    // final displayStudents = _filteredStudents.isNotEmpty ? _filteredStudents :  _displayStudents;

    // setState(() {
    //   displayStudents =
    //   _filteredStudents.isNotEmpty ? _filteredStudents : _displayStudents;
    // });

    //displayStudents = List.from(stvm.students);

    // _initializeData();

    final int totalStudents = displayStudents.length;
    final int maleCount = displayStudents.where((s) => s.gender == 1).length;
    final int femaleCount = totalStudents - maleCount;

    return BaseScreen(
      resize: true,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            // Preserve entire original Row implementation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    stvm.students.clear();
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 19.r,
                  ),
                ),
                SizedBox(width: 5.w),
                SvgPicture.asset('assets/vec.svg', width: 14.w, height: 17.h),
                SizedBox(width: 5.w),
                Text(
                  stvm.formatClass(stvm.className),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),

                //SizedBox(width: 2.w),

                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total | $totalStudents',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xFF2400FF),
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 8.w),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    // Icon(
                    //   Icons.man,
                    //   color: Colors.blue,
                    //   size: 17.r,
                    // ),
                    // const SizedBox(width: 2),
                    Image.asset(
                      'assets/bb.png',
                      width: 12.w,
                      height: 14.h,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      maleCount.toString(),
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600),
                    ),
                    //   ],
                    // ),
                    SizedBox(width: 8.w),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    // Icon(
                    //   Icons.woman,
                    //   color: Colors.pink,
                    //   size: 17.r,
                    // ),
                    // const SizedBox(width: 2),
                    Image.asset('assets/g.png',
                        width: 12.w, height: 14.h, color: Colors.pink),
                    SizedBox(width: 1.w),
                    Text(
                      femaleCount.toString(),
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.pink,
                          fontWeight: FontWeight.w600),
                    ),
                    //   ],
                    // )
                  ],
                ),
              ],
            ),

            SizedBox(height: 16.h),

            //Preserve original Search and Filter Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 36.h,
                  width: 292.w,

                  child: SearchBar(
                    elevation: WidgetStateProperty.all(0),
                    // viewElevation: 0,
                    // viewConstraints: BoxConstraints(maxHeight: 300),
                    focusNode: _searchFocusNode,
                    controller: _searchController,
                    hintText: 'Search by name',
                    hintStyle: WidgetStatePropertyAll(
                        TextStyle(color: Color(0xFF969AB8))),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                        side: BorderSide(
                            color: isSelected
                                ? Color(0xFFED7902)
                                : Color(0xFF969AB8)), // Black border
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    // barPadding: WidgetStatePropertyAll<EdgeInsets>(
                    //     EdgeInsets.symmetric(horizontal: 16.0)),
                    leading: const Icon(
                      Icons.search,
                      color: Color(0xFF969AB8),
                    ),
                    trailing: <Widget>[
                      Align(
                        child: IconButton(
                          onPressed: () {
                            _performSort(true, true);
                          },
                          icon: Icon(
                            size: 20.r,
                            Icons.refresh,
                            color: Color(0xFF969AB8),
                          ),
                        ),
                      )
                    ],
                    //controller: controller,
                    onTap: () {
                      // setState(() {
                      //   isSelected = true;
                      // });
                    },
                    textInputAction: TextInputAction.search,
                    onChanged: (value) {
                      // _filterStudents(value);
                    },
                    onSubmitted: (value) {
                      _filterStudents(value);

                      // setState(() {
                      //   isSelected = false;
                      // });
                    },
                    constraints: BoxConstraints(maxWidth: 292.w),
                  ),

                  // child: SearchAnchor.bar(
                  //
                  //     barElevation: MaterialStateProperty.all(0),
                  //     // viewElevation: 0,
                  //     // viewConstraints: BoxConstraints(maxHeight: 300),
                  //     barHintText: 'Search',
                  //     barHintStyle: WidgetStatePropertyAll(
                  //         TextStyle(
                  //             color: Color(0xFF969AB8)
                  //         )
                  //     ),
                  //     barShape: WidgetStateProperty.all(
                  //       RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(25.r),
                  //         side: BorderSide(
                  //             color: Color(0xFF969AB8)), // Black border
                  //       ),
                  //     ),
                  //     barBackgroundColor:
                  //         WidgetStateProperty.all(Colors.white),
                  //     // barPadding: WidgetStatePropertyAll<EdgeInsets>(
                  //     //     EdgeInsets.symmetric(horizontal: 16.0)),
                  //     barLeading: const Icon(Icons.search,color: Color(0xFF969AB8),),
                  //     //controller: controller,
                  //     onTap: () {
                  //
                  //     },
                  //     isFullScreen: false,
                  //     textInputAction: TextInputAction.search,
                  //     onChanged: (value) {
                  //       // _filterStudents(value);
                  //     },
                  //     viewBackgroundColor: Colors.white,
                  //     viewConstraints: BoxConstraints(maxWidth: 292.w),
                  //     suggestionsBuilder: (BuildContext context, SearchController controller) {
                  //
                  //
                  //       // if (controller.text.isEmpty) return [];
                  //       //
                  //       // final query = controller.text.toLowerCase();
                  //       // final filteredStudents = _sortedStudents.where((student) =>
                  //       // student.name.toLowerCase().contains(query) ||
                  //       //     student.rollNo.toString().contains(query) ||
                  //       //     student.gender == (query == 'male' ? 1 : (query == 'female' ? 2 : 3))
                  //       // ).toList();
                  //       //
                  //       // return [
                  //       //   Align(
                  //       //     alignment: Alignment.topLeft,
                  //       //     child: Material(
                  //       //       elevation: 4,
                  //       //       borderRadius: BorderRadius.circular(12),
                  //       //       child: SizedBox(
                  //       //         width: MediaQuery.of(context).size.width * 0.9,
                  //       //         child: ListView.builder(
                  //       //           shrinkWrap: true,
                  //       //           itemCount: filteredStudents.length,
                  //       //           itemBuilder: (context, index) {
                  //       //             final student = filteredStudents[index];
                  //       //             return ListTile(
                  //       //               title: Text(student.name),
                  //       //               subtitle: Text('Roll No: ${student.rollNo}'),
                  //       //               leading: Icon(
                  //       //                 student.gender == 1 ? Icons.male : Icons.female,
                  //       //                 color: student.gender == 1 ? Colors.blue : Colors.pink,
                  //       //               ),
                  //       //               onTap: () {
                  //       //                 controller.closeView(student.name);
                  //       //                 _filterStudents(student.name);
                  //       //               },
                  //       //             );
                  //       //           },
                  //       //         ),
                  //       //       ),
                  //       //     ),
                  //       //   )
                  //       // ];
                  //
                  //
                  //   // If search is empty, show all students
                  //       if (controller.text.isEmpty) {
                  //         return [];
                  //       }
                  //
                  //       final query = controller.text.toLowerCase();
                  //       return _sortedStudents
                  //           .where((student) =>
                  //       student.name.toLowerCase().contains(query) ||
                  //           student.rollNo.toString().contains(query) || student.gender == (query == 'male'?1:(query == 'female'? 2 : 3)))
                  //           .map(
                  //             (student) => ListTile(
                  //           title: Text(student.name),
                  //           subtitle: Text('Roll No: ${student.rollNo}'),
                  //           leading: Icon(
                  //             student.gender == 1 ? Icons.male : Icons.female,
                  //             color: student.gender == 1 ? Colors.blue : Colors.pink,
                  //           ),
                  //           onTap: () {
                  //             controller.closeView(student.name);
                  //             _filterStudents(student.name);
                  //           },
                  //         ),
                  //       ).toList();
                  //
                  // }),
                ),

                Spacer(),
                //Filter Button
                GestureDetector(
                  onTap: () {
                    RenderBox box = context.findRenderObject() as RenderBox;
                    Offset position = box.localToGlobal(Offset.zero);
                    showSortOptions(context, position);
                  },
                  child: SvgPicture.asset('assets/prefhor.svg',
                      width: 32.w, height: 32.h),
                ),
                // IconButton(
                //        iconSize: 45.r,
                //        icon:  Icon(
                //          Icons.display_settings,
                //          size: 40.r,
                //          color: Color(0xFF969AB8),
                //        ),
                //        onPressed: () {
                //          RenderBox box = context.findRenderObject() as RenderBox;
                //          Offset position = box.localToGlobal(Offset.zero);
                //          showSortOptions(context, position);
                //        },
                //      ),
              ],
            ),

            SizedBox(height: 24.h),

            // Preserve original header row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  // SizedBox(width: 30.w),
                  Image.asset(
                    'assets/id.png',
                    width: 21.w,
                    height: 16.h,
                  ),
                  SizedBox(width: 22.w),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 1,
              height: 16.h,
            ),

            // ListView with sorting
            // SizedBox(
            //   height: 800.h,
            //   child:

            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      color: Color(0xFFED7902),
                    ))
                  : ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      //shrinkWrap: true,
                      itemCount: displayStudents.length,
                      itemBuilder: (context, index) {
                        final student = displayStudents[index];

                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.h),
                          child: Column(
                            spacing: 5.h,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  startShowing(context);
                                  final apiData = await stRepo
                                      .fetchStudent(student.id.toString());
                                  stopShowing(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              StudentProfileScreen(
                                                studentData: apiData,
                                                className: stvm.className,
                                              )));
                                },
                                child: Row(
                                  children: [
                                    SizedBox(width: 20.w),
                                    Expanded(
                                      child: Text(
                                        student.rollNo.toString(),
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                    ),
                                    // SvgPicture.asset(student.gender == 1 ? 'assets/lilb.svg' : 'assets/lilg.svg',
                                    //     width: 12.w, height: 14.h),
                                    // Icon(
                                    //   student.gender == 1
                                    //       ? Icons.man
                                    //       : Icons.woman,
                                    //   color: student.gender == 1
                                    //       ? Colors.blue
                                    //       : Colors.pink,
                                    //   size: 17.r,
                                    // ),
                                    Image.asset(
                                      student.gender == 1
                                          ? 'assets/bb.png'
                                          : 'assets/g.png',
                                      width: 12.w,
                                      height: 14.h,
                                      alignment: Alignment.center,
                                      color: student.gender == 1
                                          ? Colors.blue
                                          : Colors.pink,
                                    ),
                                    SizedBox(width: 2.w),
                                    Expanded(
                                      flex: 7,
                                      child: Text(
                                        student.name,
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.grey[300],
                                thickness: 2,
                                height: 16.h,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            // ),
          ],
        ),
      ),
    );
  }
}

// import 'package:ezskool/data/viewmodels/class_attendance/student_listing_viewmodel.dart';
// import 'package:ezskool/presentation/views/base_screen.dart';
// import 'package:ezskool/presentation/views/class_attendance/student_listing/student_details.dart';
// import 'package:ezskool/presentation/widgets/loading.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../data/repo/student_repo.dart';
// import '../../../dialogs/birthday_dialog.dart';
//
// class StudentListScreen extends StatelessWidget {
//   final String title;
//   final int count;
//   final String label;
//
//   StudentListScreen({
//     Key? key,
//     required this.title,
//     required this.count,
//     required this.label,
//   }) : super(key: key);
//
//   final stRepo = StudentRepository();
//
//   @override
//   Widget build(BuildContext context) {
//     final stvm = Provider.of<StudentViewModel>(context);
//     final int totalStudents = stvm.students.length;
//     final int maleCount = stvm.students.where((s) => s.gender == 1).length;
//     final int femaleCount = totalStudents - maleCount;
//
//     return BaseScreen(
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               // Row with Dynamic Information
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Icon(
//                       Icons.arrow_back,
//                       size: 19.0,
//                     ),
//                   ),
//
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   SvgPicture.asset('assets/vec.svg', width: 14, height: 17),
//                   const SizedBox(width: 5),
//                   Text(
//                     stvm.className,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const Spacer(),
//                   // Girl Count with Pink Icon
//                   Row(
//                     children: [
//                       Text(
//                         'Total | $totalStudents',
//                         style: TextStyle(
//                             fontSize: 14,
//                             color: Color(0xFF2400FF), // Blue color for total
//                             fontWeight: FontWeight.w600),
//                       ),
//                       const SizedBox(width: 8),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.male,
//                             color: Colors.green, // Boy Icon (Green)
//                             size: 20,
//                           ),
//                           const SizedBox(width: 2),
//                           Text(
//                             maleCount.toString(), // Dynamic Boy Count
//                             style: const TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(width: 8),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.female,
//                             color: Colors.pink, // Girl Icon (Pink)
//                             size: 20,
//                           ),
//                           const SizedBox(width: 2),
//                           Text(
//                             femaleCount.toString(), // Dynamic Girl Count
//                             style: const TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.pink,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//
//                   // Boy Count with Green Icon
//
//                   // Total Count
//                 ],
//               ),
//
//               const SizedBox(height: 16),
//
//               // Search Bar with Filter Button
//               Row(
//                 children: [
//                   StatefulBuilder(builder: (context, setState) {
//                     return Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         height: 40,
//                         width: 301,
//                         // decoration: BoxDecoration(
//                         //   color: Colors.white,
//                         //   borderRadius: BorderRadius.circular(25),
//                         //   border: Border.all(color: Color(0xFF969AB8)),
//                         // ),
//                         child: SearchAnchor(builder: (BuildContext context,
//                             SearchController controller) {
//                           return SearchBar(
//                             shape: WidgetStateProperty.all(
//                               RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(25),
//                                 side: BorderSide(
//                                     color: Colors.black), // Black border
//                               ),
//                             ),
//                             controller: controller,
//                             hintText: 'search',
//                             backgroundColor:
//                                 WidgetStateProperty.all(Colors.white),
//                             padding: const WidgetStatePropertyAll<EdgeInsets>(
//                                 EdgeInsets.symmetric(horizontal: 16.0)),
//                             onTap: () {
//                               controller.openView();
//                             },
//                             onChanged: (_) {
//                               controller.openView();
//                             },
//                             leading: const Icon(Icons.search),
//                           );
//                         }, suggestionsBuilder: (BuildContext context,
//                             SearchController controller) {
//                           return List<ListTile>.generate(5, (int index) {
//                             final String item = 'item $index';
//                             return ListTile(
//                               title: Text(item),
//                               onTap: () {
//                                 setState(() {
//                                   controller.closeView(item);
//                                 });
//                               },
//                             );
//                           });
//                         }));
//                   }),
//
//                   const Spacer(),
//                   // Filter Button
//                   IconButton(
//                     icon: const Icon(
//                       Icons.filter_list,
//                       size: 30,
//                     ),
//                     onPressed: () {
//                       RenderBox box = context.findRenderObject() as RenderBox;
//                       Offset position = box.localToGlobal(Offset.zero);
//                       showSortOptions(context, position);
//                     },
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 24),
//
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   children: [
//                     SizedBox(width: 20),
//                     Icon(Icons.list_alt),
//                     SizedBox(width: 90),
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         "Name",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(
//                 color: Colors.black,
//                 thickness: 1,
//                 height: 16,
//               ),
//
//               SizedBox(
//                 height: 800,
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: stvm.students.length,
//                   itemBuilder: (context, index) {
//                     final student = stvm.students[index];
//
//                     return Padding( padding: EdgeInsets.symmetric(vertical: 3),
//                     child: Column(
//                       // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       // crossAxisAlignment: CrossAxisAlignment.center,
//                       spacing: 5,
//                       children: [
//                         GestureDetector(
//                           onTap: () async {
//                             startShowing(context);
//                             final apiData = await stRepo.fetchStudent(student.id.toString());
//                             stopShowing(context);
//                             Navigator.pushNamed(context, '/stpfp',arguments: {
//                               'studentData': apiData,
//                               'className': stvm.className,
//                             },);
//                           },
//                           child: Row(
//                             children: [
//                               SizedBox(width: 45),
//                               Expanded(
//                                 child: Text(
//                                   student.rollNo.toString(),
//                                   style: TextStyle(fontSize: 14),
//                                 ),
//                               ),
//
//                               // Gender Icon (Male / Female)
//                               Icon(
//                                 student.gender == 1 ? Icons.male : Icons.female,
//                                 color: student.gender == 1
//                                     ? Colors.blue
//                                     : Colors.pink,
//                                 size: 24,
//                               ),
//
//                               Expanded(
//                                 flex: 3,
//                                 child: Text(
//                                   student.name,
//                                   style: TextStyle(fontSize: 14),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Divider(
//                             color: Colors.grey[300], thickness: 2, height: 16),
//                       ],
//                     ));
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
