import 'package:admin/models/permissions/permissions.dart';
import 'package:admin/screens/permissions/edit_dialog.dart';
import 'package:flutter/material.dart';

class PermissionHeader extends StatelessWidget {
  const PermissionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text("Permissions", style: Theme.of(context).textTheme.titleLarge),
      ElevatedButton(
          style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
              backgroundColor:
                  Theme.of(context).elevatedButtonTheme.style?.backgroundColor),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => EditPermissionDialog(
                permission: PermissionDetails(
                  id: 0,
                  name: '',
                  category: '',
                  description: '',
                  createdByUser: 0,
                  createdOn: 0,
                  updatedOn: 0,
                ),
                isCreate: true,
              ),
            );
          },
          child: const Row(
            children: [
              Icon(Icons.add),
              SizedBox(width: 5),
              Text('New Permission'),
            ],
          ))
    ]);
  }
}
