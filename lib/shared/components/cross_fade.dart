import 'package:flutter/material.dart';

class SelectableCheckMark extends StatelessWidget {
  const SelectableCheckMark({
    super.key,
    required this.selected,
    this.iconSize,
  });

  final bool selected;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState:
          selected ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300),
      firstChild: Icon(
        Icons.check_circle,
        color: const Color(0xff434ae7),
        size: iconSize,
      ),
      secondChild: Icon(
        Icons.circle_outlined,
        color: const Color(0xff434ae7),
        size: iconSize,
      ),
    );
  }
}
