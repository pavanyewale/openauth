import 'package:admin/apis/group.dart';
import 'package:admin/models/groups/filters.dart';
import 'package:admin/models/groups/groups.dart';
import 'package:admin/screens/groups/filters.dart';
import 'package:admin/screens/groups/group_tile.dart';
import 'package:admin/utils/toast.dart';
import 'package:admin/utils/widgets/empty_list.dart';
import 'package:admin/utils/widgets/errors.dart';
import 'package:admin/utils/widgets/next_prev.dart';
import 'package:flutter/material.dart';

class GroupsList extends StatefulWidget {
  const GroupsList({super.key});

  @override
  State<GroupsList> createState() => _GroupsListState();
}

class _GroupsListState extends State<GroupsList> {
  final List<GroupDetails> groups = [];
  int limit = 10;
  int skip = 0;
  bool isLoading = false;
  String error = '';
  GroupFilters filters = GroupFilters();
  void fetchGroups() async {
    setState(() {
      isLoading = true;
    });

    final res = await GroupService.getGroups(filters, limit, skip);
    if (res.error.isNotEmpty) {
      MyToast.error(res.error);
      setState(() {
        error = res.error;
        isLoading = false;
      });
      return;
    }
    setState(() {
      groups.clear();
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
    return
        // add list of groups
        Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GroupFiltersWidget(onFetchClicked: (fitlers) {
          filters = fitlers;
          fetchGroups();
        }),
        const Divider(),
        //add loading indicator
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        //add error message
        if (error.isNotEmpty) const MyErrorWidget(),
        //show empty list message
        if (groups.isEmpty && !isLoading && error.isEmpty)
          const EmptyListWidget(),
        ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final group = groups[index];
              return GroupTile(
                group: group,
                onDelete: () => groups.removeAt(index),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: groups.length),
        // next and prev buttons
        NextAndPrevPaginationButtons(
            onNextClicked: () {
              setState(() {
                skip += limit;
              });
              fetchGroups();
            },
            onPrevClicked: () {
              setState(() {
                skip -= limit;
              });
              fetchGroups();
            },
            isNext: groups.length == limit,
            isPrev: skip > 0)
      ],
    );
  }
}
