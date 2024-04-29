import 'package:admin/apis/permissions.dart';
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
  int limit = 10;
  int skip = 0;
  bool isLoading = false;
  String error = '';

  void fetchPermissions() async {
    setState(() {
      isLoading = true;
    });

    final res = await PermissionService.getPermissions(skip, limit);
    if (res.error.isNotEmpty) {
      MyToast.error(res.error);
      setState(() {
        error = res.error;
        isLoading = false;
      });
      return;
    }
    setState(() {
      permissions.clear();
      permissions.addAll(res.permissions);
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
      /*
      
       add loading indicator
      
      */
      if (isLoading)
        const Center(
          child: CircularProgressIndicator(),
        ),

      /*
      
       add error message
      
      */

      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 10,
        ),
        const SizedBox(height: 10),
        if (!isLoading && error.isEmpty && permissions.isEmpty)
          const Center(
            child: Text('No permissions found'),
          ),
        if (error.isNotEmpty)
          Center(
            child: Text(error, style: const TextStyle(color: AppColors.error)),
          ),

        /*
        
         add list of permissions
        
        */
        ListView.separated(
          separatorBuilder: (context, index) =>
              const SizedBox(height: 5), // Add space between items
          itemCount: permissions.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final permission = permissions[index];
            return ListTile(
              tileColor: Theme.of(context).secondaryHeaderColor,
              key: ValueKey(permission.id),
              leading: Icon(
                Icons.security,
                color: Theme.of(context).primaryColorDark,
              ),
              title: Text(permission.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category:  ${permission.category}'),
                  Text('Description: ${permission.description}'),
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
                                await PermissionService.deletePermission(
                                    permission.id);
                            if (res.error.isNotEmpty) {
                              MyToast.error(res.error);
                              return;
                            } else {
                              MyToast.success(
                                  "Permission deleted successfully!");
                            }
                            setState(() {
                              permissions.removeAt(index);
                            });
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
                  builder: (context) =>
                      EditPermissionDialog(permission: permission),
                );
              },
            );
          },
        ),
        const SizedBox(height: 10),

        /*
        
         add next and prev buttons
        
        */
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (skip > 0)
                ? ElevatedButton(
                    onPressed: () {
                      skip -= limit;
                      fetchPermissions();
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back),
                        SizedBox(width: 5),
                        Text('Prev'),
                      ],
                    ),
                  )
                : const SizedBox(),
            (permissions.length == limit)
                ? ElevatedButton(
                    onPressed: () {
                      skip += limit;
                      fetchPermissions();
                    },
                    child: const Row(
                      children: [
                        Text('Next'),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        )
      ])
    ]);
  }
}
