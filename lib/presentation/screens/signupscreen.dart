import 'package:ezskool/core/services/logger.dart';
import 'package:ezskool/data/repo/auth_repo.dart';
import 'package:ezskool/presentation/dialogs/error_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../dialogs/signupsuccessfuldialog.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _repo = AuthRepository();
  final _formKey = GlobalKey<FormState>();
  final Map<String, String?> _errors = {};
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _instNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  final FocusNode _instNameFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _postalCodeFocus = FocusNode();
  final FocusNode _contactFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _institutionTypeFocus = FocusNode();

  String? _selectedInstitutionType;

  final List<String> _institutionTypes = [
    'University',
    'School',
    'College',
    'Coaching Institute'
  ];

  void _addListeners() {
    _addressController.addListener(() => _clearError('address'));
    _instNameController.addListener(() => _clearError('institutionName'));
    _cityController.addListener(() => _clearError('city'));
    _postalCodeController.addListener(() => _clearError('postalCode'));
    _contactController.addListener(() => _clearError('contactPerson'));
    _mobileController.addListener(() => _clearError('mobileNumber'));
    _emailController.addListener(() => _clearError('emailAddress'));
  }

  void _clearError(String field) {
    if (_errors[field] != null) {
      setState(() {
        _errors[field] = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _addListeners();
    _instNameFocus.addListener(() => setState(() {}));
    _addressFocus.addListener(() => setState(() {}));
    _cityFocus.addListener(() => setState(() {}));
    _postalCodeFocus.addListener(() => setState(() {}));
    _contactFocus.addListener(() => setState(() {}));
    _mobileFocus.addListener(() => setState(() {}));
    _emailFocus.addListener(() => setState(() {}));
    _institutionTypeFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // Dispose focus nodes
    _instNameFocus.dispose();
    _addressFocus.dispose();
    _cityFocus.dispose();
    _postalCodeFocus.dispose();
    _contactFocus.dispose();
    _mobileFocus.dispose();
    _emailFocus.dispose();
    _institutionTypeFocus.dispose();
    super.dispose();
  }

  void _validateForm() async {
    setState(() {
      // Validating fields and set error messages
      _errors['institutionName'] = _instNameController.text.isEmpty
          ? 'Institution name is required'
          : (_instNameController.text.length < 3
              ? 'Institution name must be at least 3 characters'
              : null);
      _errors['city'] = _cityController.text.isEmpty
          ? 'City is required'
          : (_cityController.text.length < 3
              ? 'City must be at least 3 characters'
              : null);
      _errors['contactPerson'] = _contactController.text.isEmpty
          ? 'Contact person is required'
          : (_contactController.text.length < 3
              ? 'Contact person name must be at least 3 characters'
              : null);
      _errors['mobileNumber'] = _mobileController.text.isEmpty
          ? 'Mobile number is required'
          : (_mobileController.text.length != 10
              ? 'Mobile number must be 10 digits'
              : null);
      _errors['institutionType'] = null; //_selectedInstitutionType == null
      //     ? 'Please select an institution type'
      //     : null;
      _errors['address'] = null; // Address is optional
      _errors['postalCode'] = _postalCodeController.text.isNotEmpty &&
              _postalCodeController.text.length != 6
          ? 'Postal code must be 6 digits'
          : null;
      _errors['emailAddress'] = _emailController.text.isNotEmpty &&
              !_emailController.text.contains(RegExp(r'^[^@]+@[^@]+\.[^@]+'))
          ? 'Please enter a valid email'
          : null;
    });

    // Checking if all validations pass
    if (_errors.values.every((error) => error == null)) {
      try {
        final response = await _repo.register(
          institutionName: _instNameController.text,
          contactPerson: _contactController.text,
          contactNumber: _mobileController.text,
          city: _cityController.text,
          institutionType: _selectedInstitutionType == 'School'
              ? 0
              : _selectedInstitutionType == 'College'
                  ? 1
                  : _selectedInstitutionType == 'University'
                      ? 2
                      : 3,
          email: _emailController.text,
          address: _addressController.text,
          postalCode: _postalCodeController.text,
        );
        Log.d(response['success']);
        if (response['success']) {
          showDialog(
            context: context,
            builder: (context) => SignUpSuccessDialog(),
          );
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) =>
              showSignUpFailedDialog(context, message: e.toString()),
        );
        Log.d('Sahil see this:${e.toString()}');
      }
    }
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
                SizedBox(height: 40.h),

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
                  'Register',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                SizedBox(height: 20.h),

                _buildTextField(
                  label: 'Institution Name*',
                  controller: _instNameController,
                  hintText: 'Institution Name',
                  errorText: _errors['institutionName'],
                  focusNode: _instNameFocus,
                  nextFocusNode: _addressFocus,
                  // validator: (value) {
                  //   if (value == null || value.length < 3) {
                  //     return 'Institution name should be null';
                  //   }
                  //   return null;
                  // },
                ),
                SizedBox(height: 10.h),

                _buildTextField(
                  label: 'Address(Optional)',
                  controller: _addressController,
                  hintText: 'Address',
                  errorText: _errors['address'],
                  focusNode: _addressFocus,
                  nextFocusNode: _cityFocus,
                  // validator: (value) {
                  //   return null;
                  // }
                ),
                SizedBox(height: 10.h),

                _buildTextField(
                  label: 'City*',
                  controller: _cityController,
                  hintText: 'City',
                  errorText: _errors['city'],
                  focusNode: _cityFocus,
                  nextFocusNode: _postalCodeFocus,
                  // validator: (value) {
                  //   if (value == null || value.length < 3) {
                  //     return 'City should be at least 3 characters';
                  //   }
                  //   return null;
                  // },
                ),

                SizedBox(height: 10.h),
                _buildTextField(
                  label: 'Postal Code(Optional)',
                  controller: _postalCodeController,
                  hintText: 'Postal Code',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  errorText: _errors['postalCode'],
                  focusNode: _postalCodeFocus,
                  nextFocusNode: _contactFocus,
                  // validator: (value) {
                  //   if (value != null && value.isNotEmpty) {
                  //     if (value.length != 6) {
                  //       return 'Postal code should be 6 digits';
                  //     }
                  //   }
                  //   return null;  // Allow empty postal code
                  // },
                ),

                SizedBox(height: 10.h),

                _buildTextField(
                  label: 'Contact Person*',
                  controller: _contactController,
                  hintText: 'Contact Person',
                  errorText: _errors['contactPerson'],
                  focusNode: _contactFocus,
                  nextFocusNode: _mobileFocus,
                  // validator: (value) {
                  //   if (value == null || value.length < 3) {
                  //     return 'Contact person name should be at least 3 characters';
                  //   }
                  //   return null;
                  // },
                ),
                SizedBox(height: 10.h),

                _buildTextField(
                  label: 'Contact Number*',
                  controller: _mobileController,
                  hintText: 'Contact Number',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(11),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  errorText: _errors['contactNumber'],
                  focusNode: _mobileFocus,
                  nextFocusNode: _emailFocus,
                  // validator: (value) {
                  //   if (value == null || value.length != 10) {
                  //     return 'Mobile number should be 10 digits';
                  //   }
                  //   return null;
                  // },
                ),
                SizedBox(height: 10.h),

                _buildTextField(
                  label: "Email Address(Optional)",
                  controller: _emailController,
                  hintText: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  errorText: _errors['emailAddress'],
                  focusNode: _emailFocus,
                  nextFocusNode: _institutionTypeFocus,
                  // validator: (value) {
                  //   if (value != null && value.isNotEmpty) {
                  //     if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  //       return 'Please enter a valid email';
                  //     }
                  //   }
                  //   return null;  // Allow empty email
                  //
                  // },
                ),
                SizedBox(height: 10.h),

                _buildDropdown(),

                SizedBox(height: 20.h),

                ElevatedButton(
                  onPressed: () {
                    _validateForm();
                    // if (_formKey.currentState!.validate()) {
                    //
                    //   // ScaffoldMessenger.of(context).showSnackBar(
                    //   //   SnackBar(content: Text('Processing Data')),
                    //   // );
                    //   showDialog(
                    //     context: context,
                    //     builder: (context) => SignUpSuccessDialog(),
                    //   );
                    //   // Navigator.push(
                    //   //   context,
                    //   //   MaterialPageRoute(builder: (context) => LoginScreen()),
                    //   // );
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFED7902),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    minimumSize: Size(320.w, 50.h),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),

                // ElevatedButton(
                //   onPressed: () {
                //     if (_formKey.currentState!.validate()) {
                //       // Proceed with sign-up logic
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(content: Text('Processing Data')),
                //       );
                //     }
                //   },
                //   style: ElevatedButton.styleFrom(
                //     minimumSize: Size(double.infinity, 60),
                //     backgroundColor: Color(0xFFED7902),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //   ),
                //   child: Text(
                //     'Sign Up',
                //     style: TextStyle(
                //       fontFamily: 'Poppins',
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),

                SizedBox(height: 20.h),

                GestureDetector(
                  onTap: () {
                    // Navigate to login screen
                    Navigator.pop(context);
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(
                                0xFF0E0E0E), // Black color for "Already have an account?"
                          ),
                        ),
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(
                                0xFFED7902), // Orange color for "Login" (theme color)
                          ),
                        ),
                      ],
                    ),
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => LoginScreen()),
                  //     );
                  //   },
                  //   child: Text(
                  //     'Already have an account? Login',
                  //     style: TextStyle(
                  //       color: Colors.grey,
                  //       fontSize: 14,
                  //     ),
                  //   ),
                  // ),
                )
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
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? errorText,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
  }) {
    return TextFormField(
      textInputAction:
          nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted: (value) {
        if (nextFocusNode != null) {
          nextFocusNode.requestFocus();
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      focusNode: focusNode,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        // label: Text(label),
        // hintText: hintText,
        errorText: errorText,
        filled: true,
        fillColor: Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFED7902), width: 2.w),
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,

      // validator: validator,
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedInstitutionType,

      decoration: InputDecoration(
        // label: Text("Institution Type"),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
        hintText: 'Institution Type',
        errorText: _errors['institutionType'],
        filled: true,
        fillColor: Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: Color(0xFFED7902), width: 2.w),
        ),
      ),
      items: _institutionTypes.map((String type) {
        return DropdownMenuItem<String>(
          value: type,
          alignment: Alignment.center,
          child: Text(type),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _selectedInstitutionType = value;
          _clearError('institutionType');
          _institutionTypeFocus.unfocus();
        });
      },
      // validator: (value) {
      //   if (value == null) {
      //     return 'Please select an institution type';
      //   }
      //   return null;
      // },
    );
  }
}

// theme: ThemeData(
// fontFamily: 'Poppins', // Set global font family
// primaryColor: Color(0xFFED7902), // Primary button color
// scaffoldBackgroundColor: Colors.white, // Background color
// // class RegistrationScreen extends StatelessWidget {
// //   const RegistrationScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       // appBar: AppBar(
// //       //   title: const Text('Register'),
// //       //   backgroundColor: Colors.transparent, // Transparent AppBar
// //       //   elevation: 0,
// //       // ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.center,
// //           children: [
// //
// //             const SizedBox(height: 40),
// //             // Book Logo
// //             Image.asset(
// //               'assets/book.png',
// //               width: 119,
// //               height: 119,
// //             ),
// //             const SizedBox(height: 40),
// //
// //             // Register Text
// //             Text(
// //               'Register',
// //               style: TextStyle(
// //                 fontFamily: 'Poppins',
// //                 fontSize: 24,
// //                 fontWeight: FontWeight.w500,
// //                 color: Color(0xFF1E1E1E),
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //
// //             // Form Fields
// //             RegistrationForm(),
// //
// //             // Sign In Button
// //             const SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: () {
// //                 // Navigate to Login screen (not implemented here)
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => LoginScreen()),
// //                 );
// //               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFFED7902),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 minimumSize: Size(320, 50),
//               ),
//               child: const Text(
//                 'Sign Up',
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Already have an account? Login
//             GestureDetector(
//               onTap: () {
//                 // Navigate to login screen
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginScreen()),
//                 );
//               },
//               child: RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: 'Already have an account? ',
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF0E0E0E), // Black color for "Already have an account?"
//                       ),
//                     ),
//                     TextSpan(
//                       text: 'Login',
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFFED7902), // Orange color for "Login" (theme color)
//
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class RegistrationForm extends StatefulWidget {
//   const RegistrationForm({super.key});
//
//   @override
//   _RegistrationFormState createState() => _RegistrationFormState();
// }
//
// class _RegistrationFormState extends State<RegistrationForm> {
//   final _formKey = GlobalKey<FormState>();
//
//   String? institutionName;
//   String ?address;
//   String? city;
//   String? postalCode;
//   String? contactPerson;
//   String? mobileNumber;
//   String? email;
//   String? institutionType;
//
//   List<String> institutionTypes = ['University', 'College', 'Coaching Institute'];
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           // Institution Name
//           _buildTextField(
//             label: 'Institution Name',
//             onSaved: (value) => institutionName = value,
//             validator: (value) => value?.isEmpty ?? true ? 'Please enter institution name' : null,
//           ),
//
//           // City
//           _buildTextField(
//             label: 'Address',
//             onSaved: (value) => address = value,
//             validator: (value) => value?.isEmpty ?? true ? 'Please enter address' : null,
//           ),
//
//           // City
//           _buildTextField(
//             label: 'City',
//             onSaved: (value) => city = value,
//             validator: (value) => value?.isEmpty ?? true ? 'Please enter city' : null,
//           ),
//
//           // Postal Code
//           _buildTextField(
//             label: 'Postal Code',
//             onSaved: (value) => postalCode = value,
//             validator: (value) => value?.isEmpty ?? true ? 'Please enter postal code' : null,
//           ),
//
//           // Contact Person
//           _buildTextField(
//             label: 'Contact Person',
//             onSaved: (value) => contactPerson = value,
//             validator: (value) => value?.isEmpty ?? true ? 'Please enter contact person' : null,
//           ),
//
//           // Mobile Number
//           _buildTextField(
//             label: 'Contact Number',
//             onSaved: (value) => mobileNumber = value,
//             validator: (value) => value?.isEmpty ?? true ? 'Please enter mobile number' : null,
//           ),
//
//           // Email Address
//           _buildTextField(
//             label: 'Email Address',
//             onSaved: (value) => email = value,
//             validator: (value) => value?.isEmpty ?? true ? 'Please enter email address' : null,
//           ),
//
//           // Institution Type Dropdown
//           Padding(
//             padding: const EdgeInsets.only(top: 16),
//             child: DropdownButtonFormField<String>(
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: Color(0xFFF5F5F5),
//                 contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//               value: institutionType,
//               hint: Text(
//                 'Select Institution Type',
//                 style: TextStyle(color: Color(0xFF626262)),
//               ),
//               onChanged: (newValue) {
//                 setState(() {
//                   institutionType = newValue;
//                 });
//               },
//               items: institutionTypes.map((type) {
//                 return DropdownMenuItem(
//                   value: type,
//                   child: Text(type),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required String label,
//     required void Function(String?) onSaved,
//     required String? Function(String?) validator,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 16),
//       child: TextFormField(
//         decoration: InputDecoration(
//           labelText: label,
//           filled: true,
//           fillColor: Color(0xFFF5F5F5),
//           contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide.none,
//           ),
//         ),
//         onSaved: onSaved,
//         validator: validator,
//       ),
//     );
//   }
// }
