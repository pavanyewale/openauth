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
  final TextEditingController _userIDController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  int _userID = 0;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 10,
      children: [
        TextField(
          controller: _userIDController,
          maxLines: 1,
          decoration: const InputDecoration(
            constraints: BoxConstraints(maxWidth: 150, maxHeight: 40),
            label: Text('User ID'),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            isDense: true, // Reduces the height of the input box
            border: OutlineInputBorder(),
            hintText: 'e.g. 128974',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            _userID = int.tryParse(value) ?? 0;
          },
        ),
        //date picker
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
          onPressed: () {
            _startDateController.clear();
            _endDateController.clear();
            _userIDController.clear();
            _startDate = null;
            _endDate = null;
            _userID = 0;
          },
          child: const Text('Clear'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onFetchClicked(HistoryFilters(
                startDate: _startDate!.millisecondsSinceEpoch,
                endDate: _endDate!.millisecondsSinceEpoch,
                userID: _userID));
          },
          child: const Text('Fetch'),
        ),
      ],
    );
  }
}
