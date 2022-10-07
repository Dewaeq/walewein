import 'package:flutter/material.dart';
import 'package:walewein/shared/services/isar_service.dart';

import '../../models/graph/graph_model.dart';
import '../../models/graph/graph_node.dart';
import '../../models/graph/relation_model.dart';

class GraphService {
  static Relation? lastChangedRelation(Graph graph) {
    final relations = graph.relations;
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

    return result ?? relations.first;
  }

  static Graph graphFromType(GraphType graphType, [String? name]) {
    Graph graph;
    switch (graphType) {
      case GraphType.gas:
        graph = Graph.gas();
        break;
      case GraphType.electricityDouble:
        graph = Graph.electricityDouble();
        break;
      case GraphType.electricity:
        graph = Graph.electricity();
        break;
      case GraphType.water:
        graph = Graph.water();
        break;
      default:
        throw Exception("Graph type not found!");
    }

    if (name != null) {
      graph.name = name;
    }

    return graph;
  }

  static IconData graphTypeToIconData(GraphType graphType) {
    switch (graphType) {
      case GraphType.gas:
        return Icons.gas_meter;
      case GraphType.electricityDouble:
      case GraphType.electricity:
        return Icons.electrical_services;
      case GraphType.water:
        return Icons.water;
      default:
        return Icons.list_alt;
    }
  }

  static Widget graphTypeToIcon(GraphType graphType, [double radius = 20]) {
    color() {
      switch (graphType) {
        case GraphType.gas:
          return Colors.green;
        case GraphType.electricityDouble:
        case GraphType.electricity:
          return const Color(0xffff8c32);
        case GraphType.water:
          return const Color(0xff146beb);
        default:
          return const Color(0xffaaaaaa);
      }
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: color().withOpacity(0.2),
      child: Icon(
        graphTypeToIconData(graphType),
        color: color(),
        size: radius * 1.2,
      ),
    );
  }

  static String graphTypeToTitle(GraphType? graphType) {
    switch (graphType) {
      case GraphType.gas:
        return "Gas";
      case GraphType.electricityDouble:
        return "Elektriciteit (dubbele meter)";
      case GraphType.electricity:
        return "Elektriciteit";
      case GraphType.water:
        return "Water";
      default:
        return "Custom";
    }
  }

  static Future<void> addNode(
      Graph graph, Relation relation, GraphNode node) async {
    relation.nodes = relation.nodes.toList();
    relation.nodes.add(node);

    final isarService = IsarService();
    await isarService.saveGraph(graph);
  }
}
