import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:walewein/models/graph/graph_model.dart';
import 'package:walewein/pages/add_entry/add_entry_page.dart';
import 'package:walewein/pages/home/home.dart';
import 'package:walewein/shared/constants.dart';
import '../../models/graph/relation_model.dart';
import '../../shared/services/isar_service.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key, required this.id});

  final Id id;

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  final _isarService = IsarService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Graph?>(
        stream: _isarService.listenGraph(widget.id),
        builder: (context, snapshot) {
          final graph = snapshot.data;
          if (!snapshot.hasData || graph == null) {
            return const CircularProgressIndicator();
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(graph.name),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ));
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: Column(
              children: [
                const SizedBox(height: 50),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: ChartView(graph: graph),
                ),
                for (final relation in graph.relations) _showRelation(relation)
              ],
            ),
            floatingActionButton: _buildFloatingActionButton(graph),
          );
        });
  }

  Widget _showRelation(Relation relation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(relation.xLabel),
            const Spacer(),
            Text(relation.yLabel),
          ],
        ),
        for (final node in relation.nodes)
          Row(
            children: [
              Text(DateFormat().format(node.x)),
              const Spacer(),
              Text(node.y.toString()),
            ],
          ),
      ],
    );
  }

  FloatingActionButton _buildFloatingActionButton(Graph graph) {
    return FloatingActionButton(
      onPressed: () => _addEntry(graph),
      backgroundColor: kPrimaryColor,
      tooltip: 'Add Entry',
      child: const Icon(Icons.add),
    );
  }

  _addEntry(Graph graph) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddEntryPage(graph: graph)),
    );
  }
}

// ignore: must_be_immutable
class ChartView extends StatelessWidget {
  ChartView({
    Key? key,
    required this.graph,
    this.showLabels = true,
  }) : super(key: key);

  final Graph graph;
  bool showLabels;

  @override
  Widget build(BuildContext context) {
    if (graph.relations.isEmpty || graph.relations.first.nodes.isEmpty) {
      return Container();
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: showLabels
                ? null
                : AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
            bottomTitles: showLabels
                ? null
                : AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
          ),
          gridData: FlGridData(
            show: showLabels,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.3),
                dashArray: [10, 3],
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.3),
                dashArray: [10, 3],
              );
            },
          ),
          lineBarsData: [
            for (final relation in graph.relations)
              LineChartBarData(
                // isCurved: true,
                // curveSmoothness: 0.1,
                barWidth: 5,
                gradient: const LinearGradient(colors: [
                  Color(0xff23b6e6),
                  Color(0xff02d39a),
                ]),
                spots: [
                  for (final node in relation.nodes)
                    FlSpot(
                      (node.x.millisecondsSinceEpoch -
                                  graph.dateCreated.millisecondsSinceEpoch)
                              .toDouble() /
                          1000,
                      node.y,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
