import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:walewein/models/data/relation_model.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/constants.dart';

class RelationInputField extends StatelessWidget {
  const RelationInputField({
    super.key,
    required this.relation,
    required this.onSelectRelation,
    required this.onFieldSubmitted,
    required this.controller,
  });

  final Relation relation;
  final Function(Relation relation) onSelectRelation;
  final Function(String value, Relation relation) onFieldSubmitted;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: kDefaultPadding / 2),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: defaultButtonBorderRadius,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            IconButton(
              onPressed: () => onSelectRelation(relation),
              tooltip: 'graph.readFromImage'.tr(),
              icon: const Icon(
                Icons.image,
                color: Colors.white,
              ),
            ),
            Container(
              width: 3,
              color: Colors.grey[700],
            ),
            defaultWidthSizedBox,
            Expanded(
              child: TextField(
                controller: controller,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.number,
                onSubmitted: (value) => onFieldSubmitted(value, relation),
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  hintText: '...',
                  hintStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Text(
              relation.yLabel.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
