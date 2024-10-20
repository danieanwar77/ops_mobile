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
  String encryptedData = '';
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
    String encryptedText = data.first['password_aes'];

    //aesEncrypt();
    String decryptedPassword = aesDecrypt('MTIzNDU2Nzg5MDEyMzQ1NkhCM2ZMMW1pbGY4PQ==');
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

  String? aesEncrypt(){
    final key = enc.Key.fromUtf8('1234567890123456'); // 32 chars for AES-256
    final iv = enc.IV.fromUtf8('NtIsH@k42@@4'); // AES block size is 16 bytes

    // Step 2: Create the encrypter object (AES with CBC mode and PKCS7 padding)
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc, padding: 'PKCS7'));

    // Step 3: The plaintext to encrypt
    final plainText = 'Hello, AES Encryption!';

    // Step 4: Encrypt the plaintext
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    print('Encrypted (base64): ${encrypted.base64}');  // Encrypted string in base64 format

    // Step 5: Decrypt the ciphertext
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    print('Decrypted: $decrypted');  // Decrypted text (original plaintext)
  }

  String aesDecrypt(String encryptedPassword) {
    final iv = "12345678901234561234567890123456";
    final key ="iNtIsH@k42@@4G7O";

    final keyBytes = enc.Key.fromUtf8(key); // Kunci AES
    final ivBytes = enc.IV.fromUtf8(iv);    // IV

    final encrypter = enc.Encrypter(enc.AES(keyBytes, mode: enc.AESMode.cbc, padding: 'PKCS7')); // Mode CBC
    final encrypted = enc.Encrypted.fromBase64(encryptedPassword); // Konversi dari base64
    final decrypted = encrypter.decrypt(enc.Encrypted.fromUtf8(encryptedPassword), iv: ivBytes); // Dekripsi menggunakan

    return decrypted;
  }

}