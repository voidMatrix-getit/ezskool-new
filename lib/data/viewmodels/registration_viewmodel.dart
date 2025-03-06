// lib/viewmodels/registration_viewmodel.dart
import 'package:ezskool/data/models/registeration_form.dart';
import 'package:ezskool/data/repo/auth_repo.dart';
import 'package:flutter/material.dart';

class RegistrationViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final RegistrationForm _form = RegistrationForm();
  final Map<String, String?> _errors = {};

  Map<String, String?> get errors => _errors;
  RegistrationForm get form => _form;

  Future<bool> register() async {
    _errors.clear();
    _errors.addAll(_form.validate());
    if (_errors.values.every((error) => error == null)) {
      try {
        final response = await _authRepository.register(
          institutionName: _form.institutionName!,
          contactPerson: _form.contactPerson!,
          contactNumber: _form.contactNumber!,
          city: _form.city!,
          institutionType: _form.institutionType == 'School'
              ? 0
              : _form.institutionType == 'College'
              ? 1
              : _form.institutionType == 'University'
              ? 2
              : 3,
          email: _form.emailAddress,
          address: _form.address,
          postalCode: _form.postalCode,
        );
        return response['success'];
      } catch (e) {
        _errors['general'] = e.toString();
      }
    }
    notifyListeners();
    return false;
  }

  void updateField(String field, String? value) {
    switch (field) {
      case 'institutionName':
        _form.institutionName = value;
        break;
      case 'address':
        _form.address = value;
        break;
      case 'city':
        _form.city = value;
        break;
      case 'postalCode':
        _form.postalCode = value;
        break;
      case 'contactPerson':
        _form.contactPerson = value;
        break;
      case 'contactNumber':
        _form.contactNumber = value;
        break;
      case 'emailAddress':
        _form.emailAddress = value;
        break;
      case 'institutionType':
        _form.institutionType = value;
        break;
    }
    notifyListeners();
  }
}
