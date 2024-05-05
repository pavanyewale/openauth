import 'package:admin/screens/groups/edit/edit.dart';
import 'package:admin/utils/navigator.dart';
import 'package:flutter/material.dart';

class GroupHeader extends StatelessWidget {
  const GroupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Groups", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MyRoute(builder: (context) => const CreateGroupScreen()));
          },
          child: const Row(children: [
            Icon(Icons.add),
            SizedBox(
              width: 10,
            ),
            Text("New Group")
          ]),
        )
      ],
    );
  }
}
