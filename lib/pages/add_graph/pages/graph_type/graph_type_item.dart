import 'package:flutter/material.dart';
import '../../../../models/graph/graph_model.dart';
import '../../../../shared/services/graph_service.dart';

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
        borderRadius: BorderRadius.circular(7),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size.width * 0.95,
          height: size.height * 0.1,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: isSelected
                  ? const Color(0xff434ae7)
                  : const Color.fromARGB(255, 202, 202, 208),
            ),
          ),
          child: Row(
            children: [
              GraphService.graphTypeToIcon(graphType),
              const SizedBox(width: 15),
              Text(GraphService.graphTypeToTitle(graphType)),
              const Spacer(),
              AnimatedCrossFade(
                crossFadeState: isSelected
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 300),
                firstChild: const Icon(
                  Icons.check_circle,
                  color: Color(0xff434ae7),
                ),
                secondChild: const Icon(
                  Icons.circle_outlined,
                  color: Color(0xff434ae7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
