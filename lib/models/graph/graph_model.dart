import 'dart:ui';

import 'package:walewein/models/graph/graph_node.dart';
import 'package:walewein/models/graph/relation_model.dart';

class Graph {
  String name = "";
  List<Relation> relations = [];

  Graph(this.name, this.relations);

  Graph.gas({List<GraphNode> nodes = const []}) {
    name = "Gas";
    relations = [
      Relation(nodes: nodes, xLabel: "Datum", yLabel: "m^3"),
    ];
  }

  Graph.electricity({List<GraphNode> nodes = const []}) {
    name = "Elektriciteit";
    relations = [
      Relation(nodes: nodes, xLabel: "Datum", yLabel: "kWh"),
    ];
  }

  Graph.electricityDouble({
    List<GraphNode> dayNodes = const [],
    List<GraphNode> nightNodes = const [],
  }) {
    name = "Elektriciteit (dubbele meter)";
    relations = [
      Relation(nodes: dayNodes, xLabel: "Datum (overdag)", yLabel: "kWh"),
      Relation(nodes: nightNodes, xLabel: "Datum ('s nachts')", yLabel: "kWh"),
    ];
  }

  Relation? lastChangedRelation() {
    if (relations.isEmpty) {
      return null;
    }

    var lastDate = DateTime.fromMillisecondsSinceEpoch(0);
    Relation? result;

    for (final relation in relations) {
      if (relation.nodes.isEmpty) {
        continue;
      }

      if (relation.nodes.last.dateAdded.isAfter(lastDate)) {
        lastDate = relation.nodes.last.dateAdded;
        result = relation;
      }
    }

    return result;
  }

  String? headerValue() {
    var relation = lastChangedRelation();
    return relation?.nodes.last.y.toString();
  }

  lastChange() {
    var relation = lastChangedRelation();
    if (relation == null || relation.nodes.length < 2) {
      return null;
    }

    var last = relation.nodes.last;
    var previous = relation.nodes[relation.nodes.length - 2];
    var diff = last.y - previous.y;

    var result = diff.isNegative ? "-" : "+$diff";
    var color = diff.isNegative ? Color(0xfff7564c) : Color(0xff08bc50);

    return result;
  }
}
