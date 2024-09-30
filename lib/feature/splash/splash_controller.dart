import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:ops_mobile/feature/home/home_screen.dart';
import 'package:ops_mobile/feature/login/login_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../data/model/login_data_model.dart';

class SplashController extends BaseController {

  late PackageInfo packageInfo;

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
}