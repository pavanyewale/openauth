import 'dart:convert';

import 'package:admin/models/history/history.dart';
import 'package:admin/utils/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

class HistoryDetailsScreen extends StatelessWidget {
  final History history;
  const HistoryDetailsScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    dynamic data = json.decode(history.data);

    // Convert the parsed JSON back to a formatted string
    String prettyJson = const JsonEncoder.withIndent('    ').convert(data);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("History Details"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(
                      Icons.notes,
                      size: 30,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(history.operation,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                  ]),
                  Wrap(
                    spacing: 20,
                    runSpacing: 10,
                    children: [
                      SubTextWithIcon(
                          icon: Icons.person,
                          text: history.createdByUser.toString()),
                      SubTextWithIcon(
                          icon: Icons.calendar_today,
                          text: formatter.format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  history.createdOn)))
                    ],
                  ),
                  Text(
                    "Data",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 59, 59, 59),
                        borderRadius: BorderRadius.circular(5)),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        prettyJson,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
