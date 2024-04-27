import 'package:admin/apis/permissions/service.dart';
import 'package:admin/models/permissions.dart';
import 'package:admin/utils/toast.dart';
import 'package:flutter/material.dart';

class PermissionForm extends StatefulWidget {
  final PermissionDetails permission;
  final bool isCreate;
  const PermissionForm(
      {super.key, required this.permission, this.isCreate = false});

  @override
  State<PermissionForm> createState() => PermissionFormState();
}

class PermissionFormState extends State<PermissionForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  bool isEdit = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.permission.name);
    _descriptionController =
        TextEditingController(text: widget.permission.description);
    isEdit = widget.isCreate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      widget.permission.name = _nameController.text;
      widget.permission.description = _descriptionController.text;
      UpdatePermissionResponse res =
          await PermissionService.instance.createPermission(widget.permission);
      if (res.error.isNotEmpty) {
        MyToast.error(res.error);
        setState(() {
          isLoading = false;
        });
        return;
      } else {
        MyToast.success("Permission created successfully");
      }
      Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Example format (YYYY-MM-DD HH:MM:SS)

    return Stack(children: [
      if (isLoading)
        const Center(
          child: CircularProgressIndicator(),
        ),
      Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                isEdit
                    ? (widget.isCreate
                        ? "Create Permission"
                        : "Edit Permission")
                    : "Permission Details",
                style: Theme.of(context).textTheme.titleLarge),
            TextFormField(
              readOnly: !isEdit,
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter permission name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              readOnly: !isEdit,
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              minLines: 1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter permission description';
                }
                return null;
              },
            ),
            if (!widget.isCreate)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Text(
                      "Created By User Id : ${widget.permission.createdByUser}"),
                  const SizedBox(height: 15),
                  Text(
                      "Created On :  ${DateTime.fromMillisecondsSinceEpoch(widget.permission.createdOn).toString()}"),
                  const SizedBox(height: 15),
                  Text(
                      "Updated On : ${DateTime.fromMillisecondsSinceEpoch(widget.permission.updatedOn).toString()}"),
                ],
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 10),
                if (isEdit)
                  ElevatedButton(
                    onPressed: submit,
                    child: const Text('Save'),
                  ),
                // if (!isEdit)
                //   ElevatedButton(
                //     onPressed: () {
                //       setState(() {
                //         isEdit = true;
                //       });
                //     },
                //     child: const Text('Edit'),
                //   ),
              ],
            ),
          ],
        ),
      )
    ]);
  }
}
