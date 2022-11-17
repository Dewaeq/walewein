import 'dart:async';
import 'package:flutter/material.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/models/data/price_model.dart';
import 'package:walewein/pages/add_graph/add_graph_page.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/shared/services/graph_service.dart';
import 'package:walewein/shared/services/isar_service.dart';

class HomeViewModel extends ViewModel<List<Graph>> {
  HomeViewModel(super.context);

  List<Graph> graphs = [];
  Map<Graph, bool> selectedGraphs = {};
  List<Price> prices = [];
  bool isSelecting = false;

  late final StreamSubscription<List<Graph>> _graphSubscription;
  late final StreamSubscription<List<Price>> _priceSubscription;
  final isarService = IsarService();

  @override
  Future<void> init() async {
    final graphSream = isarService.listenGraphs();
    final priceStream = isarService.listenPrices(false);

    prices = await isarService.getAllPrices();

    _graphSubscription = graphSream.listen((event) => setState(event));
    _priceSubscription = priceStream.listen((event) => setPrices(event));
  }

  @override
  void onDisMount() {
    _graphSubscription.cancel();
    _priceSubscription.cancel();
  }

  @override
  void setState([model]) async {
    loaded = false;
    if (model == null || prices.isEmpty) return;

    graphs = model;

    selectedGraphs = {};
    for (final graph in graphs) {
      selectedGraphs[graph] = false;
    }

    super.setState(model);
  }

  void setPrices(List<Price> newPrices) {
    prices = newPrices;

    notifyListeners();
  }

  void addGraph() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddGraphPage()),
    );
  }

  void editGraphs() {
    isSelecting = !isSelecting;
    selectedGraphs = selectedGraphs.map((key, value) => MapEntry(key, false));

    notifyListeners();
  }

  void select(Graph graph) {
    isSelecting = true;
    selectedGraphs[graph] = !selectedGraphs[graph]!;

    if (selectedGraphs.entries.every((x) => !x.value)) {
      isSelecting = false;
      selectedGraphs = selectedGraphs.map((key, value) => MapEntry(key, false));
    }

    notifyListeners();
  }

  Future<void> deleteSelectedGraphs() async {
    for (final entry in selectedGraphs.entries) {
      if (!entry.value) continue;

      await isarService.removeGraph(entry.key.id!);
    }

    isSelecting = false;
    notifyListeners();
  }

  int graphPrice(Graph graph) {
    int result = 0;

    final now = DateTime.now();
    final currentVal = now.millisecondsSinceEpoch / millisInDay;
    final startVal =
        DateTime(now.year, now.month, 1).millisecondsSinceEpoch / millisInDay;
    final price = prices.firstWhere((e) => e.graphType == graph.graphType);

    for (final relation in graph.relations) {
      if (relation.nodes.length < 2) continue;

      final currentUsage = GraphService.interpolate(relation.nodes, currentVal);

      final startUsage = GraphService.interpolate(relation.nodes, startVal);

      result += ((currentUsage - startUsage) * price.price).round();
    }

    return result;
  }
}
