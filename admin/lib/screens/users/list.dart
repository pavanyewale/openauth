import 'package:admin/apis/users.dart';
import 'package:admin/models/users/users.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/toast.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  bool isLoading = false;
  List<ShortUserDetails> users = [];
  int offset = 0;
  int limit = 10;
  String error = '';

  void fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    final res = await UsersService.getUsers(GetUsersFilters(), offset, limit);
    if (res.error.isNotEmpty) {
      setState(() {
        error = res.error;
        isLoading = false;
      });
      return;
    }
    setState(() {
      users.clear();
      users.addAll(res.data);
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final user = users[index];
              final name = user.firstName.isEmpty && user.lastName.isEmpty
                  ? 'Unknown User'
                  : '${user.firstName} ${user.lastName}';
              return ListTile(
                tileColor: Theme.of(context).primaryColorLight,
                leading: CircleAvatar(
                  child: Text(name[0]),
                ),
                title: Text(name),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (user.username.isNotEmpty) Text(user.username),
                      if (user.email.isNotEmpty) Text(user.email),
                      if (user.mobile.isNotEmpty) Text(user.mobile),
                      Text(DateTime.fromMillisecondsSinceEpoch(user.createdOn)
                          .toString())
                    ]),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete User'),
                        content:
                            const Text('Are you sure you want to delete user?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              final res =
                                  await UsersService.deleteUser(user.id);
                              if (res.error.isNotEmpty) {
                                MyToast.error(res.error);
                                return;
                              } else {
                                MyToast.success("User deleted successfully!");
                              }
                              setState(() {
                                users.removeAt(index);
                              });
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
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
            itemCount: users.length)
      ],
    );
  }
}
