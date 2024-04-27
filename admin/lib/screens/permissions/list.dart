import 'package:admin/apis/permissions/service.dart';
import 'package:admin/models/permissions.dart';
import 'package:admin/screens/permissions/edit_dialog.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/toast.dart';
import 'package:flutter/material.dart';

class PermissionsList extends StatefulWidget {
  const PermissionsList({super.key});

  @override
  State<PermissionsList> createState() => _PermissionsListState();
}

class _PermissionsListState extends State<PermissionsList> {
  final List<PermissionDetails> permissions = [];
  int limit = 20;
  int offset = 0;
  bool isLoading = false;
  String error = '';

  void fetchPermissions() async {
    setState(() {
      isLoading = true;
    });

    final res = await PermissionService.instance.getPermissions(offset, limit);
    if (res.error.isNotEmpty) {
      MyToast.error(res.error);
      setState(() {
        error = res.error;
        isLoading = false;
      });
      return;
    }
    setState(() {
      permissions.addAll(res.permissions);
      offset += res.permissions.length;
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      if (isLoading)
        const Center(
          child: CircularProgressIndicator(),
        ),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 10),
        if (error.isEmpty && permissions.isEmpty)
          const Center(
            child: Text('No permissions found'),
          ),
        if (error.isNotEmpty)
          Center(
            child: Text(error, style: const TextStyle(color: AppColors.error)),
          ),
        ListView.separated(
          separatorBuilder: (context, index) =>
              const SizedBox(height: 5), // Add space between items
          itemCount: permissions.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final permission = permissions[index];
            return ListTile(
              tileColor: Theme.of(context).primaryColorLight,
              key: ValueKey(permission.id),
              leading: const Icon(Icons.security),
              title: Text(permission.name),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Permission'),
                      content: const Text(
                          'Are you sure you want to delete this permission?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final res = await PermissionService.instance
                                .deletePermission(permission.id);
                            if (res.error.isNotEmpty) {
                              MyToast.error(res.error);
                              return;
                            }
                            setState(() {
                              permissions.removeAt(index);
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              subtitle: Text(permission.description),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      EditPermissionDialog(permission: permission),
                );
              },
            );
          },
        )
      ])
    ]);
  }
}
