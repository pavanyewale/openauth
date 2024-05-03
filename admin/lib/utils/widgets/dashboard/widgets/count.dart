import 'dart:math';

import 'package:flutter/material.dart';

class CountWidget extends StatelessWidget {
  final String title;
  final int count;

  CountWidget.fromJson(Map<String, dynamic> json, {super.key})
      : title = json['key'],
        count = json['total'];

  const CountWidget({super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // get a random color
        color: Color.fromRGBO(
          Random().nextInt(256),
          Random().nextInt(256),
          Random().nextInt(256),
          1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: const TextStyle(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
          ),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
