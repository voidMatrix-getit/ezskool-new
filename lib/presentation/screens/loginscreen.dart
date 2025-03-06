import 'package:ezskool/data/repo/auth_repo.dart';
import 'package:ezskool/presentation/screens/signupscreen.dart';
import 'package:ezskool/presentation/views/class_attendance/new_class_attendance_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'forgotpasswordscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repo = AuthRepository();
  final TextEditingController _clientidController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Focus nodes for detecting focus
  final FocusNode _clientidFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Adding listeners to update the state when the focus changes
    _clientidFocusNode.addListener(() => setState(() {}));
    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _clientidController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _clientidFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 66.h),
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
                SizedBox(height: 20.h),
                Image.asset('assets/book.png', width: 119.w, height: 119.h),
                SizedBox(height: 40.h),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                SizedBox(height: 20.h),

                _buildTextField(
                  label: "Client Id",
                  controller: _clientidController,
                  focusNode: _clientidFocusNode,
                  nextFocusNode: _emailFocusNode,
                  hintText: 'Client Id',
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your client id';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20.h),
                _buildTextField(
                  label: "Username",
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  nextFocusNode: _passwordFocusNode,
                  hintText: 'Username',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    // if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    //   return 'Please enter a valid email';
                    // }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                // _buildTextField(
                //   label: "Password",
                //   controller: _passwordController,
                //   focusNode: _passwordFocusNode,
                //   hintText: 'Password',
                //   obscureText: true,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter your password';
                //     }
                //     return null;
                //   },
                // ),
                _buildPasswordField(),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen()),
                      );
                    },
                    child: Text(
                      'Forgot your password?',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFED7902),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () async {
                    HapticFeedback.heavyImpact();

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFFED7902)),
                            strokeWidth: 5,
                            backgroundColor: Colors.white.withOpacity(0.3),
                          ),
                        );
                      },
                    );
                    if (_formKey.currentState!.validate()) {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Processing Login')),
                      // );
                      // Perform login logic here
                      try {
                        final response = await _repo.login(
                            clientId: _clientidController.text,
                            userName: _emailController.text,
                            password: _passwordController.text);
                        if (response['success'] == true) {
                          Navigator.of(context, rootNavigator: true).pop();

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(response['message']),
                            duration: Duration(seconds: 1),
                            backgroundColor: Colors.green,
                          ));

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NewClassAttendanceHomeScreen()),
                            (route) => false, // Removes all previous screens
                          );
                        } else {
                          Navigator.of(context, rootNavigator: true).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(response['message']),
                            ),
                          );
                        }
                      } catch (e) {
                        Navigator.of(context, rootNavigator: true).pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Login failed. Invalid Credentials'),
                          backgroundColor: Colors.red,
                        ));
                      }
                    } else {
                      Navigator.of(context, rootNavigator: true).pop();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please enter valid credentials')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFED7902),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    minimumSize: Size(320.w, 50.h),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () {
                    // Navigate to registration screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationScreen()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'New to ezskool? ',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0E0E0E),
                          ),
                        ),
                        TextSpan(
                          text: 'Register here',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
    FocusNode? nextFocusNode,
  }) {
    return TextFormField(
      textInputAction:
          nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted: (value) {
        if (nextFocusNode != null) {
          nextFocusNode.requestFocus();
        } else {
          focusNode.unfocus();
        }
      },
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        // hintText: hintText,
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
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  bool _isObscured = true; // State to manage visibility of password

  Widget _buildPasswordField() {
    return TextFormField(
      textInputAction: TextInputAction.done, // Last field
      onFieldSubmitted: (value) {
        _passwordFocusNode.unfocus(); // Dismiss keyboard on last field
      },
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: _isObscured, // Toggles between show/hide password
      decoration: InputDecoration(
        labelText: "Password",
        // hintText: 'Password',
        filled: true,
        fillColor: Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Color(0xFFED7902), width: 2.w),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured; // Toggle the state
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }
}
