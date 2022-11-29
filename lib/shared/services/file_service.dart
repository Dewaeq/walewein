import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FileService {
  static Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      return File(result.files.single.path!);
    }

    return null;
  }

  static Future<void> writeFile(
    File file,
    String path,
    String name, [
    bool delete = true,
  ]) async {
    final saveDir = '$path/$name';
    final target = File(saveDir);

    if (!await target.exists()) {
      await target.create();
    }

    final bytes = await file.readAsBytes();
    await target.writeAsBytes(bytes);
  }
}
