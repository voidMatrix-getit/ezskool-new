import 'package:ezskool/presentation/screens/loginscreen.dart'; //views/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Top white area background
      body: Stack(
        children: [
          // Top Section
          Column(
            children: [
              SizedBox(height: 110.h),
              Center(
                child: Text(
                  'Welcome to',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Center(

                child: Container(
                  width: 241.w,
                  height: 58.h,
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        // fontFamily: 'Poppins',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        fontSize: 40.sp,
                        letterSpacing: 0.001,
                      ),
                      children: [
                        TextSpan(
                          text: 'ez',
                          style: TextStyle(color: Color(0xFFED7902)), // Orange color
                        ),
                        TextSpan(
                          text: 'skool',
                          style: TextStyle(color: Colors.black), // Black color
                        ),
                      ],
                    ),
                  ),
                ),

              ),
              SizedBox(height: 16.h),
              Image.asset(
                'assets/book.png', // Replace with your book image asset
                height: 119.h,
                width: 119.w,
              ),
            ],
          ),

          // Bottom Card Section
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 325.h,
              width: double.infinity.w,
              decoration: BoxDecoration(
                color: Color(0xFF333333), // Card background
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(31.r),
                  topRight: Radius.circular(31.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.26),
                    blurRadius: 50,
                    offset: Offset(0, -13),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  Container(
                    width: 80.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFED7902), // Orange line
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 24.h),
                  Text(
                    'Your one-stop solution for managing\nschool operations.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17.sp,
                      color: Colors.white,
                      height: 1.5.h,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(317.w, 62.h),
                      backgroundColor: Color(0xFFED7902),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 48.w,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Spacer(),
                        Text(
                          'Let’s Go',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        // SizedBox(width: 20),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
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
