import 'package:admin/screens/users/user_details/general_info.dart';
import 'package:admin/screens/users/user_details/groups.dart';
import 'package:admin/screens/users/user_details/permissions.dart';
import 'package:admin/screens/users/user_details/reset_password.dart';
import 'package:flutter/material.dart';

class UserDetailsScreen extends StatefulWidget {
  final int userId;
  const UserDetailsScreen({super.key, this.userId = 0});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  int userId = 0;

  @override
  void initState() {
    userId = widget.userId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: widget.userId == 0
            ? const Text("Add New User")
            : const Text("User Details"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                children: [
                  UserGeneralInfo(userId: widget.userId),
                  if (widget.userId != 0)
                    Column(
                      children: [
                        const Divider(
                          height: 50,
                        ),
                        const ResetUserPassword(),
                        const Divider(
                          height: 50,
                        ),
                        UserGroups(
                          userID: widget.userId,
                        ),
                        const Divider(
                          height: 50,
                        ),
                        UserPermissions(userID: widget.userId)
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
