import 'package:admin/screens/home/body.dart';
import 'package:admin/screens/home/drawer.dart';
import 'package:admin/utils/screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Screen.isMobile(context);
    return Scaffold(
      appBar: isMobile
          ? AppBar(
              title: Text(
                "OpenGate",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            )
          : null,
      drawer: isMobile
          ? const Drawer(
              elevation: double.infinity,
              child: MyDrawer(),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile) const Expanded(child: MyDrawer()),
          const Expanded(flex: 5, child: MyBody())
        ],
      ),
    );
  }
}
