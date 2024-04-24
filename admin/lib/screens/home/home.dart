import 'package:admin/utils/screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Screen.isMobile(context)? AppBar():null,
      drawer:  Screen.isMobile(context)? const Drawer(elevation: double.infinity, child: MyDrawer(), ):null,
      body: Center(
        child: Text("Home Screen"),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      
    );
  }
}