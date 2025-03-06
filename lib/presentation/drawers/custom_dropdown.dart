import 'package:flutter/material.dart';

class DropdownBottomSheet extends StatelessWidget {
  final String dropdownType;

  const DropdownBottomSheet({super.key, required this.dropdownType});

  // A helper method to create the dropdown items dynamically
  Widget _buildDropdownItems() {
    return Column(
      children: [
        // Curved Line
        Container(
          width: 311,
          height: 4,
          decoration: BoxDecoration(
            color: Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(22),
          ),
        ),

        SizedBox(height: 16), // Spacing

        // "Select Standard" Text
        Text(
          'Select Standard',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            color: Color(0xFF181818),
          ),
        ),

        SizedBox(height: 16), // Spacing

        // Standard Box Layout
        GridView.builder(
          shrinkWrap: true,
          itemCount: 10, // Number of boxes for Standard
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                // Handle box tap
              },
              child: Container(
                height: 51,
                decoration: BoxDecoration(
                  color: Color(0xFFED7902),
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
                    '${index + 1}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Color(0xFFFAECEC),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        SizedBox(height: 32), // Spacing

        // "Select Division" Text
        Text(
          'Select Division',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            color: Color(0xFF181818),
          ),
        ),

        SizedBox(height: 16), // Spacing

        // Division Box Layout (A, B, C)
        GridView.builder(
          shrinkWrap: true,
          itemCount: 3, // Number of boxes for Division
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                // Handle box tap
              },
              child: Container(
                height: 51,
                decoration: BoxDecoration(
                  color: Color(0xFFED7902),
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
                    ['A', 'B', 'C'][index], // Divisions A, B, C
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Color(0xFFFAECEC),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],


    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Container(
            height: 4,
            width: 162,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(22),
            ),
          ),
          _buildDropdownItems(),
        ],
      ),
    );
  }
}






//
// class BottomSheetDropdown extends StatefulWidget {
//   final String title;  // Accepts "Select Standard" or "Select Division"
//   final List<String> options;
//
//   BottomSheetDropdown({required this.title, required this.options});
//
//   @override
//   _BottomSheetDropdownState createState() => _BottomSheetDropdownState();
// }
//
// class _BottomSheetDropdownState extends State<BottomSheetDropdown> {
//   bool isOpen = false;
//
//   void _toggleDropdown() {
//     setState(() {
//       isOpen = !isOpen;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _toggleDropdown,
//       child: Material(
//         color: Colors.transparent,
//         child: Stack(
//           children: [
//             // Dimmed background when bottom sheet is open
//             if (isOpen)
//               Positioned.fill(
//                 child: Container(
//                   color: Colors.black.withOpacity(0.3),  // Dimming effect
//                 ),
//               ),
//             // Bottom Sheet Drawer
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: AnimatedContainer(
//                 duration: Duration(milliseconds: 300),
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(36),
//                     topRight: Radius.circular(36),
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // Curved line at the top of the bottom sheet
//                     ClipPath(
//                       clipper: CurvedTopClipper(),
//                       child: Container(
//                         height: 4,
//                         color: Colors.grey[300],
//                         width: 162,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     // Title
//                     Text(
//                       widget.title,
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontSize: 18,
//                         fontWeight: FontWeight.w400,
//                         color: Color(0xFF181818),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     // Boxes (Clickable)
//                     Wrap(
//                       spacing: 20,
//                       children: widget.options
//                           .map((option) => ElevatedBox(option: option))
//                           .toList(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Arrow Button that toggles direction
//             Positioned(
//               top: 16,
//               right: 16,
//               child: IconButton(
//                 icon: Icon(
//                   isOpen ? Icons.arrow_right : Icons.arrow_drop_down,
//                   color: Colors.black,
//                 ),
//                 onPressed: _toggleDropdown,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ElevatedBox extends StatelessWidget {
//   final String option;
//
//   ElevatedBox({required this.option});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 58,
//       height: 51,
//       decoration: BoxDecoration(
//         color: Theme.of(context).primaryColor,  // Using app theme color
//         borderRadius: BorderRadius.circular(5),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.25),
//             offset: Offset(0, 2),
//             blurRadius: 4,
//           ),
//         ],
//       ),
//       child: Center(
//         child: Text(
//           option,
//           style: TextStyle(
//             color: Colors.white,
//             fontFamily: 'Poppins',
//             fontSize: 24,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class CurvedTopClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     path.lineTo(0, 0);
//     path.quadraticBezierTo(size.width / 2, -10, size.width, 0);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       body: Center(
//         child: BottomSheetDropdown(
//           title: 'Select Standard',
//           options: List.generate(10, (index) => (index + 1).toString()),
//         ),
//       ),
//     ),
//   ));
// }
