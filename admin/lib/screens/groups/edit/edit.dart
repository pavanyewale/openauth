import 'package:admin/apis/group.dart';
import 'package:admin/models/groups/groups.dart';
import 'package:admin/utils/toast.dart';
import 'package:flutter/material.dart';

class CreateGroupScreen extends StatefulWidget {
  final GroupDetails? groupDetails;
  const CreateGroupScreen({super.key, this.groupDetails});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();

  GroupDetails? groupDetails;
  bool isLoading = false;
  String error = '';

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
    MyToast.success(groupDetails!.id != 0
        ? "Group created successfully!"
        : "Group updated successfully!");
    setState(() {
      isLoading = false;
      error = '';
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    if (widget.groupDetails != null) {
      groupDetails = widget.groupDetails;
    } else {
      groupDetails = GroupDetails();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text(widget.groupDetails != null ? "Edit Group" : "Create Group"),
        ),
        body: Stack(
          children: [
            //loader
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            // editing form
            if (groupDetails != null)
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: "Name"),
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
                            decoration:
                                const InputDecoration(labelText: "Description"),
                            initialValue: groupDetails!.description,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter group description';
                              }
                              return null;
                            },
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
                                      color:
                                          Theme.of(context).colorScheme.error),
                                )),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  createUpdateGroup(context);
                                }
                              },
                              child: const Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text("Submit")),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ));
  }
}
