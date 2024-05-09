import 'package:admin/apis/group.dart';
import 'package:admin/apis/users.dart';
import 'package:admin/models/groups/group_users.dart';
import 'package:admin/models/groups/groups.dart';
import 'package:admin/models/users/users.dart';
import 'package:admin/utils/toast.dart';
import 'package:admin/utils/widgets/empty_list.dart';
import 'package:flutter/material.dart';

class GroupUsersScreen extends StatelessWidget {
  final GroupDetails groupDetails;
  const GroupUsersScreen({super.key, required this.groupDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Group Users"),
        ),
        body: GroupUsers(
          groupDetails: groupDetails,
        ));
  }
}

class GroupUsers extends StatefulWidget {
  final GroupDetails groupDetails;
  const GroupUsers({super.key, required this.groupDetails});

  @override
  State<GroupUsers> createState() => _GroupUsersState();
}

class _GroupUsersState extends State<GroupUsers> {
  bool edit = false;
  List<ShortUserDetails>? groupUsers;
  bool isLoading = false;
  String error = '';
  int limit = 0, offset = 0;

  saveGroupUsers() async {
    setState(() {
      isLoading = true;
    });
    List<int> userIds = groupUsers!.map((e) => e.id).toList();
    String err = await GroupService.addUsersToGroup(AddUsersToGroupRequest(
        groupId: widget.groupDetails.id, userIds: userIds));
    if (err.isNotEmpty) {
      MyToast.error(err);
      setState(() {
        error = err;
        isLoading = false;
      });
    } else {
      MyToast.success("Users added to the group");
      setState(() {
        isLoading = false;
        edit = false;
      });
    }
  }

  fetchGroupUsers() async {
    setState(() {
      isLoading = true;
    });
    GetUsersOfGroupResponse res =
        await GroupService.getUsersOfGroup(widget.groupDetails.id);
    if (res.error.isNotEmpty) {
      setState(() {
        error = res.error;
        isLoading = false;
      });
    } else {
      setState(() {
        groupUsers = res.users;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchGroupUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Users of the group",
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
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all()),
                padding: const EdgeInsets.all(10),
                height: 250,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Group Users",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                      if (error.isNotEmpty)
                        Text(error,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error)),
                      if (groupUsers != null && groupUsers!.isEmpty)
                        const EmptyListWidget(
                          msg: "No Users in the Group",
                          height: 100,
                        ),
                      if (groupUsers != null)
                        ListView.separated(
                            separatorBuilder: (context, index) => const Divider(
                                  height: 0,
                                ),
                            shrinkWrap: true,
                            itemCount: groupUsers!.length,
                            itemBuilder: (context, index) {
                              return GroupUser(
                                  user: groupUsers![index],
                                  onClick: edit
                                      ? () {
                                          setState(() {
                                            groupUsers!.removeAt(index);
                                          });
                                        }
                                      : null,
                                  icon: Icons.remove_circle_outline);
                            }),
                      if (isLoading) const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
              if (edit)
                AllUsersList(
                  groupId: widget.groupDetails.id,
                  onAdd: (user) => setState(() {
                    groupUsers!.add(user);
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
                      saveGroupUsers();
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
      ),
    );
  }
}

class AllUsersList extends StatefulWidget {
  const AllUsersList({super.key, required this.groupId, required this.onAdd});
  final Function(ShortUserDetails) onAdd;
  final int groupId;

  @override
  State<AllUsersList> createState() => _AllUsersListState();
}

class _AllUsersListState extends State<AllUsersList> {
  List<ShortUserDetails>? users;
  bool isLoading = true;
  String error = '';
  int limit = 0, offset = 0;
  bool edit = false;

  fetchUsers() async {
    setState(() {
      isLoading = true;
    });
    GetUsersResponse res =
        await UsersService.getUsers(GetUsersFilters(), offset, limit);
    if (res.error.isNotEmpty) {
      setState(() {
        error = res.error;
        isLoading = false;
      });
    } else {
      setState(() {
        users = res.data;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all()),
      height: 350,
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("All Users",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          if (error.isNotEmpty)
            Text(error,
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          if (users != null && users!.isEmpty)
            const EmptyListWidget(
              msg: "No Users Found",
              height: 100,
            ),
          if (users != null && users!.isNotEmpty)
            ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                      height: 0,
                    ),
                shrinkWrap: true,
                itemCount: users!.length,
                itemBuilder: (context, index) {
                  return GroupUser(
                    user: users![index],
                    onClick: () {
                      widget.onAdd(users![index]);
                      users!.removeAt(index);
                    },
                    icon: Icons.add_circle_outline,
                  );
                }),
          if (isLoading) const CircularProgressIndicator(),
        ],
      )),
    );
  }
}

class GroupUser extends StatelessWidget {
  final ShortUserDetails user;
  final Function()? onClick;

  final IconData icon;

  const GroupUser({
    super.key,
    required this.user,
    required this.onClick,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final name = user.firstName.isEmpty && user.lastName.isEmpty
        ? 'Unknown User'
        : '${user.firstName} ${user.lastName}';
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        name,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Wrap(spacing: 10, children: [
        SubTextWithIcon(icon: Icons.email, text: user.email),
        SubTextWithIcon(icon: Icons.phone, text: user.mobile),
      ]),
      trailing: IconButton(icon: Icon(icon), onPressed: onClick),
    );
  }
}

class SubTextWithIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  final int maxLines;
  const SubTextWithIcon(
      {super.key, required this.icon, required this.text, this.maxLines = 3});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
              child: Text(
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            text.isNotEmpty ? text : "Not Available",
            style: Theme.of(context).textTheme.bodySmall,
          ))
        ]);
  }
}
