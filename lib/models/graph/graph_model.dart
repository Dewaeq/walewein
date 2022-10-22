import 'package:isar/isar.dart';
import 'package:walewein/models/graph/graph_node.dart';
import 'package:walewein/models/graph/relation_model.dart';

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
      Relation.from(nodes: nodes, xLabel: "Datum", yLabel: "m^3"),
    ];
  }

  Graph.electricity({List<GraphNode> nodes = const []}) {
    name = "Elektriciteit";
    graphType = GraphType.electricity;
    dateCreated = DateTime.now();
    relations = [
      Relation.from(nodes: nodes, xLabel: "Datum", yLabel: "kWh"),
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
          nodes: dayNodes, xLabel: "Datum (overdag)", yLabel: "kWh (dag)"),
      Relation.from(
          nodes: nightNodes,
          xLabel: "Datum ('s nachts')",
          yLabel: "kWh (nacht)"),
    ];
  }

  Graph.water({List<GraphNode> nodes = const []}) {
    name = "Water";
    graphType = GraphType.water;
    dateCreated = DateTime.now();
    relations = [
      Relation.from(nodes: nodes, xLabel: "Datum", yLabel: "m^3"),
    ];
  }
}

enum GraphType {
  gas,
  electricity,
  electricityDouble,
  water,
  custom,
}

enum DisplayDateSpread {
  day,
  week,
  month,
  year,
}
