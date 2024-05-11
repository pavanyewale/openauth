import 'package:flutter/material.dart';

class SubTextWithIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  final int maxLines;
  final String iconLebel;
  const SubTextWithIcon(
      {super.key,
      required this.icon,
      required this.text,
      this.maxLines = 3,
      this.iconLebel = ''});

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
            semanticLabel: iconLebel,
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
              child: Text(
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            text.isNotEmpty ? text : "Not Available",
          ))
        ]);
  }
}
