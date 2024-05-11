import 'package:admin/apis/group.dart';
import 'package:admin/apis/permissions.dart';
import 'package:admin/models/groups/groups.dart';
import 'package:admin/models/permissions/filters.dart';
import 'package:admin/models/permissions/permissions.dart';
import 'package:admin/utils/widgets/empty_list.dart';
import 'package:admin/utils/widgets/errors.dart';
import 'package:flutter/material.dart';

class GroupPermissionsScreen extends StatelessWidget {
  final GroupDetails groupDetails;
  const GroupPermissionsScreen({super.key, required this.groupDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Group Permissions"),
        ),
        body: GroupPermissions(
          groupDetails: groupDetails,
        ));
  }
}

class GroupPermissions extends StatefulWidget {
  final GroupDetails groupDetails;
  const GroupPermissions({super.key, required this.groupDetails});

  @override
  State<GroupPermissions> createState() => _GroupPermissionsState();
}

class _GroupPermissionsState extends State<GroupPermissions> {
  bool isLoading = false;
  String error = '';
  bool edit = false;

  List<PermissionDetails>? groupPermissions;

  saveGroupPermissions() async {
    setState(() {
      isLoading = true;
    });

    final res = await GroupService.savePermissions(
        widget.groupDetails.id, groupPermissions!);
    if (res.error.isNotEmpty) {
      setState(() {
        isLoading = false;
        error = res.error;
      });
      return;
    }
    setState(() {
      isLoading = false;
      edit = false;
      error = '';
    });
  }

  fetchGroupPermissions() {
    setState(() {
      isLoading = true;
    });

    GroupService.getPermissions(widget.groupDetails.id).then((res) {
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
        groupPermissions = res.permissions;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Permissions of the group",
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
                    if (error.isEmpty &&
                        (groupPermissions == null || groupPermissions!.isEmpty))
                      const EmptyListWidget(
                        msg: "No Permissions of the Group",
                        height: 100,
                      ),
                    if (groupPermissions != null)
                      ListView.separated(
                          separatorBuilder: (context, index) => const Divider(
                                height: 0,
                              ),
                          shrinkWrap: true,
                          itemCount: groupPermissions!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(groupPermissions![index].name),
                              subtitle:
                                  Text(groupPermissions![index].description),
                            );
                          }),
                    if (isLoading) const CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
            if (edit)
              AllPermissions(
                onAdd: (user) => setState(() {
                  groupPermissions!.add(user);
                }),
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
                    saveGroupPermissions();
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

class AllPermissions extends StatefulWidget {
  final Function(PermissionDetails) onAdd;
  const AllPermissions({super.key, required this.onAdd});

  @override
  State<AllPermissions> createState() => _AllPermissionsState();
}

class _AllPermissionsState extends State<AllPermissions> {
  bool isLoading = false;
  String error = '';
  List<PermissionDetails> allPermissions = [];
  int limit = 10;
  int offset = 0;
  PermissionsFilters filter = PermissionsFilters();
  fetchPermissions() async {
    setState(() {
      isLoading = true;
    });

    final res = await PermissionService.getPermissions(filter, offset, limit);
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
      allPermissions = res.permissions;
    });
  }

  @override
  void initState() {
    fetchPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("All Permissions",
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.bold)),
      if (error.isNotEmpty) const MyErrorWidget(),
      if (allPermissions.isEmpty && !isLoading && error.isEmpty)
        const EmptyListWidget(
          msg: "No Permissions found",
        ),
      if (allPermissions.isNotEmpty)
        ListView.builder(
          itemCount: allPermissions.length,
          itemBuilder: (context, index) {
            final permission = allPermissions[index];
            return ListTile(
              title: Text(permission.name),
              subtitle: Text(permission.description),
            );
          },
        ),
      if (isLoading) const CircularProgressIndicator(),
    ]);
  }
}
