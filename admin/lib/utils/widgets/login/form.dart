import 'package:admin/utils/colors.dart';
import 'package:admin/utils/widgets/login/api_structs/login.dart';
import 'package:admin/utils/widgets/login/service.dart';
import 'package:admin/utils/toast.dart';
import 'package:admin/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
  bool isOTPSent = false;
  String message = '';
  void submit(LoginRequest request) async {
    setState(() {
      isSubmitting = true;
      error = "";
      message = "";
    });
    if (isEnteringOtp && !isOTPSent) {
      request.password = "";
      request.sendOtp = true;
    }
    request.deviceDetails = await Utils.instance.fetchDeviceInfo();
    LoginResponse resp = await LoginService.instance.login(request);
    if (resp.error.isNotEmpty) {
      error = resp.error;
    } else {
      if (isEnteringOtp) {
        isOTPSent = true;
        MyToast.success("OTP sent to your mobile/email");
      } else {
        MyToast.success("Logged in successfully!");
      }
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
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    initialValue: username,
                    decoration: InputDecoration(
                        labelText: isEnteringOtp
                            ? "Mobile / Email"
                            : 'Username / Mobile / Email'),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          (isEnteringOtp &&
                              !Utils.instance.isValidMobileOrEmail(value))) {
                        return isEnteringOtp
                            ? 'Please enter valid Mobile/Email'
                            : 'Please enter username / email / mobile';
                      }
                      return null;
                    },
                    onSaved: (value) => username = value!,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (isEnteringOtp && isOTPSent)
                    TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
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
                  if (message.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          message,
                          style: const TextStyle(
                              color: AppColors.success,
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
