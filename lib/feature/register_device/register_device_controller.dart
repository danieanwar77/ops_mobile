import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/core/core/constant/app_constant.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/data/model/response_register_device.dart';
import 'package:ops_mobile/data/network.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:ops_mobile/feature/settings/settings_screen.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';

class RegisterDeviceController extends BaseController{

  late var settingsData;
  var urlController = Get.put(AppConstant());
  final NetworkCore network = Get.find<NetworkCore>();
  final PathProviderAndroid providerAndroid = PathProviderAndroid();
  final PathProviderIOS providerIOS = PathProviderIOS();

  RxBool isLoading = false.obs;
  TextEditingController employeeIdText = TextEditingController();
  TextEditingController internetUrlText = TextEditingController();
  TextEditingController localUrlText = TextEditingController();


  @override
  void onInit()async{
    settingsData = StorageCore().storage.read('settings') ?? '';
    await readSettings();
    update();
    debugPrint('settings data: ${jsonEncode(settingsData)}');
  }

  void registerConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text(
            'Apakah benar anda akan registrasi data perangkat ini? pastikan data yg anda input sudah benar.'),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text(
              "OK",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              Get.back();
              sendRegisterDevice();
            },
          ),
        ],
      ),
    );
  }

  void sendRegisterDevice()async{
    var rng = new Random();
    var left = rng.nextInt(90000) + 10000;
    var middle = rng.nextInt(90000000) + 10000000;
    var right = rng.nextInt(900000) + 100000;
    var uuid = '$left-$middle-$right';

    AppConstant.BASE_URL = internetUrlText.text;
    update();
    network.setBaseUrl(AppConstant.BASE_URL);
    debugPrint('base url:${AppConstant.BASE_URL}');
    isLoading.value = true;
    try{
      var response = await repository.registerDevice(employeeIdText.text, uuid) ?? ResponseRegisterDevice();
      isLoading.value = false;
      update();
      if(response.code == 200 && response.message == 'Registrasi Device Berhasil'){
        var setting = {
          'internet_url' : internetUrlText.text,
          'local_url' : localUrlText.text,
          'uuid' : uuid,
          'e_number' : employeeIdText.text
        };
        await StorageCore().storage.write('settings', setting);
        await writeSettings(jsonEncode(setting));
        Get.back();
        openDialog('Success', 'Berhasil register perangkat',(){Get.to<void>(SettingsScreen());});
      }else{
        openDialog('Success', response.message ?? 'Register perangkat gagal',(){});
      }
    } catch(e){
      openDialog('Failed', 'Register perangkat gagal: $e',(){});
      isLoading.value = false;
      update();
    }
  }

  void loadingProgressDialog() {
    // Get.dialog(
    //   AlertDialog(
    //     title: Text(
    //       'Loading Register',
    //       style: TextStyle(
    //           fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
    //     ),
    //     content: SizedBox(
    //       width: double.infinity,
    //       height: 84,
    //       child: Column(
    //         children: [
    //           SizedBox(
    //               width: 84,
    //               height: 84,
    //               child: CircularProgressIndicator()
    //           ),
    //         ],
    //       ),
    //     ),
    //     actions: [],
    //   ),
    //   barrierDismissible: false
    // );
  }

  Future<void> writeSettings(String text) async {
    final directory = await providerAndroid.getApplicationDocumentsPath();
    final File file = File('$directory/settings.txt');
    await file.writeAsString(text);
  }

  Future<String> readSettings() async {
    String text;
    try {
      final directory = await providerAndroid.getApplicationDocumentsPath();
      final File file = File('${directory}/settings.txt');
      text = await file.readAsString();
      debugPrint('setting txt: ${jsonDecode(text)}');
      var data = jsonDecode(text);
      employeeIdText.text = data['e_number'];
      internetUrlText.text = data['internet_url'];
      localUrlText.text = data['local_url'];
      update();
    } catch (e) {
      print("Couldn't read file");
      text = '';
    }
    return text;
  }

  void openDialog(String type, String text,VoidCallback func) {
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
              Get.back();
              Future.delayed(Duration(milliseconds: 100), () {
              func(); // Eksekusi setelah dialog ditutup
              });
            }
          ),
        ],
      ),
    );
  }
}