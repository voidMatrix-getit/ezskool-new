import 'package:ezskool/data/viewmodels/forgot_password_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ChangeNotifierProvider<ForgotPasswordViewModel>(
          create: (_) => ForgotPasswordViewModel(),
          child: Consumer<ForgotPasswordViewModel>(
            builder: (context, viewModel, child) {
              return Form(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 66),
                      _buildLogo(),
                      const SizedBox(height: 40),
                      const Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E1E1E),
                        ),
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
                      const SizedBox(height: 40),
                      _buildSendButton(viewModel, context),
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

  Widget _buildSendButton(ForgotPasswordViewModel viewModel, BuildContext context) {
    return ElevatedButton(
      onPressed: viewModel.isLoading
          ? null
          : () async {
        if (viewModel.email.isNotEmpty) {
          await viewModel.sendResetLink();
          if (viewModel.errorMessage == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('A reset link has been sent to your email!'),
            ));
            Navigator.pop(context);
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
          ? const CircularProgressIndicator()
          : const Text(
        'Send Reset Link',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
