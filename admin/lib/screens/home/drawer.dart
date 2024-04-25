import 'package:admin/utils/screen.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Screen.isMobile(context);
    return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 180, maxWidth: 220),
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
                    'OpenGate',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )),
                ),
              ListTile(
                leading: Icon(Icons.dashboard),
                title: Text('Dashboard'),
                onTap: () {
                  // Navigate to Dashboard
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Users'),
                onTap: () {
                  // Navigate to User
                },
              ),
              ListTile(
                leading: Icon(Icons.group),
                title: Text('Groups'),
                onTap: () {
                  // Navigate to Groups
                },
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text('Permissions'),
                onTap: () {
                  // Navigate to Permissions
                },
              ),
            ],
          ),
          bottomNavigationBar: (!isMobile) ? const UserAccDrawerHeader() : null,
        ));
  }
}

class UserAccDrawerHeader extends StatelessWidget {
  const UserAccDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: Text('John Doe'),
      accountEmail: Text('john.doelkdjfgllkjsdf@example.com'),
      currentAccountPicture: CircleAvatar(
        child: Icon(Icons.person),
      ),
      otherAccountsPictures: [
        GestureDetector(
          onTap: () {
            // Perform logout action
          },
          child: CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 72, 71, 71),
            child: Icon(Icons.exit_to_app, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
