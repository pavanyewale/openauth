import 'package:admin/apis/users.dart';
import 'package:admin/models/users/users.dart';
import 'package:admin/screens/users/filter.dart';
import 'package:admin/screens/users/user_tile.dart';
import 'package:admin/utils/toast.dart';
import 'package:admin/utils/widgets/empty_list.dart';
import 'package:admin/utils/widgets/errors.dart';
import 'package:admin/utils/widgets/load_more.dart';
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
  bool filtersChanged = false;
  bool isMore = true;

  GetUsersFilters filters = GetUsersFilters();

  void fetchUsers() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    final res = await UsersService.getUsers(filters, offset, limit);
    if (res.error.isNotEmpty) {
      MyToast.error(res.error);
      setState(() {
        error = res.error;
        isLoading = false;
      });
      return;
    }
    setState(() {
      users.addAll(res.data);
      isMore = res.data.length == limit;
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
        UsersFilters(
          onFetchClicked: (filters) {
            offset = 0;

            this.filters = filters;
            fetchUsers();
          },
        ),
        const Divider(),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        (error.isEmpty)
            ? ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return UserTile(
                      user: users[index],
                      onDelete: () {
                        setState(() {
                          users.removeAt(index);
                        });
                      });
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: users.length)
            : const MyErrorWidget(),
        if (users.isEmpty && !isLoading && error.isEmpty)
          const EmptyListWidget(),
        if (error.isEmpty && isMore && !isLoading)
          LoadMoreTile(onTap: () {
            offset += limit;
            fetchUsers();
          }),
      ],
    );
  }
}
