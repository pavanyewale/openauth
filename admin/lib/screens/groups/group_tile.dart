import 'package:admin/apis/group.dart';
import 'package:admin/models/groups/groups.dart';
import 'package:admin/screens/groups/group_details/details.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/utils/toast.dart';
import 'package:admin/utils/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

class GroupTile extends StatelessWidget {
  const GroupTile({
    super.key,
    required this.group,
    required this.onDelete,
  });

  final GroupDetails group;
  final Function() onDelete;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          Navigator.push(context, MyRoute(
            builder: (context) {
              return GroupDetailsScreen(groupDetails: group);
            },
          ));
        },
        leading: const Icon(Icons.grid_view),
        title: Text(group.name,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        subtitle: Wrap(
          spacing: 20,
          runSpacing: 5,
          children: [
            SubTextWithIcon(icon: Icons.description, text: group.description),
            SubTextWithIcon(
              icon: Icons.person,
              text: group.createdByUser.toString(),
            ),
            SubTextWithIcon(
              icon: Icons.date_range,
              text: formatter
                  .format(DateTime.fromMillisecondsSinceEpoch(group.createdOn)),
            ),
          ],
        ),
        //delete button
        trailing: IconButton(
          icon: const Icon(
            Icons.delete,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Group'),
                content: Text(
                    'Are you sure you want to delete `${group.name}` group?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final err = await GroupService.deleteGroup(group.id);
                      if (err.isNotEmpty) {
                        MyToast.error(err);
                        return;
                      } else {
                        MyToast.success("Group deleted successfully!");
                      }
                      onDelete();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Delete',
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
