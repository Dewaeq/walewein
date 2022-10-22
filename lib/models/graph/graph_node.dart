import 'package:isar/isar.dart';

part 'graph_node.g.dart';

@embedded
class GraphNode {
  late DateTime x;

  late double y;

  late DateTime dateAdded;

  GraphNode();

  GraphNode.from({
    required this.x,
    required this.y,
    DateTime? dateAdded,
  }) {
    this.dateAdded = dateAdded ?? DateTime.now();
  }

  @override
  String toString() {
    return "GraphNode { x: $x, y: $y, dateAddex: $dateAdded}";
  }
}
