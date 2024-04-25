import 'package:admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyToast {
  static void error(  String msg) {
    Fluttertoast.showToast(
      msg: msg,
      webBgColor: "white",
      textColor: AppColors.error,
      backgroundColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      webPosition: "center",
    );
  }

  static void success(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      webBgColor: "white",
      textColor: AppColors.success,
      backgroundColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      webPosition: "center",
      toastLength: Toast.LENGTH_SHORT
    );
  }
}
