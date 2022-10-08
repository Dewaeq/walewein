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

  static GraphNode? firstNode(Relation relation) {
    GraphNode? firstNode;
    // for (final relation in graph.relations) {
    if (relation.nodes.isNotEmpty) {
      for (final node in relation.nodes) {
        if (firstNode == null || node.x.isBefore(firstNode.x)) {
          firstNode = node;
        }
      }
    }
    // }

    return firstNode;
  }

  static GraphNode? lastNode(Relation relation) {
    GraphNode? lastNode;
    // for (final relation in graph.relations) {
    if (relation.nodes.isNotEmpty) {
      for (final node in relation.nodes) {
        if (lastNode == null || node.x.isAfter(lastNode.x)) {
          lastNode = node;
        }
      }
    }
    // }

    return lastNode;
  }

  static double? trendPrediction(Relation relation) {
    if (relation.nodes.isEmpty) {
      return null;
    }

    final a = firstNode(relation)!;
    final b = lastNode(relation)!;

    if (a == b) {
      return 0;
    }

    return (b.y - a.y) /
        (b.x.millisecondsSinceEpoch - a.x.millisecondsSinceEpoch) *
        1000;
  }

  static GraphNode? relationMinY(Relation relation) {
    if (relation.nodes.isEmpty) {
      return null;
    }

    return relation.nodes.reduce((a, b) => a.y <= b.y ? a : b);
  }

  static GraphNode? maxY(Graph graph) {
    GraphNode? result;

    for (final relation in graph.relations) {
      if (relation.nodes.isEmpty) continue;

      final node = relation.nodes.reduce((a, b) => a.y >= b.y ? a : b);
      if (result == null || node.y > result.y) {
        result = node;
      }
    }

    return result;
  }

  static GraphNode? minY(Graph graph) {
    GraphNode? result;

    for (final relation in graph.relations) {
      if (relation.nodes.isEmpty) continue;

      final node = relationMinY(relation)!;
      if (result == null || node.y < result.y) {
        result = node;
      }
    }

    return result;
  }

  static GraphNode maxX(Graph graph) {
    final relation = graph.relations
        .where((x) => x.nodes.isNotEmpty)
        .reduce((a, b) => a.nodes.last.x.isAfter(b.nodes.last.x) ? a : b);

    return relation.nodes.last;
  }

  static GraphNode minX(Graph graph) {
    final relation = graph.relations
        .where((x) => x.nodes.isNotEmpty)
        .reduce((a, b) => a.nodes.first.x.isBefore(b.nodes.first.x) ? a : b);

    return relation.nodes.first;
  }
}
