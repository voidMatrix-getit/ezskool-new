import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'new_assignment_screen.dart';

class AssignTaskScreen extends StatefulWidget {
  const AssignTaskScreen({super.key});

  @override
  State<AssignTaskScreen> createState() => _AssignTaskScreenState();
}

class _AssignTaskScreenState extends State<AssignTaskScreen> {
  bool _isSpecificStudents = true; // Default to true as shown in the image
  List<Student> _selectedStudents =
      []; // Will be populated with sample data in initState

  // Sample student data with roll numbers from 1 to 10
  final List<Student> _allStudents = [
    Student(id: 1, name: "Arya Rathod", gender: Gender.female),
    Student(id: 2, name: "Rohan Gupta", gender: Gender.male),
    Student(id: 3, name: "Hema Joshi", gender: Gender.female),
    Student(id: 4, name: "Nandini Chaturvedi", gender: Gender.female),
    Student(id: 5, name: "Geeta Patel", gender: Gender.female),
    Student(id: 6, name: "Akanksha Agnihotri", gender: Gender.female),
    Student(id: 7, name: "Jay Rathod", gender: Gender.male),
    Student(id: 8, name: "Nisha Shirke", gender: Gender.female),
    Student(id: 9, name: "Rahul Sharma", gender: Gender.male),
    Student(id: 10, name: "Priya Desai", gender: Gender.female),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with all students selected as shown in the image
    _selectedStudents = List.from(_allStudents);
  }

  void _showStudentSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => StudentSelectionBottomSheet(
        students: _allStudents,
        selectedStudents: _selectedStudents,
        onSelect: (selectedStudents) {
          setState(() {
            _selectedStudents = selectedStudents;
          });
        },
      ),
    );
  }

  void _removeStudent(Student student) {
    setState(() {
      _selectedStudents.remove(student);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom back button and title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios, size: 18.r),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Assign Task",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.w), // To balance the back button
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Radio options
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildRadioOption("All Students", !_isSpecificStudents),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 8.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRadioOption("Specific Students", _isSpecificStudents),
                if (_isSpecificStudents)
                  GestureDetector(
                    onTap: _showStudentSelectionBottomSheet,
                    child: Text(
                      "Select",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFED7902),
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(
                            0xFFED7902), // Match underline color to theme
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Selected students card
          if (_isSpecificStudents) ...[
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: _selectedStudents
                      .map((student) => _buildStudentChip(student))
                      .toList(),
                ),
              ),
            ),
          ],

          const Spacer(),

          // Bottom buttons
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // "Post Assignment" button
                  SizedBox(
                    width: 315.w,
                    height: 37.h,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFED7902),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      child: Text(
                        "Post Assignment",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // "Save Draft" button
                  SizedBox(
                    width: 315.w,
                    height: 37.h,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5F5F5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      child: Text(
                        "Save As Draft",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSpecificStudents = title == "Specific Students";
        });
      },
      child: Row(
        children: [
          Container(
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFFED7902) : Colors.grey,
                width: 1.5,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 12.w,
                      height: 12.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFED7902),
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: 8.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentChip(Student student) {
    return Container(
      height: 30.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${student.id} - ${student.name}",
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black87,
            ),
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: () => _removeStudent(student),
            child: Icon(
              Icons.close,
              size: 16.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class StudentSelectionBottomSheet extends StatefulWidget {
  final List<Student> students;
  final List<Student> selectedStudents;
  final Function(List<Student>) onSelect;

  const StudentSelectionBottomSheet({
    super.key,
    required this.students,
    required this.selectedStudents,
    required this.onSelect,
  });

  @override
  State<StudentSelectionBottomSheet> createState() =>
      _StudentSelectionBottomSheetState();
}

class _StudentSelectionBottomSheetState
    extends State<StudentSelectionBottomSheet> {
  late List<Student> _tempSelectedStudents;

  @override
  void initState() {
    super.initState();
    _tempSelectedStudents = List.from(widget.selectedStudents);
  }

  void _toggleStudent(Student student) {
    setState(() {
      if (_tempSelectedStudents.contains(student)) {
        _tempSelectedStudents.remove(student);
      } else {
        _tempSelectedStudents.add(student);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 650.h,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Text(
              "Select Students",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFED7902),
              ),
            ),
          ),

          // Main Container
          Container(
            width: 353.w,
            height: 510.h,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 13.5,
                  offset: Offset(0, 1),
                ),
              ],
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  height: 36.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 23.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE8D1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(7.r),
                      topRight: Radius.circular(7.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/id.png',
                        width: 21.w,
                        height: 16.h,
                      ),
                      SizedBox(width: 29.w),
                      Text(
                        "Name",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF434343),
                        ),
                      ),
                    ],
                  ),
                ),

                // Student list
                SizedBox(
                  height: 460.h, // 485 - 36 = 449
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: widget.students.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      thickness: 0.5,
                      color: Color(0xFFDADADA),
                    ),
                    itemBuilder: (context, index) {
                      final student = widget.students[index];
                      final isSelected =
                          _tempSelectedStudents.contains(student);

                      return Container(
                        height: 46.h,
                        padding: EdgeInsets.only(
                          left: 31.5.w,
                          right: 16.w,
                        ),
                        child: Row(
                          children: [
                            Container(
                              child: Text(
                                "${student.id}",
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1E1E1E),
                                ),
                              ),
                            ),
                            SizedBox(width: 36.w),
                            Image.asset(
                              color: student.gender == Gender.male
                                  ? Colors.blue
                                  : Colors.pink,
                              student.gender == Gender.male
                                  ? 'assets/bb.png'
                                  : 'assets/g.png',
                              width: 12.w,
                              height: 14.h,
                            ),
                            SizedBox(width: 3.w),
                            SizedBox(
                              width: 192.w,
                              child: Text(
                                student.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1E1E1E),
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: 20.w,
                              height: 20.h,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFED7902)
                                    : Colors.white,
                                border: Border.all(
                                  color: const Color(0xFFDFDFDF),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                              child: InkWell(
                                onTap: () => _toggleStudent(student),
                                child: isSelected
                                    ? Icon(
                                        Icons.check,
                                        size: 16.sp,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 40.h),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cancel Button
              CustomActionButton(
                text: 'Cancel',
                backgroundColor: const Color(0xFFF5F5F5),
                textColor: Color(0xFF494949),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(width: 9.w),

              // Submit Button
              CustomActionButton(
                text: 'Select',
                backgroundColor: const Color(0xFFED7902),
                textColor: Colors.white,
                onPressed: () {
                  widget.onSelect(_tempSelectedStudents);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Models
enum Gender { male, female }

class Student {
  final int id;
  final String name;
  final Gender gender;

  Student({
    required this.id,
    required this.name,
    required this.gender,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Student &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
