import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class ParentContactBottomSheet extends StatelessWidget {
  final List<Map<String, dynamic>> parents;
  final String name;
  final String rollNo;
  final int gender;

  const ParentContactBottomSheet(
      {super.key,
      required this.parents,
      required this.name,
      required this.rollNo,
      required this.gender});

  String getRelationLabel(int relation) {
    switch (relation) {
      case 1:
        return "Father";
      case 2:
        return "Mother";
      case 3:
        return "Guardian";
      default:
        return "N/A";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(27.r),
        topRight: Radius.circular(27.r),
      ),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     SizedBox(width: 65.w,),
            //
            //
            //    SizedBox(width: 18.w,),
            //
            //     IconButton(
            //         onPressed: () => Navigator.pop(context),
            //         icon: Icon(Icons.close)),
            //   ],
            // ),
            Text(
              'Parent Contact Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: Color(0xFF1E1E1E),
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 5.h),
            Container(
              height: 2.h,
              width: 250.w,
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(height: 20.h),

            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //SizedBox(width: 38.w,),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24.sp,
                      color: Color(0xFF533DDC),
                    ),
                  ),
                ]),

            SizedBox(height: 10.h),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SVG Icon
                // SizedBox(
                //   width: 38.w,
                // ),
                // SvgPicture.asset(
                //   'assets/Frame.svg',
                //   width: 53.w,
                //   height: 75.h,
                // ),
                Image.asset(
                  gender == 1 ? 'assets/bb.png' : 'assets/g.png',
                  color: gender == 1 ? Colors.blue : Colors.pink,
                  width: 53.w,
                  height: 75.h,
                ),
                // SizedBox(width: 10.w,),
                SizedBox(width: 8.w),

                Text(
                  "Roll No - $rollNo",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                    color: Color(0xFF494949),
                  ),
                ),

                // Column with Name and Roll Number
                // Expanded(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       // Name
                //
                //       // Roll Number
                //
                //     ],
                //   ),
                // ),
              ],
            ),

            SizedBox(height: 10.h),

            Column(
              //mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: parents.map((parent) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
                  child: ContactInfoSection(
                    label:
                        '${parent.containsKey('name') ? parent['name'] : (parent.containsKey('parent_name') ? parent['parent_name'] : 'N/A')} (${getRelationLabel(parent.containsKey('relation') ? (parent['relation'].toString().length == 1 ? parent['relation'] : -1) : (parent.containsKey('rel') ? (parent['rel'].toString().length == 1 ? parent['rel'] : -1) : -1))})',
                    phoneNumber: parent['contact_no'] != null
                        ? parent['contact_no'].toString()
                        : '      N/A       ',
                  ),
                );
              }).toList(),
            ),

            // Centered ContactInfoSection widgets
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.center, // Aligns the entire section in the center
            //   children: [
            //     ContactInfoSection(
            //       label: 'Father',
            //       phoneNumber: '984028022',
            //     ),
            //     SizedBox(height: 20),
            //     ContactInfoSection(
            //       label: 'Mother',
            //       phoneNumber: '8724910481',
            //     ),
            //     SizedBox(height: 20),
            //     ContactInfoSection(
            //       label: 'Guardian',
            //       phoneNumber: '7742349013',
            //     ),
            //   ],
            // ),

            SizedBox(height: 10.h),
            //Spacer(),
            //
            // // Bottom row with action buttons
            Padding(
              padding: EdgeInsets.all(8.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Button 1: Gray background
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xF5F5F5F5),
                      // Gray background
                      shadowColor: Colors.black.withOpacity(0.5),
                      // Drop shadow
                      elevation: 4,
                      // Shadow elevation
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5.r), // Rounded corners
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 22.w, vertical: 10.h),
                    ),
                    child: Text(
                      "Close", // Replace with actual text
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        letterSpacing: 0.4.w,
                        color: Color(0xFF494949), // Text color
                      ),
                    ),
                  ),
                  // Button 2: Orange background
                  // SizedBox(width: 20.w),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.pop(context);
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Color(0xFFED7902),
                  //     // Orange background
                  //     shadowColor: Colors.black.withOpacity(0.5),
                  //     // Drop shadow
                  //     elevation: 4,
                  //     // Shadow elevation
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius:
                  //       BorderRadius.circular(5.r), // Rounded corners
                  //     ),
                  //     padding:
                  //     EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                  //   ),
                  //   child: Text(
                  //     "    OK    ", // Replace with actual text
                  //     style: TextStyle(
                  //       fontFamily: 'Inter',
                  //       fontWeight: FontWeight.w500,
                  //       fontSize: 14.sp,
                  //       letterSpacing: 0.4.w,
                  //       color: Color(0xFFFAECEC), // Text color
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactInfoSection extends StatelessWidget {
  final String label;
  final String phoneNumber;

  const ContactInfoSection(
      {super.key, required this.label, required this.phoneNumber});

  Future<bool> _handlePermission(Permission permission) async {
    PermissionStatus status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      status = await permission.request();
      return status.isGranted;
    }

    if (status.isPermanentlyDenied) {
      // Show dialog to open app settings
      return false;
    }

    return false;
  }

  Future<void> _makePhoneCall(BuildContext context) async {
    if (await _handlePermission(Permission.phone)) {
      final Uri phoneUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch phone app')),
          );
        }
      }
    } else {
      if (context.mounted) {
        _showPermissionDeniedDialog(context, 'phone call');
      }
    }
  }

  Future<void> _sendSMS(BuildContext context) async {
    if (await _handlePermission(Permission.sms)) {
      final Uri smsUri = Uri(
        scheme: 'sms',
        path: phoneNumber,
      );
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch SMS app')),
          );
        }
      }
    } else {
      if (context.mounted) {
        _showPermissionDeniedDialog(context, 'send SMS');
      }
    }
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    // WhatsApp doesn't need special permissions
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (!cleanNumber.startsWith('+')) {
      cleanNumber = '91$cleanNumber';
    }

    final whatsappUrl = Uri.parse('https://wa.me/$cleanNumber');
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp')),
        );
      }
    }
  }

  void _showPermissionDeniedDialog(BuildContext context, String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Permission Required'),
        content: Text(
            'Permission is required to $action. Please enable it in app settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  // Future<void> _makePhoneCall() async {
  //   final Uri phoneUri = Uri(
  //     scheme: 'tel',
  //     path: phoneNumber,
  //   );
  //   if (await canLaunchUrl(phoneUri)) {
  //     await launchUrl(phoneUri);
  //   } else {
  //     debugPrint('Could not launch $phoneUri');
  //   }
  // }
  //
  // Future<void> _sendSMS() async {
  //   final Uri smsUri = Uri(
  //     scheme: 'sms',
  //     path: phoneNumber,
  //   );
  //   if (await canLaunchUrl(smsUri)) {
  //     await launchUrl(smsUri);
  //   } else {
  //     debugPrint('Could not launch $smsUri');
  //   }
  // }
  //
  // Future<void> _openWhatsApp() async {
  //   // Remove any non-numeric characters from the phone number
  //   String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
  //
  //   // Add country code if not present (example using India's code)
  //   if (!cleanNumber.startsWith('+')) {
  //     cleanNumber = '91$cleanNumber';  // Replace 91 with your country code
  //   }
  //
  //   final whatsappUrl = Uri.parse('https://wa.me/$cleanNumber');
  //   if (await canLaunchUrl(whatsappUrl)) {
  //     await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
  //   } else {
  //     debugPrint('Could not launch $whatsappUrl');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // Center the entire section horizontally
      children: [
        Column(
          //mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          // Keep the label aligned to the start
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 13.sp,
                color: Color(0xFF1E1E1E),
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Container(
                  width: 303.w,
                  height: 39.h,
                  padding:
                      EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFD2D2D7)),
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Phone Number Text
                      Text(
                        phoneNumber,
                        style: TextStyle(
                          fontSize: 19.sp,
                          color: Color(0xFF494949),
                        ),
                      ),
                      Spacer(), // Space between text and icons
                      // Icon Buttons
                      GestureDetector(
                        onTap: () => phoneNumber != 'N/A'
                            ? _makePhoneCall(context)
                            : null,
                        child: SvgPicture.asset(
                          'assets/call.svg',
                          height: 20.h,
                          width: 20.w,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      GestureDetector(
                        onTap: () =>
                            phoneNumber != 'N/A' ? _sendSMS(context) : null,
                        child: SvgPicture.asset(
                          'assets/sms.svg',
                          height: 20.h,
                          width: 20.w,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      GestureDetector(
                        onTap: () => phoneNumber != 'N/A'
                            ? _openWhatsApp(context)
                            : null,
                        child: SvgPicture.asset(
                          'assets/wa.svg',
                          height: 20.h,
                          width: 20.w,
                        ),
                      ),
                      // IconButton(
                      //   onPressed: () {},
                      //   icon: Icon(Icons.call_to_action_outlined,
                      //       color: Color(0xFF3F866E)),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
