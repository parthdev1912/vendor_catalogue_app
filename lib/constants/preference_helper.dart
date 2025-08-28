import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_catalogue_app/constants/encryption.dart';

class PreferenceHelper {
  PreferenceHelper._();
  static SharedPreferences? _prefs;
  static String _encryptionKey = '';

  static Future<void> init({required String encryptionKey}) async {
    _prefs = await SharedPreferences.getInstance();
    _encryptionKey = encryptionKey;
  }

  static Future<void> setBoolPrefValue({
    required String key,
    required bool value,
  }) async {
    await setEncryptedValue(key: key, value: value.toString());
  }

  static Future<void> setStringPrefValue({
    required String key,
    required String value,
  }) async {
    await setEncryptedValue(key: key, value: value);
  }

  static Future<void> setIntPrefValue({
    required String key,
    required int value,
  }) async {
    await setEncryptedValue(key: key, value: value.toString());
  }

  static Future<void> setDoublePrefValue({
    required String key,
    required double value,
  }) async {
    await setEncryptedValue(key: key, value: value.toString());
  }

  static bool? getBoolPrefValue({
    required String key,
  }) {
    final String? value = getDecryptedValue(key: key);
    if ((value?.isNotEmpty ?? false)) {
      return value?.toBoolean();
    } else {
      return null;
    }
  }

  static String getStringPrefValue({
    required String key,
  }) {
    final String? value = getDecryptedValue(key: key);
    if ((value?.isNotEmpty ?? false)) {
      return value ?? '';
    } else {
      return '';
    }
  }

  static int? getIntPrefValue({
    required String key,
  }) {
    final value = getDecryptedValue(key: key);
    if (value?.isNotEmpty ?? false) {
      return int.parse(value ?? '0');
    } else {
      return null;
    }
  }

  static double? getDoublePrefValue({
    required String key,
  }) {
    final value = getDecryptedValue(key: key);

    if (value?.isNotEmpty ?? false) {
      return double.parse(value ?? "0.0");
    } else {
      return null;
    }
  }

  static Future<bool> removePrefValue({
    required String key,
  }) async {
    final Future<bool> value = _prefs!.remove("v2" + key);
    return value;
  }

  static Future<bool> clearAll() async {
    final Future<bool> value = _prefs!.clear();
    return value;
  }

  static Future<void> setEncryptedValue(
      {required String key, required String value}) async {
    if (value.isNotEmpty) {
      await _prefs?.setString("v2" + key,
          EncryptionHelper.encrypt(value: value, key: _encryptionKey));
    }
  }

  static String? getDecryptedValue({required String key}) {
    final value = _prefs?.getString("v2" + key);
    if (value?.isNotEmpty ?? false) {
      return EncryptionHelper.decrypt(value: value ?? '', key: _encryptionKey);
    } else {
      return null;
    }
  }
}

extension on String {
  bool? toBoolean() {
    return (toLowerCase() == "true" || toLowerCase() == "1")
        ? true
        : (toLowerCase() == "false" || toLowerCase() == "0" ? false : null);
  }
}
