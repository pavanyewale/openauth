import 'package:admin/apis/users.dart';
import 'package:admin/models/users/users.dart';
import 'package:admin/screens/users/filter.dart';
import 'package:admin/screens/users/user_tile.dart';
import 'package:admin/utils/widgets/next_prev.dart';
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

  GetUsersFilters filters = GetUsersFilters();

  void fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    final res = await UsersService.getUsers(filters, offset, limit);
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
        UsersFilters(
          onFetchClicked: (filters) {
            this.filters = filters;
            fetchUsers();
          },
        ),
        const Divider(),
        ListView.separated(
            shrinkWrap: true,
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
            itemCount: users.length),
        //next
        NextAndPrevPaginationButtons(
            onNextClicked: () {
              offset += limit;
              fetchUsers();
            },
            onPrevClicked: () {
              offset -= limit;
              fetchUsers();
            },
            isNext: users.length == limit,
            isPrev: offset > 0)
      ],
    );
  }
}
