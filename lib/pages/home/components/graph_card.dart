import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walewein/models/graph/graph_model.dart';
import 'package:walewein/pages/graph/graph_page.dart';

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
                _graphChanges(),
              ],
            ),
          ),
          Expanded(
            child: Container(color: Colors.pink),
          ),
        ],
      ),
    );
  }

  Row _cardHeader() {
    return Row(
      children: [
        const Icon(
          Icons.list_alt,
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
    final relation = graph.lastChangedRelation();

    if (relation == null || relation.nodes.isEmpty) return Container();

    final length = relation.nodes.length;
    final last = relation.nodes.last;
    final previous = length >= 2 ? relation.nodes[length - 2] : last;
    final diff = last.y - previous.y;

    final result = "${diff.isNegative ? "" : "+"}$diff";
    final color =
        diff.isNegative ? const Color(0xfff7564c) : const Color(0xff08bc50);

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              last.y.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff19224c),
                fontSize: 32,
              ),
            ),
          ],
        ),
        Text(relation.yLabel),
        const SizedBox(width: 12),
        Text(
          result,
          style: TextStyle(
            fontSize: 16,
            color: color,
          ),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            "from ${DateFormat("M/d/y").format(last.dateAdded)}",
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xff8e92a6),
            ),
          ),
        ),
      ],
    );
  }

  _openGraph(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => GraphPage(graph: graph)),
    );
  }
}
