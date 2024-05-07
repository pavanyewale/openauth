import 'package:admin/models/groups/groups.dart';
import 'package:flutter/material.dart';

class GroupUsersScreen extends StatelessWidget {
  final GroupDetails groupDetails;
  const GroupUsersScreen({super.key, required this.groupDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Group Users"),
        ),
        body: GroupUsers(
          groupDetails: groupDetails,
        ));
  }
}

class GroupUsers extends StatefulWidget {
  final GroupDetails groupDetails;
  const GroupUsers({super.key, required this.groupDetails});

  @override
  State<GroupUsers> createState() => _GroupUsersState();
}

class _GroupUsersState extends State<GroupUsers> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
