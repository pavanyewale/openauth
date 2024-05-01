// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
// ignore: library_prefixes
import 'dart:io' as platformCheck;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  void setString(String key, String value);
  Future<String?> getString(String key);

  factory LocalStorage() {
    if (kIsWeb) {
      return WebLocalStorage._instance;
    }

    if (platformCheck.Platform.isAndroid) {
      return AndroidLocalStorage._instance;
    }
    if (platformCheck.Platform.isIOS) {
      return IOSLocalStorage._instance;
    }
    return WebLocalStorage._instance;
  }
}

class IOSLocalStorage implements LocalStorage {
  final SharedPreferences _sharedPreferences =
      SharedPreferences.getInstance() as SharedPreferences;
  IOSLocalStorage._privateConstructor();

  static final IOSLocalStorage _instance =
      IOSLocalStorage._privateConstructor();

  factory IOSLocalStorage() => _instance;

  @override
  Future<String> getString(String key) async {
    return _sharedPreferences.getString(key) ?? '';
  }

  @override
  void setString(String key, String value) {
    _sharedPreferences.setString(key, value);
  }
}

class WebLocalStorage implements LocalStorage {
  WebLocalStorage._privateConstructor();

  static final WebLocalStorage _instance =
      WebLocalStorage._privateConstructor();

  factory WebLocalStorage() => _instance;

  @override
  Future<String?> getString(String key) async {
    return window.localStorage[key];
  }

  @override
  void setString(String key, String value) {
    window.localStorage[key] = value;
  }
}

class AndroidLocalStorage implements LocalStorage {
  final SharedPreferences _sharedPreferences =
      SharedPreferences.getInstance() as SharedPreferences;
  AndroidLocalStorage._privateConstructor();

  static final AndroidLocalStorage _instance =
      AndroidLocalStorage._privateConstructor();

  factory AndroidLocalStorage() => _instance;

  @override
  Future<String> getString(String key) async {
    return _sharedPreferences.getString(key) ?? '';
  }

  @override
  void setString(String key, String value) {
    _sharedPreferences.setString(key, value);
  }
}
