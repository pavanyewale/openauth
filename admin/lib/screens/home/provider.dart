import 'package:admin/screens/home/constants.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  String currentTab = PERMISSIONS;
  void changeTab(String tab) {
    currentTab = tab;
    notifyListeners();
  }

  HomeProvider();
}
