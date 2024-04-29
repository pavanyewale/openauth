import 'package:admin/screens/dashboard/dashboard.dart';
import 'package:admin/screens/groups/groups.dart';
import 'package:admin/screens/history/history.dart';
import 'package:admin/screens/home/constants.dart';
import 'package:admin/screens/home/provider.dart';
import 'package:admin/screens/permissions/permissions_screen.dart';
import 'package:admin/screens/users/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBody extends StatelessWidget {
  const MyBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    Widget getCurrentScreen() {
      switch (provider.currentTab) {
        case DASHBOARD:
          return const Dashboard();
        case USERS:
          return const Users();
        case PERMISSIONS:
          return const PermissionsScreen();
        case HISTORY:
          return const HistoryScreen();
        case GROUPS:
          return const GroupsScreen();
      }
      return Text("invalid tab ${provider.currentTab}");
    }

    return Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(child: getCurrentScreen()));
  }
}
