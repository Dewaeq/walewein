import 'package:equations/equations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/models/data/graph_node.dart';
import 'package:walewein/models/data/relation_model.dart';

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
      case GraphType.firePlace:
        graph = Graph.firePlace();
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
      case GraphType.firePlace:
        return CupertinoIcons.flame_fill;
      default:
        return Icons.list_alt;
    }
  }

  static Color graphTypeToColor(GraphType graphType) {
    switch (graphType) {
      case GraphType.gas:
        return Colors.green;
      case GraphType.electricityDouble:
      case GraphType.electricity:
        return const Color(0xffff8c32);
      case GraphType.water:
        return const Color(0xff146beb);
      case GraphType.firePlace:
        return const Color(0xffcf1b04);
      default:
        return const Color(0xffaaaaaa);
    }
  }

  static Widget graphTypeToIcon(GraphType graphType, [double radius = 20]) {
    final color = graphTypeToColor(graphType);

    return CircleAvatar(
      radius: radius,
      backgroundColor: color.withOpacity(0.2),
      child: Icon(
        graphTypeToIconData(graphType),
        color: color,
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
      case GraphType.firePlace:
        return "Haardvuur";
      default:
        return "Custom";
    }
  }

  /// Predicted increase per second
  static double? trendPrediction(Relation relation) {
    if (relation.nodes.isEmpty) {
      return null;
    }

    final a = firstNode([relation])!;
    final b = lastNode([relation])!;

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

  static GraphNode? firstNode(List<Relation> relations, [DateTime? afterDate]) {
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

  static GraphNode? lastNode(List<Relation> relations) {
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

  static double interpolate(List<GraphNode> nodes, double x) {
    final data = nodes
        .map((e) => DataPoint((e.x.millisecondsSinceEpoch) / millisInDay, e.y))
        .toList();

    final interpolation = SplineInterpolation(
      nodes: data.map((e) => InterpolationNode(x: e.x, y: e.y)).toList(),
    );

    return interpolation.compute(x);
  }
}

class DataPoint {
  final double x;
  final double y;

  const DataPoint(this.x, this.y);
}
