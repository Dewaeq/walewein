import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walewein/models/data/graph_node.dart';
import 'package:walewein/pages/home/components/text_with_custom_underline.dart';
import 'package:walewein/shared/components/help_button.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/models/data/relation_model.dart';
import 'package:walewein/shared/components/constants.dart';

class RelationCard extends StatelessWidget {
  const RelationCard({
    super.key,
    required this.relation,
    required this.onNodePressed,
  });

  final Relation relation;
  final Function(GraphNode) onNodePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        children: [
          Row(
            children: [
              TextWithCustomUnderline(text: relation.xLabel),
              const Spacer(),
              TextWithCustomUnderline(text: relation.yLabel),
              const HelpButton(
                  content: 'Long press a tile to change its values'),
            ],
          ),
          const Divider(
            indent: 20,
            endIndent: 20,
            color: Colors.black,
          ),
          ...relation.nodes.map((node) {
            return NodeTile(node: node, onPressed: onNodePressed);
          }),
        ],
      ),
    );
  }
}

class NodeTile extends StatelessWidget {
  const NodeTile({
    Key? key,
    required this.node,
    required this.onPressed,
  }) : super(key: key);

  final GraphNode node;
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
        leading: Text(DateFormat("d MMM yyyy, HH:mm").format(node.x)),
        trailing: Text(node.y.toString()),
        enableFeedback: true,
        onTap: () {},
        onLongPress: () => onPressed(node),
        /* onLongPress: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            builder: (context) => EditEntryModal(
              node: node,
              relation: relation,
              graph: graph,
            ),
          );
        }, */
      ),
    );
  }
}
