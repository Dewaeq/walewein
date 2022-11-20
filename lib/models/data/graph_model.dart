import 'package:isar/isar.dart';
import 'package:walewein/models/data/graph_node.dart';
import 'package:walewein/models/data/relation_model.dart';

part 'graph_model.g.dart';

@collection
class Graph {
  Id? id;

  /// Override the default name
  String? name;

  List<Relation> relations = [];

  @enumerated
  late GraphType graphType;

  late DateTime dateCreated;

  Graph();

  Graph.gas({List<GraphNode> nodes = const []}) {
    graphType = GraphType.gas;
    dateCreated = DateTime.now();
    relations = [
      Relation.from(
        nodes: nodes,
        xLabel: 'general.date',
        yLabel: 'yLabels.gas',
      ),
    ];
  }

  Graph.electricity({List<GraphNode> nodes = const []}) {
    graphType = GraphType.electricity;
    dateCreated = DateTime.now();
    relations = [
      Relation.from(
        nodes: nodes,
        xLabel: 'general.date',
        yLabel: 'yLabels.electricity',
      ),
    ];
  }

  /// **IMPORTANT**
  ///
  /// First relation should always be daytime usage and the second nighttime
  Graph.electricityDouble({
    List<GraphNode> dayNodes = const [],
    List<GraphNode> nightNodes = const [],
  }) {
    graphType = GraphType.electricityDouble;
    dateCreated = DateTime.now();
    relations = [
      Relation.from(
        nodes: dayNodes,
        xLabel: 'xLabels.electricityDay',
        yLabel: 'yLabels.electricityDay',
      ),
      Relation.from(
        nodes: nightNodes,
        xLabel: 'xLabels.electricityNight',
        yLabel: 'yLabels.electricityNight',
      ),
    ];
  }

  Graph.water({List<GraphNode> nodes = const []}) {
    graphType = GraphType.water;
    dateCreated = DateTime.now();
    relations = [
      Relation.from(
        nodes: nodes,
        xLabel: 'general.date',
        yLabel: 'yLabels.water',
      ),
    ];
  }

  Graph.firePlace({List<GraphNode> nodes = const []}) {
    graphType = GraphType.firePlace;
    dateCreated = DateTime.now();
    relations = [
      Relation.from(
        nodes: nodes,
        xLabel: 'general.date',
        yLabel: 'yLabels.firePlace',
      ),
    ];
  }
}

enum GraphType {
  gas,
  electricity,
  electricityDouble,
  water,
  firePlace,
}

enum RelationXLabel {
  date,
  dateDay,
  dateNight,
}

enum RelationYLabel {
  gas,
  water,
  firePlace,
  electricity,
  electricityDouble,
}

enum DisplayDateSpread {
  day,
  week,
  month,
  year,
}
