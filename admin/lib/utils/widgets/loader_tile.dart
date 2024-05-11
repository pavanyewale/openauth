import 'package:flutter/material.dart';

class LoaderTile extends StatelessWidget {
  const LoaderTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      title: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
