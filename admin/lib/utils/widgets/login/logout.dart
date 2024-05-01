import 'package:admin/utils/widgets/login/service.dart';
import 'package:admin/utils/toast.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  void showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final res = await LoginService.instance.logout();
                if (res.error.isNotEmpty) {
                  MyToast.error(res.error);
                }
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('Logout'),
      onTap: () {
        showLogoutConfirmation(context);
      },
    );
  }
}
