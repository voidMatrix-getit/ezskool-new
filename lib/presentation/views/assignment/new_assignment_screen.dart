import 'package:ezskool/data/repo/student_repo.dart';
import 'package:ezskool/data/viewmodels/class_attendance/class_attendance_home_viewmodel.dart';
import 'package:ezskool/data/viewmodels/class_attendance/student_listing_viewmodel.dart';
import 'package:ezskool/presentation/drawers/class_selection_drawer.dart';
import 'package:ezskool/presentation/widgets/custom_dropdown.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../base_screen.dart';
import 'assign_task_screen.dart';

// Reusable Components

// 1. Custom Dropdown Menu
// class CustomDropdown extends StatefulWidget {
//   final List<String> items;
//   final String? selectedItem;
//   final String hintText;
//   final Function(String) onChanged;
//
//   const CustomDropdown({
//     Key? key,
//     required this.items,
//     this.selectedItem,
//     required this.hintText,
//     required this.onChanged,
//   }) : super(key: key);
//
//   @override
//   State<CustomDropdown> createState() => _CustomDropdownState();
// }
//
// class _CustomDropdownState extends State<CustomDropdown> {
//   bool isDropdownOpen = false;
//   OverlayEntry? _overlayEntry;
//   final GlobalKey _dropdownKey = GlobalKey();
//
//   @override
//   void dispose() {
//     _removeDropdown();
//     super.dispose();
//   }
//
//   void _showDropdown() {
//     final RenderBox renderBox =
//         _dropdownKey.currentContext!.findRenderObject() as RenderBox;
//     final position = renderBox.localToGlobal(Offset.zero);
//     final size = renderBox.size;
//
//     // Get the screen height to check for overflow
//     final screenHeight = MediaQuery.of(context).size.height;
//     final bottomSpace = screenHeight - (position.dy + size.height);
//
//     // Calculate the height of the dropdown content
//     final contentHeight = widget.items.length * (21.h + 14.h) + 8.h;
//
//     // Check if dropdown would overflow at the bottom
//     final willOverflow = bottomSpace < contentHeight;
//
//     // Position above if it will overflow, otherwise position below
//     final topPosition =
//         willOverflow ? position.dy - contentHeight : position.dy + size.height;
//
//     _overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         left: position.dx,
//         top: topPosition,
//         width: size.width,
//         child: Material(
//           elevation: 4,
//           child: Container(
//             width: 343.w,
//             height: contentHeight,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.25),
//                   blurRadius: 4.3,
//                   offset: const Offset(0, 1),
//                 ),
//               ],
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: ListView.builder(
//               padding: EdgeInsets.only(top: 8.h),
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: widget.items.length,
//               itemBuilder: (context, index) {
//                 final type = widget.items[index];
//                 final isSelected = widget.selectedItem == type;
//
//                 return GestureDetector(
//                   onTap: () {
//                     widget.onChanged(type);
//                     _removeDropdown();
//                   },
//                   child: Container(
//                     width: 343.w,
//                     // Full width of the dropdown
//                     height: 21.h,
//                     margin: EdgeInsets.only(bottom: 14.h),
//                     color: isSelected
//                         ? const Color(0xFFFAECEC)
//                         : Colors.transparent,
//                     child: Padding(
//                       padding: EdgeInsets.only(left: 14.w),
//                       child: Text(
//                         type,
//                         style: TextStyle(
//                           fontWeight:
//                               isSelected ? FontWeight.w500 : FontWeight.w400,
//                           fontSize: 14.sp,
//                           height: 1.5,
//                           letterSpacing: 0.01,
//                           color: const Color(0xFF494949),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//
//     Overlay.of(context)!.insert(_overlayEntry!);
//     setState(() {
//       isDropdownOpen = true;
//     });
//   }
//
//   void _removeDropdown() {
//     if (_overlayEntry != null) {
//       _overlayEntry!.remove();
//       _overlayEntry = null;
//     }
//     setState(() {
//       isDropdownOpen = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       key: _dropdownKey,
//       onTap: () {
//         if (isDropdownOpen) {
//           _removeDropdown();
//         } else {
//           _showDropdown();
//         }
//       },
//       child: Container(
//         width: 339.w,
//         height: 39.h,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(
//             color: const Color(0xFF969AB8),
//             width: 0.5.w,
//           ),
//           borderRadius: BorderRadius.circular(6.r),
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 14.w),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 widget.selectedItem ?? widget.hintText,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: widget.selectedItem != null
//                       ? Colors.black
//                       : const Color(0xFF969AB8),
//                 ),
//               ),
//               Icon(isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
//                   color: const Color(0xFF969AB8)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // 2. Custom Text Input Field
// class CustomTextField extends StatelessWidget {
//   final String labelText;
//   final TextEditingController? controller;
//   final FocusNode? focusNode;
//   final FocusNode? nextFocusNode;
//   final bool isMultiLine;
//   final TextInputAction textInputAction;
//   final TextInputType keyboardType;
//
//   const CustomTextField({
//     Key? key,
//     required this.labelText,
//     this.controller,
//     this.focusNode,
//     this.nextFocusNode,
//     this.isMultiLine = false,
//     this.textInputAction = TextInputAction.next,
//     this.keyboardType = TextInputType.text,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     if (focusNode != null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (focusNode!.hasFocus) {
//           FocusScope.of(context).requestFocus(focusNode);
//         }
//       });
//     }
//     return SizedBox(
//       height: 39.h,
//         width: 339.w,
//         child: TextFormField(
//
//       controller: controller,
//       focusNode: focusNode,
//       maxLines: isMultiLine ? null : 1,
//       minLines: isMultiLine ? 2 : 1,
//       textInputAction: textInputAction,
//       keyboardType: keyboardType,
//       onFieldSubmitted: (_) {
//         if (nextFocusNode != null) {
//           FocusScope.of(context).requestFocus(nextFocusNode);
//         }
//       },
//       decoration: InputDecoration(
//         // constraints: BoxConstraints(
//         //   minHeight: 39.h,  // Minimum height
//         //   maxHeight: 339.w,  // Maximum height
//         // ),
//         labelText: labelText,
//         labelStyle: TextStyle(
//           fontSize: 14.sp,
//           color: Color(0xFF969AB8),
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(6.r),
//           borderSide: BorderSide(
//             color: Color(0xFF969AB8),
//             width: 0.5.w,
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(6.r),
//           borderSide: BorderSide(
//             color: Color(0xFF969AB8),
//             width: 0.5.w,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(6.r),
//           borderSide: BorderSide(
//             color: Color(0xFF969AB8),
//             width: 0.5.w,
//           ),
//         ),
//         contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
//         filled: true,
//         fillColor: Colors.white,
//       ),
//     ));
//   }
// }
//
// // 3. Custom Date Picker Field
// class CustomDatePicker extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final Function(DateTime) onDateSelected;

//   const CustomDatePicker({
//     Key? key,
//     required this.controller,
//     required this.hintText,
//     required this.onDateSelected,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async {
//         showCalendarBottomSheet(
//           context,
//           controller.text.isEmpty
//               ? DateTime.now()
//               : DateFormat('dd/MM/yyyy').parse(controller.text),
//           (DateTime selectedDate) {
//             controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
//             onDateSelected(selectedDate);
//           },
//         );
//       },
//       child: Container(
//         width: 339.w,
//         height: 38.h,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(
//             color: const Color(0xFF969AB8),
//             width: 0.5.w,
//           ),
//           borderRadius: BorderRadius.circular(6.r),
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 12.w),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 controller.text.isEmpty ? hintText : controller.text,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: controller.text.isEmpty
//                       ? const Color(0xFF969AB8)
//                       : Colors.black,
//                 ),
//               ),
//               Icon(
//                 Icons.calendar_today,
//                 color: Color(0xFFB8BCCA),
//                 size: 20.r,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class CustomDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final Function(DateTime) onDateSelected;

  const CustomDatePicker({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onDateSelected,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showCalendarBottomSheet(
          context,
          controller.text.isEmpty
              ? DateTime.now()
              : DateFormat('dd/MM/yyyy').parse(controller.text),
          (DateTime selectedDate) {
            controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
            onDateSelected(selectedDate);
          },
        );
      },
      child: SizedBox(
        width: 339.w,
        height: 38.h,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: controller.text.isNotEmpty ? labelText : null,
            labelStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide:
                  BorderSide(color: const Color(0xFF969AB8), width: 0.5.w),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide:
                  BorderSide(color: const Color(0xFF969AB8), width: 0.5.w),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.text.isEmpty ? hintText : controller.text,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: controller.text.isEmpty
                        ? const Color(0xFF969AB8)
                        : Colors.black,
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: const Color(0xFFB8BCCA),
                  size: 20.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
// // 4. Custom File Picker
// class CustomFilePicker extends StatelessWidget {
//   final String? selectedFile;
//   final Function(String) onFilePicked;

//   const CustomFilePicker({
//     Key? key,
//     required this.selectedFile,
//     required this.onFilePicked,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async {
//         final result = await FilePicker.platform.pickFiles();
//         if (result != null) {
//           onFilePicked(result.files.single.name);
//         }
//       },
//       child: Container(
//         width: 339.w,
//         height: 38.h,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(
//             color: const Color(0xFF969AB8),
//             width: 0.5.w,
//           ),
//           borderRadius: BorderRadius.circular(6.r),
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 selectedFile ?? 'Upload Files',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: selectedFile != null
//                       ? Colors.black
//                       : const Color(0xFF969AB8),
//                 ),
//               ),
//               Icon(
//                 Icons.upload_file,
//                 color: Color(0xFF969AB8),
//                 size: 20.r,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class CustomFilePicker extends StatelessWidget {
  final String? selectedFile;
  final String? hintText;
  final String? labelText;
  final Function(String) onFilePicked;

  const CustomFilePicker({
    super.key,
    required this.selectedFile,
    required this.onFilePicked,
    required this.hintText,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await FilePicker.platform.pickFiles();
        if (result != null) {
          onFilePicked(result.files.single.name);
        }
      },
      child: SizedBox(
        width: 339.w,
        height: 38.h,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: selectedFile != null ? labelText : null,
            labelStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide:
                  BorderSide(color: const Color(0xFF969AB8), width: 0.5.w),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide:
                  BorderSide(color: const Color(0xFF969AB8), width: 0.5.w),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedFile ?? hintText!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: selectedFile != null
                        ? Colors.black
                        : const Color(0xFF969AB8),
                  ),
                ),
                Icon(
                  Icons.upload_file,
                  color: const Color(0xFF969AB8),
                  size: 20.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
// // 5. Custom Radio Button
// class CustomRadioButton extends StatelessWidget {
//   final bool isSelected;
//   final String text;
//   final VoidCallback onTap;
//   final Color selectedColor;
//
//   const CustomRadioButton({
//     Key? key,
//     required this.isSelected,
//     required this.text,
//     required this.onTap,
//     this.selectedColor = const Color(0xFFED7902),
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Row(
//         children: [
//           Container(
//             width: 18.w,
//             height: 18.h,
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: isSelected ? selectedColor : const Color(0xFF969AB8),
//                 width: 1.w,
//               ),
//               borderRadius: BorderRadius.circular(13.r),
//             ),
//             child: isSelected
//                 ? Center(
//                     child: Container(
//                       width: 12.w,
//                       height: 12.h,
//                       decoration: BoxDecoration(
//                         color: selectedColor,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   )
//                 : null,
//           ),
//           SizedBox(width: 8.w),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: Color(0xFF1E1E1E),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // 6. Custom Action Button
class CustomActionButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const CustomActionButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 99.w,
        height: 37.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 5.1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: textColor,
              letterSpacing: 0.4.w,
            ),
          ),
        ),
      ),
    );
  }
}

// Custom TextFormField component
class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final int? taskNumber;
  final TextEditingController controller;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.taskNumber,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.h,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF969AB8), width: 0.5.w),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: 3,
        style: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xFF626262),
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.w),
          border: InputBorder.none,
          hintText: taskNumber != null ? '$taskNumber. $hintText' : hintText,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF969AB8),
          ),
        ),
      ),
    );
  }
}

// Main Screen
class NewAssignmentScreen extends StatefulWidget {
  const NewAssignmentScreen({super.key});

  @override
  State<NewAssignmentScreen> createState() => _NewAssignmentScreenState();
}

class _NewAssignmentScreenState extends State<NewAssignmentScreen> {
  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Focus Nodes for managing focus
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  DateTime selectedDate = DateTime.now();

  // Form state
  final bool _allSelected = true;
  final bool _classSelected = false;
  final bool _studentsSelected = false;
  String? _selectedFile;
  String? selectedIntimationType;

  // Dropdown options
  final List<String> intimationTypes = [
    'Holiday',
    'Event',
    'General Announcement',
    'Custom Message'
  ];
  final stRepo = StudentRepository();
  List<Map<String, dynamic>> cardData = [];
  String? tempClass = '';
  bool isLoding = true;

  @override
  void initState() {
    super.initState();
    loadClasses();
  }

  Future<void> loadClasses() async {
    setState(() {
      isLoding = true;
    });
    final cls = await stRepo.getAllClasses();
    Provider.of<ClassAttendanceHomeViewModel>(context, listen: false)
        .updateClass('');

    setState(() {
      cardData = cls;
      isLoding = false;
    });
  }

  @override
  void dispose() {
    // Clean up the controllers and focus nodes
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  String? selectedAssignmentType;
  String? selectedSubject;
  final List<TextEditingController> taskControllers = [TextEditingController()];

  final List<String> assignmentTypes = ['Academic', 'Co-curricular', 'Others'];
  final List<String> subjects = [
    'Mathematics',
    'Science',
    'English',
    'Social Science',
    'History & Geography',
    'Language - I',
  ];

  void addNewTask() {
    setState(() {
      taskControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    final stvm = Provider.of<StudentViewModel>(context);
    final viewModel = Provider.of<ClassAttendanceHomeViewModel>(context);

    return BaseScreen(
      resize: true,
      child: SingleChildScrollView(
          //child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 5.h),
              // Title
              Text(
                'New Assignment',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 15.h),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SvgPicture.asset('assets/cal.svg', width: 18.w, height: 18.h),
                SizedBox(width: 5.w),
                Text(
                  DateFormat('d MMM yyyy, EEEE').format(selectedDate),
                  style: TextStyle(color: Color(0xFF494949), fontSize: 14.sp),
                ),
              ]),
              SizedBox(height: 15.h),

              // Form Section - Using Expanded with SingleChildScrollView to prevent overflow
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LabeledDropdownButton2(
                    label: 'Assignment Type',
                    items: ['Academic', 'Non-Academic'],
                    hint: 'Assignment Type',
                    value:
                        selectedAssignmentType, // your current selection (can be null)
                    onChanged: (newValue) {
                      setState(() {
                        selectedAssignmentType = newValue;
                      });
                    },
                  ),

                  SizedBox(height: 15.h),

                  GestureDetector(
                    onTap: () async {
                      openBottomDrawerDropDown(context, stvm, cardData);
                    },
                    child: SizedBox(
                      width: 339.w,
                      height: 39.h,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: viewModel.selectedClass.isNotEmpty
                              ? 'Selected Class'
                              : null,
                          labelStyle:
                              TextStyle(fontSize: 12.sp, color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 8.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.r),
                            borderSide: BorderSide(
                                color: const Color(0xFF969AB8), width: 0.5.w),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.r),
                            borderSide: BorderSide(
                                color: const Color(0xFF969AB8), width: 0.5.w),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w), // Adds space inside
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween, // Aligns items
                            children: [
                              Text(
                                viewModel.selectedClass.isNotEmpty
                                    ? viewModel.selectedClass
                                        .replaceAll(' ', '-')
                                    : 'Select Class',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                  letterSpacing: 0.01,
                                  color: viewModel.selectedClass.isNotEmpty
                                      ? const Color(0xFF1E1E1E)
                                      : const Color(0xFF969AB8),
                                ),
                              ),
                              Icon(
                                CupertinoIcons.chevron_down,
                                color: const Color(0xFF969AB8),
                                size: 20.w,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // SizedBox(
                    //   width: 339.w,
                    //   height: 39.h,
                    //   child: InputDecorator(
                    //     decoration: InputDecoration(
                    //       labelText: viewModel.selectedClass.isNotEmpty
                    //           ? 'Selected Class'
                    //           : null,
                    //       labelStyle:
                    //           TextStyle(fontSize: 12.sp, color: Colors.grey),
                    //       contentPadding: EdgeInsets.symmetric(
                    //           horizontal: 14.w, vertical: 8.h),
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(6.r),
                    //         borderSide: BorderSide(
                    //             color: const Color(0xFF969AB8), width: 0.5.w),
                    //       ),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(6.r),
                    //         borderSide: BorderSide(
                    //             color: const Color(0xFF969AB8), width: 0.5.w),
                    //       ),
                    //     ),
                    //     child: Stack(
                    //       children: [
                    //         Positioned(
                    //           left: 14.w,
                    //           top: 1.h,
                    //           child: Text(
                    //             viewModel.selectedClass.isNotEmpty
                    //                 ? viewModel.selectedClass
                    //                     .replaceAll(' ', '-')
                    //                 : 'Select Class',
                    //             style: TextStyle(
                    //               fontSize: 14.sp,
                    //               fontWeight: FontWeight.w400,
                    //               height: 1.5,
                    //               letterSpacing: 0.01,
                    //               color: viewModel.selectedClass.isNotEmpty
                    //                   ? const Color(0xFF1E1E1E)
                    //                   : const Color(0xFF969AB8),
                    //             ),
                    //           ),
                    //         ),
                    //         Positioned(
                    //           right: 12.w,
                    //           top: 1.h,
                    //           child: Icon(
                    //             CupertinoIcons.chevron_down,
                    //             color: const Color(0xFF969AB8),
                    //             size: 20.w,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    // InputDecorator(
                    //   decoration: InputDecoration(
                    //     labelText: viewModel.selectedClass.isNotEmpty
                    //         ? 'Selected Class'
                    //         : null,
                    //     labelStyle:
                    //         TextStyle(fontSize: 12.sp, color: Colors.grey),
                    //     contentPadding: EdgeInsets.symmetric(
                    //         horizontal: 14.w, vertical: 8.h),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(6.r),
                    //       borderSide: BorderSide(
                    //           color: const Color(0xFF969AB8), width: 0.5.w),
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(6.r),
                    //       borderSide: BorderSide(
                    //           color: const Color(0xFF969AB8), width: 0.5.w),
                    //     ),
                    //   ),
                    //   child: SizedBox(
                    //     width: 339.w,
                    //     height: 39.h,
                    //     // decoration: BoxDecoration(
                    //     //   color: Colors.white,
                    //     //   border: Border.all(
                    //     //     color: const Color(0xFF969AB8),
                    //     //     width: 0.5.w,
                    //     //   ),
                    //     //   borderRadius: BorderRadius.circular(6.r),
                    //     // ),
                    //     child: Stack(
                    //       children: [
                    //         // Text Block (Select Class)
                    //         Positioned(
                    //           left: 14.w,
                    //           top: 9.h,
                    //           child: Text(
                    //             viewModel.selectedClass.isNotEmpty
                    //                 ? viewModel.selectedClass
                    //                     .replaceAll(' ', '-')
                    //                 : 'Select Class',
                    //             style: TextStyle(
                    //               fontSize: 14.sp,
                    //               fontWeight: FontWeight.w400,
                    //               height: 1.5, // roughly 150% line height
                    //               letterSpacing: 0.01,
                    //               color: viewModel.selectedClass.isNotEmpty
                    //                   ? const Color(0xFF1E1E1E)
                    //                   : const Color(0xFF969AB8),
                    //             ),
                    //           ),
                    //         ),
                    //         // Cupertino down arrow icon
                    //         Positioned(
                    //           right: 12.w,
                    //           top: 8.h,
                    //           child: Icon(
                    //             CupertinoIcons.chevron_down,
                    //             color: const Color(0xFF969AB8),
                    //             size: 20.w,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // )
                  ),

                  SizedBox(height: 15.h),

                  LabeledDropdownButton2(
                    label: 'Selected Subject',
                    items: subjects,
                    hint: 'Select Subject',
                    value:
                        selectedSubject, // your current selection (can be null)
                    onChanged: (newValue) {
                      setState(() {
                        selectedSubject = newValue;
                      });
                    },
                  ),

                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Task',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF494949),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: taskControllers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: CustomTextFormField(
                          hintText: 'Write your task here...',
                          taskNumber:
                              taskControllers.length > 1 ? index + 1 : null,
                          controller: taskControllers[index],
                        ),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: addNewTask,
                        child: Container(
                          width: 55.w,
                          height: 21.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFED7902),
                            borderRadius: BorderRadius.circular(2.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 4.3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '+ Add',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Attachments ',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF494949),
                          ),
                          children: [
                            TextSpan(
                              text: '(Optional)',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(
                                    0xFF969AB8), // Different color for "(Optional)"
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // File picker and date picker would go here
                  SizedBox(height: 10.h),
                  CustomFilePicker(
                    hintText: 'Upload Files',
                    labelText: 'Uploaded Files',
                    selectedFile: _selectedFile,
                    onFilePicked: (fileName) {
                      setState(() {
                        _selectedFile = fileName;
                      });
                    },
                  ),
                  SizedBox(height: 15.h),
                  CustomDatePicker(
                    controller: _dateController,
                    hintText: 'Select Deadline',
                    labelText: 'Selected Deadline',
                    onDateSelected: (date) {
                      setState(() {
                        _dateController.text =
                            DateFormat('dd/MM/yyyy').format(date);
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 140.h),
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
                    text: 'Next',
                    backgroundColor: const Color(0xFFED7902),
                    textColor: Colors.white,
                    onPressed: () {
                      // Handle form submission
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AssignTaskScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              // Action Buttons
            ],
          )),

      //)
    );
  }
}

void showCalendarBottomSheet(BuildContext context, DateTime initialDate,
    Function(DateTime) onDateSelected) {
  // Ensure initialDate is not before current date
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(Duration(days: 1));
  final validInitialDate = initialDate.isBefore(tomorrow)
      ? tomorrow // Set to tomorrow if initialDate is today or earlier
      : initialDate;

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(36.r)),
    ),
    builder: (context) => CalendarBottomSheet(
      initialDate: validInitialDate,
      onDateSelected: onDateSelected,
    ),
  );
}

class CalendarBottomSheet extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarBottomSheet({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  _CalendarBottomSheetState createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  late DateTime selectedDate;
  late DateTime currentDate;
  late DateTime firstSelectableDate;

  @override
  void initState() {
    super.initState();
    // Set current date to today at midnight for comparison
    currentDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    firstSelectableDate = currentDate.add(Duration(days: 1));

    // Make sure selectedDate is not before currentDate
    if (widget.initialDate.isBefore(firstSelectableDate)) {
      selectedDate = firstSelectableDate;
    } else {
      selectedDate = widget.initialDate;
    }
  }

  void _changeMonth(int offset) {
    setState(() {
      selectedDate = DateTime(
          selectedDate.year, selectedDate.month + offset, selectedDate.day);
    });
  }

  // bool _isDateDisabled(DateTime date) {
  //   return date.isBefore(currentDate);
  // }

  bool _isDateDisabled(DateTime date) {
    // Disable both past dates and the current date
    return !date.isAfter(currentDate);
  }

  @override
  Widget build(BuildContext context) {
    final currentMonth = DateFormat('MMMM yyyy').format(selectedDate);
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDayOfMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0);
    final days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    final firstWeekdayOfMonth = firstDayOfMonth.weekday % 7;
    final totalDays = firstWeekdayOfMonth + lastDayOfMonth.day;
    final totalWeeks = ((totalDays + 6) ~/ 7);

    return Container(
      padding: EdgeInsets.all(24.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            //height: 4.h,
            width: 164.w,
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(22.r),
            ),
          ),
          SizedBox(height: 20.h),
          // Month navigation row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left, color: Colors.black),
                // Disable going back if we're in the current month
                onPressed: selectedDate.year == currentDate.year &&
                        selectedDate.month == currentDate.month
                    ? null
                    : () => _changeMonth(-1),
              ),
              Text(
                currentMonth,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_right, color: Colors.black),
                onPressed: () => _changeMonth(1),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Days of the week header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.map((day) {
              final currentWeekday = selectedDate.weekday % 7;
              final isSelectedDay = days.indexOf(day) == currentWeekday;

              return Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        isSelectedDay ? Color(0xFFED7902) : Colors.transparent,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isSelectedDay ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 8.h),
          // Calendar grid
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 7,
            childAspectRatio: 1.0,
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 8.w,
            children: List.generate(totalWeeks * 7, (index) {
              final dayOffset = index - firstWeekdayOfMonth;
              if (dayOffset < 0 || dayOffset >= lastDayOfMonth.day) {
                return Container(); // Empty space
              }

              final date = DateTime(
                  selectedDate.year, selectedDate.month, dayOffset + 1);

              final isDisabled = _isDateDisabled(date);
              final isSelected = selectedDate.year == date.year &&
                  selectedDate.month == date.month &&
                  selectedDate.day == date.day;

              return InkWell(
                onTap: isDisabled
                    ? null
                    : () {
                        setState(() {
                          selectedDate = date;
                        });
                        widget.onDateSelected(selectedDate);
                        Navigator.pop(context);
                      },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Color(0xFFED7902)
                        : (isDisabled ? Colors.grey.shade200 : Colors.white),
                    shape: BoxShape.circle,
                    // border: isDisabled && !isSelected
                    //     ? Border.all(color: Colors.grey.withOpacity(0.5))
                    //     : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "${dayOffset + 1}",
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDisabled
                              ? Colors.grey.withOpacity(0.5)
                              : Colors.black),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
