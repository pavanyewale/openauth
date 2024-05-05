import 'package:admin/apis/users.dart';
import 'package:admin/models/users/user.dart';
import 'package:admin/models/users/verify_contacts.dart';
import 'package:flutter/material.dart';

class AddNewUserScreen extends StatefulWidget {
  final int userId;
  const AddNewUserScreen({super.key, required this.userId});

  @override
  State<AddNewUserScreen> createState() => _AddNewUserScreenState();
}

class _AddNewUserScreenState extends State<AddNewUserScreen> {
  final _formKey = GlobalKey<FormState>();

  UserDetails? userDetails;
  bool isLoading = false;
  String error = '';
  bool isEdit = false;
  String? emailErr;
  String? mobileErr;
  String? usernameErr;
  bool verificationDone = false;
  bool emailOTPSent = false;
  bool mobileOTPSent = false;
  bool isFieldEditable = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailOTPController = TextEditingController();
  final TextEditingController _mobileOTPController = TextEditingController();

  fetchUserDetails() {
    setState(() {
      isLoading = true;
    });
    UsersService.getUser(widget.userId).then((response) {
      if (response.error.isEmpty) {
        setState(() {
          userDetails = response.data!;
          _emailController.text = userDetails!.email;
          _mobileController.text = userDetails!.mobile;
          _usernameController.text = userDetails!.username;
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

  Future<bool> isContactsValid() async {
    if (_emailController.text == userDetails!.email &&
        _mobileController.text == userDetails!.mobile &&
        _usernameController.text == userDetails!.username) {
      setState(() {
        error = "username, email or mobile is required";
      });
      return true;
    }
    VerifyContactsRequest req = VerifyContactsRequest(
      sendOtp: true,
      email: _emailController.text != userDetails!.email
          ? _emailController.text
          : '',
      mobile: _mobileController.text != userDetails!.mobile
          ? _mobileController.text
          : '',
      username: _usernameController.text != userDetails!.username
          ? _usernameController.text
          : '',
    );
    var response = await UsersService.verifyContacts(req);
    if (response.error.isEmpty) {
      setState(() {
        emailOTPSent = response.emailErr.isEmpty && req.email.isNotEmpty;
        mobileOTPSent = response.mobileErr.isEmpty && req.mobile.isNotEmpty;
        emailErr = response.emailErr;
        mobileErr = response.mobileErr;
        usernameErr = response.usernameErr;
        verificationDone = response.emailErr.isEmpty &&
            response.mobileErr.isEmpty &&
            response.usernameErr.isEmpty;
      });
      if (response.emailErr.isEmpty &&
          response.mobileErr.isEmpty &&
          response.usernameErr.isEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      setState(() {
        error = response.error;
      });
      return false;
    }
  }

  createUpdateUser() {
    setState(() {
      isLoading = true;
    });
    var req = userDetails!.toCreateUpdateUserRequest();
    req.email = _emailController.text;
    req.mobile = _mobileController.text;
    req.username = _usernameController.text;
    req.emailOTP = _emailOTPController.text;
    req.mobileOTP = _mobileOTPController.text;
    UsersService.createUpdateUser(req).then((response) {
      if (response.error.isEmpty) {
        Navigator.pop(context, true);
      } else {
        setState(() {
          error = response.error;
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    if (widget.userId != 0) {
      fetchUserDetails();
    } else {
      userDetails = UserDetails();
      isFieldEditable = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (!isFieldEditable)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isFieldEditable = true;
                });
              },
            ),
          const SizedBox(width: 10)
        ],
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  if (userDetails != null)
                    Form(
                        key: _formKey,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (userDetails!.deleted)
                                Text(
                                  'This user has been deleted!',
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      fontStyle: FontStyle.italic),
                                ),
                              if (isLoading)
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              Wrap(
                                  spacing: 20,
                                  runSpacing: 10,
                                  alignment: WrapAlignment.spaceBetween,
                                  children: [
                                    TextFormField(
                                      readOnly: !isFieldEditable,
                                      decoration: const InputDecoration(
                                          labelText: 'First Name',
                                          isDense: true,
                                          constraints:
                                              BoxConstraints(maxWidth: 130)),
                                      initialValue: userDetails!.firstName,
                                      onChanged: (value) {
                                        userDetails!.firstName = value;
                                      },
                                    ),
                                    TextFormField(
                                      readOnly: !isFieldEditable,
                                      decoration: const InputDecoration(
                                          labelText: 'Middle Name',
                                          isDense: true,
                                          constraints:
                                              BoxConstraints(maxWidth: 130)),
                                      initialValue: userDetails!.middleName,
                                      onChanged: (value) {
                                        userDetails!.middleName = value;
                                      },
                                    ),
                                    TextFormField(
                                      readOnly: !isFieldEditable,
                                      decoration: const InputDecoration(
                                          labelText: 'Last Name',
                                          isDense: true,
                                          constraints:
                                              BoxConstraints(maxWidth: 130)),
                                      initialValue: userDetails!.lastName,
                                      onChanged: (value) {
                                        userDetails!.lastName = value;
                                      },
                                    ),
                                  ]),
                              TextFormField(
                                readOnly: !isFieldEditable,
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  isDense: true,
                                  error: (usernameErr ?? '').isNotEmpty
                                      ? Text(
                                          usernameErr!,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                        )
                                      : null,
                                ),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              TextFormField(
                                readOnly: !isFieldEditable,
                                decoration: const InputDecoration(
                                  labelText: 'Bio',
                                  isDense: true,
                                ),
                                initialValue: userDetails!.bio,
                                minLines: 1,
                                maxLines: 4,
                                maxLength: 200,
                                onChanged: (value) {
                                  userDetails!.bio = value;
                                },
                              ),
                              TextFormField(
                                readOnly: !isFieldEditable,
                                controller: _mobileController,
                                decoration: InputDecoration(
                                    labelText: 'Mobile',
                                    icon: const Icon(Icons.phone),
                                    isDense: true,
                                    error: (mobileErr ?? '').isNotEmpty
                                        ? Text(
                                            mobileErr!,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error),
                                          )
                                        : null),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  //validate mobile
                                  if ((value ?? '').isNotEmpty) {
                                    if (!RegExp(r'^[0-9]{10}$')
                                        .hasMatch(value!)) {
                                      return 'Please enter valid mobile number';
                                    }
                                  }
                                  return null;
                                },
                              ),
                              if (mobileOTPSent)
                                TextFormField(
                                  readOnly: !isFieldEditable,
                                  controller: _mobileOTPController,
                                  decoration: const InputDecoration(
                                    labelText: 'Mobile OTP',
                                    icon: Icon(Icons.phone),
                                    isDense: true,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter OTP';
                                    }
                                    return null;
                                  },
                                ),
                              TextFormField(
                                readOnly: !isFieldEditable,
                                controller: _emailController,
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    icon: const Icon(Icons.email),
                                    isDense: true,
                                    error: (emailErr ?? '').isNotEmpty
                                        ? Text(
                                            emailErr!,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error),
                                          )
                                        : null),
                                validator: (value) {
                                  //validate email
                                  if ((value ?? '').isNotEmpty) {
                                    if (!RegExp(
                                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value!)) {
                                      return 'Please enter valid email';
                                    }
                                  }
                                  return null;
                                },
                              ),
                              if (emailOTPSent)
                                TextFormField(
                                  readOnly: !isFieldEditable,
                                  controller: _emailOTPController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email OTP',
                                    icon: Icon(Icons.phone),
                                    isDense: true,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter OTP';
                                    }
                                    return null;
                                  },
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (error.isNotEmpty)
                                Center(
                                  child: Text(
                                    error,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error),
                                  ),
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (isFieldEditable)
                                Center(
                                    child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      if (!verificationDone) {
                                        await isContactsValid();
                                        return;
                                      }
                                      createUpdateUser();
                                    }
                                  },
                                  child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'Save',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                )),
                            ],
                          ),
                        )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
