import 'package:isar/isar.dart';
import 'package:walewein/models/graph/graph_node.dart';

part 'relation_model.g.dart';

@embedded
class Relation {
  late List<GraphNode> nodes;

  late String xLabel;

  late String yLabel;

  Relation();

  Relation.from({
    required this.nodes,
    required this.xLabel,
    required this.yLabel,
  });
}
