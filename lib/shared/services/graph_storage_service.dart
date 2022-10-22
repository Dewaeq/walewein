import '../../models/graph/graph_model.dart';
import '../../models/graph/graph_node.dart';
import '../../models/graph/relation_model.dart';
import 'isar_service.dart';

class GraphStorageService {
  static Future<void> addNode(
      Graph graph, Relation relation, GraphNode node) async {
    relation.nodes = relation.nodes.toList();
    relation.nodes.add(node);

    sortNodes(graph);

    final isarService = IsarService();
    await isarService.saveGraph(graph);
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

    final isar = IsarService();
    await isar.saveGraph(graph);
  }

  static Future<void> removeNode(
    Graph graph,
    Relation relation,
    GraphNode node,
  ) async {
    relation.nodes = relation.nodes.toList();
    relation.nodes.remove(node);

    sortNodes(graph);

    final isarService = IsarService();
    await isarService.saveGraph(graph);
  }

  static void sortNodes(Graph graph) {
    for (final relation in graph.relations) {
      relation.nodes.sort((a, b) => a.x.compareTo(b.x));
    }
  }
}
