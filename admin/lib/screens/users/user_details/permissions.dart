import 'package:admin/apis/group.dart';
import 'package:admin/models/groups/group_permissions.dart';
import 'package:admin/models/permissions/permissions.dart';
import 'package:admin/screens/groups/group_details/permissions.dart';
import 'package:admin/utils/toast.dart';
import 'package:admin/utils/widgets/empty_list.dart';
import 'package:admin/utils/widgets/loader_tile.dart';
import 'package:flutter/material.dart';

class UserPermissionsScreen extends StatelessWidget {
  final int userId;
  const UserPermissionsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User Permissions"),
        ),
        body: UserPermissions(
          userID: userId,
        ));
  }
}

class UserPermissions extends StatefulWidget {
  final int userID;
  const UserPermissions({super.key, required this.userID});

  @override
  State<UserPermissions> createState() => _UserPermissionsState();
}

class _UserPermissionsState extends State<UserPermissions> {
  bool isLoading = false;
  String error = '';
  bool edit = false;

  List<PermissionDetails> userPermissions = [];

  saveUserPermissions() async {
    setState(() {
      isLoading = true;
    });

    final String err =
        await GroupService.savePermissions(widget.userID, userPermissions);
    if (err.isNotEmpty) {
      setState(() {
        isLoading = false;
        error = err;
      });
      return;
    }
    MyToast.success("Permissions saved successfully");
    setState(() {
      isLoading = false;
      edit = false;
      error = '';
    });
  }

  fetchUserPermissions() async {
    setState(() {
      isLoading = true;
    });

    GetGroupPermissionsResponse res =
        await GroupService.getPermissions(widget.userID);
    if (res.error.isNotEmpty) {
      setState(() {
        isLoading = false;
        error = res.error;
      });
      return;
    }
    setState(() {
      isLoading = false;
      error = '';
      userPermissions.addAll(res.permissions);
    });
  }

  removePermission(int index) async {
    setState(() {
      isLoading = true;
    });

    final String err = await GroupService.removePermission(
        widget.userID, userPermissions[index].id);
    if (err.isNotEmpty) {
      setState(() {
        isLoading = false;
        error = err;
      });
      return;
    }
    MyToast.success("Permission removed successfully");
    setState(() {
      isLoading = false;
      error = '';
      userPermissions.removeAt(index);
    });
  }

  @override
  void initState() {
    fetchUserPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Permissions of the user",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          if (!edit)
            IconButton(
                onPressed: () {
                  setState(() {
                    edit = true;
                  });
                },
                icon: const Icon(Icons.edit))
        ]),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            Container(
              decoration: BoxDecoration(border: Border.all()),
              padding: const EdgeInsets.all(10),
              constraints: const BoxConstraints(maxHeight: 250, minHeight: 100),
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (error.isNotEmpty)
                      Text(error,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error)),
                    if (error.isEmpty && (userPermissions.isEmpty))
                      const EmptyListWidget(
                        msg: "No Permissions of the User",
                        height: 100,
                      ),
                    ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                              height: 0,
                            ),
                        shrinkWrap: true,
                        itemCount: userPermissions.length,
                        itemBuilder: (context, index) {
                          return PermissionTile(
                              iconData: Icons.remove_circle_outline,
                              permission: userPermissions[index],
                              onAdd: () {
                                removePermission(index);
                              });
                        }),
                    if (isLoading) const LoaderTile(),
                  ],
                ),
              ),
            ),
            if (edit)
              AllPermissions(
                onAdd: (permission) {
                  setState(() {
                    userPermissions.add(permission);
                  });
                },
              ),
          ],
        ),
        const SizedBox(height: 20),
        if (edit)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: () {
                    saveUserPermissions();
                  },
                  child: const Text("Save")),
              const SizedBox(width: 20),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      edit = false;
                    });
                  },
                  child: const Text("Cancel")),
            ],
          )
      ],
    );
  }
}
