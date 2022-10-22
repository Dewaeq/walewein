import 'package:flutter/material.dart';

import 'constants.dart';

class SimpleTextButton extends StatelessWidget {
  const SimpleTextButton({
    super.key,
    required this.onPressed,
    required this.color,
    required this.text,
  });

  final VoidCallback onPressed;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: double.infinity,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: defaultButtonBorderRadius,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
