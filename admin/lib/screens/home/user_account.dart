import 'package:admin/utils/widgets/login/service.dart';
import 'package:flutter/material.dart';

class UserAccDrawerHeader extends StatelessWidget {
  const UserAccDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = LoginService.instance.user;
    final name = (user.firstName.isNotEmpty || user.lastName.isNotEmpty)
        ? '${user.firstName} ${user.lastName}'
        : 'Unknown User';
    return DecoratedBox(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(name, style: const TextStyle(color: Colors.white)),
              ],
            )));
  }
}
