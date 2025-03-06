import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();

  factory SecureStorageService() {
    return _instance;
  }

  late final FlutterSecureStorage _secureStorage;

  static const androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
    resetOnError: true, // Will clear storage if decryption fails
  );

  SecureStorageService._internal() {
    _secureStorage = const FlutterSecureStorage(aOptions: androidOptions);
  }

  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }
}
