import 'package:equations/equations.dart';
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
        throw Exception('Graph type not found!');
    }

    if (name != null) {
      graph.name = name;
    }

    return graph;
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
