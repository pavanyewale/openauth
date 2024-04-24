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
        info = (await deviceInfo.androidInfo).toString();
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
}
