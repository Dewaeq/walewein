import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  const ToggleButton({
    super.key,
    required this.primaryIcon,
    required this.secondaryIcon,
    required this.showPrimary,
    this.duration = const Duration(milliseconds: 300),
    this.iconColor,
  });

  final bool showPrimary;
  final IconData primaryIcon;
  final IconData secondaryIcon;
  final Color? iconColor;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedScale(
          duration: duration,
          scale: showPrimary ? 0 : 1,
          child: Icon(primaryIcon, color: iconColor),
        ),
        AnimatedScale(
          duration: duration,
          scale: showPrimary ? 1 : 0,
          child: Icon(secondaryIcon, color: iconColor),
        ),
      ],
    );
  }
}
