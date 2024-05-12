import 'package:flutter/material.dart';

class MyErrorWidget extends StatelessWidget {
  final String? error;
  const MyErrorWidget({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "An error occurred. Please try again later",
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            )
          ],
        ),
      ),
    );
  }
}
