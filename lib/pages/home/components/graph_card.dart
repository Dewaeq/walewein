import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walewein/models/graph/graph_model.dart';
import 'package:walewein/pages/graph/graph_page.dart';
import 'package:walewein/shared/services/graph_service.dart';

class GraphCard extends StatelessWidget {
  const GraphCard({super.key, required this.graph});

  final Graph graph;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => _openGraph(context),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          color: Color(0x33000000),
        ),
      ),
      color: Colors.white,
      elevation: 0,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _cardHeader(),
                const SizedBox(height: 15),
                _graphChanges(),
              ],
            ),
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.2,
              child: ChartView(graph: graph, showLabels: false),
            ),
          ),
        ],
      ),
    );
  }

  Row _cardHeader() {
    return Row(
      children: [
        SizedBox(
          child: GraphService.graphTypeToIcon(graph.graphType, 17),
        ),
        const SizedBox(width: 15),
        Text(
          graph.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _graphChanges() {
    final relation = GraphService.lastChangedRelation(graph);
    final empty = relation == null || relation.nodes.isEmpty;

    var diff = 0.0;
    var lastValue = 0.0;
    var date = graph.dateCreated;

    if (!empty) {
      final length = relation.nodes.length;
      final last = relation.nodes.last;
      final previous = length >= 2 ? relation.nodes[length - 2] : last;

      lastValue = last.y;
      date = previous.dateAdded;
      diff = last.y - previous.y;
    }

    if (diff > 5) {
      diff = diff.roundToDouble();
    } else {
      diff = double.parse(diff.toStringAsFixed(4));
    }

    final result = "${diff.isNegative ? "" : "+"}$diff";
    final color =
        diff.isNegative ? const Color(0xfff7564c) : const Color(0xff08bc50);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              lastValue.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff19224c),
                fontSize: 32,
              ),
            ),
            const SizedBox(width: 5),
            Text(relation!.yLabel),
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
            Text(
              "from ${DateFormat("EEE, d MMM").format(date)}",
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xff8e92a6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _openGraph(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => GraphPage(id: graph.id!)),
    );
  }
}
