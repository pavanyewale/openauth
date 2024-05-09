import 'package:admin/apis/group.dart';
import 'package:admin/apis/users.dart';
import 'package:admin/models/groups/group_users.dart';
import 'package:admin/models/groups/groups.dart';
import 'package:admin/models/users/users.dart';
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
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Users of the group",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          IconButton(
              onPressed: () {
                setState(() {
                  edit = true;
                });
              },
              icon: const Icon(Icons.edit))
        ]),
        Wrap(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(border: Border.all()),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: groupUsers!.length,
                  itemBuilder: (context, index) {
                    var user = groupUsers![index];
                    final name = user.firstName.isEmpty && user.lastName.isEmpty
                        ? 'Unknown User'
                        : '${user.firstName} ${user.lastName}';
                    return (groupUsers!.isEmpty)
                        ? const EmptyListWidget()
                        : ListTile(
                            title: Text(name),
                            subtitle: Wrap(children: [Text(user.email)]),
                            trailing: IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  groupUsers!.removeAt(index);
                                }),
                          );
                  }),
            ),
            if (edit)
              AllUsersList(
                groupId: widget.groupDetails.id,
              ),
          ],
        ),
      ],
    );
  }
}

class AllUsersList extends StatefulWidget {
  const AllUsersList({super.key, required this.groupId});

  final int groupId;

  @override
  State<AllUsersList> createState() => _AllUsersListState();
}

class _AllUsersListState extends State<AllUsersList> {
  List<ShortUserDetails>? users;
  bool isLoading = false;
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
    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all()),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: users!.length,
          itemBuilder: (context, index) {
            var user = users![index];
            final name = user.firstName.isEmpty && user.lastName.isEmpty
                ? 'Unknown User'
                : '${user.firstName} ${user.lastName}';
            return ListTile(
              title: Text(name),
              subtitle: Text(users![index].email),
              trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    users!.removeAt(index);
                  }),
            );
          }),
    );
  }
}
