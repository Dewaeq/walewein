import 'package:flutter/material.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/pages/graph/graph_page.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/shared/services/graph_service.dart';
import 'package:walewein/shared/services/storage_service.dart';

class AddGraphViewModel extends ViewModel {
  static const numPages = 3;

  AddGraphViewModel(super.context);

  final pageController = PageController();
  double page = 0;
  GraphType? selectedType;
  String? graphName;

  @override
  Future<void> init() async {
    pageController.addListener(() {
      page = pageController.page ?? 0;
      notifyListeners();
    });
  }

  @override
  void onDisMount() {
    pageController.dispose();
  }

  Future<bool> willPop() async {
    if (page >= 1) {
      goToPreviousPage();
      return false;
    } else {
      return true;
    }
  }

  void goToNextPage() {
    // Completed the last page, so we're done
    if (page == numPages - 1) {
      saveGraph();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.decelerate,
      );
    }
  }

  void goToPreviousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.decelerate,
    );
  }

  void saveGraph() {
    final graph = GraphService.graphFromType(selectedType!, graphName);
    final storage = StorageService();

    storage.saveGraph(graph).then((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => GraphPage(id: graph.id!)),
      );
    });
  }

  void onGraphType(GraphType type) {
    selectedType = type;
    graphName = GraphService.graphTypeToTitle(type);

    notifyListeners();
  }

  void onGraphName(String name) {
    if (name.isNotEmpty) {
      graphName = name.trim();
    } else {
      graphName = null;
    }

    notifyListeners();
  }

  bool completedType() {
    return selectedType != null;
  }

  bool completedName() {
    return graphName != null && graphName!.isNotEmpty;
  }

  bool isFinished() {
    return page == AddGraphViewModel.numPages - 1;
  }

  bool enableContinueButton() {
    return (page == 0 && completedType()) ||
        (page == 1 && completedName()) ||
        isFinished();
  }

  void Function()? onPressContinueButton() =>
      enableContinueButton() ? goToNextPage : null;

  Color continueButtonColor() {
    if (enableContinueButton()) {
      return const Color(0xff424ce4);
    } else {
      return const Color(0xff424ce4).withOpacity(0.6);
    }
  }
}
