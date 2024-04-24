import 'package:admin/screens/login/service.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool isEnteringOtp = false;
  String? otp;
  String? password;
  bool permissions = true;
  String? username;
  bool isSubmitting = false;
  String error = "";
  void submit(LoginRequest request) async {
    setState(() {
      isSubmitting = true;
    });
    request.deviceDetails = await Utils.instance.fetchDeviceInfo();
    LoginResponse resp = await LoginService.instance.login(request);
    if (resp.error.isNotEmpty) {
      error = resp.error;
    } else {
      Fluttertoast.showToast(
          msg: "Logged in successfully!",
          toastLength: Toast.LENGTH_SHORT,
          textColor: AppColors.success,
          webPosition: "center",
          );
    }
    setState(() {
      isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      if (isSubmitting) const Center(child: CircularProgressIndicator()),
      AbsorbPointer(
        absorbing: isSubmitting,
        child: Opacity(
          opacity: isSubmitting ? 0.3 : 1,
          child: Center(
              child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      }
                      return null;
                    },
                    onSaved: (value) => username = value!,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (isEnteringOtp)
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'OTP'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter OTP';
                        }
                        return null;
                      },
                      onSaved: (value) => otp = value!,
                    ),
                  if (!isEnteringOtp)
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                      onSaved: (value) => password = value!,
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Switch(
                        value: isEnteringOtp,
                        onChanged: (value) {
                          setState(() {
                            isEnteringOtp = value;
                          });
                        },
                      ),
                      const Text('OTP'),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (error.isNotEmpty)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          error,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ElevatedButton(
                    onPressed: isSubmitting
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              submit(LoginRequest(
                                deviceDetails: '',
                                otp: isEnteringOtp ? otp ?? '' : '',
                                password: !isEnteringOtp ? password ?? '' : '',
                                permissions: permissions,
                                username: username ?? '',
                              ));
                            }
                          },
                    child: const Text('Login',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          )),
        ),
      )
    ]);
  }
}
