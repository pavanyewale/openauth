import 'package:admin/apis/permissions.dart';
import 'package:admin/models/permissions/filters.dart';
import 'package:admin/models/permissions/permissions.dart';
import 'package:admin/screens/permissions/filters.dart';
import 'package:admin/screens/permissions/permission_tile.dart';
import 'package:admin/utils/toast.dart';
import 'package:admin/utils/widgets/empty_list.dart';
import 'package:admin/utils/widgets/errors.dart';
import 'package:admin/utils/widgets/next_prev.dart';
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
  PermissionsFilters filters = PermissionsFilters();

  void fetchPermissions() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    final res = await PermissionService.getPermissions(filters, skip, limit);
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
      // add loading indicator
      if (isLoading)
        const Center(
          child: CircularProgressIndicator(),
        ),

      // add error message
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PermissionsFilterWidget(onFetchClicked: (filters) {
          filters = filters;
          fetchPermissions();
        }),
        const Divider(),
        if (!isLoading && error.isEmpty && permissions.isEmpty)
          const EmptyListWidget(),
        if (error.isNotEmpty) const MyErrorWidget(),

        // add list of permissions
        ListView.separated(
          separatorBuilder: (context, index) =>
              const Divider(), // Add space between items
          itemCount: permissions.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return PermissionTile(
              permission: permissions[index],
              onDelete: () {
                setState(() {
                  permissions.removeAt(index);
                });
              },
            );
          },
        ),

        // add next and prev buttons
        if (error.isEmpty)
          NextAndPrevPaginationButtons(
            onNextClicked: () {
              skip += limit;
              fetchPermissions();
            },
            onPrevClicked: () {
              skip -= limit;
              fetchPermissions();
            },
            isPrev: skip > 0,
            isNext: permissions.length == limit,
          )
      ])
    ]);
  }
}
