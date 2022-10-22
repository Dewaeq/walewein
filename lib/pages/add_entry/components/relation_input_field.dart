import 'package:flutter/material.dart';
import 'package:walewein/models/graph/relation_model.dart';

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
    return Row(children: [
      IconButton(
        onPressed: () => onSelectRelation(relation),
        tooltip: "Read from image",
        icon: const Icon(
          Icons.image,
          color: Colors.white,
        ),
      ),
      Expanded(
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.left,
          keyboardType: TextInputType.number,
          onFieldSubmitted: (value) => onFieldSubmitted(value, relation),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 33,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      Text(
        relation.yLabel,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
      )
    ]);
  }
}
