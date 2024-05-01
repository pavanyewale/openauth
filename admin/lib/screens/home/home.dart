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
      centerTitle: false,
      title: Image.asset(
        "assets/images/logo2.png",
        height: 30,
      ),
    );

    //
    return ChangeNotifierProvider(
        create: (_) => HomeProvider(),
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: isMobile ? appbar : null,
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
              if (!isMobile) Container(width: 2, color: Colors.grey[300]),
              const Expanded(flex: 1, child: MyBody())
            ],
          ),
        ));
  }
}
