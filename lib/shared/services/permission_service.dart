import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> storagePermission() async {
    return await checkPermission(Permission.storage);
  }

  static Future<bool> checkPermission(Permission permission) async {
    final status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    final request = await permission.request();
    if (request.isGranted) {
      return true;
    }

    return false;
  }
}
