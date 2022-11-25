import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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
import 'package:walewein/shared/services/storage_service.dart';
import 'package:walewein/shared/utils.dart';

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
  final storage = StorageService();

  /// relations containing only nodes after [afterDate]
  late List<Relation> chartRelations;
  late GraphNode firstNode;
  late GraphNode lastNode;
  late GraphNode minNode;
  late GraphNode maxNode;
  late ChartRange chartRange;
  late DisplayDateSpread dateSpread;
  Map<Relation, TrendPrediction> trends = {};
  List<BarDataPoint> monthlyUsages = [];
  late double maxMonthlyUsage;
  double selectedPointIndex = -1;
  bool showCosts = false;
  bool isAnimatingCosts = false;
  List<Price> prices = [];

  @override
  Future<void> init() async {
    prices = await storage.getAllPrices();
    setState(graph);
  }

  @override
  void setState([model]) async {
    loaded = false;

    if (isGraphEmpty()) {
      loaded = true;
      return;
    }

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
      getDrawingHorizontalLine: (value) => FlLine(color: kGraphAccentColor),
      getDrawingVerticalLine: (value) => FlLine(color: kGraphAccentColor),
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
    const steps = 5;
    final stepSize = (chartRange.maxY - chartRange.minY) ~/ steps;
    List<String> labels = [];

    for (int i = 0; i < steps; i++) {
      final value = chartRange.minY.toInt() + i * stepSize;
      labels.add(NumberFormat.compact(locale: 'en_GB').format(value));
    }

    labels.add(
        NumberFormat.compact(locale: 'en_GB').format(chartRange.maxY.round()));

    return labels.reversed.toList();
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
        return DateFormat('d MMM').format(date);
      case DisplayDateSpread.month:
        return DateFormat('d MMM').format(date);
      case DisplayDateSpread.week:
        return DateFormat('EEE d').format(date);
      case DisplayDateSpread.day:
        return DateFormat('HH:mm').format(date);
      default:
        return '';
    }
  }

  double barHeight(BarDataPoint data) {
    final offset = data.isSelected ? maxMonthlyUsage * 0.05 : 0;
    return (data.y + offset);
  }

  double barBackgroundHeight(BarDataPoint data) {
    return maxMonthlyUsage * 1.1;
  }

  Color barColor(BarDataPoint data) {
    if (data.isSelected) return Colors.yellow;
    if (isAnimatingCosts) return Colors.yellow;

    return Colors.white;
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
        daysToDisplayDateSpread(maxDate.difference(firstNode.x).inDays);
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

    for (int i = 0; i < graph.relations.length; i++) {
      final relation = graph.relations[i];
      final nodes = relation.nodes;

      if (nodes.length < 2) continue;

      for (int j = 4; j >= 0; j--) {
        var price = prices.firstWhere((e) => e.graphType == graph.graphType);

        if (i == 0 && graph.graphType == GraphType.electricityDouble) {
          price =
              prices.firstWhere((e) => e.graphType == GraphType.electricity);
        }

        final start =
            DateTime(year, month - j, 1).millisecondsSinceEpoch / millisInDay;
        final end =
            DateTime(year, month - j, 30).millisecondsSinceEpoch / millisInDay;

        final startUsage = GraphService.interpolate(nodes, start);
        final endUsage = GraphService.interpolate(nodes, end);
        final total = (endUsage - startUsage).abs().roundToDouble();
        final usage = total * (showCosts ? price.price : 1);

        final x = month - j;

        if (monthlyUsages.any((e) => e.x == x)) {
          final dataPoint = monthlyUsages.firstWhere((e) => e.x == x);
          final fromY = dataPoint.entries.last.toY;
          final toY = fromY + usage;

          maxMonthlyUsage = max(maxMonthlyUsage, toY);
          dataPoint.y = toY;
          dataPoint.entries.add(EntryPoint(
            x,
            fromY,
            toY,
            relation.yLabel,
            price,
          ));
        } else {
          maxMonthlyUsage = max(maxMonthlyUsage, usage);
          monthlyUsages.add(BarDataPoint(
            x,
            usage,
            [EntryPoint(x, 0, usage, relation.yLabel, price)],
          ));
        }
      }
    }

    monthlyUsages.sort((a, b) => a.x.compareTo(b.x));
  }

  void toggleCosts() async {
    showCosts = !showCosts;

    for (int i = 0; i < monthlyUsages.length; i++) {
      monthlyUsages[i].y /= 2;
    }

    isAnimatingCosts = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    setMonthlyUsage();
    isAnimatingCosts = false;

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

  void selectPoint(double xValue) {
    selectedPointIndex = xValue;
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
  List<EntryPoint> entries;

  BarDataPoint(
    this.x,
    this.y,
    this.entries, [
    this.isSelected = false,
  ]);
}

class EntryPoint {
  int x;
  double fromY;
  double toY;
  String label;
  Price price;

  EntryPoint(this.x, this.fromY, this.toY, this.label, this.price);
}

class ViewBarDataPoint extends BarChartRodData {
  final List<EntryPoint> entries;

  ViewBarDataPoint({
    required this.entries,
    required super.toY,
    super.rodStackItems,
    super.borderRadius,
    super.color,
    super.width,
    super.backDrawRodData,
    super.borderSide,
  });
}
