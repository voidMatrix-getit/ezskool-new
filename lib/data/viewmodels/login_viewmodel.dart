// lib/data/viewmodels/login_viewmodel.dart
import 'package:ezskool/data/repo/auth_repo.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  String clientId = '';
  String email = '';
  String password = '';
  String? errorMessage;
  bool isLoading = false;

  Future<void> login() async {
    if (clientId.isEmpty || email.isEmpty || password.isEmpty) {
      errorMessage = 'Please fill in all fields';
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      final response = await _authRepository.login(
        clientId: clientId,
        userName: email,
        password: password,
      );

      isLoading = false;
      errorMessage = response['success'] == true ? null : response['message'];
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'An error occurred. Please try again.';
      notifyListeners();
    }
  }
}
