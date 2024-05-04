import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class Utils {
  // Private constructor to prevent instantiation from outside
  Utils._();

  // Singleton instance variable
  static final Utils _instance = Utils._();

  // Getter to access the singleton instance
  static Utils get instance => _instance;

  Future<String> fetchDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String info = "";
    try {
      if (Platform.isAndroid) {
        var androidInfo = await deviceInfo.androidInfo;
        info = {"device":androidInfo.device, "model":androidInfo.device, "androidVersion":androidInfo.version}.toString();
      } else if (Platform.isIOS) {
        info = (await deviceInfo.iosInfo).toString();
      } else {
        info = (await deviceInfo.webBrowserInfo).toString();
      }
    } catch (e) {
      try {
        info = (await deviceInfo.webBrowserInfo).toString();
      } catch (e) {
        print("$e");
        info = "unknown device";
      }
    }
    return info;
  }

  bool isValidMobileOrEmail(String value) {
    return isValidMobile(value) || isValidEmail(value);
  }

  bool isValidMobile(String value) {
    return RegExp(r'^[0-9]{10}$').hasMatch(value);
  }

  bool isValidEmail(String value) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value);
  }
}
