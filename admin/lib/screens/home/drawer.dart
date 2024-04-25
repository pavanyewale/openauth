import 'package:admin/screens/home/constants.dart';
import 'package:admin/screens/home/provider.dart';
import 'package:admin/utils/login/logout.dart';
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
    return  ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 180, maxWidth: 250),
            child: Scaffold(
                body: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: [
                    if (isMobile)
                      const UserAccDrawerHeader()
                    else
                      DrawerHeader(
                        decoration: const BoxDecoration(
                            // color: Color.fromARGB(255, 224, 224, 224),
                            ),
                        child: Center(
                            child: Text(
                          'TestApp',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        )),
                      ),
                    ListTile(
                      leading: const Icon(Icons.dashboard),
                      title: const Text('Dashboard'),
                      selected: provider.currentTab == DASHBOARD,
                      onTap: () {
                        provider.changeTab(DASHBOARD);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Users'),
                      selected: provider.currentTab == USERS,
                      onTap: () {
                        provider.changeTab(USERS);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.group),
                      title: const Text('Groups'),
                      selected: provider.currentTab == GROUPS,
                      onTap: () {
                        provider.changeTab(GROUPS);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text('Permissions'),
                      selected: provider.currentTab == PERMISSIONS,
                      onTap: () {
                        provider.changeTab(PERMISSIONS);
                      },
                    ),
                  ],
                ),
                bottomNavigationBar: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  const Divider(),
                  (!isMobile)
                      ? const UserAccDrawerHeader()
                      : const LogoutButton(),
                ])));
  }
}
