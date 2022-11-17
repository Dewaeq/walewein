import 'package:isar/isar.dart';
import 'package:walewein/models/data/graph_node.dart';
import 'package:walewein/models/data/relation_model.dart';
import 'package:walewein/shared/services/graph_service.dart';

part 'graph_model.g.dart';

@collection
class Graph {
  Id? id;

  late String name = "";

  late List<Relation> relations = [];

  @enumerated
  late GraphType graphType;

  late DateTime dateCreated;

  Graph();

  Graph.gas({List<GraphNode> nodes = const []}) {
    name = "Gas";
    graphType = GraphType.gas;
    dateCreated = DateTime.now();
    relations = [
      Relation.from(
        nodes: nodes,
        xLabel: "Datum",
        yLabel: GraphService.unityType(graphType),
      ),
    ];
  }

  Graph.electricity({List<GraphNode> nodes = const []}) {
    name = "Elektriciteit";
    graphType = GraphType.electricity;
    dateCreated = DateTime.now();
    relations = [
      Relation.from(
        nodes: nodes,
        xLabel: "Datum",
        yLabel: GraphService.unityType(graphType),
      ),
    ];
  }

  Graph.electricityDouble({
    List<GraphNode> dayNodes = const [],
    List<GraphNode> nightNodes = const [],
  }) {
    name = "Elektriciteit (dubbele meter)";
    graphType = GraphType.electricityDouble;
    dateCreated = DateTime.now();
    relations = [
      Relation.from(
        nodes: dayNodes,
        xLabel: "Datum (overdag)",
        yLabel: '${GraphService.unityType(graphType)} (dag)',
      ),
      Relation.from(
        nodes: nightNodes,
        xLabel: "Datum ('s nachts')",
        yLabel: '${GraphService.unityType(graphType)} (nacht)',
      ),
    ];
  }

  Graph.water({List<GraphNode> nodes = const []}) {
    name = "Water";
    graphType = GraphType.water;
    dateCreated = DateTime.now();
    relations = [
      Relation.from(
        nodes: nodes,
        xLabel: "Datum",
        yLabel: GraphService.unityType(graphType),
      ),
    ];
  }

  Graph.firePlace({List<GraphNode> nodes = const []}) {
    name = "Fireplace";
    graphType = GraphType.firePlace;
    dateCreated = DateTime.now();
    relations = [
      Relation.from(
        nodes: nodes,
        xLabel: "Datum",
        yLabel: GraphService.unityType(graphType),
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
  custom,
}

enum DisplayDateSpread {
  day,
  week,
  month,
  year,
}
