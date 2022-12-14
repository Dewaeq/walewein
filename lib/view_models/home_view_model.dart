import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/models/data/price_model.dart';
import 'package:walewein/pages/add_graph/add_graph_page.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/shared/services/graph_service.dart';
import 'package:walewein/shared/services/localization_service.dart';
import 'package:walewein/shared/services/storage_service.dart';

class HomeViewModel extends ViewModel<List<Graph>> {
  HomeViewModel(super.context);

  List<Graph> graphs = [];
  Map<Graph, bool> selectedGraphs = {};
  List<Price> prices = [];
  bool isEditing = false;

  /// Generate a new key everytime [graph] changes, to update the charts
  late List<Key> chartViewKeys;

  late final StreamSubscription<List<Graph>> _graphSubscription;
  late final StreamSubscription<List<Price>> _priceSubscription;
  final storage = StorageService();

  @override
  Future<void> init() async {
    final graphSream = storage.listenGraphs();
    final priceStream = storage.listenPrices(false);

    prices = await storage.getAllPrices();

    final locale = context.locale.toLanguageTag();
    await LocalizationService.setDateLocale(locale);

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

    final numKeys = graphs.length;
    chartViewKeys = List.generate(numKeys, (_) => UniqueKey());

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

  void toggleEditing() {
    isEditing = !isEditing;
    selectedGraphs = selectedGraphs.map((key, value) => MapEntry(key, false));

    notifyListeners();
  }

  void select(Graph graph) {
    isEditing = true;
    selectedGraphs[graph] = !selectedGraphs[graph]!;

    if (selectedGraphs.entries.every((x) => !x.value)) {
      isEditing = false;
      selectedGraphs = selectedGraphs.map((key, value) => MapEntry(key, false));
    }

    notifyListeners();
  }

  Future<void> deleteSelectedGraphs() async {
    for (final entry in selectedGraphs.entries) {
      if (!entry.value) continue;

      await storage.removeGraph(entry.key.id!);
    }

    isEditing = false;
    notifyListeners();
  }

  int graphPrice(Graph graph) {
    int result = 0;

    final now = DateTime.now();
    final currentVal = now.millisecondsSinceEpoch / millisInDay;
    final startVal =
        DateTime(now.year, now.month, 1).millisecondsSinceEpoch / millisInDay;
    final price = prices.firstWhere((e) => e.graphType == graph.graphType);

    for (int i = 0; i < graph.relations.length; i++) {
      final relation = graph.relations[i];
      if (relation.nodes.length < 2) continue;

      final currentUsage = GraphService.interpolate(relation.nodes, currentVal);
      final startUsage = GraphService.interpolate(relation.nodes, startVal);
      final usage = (currentUsage - startUsage).roundToDouble();

      if (i == 0 && graph.graphType == GraphType.electricityDouble) {
        final dayPrice =
            prices.firstWhere((e) => e.graphType == GraphType.electricity);
        result += (usage * dayPrice.price).round();
      } else {
        result += (usage * price.price).round();
      }
    }

    return result;
  }

  Future<bool> willPop() async {
    if (isEditing) {
      toggleEditing();
      return false;
    }

    return true;
  }
}
