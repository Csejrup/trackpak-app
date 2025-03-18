import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageProvider {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  ///  **Write String**
  Future<void> writeString(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      print("❌ SecureStorageProvider Error (writeString): $e");
    }
  }

  ///  **Read String**
  Future<String?> readString(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      print("❌ SecureStorageProvider Error (readString): $e");
      return null;
    }
  }

  ///  **Delete Key**
  Future<void> deleteKey(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      print("❌ SecureStorageProvider Error (deleteKey): $e");
    }
  }

  ///  **Write Boolean**
  Future<void> writeBool(String key, bool value) async {
    try {
      await _storage.write(key: key, value: value.toString());
    } catch (e) {
      print("❌ SecureStorageProvider Error (writeBool): $e");
    }
  }

  ///  **Read Boolean**
  Future<bool> readBool(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value == 'true';
    } catch (e) {
      print("❌ SecureStorageProvider Error (readBool): $e");
      return false;
    }
  }

  ///  **Write Integer**
  Future<void> writeInt(String key, int value) async {
    try {
      await _storage.write(key: key, value: value.toString());
    } catch (e) {
      print("❌ SecureStorageProvider Error (writeInt): $e");
    }
  }

  ///  **Read Integer**
  Future<int?> readInt(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null ? int.tryParse(value) : null;
    } catch (e) {
      print("❌ SecureStorageProvider Error (readInt): $e");
      return null;
    }
  }

  ///  **Clear All Storage**
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      print(" SecureStorageProvider: All keys deleted successfully.");
    } catch (e) {
      print("❌ SecureStorageProvider Error (clearAll): $e");
    }
  }
}
