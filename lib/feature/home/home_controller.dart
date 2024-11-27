import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/core/core/constant/app_constant.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/core/core/services/background_service.dart';
import 'package:ops_mobile/data/model/jo_daily_photo.dart';
import 'package:ops_mobile/data/model/jo_detail_model.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity5.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity6.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity_lab.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity_lab5.dart';
import 'package:ops_mobile/data/model/jo_list_model.dart';
import 'package:ops_mobile/data/model/jo_pic_model.dart';
import 'package:ops_mobile/data/model/jo_send_model.dart';
import 'package:ops_mobile/data/model/login_data_model.dart';
import 'package:ops_mobile/data/respository/repository.dart';
import 'package:ops_mobile/data/sqlite.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:ops_mobile/feature/login/login_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';

class HomeController extends BaseController{

  late PackageInfo packageInfo;

  String appName = '';
  String packageName = '';
  String version = '';
  String buildNumber = '';

  final backgroundServiceHandler = BackgroundService();
  final PathProviderAndroid providerAndroid = PathProviderAndroid();
  final PathProviderIOS providerIOS = PathProviderIOS();
  late var loginData;

  Rx<Data?> userData = Rx(Data());
  RxList<DataJo> dataJoList = RxList();
  RxList<DataDetail> dataJoDetail = RxList();
  RxList<DataPIC> dataJoPIC = RxList();
  RxList<DataDailyPhoto> dataJoDailyPhotos = RxList();
  RxList<DataActivity> dataListActivity = RxList();
  RxList<DataListActivity5> dataListActivity5 = RxList();
  RxList<DataActivity6> dataListActivity6 = RxList();
  RxList<DataActivityLab> dataListActivityLab = RxList();
  RxList<DataActivityLab5> dataListActivityLab5 = RxList();

  var item = [1,2,3,4,5];
  var status = [1,2,3,4,5,6,7];
  int indexItem = 0;
  late List<ConnectivityResult> connectivityResult;


  @override
  void onInit()async{
    initializeService();

    packageInfo = await PackageInfo.fromPlatform();

    appName =  packageInfo.appName;
    packageName =  packageInfo.packageName;
    version =  packageInfo.version;
    buildNumber =  packageInfo.buildNumber;

    var user = jsonDecode(await StorageCore().storage.read('login'));
    debugPrint('data user: ${user}');
    var data = await SqlHelper.getUserDetail(user['e_number'].toString());
    userData.value = Data(
      id : data.first['id'],
      fullname: data.first['fullname'],
      nip: data.first['e_number'],
      positionId: data.first['jabatan_id'],
      position: data.first['jabatan'],
      divisionId: data.first['division_id'],
      division: data.first['division'].toString(),
      superior: data.first['superior_id'].toString()
    );
    await StorageCore().storage.write('user', jsonEncode(data));
    debugPrint('data users: ${jsonEncode(userData.value)}');
    update();

    // connectivityResult = await (Connectivity().checkConnectivity());
    //await getJO();
    super.onInit();
  }

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStartBG,  // Ganti ke startService
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: onStartBG,  // Ganti ke startService
        onBackground: onIosBackground,
      ),
    );

    await service.startService();
  }

  // Fungsi tambahan untuk iOS
  bool onIosBackground(ServiceInstance service) {
    return true;
  }

  void changeSliderIndex(int i){
    indexItem = i;
    update();
  }

  void logOutConfirm() {
    Get.dialog(
      AlertDialog(
        title: const Text('Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
          ),
        ),
        content: const Text('Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            child: const Text('Tidak',
              style: TextStyle(
                color: gray
              ),
            ),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: const Text('Ya',
              style: TextStyle(
                color: primaryColor
              ),
            ),
            onPressed: () {
              StorageCore().storage.remove('login');
              Get.offAll(()=> LoginScreen());
            },
          ),
        ],
      ),
    );
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

  Future<void> sendJoActivityInspection(Activity data) async {
    try{
      var response = await repository.insertActivityInspection(data);
      print('response send activity inspection : ${response.message}');
    } catch(e){
      print('response error send activity inspection : ${jsonEncode(e)}');
    }
  }

  Future<void> sendJoActivity5Inspection(List<FormDataArray> data) async {
    try{
      var response = await repository.insertActivityInspection5(data);
      print('response send activity 5 inspection : ${response.message}');
    } catch(e){
      print('response error send activity 5 inspection : ${jsonEncode(e)}');
    }
  }

  Future<void> sendJoActivity6Inspection(List<FormDataArray6> data) async {
    try{
      var response = await repository.insertActivityInspection6(data);
      print('response send activity 6 inspection : ${response.message}');
    } catch(e){
      print('response error send activity 6 inspection : ${jsonEncode(e)}');
    }
  }

  Future<void> sendJoActivityLaboratory(List<ActivityLab> data) async {
    try{
      var response = await repository.insertActivityLab(data);
      print('response send activity laboratory : ${response.message}');
    } catch(e){
      print('response error send activity laboratory : ${jsonEncode(e)}');
    }
  }

  Future<void> sendJoActivity5Laboratory(List<ActivityAct5Lab> data) async {
    try{
      var response = await repository.insertActivity5Lab(data);
      print('response send activity 5 laboratory : ${response.message}');
    } catch(e){
      print('response error send activity 5 laboratory : ${jsonEncode(e)}');
    }
  }

  Future<void> sendJoActivity6Laboratory(List<FormDataArrayLab6> data) async {
    try{
      var response = await repository.insertActivity6Lab(data);
      print('response send activity 6 laboratory : ${response.message}');
    } catch(e){
      print('response error send activity 6 laboratory : ${jsonEncode(e)}');
    }
  }

  void loadingDialog(){
    Get.dialog(
      AlertDialog(
        title: Center(child: Text("Get JO Data",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
          ),
        )
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Mohon untuk tetap berada di halaman ini sampai proses selesai"),
            SizedBox(height: 16,),
            Center(
              child: LoadingAnimationWidget.prograssiveDots(color: primaryColor, size: 80),
            )
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
  
  void versionSyncDialog()async{
    // await showDialog<Widget>(
    //     context: Get.context!,
    //     builder: (context) {
    //       return SafeArea(
    //         child: Builder(builder: (context) {
    //           return Material(
    //               color: Colors.transparent,
    //               child: Align(
    //                   alignment: Alignment.center,
    //                   child: Container(
    //                       padding: EdgeInsets.all(16),
    //                       height: 72.h,
    //                       width: MediaQuery.sizeOf(Get.context!).width.w * 0.6,
    //                       decoration: BoxDecoration(
    //                         color: Color(0xff727272).withOpacity(0.8),
    //                         borderRadius: BorderRadius.circular(10)
    //                       ),
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         mainAxisSize: MainAxisSize.min,
    //                         children: [
    //                           Text("Version ${version}",
    //                             style: TextStyle(
    //                                 color: Colors.white,
    //                                 fontWeight: FontWeight.w700
    //                             ),
    //                           ),
    //                           SizedBox(height: 16,),
    //                           Text("Last Sync",
    //                             style: TextStyle(
    //                                 color: Colors.white,
    //                                 fontWeight: FontWeight.w700
    //                             ),
    //                           )
    //                         ],
    //                       )
    //                   )
    //               ));
    //         }),
    //       );
    //     },
    //     barrierDismissible: true,
    //     barrierColor: Colors.transparent
    // );
    Get.dialog(
        AlertDialog(
          backgroundColor: Color(0xff727272).withOpacity(0.8),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Version ${version}",
               style: TextStyle(
                 color: Colors.white,
                 fontWeight: FontWeight.w700
               ),
              ),
              SizedBox(height: 16,),
              Text("Last Sync",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700
                ),
              )
            ],
          ),
        ),
      barrierColor: Colors.transparent
    );
    Future.delayed(Duration(seconds: 10), (){
      Get.back();
    });

  }

  @pragma('vm:entry-point')
  static Future<void> onStartBG(ServiceInstance service) async {
    // Timer untuk mengirim data setiap 15 menit
    Timer.periodic(const Duration(seconds: 5 ), (timer) async {
      // if (service is AndroidServiceInstance) {
      //   timer.cancel();
      //   return;
      // }

      // Data yang akan dikirim ke API
      // Map<String, dynamic> requestData = {
      //   "key1": "value1",
      //   "key2": "value2",
      // };
      //
      // var data = Activity.fromJson({
      //   "t_h_jo_id" : 7,
      //   "m_statusinspectionstages_id" : 4,
      //   "trans_date" : "2024-08-31",
      //   "start_activity_time" : "15:00:00",
      //   "end_activity_time" : "16:00:00",
      //   "activity" : "Menunggu Kedatangan Kapal",
      //   "created_by" : 0,
      //   "remarks" : "testing"
      // });
      // print('data yang dikirim background service: ${jsonEncode(data)}');
      // await sendJoActivityInspection(data);
      //
      // // Opsional: Update notifikasi
      // if (service is AndroidServiceInstance) {
      //   service.setForegroundNotificationInfo(
      //     title: "Background Service",
      //     content: "Last sent at ${DateTime.now()}",
      //   );
      // }

      debugPrint('test background service');
    });
  }

}



Future<void> sendJoActivityInspection(Activity data) async {
  final repositoryBackground = Get.find<Repository>();
  try {
    var response = await repositoryBackground.insertActivityInspection(data);
    print('response background service : ${response.message}');
  } catch (e) {
    print('response error background service : ${jsonEncode(e)}');
  }
}