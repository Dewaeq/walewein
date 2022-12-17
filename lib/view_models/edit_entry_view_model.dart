import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:walewein/models/data/graph_node.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/shared/extensions.dart';
import 'package:walewein/shared/utils.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/models/data/relation_model.dart';
import 'package:walewein/shared/services/graph_storage_service.dart';

class EditEntryViewModel extends ViewModel<GraphNode> {
  EditEntryViewModel(this.node, this.graph, BuildContext context)
      : super(context);

  final GraphNode node;
  final Graph graph;
  late final Relation relation;

  String title = '';
  final controller = TextEditingController();

  DateTime? date;

  @override
  Future<void> init() async {
    relation =
        graph.relations.firstWhere((relation) => relation.nodes.contains(node));

    setState();
  }

  @override
  void setState([model]) {
    loaded = false;

    title = relation.yLabel.tr();
    date = node.x;
    controller.text = node.y.toString();

    super.setState();
  }

  void onFieldSubmitted(String value) {
    controller.text = value.parse();
    notifyListeners();
  }

  void changeDate() async {
    final newDate = await pickDate(
      context: context,
      initialDate: date!,
      defaultDate: node.x,
    );

    final newTime = await pickTime(
      context: context,
      initialTime: TimeOfDay.fromDateTime(date!),
      defaultTime: TimeOfDay.fromDateTime(node.x),
    );

    date = DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      newTime.hour,
      newTime.minute,
    );

    notifyListeners();
  }

  void saveNode() async {
    await GraphStorageService.editNode(
      graph,
      node,
      value: controller.text.parse(),
      date: date ?? node.x,
    );

    notifyListeners();

    closeSheet();
  }

  void deleteNode() async {
    await GraphStorageService.removeNode(graph, relation, node);

    notifyListeners();

    closeSheet();
  }

  void closeSheet() {
    Navigator.of(context).pop();
  }
}
