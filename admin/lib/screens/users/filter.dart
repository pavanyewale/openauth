import 'package:admin/models/users/users.dart';
import 'package:flutter/material.dart';

class UsersFilters extends StatefulWidget {
  final Function(GetUsersFilters filters) onFetchClicked;
  const UsersFilters({super.key, required this.onFetchClicked});

  @override
  State<UsersFilters> createState() => _UsersFiltersState();
}

class _UsersFiltersState extends State<UsersFilters> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final GetUsersFilters filters = GetUsersFilters();

  @override
  Widget build(BuildContext context) {
    const boxConstrants = BoxConstraints(maxWidth: 150, maxHeight: 40);
    ;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            TextField(
              controller: _userIdController,
              maxLines: 1,
              decoration: const InputDecoration(
                constraints: boxConstrants,
                label: Text('User ID'),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                isDense: true, // Reduces the height of the input box
                border: OutlineInputBorder(),
                hintText: 'e.g. 128974',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                filters.userId = int.tryParse(value) ?? 0;
              },
            ),
            TextField(
              controller: _usernameController,
              maxLines: 1,
              decoration: const InputDecoration(
                constraints: boxConstrants,
                label: Text('Username'),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                isDense: true, // Reduces the height of the input box
                border: OutlineInputBorder(),
                hintText: 'e.g. raj123',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                filters.username = value;
              },
            ),
            TextFormField(
              controller: _mobileController,
              decoration: const InputDecoration(
                constraints: BoxConstraints(maxWidth: 170, maxHeight: 40),
                label: Text('Mobile'),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                isDense: true, // Reduces the height of the input box
                border: OutlineInputBorder(),
                hintText: 'e.g. 707893****',
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                filters.mobile = value;
              },
            ),
            TextFormField(
              cursorHeight: 20,
              controller: _emailController,
              decoration: const InputDecoration(
                constraints: BoxConstraints(maxWidth: 200, maxHeight: 40),
                label: Text('Email'),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                isDense: true, // Reduces the height of the input box
                border: OutlineInputBorder(),
                hintText: 'e.g. xyz@gmail.com',
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                filters.email = value;
              },
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _userIdController.clear();
                  _emailController.clear();
                  _mobileController.clear();
                  _usernameController.clear();
                  filters.userId = 0;
                  filters.email = '';
                  filters.mobile = '';
                  filters.username = '';
                });
              },
              child: const Text('Clear'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onFetchClicked(filters);
              },
              child: const Text('Search'),
            ),
          ],
        ),
      ],
    );
  }
}
