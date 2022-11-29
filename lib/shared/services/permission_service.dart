import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> storagePermission() async {
    final status = await Permission.storage.status;

    if (status.isGranted) {
      return true;
    }

    final request = await Permission.storage.request();
    if (request.isGranted) {
      return true;
    }

    return false;
  }
}
