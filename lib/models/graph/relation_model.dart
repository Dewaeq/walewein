import 'package:walewein/models/graph/graph_node.dart';

class Relation {
  Relation({required this.nodes, required this.xLabel, required this.yLabel});

  List<GraphNode> nodes;
  String xLabel;
  String yLabel;
}
