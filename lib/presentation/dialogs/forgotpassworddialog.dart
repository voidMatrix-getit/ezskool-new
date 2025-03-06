import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // Allows dismissal by tapping outside the dialog
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Match the given border-radius
        ),
        child: Container(
          width: 292,
          height: 342,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Stack(
            children: [
              // Close button
              Positioned(
                right: 8.0,
                top: 8.0,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    size: 24,
                    color: Colors.black54,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 60), // Space below the close button
                  // Circle with error icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFED7902),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      size: 32, // Adjust icon size if necessary
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16), // Space between circle and text
                  // Error text
                  const Text(
                    'Error!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 1.5,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 12), // Space between text and description
                  // Error description
                  const Text(
                    'Invalid email address. Please check your email and try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      height: 1.5,
                      color: Color(0xFF949495),
                    ),
                  ),
                  const Spacer(), // Push the button to the bottom
                  // OK Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog on button press
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFED7902),
                      minimumSize: const Size(99, 37),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: 0.4,
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

  );
}

void showResetPasswordDialogSuccess(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // Allows dismissal by tapping outside the dialog
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Match the given border-radius
        ),
        child: Container(
          width: 292,
          height: 342,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Stack(
            children: [
              // Close button
              Positioned(
                right: 8.0,
                top: 8.0,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    size: 24,
                    color: Colors.black54,
                  ),
                ),
              ),
              // Image icon
              Positioned(
                top: 23.0,
                left: 68.0,
                right: 68.0,
                child: Icon(
                  CupertinoIcons.mail,
                  color: CupertinoColors.systemGrey,
                  size: 64,
                ),
              ),
              // Success message
              Positioned(
                top: 147.0,
                left: 0,
                right: 0,
                child: const Text(
                  'Link Sent Successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    height: 1.5,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
              ),
              // Description text
              Positioned(
                top: 188.0,
                left: 0,
                right: 0,
                child: const Text(
                  'A password reset link has been sent to your email.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    height: 1.5,
                    color: Color(0xFF949495),
                  ),
                ),
              ),
              // OK Button - Centered at the bottom
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog on button press
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFED7902),
                      minimumSize: const Size(99, 37),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
