import 'package:admin/models/groups/groups.dart';
import 'package:admin/screens/groups/group_details/info.dart';
import 'package:admin/screens/groups/group_details/permissions.dart';
import 'package:admin/screens/groups/group_details/users.dart';
import 'package:flutter/material.dart';

class GroupDetailsScreen extends StatefulWidget {
  final GroupDetails? groupDetails;
  const GroupDetailsScreen({super.key, this.groupDetails});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  GroupDetails groupDetails = GroupDetails();
  @override
  void initState() {
    if (widget.groupDetails != null) {
      groupDetails = widget.groupDetails!;
    }
    super.initState();
  }

  onCreate(GroupDetails details) {
    setState(() {
      groupDetails = details;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: groupDetails.id == 0
              ? const Text("Create Group")
              : const Text("Group Details"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                children: [
                  CreateUpdateGroupInfo(
                    groupDetails: widget.groupDetails,
                    onCreate: onCreate,
                  ),
                  if (groupDetails.id != 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: GroupUsers(
                        groupDetails: groupDetails,
                      ),
                    ),
                  if (groupDetails.id != 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: GroupPermissions(
                        groupDetails: groupDetails,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ));
  }
}
