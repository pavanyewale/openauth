import 'package:admin/screens/home/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBody extends StatelessWidget {
  const MyBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            children: [Text(provider.currentTab, style: Theme.of(context).textTheme.titleLarge)],
          ),
          Container(color: Color.fromARGB(255, 244, 244, 244))
        ]));
  }
}
