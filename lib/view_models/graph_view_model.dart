import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:walewein/models/data/graph_node.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/shared/services/isar_service.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/pages/graph/components/edit_entry_modal.dart';

class GraphViewModel extends ViewModel<Graph> {
  GraphViewModel(this.id, BuildContext context) : super(context);

  final Id id;
  String title = "";
  late Graph graph;
  final controller = PageController();

  late final StreamSubscription<Graph?> _subscription;
  final isarService = IsarService();

  @override
  Future<void> init() async {
    final stream = isarService.listenGraph(id.toInt());
    _subscription = stream.listen((event) {
      if (event == null) {
        return;
      }
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

    graph = model;
    title = model.name;

    super.setState();
  }

  void onNodePressed(GraphNode node) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) => EditEntryModal(
        node: node,
        graph: graph,
      ),
    );
  }

  void goToPage(int index) {
    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}
