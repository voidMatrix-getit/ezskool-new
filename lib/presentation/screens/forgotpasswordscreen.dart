import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../dialogs/forgotpassworddialog.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[

                SizedBox(height: 50.h),

                Center(
                  child: Container(
                    width: 241.w,
                    height: 58.h,
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700,
                          fontSize: 40.sp,
                          letterSpacing: 0.001.w,
                        ),
                        children: [
                          TextSpan(
                            text: 'ez',
                            style: TextStyle(
                                color: Color(0xFFED7902)), // Orange color
                          ),
                          TextSpan(
                            text: 'skool',
                            style:
                            TextStyle(color: Colors.black), // Black color
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Image.asset(
                  'assets/book.png',
                  width: 119.w,
                  height: 119.h,
                ),
                SizedBox(height: 40.h),
                 Text(
                  'Forgot Your Password?',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24.sp,
                    height: 1.5.h, // Line height in terms of font size
                    letterSpacing: 0.001.w,
                    color: Color(0xFF1E1E1E),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Text(
                    'Enter your registered email address below and we’ll send you a link to your email to reset your password.',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                      height: 1.5.h, // Line height in terms of font size
                      letterSpacing: 0.001.w,
                      color: Color(0xFF4B4B4B),
                    ),
                    textAlign: TextAlign.center,
                  ),

                ),

                SizedBox(height: 50.h),
                _buildEmailField(),
                 SizedBox(height: 30.h),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content: Text('Password reset link sent to your email'),
                      //   ),
                      // );
                      // Add logic for sending a password reset link
                      showResetPasswordDialogSuccess(context);
                    }
                    else{
                      showErrorDialog(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFED7902),
                    minimumSize: Size(341.w, 54.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'Send Reset Link',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      height: 1.5.h,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Remembered your password? ',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Color(0xFF494949),
                          ),
                        ),
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Color(0xFFED7902),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email Address',
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Color(0xFFED7902), width: 2.w),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}
