import 'package:flutter/material.dart';

class CountWidget extends StatelessWidget {
  final String title;
  final int count;

  CountWidget.fromJson(Map<String, dynamic> json, {super.key})
      : title = json['title'],
        count = json['count'];

  const CountWidget({super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
