import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static FlutterSecureStorage get storage {
    return const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions());
  }
}
