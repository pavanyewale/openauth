import 'package:flutter/material.dart';

class SubTextWithIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  const SubTextWithIcon({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 17,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text.isNotEmpty ? text : "Not Available",
          )
        ]);
  }
}
