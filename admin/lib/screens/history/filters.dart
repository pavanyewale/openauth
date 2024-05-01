// history filters start date and end date

import 'package:admin/models/history/filters.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryFiltersWidget extends StatefulWidget {
  final void Function(HistoryFilters) onFetchClicked;
  const HistoryFiltersWidget({super.key, required this.onFetchClicked});

  @override
  State<HistoryFiltersWidget> createState() => _HistoryFiltersWidgetState();
}

class _HistoryFiltersWidgetState extends State<HistoryFiltersWidget> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 10,
      children: [
        //date range picker
        TextField(
          readOnly: true, // Makes the input box read-only
          controller: _startDateController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            constraints: const BoxConstraints(maxWidth: 150, maxHeight: 35),
            labelText: 'Start Date',
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _startDate ?? DateTime.now(),
                  firstDate: DateTime(2015, 8),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _startDate) {
                  setState(() {
                    _startDate = picked;
                    _startDateController.text =
                        DateFormat('yyyy-MM-dd').format(picked);
                  });
                }
              },
            ),
          ),
        ),
        TextField(
          readOnly: true, // Makes the input box read-only
          controller: _endDateController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            constraints: const BoxConstraints(maxWidth: 150, maxHeight: 35),
            labelText: 'End Date',
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _startDate ?? DateTime.now(),
                  firstDate: DateTime(2015, 8),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _endDate) {
                  setState(() {
                    _endDate = picked;
                    _endDateController.text =
                        DateFormat('yyyy-MM-dd').format(picked);
                  });
                }
              },
            ),
          ),
        ),
        //clear button
        ElevatedButton(
          onPressed: () {},
          child: const Text('Clear'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onFetchClicked(HistoryFilters(
                startDate: _startDate!.millisecondsSinceEpoch,
                endDate: _endDate!.millisecondsSinceEpoch));
          },
          child: const Text('Fetch'),
        ),
      ],
    );
  }
}
