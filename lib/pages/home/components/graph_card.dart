import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/pages/graph/graph_page.dart';
import 'package:walewein/shared/components/charts/chart_view.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/components/cross_fade.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/shared/services/graph_service.dart';
import 'package:walewein/shared/utils.dart';

class GraphCard extends StatelessWidget {
  const GraphCard({
    super.key,
    required this.graph,
    required this.isSelecting,
    required this.isSelected,
    required this.onSelect,
  });

  final Graph graph;
  final bool isSelecting;
  final bool isSelected;
  final Function() onSelect;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => isSelecting ? onSelect() : _openGraph(context),
      onLongPress: onSelect,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: defaultButtonBorderRadius,
        side: const BorderSide(
          color: Color(0x33000000),
        ),
      ),
      color: isSelected ? const Color(0xffacc2cd) : Colors.white,
      elevation: 0,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: kDefaultPadding / 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _cardHeader(),
                  defaultHalfHeightSizedBox,
                  _graphChanges(),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
                child: AspectRatio(
                  aspectRatio: 1.3,
                  child: ChartView(
                    graph: graph,
                    showLabels: false,
                    chartType: ChartViewType.cumulativeUsage,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _cardHeader() {
    return Row(
      children: [
        AnimatedCrossFade(
          firstChild: graphTypeToIcon(graph.graphType, 17),
          secondChild: SelectableCheckMark(selected: isSelected, iconSize: 34),
          crossFadeState: isSelecting
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        defaultHalfWidthSizedBox,
        Flexible(
          child: Text(
            graph.name ?? '${graph.graphType}'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _graphChanges() {
    final relation = GraphService.lastChangedRelation(graph);
    final empty = relation == null || relation.nodes.isEmpty;

    // usage this month
    double usage = 0;
    // usage compared to last month
    double diff = 1;

    if (!empty) {
      final now = DateTime.now();
      usage = GraphService.monthlyUsage(relation.nodes, now.year, now.month);

      final prevUsage = GraphService.monthlyUsage(
        relation.nodes,
        now.year,
        now.month - 1,
        endDay: now.day,
      );
      if (prevUsage == 0) {
        diff = 1;
      } else {
        diff = (usage / prevUsage);
      }
    }

    final result = diff >= 1
        ? '+${((diff - 1) * 100).toStringAsFixed(2)}%'
        : '-${(((1 - diff) * 100).toStringAsFixed(2))}%';
    final color = diff < 1 ? const Color(0xfff7564c) : const Color(0xff08bc50);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                '${usage.round()}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff19224c),
                  fontSize: 32,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(relation!.yLabel.tr()),
          ],
        ),
        Row(
          children: [
            Text(
              result,
              style: TextStyle(
                fontSize: 16,
                color: color,
              ),
            ),
            const SizedBox(width: 5),
            const Flexible(
              child: Text(
                // TODO: translation
                'from last month',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff8e92a6),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _openGraph(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => GraphPage(id: graph.id!)),
    );
  }
}
