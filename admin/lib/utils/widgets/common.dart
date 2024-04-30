import 'package:flutter/material.dart';

class SubTextWithIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  const SubTextWithIcon({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 17,
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
              child: Text(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            text.isNotEmpty ? text : "Not Available",
          ))
        ]);
  }
}
