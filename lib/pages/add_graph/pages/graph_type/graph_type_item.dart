import 'package:flutter/material.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/components/cross_fade.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/shared/utils.dart';

class GraphTypeItem extends StatelessWidget {
  const GraphTypeItem({
    super.key,
    required this.graphType,
    required this.isSelected,
    required this.onSelect,
  });

  final GraphType graphType;
  final bool isSelected;
  final Function onSelect;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () => onSelect(),
        borderRadius: defaultButtonBorderRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size.width * 0.95,
          height: size.height * 0.1,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: defaultButtonBorderRadius,
            border: Border.all(
              color: isSelected
                  ? const Color(0xff434ae7)
                  : const Color.fromARGB(255, 202, 202, 208),
            ),
          ),
          child: Row(
            children: [
              graphTypeToIcon(graphType),
              defaultWidthSizedBox,
              Text(graphTypeToString(graphType)),
              const Spacer(),
              SelectableCheckMark(selected: isSelected),
            ],
          ),
        ),
      ),
    );
  }
}
