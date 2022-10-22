import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/graph/graph_model.dart';
import '../../models/graph/relation_model.dart';
import '../constants.dart';
import '../services/graph_service.dart';

class ChartView extends StatelessWidget {
  ChartView({
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
  DisplayDateSpread? _dateSpread;

  @override
  Widget build(BuildContext context) {
    if (graph.relations.isEmpty ||
        graph.relations.every((x) => x.nodes.isEmpty)) {
      return Container();
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: chart(),
    );
  }

  Widget chart() {
    final maxY = GraphService.maxY(graph)!;
    final minY = GraphService.minY(graph)!;
    final minX = GraphService.minX(graph).x;
    var maxX = showPrediction
        ? DateTime.now().add(const Duration(days: 93))
        : GraphService.maxX(graph).x;

    _dateSpread = GraphService.getDateSpread(graph, maxX);

    /* if (showDateMargin) {
      if (maxX.minute == minX.minute) {
        maxX = maxX.add(const Duration(minutes: 15));
      } else if (maxX.hour == minX.hour) {
        maxX = maxX.add(const Duration(minutes: 15));
      } else if (maxX.day == minX.day) {
        maxX = maxX.add(const Duration(hours: 8));
      } else if (maxX.month == minX.month) {
        maxX = maxX.add(const Duration(days: 5));
      }
    } */

    Map<Relation, dynamic> trends = {};
    double maxTrendPrediction = 0;

    for (final relation in graph.relations) {
      final trend = GraphService.trendPrediction(relation);
      if (trend != null) {
        final firstNode = GraphService.firstNode(relation)!;
        final prediction = trend * maxX.difference(firstNode.x).inSeconds +
            GraphService.relationMinY(relation)!.y;
        maxTrendPrediction = max(prediction, maxTrendPrediction);
        trends[relation] = {
          "trendPrediction": prediction,
          "lastNode": GraphService.lastNode(relation),
        };
      }
    }

    return Container(
      padding: showLabels
          ? const EdgeInsets.only(left: 0, bottom: 50, right: 20)
          : null,
      width: double.infinity,
      child: LineChart(
        LineChartData(
          minX: minX.millisecondsSinceEpoch.toDouble(),
          maxX: maxX.millisecondsSinceEpoch.toDouble(),
          maxY: showPrediction ? maxTrendPrediction * 1.1 : maxY.y * 1.05,
          minY: minY.y * 0.8,
          borderData: FlBorderData(
            border: Border.all(
              style: showLabels ? BorderStyle.solid : BorderStyle.none,
              color: Colors.grey[200]!,
            ),
          ),
          titlesData: _titlesData(maxX, minX),
          gridData: _gridData(
              maxX,
              minX,
              showPrediction ? maxTrendPrediction * 1.1 : maxY.y * 1.05,
              minY.y * 0.8),
          lineBarsData: [
            for (final relation in graph.relations)
              LineChartBarData(
                barWidth: 5,
                gradient: const LinearGradient(colors: [
                  Color(0xff23b6e6),
                  Color(0xff02d39a),
                ]),
                spots: buildSpots(relation),
                dotData: dotData(),
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
            ...buildPredictions(trends, maxX),
          ],
        ),
        swapAnimationDuration: const Duration(milliseconds: 300),
        swapAnimationCurve: Curves.decelerate,
      ),
    );
  }

  FlDotData dotData([Color color = kPrimaryColor]) {
    return FlDotData(
      show: showLabels,
      getDotPainter: (p0, p1, p2, p3) {
        return FlDotCirclePainter(
          strokeColor: Colors.transparent,
          color: color,
          radius: 2.5,
        );
      },
    );
  }

  List<FlSpot> buildSpots(Relation relation) {
    List<FlSpot> spots = [];

    for (final node in relation.nodes) {
      spots.add(FlSpot(node.x.millisecondsSinceEpoch.toDouble(), node.y));
    }

    return spots;
  }

  List<LineChartBarData> buildPredictions(
      Map<Relation, dynamic> trends, DateTime maxX) {
    if (!showPrediction) return [];

    return [
      for (final k in trends.entries)
        LineChartBarData(
          barWidth: 5,
          spots: [
            FlSpot(k.value["lastNode"].x.millisecondsSinceEpoch.toDouble(),
                k.value["lastNode"].y),
            FlSpot(maxX.millisecondsSinceEpoch.toDouble(),
                k.value["trendPrediction"]),
          ],
          dotData: dotData(Colors.red),
          color: Colors.orange,
        ),
    ];
  }

  FlTitlesData _titlesData(DateTime maxX, DateTime minX) {
    return FlTitlesData(
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: GraphService.bottomTitleInterval(_dateSpread!),
          getTitlesWidget: bottomTitleWidgets,
        ),
      ),
      show: showLabels,
    );
  }

  FlGridData _gridData(DateTime maxX, DateTime minX, double maxY, double minY) {
    const numLines = 8;
    final xDiff =
        (maxX.millisecondsSinceEpoch - minX.millisecondsSinceEpoch).toDouble();
    final yDiff = maxY - minY;

    final vInterval = xDiff == 0 ? 5.0 : xDiff / numLines;
    final yInterval = yDiff == 0 ? 5.0 : yDiff / numLines;

    return FlGridData(
      show: showLabels,
      verticalInterval: vInterval,
      horizontalInterval: yInterval,
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
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
      overflow: TextOverflow.visible,
    );

    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    var text = "";

    switch (_dateSpread) {
      case DisplayDateSpread.year:
        text = DateFormat("MMM").format(date);
        break;
      case DisplayDateSpread.month:
        text = DateFormat("d MMM").format(date);
        break;
      case DisplayDateSpread.week:
        text = DateFormat("EEE\nHH:mm").format(date);
        break;
      case DisplayDateSpread.day:
        text = DateFormat("HH:mm").format(date);
        break;
      default:
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }
}
