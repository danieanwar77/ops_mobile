import 'dart:convert';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:ops_mobile/utils/helper.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';

class SettingsController extends BaseController{

  late var settingsData;
  final PathProviderAndroid providerAndroid = PathProviderAndroid();
  final PathProviderIOS providerIOS = PathProviderIOS();

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  RxBool obsecure = true.obs;
  bool isLoading = false;

  @override
  void onInit()async{
    if (Get.previousRoute != '/RegisterDeviceScreen') {
      Future.delayed(Duration(milliseconds: 500), () {
        drawerAddDocument();
      });
    }

    settingsData = jsonDecode(await readSettings());
    update();
    debugPrint('settings data: ${settingsData}');
  }

  Future<String> readSettings() async {
    String text;
    try {
      final directory = await providerAndroid.getApplicationDocumentsPath();
      final File file = File('${directory}/settings.txt');
      text = await file.readAsString();
      debugPrint('setting txt: ${jsonDecode(text)}');
    } catch (e) {
      print("Couldn't read file");
      text = '';
    }
    return text;
  }

  void drawerAddDocument(){
    Get.bottomSheet(
      WillPopScope(
        onWillPop: () async {
          // Kembalikan false untuk mencegah dialog hilang saat tombol back ditekan
          return false;
        },
        child: GetBuilder<SettingsController>(
          init: SettingsController(),
          builder: (controller) => Container(
            padding: EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24),
                topLeft: Radius.circular(24),
              ),
            ),
            child: Obx(
                  () => Column(
                children: [
                  const SizedBox(
                    height: 48,
                  ),
                  TextFormField(
                    controller: password,
                    obscureText: controller.obsecure.value,
                    cursorColor: onFocusColor,
                    style: const TextStyle(color: onFocusColor),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        onPressed: () {
                          controller.obsecure.value = !controller.obsecure.value;
                        },
                        icon: controller.obsecure.value
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: onFocusColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Password',
                      floatingLabelStyle: const TextStyle(color: onFocusColor),
                      fillColor: onFocusColor,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      controller.isLoading = true;
                      bool loginAdmin = await loginAdminSetting(password.text);
                      controller.isLoading = false;
                      if (loginAdmin) {
                        Get.back();
                        openDialog("Success", "Berhasil login admin.");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      width: double.infinity,
                      child: Center(
                        child: controller.isLoading
                            ? const CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        )
                            : const Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
    );

  }

  Future<bool> loginAdminSetting(String password) async{
    if(password == 'admin'){
      return true;
    } else {
      openDialog("Failed", "Password salah.");
      return false;
    }
  }

  void openDialog(String type, String text) {
    Get.dialog(
      AlertDialog(
        title: Text(type,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
          ),
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

  void deleteSettingsConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text('Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
          ),
        ),
        content: Text('Apakah benar anda ingin menghapus data setting di device ini?'),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text("OK",
              style: TextStyle(
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              Get.back();
              //var response = await repository.deleteRegisterDevice(settingsData['e_number'].toString());
              await StorageCore().storage.write("last_sync", '');
              String? path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
              String pathDb = '$path/ops/IGSgForce.db';
              await Helper.deleteDatabaseFile(pathDb);
              openDialog('Success', 'Berhasil hapus data');
              // if(response.code == 200 && response.message == 'Delete Succesfuly'){
              //   openDialog('Success', 'Berhasil hapus data register perangkat');
              // }
            },
          ),
        ],
      ),
    );
  }
}