import 'package:admin/apis/permissions.dart';
import 'package:admin/models/permissions.dart';
import 'package:admin/screens/permissions/permission_tile.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/toast.dart';
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
      // add loading indicator
      if (isLoading)
        const Center(
          child: CircularProgressIndicator(),
        ),

      // add error message
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
