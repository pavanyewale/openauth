import 'package:admin/screens/groups/header.dart';
import 'package:admin/screens/groups/list.dart';
import 'package:flutter/material.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GroupHeader(),
        SizedBox(height: 20),
        GroupsList(),
      ],
    );
  }
}
