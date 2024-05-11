import 'package:admin/models/permissions/filters.dart';
import 'package:flutter/material.dart';

class PermissionsFilterWidget extends StatefulWidget {
  final Function(PermissionsFilters) onFetchClicked;
  const PermissionsFilterWidget({super.key, required this.onFetchClicked});

  @override
  State<PermissionsFilterWidget> createState() =>
      _PermissionsFilterWidgetState();
}

class _PermissionsFilterWidgetState extends State<PermissionsFilterWidget> {
  final PermissionsFilters filters = PermissionsFilters();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // name filter
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            constraints: BoxConstraints(maxWidth: 150, maxHeight: 40),
            label: Text('Name'),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            isDense: true, // Reduces the height of the input box
            border: OutlineInputBorder(),
            hintText: 'e.g. permission1',
          ),
          onChanged: (value) {
            filters.name = value;
          },
        ),
        // category filter
        TextField(
          controller: categoryController,
          decoration: const InputDecoration(
            constraints: BoxConstraints(maxWidth: 150, maxHeight: 40),
            label: Text('Category'),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            isDense: true, // Reduces the height of the input box
            border: OutlineInputBorder(),
            hintText: 'e.g. category1',
          ),
          onChanged: (value) {
            filters.category = value;
          },
        ),
        // clear button
        ElevatedButton(
          onPressed: () {
            nameController.clear();
            filters.name = '';
            categoryController.clear();
            filters.category = '';
          },
          child: const Text('Clear'),
        ),
        // fetch button
        ElevatedButton(
          onPressed: () {
            widget.onFetchClicked(filters);
          },
          child: const Text('Search'),
        ),
      ],
    );
  }
}
