import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:walewein/models/image_result.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/shared/extensions.dart';
import 'package:walewein/shared/services/image_processor.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/models/data/graph_node.dart';
import 'package:walewein/models/data/relation_model.dart';
import 'package:walewein/shared/services/graph_storage_service.dart';
import 'package:walewein/shared/utils.dart';

class AddEntryViewModel extends ViewModel {
  AddEntryViewModel(this.graph, super.context);

  final Graph graph;
  final imagePicker = ImagePicker();
  final bottomBarController = BottomBarWithSheetController(initialIndex: 0);
  final imageProcessor = ImageProcessor();

  Map<Relation, TextEditingController> controllers = {};
  ImageResult? imageResult;
  Relation? selectedRelation;
  DateTime date = DateTime.now();

  @override
  Future<void> init() async {
    for (final relation in graph.relations) {
      controllers[relation] = TextEditingController();
    }

    Future.delayed(const Duration(milliseconds: 400)).then((_) => openSheet());
  }

  @override
  void onDisMount() {
    for (final controller in controllers.values) {
      controller.dispose();
    }

    bottomBarController.close();
  }

  void getImage(int modeIndex) async {
    final source = modeIndex == 0 ? ImageSource.camera : ImageSource.gallery;
    final pickedFile = await imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      imageResult = await imageProcessor.processImage(pickedFile);

      notifyListeners();
    }
  }

  bool didReadImage() => imageResult != null;

  void selectText(String text) async {
    text = text.parse();
    closeSheet();

    if (graph.relations.length == 1) {
      controllers[graph.relations.first]?.text = text;
    } else if (selectedRelation != null) {
      controllers[selectedRelation]?.text = text;
    }

    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    openSheet();
  }

  void openSheet() {
    bottomBarController.openSheet();
  }

  void closeSheet() {
    bottomBarController.closeSheet();
  }

  void selectDateWithPicker() async {
    date = await pickDate(
      context: context,
      initialDate: DateTime.now(),
      defaultDate: DateTime.now(),
    );

    notifyListeners();
  }

  void selectRelation(Relation relation) {
    selectedRelation = relation;

    notifyListeners();
  }

  void onFieldSubmitted(String value, Relation relation) {
    controllers[relation]?.text = value.parse();

    // notifyListeners();
  }

  void save() async {
    for (final entry in controllers.entries) {
      final relation = entry.key;
      final value = entry.value.text.parse();

      if (value.isEmpty) continue;

      final node = GraphNode.from(
        x: date,
        y: double.parse(value),
      );

      await GraphStorageService.addNode(graph, relation, node);
    }

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
}
