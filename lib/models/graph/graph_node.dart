import 'package:isar/isar.dart';

part 'graph_node.g.dart';

@embedded
class GraphNode {
  late final DateTime x;

  late final double y;

  late final DateTime dateAdded;

  GraphNode();

  GraphNode.from({
    required this.x,
    required this.y,
    DateTime? dateAdded,
  }) {
    this.dateAdded = dateAdded ?? DateTime.now();
  }
}
