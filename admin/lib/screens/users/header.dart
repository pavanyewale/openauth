import 'package:admin/screens/users/add_new_user/new_user.dart';
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
                MaterialPageRoute(
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
