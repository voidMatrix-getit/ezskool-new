import 'dart:convert';
import 'package:ezskool/core/bloc/auth_bloc.dart';
import 'package:ezskool/core/constants/api.dart';
import 'package:ezskool/core/constants/api_data.dart';
import 'package:ezskool/core/services/http_service.dart';
import 'package:ezskool/core/services/logger.dart';
import 'package:ezskool/presentation/screens/loginscreen.dart'; //views/login_screen.dart
import 'package:ezskool/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';

class AuthRepository extends HttpService {
  Future<Map<String, dynamic>> register({
    required String institutionName,
    required String contactPerson,
    required String contactNumber,
    required String city,
    int? institutionType,
    String? address,
    String? email,
    String? postalCode,
  }) async {
    // final uri = Uri.parse(url);
    final response = await post(
      API.buildUrl(API.register),
      data: {
        'inst_name': institutionName,
        'inst_cp': contactPerson,
        'inst_no': contactNumber,
        'inst_email': email ?? '',
        'inst_type': institutionType.toString() ?? '-1',
        'inst_add': address ?? '',
        'inst_city': city,
        'pincode': postalCode ?? '',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Registration failed.');
      }
    } else {
      throw Exception('Failed to connect to the server.');
    }
  }

  Future<Map<String, dynamic>> login({
    required String clientId,
    required String userName,
    required String password,
  }) async {
    try {
      // Using the generic post function
      final response = await post(
        API.buildUrl(API.login),
        data: {
          'client_id': clientId,
          'user_name': userName,
          'password': password,
        },
      );
      Log.d(response);

      if (response[APIData.success] == true) {
        await storeBearerToken(response[APIData.data][HttpService.token]);

        String? tk = await getBearerToken();

        Log.d(tk!);

        return response;
      } else {
        throw Exception('Login Failed: ${response['message']}');
      }
    } catch (error) {
      Log.d(error);
      throw Exception('Error during login: $error');
    }
  }

  Future<void> logout(BuildContext context) async {
    // API call to log out
    var tkn = await getBearerToken();
    final response = await post(
      API.buildUrl(API.logout),
      headers: {
        'Authorization': 'Bearer $tkn',
      },
    );

    if (response['success']) {
      await storeBearerToken('');

      stopShowing(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Logged out successfully'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.green),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } else {
      // Handle error case if logout fails
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to logout. Please try again!')),
      );
    }
  }

  Future<Map<String, dynamic>> logout2() async {
    try {
      // Get token
      String? tkn = await getBearerToken();
      if (tkn == null || tkn.isEmpty) {
        return {'success': false, 'message': 'No active session found'};
      }

      // Make server logout request
      final response = await post(
        API.buildUrl(API.logout),
        headers: {
          'Authorization': 'Bearer $tkn',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => {'success': false, 'error': 'Connection timeout'},
      );

      // Only proceed with local logout if server confirms success
      if (response['success'] == true) {
        // Clear token and other data
        await storeBearerToken('');

        return {'success': true, 'message': 'Logged out successfully'};
      } else {
        // Server rejected the logout
        return {
          'success': false,
          'message': response['error'] ?? 'Failed to log out. Please try again.'
        };
      }
    } catch (e) {
      // Error during logout
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }
}
