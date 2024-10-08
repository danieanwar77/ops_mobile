import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

class GetDataController extends BaseController{

  final PathProviderPlatform provider = PathProviderPlatform.instance;
  RxBool isLoading = false.obs;
  List<String> items = ['Internet','Penyimpanan'];
  RxString selectedValue = RxString('');
  TextEditingController dateTugas = TextEditingController();
  late PermissionStatus storagePermission;

  @override
  void onInit()async{
    selectedValue.value = items.first;
    //storagePermission = await Permission.manageExternalStorage.status;
    update();
      Permission.storage.request();
      Permission.manageExternalStorage.request();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(Duration(days:1)),
        lastDate: DateTime(2101));
    if (picked != null) {
      dateTugas.text = DateFormat('yyyy-MM-dd').format(picked).toString();
      update();
    }
  }

  Future<String> get _localPath async {
    var current = await ExternalPath.getExternalStorageDirectories();

    return current.first ?? '';
  }

  void readZip()async{
    // Get app directory
    var path = await _localPath;

    debugPrint('path app : $path');

    // Read the Zip file from disk.
    final bytes = File('$path/Download/ops/IGSgForce.zip').readAsBytesSync();

// Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);

// Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File('$path/Download/ops/out/' + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory('$path/Download/ops/out/' + filename).create(recursive: true);
      }
      debugPrint('file extracted: $filename');
    }
  }
}