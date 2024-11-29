import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:external_path/external_path.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/core/core/constant/app_constant.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/data/model/response_gendata_file.dart';
import 'package:ops_mobile/data/model/response_register_device.dart';
import 'package:ops_mobile/data/sqlite.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:ops_mobile/feature/login/login_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

class GetDataController extends BaseController{

  late var settingsData;
  late VoidCallback? action;
  final PathProviderAndroid providerAndroid = PathProviderAndroid();
  final PathProviderIOS providerIOS = PathProviderIOS();

  final PathProviderPlatform provider = PathProviderPlatform.instance;
  RxBool isLoading = false.obs;
  List<String> items = ['Internet','Penyimpanan'];
  RxString selectedValue = RxString('');
  TextEditingController dateTugas = TextEditingController();
  late PermissionStatus storagePermission;
  // String token = '';

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
    await generateFirebase();
    dateTugas.text = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    await readSettings();
    debugPrint('settings data: ${jsonEncode(settingsData)}');
    //storagePermission = await Permission.manageExternalStorage.status;
    update();
    Permission.storage.request();
    Permission.manageExternalStorage.request();
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

  Future<void> getGenData(String token,String apkVersion,String platform)async{
    try{
      var response = await repository.getGenData(settingsData['e_number'], token, apkVersion,platform);
      loadingProgressDialog();
        if(response.file != null){
          await createFileFromBase64Str(response.file!);
          await readZip();
          final data = await SqlHelper.getLogin(settingsData['e_number']);
          debugPrint('user data: $data');
          Get.back();
          openDialog('Success', 'Berhasil ambil data', (){Get.to<void>(LoginScreen());});
        } else {
          openDialog('Failed', 'Data gagal diambil',(){});
        }
    } catch(e) {
      openDialog('Failed', '$e', (){});
    }
  }

  void loadingProgressDialog() {
    Get.dialog(
        AlertDialog(
          title: Text(
            'Loading Get Data',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
          ),
          content: SizedBox(
            width: double.infinity,
            height: 84,
            child: Column(
              children: [
                SizedBox(
                    width: 84,
                    height: 84,
                    child: CircularProgressIndicator()
                ),
              ],
            ),
          ),
          actions: [],
        ),
        barrierDismissible: false
    );
  }

  Future<void> generateFirebase()async{
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.getToken().then((token) {
      token = token.toString();
      update();
      debugPrint('firebase_token ${token}');
    });
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
    final dir = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    bool exists = await Directory('$dir/ops').exists();

    if(exists == false){
      Directory('$dir/ops').create();
    }

    if(await File("$dir/ops").exists()){
      File("$dir/ops").delete();
      Directory('$dir/ops').create();
    }

    File file = File("$dir/ops/application.zip");
    await file.writeAsBytes(bytes, mode: FileMode.writeOnly);
    return file.path;
  }

  void openDialog(String type, String text, VoidCallback func) {
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
            onPressed: () {
              func;
              Get.back();
            },

          ),
        ],
      ),
    );
  }

  Future<void> readZip()async{
    // Get app directory
    var path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);

    debugPrint('path app : $path');

    // Read the Zip file from disk.
    final bytes = File('$path/ops/application.zip').readAsBytesSync();

// Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);

// Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File('$path/ops/' + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory('$path/ops/' + filename).create(recursive: true);
      }
      debugPrint('file extracted: $filename');
    }
  }
}