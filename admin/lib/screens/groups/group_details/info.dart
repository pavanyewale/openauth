import 'package:admin/apis/group.dart';
import 'package:admin/models/groups/groups.dart';
import 'package:admin/screens/groups/group_details/permissions.dart';
import 'package:admin/screens/groups/group_details/users.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/utils/screen.dart';
import 'package:admin/utils/toast.dart';
import 'package:flutter/material.dart';

class CreateUpdateGroupInfo extends StatefulWidget {
  final GroupDetails? groupDetails;
  final Function(GroupDetails details) onCreate;
  const CreateUpdateGroupInfo(
      {super.key, this.groupDetails, required this.onCreate});

  @override
  State<CreateUpdateGroupInfo> createState() => _CreateUpdateGroupInfoState();
}

class _CreateUpdateGroupInfoState extends State<CreateUpdateGroupInfo> {
  final _formKey = GlobalKey<FormState>();

  GroupDetails? groupDetails;
  bool isLoading = false;
  String error = '';
  bool isEdit = false;

  createUpdateGroup(context) async {
    setState(() {
      isLoading = true;
    });

    final res = await GroupService.createUpdateGroup(groupDetails!);
    if (res.error.isNotEmpty) {
      setState(() {
        isLoading = false;
        error = res.error;
      });
      return;
    }
    MyToast.success(groupDetails!.id == 0
        ? "Group created successfully!"
        : "Group updated successfully!");
    setState(() {
      isLoading = false;
      isEdit = false;
      error = '';
      groupDetails!.id = res.groupDetails.id;
    });
    widget.onCreate(groupDetails!);
  }

  @override
  void initState() {
    if (widget.groupDetails != null) {
      groupDetails = widget.groupDetails;
    } else {
      groupDetails = GroupDetails();
      isEdit = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Screen.isMobile(context);
    return Stack(
      children: [
        //loader
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        // editing form
        if (groupDetails != null)
          Form(
            key: _formKey,
            child: Column(
              children: [
                if (groupDetails!.id != 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("General Information",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                      if (!isEdit)
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isEdit = true;
                              });
                            },
                            icon: const Icon(Icons.edit)),
                    ],
                  ),
                TextFormField(
                  readOnly: !isEdit,
                  decoration: const InputDecoration(labelText: "Name"),
                  initialValue: groupDetails!.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter group name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    groupDetails!.name = value!;
                  },
                ),
                TextFormField(
                  readOnly: !isEdit,
                  decoration: const InputDecoration(labelText: "Description"),
                  initialValue: groupDetails!.description,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter group description';
                    }
                    return null;
                  },
                  maxLines: 3,
                  minLines: 1,
                  onSaved: (value) {
                    groupDetails!.description = value!;
                  },
                ),
                if (error.isNotEmpty)
                  Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        error,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      )),
                const SizedBox(height: 20),
                if (isEdit)
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        createUpdateGroup(context);
                      }
                    },
                    style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all(const Size(220, 40))),
                    child: const Text("Submit"),
                  ),
                const SizedBox(height: 20),
                if (isMobile && groupDetails!.id != 0)
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MyRoute(
                                  builder: (context) => GroupUsersScreen(
                                        groupDetails: groupDetails!,
                                      )));
                        },
                        style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all(const Size(220, 40))),
                        child: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Update Users"),
                              SizedBox(width: 5),
                              Icon(Icons.arrow_forward)
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MyRoute(
                                  builder: (context) => GroupPermissionsScreen(
                                        groupDetails: groupDetails!,
                                      )));
                        },
                        style: ButtonStyle(
                          fixedSize:
                              MaterialStateProperty.all(const Size(220, 40)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Update Permissions"),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_forward)
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
