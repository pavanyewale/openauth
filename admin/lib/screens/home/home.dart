import 'package:admin/screens/home/body.dart';
import 'package:admin/screens/home/drawer.dart';
import 'package:admin/screens/home/provider.dart';
import 'package:admin/utils/screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Screen.isMobile(context);

    // appbar
    AppBar appbar = AppBar(
      title: Text(
        "OpenAuth",
        style: TextStyle(
            color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
      ),
    );

    //
    return ChangeNotifierProvider(
        create: (_) => HomeProvider(),
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: appbar,
          drawer: isMobile
              ? const Drawer(
                  elevation: double.infinity,
                  child: MyDrawer(),
                )
              : null,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMobile) const MyDrawer(),
              const VerticalDivider(),
              const Expanded(flex: 1, child: MyBody())
            ],
          ),
        ));
  }
}
