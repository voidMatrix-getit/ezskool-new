import 'package:ezskool/data/viewmodels/login_viewmodel.dart';
import 'package:ezskool/presentation/screens/forgotpasswordscreen.dart';
import 'package:ezskool/presentation/views/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'class_attendance/class_attendance_home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ChangeNotifierProvider<LoginViewModel>(
          create: (_) => LoginViewModel(),
          child: Consumer<LoginViewModel>(
            builder: (context, viewModel, child) {
              return Form(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 66),
                      _buildLogo(),
                      const SizedBox(height: 20),
                      Image.asset('assets/book.png', width: 119, height: 119),
                      const SizedBox(height: 40),
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        label: "Client Id",
                        onChanged: (value) {
                          viewModel.clientId = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your client id';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        label: "Email Address",
                        onChanged: (value) {
                          viewModel.email = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildPasswordField(
                        onChanged: (value) {
                          viewModel.password = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildForgotPassword(context),
                      const SizedBox(height: 20),
                      _buildLoginButton(viewModel, context),
                      const SizedBox(height: 20),
                      _buildRegisterLink(context),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Container(
        width: 241,
        height: 58,
        alignment: Alignment.center,
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w700,
              fontSize: 40,
              letterSpacing: 0.001,
            ),
            children: const [
              TextSpan(
                text: 'Ez',
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
    );
  }

  Widget _buildTextField({
    required String label,
    required ValueChanged<String> onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField({required ValueChanged<String> onChanged}) {
    return TextFormField(
      obscureText: true,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: "Password",
        hintText: 'Password',
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
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

  Widget _buildForgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ForgotPasswordScreen()),
          );
        },
        child: const Text(
          'Forgot your password?',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFED7902),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(LoginViewModel viewModel, BuildContext context) {
    return ElevatedButton(
      onPressed: viewModel.isLoading
          ? null
          : () async {
              if (viewModel.clientId.isNotEmpty &&
                  viewModel.email.isNotEmpty &&
                  viewModel.password.isNotEmpty) {
                await viewModel.login();
                if (viewModel.errorMessage == null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ClassAttendanceHomeScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(viewModel.errorMessage ?? 'Error'),
                  ));
                }
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFED7902),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(320, 50),
      ),
      child: viewModel.isLoading
          ? CircularProgressIndicator()
          : const Text(
              'Login',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegistrationScreen()),
        );
      },
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'New to ezskool? ',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0E0E0E),
              ),
            ),
            TextSpan(
              text: 'Register here',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFED7902),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
