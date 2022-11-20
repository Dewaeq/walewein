import 'package:easy_localization/easy_localization.dart';
import 'package:isar/isar.dart';
import 'package:walewein/models/data/graph_node.dart';
import 'package:walewein/models/data/relation_model.dart';
import 'package:walewein/shared/utils.dart';

part 'graph_model.g.dart';

@collection
class Graph {
  Id? id;

  /// Override the default name
  String? name;

  List<Relation> relations = [];

  @enumerated
  late GraphType graphType;

  late DateTime dateCreated;

  Graph();

  Graph.gas({List<GraphNode> nodes = const []}) {
    graphType = GraphType.gas;
    dateCreated = DateTime.now();
    relations = [
      Relation.from(
        nodes: nodes,
        xLabel: 'general.date'.tr(),
        yLabel: unityTypeToString(graphType),
      ),
    ];
  }

  Graph.electricity({List<GraphNode> nodes = const []}) {
    graphType = GraphType.electricity;
    dateCreated = DateTime.now();
    relations = [
      Relation.from(
        nodes: nodes,
        xLabel: 'general.date'.tr(),
        yLabel: unityTypeToString(graphType),
      ),
    ];
  }

  Graph.electricityDouble({
    List<GraphNode> dayNodes = const [],
    List<GraphNode> nightNodes = const [],
  }) {
    graphType = GraphType.electricityDouble;
    dateCreated = DateTime.now();
    relations = [
      Relation.from(
        nodes: dayNodes,
        xLabel: '${'general.date'.tr()} (${'general.day'.tr()})',
        yLabel: '${unityTypeToString(graphType)} (${'general.day'.tr()})',
      ),
      Relation.from(
        nodes: nightNodes,
        xLabel: '${'general.date'.tr()} (${'general.night'.tr()})',
        yLabel: '${unityTypeToString(graphType)} (${'general.night'.tr()})',
      ),
    ];
  }

  Graph.water({List<GraphNode> nodes = const []}) {
    graphType = GraphType.water;
    dateCreated = DateTime.now();
    relations = [
      Relation.from(
        nodes: nodes,
        xLabel: 'general.date'.tr(),
        yLabel: unityTypeToString(graphType),
      ),
    ];
  }

  Graph.firePlace({List<GraphNode> nodes = const []}) {
    graphType = GraphType.firePlace;
    dateCreated = DateTime.now();
    relations = [
      Relation.from(
        nodes: nodes,
        xLabel: 'general.date'.tr(),
        yLabel: unityTypeToString(graphType),
      ),
    ];
  }
}

enum GraphType {
  gas,
  electricity,
  electricityDouble,
  water,
  firePlace,
}

enum DisplayDateSpread {
  day,
  week,
  month,
  year,
}
