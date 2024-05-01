import 'package:admin/screens/history/list.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("History", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 20),
        const HistoryList()
      ],
    );
  }
}
