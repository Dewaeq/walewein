import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:isar/isar.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/models/data/price_model.dart';
import 'package:walewein/shared/services/file_service.dart';
import 'package:walewein/shared/services/permission_service.dart';

class StorageService {
  late final Future<Isar> db;

  StorageService() {
    db = openDB();
  }

  Future<void> saveGraph(Graph graph) async {
    final isar = await db;
    await isar.writeTxn(() async => await isar.graphs.put(graph));
  }

  Future<void> removeGraph(Id id) async {
    final isar = await db;
    await isar.writeTxn(() async => await isar.graphs.delete(id));
  }

  Future<void> removeAllGraphs() async {
    final isar = await db;
    await isar.writeTxn(() async => await isar.graphs.clear());
  }

  Future<Graph> getGraph(Id id) async {
    final isar = await db;
    final graph = await isar.graphs.get(id);

    if (graph == null) {
      throw Exception('Failed to get graph with id: $id');
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

  Future<void> initPrices() async {
    for (final entry in defaultPrices.entries) {
      final price = await getPrice(entry.key);
      if (price != null) continue;

      await savePrice(entry.value);
    }
  }

  Future<void> savePrice(Price price) async {
    final isar = await db;
    await isar.writeTxn(() async => await isar.prices.put(price));
  }

  Future<Price?> getPrice(GraphType type) async {
    final isar = await db;

    final price = await isar.prices.filter().graphTypeEqualTo(type).findFirst();

    return price;
  }

  Future<List<Price>> getAllPrices() async {
    final isar = await db;
    return await isar.prices.where().findAll();
  }

  Stream<List<Price>> listenPrices([bool fireImmediately = true]) async* {
    final isar = await db;
    yield* isar.prices.where().watch(fireImmediately: fireImmediately);
  }

  Future<String> _createBackupPath() async {
    final now = DateTime.now();
    final fileName =
        'walewein_backup_${DateFormat('yyyy-MM-dd_HH:mm').format(now)}.wbak';
    final dir = Directory('/storage/emulated/0/Download/walewein');

    if (!await dir.exists()) {
      await dir.create();
    }

    return '${dir.path}/$fileName';
  }

  Future<void> saveBackup({
    required Function() onSucces,
    required Function() onError,
  }) async {
    final permission = await PermissionService.storagePermission();
    if (!permission) {
      onError();
      return;
    }

    final isar = await db;
    final savePath = await _createBackupPath();

    try {
      if (await File(savePath).exists()) {
        // Delete the previous backup
        await File(savePath).delete();
      }

      await isar.writeTxn(() async => await isar.copyToFile(savePath));
      onSucces();
    } catch (e) {
      onError();
    }
  }

  Future<void> loadBackup({
    required Function() onSucces,
    required Function() onError,
  }) async {
    final file = await FileService.pickFile();

    if (file == null) return;
    if (!file.path.endsWith('.wbak')) return onError();

    final isar = await db;
    final dir = isar.directory!;

    try {
      await File('$dir/default.isar.lock').delete();
      await FileService.writeFile(file, dir, 'default.isar');
      onSucces();
    } catch (e) {
      onError();
    }
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([GraphSchema, PriceSchema]);
    } else {
      return Future.value(Isar.getInstance());
    }
  }
}
