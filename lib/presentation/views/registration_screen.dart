// lib/views/registration_screen.dart
import 'package:ezskool/data/viewmodels/registration_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RegistrationViewModel>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Title
                Center(
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
                            text: 'ez',
                            style: TextStyle(color: Color(0xFFED7902)), // Orange
                          ),
                          TextSpan(
                            text: 'skool',
                            style: TextStyle(color: Colors.black), // Black
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Icon
                Image.asset('assets/book.png', width: 119, height: 119),
                const SizedBox(height: 40),

                // Form Title
                const Text(
                  'Register',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 20),

                // Form Fields
                ..._buildFormFields(viewModel),

                const SizedBox(height: 20),

                // Sign Up Button
                ElevatedButton(
                  onPressed: () async {
                    final success = await viewModel.register();
                    if (success) {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          content: Text('Sign Up Successful'),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          content: Text('Sign Up Failed. Please try again.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFED7902),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(320, 50),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Already have an account
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0E0E0E), // Black
                          ),
                        ),
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFED7902), // Orange
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

  List<Widget> _buildFormFields(RegistrationViewModel viewModel) {
    return [
      _buildTextField(
        label: 'Institution Name*',
        hintText: 'Institution Name',
        errorText: viewModel.errors['institutionName'],
        onChanged: (value) {
          viewModel.updateField('institutionName', value);
        },
      ),
      const SizedBox(height: 10),
      _buildTextField(
        label: 'Address (Optional)',
        hintText: 'Address',
        errorText: viewModel.errors['address'],
        onChanged: (value) {
          viewModel.updateField('address', value);
        },
      ),
      const SizedBox(height: 10),
      _buildTextField(
        label: 'City*',
        hintText: 'City',
        errorText: viewModel.errors['city'],
        onChanged: (value) {
          viewModel.updateField('city', value);
        },
      ),
      const SizedBox(height: 10),
      _buildTextField(
        label: 'Postal Code (Optional)',
        hintText: 'Postal Code',
        keyboardType: TextInputType.number,
        errorText: viewModel.errors['postalCode'],
        onChanged: (value) {
          viewModel.updateField('postalCode', value);
        },
      ),
      const SizedBox(height: 10),
      _buildTextField(
        label: 'Contact Person*',
        hintText: 'Contact Person',
        errorText: viewModel.errors['contactPerson'],
        onChanged: (value) {
          viewModel.updateField('contactPerson', value);
        },
      ),
      const SizedBox(height: 10),
      _buildTextField(
        label: 'Contact Number*',
        hintText: 'Contact Number',
        keyboardType: TextInputType.phone,
        errorText: viewModel.errors['contactNumber'],
        onChanged: (value) {
          viewModel.updateField('contactNumber', value);
        },
      ),
      const SizedBox(height: 10),
      _buildTextField(
        label: 'Email Address (Optional)',
        hintText: 'Email Address',
        keyboardType: TextInputType.emailAddress,
        errorText: viewModel.errors['emailAddress'],
        onChanged: (value) {
          viewModel.updateField('emailAddress', value);
        },
      ),
      const SizedBox(height: 10),
      _buildDropdown(viewModel),
    ];
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        errorText: errorText,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildDropdown(RegistrationViewModel viewModel) {
    return DropdownButtonFormField<String>(
      value: viewModel.form.institutionType,
      decoration: InputDecoration(
        labelText: 'Institution Type',
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      items: ['School', 'College', 'University', 'Other'].map((type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (value) {
        viewModel.updateField('institutionType', value);
      },
    );
  }
}
