import 'package:ezskool/core/constants/api.dart';
import 'package:ezskool/core/constants/api_data.dart';
import 'package:ezskool/core/services/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


const androidOptions = AndroidOptions(
  encryptedSharedPreferences: true,
  resetOnError: true, // Will clear storage if decryption fails
);

final storage = SecureStorageService();


Future<void> storeBaseURL() async {
  await storage.write(APIData.baseURL, API.baseURL);
}


Future<void> storeBearerToken(String token) async {
  await storage.write(APIData.bearerToken, token);
}


Future<String?> getBaseURL() async {
  return await storage.read(APIData.baseURL);
}


Future<String?> getBearerToken() async {
    return await storage.read(APIData.bearerToken);

}
