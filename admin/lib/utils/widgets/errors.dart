import 'package:flutter/material.dart';

class MyErrorWidget extends StatelessWidget {
  const MyErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 200,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              color: Colors.red,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "An error occurred. Please try again later",
              style: TextStyle(color: Colors.red),
            )
          ],
        ),
      ),
    );
  }
}
