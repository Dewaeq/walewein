import 'package:walewein/models/graph/graph_node.dart';

class Relation<X, Y> {
  Relation({required this.nodes});

  List<GraphNode<X, Y>> nodes;
}
