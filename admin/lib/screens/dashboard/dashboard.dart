//dashboard widget to show the dashboard screen
import 'package:admin/utils/widgets/comming_soon.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Dashboard", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(
          height: 200,
          width: double.infinity,
          child: CommingSoon(),
        ),
      ],
    );
  }
}
