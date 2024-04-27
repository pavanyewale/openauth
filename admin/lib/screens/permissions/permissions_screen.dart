import 'package:admin/screens/permissions/header.dart';
import 'package:admin/screens/permissions/list.dart';
import 'package:flutter/material.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PermissionHeader(),
        PermissionsList(),
      ],
    );
  }
}
