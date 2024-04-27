import 'package:admin/models/permissions.dart';
import 'package:admin/screens/permissions/form.dart';
import 'package:flutter/material.dart';

class EditPermissionDialog extends StatelessWidget {
  final PermissionDetails permission;

  final bool isCreate;

  const EditPermissionDialog(
      {super.key, required this.permission, this.isCreate = false});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: PermissionForm(
          permission: permission,
          isCreate: isCreate,
        ),
      ),
    );
  }
}
