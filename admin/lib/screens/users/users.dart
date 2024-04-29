import 'package:admin/screens/users/header.dart';
import 'package:admin/screens/users/list.dart';
import 'package:flutter/material.dart';

class Users extends StatelessWidget {
  const Users({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserHeader(),
        SizedBox(
          height: 20,
        ),
        UserList()
      ],
    );
  }
}
