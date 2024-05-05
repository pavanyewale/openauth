import 'package:admin/screens/users/user_details/form.dart';
import 'package:admin/utils/navigator.dart';
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
            // navigate to add new user screen
            Navigator.push(
                context,
                MyRoute(
                    builder: (context) => const AddNewUserScreen(userId: 0)));
          },
          child: const Row(children: [
            Icon(Icons.add),
            SizedBox(
              width: 5,
            ),
            Text("New User")
          ]),
        )
      ],
    );
  }
}
