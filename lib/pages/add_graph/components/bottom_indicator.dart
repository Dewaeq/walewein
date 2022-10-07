import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class BottomIndicator extends StatelessWidget {
  const BottomIndicator({
    Key? key,
    required this.page,
    required this.numPages,
  }) : super(key: key);

  final int numPages;
  final double page;

  @override
  Widget build(BuildContext context) {
    return DotsIndicator(
      dotsCount: numPages,
      position: page,
      decorator: DotsDecorator(
        color: const Color(0xffb9b9bd),
        activeColor: const Color(0xff424ce4),
        size: const Size(75, 5),
        activeSize: const Size(75, 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
