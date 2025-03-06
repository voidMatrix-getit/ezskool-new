import 'package:flutter/material.dart';
import 'custom_dialog.dart';

void showInvalidQRCodeErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(
        title: 'Invalid QR Code',
        height: 400,
        message: 'The QR code is not recognized. Try scanning again or switch to manual entry.',
        buttonText: 'OK',
        icon: Icons.error,
        iconColor: Colors.red, // Red color for error
        backgroundColor: Color(0xFFED7902), // Red background
        onButtonPressed: () {
          // Custom action for retry
          Navigator.pop(context); // Close the dialog
        },
      );
    },
  );
}

void showStudentNotFoundErrorDialog(BuildContext context) {
  showDialog(
    context: context,

    builder: (BuildContext context) {
      return CustomDialog(
        title: 'Error: Student Not Found',
        height: 350,
        message: 'No matching details were found. Please verify the information and try again!',
        buttonText: 'OK',
        icon: Icons.error,
        iconColor: Colors.red, // Red color for error
        backgroundColor: Color(0xFFED7902), // Red background
        onButtonPressed: () {
          // Custom action for retry
          Navigator.pop(context); // Close the dialog
        },
      );
    },
  );
}

Widget showSignUpFailedDialog(BuildContext context, {String message = 'An error occurred during registration. Please try again later.'}) {
  return CustomDialog(
    title: 'Registration Failed',
    height: 380,
    message: message,
    buttonText: 'Retry',
    icon: Icons.error_outline,
    iconColor: Colors.red,
    backgroundColor: Color(0xFFED7902), // Consistent error theme
    onButtonPressed: () {
      Navigator.pop(context); // Close the dialog and allow retry
    },
  );
}

