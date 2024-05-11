import 'package:admin/models/history/history.dart';
import 'package:admin/screens/history/details/details.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/utils/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryTile extends StatelessWidget {
  final History history;
  const HistoryTile({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.notes,
        size: 30,
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: Text(history.operation,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold)),
      subtitle: Wrap(spacing: 20, runSpacing: 10, children: [
        SubTextWithIcon(
          icon: Icons.description,
          text: history.data,
          maxLines: 1,
        ),
        SubTextWithIcon(
          icon: Icons.person,
          text: history.createdByUser.toString(),
        ),
        SubTextWithIcon(
            icon: Icons.calendar_today,
            text: formatter
                .format(DateTime.fromMillisecondsSinceEpoch(history.createdOn)))
      ]),
      onTap: () {
        // navigate to details screen
        Navigator.of(context).push(MyRoute(
          builder: (context) => HistoryDetailsScreen(history: history),
        ));
      },
    );
  }
}
