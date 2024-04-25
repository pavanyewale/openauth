import 'package:admin/screens/home/constants.dart';
import 'package:flutter/material.dart';


class HomeProvider extends ChangeNotifier{
  String currentTab = DASHBOARD;
  void changeTab(String tab){
    currentTab = tab;
    notifyListeners();
  }

   HomeProvider._();

  // Singleton instance variable
  static final HomeProvider _instance = HomeProvider._();

  // Getter to access the singleton instance
  static HomeProvider get instance => _instance;
}