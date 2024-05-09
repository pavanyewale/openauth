import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  final String? msg;
  final double? height;
  final double? fontSize;
  final double? iconSize;
  const EmptyListWidget(
      {super.key, this.msg, this.height, this.fontSize, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty,
              size: iconSize ?? 50,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            Text(
              msg ?? 'No data found!',
              style: TextStyle(
                color: Colors.grey,
                fontSize: fontSize ?? 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
