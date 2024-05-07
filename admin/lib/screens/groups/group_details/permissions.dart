import 'package:admin/models/groups/groups.dart';
import 'package:admin/models/permissions/permissions.dart';
import 'package:flutter/material.dart';

class GroupPermissionsScreen extends StatelessWidget {
  final GroupDetails groupDetails;
  const GroupPermissionsScreen({super.key, required this.groupDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Group Permissions"),
        ),
        body: GroupPermissions(
          groupDetails: groupDetails,
        ));
  }
}

class GroupPermissions extends StatefulWidget {
  final GroupDetails groupDetails;
  const GroupPermissions({super.key, required this.groupDetails});

  @override
  State<GroupPermissions> createState() => _GroupPermissionsState();
}

class _GroupPermissionsState extends State<GroupPermissions> {
  bool isLoading = false;
  String error = '';
  List<PermissionDetails> groupPermissions = [];

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
