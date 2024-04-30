import 'package:admin/apis/users.dart';
import 'package:admin/models/users/users.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/toast.dart';
import 'package:admin/utils/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

class UserTile extends StatelessWidget {
  final ShortUserDetails user;
  final Function() onDelete;
  const UserTile({super.key, required this.user, required this.onDelete});

  void onClick(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('First Name: ${user.firstName}'),
            Text('Last Name: ${user.lastName}'),
            Text('Email: ${user.email}'),
            Text('Mobile: ${user.mobile}'),
            Text(
                'Created On: ${formatter.format(DateTime.fromMillisecondsSinceEpoch(user.createdOn))}'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = user.firstName.isEmpty && user.lastName.isEmpty
        ? 'Unknown User'
        : '${user.firstName} ${user.lastName}';
    return ListTile(
      leading: CircleAvatar(
        child: Text(name[0]),
      ),
      title: Text(name),
      subtitle: Wrap(
        spacing: 10,
        runSpacing: 5,
        children: [
          SubTextWithIcon(icon: Icons.email, text: user.email),
          SubTextWithIcon(icon: Icons.phone, text: user.mobile),
          SubTextWithIcon(
              icon: Icons.calendar_today,
              text: formatter
                  .format(DateTime.fromMillisecondsSinceEpoch(user.createdOn)))
        ],
      ),
      trailing: IconButton(
        icon: const Icon(
          Icons.delete,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete User'),
              content: const Text('Are you sure you want to delete user?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final res = await UsersService.deleteUser(user.id);
                    if (res.error.isNotEmpty) {
                      MyToast.error(res.error);
                      return;
                    } else {
                      MyToast.success("User deleted successfully!");
                    }
                    onDelete();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      onTap: () {
        onClick(context);
      },
    );
  }
}
