import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  static Future<void> requestPermission(Permission permission) async {
   bool granted = await permission.isGranted;
   if(!granted){
     final status = await permission.request();
     if(status == PermissionStatus.denied){
       exit(0);
     }
   }
  }
}