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
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(children: [
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 40, left: 60, right: 60),
                  child: Image.asset(
                    "assets/images/logo.png",
                  ),
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
