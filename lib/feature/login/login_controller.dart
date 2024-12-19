import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/core/core/constant/app_constant.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/data/model/login_data_model.dart';
import 'package:ops_mobile/data/model/login_model.dart';
import 'package:ops_mobile/data/sqlite.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:ops_mobile/feature/home/home_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';

class LoginController extends BaseController{

  final PathProviderAndroid providerAndroid = PathProviderAndroid();
  final PathProviderIOS providerIOS = PathProviderIOS();

  late var loginData;
  late TextEditingController username;
  late TextEditingController password;
  late String decryptedPassword;
  late List<ConnectivityResult> connectivityResult;
  RxString loginToken = RxString('');
  bool isLoading = false;
  RxBool obsecure = true.obs;
  RxBool isUpdated = false.obs;
  String version = '';
  late PackageInfo packageInfo;



  @override
  void onInit() async {
    username = TextEditingController();
    password = TextEditingController();
    connectivityResult = await (Connectivity().checkConnectivity());
    await readSettings();
    username.text = loginData['e_number'];
    final testDir = await providerAndroid.getExternalStoragePath();
    debugPrint("print path directory ${testDir}");
    final directory = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    debugPrint('path directory: $directory');
    final data = await SqlHelper.getEmployeePassword(loginData['e_number']);
    debugPrint('data gendata : ${jsonEncode(data)}');
    String encryptedText = data.first['password_aes'];
    debugPrint('data password : $encryptedText');
    decryptedPassword = aesEncrypt(encryptedText) ?? '';
    update();
    String now = DateFormat('dd-MM-yyyy').format(DateTime.now());
    String lastSync = await StorageCore().storage.read("last_sync") ?? '-';
    if(now == lastSync){
      isUpdated.value = true;
    }
    packageInfo = await PackageInfo.fromPlatform();
    version =  packageInfo.version;
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
      AppConstant.BASE_URL = loginData['internet_url'];
      network.setBaseUrl(AppConstant.BASE_URL);
      debugPrint('base url:${AppConstant.BASE_URL}');
      update();
      debugPrint('setting txt: ${jsonDecode(text)}');
    } catch (e) {
      print("Couldn't read file");
      text = '';
    }
    return text;
  }

  void logInDecrypt()async{
    isLoading = true;
    update();
    if(decryptedPassword != '' && password.text == decryptedPassword ){
      isLoading = false;
      update();
      await StorageCore().storage.write('login', jsonEncode(loginData));
      Get.to(() => HomeScreen());
    } else {
      isLoading = false;
      update();
      Get.showSnackbar(
        GetSnackBar(
          // title: "Error",
          backgroundColor: primaryColor,
          message: "Login failed. Password incorrect.",
          // icon: const Icon(Icons.error),
          duration: const Duration(seconds: 3),
        ),
      );
    }
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
    }
  }

  String? aesEncrypt(String encryptedPassword){
    //final encryptedText = '1nSpPO+ndJ8m4n8f3fOscA==';

    // Dekode base64
    final encryptedBytes = enc.Encrypted.fromBase64(encryptedPassword);

    // Kunci dan IV
    final iv = enc.IV.fromUtf8('1234567890123456');
    final key = enc.Key.fromUtf8('iNtIsH@k42@@4G7O');

    // Buat enkripsi AES dengan mode CBC dan padding PKCS7
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));

    // Dekripsi
    try {
      final decrypted = encrypter.decrypt(encryptedBytes, iv: iv);
      password.text = decrypted;
      // Tampilkan hasil dekripsi
      debugPrint('Hasil dekripsi: $decrypted');
      return decrypted;
    } catch (e) {
      debugPrint('Kesalahan saat dekripsi: $e');
    }

  }

  String aesDecrypt(String encryptedPassword) {
    final iv = "1234567890123456";
    final key ="iNtIsH@k42@@4G7O";

    final keyBytes = enc.Key.fromUtf8(key); // Kunci AES
    final ivBytes = enc.IV.fromUtf8(iv);    // IV

    final encrypter = enc.Encrypter(enc.AES(keyBytes, mode: enc.AESMode.cbc)); // Mode CBC
    final encrypted = enc.Encrypted.fromBase64(encryptedPassword); // Konversi dari base64
    final decrypted = encrypter.decrypt(encrypted, iv: ivBytes); // Dekripsi menggunakan

    return decrypted;
  }

}