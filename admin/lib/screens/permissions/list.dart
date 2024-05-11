import 'package:admin/apis/permissions.dart';
import 'package:admin/models/permissions/filters.dart';
import 'package:admin/models/permissions/permissions.dart';
import 'package:admin/screens/permissions/filters.dart';
import 'package:admin/screens/permissions/permission_tile.dart';
import 'package:admin/utils/toast.dart';
import 'package:admin/utils/widgets/empty_list.dart';
import 'package:admin/utils/widgets/errors.dart';
import 'package:admin/utils/widgets/load_more.dart';
import 'package:flutter/material.dart';

class PermissionsList extends StatefulWidget {
  const PermissionsList({super.key});

  @override
  State<PermissionsList> createState() => _PermissionsListState();
}

class _PermissionsListState extends State<PermissionsList> {
  final List<PermissionDetails> permissions = [];
  int limit = 10;
  int offset = 0;
  bool isLoading = false;
  String error = '';
  PermissionsFilters filters = PermissionsFilters();
  bool loadMore = true;
  bool newFilters = false;

  void fetchPermissions() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    final res = await PermissionService.getPermissions(filters, offset, limit);
    if (res.error.isNotEmpty) {
      MyToast.error(res.error);
      setState(() {
        error = res.error;
        isLoading = false;
      });
      return;
    }
    if (newFilters) {
      permissions.clear();
      newFilters = false;
    }
    setState(() {
      loadMore = res.permissions.length == limit;
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
          newFilters = true;
          offset = 0;
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
        if (error.isEmpty && !isLoading && loadMore)
          LoadMoreTile(onTap: () {
            offset += limit;
            fetchPermissions();
          }),
      ])
    ]);
  }
}
