
import 'package:admin/utils/login/logout.dart';
import 'package:admin/utils/login/service.dart';
import 'package:admin/utils/screen.dart';
import 'package:flutter/material.dart';

class UserAccDrawerHeader extends StatelessWidget {
  const UserAccDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = LoginService.instance.user;
    final name = '${user.firstName} ${user.lastName}';
    return Padding(
        padding: const EdgeInsets.all(10),
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
            Text(name),
            if (!Screen.isMobile(context)) const LogoutButton(),
          ],
        ));
  }
}
