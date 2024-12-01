import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
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
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity_stages.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity_stages_transhipment.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity_vessel.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_attachment.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_pict.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory_activity.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory_activity_stages.dart';
import 'package:ops_mobile/data/model/t_h_jo.dart';
import 'package:ops_mobile/data/respository/repository.dart';
import 'package:ops_mobile/data/sqlite.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:ops_mobile/feature/login/login_screen.dart';
import 'package:ops_mobile/utils/helper.dart';
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
    Timer.periodic(const Duration(seconds: 10 ), (timer) async {
     // NetworkCore networkCore = Get.find<NetworkCore>();
      //sendDataInpectionPhoto();
      //sendDataInspection();
      sendDataLaboratory();
      //}
      debugPrint('test background service');
    });
  }

  static void sendDataInspection() async{
    debugPrint('print function sendDataInspection ');
    THJo dataActivity = await THJo.getJoActivitySend();
    List<TDJoInspectionActivityStages> stages = dataActivity.inspectionActivityStages ?? [];
    // for(int i = 0; i < stages.length; i++){
    //   debugPrint("json encode stage ${jsonEncode(stages[i])}");
    //   debugPrint("json encode activity ${jsonEncode(stages[i].listActivity)}");
    //   debugPrint("json encode barge ${jsonEncode(stages[i].listActivityBarge)}");
    //   debugPrint("json encode transhipment ${jsonEncode(stages[i].listActivityStageTranshipment)}");
    //   debugPrint("json encode vessel ${jsonEncode(stages[i].listActivityVessel)}");
    // }
    //debugPrint('print data jo ${dataActivity.id.isNull}');
    if(!dataActivity.id.isNull && dataActivity.id != null && Helper.baseUrl().isNotEmpty){
      //send data
      final response = await http.post(
          Uri.parse('${Helper.baseUrl()}/api/v1/inspection/activity'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(dataActivity.toSend())
      );
      debugPrint('print response kirim data jo  ${response.body}');
      if(response.statusCode == 200){
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if(responseData['status'] != 500){
          final data = responseData['data'];
          THJo  thJo = THJo.fromJson(data);
          debugPrint('print data jo yang berhasil terkirim ${jsonEncode(data)}');
          List<TDJoInspectionActivityStages> stageSend = thJo.inspectionActivityStages ?? [];
          for(int s = 0; s < stageSend.length; s++){
            TDJoInspectionActivityStages dataStage = stageSend[s];
            await TDJoInspectionActivityStages.updateUploaded(dataStage.code ?? '');
            if(dataStage.listActivity != null){
              List<TDJoInspectionActivity> dataActs = dataStage.listActivity ?? [];
              for(int a= 0; a < dataActs.length; a++){
                TDJoInspectionActivity  dataAct = dataActs[a];
                await TDJoInspectionActivity.updateUploaded(dataAct.code ?? '');
              }
            }
            if(dataStage.listAttachment != null){
              List<TDJoInspectionAttachment> attachments = dataStage.listAttachment ?? [];
              for(int a=0; a <attachments.length; a++){
                await TDJoInspectionAttachment.updateUploaded(attachments[a].code ?? '');
              }
            }
            if(dataStage.listActivityVessel != null){
              List<TDJoInspectionActivityVessel> vessels = dataStage.listActivityVessel ?? [];
              for(int v = 0; v < vessels.length; v++){
                await TDJoInspectionActivityVessel.updateUploaded(vessels[v].code ?? '');
              }
            }
            if(dataStage.listActivityStageTranshipment != null){
              List<TDJoInspectionActivityStagesTranshipment> transhipments = dataStage.listActivityStageTranshipment ?? [];
              for(int t = 0; t < transhipments.length; t++){
                await TDJoInspectionActivityStagesTranshipment.updateUploaded(transhipments[t].code ?? '');
              }
            }
          }
        }
      }
    }
  }

  static void sendDataLaboratory() async{
    THJo dataActivity = await THJo.getJoLaboratorySend();
    debugPrint('print data jo laboratory send ${jsonEncode(dataActivity.toSend())}');
    //List<TDJoLaboratory> laboratories = dataActivity.laboratory ?? [];
    // for(int i = 0; i < laboratories.length; i++){
    //   debugPrint('print data laboratory ${jsonEncode(laboratories[i].laboratoryActivityStages)}');
    //   List<TDJoLaboratoryActivityStages> stages = laboratories[i].laboratoryActivityStages ?? [];
    //   for(int s = 0; s < stages.length; s++){
    //    // debugPrint('print data laboratory activity ${jsonEncode(stages[s].listLabActivity)}');
    //   }
    // }
    if(dataActivity.id != null && Helper.baseUrl().isNotEmpty){
      //send data
      final response = await http.post(
          Uri.parse('${Helper.baseUrl()}/api/v1/laboratory/activity'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(dataActivity.toSend()),
      );
      if(response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] != 500) {
          final data = responseData['data'];
          debugPrint('print data ${jsonEncode(data)}');
          TDJoLaboratory joLaboratory = TDJoLaboratory.fromJson(data);
          debugPrint('print data jo laboratory ${jsonEncode(joLaboratory)}');
          List<TDJoLaboratoryActivityStages> listLabStage = joLaboratory.laboratoryActivityStages ?? [];
          debugPrint('print data list lab stage ${jsonEncode(listLabStage)}');
          for (int s = 0; s < listLabStage.length; s++) {
            TDJoLaboratoryActivityStages stage = listLabStage[s];
            debugPrint('print data stage ${jsonEncode(stage)}');
            await TDJoLaboratoryActivityStages.updateUploaded(stage.code.toString());
            List<TDJoLaboratoryActivity> activities = listLabStage[s].listLabActivity ?? [];
            for (int a = 0; a < activities.length; a++) {
              TDJoLaboratoryActivity activity = activities[a];
              debugPrint('print data activity ${jsonEncode(activity)}');
              await TDJoLaboratoryActivity.updateUploaded(activity.code ?? '');
            }
          }
        }
      }
    }
  }

  static void sendDataInpectionPhoto() async {
    debugPrint('print sendDataInspectionPhoto ');
    List<TDJoInspectionPict> dataSend = await TDJoInspectionPict.getSendDataPict();
    if(dataSend.isNotEmpty){
      for(TDJoInspectionPict data in dataSend){
        data.pathPhoto = await Helper.convertPhotosToBase64(data.pathPhoto ?? '');
      }
      final response = await http.post(
          Uri.parse('${Helper.baseUrl()}/api/transaksi/jo'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(dataSend.map((item) => TDJoInspectionPict.fromJson(item)).toList())
      );
      debugPrint('Data berhasil dikirim: ${response.body}');
      if(response.statusCode == 200){

      }
    }
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