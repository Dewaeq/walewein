import 'dart:async';
import 'package:flutter/material.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/pages/add_graph/add_graph_page.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/shared/services/isar_service.dart';

class HomeViewModel extends ViewModel<List<Graph>> {
  HomeViewModel(super.context);

  late List<Graph> graphs;
  late Map<Graph, bool> selectedGraphs;
  bool isSelecting = false;

  late final StreamSubscription<List<Graph>> _subscription;
  final isarService = IsarService();

  @override
  Future<void> init() async {
    final stream = isarService.listenGraphs();
    _subscription = stream.listen((event) {
      setState(event);
    });
  }

  @override
  void onDisMount() {
    _subscription.cancel();
  }

  @override
  void setState([model]) async {
    loaded = false;
    if (model == null) return;

    graphs = model;

    selectedGraphs = {};
    for (final graph in graphs) {
      selectedGraphs[graph] = false;
    }

    super.setState(model);
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
}
