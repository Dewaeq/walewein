import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:walewein/models/data/graph_node.dart';
import 'package:walewein/pages/graph/components/node_tile.dart';
import 'package:walewein/pages/home/components/text_with_custom_underline.dart';
import 'package:walewein/shared/components/help_button.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/models/data/relation_model.dart';

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
              TextWithCustomUnderline(text: relation.xLabel.tr()),
              const Spacer(),
              TextWithCustomUnderline(text: relation.yLabel.tr()),
              HelpButton(
                content: 'graph.tileHelpText'.tr(),
              ),
            ],
          ),
          const Divider(
            indent: 20,
            endIndent: 20,
            color: Colors.black,
          ),
          for (int i = 0; i < relation.nodes.length; i++)
            NodeTile(
              node: relation.nodes[i],
              diff: i == 0 ? 0 : relation.nodes[i].y - relation.nodes[i - 1].y,
              onPressed: onNodePressed,
            ),
        ],
      ),
    );
  }
}
