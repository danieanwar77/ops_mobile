import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/data/model/login_data_model.dart';
import 'package:ops_mobile/data/model/login_model.dart';
import 'package:ops_mobile/data/sqlite.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:ops_mobile/feature/home/home_screen.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';

class LoginController extends BaseController{

  final PathProviderAndroid providerAndroid = PathProviderAndroid();
  final PathProviderIOS providerIOS = PathProviderIOS();
  static const encryptionChannel = const MethodChannel('enc/dec');
  String decryptedData = '';

  late var loginData;
  late TextEditingController username;
  late TextEditingController password;
  late List<ConnectivityResult> connectivityResult;
  RxString loginToken = RxString('');
  bool isLoading = false;
  RxBool obsecure = true.obs;

  @override
  void onInit() async {
    username = TextEditingController();
    password = TextEditingController();
    connectivityResult = await (Connectivity().checkConnectivity());
    await readSettings();
    username.text = loginData['e_number'];
    final directory = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    debugPrint('path directory: $directory');
    final data = await SqlHelper.getEmployeePassword(loginData['e_number']);
    debugPrint('data gendata : ${jsonEncode(data)}');
    String encryptedText = data.first['password_aes']; // Ganti dengan string terenkripsi
    String key = '\$NtIsH@k42@@4'; // Kunci AES (32 karakter)

    String decryptedPassword = aesDecryptWithoutIV(encryptedText, key);
    print('Decrypted Password: $decryptedPassword');

    update();
    super.onInit();
  }

  Future<String> readSettings() async {
    String text;
    try {
      final directory = await providerAndroid.getApplicationDocumentsPath();
      final File file = File('${directory}/settings.txt');
      text = await file.readAsString();
      loginData = jsonDecode(text);
      update();
      debugPrint('setting txt: ${jsonDecode(text)}');
    } catch (e) {
      print("Couldn't read file");
      text = '';
    }
    return text;
  }
  
  void logIn() async{
    isLoading = true;
    update();
    var response = await repository.login(username.text, password.text) ?? LoginModel();
    if(connectivityResult.contains(ConnectivityResult.none)){
      isLoading = false;
      update();
      Get.showSnackbar(
        GetSnackBar(
          // title: "Error",
          backgroundColor: primaryColor,
          message: "Login failed. Please check your internet connection.",
          // icon: const Icon(Icons.error),
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      if(response?.status == 100){
        loginToken.value = response?.token ?? '';
        if(loginToken.value != ''){
          isLoading = false;
          update();
          getLoginData();
        } else {
          isLoading = false;
          update();
          Get.showSnackbar(
            GetSnackBar(
              // title: "Error",
              backgroundColor: primaryColor,
              message: "Login failed. Token is Empty.",
              // icon: const Icon(Icons.error),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        isLoading = false;
        update();
        Get.showSnackbar(
          GetSnackBar(
            // title: "Error",
            backgroundColor: primaryColor,
            message: "${response.message}",
            // icon: const Icon(Icons.error),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void getLoginData() async {
    isLoading = true;
    update();
    var response = await repository.getEmployeeData(loginToken.value) ?? LoginDataModel();
    if(connectivityResult.contains(ConnectivityResult.none)){
      isLoading = false;
      update();
      Get.showSnackbar(
        GetSnackBar(
          // title: "Error",
          backgroundColor: primaryColor,
          message: "Login failed. Please check your internet connection.",
          // icon: const Icon(Icons.error),
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
        isLoading = false;
        update();
        debugPrint(jsonEncode(response.data));
        await StorageCore().storage.write('login', jsonEncode(response.data));
        update();
        username.text = '';
        password.text = '';
        Get.to(() => HomeScreen());
        // Get.showSnackbar(
        //   GetSnackBar(
        //     // title: "Error",
        //     backgroundColor: primaryColor,
        //     message: "${response.message}",
        //     // icon: const Icon(Icons.error),
        //     duration: const Duration(seconds: 3),
        //   ),
        // );

    }
  }

  String aesDecryptWithoutIV(String encryptedPassword, String key) {
    final keyBytes = enc.Key.fromUtf8(key); // Kunci AES, harus 16, 24, atau 32 karakter

    // Inisialisasi enkripsi tanpa IV (menggunakan ECB mode)
    final encrypter = enc.Encrypter(enc.AES(keyBytes, mode: enc.AESMode.ecb)); // Mode ECB, tidak memerlukan IV
    final encrypted = enc.Encrypted.fromBase64(encryptedPassword); // Konversi dari base64
    final decrypted = encrypter.decrypt(encrypted); // Dekripsi tanpa IV

    return decrypted;
  }
}