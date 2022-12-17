import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:walewein/shared/services/file_service.dart';
import 'package:walewein/shared/services/permission_service.dart';
import 'package:walewein/shared/services/storage_service.dart';

class BackupService {
  static final db = StorageService().db;

  static Future<String> _createBackupPath() async {
    final now = DateTime.now();
    final fileName =
        'backup_${DateFormat('yyyy-MM-dd_HH:mm').format(now)}.wbak';
    final dir = await getTemporaryDirectory();

    return '${dir.path}/$fileName';
  }

  static Future<void> saveBackup({
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

      final params = SaveFileDialogParams(sourceFilePath: savePath);
      await FlutterFileDialog.saveFile(params: params);

      // Delete the temporary file
      await File(savePath).delete();

      onSucces();
    } catch (e) {
      onError();
    }
  }

  static Future<void> loadBackup({
    required Function() onSucces,
    required Function() onError,
  }) async {
    final file = await FileService.pickFile();

    if (file == null) return;
    if (!file.path.endsWith('.wbak')) return onError();

    final isar = await db;
    final dir = isar.directory!;

    final lockFile = File('$dir/default.isar.lock');

    try {
      if (await lockFile.exists()) {
        await lockFile.delete();
      }

      await FileService.writeFile(file, dir, 'default.isar');
      onSucces();
    } catch (e) {
      onError();
    }
  }
}
