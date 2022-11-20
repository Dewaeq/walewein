import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/pages/add_graph/pages/graph_type/graph_type_item.dart';

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
          Text(
            'addGraph.description'.tr(),
            style: const TextStyle(
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
