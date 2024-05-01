import 'package:admin/models/groups/filters.dart';
import 'package:flutter/material.dart';

class GroupFiltersWidget extends StatefulWidget {
  final Function(GroupFilters) onFetchClicked;
  const GroupFiltersWidget({super.key, required this.onFetchClicked});

  @override
  State<GroupFiltersWidget> createState() => _GroupFiltersWidgetState();
}

class _GroupFiltersWidgetState extends State<GroupFiltersWidget> {
  final GroupFilters filters = GroupFilters();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 10,
      children: [
        // name filter
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            constraints: BoxConstraints(maxWidth: 150, maxHeight: 40),
            label: Text('Group Name'),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            isDense: true, // Reduces the height of the input box
            border: OutlineInputBorder(),
            hintText: 'e.g. group1',
          ),
          onChanged: (value) {
            filters.name = value;
          },
        ),
        // clear button
        ElevatedButton(
          onPressed: () {
            nameController.clear();
            filters.name = '';
          },
          child: const Text('Clear'),
        ),

        // fetch button
        ElevatedButton(
          onPressed: () {
            // call the parent widget's onFetchClicked function
            widget.onFetchClicked(filters);
          },
          child: const Text('Fetch'),
        ),
      ],
    );
  }
}
