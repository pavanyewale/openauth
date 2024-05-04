import 'package:admin/apis/permissions.dart';
import 'package:admin/models/permissions/permissions.dart';
import 'package:admin/screens/permissions/edit_dialog.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/toast.dart';
import 'package:admin/utils/widgets/common.dart';
import 'package:flutter/material.dart';

class PermissionTile extends StatelessWidget {
  final PermissionDetails permission;
  final Function onDelete;
  const PermissionTile(
      {super.key, required this.permission, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(permission.id),
      leading: Icon(
        Icons.security,
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: Text(permission.name,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold)),
      subtitle: Wrap(
        spacing: 10,
        runSpacing: 5,
        children: [
          SubTextWithIcon(icon: Icons.category, text: permission.category),
          SubTextWithIcon(
              icon: Icons.description, text: permission.description),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(
          Icons.delete,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Permission'),
              content: Text(
                  'Are you sure you want to delete `${permission.name}` permission?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final res =
                        await PermissionService.deletePermission(permission.id);
                    if (res.error.isNotEmpty) {
                      MyToast.error(res.error);
                      return;
                    } else {
                      MyToast.success("Permission deleted successfully!");
                    }
                    onDelete();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => EditPermissionDialog(permission: permission),
        );
      },
    );
  }
}
