import 'package:isar/isar.dart';
import 'package:walewein/models/graph/graph_model.dart';

class IsarService {
  late final Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<void> saveGraph(Graph graph) async {
    final isar = await db;
    await isar.writeTxn(() async => await isar.graphs.put(graph));
  }

  Future<void> removeGraph(Id id) async {
    final isar = await db;
    await isar.graphs.delete(id);
  }

  Future<void> removeAllGraphs() async {
    final isar = await db;
    await isar.writeTxn(() async => await isar.graphs.clear());
  }

  Future<Graph> getGraph(Id id) async {
    final isar = await db;
    final graph = await isar.graphs.get(id);

    if (graph == null) {
      throw Exception("Failed to get graph with id: $id");
    }

    return graph;
  }

  Future<List<Graph>> getAllGraphs() async {
    final isar = await db;
    return await isar.graphs.where().findAll();
  }

  Stream<Graph?> listenGraph(Id id) async* {
    final isar = await db;
    yield* isar.graphs.watchObject(id, fireImmediately: true);
  }

  Stream<List<Graph>> listenGraphs() async* {
    final isar = await db;
    yield* isar.graphs.where().watch(fireImmediately: true);
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([GraphSchema]);
    } else {
      return Future.value(Isar.getInstance());
    }
  }
}
