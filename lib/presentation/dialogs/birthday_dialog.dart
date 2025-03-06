import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//below code works
class SortOptionsDialog extends StatefulWidget {
  final Offset position;
  final void Function(bool isAscending, bool isByRollNo) onSortChanged;
  final VoidCallback onClose;
  final Color themeColor;

  const SortOptionsDialog({
    super.key,
    required this.position,
    required this.onSortChanged,
    required this.onClose,
    required this.themeColor,
  });

  @override
  _SortOptionsDialogState createState() => _SortOptionsDialogState();
}

class _SortOptionsDialogState extends State<SortOptionsDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool isAscending = true;
  bool isByRollNo = true;
  bool isRollNoAscending = true;
  bool isNameAscending = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1), // Starts slightly below
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx + 120, // Adjusted for right-side alignment
      top: widget.position.dy + 200, // Below the filter button
      child: Material(
        color: Colors.transparent,
        child: Container(
            width: 256.w,
            height: 220.h,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: SingleChildScrollView(
              child: Column(
                // mainAxisSize: MainAxisSize,
                children: [
                  _buildHeader(),
                  const Divider(),
                  _buildOption("Roll No", true),
                  const Divider(),
                  _buildOption("Name", false),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: Text("Sort by", style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildOption(String text, bool isRollNo) {
    bool isSelected = isByRollNo == isRollNo;
    bool isAscending = isRollNo ? isRollNoAscending : isNameAscending;

    return GestureDetector(
      onTap: () {
        setState(() => isByRollNo = isRollNo);
        widget.onSortChanged(
            isByRollNo, isByRollNo ? isRollNoAscending : isNameAscending);
      },
      child: Container(
        color: isSelected ? Color(0xFFEFEFF1) : Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Radio<bool>(
                  value: isRollNo,
                  groupValue: isByRollNo,
                  activeColor: widget.themeColor,
                  onChanged: (value) {
                    setState(() => isByRollNo = value!);
                    widget.onSortChanged(isByRollNo,
                        isByRollNo ? isRollNoAscending : isNameAscending);
                  },
                ),
                Text(
                  text,
                  style: TextStyle(
                    color: isSelected ? widget.themeColor : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                // Single arrow button
                IconButton(
                  icon: Icon(
                    isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isSelected
                        ? widget.themeColor
                        : Colors.grey, // Highlight arrow only if selected
                  ),
                  onPressed: () {
                    setState(() {
                      if (isRollNo) {
                        isRollNoAscending = !isRollNoAscending;
                      } else {
                        isNameAscending = !isNameAscending;
                      }
                    });
                    widget.onSortChanged(isByRollNo,
                        isRollNo ? isRollNoAscending : isNameAscending);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class SortOptionsDialog extends StatefulWidget {
//   final Offset position;
//   final void Function(bool isRollNo, bool isAscending) onSortChanged;
//   final VoidCallback onClose;
//   final Color themeColor;
//
//   const SortOptionsDialog({
//     Key? key,
//     required this.position,
//     required this.onSortChanged,
//     required this.onClose,
//     required this.themeColor,
//   }) : super(key: key);
//
//   @override
//   _SortOptionsDialogState createState() => _SortOptionsDialogState();
// }
//
// class _SortOptionsDialogState extends State<SortOptionsDialog>
//     with SingleTickerProviderStateMixin {
//   bool isByRollNo = true;
//   bool isRollNoAscending = true;
//   bool isNameAscending = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: widget.position.dx + 170,
//       top: widget.position.dy + 200,
//       child:
//     );
//   }
//
//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//       child: Text("Sort by", style: TextStyle(fontWeight: FontWeight.bold)),
//     );
//   }
//
//   Widget _buildOption(String text, bool isRollNo) {
//     bool isSelected = isByRollNo == isRollNo;
//     return GestureDetector(
//       onTap: () {
//         setState(() => isByRollNo = isRollNo);
//         widget.onSortChanged(isByRollNo, isByRollNo ? isRollNoAscending : isNameAscending);
//       },
//       child: Container(
//         color: isSelected ? widget.themeColor.withOpacity(0.2) : Colors.transparent,
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Radio<bool>(
//                   value: isRollNo,
//                   groupValue: isByRollNo,
//                   activeColor: widget.themeColor,
//                   onChanged: (value) {
//                     setState(() => isByRollNo = value!);
//                     widget.onSortChanged(isByRollNo, isByRollNo ? isRollNoAscending : isNameAscending);
//                   },
//                 ),
//                 Text(
//                   text,
//                   style: TextStyle(
//                     color: isSelected ? widget.themeColor : Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     Icons.arrow_upward,
//                     color: (isRollNo ? isRollNoAscending : isNameAscending) ? widget.themeColor : Colors.grey,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       if (isRollNo) {
//                         isRollNoAscending = true;
//                       } else {
//                         isNameAscending = true;
//                       }
//                     });
//                     widget.onSortChanged(isByRollNo, isRollNo ? isRollNoAscending : isNameAscending);
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     Icons.arrow_downward,
//                     color: (isRollNo ? !isRollNoAscending : !isNameAscending) ? widget.themeColor : Colors.grey,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       if (isRollNo) {
//                         isRollNoAscending = false;
//                       } else {
//                         isNameAscending = false;
//                       }
//                     });
//                     widget.onSortChanged(isByRollNo, isRollNo ? isRollNoAscending : isNameAscending);
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// void showSortOptions(BuildContext context, Offset position) {
//   OverlayEntry? overlayEntry;
//
//   overlayEntry = OverlayEntry(
//     builder: (context) => Stack(
//       children: [
//         GestureDetector(
//           onTap: () => overlayEntry?.remove(), // Dismiss when tapped outside
//           child: Container(
//             color: Colors.transparent,
//             width: double.infinity,
//             height: double.infinity,
//           ),
//         ),
//         SortOptionsDialog(
//           position: position,
//           themeColor: Color(0xFFED7902), // Change to your app's theme color
//           onSortChanged: (isByRollNo, isAscending) {
//
//             overlayEntry?.remove();
//           },
//           onClose: () => overlayEntry?.remove(),
//         ),
//       ],
//     ),
//   );
//
//   Overlay.of(context).insert(overlayEntry);
// }


// Add these sorting methods to your _StudentListScreenState class
// void _sortStudentsByRollNo(bool isAscending) {
//   final stvm = Provider.of<StudentViewModel>(context, listen: false);
//   List<Student> sortedStudents = List.from(stvm.students);
//
//   sortedStudents.sort((a, b) => a.rollNo.compareTo(b.rollNo));
//
//   if (!isAscending) {
//     sortedStudents = sortedStudents.reversed.toList();
//   }
//
//   // Update the view model or local state with sorted students
//   // Depending on your state management approach
//   stvm.updateStudentList(sortedStudents);
// }
//
// void _sortStudentsByName(bool isAscending) {
//   final stvm = Provider.of<StudentViewModel>(context, listen: false);
//   List<Student> sortedStudents = List.from(stvm.students);
//
//   sortedStudents.sort((a, b) => a.name.compareTo(b.name));
//
//   if (!isAscending) {
//     sortedStudents = sortedStudents.reversed.toList();
//   }
//
//   // Update the view model or local state with sorted students
//   stvm.updateStudentList(sortedStudents);
// }



// import 'package:flutter/material.dart';
//
// class SortOptionsDialog extends StatefulWidget {
//   final Offset position;
//   final void Function(bool isAscending, bool isByRollNo) onSortChanged;
//   final VoidCallback onClose;
//   final Color themeColor;
//
//   const SortOptionsDialog({
//     Key? key,
//     required this.position,
//     required this.onSortChanged,
//     required this.onClose,
//     required this.themeColor,
//   }) : super(key: key);
//
//   @override
//   _SortOptionsDialogState createState() => _SortOptionsDialogState();
// }
//
// class _SortOptionsDialogState extends State<SortOptionsDialog>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _slideAnimation;
//   bool isAscending = true;
//   bool isByRollNo = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.1), // Slightly below
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//
//     _controller.forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.reverse().then((_) => _controller.dispose());
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: widget.position.dx + 170,
//       top: widget.position.dy + 200,
//       child: Material(
//         color: Colors.transparent,
//         child: SlideTransition(
//           position: _slideAnimation,
//           child: AnimatedOpacity(
//             opacity: 1.0,
//             duration: const Duration(milliseconds: 300),
//             child: GestureDetector(
//               onTap: () {}, // Prevent closing when tapping inside
//               child: Container(
//                 width: 200,
//                 padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       "Sort by",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     _buildToggleButton("Roll No", true),
//                     const SizedBox(height: 8),
//                     _buildToggleButton("Name", false),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildToggleButton(String text, bool isRollNo) {
//     bool isSelected = isByRollNo == isRollNo;
//     return GestureDetector(
//       onTap: () {
//         setState(() => isByRollNo = isRollNo);
//         widget.onSortChanged(isAscending, isByRollNo);
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? widget.themeColor : Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: widget.themeColor),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               text,
//               style: TextStyle(
//                 color: isSelected ? Colors.white : widget.themeColor,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             IconButton(
//               icon: Icon(
//                 isAscending ? Icons.arrow_upward : Icons.arrow_downward,
//                 color: isSelected ? Colors.white : widget.themeColor,
//               ),
//               onPressed: () {
//                 setState(() => isAscending = !isAscending);
//                 widget.onSortChanged(isAscending, isByRollNo);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





// void showSortOptions(BuildContext context, Offset position) {
//   OverlayEntry? overlayEntry;
//
//   overlayEntry = OverlayEntry(
//     builder: (context) => Stack(
//       children: [
//         GestureDetector(
//           onTap: () => overlayEntry?.remove(), // Dismiss when tapped outside
//           child: Container(
//             color: Colors.transparent,
//             width: double.infinity,
//             height: double.infinity,
//           ),
//         ),
//         SortOptionsDialog(
//           position: position,
//           themeColor: Color(0xFFED7902), // Change to your app's theme color
//           onSortChanged: (isAscending, isByRollNo) {
//             // Apply Sorting Logic Here
//           },
//           onClose: () => overlayEntry?.remove(),
//         ),
//       ],
//     ),
//   );
//
//   Overlay.of(context).insert(overlayEntry);
// }
//
//
//






//this latest
// class SortOptionsDialog extends StatefulWidget {
//   final Offset position;
//   final void Function(bool isRollNo, bool isAscending) onSortChanged;
//   final VoidCallback onClose;
//   final Color themeColor;
//
//   const SortOptionsDialog({
//     Key? key,
//     required this.position,
//     required this.onSortChanged,
//     required this.onClose,
//     required this.themeColor,
//   }) : super(key: key);
//
//   @override
//   _SortOptionsDialogState createState() => _SortOptionsDialogState();
// }
//
// class _SortOptionsDialogState extends State<SortOptionsDialog>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _slideAnimation;
//
//   // Track sorting state for both roll number and name
//   bool _isRollNoSelected = true;
//   bool _isRollNoAscending = true;
//   bool _isNameAscending = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 300),
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: Offset(0, 0.1), // Starts slightly below
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//
//     _controller.forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: widget.position.dx + 120, // Adjusted for right-side alignment
//       top: widget.position.dy + 200, // Below the filter button
//       child: Material(
//         color: Colors.transparent,
//         child: Container(
//           width: 256,
//           height: 220,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
//             borderRadius: BorderRadius.circular(6),
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 _buildHeader(),
//                 const Divider(),
//                 _buildSortOption("Roll No", true),
//                 const Divider(),
//                 _buildSortOption("Name", false),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//       child: Text("Sort by", style: TextStyle(fontWeight: FontWeight.bold)),
//     );
//   }
//
//   Widget _buildSortOption(String text, bool isRollNo) {
//     // Determine if this option is currently selected
//     bool isSelected = _isRollNoSelected == isRollNo;
//
//     // Determine the current ascending state for this option
//     bool isAscending = isRollNo ? _isRollNoAscending : _isNameAscending;
//
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           // Update the selected option
//           _isRollNoSelected = isRollNo;
//
//           // Trigger sort changed callback with current selection
//           widget.onSortChanged(
//               _isRollNoSelected,
//               _isRollNoSelected ? _isRollNoAscending : _isNameAscending
//           );
//         });
//       },
//       child: Container(
//         color: isSelected ? widget.themeColor.withOpacity(0.2) : Colors.transparent,
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Radio<bool>(
//                   value: isRollNo,
//                   groupValue: _isRollNoSelected,
//                   activeColor: widget.themeColor,
//                   onChanged: (value) {
//                     setState(() {
//                       _isRollNoSelected = value!;
//
//                       // Trigger sort changed callback
//                       widget.onSortChanged(
//                           _isRollNoSelected,
//                           _isRollNoSelected ? _isRollNoAscending : _isNameAscending
//                       );
//                     });
//                   },
//                 ),
//                 Text(
//                   text,
//                   style: TextStyle(
//                     color: isSelected ? widget.themeColor : Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             IconButton(
//               icon: Icon(
//                 isAscending ? Icons.arrow_upward : Icons.arrow_downward,
//                 color: isSelected ? widget.themeColor : Colors.grey,
//               ),
//               onPressed: () {
//                 setState(() {
//                   // Toggle ascending/descending for the specific option
//                   if (isRollNo) {
//                     _isRollNoAscending = !_isRollNoAscending;
//                   } else {
//                     _isNameAscending = !_isNameAscending;
//                   }
//
//                   // Trigger sort changed callback
//                   widget.onSortChanged(
//                       _isRollNoSelected,
//                       _isRollNoSelected ? _isRollNoAscending : _isNameAscending
//                   );
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



//
//
// void showSortOptions(BuildContext context, Offset position, Color themeColor) {
//   OverlayEntry? overlayEntry;
//
//   overlayEntry = OverlayEntry(
//     builder: (context) => Stack(
//       children: [
//         // Background tap to dismiss
//         GestureDetector(
//           onTap: () => overlayEntry?.remove(),
//           child: Container(
//             color: Colors.transparent,
//             width: double.infinity,
//             height: double.infinity,
//           ),
//         ),
//         // Sorting Options Dialog
//         SortOptionsDialog(
//           position: position,
//           themeColor: themeColor,
//           onSortChanged: (isAscending, isByRollNo) {
//             // Apply Sorting Logic Here
//           },
//           onClose: () => overlayEntry?.remove(),
//         ),
//       ],
//     ),
//   );
//
//   Overlay.of(context).insert(overlayEntry);
// }





// import 'package:flutter/material.dart';
//
//
//
// void showSortOptions(BuildContext context, Offset position) {
//   OverlayEntry? overlayEntry;
//
//   overlayEntry = OverlayEntry(
//     builder: (context) => Stack(
//       children: [
//         GestureDetector(
//           onTap: () {
//             overlayEntry?.remove();
//           },
//           child: Container(
//             color: Colors.transparent, // Dismiss when tapped outside
//             width: double.infinity,
//             height: double.infinity,
//           ),
//         ),
//         SortOptionsDialog(
//           position: position,
//           onSortChanged: (isAscending, isByRollNo) {
//             // Apply Sorting Logic Here
//           },
//           onClose: () => overlayEntry?.remove(),
//         ),
//       ],
//     ),
//   );
//
//   Overlay.of(context).insert(overlayEntry);
// }
//
//
//
// class SortOptionsDialog extends StatefulWidget {
//   final Offset position;
//   final void Function(bool isAscending, bool isByRollNo) onSortChanged;
//   final VoidCallback onClose;
//
//   const SortOptionsDialog({
//     Key? key,
//     required this.position,
//     required this.onSortChanged,
//     required this.onClose,
//   }) : super(key: key);
//
//   @override
//   _SortOptionsDialogState createState() => _SortOptionsDialogState();
// }
//
// class _SortOptionsDialogState extends State<SortOptionsDialog>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _slideAnimation;
//   bool isAscending = true;
//   bool isByRollNo = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 300),
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: Offset(0, 0.1), // Slightly below
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//
//     _controller.forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.reverse().then((_) => _controller.dispose());
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: widget.position.dx + 170,
//       top: widget.position.dy + 200,
//       child: Material(
//         color: Colors.transparent,
//         child: SlideTransition(
//           position: _slideAnimation,
//           child: AnimatedOpacity(
//             opacity: 1.0,
//             duration: Duration(milliseconds: 300),
//             child: GestureDetector(
//               onTap: () {}, // Prevent closing when tapping inside
//               child: Container(
//                 width: 200,
//                 padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("Sort by", style: TextStyle(fontWeight: FontWeight.bold)),
//                         Switch(
//                           value: isByRollNo,
//                           onChanged: (value) {
//                             setState(() => isByRollNo = value);
//                             widget.onSortChanged(isAscending, isByRollNo);
//                           },
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(isByRollNo ? "Roll No" : "Name"),
//                         IconButton(
//                           icon: Icon(
//                             isAscending ? Icons.arrow_downward : Icons.arrow_upward,
//                             color: Colors.black,
//                           ),
//                           onPressed: () {
//                             setState(() => isAscending = !isAscending);
//                             widget.onSortChanged(isAscending, isByRollNo);
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
