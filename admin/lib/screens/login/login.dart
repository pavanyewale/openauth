import 'package:admin/utils/widgets/login/form.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(children: [
                Image.asset(
                  "assets/images/logo.png",
                  height: 200,
                ),
                const SizedBox(
                  height: 30,
                ),
                const LoginForm(),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
