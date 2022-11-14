import 'package:flutter/cupertino.dart';
import 'package:walewein/models/data/graph_node.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
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

  String title = "";
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

    title = relation.yLabel;
    date = node.x;
    controller.text = node.y.toString();

    super.setState();
  }

  void onFieldSubmitted(String value) {
    controller.text = value.parse();
    notifyListeners();
  }

  void selectDateWithPicker() async {
    date = await pickDate(
      context: context,
      initialDate: date!,
      defaultDate: node.x,
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
