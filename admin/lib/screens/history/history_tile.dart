import 'package:admin/models/history/history.dart';
import 'package:admin/utils/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

class HistoryTile extends StatelessWidget {
  final History history;
  const HistoryTile({super.key, required this.history});

  onTap(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('History Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Operation: ${history.operation}'),
            Text('Data: ${history.data}'),
            Text('Created By: ${history.createdByUser}'),
            Text(
                'Created On: ${formatter.format(DateTime.fromMillisecondsSinceEpoch(history.createdOn))}'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.history_edu,
        color: Theme.of(context).primaryColorDark,
      ),
      title: Text(history.operation),
      subtitle: Wrap(spacing: 20, runSpacing: 10, children: [
        SubTextWithIcon(
          icon: Icons.description,
          text: history.data,
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
        onTap(context);
      },
    );
  }
}
