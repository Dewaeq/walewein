import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/models/data/graph_node.dart';
import 'package:walewein/models/data/relation_model.dart';
import 'package:walewein/shared/services/storage_service.dart';

class GraphStorageService {
  static Future<void> addNode(
      Graph graph, Relation relation, GraphNode node) async {
    relation.nodes = relation.nodes.toList();
    relation.nodes.add(node);

    sortNodes(graph);

    final storage = StorageService();
    await storage.saveGraph(graph);
  }

  static Future<void> editNode(
    Graph graph,
    GraphNode node, {
    String? value,
    DateTime? date,
  }) async {
    node.dateAdded = DateTime.now();

    if (value != null) {
      node.y = double.parse(value);
    }
    if (date != null) {
      node.x = date;
    }

    sortNodes(graph);

    final storage = StorageService();
    await storage.saveGraph(graph);
  }

  static Future<void> removeNode(
    Graph graph,
    Relation relation,
    GraphNode node,
  ) async {
    relation.nodes = relation.nodes.toList();
    relation.nodes.remove(node);

    sortNodes(graph);

    final storage = StorageService();
    await storage.saveGraph(graph);
  }

  static void sortNodes(Graph graph) {
    for (final relation in graph.relations) {
      relation.nodes.sort((a, b) => a.x.compareTo(b.x));
    }
  }
}
