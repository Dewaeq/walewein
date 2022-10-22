import 'package:flutter/material.dart';
import 'package:walewein/models/graph/graph_model.dart';

import 'graph_type_item.dart';

class SelectGraphTypePage extends StatelessWidget {
  const SelectGraphTypePage(
      {super.key, required this.onSelect, required this.selectedType});

  final Function(GraphType) onSelect;
  final GraphType? selectedType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 38),
      child: Column(
        children: [
          const Text(
            "Select one of our prebuilt graphs, or add a custom one",
            style: TextStyle(
              color: Color.fromARGB(255, 158, 158, 163),
            ),
          ),
          const Spacer(),
          for (var type in GraphType.values)
            GraphTypeItem(
              graphType: type,
              isSelected: type == selectedType,
              onSelect: () => onSelect(type),
            ),
          const Spacer(),
        ],
      ),
    );
  }
}
