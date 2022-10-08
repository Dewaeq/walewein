import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:walewein/models/graph/graph_model.dart';
import 'package:walewein/pages/add_entry/add_entry_page.dart';
import 'package:walewein/pages/home/components/text_with_custom_underline.dart';
import 'package:walewein/pages/home/home.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/shared/services/graph_service.dart';
import 'package:walewein/shared/services/utils.dart';
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
  bool _showPredictions = false;

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
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: ChartView(
                      graph: graph,
                      showPrediction: _showPredictions,
                    ),
                  ),
                  const TextWithCustomUnderline(text: "Show predictions"),
                  Switch(
                    value: _showPredictions,
                    onChanged: (value) {
                      setState(() => _showPredictions = value);
                    },
                  ),
                  const SizedBox(height: 15),
                  for (final relation in graph.relations)
                    _showRelation(relation),
                ],
              ),
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

class ChartView extends StatelessWidget {
  const ChartView({
    Key? key,
    required this.graph,
    this.showLabels = true,
    this.showPrediction = false,
    this.showDateMargin = true,
  }) : super(key: key);

  final Graph graph;
  final bool showLabels;
  final bool showPrediction;
  final bool showDateMargin;

  @override
  Widget build(BuildContext context) {
    if (graph.relations.isEmpty ||
        graph.relations.every((x) => x.nodes.isEmpty)) {
      return Text(graph.relations.last.nodes.length.toString());
    }

    return chart(context);
  }

  Widget chart(BuildContext context) {
    final maxY = GraphService.maxY(graph)!;
    final minY = GraphService.minY(graph)!;
    final minX = GraphService.minX(graph).x;
    var maxX = showPrediction ? DateTime.now() : GraphService.maxX(graph).x;

    if (showDateMargin) {
      if (maxX.minute == minX.minute) {
        maxX = maxX.add(const Duration(minutes: 15));
      } else if (maxX.hour == minX.hour) {
        maxX = maxX.add(const Duration(minutes: 15));
      } else if (maxX.day == minX.day) {
        maxX = maxX.add(const Duration(hours: 8));
      } else if (maxX.month == minX.month) {
        maxX = maxX.add(const Duration(days: 5));
      }
    }

    final firstNode = GraphService.firstNode(graph.relations.first)!;
    final lastNode = GraphService.lastNode(graph.relations.first)!;

    // change per second
    final trend = (lastNode.y - firstNode.y) /
        (lastNode.x.millisecondsSinceEpoch -
            firstNode.x.millisecondsSinceEpoch) *
        1000;
    final trendPrediction = firstNode == lastNode
        ? firstNode.y
        : trend * maxX.difference(firstNode.x).inSeconds + minY.y;

    debugPrint("${firstNode == lastNode}");

    Map<Relation, dynamic> trends = {};

    for (final relation in graph.relations) {
      final trend = GraphService.trendPrediction(relation);
      if (trend != null) {
        final prediction =
            trend * maxX.difference(firstNode.x).inSeconds + minY.y;
        trends[relation] = {
          "trendPrediction": prediction,
          "lastNOde": GraphService.lastNode(relation),
        };
      }
    }

    return Container(
      padding: showLabels
          ? const EdgeInsets.only(left: 0, bottom: 50, right: 20)
          : null,
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      child: LineChart(
        LineChartData(
          minX: calculateX(minX),
          maxX: calculateX(maxX),
          maxY: showPrediction ? trendPrediction * 1.1 : maxY.y * 1.05,
          minY: minY.y * 0.8,
          titlesData: FlTitlesData(
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: const Text("kWh"),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
              ),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: const Text("Date"),
              sideTitles: SideTitles(
                showTitles: true,
                interval: 0.20,
                getTitlesWidget: bottomTitleWidgets,
              ),
            ),
            show: showLabels,
          ),
          gridData: _gridData(),
          lineBarsData: [
            for (final relation in graph.relations)
              LineChartBarData(
                barWidth: 5,
                gradient: const LinearGradient(colors: [
                  Color(0xff23b6e6),
                  Color(0xff02d39a),
                ]),
                spots: buildSpots(relation),
                dotData: FlDotData(
                  show: showLabels,
                  getDotPainter: (p0, p1, p2, p3) {
                    return FlDotCirclePainter(
                      strokeColor: Colors.transparent,
                      color: kPrimaryColor,
                      radius: 2.5,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: false,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xff23b6e6),
                      const Color(0xff02d39a),
                    ].map((color) => color.withOpacity(0.3)).toList(),
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            showPrediction
                ? LineChartBarData(
                    spots: [
                      FlSpot(calculateX(lastNode.x), lastNode.y),
                      FlSpot(calculateX(maxX), trendPrediction)
                    ],
                    color: Colors.pink,
                  )
                : LineChartBarData(),
          ],
        ),
        swapAnimationDuration: const Duration(milliseconds: 300),
        swapAnimationCurve: Curves.decelerate,
      ),
    );
  }

  List<FlSpot> buildSpots(Relation relation) {
    List<FlSpot> spots = [];

    for (final node in relation.nodes) {
      spots.add(FlSpot(calculateX(node.x), node.y));
    }

    return spots;
  }

  double calculateX(DateTime date) {
    return date.month +
        (date.day * 24 * 3600 +
                date.hour * 3600 +
                date.minute * 60 +
                date.second) /
            2592000;
  }

  FlGridData _gridData() {
    return FlGridData(
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
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16,
      overflow: TextOverflow.visible,
    );

    if (value > 12) {
      value = value - 12;
    }

    Widget text;
    if (meta.max - meta.min < 1) {
      text = Text(keyToDateString(value),
          style: style, textAlign: TextAlign.center);
    } else {
      text = Text(intToMonth(value.toInt()),
          style: style, textAlign: TextAlign.center);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: text,
    );
  }
}
