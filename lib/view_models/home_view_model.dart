import 'dart:async';
import 'package:flutter/material.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/pages/add_graph/add_graph_page.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/shared/services/isar_service.dart';

class HomeViewModel extends ViewModel<List<Graph>> {
  HomeViewModel(super.context);

  late List<Graph> graphs;

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
  void setState([model]) {
    loaded = false;
    if (model == null) return;

    graphs = model;

    super.setState(model);
  }

  void addGraph() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddGraphPage()),
    );
  }

  void editGraphs() {}
}
