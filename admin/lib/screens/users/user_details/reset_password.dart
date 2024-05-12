import 'package:admin/utils/toast.dart';
import 'package:admin/utils/widgets/errors.dart';
import 'package:admin/utils/widgets/loader_tile.dart';
import 'package:admin/utils/widgets/login/service.dart';
import 'package:flutter/material.dart';

class ResetUserPassword extends StatefulWidget {
  const ResetUserPassword({super.key});

  @override
  State<ResetUserPassword> createState() => _ResetUserPasswordState();
}

class _ResetUserPasswordState extends State<ResetUserPassword> {
  bool edit = false;
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String error = '';

  resetPassword() async {
    setState(() {
      isLoading = true;
    });
    var err =
        await LoginService.instance.resetPassowrd(passwordController.text);
    if (err.isNotEmpty) {
      setState(() {
        isLoading = false;
        error = err;
      });
      return;
    }
    MyToast.success("Password reseted successfully");
    setState(() {
      isLoading = false;
      edit = false;
      error = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Reset Password",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          if (!edit)
            IconButton(
                onPressed: () {
                  setState(() {
                    edit = true;
                  });
                },
                icon: const Icon(Icons.edit)),
        ]),
        const SizedBox(
          height: 20,
        ),
        if (edit)
          Form(
            key: _formKey,
            child: Wrap(
              spacing: 20,
              runSpacing: 10,
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      labelText: 'New Password',
                      hintText: "Enter new password",
                      isDense: true,
                      constraints: BoxConstraints(maxWidth: 200)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter password";
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            resetPassword();
                          }
                        },
                  child: const Text("Reset Password"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      passwordController.clear();
                      edit = false;
                    });
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ),
        if (isLoading) const LoaderTile(),
        if (error.isNotEmpty)
          MyErrorWidget(
            error: error,
          ),
      ],
    );
  }
}
