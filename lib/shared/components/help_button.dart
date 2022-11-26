import 'package:easy_localization/easy_localization.dart';
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
      tooltip: 'general.help'.tr(),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('general.help'.tr()),
              content: Text(content),
              actionsPadding: const EdgeInsets.only(
                right: 20,
                bottom: 10,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'general.ok'.tr()),
                  child: Text(
                    'general.ok'.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
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
