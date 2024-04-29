import 'package:flutter/material.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Users", style: Theme.of(context).textTheme.titleLarge),
        ElevatedButton(
          onPressed: () {
            print("Add user");
          },
          child: const Row(children: [
            Icon(Icons.add),
            SizedBox(
              width: 5,
            ),
            Text("New")
          ]),
        )
      ],
    );
  }
}
