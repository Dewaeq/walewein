import 'package:flutter/material.dart';
import 'package:walewein/pages/home/components/text_with_custom_underline.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/constants.dart';

class TitleWithEditButton extends StatelessWidget {
  const TitleWithEditButton({
    Key? key,
    required this.title,
    required this.isEditing,
    required this.onPress,
  }) : super(key: key);

  final String title;
  final bool isEditing;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: [
          TextWithCustomUnderline(text: title),
          const Spacer(),
          MaterialButton(
            onPressed: () => onPress(),
            color: isEditing ? Colors.red : kPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: isEditing
                ? Row(
                    children: const [
                      Text(
                        "Done",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: const [
                      Text(
                        "Edit",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      defaultHalfWidthSizedBox,
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
