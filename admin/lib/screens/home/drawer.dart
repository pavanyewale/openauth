import 'package:admin/utils/screen.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        if (!Screen.isMobile(context))
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 224, 224, 224),
            ),
            child: Center(
                child: Text(
              'OpenGate',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            )),
          )
      ],
    );
  }
}
