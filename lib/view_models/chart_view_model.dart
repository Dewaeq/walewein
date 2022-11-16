import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walewein/models/chart_range.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/models/data/graph_node.dart';
import 'package:walewein/models/data/price_model.dart';
import 'package:walewein/models/data/relation_model.dart';
import 'package:walewein/models/trend_prediction.dart';
import 'package:walewein/shared/components/charts/chart_view.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/shared/services/graph_service.dart';
import 'package:walewein/shared/services/isar_service.dart';

class ChartViewModel extends ViewModel<Graph> {
  ChartViewModel(
    super.context,
    this.graph,
    this.showLabels,
    this.chartType,
  );

  Graph graph;
  final bool showLabels;
  final ChartViewType chartType;

  final afterDate = DateTime.now().subtract(maxDisplayDateAgo);
  final predictionDate = DateTime.now().add(const Duration(days: 93));
  final isarService = IsarService();

  /// relations containing only nodes after [afterDate]
  late List<Relation> chartRelations;
  late GraphNode firstNode;
  late GraphNode lastNode;
  late GraphNode minNode;
  late GraphNode maxNode;
  late ChartRange chartRange;
  late DisplayDateSpread dateSpread;
  Map<Relation, TrendPrediction> trends = {};
  late List<BarDataPoint> monthlyUsages;
  late double maxMonthlyUsage;
  double selectedPointIndex = -1;
  bool showCosts = false;
  late final Price price;
  Color graphColor = Colors.white;

  @override
  Future<void> init() {
    setState(graph);
    return Future.value();
  }

  @override
  void setState([model]) async {
    loaded = false;

    if (isGraphEmpty()) {
      return;
    }

    price = await isarService.getPrice(graph.graphType);

    setRelations();
    setNodes();
    setChartRange();
    setDateSpread();
    setPredictions();
    setMonthlyUsage();

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
          color: const Color(0xff72d8bf),
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: const Color(0xff72d8bf),
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
    final stepSize = (chartRange.maxY - maxNode.y) / 1.5;
    List<String> labels = [];

    for (var i = 0; chartRange.maxY - i * stepSize > chartRange.minY; i++) {
      final value = chartRange.maxY - (i * stepSize);
      labels.add(NumberFormat.compact(locale: "en_GB").format(value.round()));
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

      if ((chartType == ChartViewType.predictions && i == steps - 2) ||
          (chartType != ChartViewType.predictions && i == steps - 1)) {
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

  double barHeight(BarDataPoint data) {
    final offset = data.isSelected ? maxMonthlyUsage * 0.05 : 0;
    final priceMultiplier = showCosts ? price.price : 1;

    return (data.y + offset) * priceMultiplier;
  }

  double barBackgroundHeight() {
    return maxMonthlyUsage * 1.1 * (showCosts ? price.price : 1);
  }

  String toolTipValue(double y) {
    final offset = maxMonthlyUsage * 0.05;
    final priceMultiplier = showCosts ? price.price : 1;

    final value = y - offset * priceMultiplier;
    return value.round().toString();
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
    firstNode = GraphService.firstNode(chartRelations, afterDate) ??
        GraphService.firstNode(chartRelations)!;
    lastNode = GraphService.lastNode(chartRelations)!;
    minNode = GraphService.minNode(chartRelations)!;
    maxNode = GraphService.maxNode(chartRelations)!;
  }

  void setChartRange() {
    chartRange = ChartRange(
      firstNode.x.millisecondsSinceEpoch.toDouble(),
      chartType == ChartViewType.predictions
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
    if (chartType != ChartViewType.predictions) return;
    double maxTrendPrediction = 0;

    for (final relation in chartRelations) {
      final trend = GraphService.trendPrediction(relation);
      if (trend == null) continue;

      final firstNode = GraphService.firstNode([relation])!;
      final offset = GraphService.relationMinY(relation)!.y;
      final prediction =
          trend * predictionDate.difference(firstNode.x).inSeconds + offset;

      maxTrendPrediction = max(maxTrendPrediction, prediction);
      trends[relation] = TrendPrediction(predictionDate, prediction);
    }

    chartRange.maxY = maxTrendPrediction * 1.1;
    chartRange.maxX = predictionDate.millisecondsSinceEpoch.toDouble();
  }

  void setMonthlyUsage() {
    monthlyUsages = [];
    maxMonthlyUsage = 0;

    final year = DateTime.now().year;
    final month = DateTime.now().month;
    final nodes = graph.relations.first.nodes;

    if (nodes.length < 2) return;

    for (int i = 4; i >= 0; i--) {
      final start =
          DateTime(year, month - i, 1).millisecondsSinceEpoch / millisInDay;
      final end =
          DateTime(year, month - i, 30).millisecondsSinceEpoch / millisInDay;

      final startUsage = GraphService.interpolate(nodes, start);
      final endUsage = GraphService.interpolate(nodes, end);
      final usage = (endUsage - startUsage).abs().roundToDouble();

      maxMonthlyUsage = max(maxMonthlyUsage, usage);
      monthlyUsages.add(BarDataPoint(month - i, usage));
    }
  }

  void toggleCosts() async {
    showCosts = !showCosts;

    for (int i = 0; i < monthlyUsages.length; i++) {
      monthlyUsages[i].y /= 2;
    }

    graphColor = Colors.yellow;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    setMonthlyUsage();
    graphColor = Colors.white;

    notifyListeners();
  }

  void selectBar(int index) {
    monthlyUsages[index].isSelected = true;
    notifyListeners();
  }

  void unSelectBar() {
    monthlyUsages = monthlyUsages.map((e) => e..isSelected = false).toList();
    notifyListeners();
  }

  void selectPoint(double yValue) {
    selectedPointIndex = yValue;
    notifyListeners();
  }

  void unSelectPoint() {
    selectedPointIndex = -1;
    notifyListeners();
  }
}

class BarDataPoint {
  int x;
  double y;
  bool isSelected;

  BarDataPoint(this.x, this.y, [this.isSelected = false]);
}
