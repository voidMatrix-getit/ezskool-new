import 'package:ezskool/presentation/widgets/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

import '../base_screen.dart';

// Reusable Components

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final IconData? leadingIcon;
  final Function(T?) onChanged;
  final bool enableFilter;
  final TextEditingController? controller;
  final InputDecoration? inputDecoration;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.leadingIcon,
    this.enableFilter = false,
    this.controller,
    this.inputDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      controller: controller,
      enableFilter: enableFilter,
      requestFocusOnTap: true,
      leadingIcon: leadingIcon != null ? Icon(leadingIcon) : null,
      label: Text(label),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0),
      ),
      onSelected: onChanged,
      dropdownMenuEntries: items
          .map(
            (T item) => DropdownMenuEntry<T>(
              value: item,
              label: itemLabel(item),
            ),
          )
          .toList(),
    );
  }
}

// 2. Custom Text Input Field
class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final bool isMultiLine;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.focusNode,
    this.nextFocusNode,
    this.isMultiLine = false,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    if (focusNode != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (focusNode!.hasFocus) {
          FocusScope.of(context).requestFocus(focusNode);
        }
      });
    }
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      maxLines: isMultiLine ? null : 1,
      minLines: isMultiLine ? 2 : 1,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      onFieldSubmitted: (_) {
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      },
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: 14.sp,
          color: Color(0xFF969AB8),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(
            color: Color(0xFF969AB8),
            width: 0.5.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(
            color: Color(0xFF969AB8),
            width: 0.5.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(
            color: Color(0xFF969AB8),
            width: 0.5.w,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

// 3. Custom Date Picker Field
class CustomDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(DateTime) onDateSelected;

  const CustomDatePicker({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onDateSelected,
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
      child: Container(
        width: 339.w,
        height: 38.h,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFF969AB8),
            width: 0.5.w,
          ),
          borderRadius: BorderRadius.circular(6.r),
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
                color: Color(0xFFB8BCCA),
                size: 20.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 4. Custom File Picker
class CustomFilePicker extends StatelessWidget {
  final String? selectedFile;
  final Function(String) onFilePicked;

  const CustomFilePicker({
    super.key,
    required this.selectedFile,
    required this.onFilePicked,
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
      child: Container(
        width: 339.w,
        height: 38.h,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFF969AB8),
            width: 0.5.w,
          ),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedFile ?? 'Upload Files',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: selectedFile != null
                      ? Colors.black
                      : const Color(0xFF969AB8),
                ),
              ),
              Icon(
                Icons.upload_file,
                color: Color(0xFF969AB8),
                size: 20.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 5. Custom Radio Button
class CustomRadioButton extends StatelessWidget {
  final bool isSelected;
  final String text;
  final VoidCallback onTap;
  final Color selectedColor;

  const CustomRadioButton({
    super.key,
    required this.isSelected,
    required this.text,
    required this.onTap,
    this.selectedColor = const Color(0xFFED7902),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 18.w,
            height: 18.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? selectedColor : const Color(0xFF969AB8),
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 12.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: selectedColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: Color(0xFF1E1E1E),
            ),
          ),
        ],
      ),
    );
  }
}

// 6. Custom Action Button
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

// Main Screen
class NewIntimationScreen extends StatefulWidget {
  const NewIntimationScreen({super.key});

  @override
  State<NewIntimationScreen> createState() => _NewIntimationScreenState();
}

class _NewIntimationScreenState extends State<NewIntimationScreen> {
  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Focus Nodes for managing focus
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  // Form state
  bool _allSelected = true;
  bool _classSelected = false;
  bool _studentsSelected = false;
  bool _groupSelected = false;
  String? _selectedFile;
  String? selectedIntimationType;
  String? selectedGroup;

  final List<String> groups = [
    'House A',
    'House B',
    'House C',
    'House D',
  ];

  // Dropdown options
  final List<String> intimationTypes = [
    'Holiday',
    'Event',
    'General Announcement',
    'Custom Message'
  ];

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

  @override
  Widget build(BuildContext context) {
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
                'New Intimation',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20.h),

              // Form Section - Using Expanded with SingleChildScrollView to prevent overflow
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabeledDropdownButton2(
                    label: 'Intimation Type',
                    items: intimationTypes,
                    hint: 'Intimation Type',
                    value:
                        selectedIntimationType, // your current selection (can be null)
                    onChanged: (newValue) {
                      setState(() {
                        selectedIntimationType = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 12.h),

                  // Title Field
                  CustomTextField(
                    labelText: 'Title',
                    controller: _titleController,
                    focusNode: _titleFocus,
                    nextFocusNode: _descriptionFocus,
                  ),
                  SizedBox(height: 12.h),

                  // Description Label
                  Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: Color(0xFF494949),
                    ),
                  ),
                  SizedBox(height: 5.h),

                  // Description Field
                  CustomTextField(
                    labelText: 'Add Intimation Details',
                    controller: _descriptionController,
                    focusNode: _descriptionFocus,
                    isMultiLine: true,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 12.h),

                  // Date Picker
                  CustomDatePicker(
                    controller: _dateController,
                    hintText: 'Select Date for holiday/event',
                    onDateSelected: (date) {
                      setState(() {
                        _dateController.text =
                            DateFormat('dd/MM/yyyy').format(date);
                      });
                    },
                  ),
                  SizedBox(height: 12.h),

                  // Attachments Section
                  Text(
                    'Attachments (Optional)',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: Color(0xFF494949),
                    ),
                  ),
                  SizedBox(height: 5.h),

                  // File Picker
                  CustomFilePicker(
                    selectedFile: _selectedFile,
                    onFilePicked: (fileName) {
                      setState(() {
                        _selectedFile = fileName;
                      });
                    },
                  ),
                  SizedBox(height: 12.h),

                  // Recipients Section
                  Text(
                    'Recipients',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: Color(0xFF494949),
                    ),
                  ),
                  SizedBox(height: 5.h),

                  // All Radio Button
                  CustomRadioButton(
                    isSelected: _allSelected,
                    text: 'All',
                    onTap: () {
                      setState(() {
                        _allSelected = true;
                        _classSelected = false;
                        _studentsSelected = false;
                        _groupSelected = false;
                      });
                    },
                  ),
                  SizedBox(height: 14.h),

                  // Select Class Radio Button
                  CustomRadioButton(
                    isSelected: _classSelected,
                    text: 'Select Class',
                    onTap: () {
                      setState(() {
                        _allSelected = false;
                        _classSelected = true;
                        _studentsSelected = false;
                        _groupSelected = false;
                      });
                    },
                  ),
                  if (_classSelected) ...[
                    SizedBox(height: 14.h),
                    GestureDetector(
                      onTap: () async {
                        //openBottomDrawerDropDown(context, stvm, cardData);
                      },
                      child: SizedBox(
                        width: 339.w,
                        height: 39.h,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: null,
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
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Aligns items
                              children: [
                                Text(
                                  'Select Class',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    letterSpacing: 0.01,
                                    color: const Color(0xFF969AB8),
                                    // const Color(0xFF1E1E1E)
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
                    )
                  ],
                  SizedBox(height: 14.h),

                  // Select Students Radio Button
                  CustomRadioButton(
                    isSelected: _studentsSelected,
                    text: 'Select Students',
                    onTap: () {
                      setState(() {
                        _allSelected = false;
                        _classSelected = false;
                        _studentsSelected = true;
                        _groupSelected = false;
                      });
                    },
                  ),

                  SizedBox(height: 14.h),
                  CustomRadioButton(
                    isSelected: _groupSelected,
                    text: 'Select Group',
                    onTap: () {
                      setState(() {
                        _allSelected = false;
                        _classSelected = false;
                        _studentsSelected = false;
                        _groupSelected = true;
                      });
                    },
                  ),

                  if (_groupSelected) ...[
                    SizedBox(height: 14.h),
                    LabeledDropdownButton2(
                      label: 'Selected Group',
                      items: groups,
                      hint: 'Select group',
                      value:
                          selectedGroup, // your current selection (can be null)
                      onChanged: (newValue) {
                        setState(() {
                          selectedGroup = newValue;
                        });
                      },
                    ),
                  ]
                ],
              ),

              SizedBox(height: 110.h),
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
                    text: 'Send',
                    backgroundColor: const Color(0xFFED7902),
                    textColor: Colors.white,
                    onPressed: () {
                      // Handle form submission
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

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:file_picker/file_picker.dart';
//
// import '../../../main.dart';
// import '../base_screen.dart';
//
//
//
// class DropdownMenuExample extends StatefulWidget {
//   @override
//   _DropdownMenuExampleState createState() => _DropdownMenuExampleState();
// }
//
// class _DropdownMenuExampleState extends State<DropdownMenuExample> {
//   //final GlobalKey _dropdownKey = GlobalKey();
//   final List<String> _items = ['Holiday', 'Event', 'General Announcement', 'Custom Message'];
//   String _selectedItem = 'Holiday'; // Default selection
//   String? selectedIntimationType;
//   OverlayEntry? _overlayEntry;
//   bool _isMenuOpen = false;
//
//   void _showDropdownMenu() {
//     // Close if already open
//     if (_isMenuOpen) {
//       _hideDropdownMenu();
//       return;
//     }
//
//     final RenderBox renderBox = navigatorKey.currentContext!.findRenderObject() as RenderBox;
//     final size = renderBox.size;
//     final offset = renderBox.localToGlobal(Offset.zero);
//
//     _overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         left: offset.dx,
//         top: offset.dy + size.height,
//         width: 343,
//         child: Material(
//           elevation: 4,
//           borderRadius: BorderRadius.circular(5),
//           child: Container(
//             height: 142,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(5),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.25),
//                   blurRadius: 4.3,
//                   offset: Offset(0, 1),
//                 ),
//               ],
//             ),
//             child: ListView.builder(
//               padding: EdgeInsets.zero,
//               itemCount: _items.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _selectedItem = _items[index];
//                     });
//                     _hideDropdownMenu();
//                   },
//                   child: Container(
//                     height: 32,
//                     color: _items[index] == _selectedItem
//                         ? Color(0xFFFAECEC)
//                         : Colors.white,
//                     padding: EdgeInsets.symmetric(horizontal: 14),
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       _items[index],
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         color: Color(0xFF494949),
//                         letterSpacing: 0.01,
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
//     Overlay.of(context).insert(_overlayEntry!);
//     _isMenuOpen = true;
//   }
//
//   void _hideDropdownMenu() {
//     if (_overlayEntry != null) {
//       _overlayEntry!.remove();
//       _overlayEntry = null;
//       _isMenuOpen = false;
//     }
//   }
//
//   @override
//   void dispose() {
//     if (_overlayEntry != null) {
//       _overlayEntry!.remove();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//             GestureDetector(
//               //key: _dropdownKey,
//               onTap: _showDropdownMenu,
//               child: Container(
//                 width: 339.w,
//                 height: 39.h,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(
//                     color: const Color(0xFF969AB8),
//                     width: 0.5.w,
//                   ),
//                   borderRadius: BorderRadius.circular(6.r),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 14.w),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         selectedIntimationType ?? 'Intimation Type',
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           color: selectedIntimationType != null
//                               ? Colors.black
//                               : const Color(0xFF969AB8),
//                         ),
//                       ),
//                       Icon(
//                           _isMenuOpen
//                               ? Icons.arrow_drop_up
//                               : Icons.arrow_drop_down,
//                           color: const Color(0xFF969AB8)
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//     );
//   }
// }
//
// class NewIntimationScreen extends StatefulWidget {
//   const NewIntimationScreen({Key? key}) : super(key: key);
//
//   @override
//   State<NewIntimationScreen> createState() => _NewIntimationScreenState();
// }
//
// class _NewIntimationScreenState extends State<NewIntimationScreen> {
//   final TextEditingController _dateController = TextEditingController();
//   bool _allSelected = true;
//   bool _classSelected = false;
//   bool _studentsSelected = false;
//   String? _selectedFile;
//
//   // For dropdown
//   final List<String> intimationTypes = ['Holiday', 'Event', 'General Announcement', 'Custom Message'];
//   String? selectedIntimationType;
//   String selectedIntimationTypeForColor = "Holiday";
//   bool isDropdownOpen = false;
//   late OverlayEntry? _overlayEntry;
//   final GlobalKey _dropdownKey = GlobalKey();
//
//
//   @override
//   void initState() {
//     super.initState();
//     _overlayEntry = null;
//
//   }
//
//
//
//
//   void _showDropdown() {
//     final RenderBox renderBox = _dropdownKey.currentContext!.findRenderObject() as RenderBox;
//     final position = renderBox.localToGlobal(Offset.zero);
//     final size = renderBox.size;
//
//     // Get the screen height to check for overflow
//     final screenHeight = MediaQuery.of(context).size.height;
//     final bottomSpace = screenHeight - (position.dy + size.height);
//
//     // Calculate the height of the dropdown content
//     final contentHeight = intimationTypes.length * (21.h + 14.h) + 8.h;
//
//     // Check if dropdown would overflow at the bottom
//     final willOverflow = bottomSpace < contentHeight;
//
//     // Position above if it will overflow, otherwise position below
//     final topPosition = willOverflow
//         ? position.dy - contentHeight
//         : position.dy + size.height;
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
//               itemCount: intimationTypes.length,
//               itemBuilder: (context, index) {
//                 final type = intimationTypes[index];
//                 final isSelected = selectedIntimationTypeForColor == type;
//
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedIntimationType = type;
//                       selectedIntimationTypeForColor = type;
//                       isDropdownOpen = false;
//                     });
//                     _removeDropdown();
//                   },
//                   child: Container(
//                     width: 343.w, // Full width of the dropdown
//                     height: 21.h,
//                     margin: EdgeInsets.only(bottom: 14.h),
//                     color: isSelected ? const Color(0xFFFAECEC) : Colors.transparent,
//                     child: Padding(
//                       padding: EdgeInsets.only(left: 14.w),
//                       child: Text(
//                         type,
//                         style: TextStyle(
//                           fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
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
//
//   // Method to remove dropdown
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
//     return BaseScreen(
//       resize: true,
//       child: Padding(
//         padding: EdgeInsets.all(16.r),
//         child: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: 5.h),
//               // Title
//               Text(
//                 'New Intimation',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w500,
//                   fontSize: 16.sp,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(height: 20.h),
//
//               // Form Section
//               SizedBox(
//                 width: 339.w,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Custom Intimation Type Dropdown
//
//                     GestureDetector(
//                       key: _dropdownKey,
//                       onTap: () {
//                         if (isDropdownOpen) {
//                           _removeDropdown();
//                         } else {
//                           _showDropdown();
//                         }
//                       },
//                       child: Container(
//                         width: 339.w,
//                         height: 39.h,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border.all(
//                             color: const Color(0xFF969AB8),
//                             width: 0.5.w,
//                           ),
//                           borderRadius: BorderRadius.circular(6.r),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 14.w),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 selectedIntimationType ?? 'Intimation Type',
//                                 style: TextStyle(
//                                   fontSize: 14.sp,
//                                   color: selectedIntimationType != null
//                                       ? Colors.black
//                                       : const Color(0xFF969AB8),
//                                 ),
//                               ),
//                               Icon(
//                                   isDropdownOpen
//                                       ? Icons.arrow_drop_up
//                                       : Icons.arrow_drop_down,
//                                   color: const Color(0xFF969AB8)
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 12.h),
//
//                     // Title Field
//                     // Title Field using TextFormField
//                     TextFormField(
//                       decoration: InputDecoration(
//                         labelText: 'Title',
//                         labelStyle: TextStyle(
//                           fontSize: 14.sp,
//                           color: Color(0xFF969AB8),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(6.r),
//                           borderSide: BorderSide(
//                             color: Color(0xFF969AB8),
//                             width: 0.5.w,
//                           ),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(6.r),
//                           borderSide: BorderSide(
//                             color: Color(0xFF969AB8),
//                             width: 0.5.w,
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(6.r),
//                           borderSide: BorderSide(
//                             color: Color(0xFF969AB8),
//                             width: 0.5.w,
//                           ),
//                         ),
//                         contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
//                         filled: true,
//                         fillColor: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: 12.h),
//
//                     // Rest of your form remains the same
//                     // Description Label
//                     Text(
//                       'Description',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14.sp,
//                         color: Color(0xFF494949),
//                       ),
//                     ),
//                     SizedBox(height: 5.h),
//
//                     // Description Field
//                     Container(
//                       width: 339.w,
//                       height: 56.h,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(
//                           color: const Color(0xFF969AB8),
//                           width: 0.5.w,
//                         ),
//                         borderRadius: BorderRadius.circular(6.r),
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
//                         child: TextField(
//                           maxLines: 2,
//                           decoration: InputDecoration(
//                             labelText: 'Add Intimation Details',
//                             labelStyle: TextStyle(
//                               fontSize: 14.sp,
//                               color: Color(0xFF969AB8),
//                             ),
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 12.h),
//
//                     // Date Picker
//                     GestureDetector(
//                       onTap: () async {
//                         showCalendarBottomSheet(
//                           context,
//                           _dateController.text.isEmpty
//                               ? DateTime.now()
//                               : DateFormat('dd/MM/yyyy').parse(_dateController.text),
//                               (DateTime selectedDate) {
//                             setState(() {
//                               _dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
//                             });
//                           },
//                         );
//                       },
//                       child: Container(
//                         width: 339.w,
//                         height: 38.h,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border.all(
//                             color: const Color(0xFF969AB8),
//                             width: 0.5.w,
//                           ),
//                           borderRadius: BorderRadius.circular(6.r),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 12.w),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 _dateController.text.isEmpty
//                                     ? 'Select Date for holiday/event'
//                                     : _dateController.text,
//                                 style: TextStyle(
//                                   fontSize: 14.sp,
//                                   color: _dateController.text.isEmpty
//                                       ? const Color(0xFF969AB8)
//                                       : Colors.black,
//                                 ),
//                               ),
//                               Icon(
//                                 Icons.calendar_today,
//                                 color: Color(0xFFB8BCCA),
//                                 size: 20.r,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 12.h),
//
//                     // Rest of the form continues...
//                     // Attachments Section
//                     Text(
//                       'Attachments (Optional)',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14.sp,
//                         color: Color(0xFF494949),
//                       ),
//                     ),
//                     SizedBox(height: 5.h),
//                     GestureDetector(
//                       onTap: () async {
//                         final result = await FilePicker.platform.pickFiles();
//                         if (result != null) {
//                           setState(() {
//                             _selectedFile = result.files.single.name;
//                           });
//                         }
//                       },
//                       child: Container(
//                         width: 339.w,
//                         height: 38.h,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border.all(
//                             color: const Color(0xFF969AB8),
//                             width: 0.5.w,
//                           ),
//                           borderRadius: BorderRadius.circular(6.r),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 20.w),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 _selectedFile ?? 'Upload Files',
//                                 style: TextStyle(
//                                   fontSize: 14.sp,
//                                   color: _selectedFile != null
//                                       ? Colors.black
//                                       : const Color(0xFF969AB8),
//                                 ),
//                               ),
//                               Icon(
//                                 Icons.upload_file,
//                                 color: Color(0xFF969AB8),
//                                 size: 20.r,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 12.h),
//
//                     // Recipients Section and the rest of your form remains the same...
//                     Text(
//                       'Recipients',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14.sp,
//                         color: Color(0xFF494949),
//                       ),
//                     ),
//                     SizedBox(height: 5.h),
//
//                     // All Checkbox
//                     Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _allSelected = !_allSelected;
//                               if (_allSelected) {
//                                 _classSelected = false;
//                                 _studentsSelected = false;
//                               }
//                             });
//                           },
//                           child: Container(
//                             width: 18.w,
//                             height: 18.h,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: const Color(0xFFED7902),
//                                 width: 1.w,
//                               ),
//                               borderRadius: BorderRadius.circular(13.r),
//                             ),
//                             child: _allSelected
//                                 ? Center(
//                               child: Container(
//                                 width: 12.w,
//                                 height: 12.h,
//                                 decoration: const BoxDecoration(
//                                   color: Color(0xFFED7902),
//                                   shape: BoxShape.circle,
//                                 ),
//                               ),
//                             )
//                                 : null,
//                           ),
//                         ),
//                         SizedBox(width: 8.w),
//                         Text(
//                           'All',
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             color: Color(0xFF1E1E1E),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 14.h),
//
//                     // Select Class Checkbox
//                     Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _classSelected = !_classSelected;
//                               if (_classSelected) {
//                                 _allSelected = false;
//                               }
//                             });
//                           },
//                           child: Container(
//                             width: 18.w,
//                             height: 18.h,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: const Color(0xFF969AB8),
//                                 width: 1.w,
//                               ),
//                               borderRadius: BorderRadius.circular(13.r),
//                             ),
//                             child: _classSelected
//                                 ? Center(
//                               child: Container(
//                                 width: 12.w,
//                                 height: 12.h,
//                                 decoration: const BoxDecoration(
//                                   color: Color(0xFFED7902),
//                                   shape: BoxShape.circle,
//                                 ),
//                               ),
//                             )
//                                 : null,
//                           ),
//                         ),
//                         SizedBox(width: 8.w),
//                         Text(
//                           'Select Class',
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             color: Color(0xFF1E1E1E),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 14.h),
//
//                     // Select Students Checkbox
//                     Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _studentsSelected = !_studentsSelected;
//                               if (_studentsSelected) {
//                                 _allSelected = false;
//                               }
//                             });
//                           },
//                           child: Container(
//                             width: 18.w,
//                             height: 18.h,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: const Color(0xFF969AB8),
//                                 width: 1.w,
//                               ),
//                               borderRadius: BorderRadius.circular(13),
//                             ),
//                             child: _studentsSelected
//                                 ? Center(
//                               child: Container(
//                                 width: 12.w,
//                                 height: 12.h,
//                                 decoration: const BoxDecoration(
//                                   color: Color(0xFFED7902),
//                                   shape: BoxShape.circle,
//                                 ),
//                               ),
//                             )
//                                 : null,
//                           ),
//                         ),
//                         SizedBox(width: 8.w),
//                         Text(
//                           'Select Students',
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             color: Color(0xFF1E1E1E),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               //SizedBox(height: MediaQuery.of(context).size.height * 0.12),
//               Spacer(),
//
//               // Action Buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Cancel Button
//                   Container(
//                     width: 99.w,
//                     height: 37.h,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF5F5F5),
//                       borderRadius: BorderRadius.circular(5),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.25),
//                           blurRadius: 5.1,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child: Text(
//                         'Cancel',
//                         style: TextStyle(
//                           fontFamily: 'Inter',
//                           fontWeight: FontWeight.w500,
//                           fontSize: 14.sp,
//                           color: Color(0xFF494949),
//                           letterSpacing: 0.4.w,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 9.w),
//
//                   // Submit Button
//                   Container(
//                     width: 99.w,
//                     height: 37.h,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFED7902),
//                       borderRadius: BorderRadius.circular(5),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.25),
//                           blurRadius: 5.1,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child: Text(
//                         'Send',
//                         style: TextStyle(
//                           fontFamily: 'Inter',
//                           fontWeight: FontWeight.w500,
//                           fontSize: 14.sp,
//                           color: Colors.white,
//                           letterSpacing: 0.4.w,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _removeDropdown();
//     _dateController.dispose();
//     super.dispose();
//   }
// }

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

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:file_picker/file_picker.dart';
//
// import '../base_screen.dart';
//
// class NewIntimationScreen extends StatefulWidget {
//   const NewIntimationScreen({Key? key}) : super(key: key);
//
//   @override
//   State<NewIntimationScreen> createState() => _NewIntimationScreenState();
// }
//
// class _NewIntimationScreenState extends State<NewIntimationScreen> {
//   final TextEditingController _dateController = TextEditingController();
//   bool _allSelected = true;
//   bool _classSelected = false;
//   bool _studentsSelected = false;
//   String? _selectedFile;
//
//   @override
//   Widget build(BuildContext context) {
//     return BaseScreen(
//       resize: true,
//           child: Padding(
//             padding: EdgeInsets.all(16.r),
//             child: Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 5.h),
//                   // Title
//                   Text(
//                     'New Intimation',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 16.sp,
//                       color: Colors.black,
//                     ),
//                   ),
//                   SizedBox(height: 20.h),
//
//                   // Form Section
//                   SizedBox(
//                     width: 339.w,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Intimation Type Dropdown
//                         Container(
//                           width: 339,
//                           height: 39,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             border: Border.all(
//                               color: const Color(0xFF969AB8),
//                               width: 0.5,
//                             ),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 14),
//                             child: DropdownButtonHideUnderline(
//                               child: DropdownButton<String>(
//                                 hint: const Text(
//                                   'Intimation Type',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Color(0xFF969AB8),
//                                   ),
//                                 ),
//                                 isExpanded: true,
//                                 icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF969AB8)),
//                                 items: <String>['Announcement', 'Holiday', 'Event', 'Notice']
//                                     .map<DropdownMenuItem<String>>((String value) {
//                                   return DropdownMenuItem<String>(
//                                     value: value,
//                                     child: Text(value),
//                                   );
//                                 }).toList(),
//                                 onChanged: (String? newValue) {},
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 12.h),
//
//                         // Title Field
//                         Container(
//                           width: 339,
//                           height: 39,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             border: Border.all(
//                               color: const Color(0xFF969AB8),
//                               width: 0.5,
//                             ),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
//                             child: TextField(
//                               decoration: InputDecoration(
//                                 hintText: 'Title',
//                                 hintStyle: TextStyle(
//                                   fontSize: 14,
//                                   color: Color(0xFF969AB8),
//                                 ),
//                                 border: InputBorder.none,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 12),
//
//                         // Description Label
//                          Text(
//                           'Description',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14,
//                             color: Color(0xFF494949),
//                           ),
//                         ),
//                         SizedBox(height: 5),
//
//                         // Description Field
//                         Container(
//                           width: 339,
//                           height: 56,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             border: Border.all(
//                               color: const Color(0xFF969AB8),
//                               width: 0.5,
//                             ),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
//                             child: TextField(
//                               maxLines: 2,
//                               decoration: InputDecoration(
//                                 hintText: 'Add Intimation Details',
//                                 hintStyle: TextStyle(
//                                   fontSize: 14,
//                                   color: Color(0xFF969AB8),
//                                 ),
//                                 border: InputBorder.none,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//
//                         // Date Picker
//                         GestureDetector(
//                           onTap: () async {
//                             final DateTime? picked = await showDatePicker(
//                               context: context,
//                               initialDate: DateTime.now(),
//                               firstDate: DateTime.now(),
//                               lastDate: DateTime(2100),
//                             );
//                             if (picked != null) {
//                               setState(() {
//                                 _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
//                               });
//                             }
//                           },
//                           child: Container(
//                             width: 339,
//                             height: 38,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(
//                                 color: const Color(0xFF969AB8),
//                                 width: 0.5,
//                               ),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 12),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     _dateController.text.isEmpty
//                                         ? 'Select Date for holiday/event'
//                                         : _dateController.text,
//                                     style: TextStyle(
//                                       fontFamily: 'Poppins',
//                                       fontSize: 14,
//                                       color: _dateController.text.isEmpty
//                                           ? const Color(0xFF969AB8)
//                                           : Colors.black,
//                                     ),
//                                   ),
//                                   const Icon(
//                                     Icons.calendar_today,
//                                     color: Color(0xFFB8BCCA),
//                                     size: 20,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//
//                         // Attachments Section
//                         const Text(
//                           'Attachments (Optional)',
//                           style: TextStyle(
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14,
//                             color: Color(0xFF494949),
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         GestureDetector(
//                           onTap: () async {
//                             final result = await FilePicker.platform.pickFiles();
//                             if (result != null) {
//                               setState(() {
//                                 _selectedFile = result.files.single.name;
//                               });
//                             }
//                           },
//                           child: Container(
//                             width: 339,
//                             height: 38,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(
//                                 color: const Color(0xFF969AB8),
//                                 width: 0.5,
//                               ),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 20),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     _selectedFile ?? 'Upload Files',
//                                     style: TextStyle(
//                                       fontFamily: 'Poppins',
//                                       fontSize: 14,
//                                       color: _selectedFile != null
//                                           ? Colors.black
//                                           : const Color(0xFF969AB8),
//                                     ),
//                                   ),
//                                   const Icon(
//                                     Icons.upload_file,
//                                     color: Color(0xFF969AB8),
//                                     size: 20,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//
//                         // Recipients Section
//                         const Text(
//                           'Recipients',
//                           style: TextStyle(
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14,
//                             color: Color(0xFF494949),
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//
//                         // All Checkbox
//                         Row(
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   _allSelected = !_allSelected;
//                                   if (_allSelected) {
//                                     _classSelected = false;
//                                     _studentsSelected = false;
//                                   }
//                                 });
//                               },
//                               child: Container(
//                                 width: 18,
//                                 height: 18,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: const Color(0xFFED7902),
//                                     width: 1,
//                                   ),
//                                   borderRadius: BorderRadius.circular(13),
//                                 ),
//                                 child: _allSelected
//                                     ? Center(
//                                   child: Container(
//                                     width: 12,
//                                     height: 12,
//                                     decoration: const BoxDecoration(
//                                       color: Color(0xFFED7902),
//                                       shape: BoxShape.circle,
//                                     ),
//                                   ),
//                                 )
//                                     : null,
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             const Text(
//                               'All',
//                               style: TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontSize: 14,
//                                 color: Color(0xFF1E1E1E),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 14),
//
//                         // Select Class Checkbox
//                         Row(
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   _classSelected = !_classSelected;
//                                   if (_classSelected) {
//                                     _allSelected = false;
//                                   }
//                                 });
//                               },
//                               child: Container(
//                                 width: 18,
//                                 height: 18,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: const Color(0xFF969AB8),
//                                     width: 1,
//                                   ),
//                                   borderRadius: BorderRadius.circular(13),
//                                 ),
//                                 child: _classSelected
//                                     ? Center(
//                                   child: Container(
//                                     width: 12,
//                                     height: 12,
//                                     decoration: const BoxDecoration(
//                                       color: Color(0xFFED7902),
//                                       shape: BoxShape.circle,
//                                     ),
//                                   ),
//                                 )
//                                     : null,
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             const Text(
//                               'Select Class',
//                               style: TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontSize: 14,
//                                 color: Color(0xFF1E1E1E),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 14),
//
//                         // Select Students Checkbox
//                         Row(
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   _studentsSelected = !_studentsSelected;
//                                   if (_studentsSelected) {
//                                     _allSelected = false;
//                                   }
//                                 });
//                               },
//                               child: Container(
//                                 width: 18,
//                                 height: 18,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: const Color(0xFF969AB8),
//                                     width: 1,
//                                   ),
//                                   borderRadius: BorderRadius.circular(13),
//                                 ),
//                                 child: _studentsSelected
//                                     ? Center(
//                                   child: Container(
//                                     width: 12,
//                                     height: 12,
//                                     decoration: const BoxDecoration(
//                                       color: Color(0xFFED7902),
//                                       shape: BoxShape.circle,
//                                     ),
//                                   ),
//                                 )
//                                     : null,
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             const Text(
//                               'Select Students',
//                               style: TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontSize: 14,
//                                 color: Color(0xFF1E1E1E),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   SizedBox(height: MediaQuery.of(context).size.height * 0.12),
//
//                   // Action Buttons
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Cancel Button
//                       Container(
//                         width: 99,
//                         height: 37,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF5F5F5),
//                           borderRadius: BorderRadius.circular(5),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.25),
//                               blurRadius: 5.1,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: const Center(
//                           child: Text(
//                             'Cancel',
//                             style: TextStyle(
//                               fontFamily: 'Inter',
//                               fontWeight: FontWeight.w500,
//                               fontSize: 14,
//                               color: Color(0xFF494949),
//                               letterSpacing: 0.4,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 9),
//
//                       // Submit Button
//                       Container(
//                         width: 99,
//                         height: 37,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFED7902),
//                           borderRadius: BorderRadius.circular(5),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.25),
//                               blurRadius: 5.1,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: const Center(
//                           child: Text(
//                             'Save',
//                             style: TextStyle(
//                               fontFamily: 'Inter',
//                               fontWeight: FontWeight.w500,
//                               fontSize: 14,
//                               color: Colors.white,
//                               letterSpacing: 0.4,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _dateController.dispose();
//     super.dispose();
//   }
// }
