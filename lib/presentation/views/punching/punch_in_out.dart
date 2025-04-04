import 'package:ezskool/presentation/dialogs/custom_dialog.dart';
import 'package:ezskool/presentation/views/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:async';

class PunchInOutScreen extends StatefulWidget {
  const PunchInOutScreen({super.key});

  @override
  State<PunchInOutScreen> createState() => _PunchInOutScreenState();
}

class _PunchInOutScreenState extends State<PunchInOutScreen> {
  // Current time and date values
  late DateTime _currentDateTime;
  late DateTime _punchInDateTime;

  // Scanner controller
  late MobileScannerController _scannerController;
  final bool _hasScanned = false;
  final bool _isScannerActive = true;

  // Timer to update current time
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentDateTime = DateTime.now();

    // Update current time every second
    // _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   setState(() {
    //     _currentDateTime = DateTime.now();
    //   });
    // });

    // For demo purposes, setting punch in time as 9:15 AM today
    final now = DateTime.now();
    _punchInDateTime = DateTime(now.year, now.month, now.day, 9, 15);

    // Initialize scanner
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    //_timer.cancel();
    _scannerController.dispose();
    super.dispose();
  }

  // Format time to AM/PM
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final formattedHour = hour > 12
        ? (hour - 12).toString()
        : (hour == 0 ? '12' : hour.toString());
    return '$formattedHour:$minute $period';
  }

  // Format date
  String _formatDate(DateTime dateTime) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  void _onDetect(BarcodeCapture capture) {
    // if (_hasScanned) return;

    // final List<Barcode> barcodes = capture.barcodes;

    // for (final barcode in barcodes) {
    //   if (barcode.rawValue != null) {
    //     _hasScanned = true;

    //     //Update punch in time to current time when QR is scanned
    //     // setState(() {
    //     //   _punchInDateTime = DateTime.now();
    //     // });

    //     // Show success message
    //     // ScaffoldMessenger.of(context).showSnackBar(
    //     //   SnackBar(
    //     //     content: Text(
    //     //         'Successfully punched in at ${_formatTime(_punchInDateTime)}'),
    //     //     backgroundColor: Colors.green,
    //     //     duration: const Duration(seconds: 3),
    //     //   ),
    //     // );

    //     Future.microtask(() {
    //       setState(() {
    //         _punchInDateTime = DateTime.now();
    //       });

    //       // Show success message
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text(
    //               'Successfully punched in at ${_formatTime(_punchInDateTime)}'),
    //           backgroundColor: Colors.green,
    //           duration: const Duration(seconds: 3),
    //         ),
    //       );
    //     });

    //     break;
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      resize: true,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Punch In Time Card
              // _buildInfoCard(
              //   title1: 'Punch In Time',
              //   value1: _formatTime(_punchInDateTime),
              //   title2: 'Punch In Date',
              //   value2: _formatDate(_punchInDateTime),
              // ),
              SizedBox(height: 16.h),

              // Current Time Card
              _buildInfoCard(
                title1: 'Current Time',
                value1: _formatTime(_currentDateTime),
                title2: 'Current Date',
                value2: _formatDate(_currentDateTime),
              ),
              SizedBox(height: 40.h),

              // QR Code Scanner Section
              _buildQrScannerSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title1,
    required String value1,
    required String title2,
    required String value2,
  }) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 320.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title1,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6A7D94),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                title2,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6A7D94),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                value1,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF283D4C),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                value2,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF283D4C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQrScannerSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Make scanner responsive based on available width
        final scannerSize = constraints.maxWidth * 0.85;
        final scannerHeight = scannerSize * 1.1; // Maintain aspect ratio

        // Corner size proportional to scanner size
        final cornerSize = scannerSize * 0.2;

        return Column(
          children: [
            SizedBox(
              width: scannerSize,
              height: scannerHeight,
              child: Stack(
                children: [
                  // QR Scanner
                  ClipRRect(
                    borderRadius: BorderRadius.circular(scannerSize * 0.12),
                    child: SizedBox(
                      width: scannerSize,
                      height: scannerHeight,
                      child: MobileScanner(
                        controller: _scannerController,
                        onDetect: _onDetect,
                      ),
                    ),
                  ),

                  // Semi-transparent overlay with rounded corners
                  Container(
                    width: scannerSize,
                    height: scannerHeight,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(scannerSize * 0.12),
                    ),
                  ),

                  // Top-left corner
                  Positioned(
                    top: 0,
                    left: 0,
                    child: _buildCorner(
                      size: cornerSize,
                      isTopLeft: true,
                      color: const Color(0xFFED7902),
                    ),
                  ),

                  // Top-right corner
                  Positioned(
                    top: 0,
                    right: 0,
                    child: _buildCorner(
                      size: cornerSize,
                      isTopRight: true,
                      color: const Color(0xFFED7902),
                    ),
                  ),

                  // Bottom-left corner
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: _buildCorner(
                      size: cornerSize,
                      isBottomLeft: true,
                      color: const Color(0xFFED7902),
                    ),
                  ),

                  // Bottom-right corner
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: _buildCorner(
                      size: cornerSize,
                      isBottomRight: true,
                      color: const Color(0xFFED7902),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Place QR code within the frame',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF626262),
              ),
            ),
            SizedBox(height: 20.h),
            // Toggle torch button
            ElevatedButton.icon(
              onPressed: () {
                //_scannerController.toggleTorch();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialog(
                        title: '',
                        height: 350.h,
                        hasMessage: true,
                        message: 'Are you sure you want to log out?',
                        buttonText: 'OK',
                        icon: Icons.question_mark,
                        iconColor: Color(0xFFED7902),
                        backgroundColor: Color(0xFFED7902),
                        onButtonPressed: () {},
                      );
                    });
              },
              icon: const Icon(Icons.flashlight_on),
              label: const Text('Toggle Flashlight'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED7902),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCorner({
    required double size,
    required Color color,
    bool isTopLeft = false,
    bool isTopRight = false,
    bool isBottomLeft = false,
    bool isBottomRight = false,
  }) {
    // Calculate stroke width based on size for better scaling
    final strokeWidth = size * 0.08;

    return CustomPaint(
      size: Size(size, size),
      painter: CornerPainter(
        color: color,
        strokeWidth: strokeWidth,
        isTopLeft: isTopLeft,
        isTopRight: isTopRight,
        isBottomLeft: isBottomLeft,
        isBottomRight: isBottomRight,
      ),
    );
  }
}

class CornerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool isTopLeft;
  final bool isTopRight;
  final bool isBottomLeft;
  final bool isBottomRight;

  CornerPainter({
    required this.color,
    required this.strokeWidth,
    this.isTopLeft = false,
    this.isTopRight = false,
    this.isBottomLeft = false,
    this.isBottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Define curve parameters
    final cornerLength = size.width * 0.7; // Longer curved segments
    final curveRadius = cornerLength * 0.5;

    final path = Path();

    if (isTopLeft) {
      // Start at edge, move down
      path.moveTo(strokeWidth / 2, cornerLength);
      // Arc from left side to top side
      path.quadraticBezierTo(
        strokeWidth / 2, strokeWidth / 2, // control point at the corner
        cornerLength, strokeWidth / 2, // end point on the top edge
      );
    } else if (isTopRight) {
      // Start at right edge, move down
      path.moveTo(size.width - strokeWidth / 2, cornerLength);
      // Arc from right side to top side
      path.quadraticBezierTo(
        size.width - strokeWidth / 2,
        strokeWidth / 2, // control point at the corner
        size.width - cornerLength, strokeWidth / 2, // end point on the top edge
      );
    } else if (isBottomLeft) {
      // Start at left edge, move up
      path.moveTo(strokeWidth / 2, size.height - cornerLength);
      // Arc from left side to bottom side
      path.quadraticBezierTo(
        strokeWidth / 2,
        size.height - strokeWidth / 2, // control point at the corner
        cornerLength,
        size.height - strokeWidth / 2, // end point on the bottom edge
      );
    } else if (isBottomRight) {
      // Start at right edge, move up
      path.moveTo(size.width - strokeWidth / 2, size.height - cornerLength);
      // Arc from right side to bottom side
      path.quadraticBezierTo(
        size.width - strokeWidth / 2,
        size.height - strokeWidth / 2, // control point at the corner
        size.width - cornerLength,
        size.height - strokeWidth / 2, // end point on the bottom edge
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CornerPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.isTopLeft != isTopLeft ||
      oldDelegate.isTopRight != isTopRight ||
      oldDelegate.isBottomLeft != isBottomLeft ||
      oldDelegate.isBottomRight != isBottomRight;
}

// Improved corner painter for better responsiveness
// class CornerPainter extends CustomPainter {
//   final Color color;
//   final double strokeWidth;
//   final bool isTopLeft;
//   final bool isTopRight;
//   final bool isBottomLeft;
//   final bool isBottomRight;

//   CornerPainter({
//     required this.color,
//     required this.strokeWidth,
//     this.isTopLeft = false,
//     this.isTopRight = false,
//     this.isBottomLeft = false,
//     this.isBottomRight = false,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..strokeCap = StrokeCap.round;

//     final cornerLength = size.width * 0.8;
//     final radius = size.width * 0.3;

//     final path = Path();

//     if (isTopLeft) {
//       path.moveTo(0, radius);
//       path.arcToPoint(
//         Offset(radius, 0),
//         radius: Radius.circular(radius),
//       );
//     } else if (isTopRight) {
//       path.moveTo(size.width, radius);
//       path.arcToPoint(
//         Offset(size.width - radius, 0),
//         radius: Radius.circular(radius),
//         clockwise: false,
//       );
//     } else if (isBottomLeft) {
//       path.moveTo(0, size.height - radius);
//       path.arcToPoint(
//         Offset(radius, size.height),
//         radius: Radius.circular(radius),
//         clockwise: false,
//       );
//     } else if (isBottomRight) {
//       path.moveTo(size.width, size.height - radius);
//       path.arcToPoint(
//         Offset(size.width - radius, size.height),
//         radius: Radius.circular(radius),
//       );
//     }

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CornerPainter oldDelegate) =>
//       oldDelegate.color != color ||
//       oldDelegate.strokeWidth != strokeWidth ||
//       oldDelegate.isTopLeft != isTopLeft ||
//       oldDelegate.isTopRight != isTopRight ||
//       oldDelegate.isBottomLeft != isBottomLeft ||
//       oldDelegate.isBottomRight != isBottomRight;
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';

// class PunchInOutScreen extends StatefulWidget {
//   const PunchInOutScreen({Key? key}) : super(key: key);

//   @override
//   State<PunchInOutScreen> createState() => _PunchInOutScreenState();
// }

// class _PunchInOutScreenState extends State<PunchInOutScreen> {
//   // Current time and date values
//   late DateTime _currentDateTime;
//   late DateTime _punchInDateTime;

//   // Scanner controller
//   late MobileScannerController _scannerController;
//   bool _hasScanned = false;

//   @override
//   void initState() {
//     super.initState();
//     _currentDateTime = DateTime.now();

//     // For demo purposes, setting punch in time as 9:15 AM today
//     final now = DateTime.now();
//     _punchInDateTime = DateTime(now.year, now.month, now.day, 9, 15);

//     // Initialize scanner
//     _scannerController = MobileScannerController(
//       detectionSpeed: DetectionSpeed.normal,
//       facing: CameraFacing.back,
//       torchEnabled: false,
//     );
//   }

//   @override
//   void dispose() {
//     _scannerController.dispose();
//     super.dispose();
//   }

//   // Format time to AM/PM
//   String _formatTime(DateTime dateTime) {
//     final hour = dateTime.hour;
//     final minute = dateTime.minute.toString().padLeft(2, '0');
//     final period = hour >= 12 ? 'PM' : 'AM';
//     final formattedHour = hour > 12
//         ? (hour - 12).toString()
//         : (hour == 0 ? '12' : hour.toString());
//     return '$formattedHour:$minute $period';
//   }

//   // Format date
//   String _formatDate(DateTime dateTime) {
//     const months = [
//       'January',
//       'February',
//       'March',
//       'April',
//       'May',
//       'June',
//       'July',
//       'August',
//       'September',
//       'October',
//       'November',
//       'December'
//     ];
//     return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
//   }

//   void _onDetect(BarcodeCapture capture) {
//     if (_hasScanned) return;

//     final List<Barcode> barcodes = capture.barcodes;

//     for (final barcode in barcodes) {
//       if (barcode.rawValue != null) {
//         _hasScanned = true;

//         // Update punch in time to current time when QR is scanned
//         setState(() {
//           _punchInDateTime = DateTime.now();
//         });

//         // Show success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//                 'Successfully punched in at ${_formatTime(_punchInDateTime)}'),
//             backgroundColor: Colors.green,
//             duration: const Duration(seconds: 3),
//           ),
//         );

//         break;
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Punch In Time Card
//                 _buildInfoCard(
//                   title1: 'Punch In Time',
//                   value1: _formatTime(_punchInDateTime),
//                   title2: 'Punch In Date',
//                   value2: _formatDate(_punchInDateTime),
//                 ),
//                 SizedBox(height: 16.h),

//                 // Current Time Card
//                 _buildInfoCard(
//                   title1: 'Current Time',
//                   value1: _formatTime(_currentDateTime),
//                   title2: 'Current Date',
//                   value2: _formatDate(_currentDateTime),
//                 ),
//                 SizedBox(height: 40.h),

//                 // QR Code Scanner Section
//                 _buildQrScannerSection(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoCard({
//     required String title1,
//     required String value1,
//     required String title2,
//     required String value2,
//   }) {
//     return Container(
//       width: 299.w,
//       height: 70.h,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Text(
//                 title1,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                   color: const Color(0xFF6A7D94),
//                 ),
//               ),
//               Text(
//                 title2,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                   color: const Color(0xFF6A7D94),
//                 ),
//               ),
//             ],
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Text(
//                 value1,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                   color: const Color(0xFF283D4C),
//                 ),
//               ),
//               Text(
//                 value2,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                   color: const Color(0xFF283D4C),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQrScannerSection() {
//     return Column(
//       children: [
//         SizedBox(
//           width: 294.w,
//           height: 324.h,
//           child: Stack(
//             children: [
//               // QR Scanner
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(37.r),
//                 child: SizedBox(
//                   width: 294.w,
//                   height: 324.h,
//                   child: MobileScanner(
//                     controller: _scannerController,
//                     onDetect: _onDetect,
//                   ),
//                 ),
//               ),

//               // Semi-transparent overlay with rounded corners
//               Container(
//                 width: 294.w,
//                 height: 324.h,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.3),
//                   borderRadius: BorderRadius.circular(37.r),
//                 ),
//               ),

//               // Top-left corner
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 child: CustomPaint(
//                   painter: CornerPainter(
//                     color: const Color(0xFFED7902),
//                     strokeWidth: 4.w,
//                     cornerSize: 57.w,
//                     cornerHeight: 39.31.h,
//                     isTopLeft: true,
//                   ),
//                 ),
//               ),

//               // Top-right corner
//               Positioned(
//                 top: 0,
//                 right: 0,
//                 child: CustomPaint(
//                   painter: CornerPainter(
//                     color: const Color(0xFFED7902),
//                     strokeWidth: 4.w,
//                     cornerSize: 57.w,
//                     cornerHeight: 39.31.h,
//                     isTopRight: true,
//                   ),
//                 ),
//               ),

//               // Bottom-left corner
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 child: CustomPaint(
//                   painter: CornerPainter(
//                     color: const Color(0xFFED7902),
//                     strokeWidth: 4.w,
//                     cornerSize: 57.w,
//                     cornerHeight: 39.31.h,
//                     isBottomLeft: true,
//                   ),
//                 ),
//               ),

//               // Bottom-right corner
//               Positioned(
//                 bottom: 0,
//                 right: 0,
//                 child: CustomPaint(
//                   painter: CornerPainter(
//                     color: const Color(0xFFED7902),
//                     strokeWidth: 4.w,
//                     cornerSize: 57.w,
//                     cornerHeight: 39.31.h,
//                     isBottomRight: true,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 10.h),
//         Text(
//           'Place QR code within the frame',
//           style: TextStyle(
//             fontSize: 13.sp,
//             fontWeight: FontWeight.w400,
//             color: const Color(0xFF626262),
//           ),
//         ),
//         SizedBox(height: 20.h),
//         // Toggle torch button
//         ElevatedButton.icon(
//           onPressed: () {
//             _scannerController.toggleTorch();
//           },
//           icon: const Icon(Icons.flashlight_on),
//           label: const Text('Toggle Flashlight'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFFED7902),
//             foregroundColor: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8.r),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//   // Widget _buildQrScannerSection() {
//   //   return Column(
//   //     children: [
//   //       Container(
//   //         width: 294.w,
//   //         height: 324.h,
//   //         decoration: BoxDecoration(
//   //           borderRadius: BorderRadius.circular(37.r),
//   //         ),
//   //         child: ClipRRect(
//   //           borderRadius: BorderRadius.circular(37.r),
//   //           child: Stack(
//   //             children: [
//   //               // QR Scanner
//   //               SizedBox(
//   //                 width: 294.w,
//   //                 height: 324.h,
//   //                 child: MobileScanner(
//   //                   controller: _scannerController,
//   //                   onDetect: _onDetect,
//   //                 ),
//   //               ),

//   //               // Semi-transparent overlay
//   //               Container(
//   //                 width: 294.w,
//   //                 height: 324.h,
//   //                 decoration: BoxDecoration(
//   //                   color: Colors.black.withOpacity(0.2),
//   //                   borderRadius: BorderRadius.circular(37.r),
//   //                 ),
//   //               ),

//   //               // Scanner cutout area (transparent)
//   //               Center(
//   //                 child: Container(
//   //                   width: 220.w,
//   //                   height: 220.h,
//   //                   decoration: BoxDecoration(
//   //                     color: Colors.transparent,
//   //                     border: Border.all(
//   //                       color: Colors.white.withOpacity(0.5),
//   //                       width: 2.w,
//   //                     ),
//   //                   ),
//   //                 ),
//   //               ),

//   //               // Corner accents
//   //               Positioned(
//   //                 top: 0,
//   //                 left: 2.w,
//   //                 child: _buildCornerAccent(),
//   //               ),
//   //               Positioned(
//   //                 top: 0,
//   //                 right: 2.w,
//   //                 child: Transform.scale(
//   //                   scaleX: -1,
//   //                   child: _buildCornerAccent(),
//   //                 ),
//   //               ),
//   //               Positioned(
//   //                 bottom: 0,
//   //                 left: 2.w,
//   //                 child: Transform.scale(
//   //                   scaleY: -1,
//   //                   child: _buildCornerAccent(),
//   //                 ),
//   //               ),
//   //               Positioned(
//   //                 bottom: 0,
//   //                 right: 2.w,
//   //                 child: Transform.scale(
//   //                   scaleX: -1,
//   //                   scaleY: -1,
//   //                   child: _buildCornerAccent(),
//   //                 ),
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //       ),
//   //       SizedBox(height: 10.h),
//   //       Text(
//   //         'Place QR code within the frame',
//   //         style: TextStyle(
//   //           fontSize: 13.sp,
//   //           fontWeight: FontWeight.w400,
//   //           color: const Color(0xFF626262),
//   //         ),
//   //       ),
//   //       SizedBox(height: 20.h),
//   //       // Toggle torch button
//   //       ElevatedButton.icon(
//   //         onPressed: () {
//   //           _scannerController.toggleTorch();
//   //         },
//   //         icon: const Icon(Icons.flashlight_on),
//   //         label: const Text('Toggle Flashlight'),
//   //         style: ElevatedButton.styleFrom(
//   //           backgroundColor: const Color(0xFFED7902),
//   //           foregroundColor: Colors.white,
//   //           shape: RoundedRectangleBorder(
//   //             borderRadius: BorderRadius.circular(8.r),
//   //           ),
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }

//   Widget _buildCornerAccent() {
//     return Container(
//       width: 57.w,
//       height: 39.31.h,
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: const Color(0xFFED7902),
//           width: 4.w,
//         ),
//         borderRadius: BorderRadius.circular(35.r),
//       ),
//     );
//   }
// }

// // Custom painter for drawing the corners
// class CornerPainter extends CustomPainter {
//   final Color color;
//   final double strokeWidth;
//   final double cornerSize;
//   final double cornerHeight;
//   final bool isTopLeft;
//   final bool isTopRight;
//   final bool isBottomLeft;
//   final bool isBottomRight;

//   CornerPainter({
//     required this.color,
//     required this.strokeWidth,
//     required this.cornerSize,
//     required this.cornerHeight,
//     this.isTopLeft = false,
//     this.isTopRight = false,
//     this.isBottomLeft = false,
//     this.isBottomRight = false,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..strokeCap = StrokeCap.round;

//     final radius = cornerSize / 2;

//     if (isTopLeft) {
//       final path = Path()
//         ..moveTo(0, radius)
//         ..arcToPoint(
//           Offset(radius, 0),
//           radius: Radius.circular(radius),
//         );
//       canvas.drawPath(path, paint);
//     } else if (isTopRight) {
//       final path = Path()
//         ..moveTo(cornerSize, radius)
//         ..arcToPoint(
//           Offset(cornerSize - radius, 0),
//           radius: Radius.circular(radius),
//           clockwise: false,
//         );
//       canvas.drawPath(path, paint);
//     } else if (isBottomLeft) {
//       final path = Path()
//         ..moveTo(0, cornerHeight - radius)
//         ..arcToPoint(
//           Offset(radius, cornerHeight),
//           radius: Radius.circular(radius),
//           clockwise: false,
//         );
//       canvas.drawPath(path, paint);
//     } else if (isBottomRight) {
//       final path = Path()
//         ..moveTo(cornerSize, cornerHeight - radius)
//         ..arcToPoint(
//           Offset(cornerSize - radius, cornerHeight),
//           radius: Radius.circular(radius),
//         );
//       canvas.drawPath(path, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(CornerPainter oldDelegate) =>
//       oldDelegate.color != color ||
//       oldDelegate.strokeWidth != strokeWidth ||
//       oldDelegate.cornerSize != cornerSize ||
//       oldDelegate.cornerHeight != cornerHeight;
// }
