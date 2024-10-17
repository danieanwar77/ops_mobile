import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:ops_mobile/feature/home/home_screen.dart';
import 'package:ops_mobile/feature/login/login_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';

class SplashController extends BaseController {

  late PackageInfo packageInfo;
  late var settingsData;
  final PathProviderAndroid providerAndroid = PathProviderAndroid();
  final PathProviderIOS providerIOS = PathProviderIOS();

  String appName = '';
  String packageName = '';
  String version = '';
  String buildNumber = '';

  @override
  void onInit() async {
    packageInfo = await PackageInfo.fromPlatform();
    final userData = StorageCore().storage.read('login') ?? '';
    //debugPrint(jsonDecode(await StorageCore().storage.read('login')));

    appName =  packageInfo.appName;
    packageName =  packageInfo.packageName;
    version =  packageInfo.version;
    buildNumber =  packageInfo.buildNumber;

    Future.delayed(const Duration(seconds: 5), (){
      if(userData == ''){
        Get.offAll<void>(() => LoginScreen());
      } else {
        Get.offAll<void>(() => HomeScreen());
      }
    });
    super.onInit();
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
}