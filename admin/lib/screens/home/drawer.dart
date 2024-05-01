import 'package:admin/screens/home/constants.dart';
import 'package:admin/screens/home/provider.dart';
import 'package:admin/utils/widgets/login/logout.dart';
import 'package:admin/screens/home/user_account.dart';
import 'package:admin/utils/screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Screen.isMobile(context);
    final provider = Provider.of<HomeProvider>(context);

    void selectTab(String name) {
      provider.changeTab(name);
      if (isMobile) {
        Navigator.pop(context);
      }
    }

    return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 180, maxWidth: 250),
        child: Scaffold(
            body: ListView(
              padding: EdgeInsets.zero,
              children: [
                if (isMobile) const UserAccDrawerHeader(),
                if (!isMobile)
                  Image.asset(
                    "assets/images/logo2.png",
                    height: 100,
                  ),
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('Dashboard'),
                  selected: provider.currentTab == DASHBOARD,
                  onTap: () {
                    selectTab(DASHBOARD);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Users'),
                  selected: provider.currentTab == USERS,
                  onTap: () {
                    selectTab(USERS);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text('Groups'),
                  selected: provider.currentTab == GROUPS,
                  onTap: () {
                    selectTab(GROUPS);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Permissions'),
                  selected: provider.currentTab == PERMISSIONS,
                  onTap: () {
                    selectTab(PERMISSIONS);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('History'),
                  selected: provider.currentTab == HISTORY,
                  onTap: () {
                    selectTab(HISTORY);
                  },
                ),
                const LogoutButton(),
              ],
            ),
            bottomNavigationBar:
                (!isMobile) ? const UserAccDrawerHeader() : null));
  }
}
