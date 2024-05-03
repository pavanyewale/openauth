import 'package:admin/apis/users.dart';
import 'package:admin/models/users/user.dart';
import 'package:flutter/material.dart';

class AddNewUserScreen extends StatefulWidget {
  final int userId;
  const AddNewUserScreen({super.key, required this.userId});

  @override
  State<AddNewUserScreen> createState() => _AddNewUserScreenState();
}

class _AddNewUserScreenState extends State<AddNewUserScreen> {
  final _formKey = GlobalKey<FormState>();

  UserDetails userDetails = UserDetails();
  bool isLoading = false;
  String error = '';
  bool isEdit = false;

  fetchUserDetails() {
    setState(() {
      isLoading = true;
    });
    UsersService.getUser(widget.userId).then((response) {
      if (response.error.isEmpty) {
        setState(() {
          userDetails = response.data!;
          isLoading = false;
        });
      } else {
        setState(() {
          error = response.error;
          isLoading = false;
        });
      }
    });
  }

  createUpdateUser() {
    // create or update user
  }

  @override
  void initState() {
    if (widget.userId != 0) {
      fetchUserDetails();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: widget.userId == 0
            ? const Text("Add New User")
            : (isEdit)
                ? const Text("Edit User")
                : const Text("User Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                Form(
                    key: _formKey,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              runAlignment: WrapAlignment.spaceBetween,
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'First Name',
                                      isDense: true,
                                      constraints:
                                          BoxConstraints(maxWidth: 100)),
                                  initialValue: userDetails.firstName,
                                  onChanged: (value) {
                                    userDetails.firstName = value;
                                  },
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Middle Name',
                                      isDense: true,
                                      constraints:
                                          BoxConstraints(maxWidth: 100)),
                                  initialValue: userDetails.middleName,
                                  onChanged: (value) {
                                    userDetails.middleName = value;
                                  },
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Last Name',
                                      isDense: true,
                                      constraints:
                                          BoxConstraints(maxWidth: 100)),
                                  initialValue: userDetails.lastName,
                                  onChanged: (value) {
                                    userDetails.lastName = value;
                                  },
                                ),
                              ]),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Username'),
                            initialValue: userDetails.username,
                            onChanged: (value) {
                              userDetails.username = value;
                            },
                            validator: (value) {
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Bio'),
                            initialValue: userDetails.bio,
                            minLines: 2,
                            maxLines: 4,
                            maxLength: 200,
                            onChanged: (value) {
                              userDetails.bio = value;
                            },
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Mobile'),
                            initialValue: userDetails.mobile,
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              userDetails.mobile = value;
                            },
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Email'),
                            initialValue: userDetails.email,
                            onChanged: (value) {
                              userDetails.email = value;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                              child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                createUpdateUser();
                              }
                            },
                            child: const Text('Submit'),
                          )),
                          if (error.isNotEmpty)
                            Text(
                              error,
                              style: const TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
