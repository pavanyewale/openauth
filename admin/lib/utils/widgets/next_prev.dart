import 'package:flutter/material.dart';

class NextAndPrevPaginationButtons extends StatelessWidget {
  final void Function()? onNextClicked;
  final void Function()? onPrevClicked;
  final bool isNext;
  final bool isPrev;

  const NextAndPrevPaginationButtons({
    super.key,
    required this.onNextClicked,
    required this.onPrevClicked,
    required this.isNext,
    required this.isPrev,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: isPrev ? onPrevClicked : null,
              child: const Row(
                children: [
                  Icon(Icons.arrow_back),
                  SizedBox(width: 5),
                  Text('Prev'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: isNext ? onNextClicked : null,
              child: const Row(
                children: [
                  Text('Next'),
                  SizedBox(width: 5),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ],
        ));
  }
}
