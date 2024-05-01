import 'package:flutter/material.dart';

class CommingSoon extends StatelessWidget {
  const CommingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_top,
              size: 50,
              color: Colors.grey,
            ),
            SizedBox(height: 10),
            Text(
              'Comming Soon...!',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
