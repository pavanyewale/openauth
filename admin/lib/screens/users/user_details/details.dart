import 'package:admin/screens/users/user_details/general_info.dart';
import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  final int userId;
  const UserDetailsScreen({super.key, this.userId = 0});

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
        title: userId == 0
            ? const Text("Add New User")
            : const Text("User Details"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: UserGeneralInfo(userId: userId),
            ),
          ),
        ),
      ),
    );
  }
}
