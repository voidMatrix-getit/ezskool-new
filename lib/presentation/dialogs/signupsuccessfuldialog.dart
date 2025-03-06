import 'package:flutter/material.dart';

import '../screens/loginscreen.dart';

// class SignUpSuccessDialog extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: Stack(
//         children: [
//           // Background blur
//           Positioned.fill(
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//               child: Container(
//                 color: Colors.black.withOpacity(0.5),
//               ),
//             ),
//           ),
//           // Dialog box
//           Positioned(
//             top: 80,
//             left: 20,
//             right: 20,
//             child: Container(
//               height: 445,
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(5),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     blurRadius: 10,
//                     offset: Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Close Button
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: IconButton(
//                       icon: Icon(Icons.close),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                   ),
//                   SizedBox(height: 30),
//                   // Green Circle with Checkmark
//                   Container(
//                     width: 64,
//                     height: 64,
//                     decoration: BoxDecoration(
//                       color: Color(0xFF0AB331),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.check,
//                       color: Colors.white,
//                       size: 32,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   // Success Text
//                   Text(
//                     'Registration Successful!',
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1E1E1E),
//                     ),
//                     textAlign: TextAlign.center, // Apply textAlign here
//                   ),
//                   SizedBox(height: 20),
//                   // First Paragraph
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     child: Text(
//                       'Thank you for the registration. Our Team will contact you soon. You can also contact us.',
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontSize: 13,
//                         color: Color(0xFF949495),
//                       ),
//                       textAlign: TextAlign.center, // Apply textAlign here
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   // Second Paragraph
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     child: Text(
//                       'Restrosoft Solutions Pvt. Ltd. GUSEC, Gujarat University Campus\nAhmedabad - 15\nContact No : 9898082227\nemail : thechiragkaria@gmail.com',
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontSize: 13,
//                         color: Color(0xFF949495),
//                       ),
//                       textAlign: TextAlign.center, // Apply textAlign here
//                     ),
//                   ),
//                   Spacer(),
//                   // OK Button
//                   ElevatedButton(
//                     onPressed: () {
//                       // Redirect to login screen
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => LoginScreen()),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFFED7902),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       minimumSize: Size(99, 37),
//                     ),
//                     child: Text(
//                       'OK',
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class SignUpSuccessDialog extends StatelessWidget {
  const SignUpSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Background blur
          // Positioned.fill(
          //   child: BackdropFilter(
          //     filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          //     child: Container(
          //       color: Colors.black.withOpacity(0.5),
          //     ),
          //   ),
          // ),
          // Dialog box
          Positioned(
            top: 80,
            left: 20,
            right: 20,
            child: Container(
              height: 550,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Close Button
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  // Green Circle with Checkmark
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Color(0xFF0AB331),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Success Text
                  Text(
                    'Inquiry submitted successfully!',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                    textAlign: TextAlign.center, // Apply textAlign here
                  ),
                  SizedBox(height: 10),
                  // First Paragraph
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Thank you for the registration. Our Team will contact you soon. You can also contact us.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Color(0xFF949495),
                      ),
                      textAlign: TextAlign.center, // Apply textAlign here
                    ),
                  ),
                  SizedBox(height: 10),
                  // Second Paragraph
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Restrosoft Solutions Pvt. Ltd. GUSEC, Gujarat University Campus\nAhmedabad - 15\nContact No : 9898082227\n\nemail : thechiragkaria@gmail.com',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Color(0xFF949495),
                      ),
                      textAlign: TextAlign.center, // Apply textAlign here
                    ),
                  ),
                  Spacer(), // Pushes the OK button to the bottom
                  // OK Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        // Redirect to login screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFED7902),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minimumSize: Size(99, 37),
                      ),
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
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
}
