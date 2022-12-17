import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:walewein/models/data/graph_node.dart';
import 'package:walewein/shared/components/constants.dart';

class NodeTile extends StatelessWidget {
  const NodeTile({
    Key? key,
    required this.node,
    required this.diff,
    required this.onPressed,
  }) : super(key: key);

  final GraphNode node;
  final double diff;
  final Function(GraphNode node) onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: defaultButtonBorderRadius,
          side: BorderSide(
            color: Colors.grey[200]!,
          ),
        ),
        title: Text(DateFormat('d MMMM yyyy').format(node.x)),
        subtitle: Text("+ $diff"),
        trailing: Text(node.y.toString()),
        enableFeedback: true,
        onTap: () {},
        onLongPress: () => onPressed(node),
      ),
    );
  }
}
