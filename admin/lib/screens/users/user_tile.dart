import 'package:admin/apis/users.dart';
import 'package:admin/models/users/users.dart';
import 'package:admin/screens/users/user_details/form.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/utils/toast.dart';
import 'package:admin/utils/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

class UserTile extends StatelessWidget {
  final ShortUserDetails user;
  final Function() onDelete;
  const UserTile({super.key, required this.user, required this.onDelete});

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
        icon: Icon(
          user.deleted ? Icons.unarchive : Icons.delete,
          semanticLabel: user.deleted ? "Retrive Back" : "Delete User",
        ),
        onPressed: () {
          if (user.deleted) {
            undeleteUser(context);
          } else {
            deleleUser(context);
          }
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MyRoute(
            builder: (context) => AddNewUserScreen(userId: user.id),
          ),
        );
      },
    );
  }

  Future<dynamic> deleleUser(BuildContext context) {
    return showDialog(
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
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> undeleteUser(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Undelete User'),
        content: const Text('Are you sure you want to retrive back user?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final error = await UsersService.undeleteUser(user.id);
              if (error.isNotEmpty) {
                MyToast.error(error);
                return;
              } else {
                MyToast.success("User undeleted successfully!");
              }
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            child: const Text(
              'Retrive Back',
              style: TextStyle(color: AppColors.success),
            ),
          ),
        ],
      ),
    );
  }
}
