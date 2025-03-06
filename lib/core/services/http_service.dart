import 'package:dio/dio.dart';
import 'package:ezskool/core/constants/api.dart';
import 'package:ezskool/core/constants/api_data.dart';
import 'package:ezskool/core/services/logger.dart';
import 'package:ezskool/core/services/secure_storage_service.dart';

class HttpService {
  final Dio _dio = Dio();
  static final String url = API.baseURL;
  static final token = APIData.bearerToken;
  final storage = SecureStorageService();

  Future<dynamic> get(String url, {Map<String, dynamic>? queryParameters,Map<String, String>? headers}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters,options: Options(headers: headers));
      return response.data;
    } catch (e) {
      Log.d(e);
      throw Exception('GET request failed: $e');
    }
  }


  Future<dynamic> post(String url, {Map<String, dynamic>? data, Map<String, String>? headers}) async {
    Future.delayed(Duration(seconds: 2));
    try {
      final response = await _dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      return response.data;
    } catch (e, stacktrace) {
      Log.d('Error: $e');
      Log.d('Stacktrace: $stacktrace');
      throw Exception('POST request failed: $e');
    }
  }

// Future<dynamic> postRequest(String url, {Map<String, dynamic>? data}) async {
  //   try {
  //     final response = await _dio.post(url, data: data);
  //     return response.data;
  //   } catch (e) {
  //     Log.d(e);
  //     throw Exception('POST request failed: $e');
  //   }
  // }
}



















// import 'package:http/http.dart' as http;
// import 'secure_storage_service.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
//
// class HttpService {
//
//   // Future<http.Response> get(
//   //     String url,
//   //     Map<String, String>? headers,
//   //     Object
//   //     ) async {
//   //
//   // }
//   //
//   // Future<http.Response> post(
//   //     String url,
//   //    ) async {
//   //
//   // }
//
//
//
// }






// class RegistrationRepository {
//   // late final String baseUrl = 'https://ezs.raktdaan.org/api/v1';
//
//   // RegistrationRepository(this.baseUrl, {});
//
//   Future<Map<String, dynamic>> submitRegistration({
//     required String institutionName,
//     required String contactPerson,
//     required String contactNumber,
//     required String city,
//     int? institutionType,
//     String? address,
//     String? email,
//     String? postalCode,
//   }) async {
//     final uri = Uri.parse('$baseUrl/inquiry/create');
//     final response = await http.post(
//       uri,
//       body: {
//         'inst_name': institutionName,
//         'inst_cp': contactPerson,
//         'inst_no': contactNumber,
//         'inst_email': email ?? '',
//         'inst_type': institutionType.toString(),
//         'inst_add': address ?? '',
//         'inst_city': city,
//         'pincode': postalCode ?? '',
//       },
//     );
//
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['success']) {
//         return data;
//       } else {
//         throw Exception(data['message'] ?? 'Registration failed.');
//       }
//     } else {
//       throw Exception('Failed to connect to the server.');
//     }
//   }
// }
//
//
//
// Future<Map<String, dynamic>> login({
//   required String clientId,
//   required String userName,
//   required String password}) async {
//   final Uri url = Uri.parse('https://ezs.raktdaan.org/api/v1/login');
//
//   try {
//     // Making the POST request with the required parameters
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: json.encode({
//         'client_id': clientId,
//         'user_name': userName,
//         'password': password,
//       }),
//     );
//
//     // Check if the response is successful
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//
//       if (data['success'] == true) {
//         // Extract the token from the response
//
//         String token = data['data']['token'];
//
//         // Save the token to shared preferences
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('token', token);
//         return data;
//         // print('Login Successful');
//       } else {
//         throw Exception('Login Failed: ${data['message']}');
//         // print('Login Failed: ${data['message']}');
//       }
//     } else {
//       throw Exception('Failed to connect to the server');
//       // print('Failed to connect to the server');
//     }
//   } catch (error) {
//     throw Exception(error.toString());
//     // print('Error: $error');
//   }
// }
//
// // Method to retrieve the token from shared_preferences
// Future<String?> getToken() async {
//   final prefs = await SharedPreferences.getInstance();
//   // await prefs.setString('token', '31|bf3ACSDGyth0bgdoIXlvK1tVMMWhCMkavPA32idC2257fd25');
//   return prefs.getString('token');
// }
//
// Future<void> setToken() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setString('token', '31|bf3ACSDGyth0bgdoIXlvK1tVMMWhCMkavPA32idC2257fd25');
// }
//
// // Logout function to remove the token from SharedPreferences
// Future<void> logout(BuildContext context) async {
//
//   // API call to log out
//   var tkn = await getToken();
//   final response = await http.post(
//     Uri.parse('https://ezs.raktdaan.org/api/v1/logout'), // Use your logout API URL here
//     headers: {
//       'Authorization': 'Bearer $tkn', // Replace with your actual token
//     },
//   );
//
//   if (response.statusCode == 200) {
//     // If the server returns a 200 OK response, navigate to the login screen
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Logged out successfully')),
//     );
//
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginScreen()),
//     );
//   } else {
//     // Handle error case if logout fails
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Failed to logout. Please try again!')),
//     );
//   }
// }


