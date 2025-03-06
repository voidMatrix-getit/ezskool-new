import 'package:flutter/material.dart';
import 'package:ezskool/data/repo/auth_repo.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  String email = '';
  String? errorMessage;
  bool isLoading = false;

  Future<void> sendResetLink() async {
    if (email.isEmpty) {
      errorMessage = "Please enter your email";
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

  //   // final response = await _authRepository.sendPasswordResetLink(email);
  //
    isLoading = false;
  //   if (response != null) {
  //     errorMessage = response.message;
  //   }
  //   notifyListeners();
  }
}
