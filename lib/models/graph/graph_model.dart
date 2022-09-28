import 'package:walewein/models/graph/graph_node.dart';
import 'package:walewein/models/graph/relation_model.dart';

class GraphModel {
  GraphModel();
  GraphModel.fromRelations(this.relations);

  List<Relation> relations = [
    Relation<String, int>(
      nodes: [
        GraphNode(x: '5', y: 0),
        GraphNode(x: '5', y: 10),
      ],
    )
  ];
}
