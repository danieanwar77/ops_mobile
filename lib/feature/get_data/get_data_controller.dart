import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/core/core/constant/app_constant.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/data/model/response_gendata_file.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

class GetDataController extends BaseController{

  late var settingsData;
  final PathProviderAndroid providerAndroid = PathProviderAndroid();
  final PathProviderIOS providerIOS = PathProviderIOS();

  final PathProviderPlatform provider = PathProviderPlatform.instance;
  RxBool isLoading = false.obs;
  List<String> items = ['Internet','Penyimpanan'];
  RxString selectedValue = RxString('');
  TextEditingController dateTugas = TextEditingController();
  late PermissionStatus storagePermission;

  @override
  void onInit()async{
    selectedValue.value = items.first;
    var setting = await readSettings();
    if(setting == ''){
      settingsData = StorageCore().storage.read('settings') ?? '';
      update();
      if(settingsData != ''){
        AppConstant.BASE_URL = settingsData['internet_url'];
        update();
        network.setBaseUrl(AppConstant.BASE_URL);
      }
    }else{
      AppConstant.BASE_URL = settingsData['internet_url'];
      update();
      network.setBaseUrl(AppConstant.BASE_URL);
    }

    dateTugas.text = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    await readSettings();
    debugPrint('settings data: ${jsonEncode(settingsData)}');
    //storagePermission = await Permission.manageExternalStorage.status;
    update();
      Permission.storage.request();
      // Permission.manageExternalStorage.request();
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

  Future<void> getGenData()async{
    try{
      var response = await repository.getGenData(settingsData['employee']);
        if(response.file != null){
          await createFileFromBase64Str(response.file!);
          readZip();
          openDialog('Success', 'Berhasil ambil data');
        } else {
          openDialog('Failed', 'Data gagal diambil');
        }
    } catch(e) {
      openDialog('Failed', 'Data gagal diambil');
    }
  }

  Future<String> readSettings() async {
    String text;
    try {
      final directory = await providerAndroid.getApplicationDocumentsPath();
      final File file = File('${directory}/settings.txt');
      text = await file.readAsString();
      settingsData = jsonDecode(text);
      update();
      debugPrint('setting txt: ${jsonDecode(text)}');
    } catch (e) {
      print("Couldn't read file");
      text = '';
    }
    return text;
  }

  Future<String> createFileFromBase64Str(String code) async {
    final encodedStr = code;
    Uint8List bytes = base64.decode(encodedStr);
    final dir = await providerAndroid.getApplicationDocumentsPath();
    File file = File(
        "$dir/application.zip");
    await file.writeAsBytes(bytes);
    return file.path;
  }

  void openDialog(String type, String text) {
    Get.dialog(
      AlertDialog(
        title: Text(
          type,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text(text),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  void readZip()async{
    // Get app directory
    var path = await providerAndroid.getApplicationDocumentsPath();

    debugPrint('path app : $path');

    // Read the Zip file from disk.
    final bytes = File('$path/application.zip').readAsBytesSync();

// Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);

// Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File('$path/ops/out/' + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory('$path/ops/out/' + filename).create(recursive: true);
      }
      debugPrint('file extracted: $filename');
    }
  }
}