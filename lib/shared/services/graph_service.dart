import 'package:flutter/material.dart';
import 'package:walewein/shared/constants.dart';
import '../../models/data/graph_model.dart';
import '../../models/data/graph_node.dart';
import '../../models/data/relation_model.dart';

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

  static GraphNode? firstNode(Relation relation) {
    GraphNode? firstNode;

    if (relation.nodes.isNotEmpty) {
      for (final node in relation.nodes) {
        if (firstNode == null || node.x.isBefore(firstNode.x)) {
          firstNode = node;
        }
      }
    }

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

  /// Predicted increase per second
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

  static GraphNode? firstNodeV2(List<Relation> relations,
      [DateTime? afterDate]) {
    GraphNode? result;

    for (final relation in relations) {
      final query =
          relation.nodes.where((node) => node.x.isAfter(afterDate ?? minDate));
      if (query.isEmpty) continue;

      final node = query.first;
      if (result == null || node.x.isBefore(result.x)) {
        result = node;
      }
    }

    return result;
  }

  static GraphNode? lastNodeV2(List<Relation> relations) {
    GraphNode? result;

    for (final relation in relations) {
      if (relation.nodes.isEmpty) continue;

      final node = relation.nodes.last;
      if (result == null || node.x.isAfter(result.x)) {
        result = node;
      }
    }

    return result;
  }

  static GraphNode? maxNode(List<Relation> relations) {
    GraphNode? result;

    for (final relation in relations) {
      if (relation.nodes.isEmpty) continue;

      final node = relation.nodes.reduce((a, b) => a.y >= b.y ? a : b);
      if (result == null || node.y > result.y) {
        result = node;
      }
    }

    return result;
  }

  static GraphNode? minNode(List<Relation> relations) {
    GraphNode? result;

    for (final relation in relations) {
      if (relation.nodes.isEmpty) continue;

      final node = relation.nodes.reduce((a, b) => a.y <= b.y ? a : b);
      if (result == null || node.y < result.y) {
        result = node;
      }
    }

    return result;
  }

  static List<GraphNode> nodesAfter(List<GraphNode> nodes, DateTime afterDate) {
    return nodes.where((node) => node.x.isAfter(afterDate)).toList();
  }

  /// Get the first note that should be displayed
  static GraphNode? firstDisplayNode(Graph graph) {
    final threshold = DateTime.now().subtract(maxDisplayDateAgo);
    GraphNode? result;

    for (final relation in graph.relations) {
      final query = relation.nodes.where((node) => node.x.isAfter(threshold));
      if (query.isEmpty) continue;

      final node = query.first;
      if (result == null || result.x.isAfter(node.x)) {
        result = node;
      }
    }

    return result;
  }

  static DisplayDateSpread getDateSpread(Graph graph, [DateTime? maxDate]) {
    final firstDate = firstDisplayNode(graph)?.x;

    if (firstDate == null) {
      return DisplayDateSpread.year;
    }

    final lastDate = maxDate ?? maxX(graph).x;
    final diff = lastDate.difference(firstDate).inDays;

    return daysToDateSpread(diff);
  }

  static DisplayDateSpread daysToDateSpread(int days) {
    if (days > 95) {
      return DisplayDateSpread.year;
    } else if (days > 7) {
      return DisplayDateSpread.month;
    } else if (days > 1) {
      return DisplayDateSpread.week;
    }

    return DisplayDateSpread.day;
  }

  static double bottomTitleInterval(DisplayDateSpread dateSpread) {
    switch (dateSpread) {
      case DisplayDateSpread.day:
        return 1000 * 3600 / 2;
      case DisplayDateSpread.week:
        return 1000 * 3600 * 24;
      case DisplayDateSpread.month:
        return 1000 * 3600 * 24 * 5;
      case DisplayDateSpread.year:
        return 1000 * 3600 * 24 * 63;
    }
  }
}
