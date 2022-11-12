import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walewein/models/chart_range.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/models/data/graph_node.dart';
import 'package:walewein/models/data/relation_model.dart';
import 'package:walewein/models/trend_prediction.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/shared/services/graph_service.dart';

class ChartViewModel extends ViewModel<Graph> {
  ChartViewModel(
    super.context,
    this.graph,
    this.showLabels,
    this.showPredictions,
  );

  Graph graph;
  final bool showLabels;
  final bool showPredictions;

  final afterDate = DateTime.now().subtract(maxDisplayDateAgo);
  final predictionDate = DateTime.now().add(const Duration(days: 93));

  /// relations containing only nodes after [afterDate]
  late List<Relation> chartRelations;
  late GraphNode firstNode;
  late GraphNode lastNode;
  late GraphNode minNode;
  late GraphNode maxNode;
  late ChartRange chartRange;
  late DisplayDateSpread dateSpread;
  Map<Relation, TrendPrediction> trends = {};

  @override
  Future<void> init() {
    setState(graph);
    return Future.value();
  }

  @override
  void setState([model]) {
    loaded = false;

    if (isGraphEmpty()) {
      return;
    }

    setRelations();
    setNodes();
    setChartRange();
    setDateSpread();
    setPredictions();

    super.setState();
  }

  bool isGraphEmpty() {
    return graph.relations.isEmpty ||
        graph.relations.every((x) => x.nodes.isEmpty);
  }

  FlGridData gridData() {
    const numLines = 8;
    final xDiff = chartRange.maxX - chartRange.minX;
    final vInterval = xDiff == 0 ? 5.0 : xDiff / numLines;

    return FlGridData(
      show: showLabels,
      drawHorizontalLine: true,
      drawVerticalLine: true,
      verticalInterval: vInterval,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.grey.withOpacity(0.3),
          dashArray: [10, 5],
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: Colors.grey.withOpacity(0.3),
          dashArray: [10, 5],
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

  List<String> yLabels() {
    final stepSize = (chartRange.maxY - maxNode.y) / 2;
    List<String> labels = [];

    for (var i = 0; chartRange.maxY - i * stepSize > chartRange.minY; i++) {
      final value = chartRange.maxY - (i * stepSize);
      labels.add(NumberFormat.compact(locale: "en_GB").format(value));
    }

    return labels;
  }

  List<String> xLabels() {
    const steps = 4;
    final stepSize = (chartRange.maxX - chartRange.minX) ~/ steps;
    List<String> labels = [];

    for (int i = 0; i < steps; i++) {
      final value = chartRange.minX.toInt() + i * stepSize;
      final date = DateTime.fromMillisecondsSinceEpoch(value);

      labels.add(dateLabelFromDateSpread(date));

      if (showPredictions && i == steps - 2 ||
          !showPredictions && i == steps - 1) {
        labels.add(dateLabelFromDateSpread(lastNode.x));
      }
    }

    return labels;
  }

  String dateLabelFromDateSpread(DateTime date) {
    switch (dateSpread) {
      case DisplayDateSpread.year:
        return DateFormat("d MMM").format(date);
      case DisplayDateSpread.month:
        return DateFormat("d MMM").format(date);
      case DisplayDateSpread.week:
        return DateFormat("EEE d").format(date);
      case DisplayDateSpread.day:
        return DateFormat("HH:mm").format(date);
      default:
        return "";
    }
  }

  void setRelations() {
    chartRelations = [];
    for (final relation in graph.relations) {
      final result = Relation.from(
        nodes: GraphService.nodesAfter(relation.nodes, afterDate),
        xLabel: relation.xLabel,
        yLabel: relation.yLabel,
      );

      chartRelations.add(result);
    }
  }

  void setNodes() {
    firstNode = GraphService.firstNodeV2(chartRelations, afterDate) ??
        GraphService.firstNodeV2(chartRelations)!;
    lastNode = GraphService.lastNodeV2(chartRelations)!;
    minNode = GraphService.minNode(chartRelations)!;
    maxNode = GraphService.maxNode(chartRelations)!;
  }

  void setChartRange() {
    chartRange = ChartRange(
      firstNode.x.millisecondsSinceEpoch.toDouble(),
      showPredictions
          ? predictionDate.millisecondsSinceEpoch.toDouble()
          : lastNode.x.millisecondsSinceEpoch.toDouble(),
      minNode.y * 0.8,
      maxNode.y * 1.1,
    );
  }

  void setDateSpread() {
    final maxDate =
        DateTime.fromMillisecondsSinceEpoch(chartRange.maxX.toInt());
    dateSpread =
        GraphService.daysToDateSpread(maxDate.difference(firstNode.x).inDays);
  }

  void setPredictions() {
    if (!showPredictions) return;
    double maxTrendPrediction = 0;

    for (final relation in chartRelations) {
      final trend = GraphService.trendPrediction(relation);
      if (trend == null) continue;

      final firstNode = GraphService.firstNodeV2([relation])!;
      final offset = GraphService.relationMinY(relation)!.y;
      final prediction =
          trend * predictionDate.difference(firstNode.x).inSeconds + offset;

      maxTrendPrediction = max(maxTrendPrediction, prediction);
      trends[relation] = TrendPrediction(predictionDate, prediction);
    }

    chartRange.maxY = maxTrendPrediction * 1.1;
    chartRange.maxX = predictionDate.millisecondsSinceEpoch.toDouble();
  }
}
