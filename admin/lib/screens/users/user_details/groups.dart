import 'package:admin/apis/group.dart';
import 'package:admin/models/groups/filters.dart';
import 'package:admin/models/groups/groups.dart';
import 'package:admin/screens/groups/filters.dart';
import 'package:admin/utils/toast.dart';
import 'package:admin/utils/widgets/common.dart';
import 'package:admin/utils/widgets/empty_list.dart';
import 'package:admin/utils/widgets/errors.dart';
import 'package:admin/utils/widgets/load_more.dart';
import 'package:admin/utils/widgets/loader_tile.dart';
import 'package:flutter/material.dart';

class UserGroups extends StatefulWidget {
  final int userID;
  const UserGroups({super.key, required this.userID});

  @override
  State<UserGroups> createState() => _UserGroupsState();
}

class _UserGroupsState extends State<UserGroups> {
  bool isLoading = false;
  List<GroupDetails> userGroups = [];
  int offset = 0;
  int limit = 10;
  String error = '';
  bool edit = false;

  saveUserGroups() async {
    setState(() {
      isLoading = true;
    });

    final String err =
        await GroupService.addUserToGroups(widget.userID, userGroups);
    if (err.isNotEmpty) {
      setState(() {
        isLoading = false;
        error = err;
      });
      return;
    }
    MyToast.success("Groups saved successfully");
    setState(() {
      isLoading = false;
      edit = false;
      error = '';
    });
  }

  fetchUserGroups() async {
    setState(() {
      isLoading = true;
    });

    final res = await GroupService.getGroupsOfUser(widget.userID);
    if (res.error.isNotEmpty) {
      setState(() {
        error = res.error;
        isLoading = false;
      });
      return;
    }
    setState(() {
      userGroups = res.groups;
      isLoading = false;
      error = '';
    });
  }

  @override
  void initState() {
    fetchUserGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Groups of the user",
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
                    if (error.isEmpty && (userGroups.isEmpty))
                      const EmptyListWidget(
                        msg: "No Groups of the User",
                        height: 100,
                      ),
                    ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                              height: 0,
                            ),
                        shrinkWrap: true,
                        itemCount: userGroups.length,
                        itemBuilder: (context, index) {
                          return GroupTile(
                              group: userGroups[index],
                              iconData: Icons.remove_circle_outline,
                              onTap: edit
                                  ? () {
                                      setState(() {
                                        userGroups.removeAt(index);
                                      });
                                    }
                                  : null);
                        }),
                    if (isLoading) const LoaderTile(),
                  ],
                ),
              ),
            ),
            if (edit)
              AllGroups(
                onAdd: (permission) {
                  setState(() {
                    userGroups.add(permission);
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
                    saveUserGroups();
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

/*

All Groups Screen

*/

class AllGroups extends StatefulWidget {
  final Function(GroupDetails) onAdd;
  const AllGroups({super.key, required this.onAdd});

  @override
  State<AllGroups> createState() => _AllGroupsState();
}

class _AllGroupsState extends State<AllGroups> {
  bool isLoading = false;
  List<GroupDetails> groups = [];
  int offset = 0;
  int limit = 10;
  String error = '';
  bool loadMore = true;
  bool newFilters = false;
  GroupFilters filters = GroupFilters();

  fetchGroups() async {
    setState(() {
      isLoading = true;
    });

    final res = await GroupService.getGroups(filters, limit, offset);
    if (res.error.isNotEmpty) {
      setState(() {
        error = res.error;
        isLoading = false;
      });
      return;
    }
    if (newFilters) {
      groups.clear();
      newFilters = false;
    }
    setState(() {
      loadMore = res.groups.length == limit;
      groups.addAll(res.groups);
      isLoading = false;
      error = '';
    });
  }

  @override
  void initState() {
    fetchGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("All Permissions",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(
          height: 10,
        ),
        GroupFiltersWidget(onFetchClicked: (filter) {
          filters = filter;
          offset = 0;
          newFilters = true;
          fetchGroups();
        }),
        const SizedBox(
          height: 5,
        ),
        Container(
          decoration: BoxDecoration(border: Border.all()),
          padding: const EdgeInsets.all(10),
          constraints: const BoxConstraints(maxHeight: 350, minHeight: 50),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (error.isNotEmpty) const MyErrorWidget(),
                if (groups.isEmpty && !isLoading && error.isEmpty)
                  const EmptyListWidget(
                    msg: "No Groups found",
                  ),
                if (groups.isNotEmpty)
                  ListView.builder(
                      itemCount: groups.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        return GroupTile(
                            group: group,
                            iconData: Icons.add_circle_outline,
                            onTap: () {
                              widget.onAdd(groups[index]);
                              groups.removeAt(index);
                            });
                      }),
                if (isLoading) const LoaderTile(),
                if (!isLoading && loadMore)
                  LoadMoreTile(onTap: () {
                    offset += limit;
                    fetchGroups();
                  }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/*

Group Tile

*/

class GroupTile extends StatelessWidget {
  final GroupDetails group;
  final Function()? onTap;
  final IconData iconData;
  const GroupTile(
      {super.key,
      required this.group,
      required this.onTap,
      required this.iconData});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        group.name,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: SubTextWithIcon(
        icon: Icons.description,
        text: group.description,
      ),
      trailing: IconButton(icon: Icon(iconData), onPressed: onTap),
    );
  }
}
