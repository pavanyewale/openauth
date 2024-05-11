import 'package:flutter/material.dart';

class LoadMoreTile extends StatelessWidget {
  final Function() onTap;
  const LoadMoreTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onTap,
        title: Center(
            child: Text("Load More...",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ))));
  }
}
