import 'package:flutter/material.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({
    super.key,
    required this.content,
    this.iconColor = Colors.black,
  });
  final String content;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Help",
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Help"),
              content: Text(content),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, "Cancel"),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, "OK"),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      },
      icon: Icon(
        Icons.help_outline_rounded,
        color: iconColor,
      ),
    );
  }
}
