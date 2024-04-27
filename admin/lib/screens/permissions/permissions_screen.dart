import 'package:admin/apis/permissions/service.dart';
import 'package:admin/models/permissions.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/toast.dart';
import 'package:flutter/material.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
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
      Column(children: [
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
              subtitle: Text(permission.description),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showMenu(
                    context: context,
                    position: const RelativeRect.fromLTRB(0, 0, 0, 0),
                    items: [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                      const PopupMenuItem(
                        value: 'details',
                        child: Text('Details'),
                      ),
                    ],
                    elevation: 8.0,
                  ).then((value) {
                    if (value == 'edit') {
                      // Handle edit option
                    } else if (value == 'delete') {
                      // Handle delete option
                    } else if (value == 'details') {
                      // Handle details option
                    }
                  });
                },
              ),
            );
          },
        )
      ])
    ]);
  }
}
