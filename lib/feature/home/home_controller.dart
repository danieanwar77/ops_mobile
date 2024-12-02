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
import 'package:ops_mobile/data/model/login_data_model.dart';
import 'package:ops_mobile/data/model/t_d_jo_document_inspection_v2.dart';
import 'package:ops_mobile/data/model/t_d_jo_document_laboratory_v2.dart';
import 'package:ops_mobile/data/model/t_d_jo_finalize_inspection_v2.dart';
import 'package:ops_mobile/data/model/t_d_jo_finalize_laboratory_v2.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity_stages.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity_stages_transhipment.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity_vessel.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_attachment.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_pict.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory_activity.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory_activity_stages.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory_attachment.dart';
import 'package:ops_mobile/data/model/t_h_jo.dart';
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
    syncMaster();
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
      //sendDataInpectionPhoto();
      //sendDataInspection();
      //sendDataLaboratory();
      sendDataFinalizeLaboratory();
      sendDataFinalizeInspection();
      //}
      //debugPrint('test background service');
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
    bool connection = await Helper.checkConnection();
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
    List<TDJoLaboratory> laboratories = dataActivity.laboratory ?? [];
    for(int i = 0; i < laboratories.length; i++){
      debugPrint('print data laboratory ${jsonEncode(laboratories[i].laboratoryActivityStages)}');
      List<TDJoLaboratoryActivityStages> stages = laboratories[i].laboratoryActivityStages ?? [];
      for(int s = 0; s < stages.length; s++){
        if(stages[s].mStatuslaboratoryprogresId == 6){
          List<TDJoLaboratoryAttachment> attachments = stages[s].listLabAttachment ?? [];
          for(int a = 0; a < attachments.length; a++){
            attachments[a].pathName = await Helper.convertPhotosToBase64(attachments[a].pathName ?? '');
          }
        }
      }
    }
    bool connection = await Helper.checkConnection();
    debugPrint('print data connection ${connection}');
    if(dataActivity.id != null && Helper.baseUrl().isNotEmpty){
      //send data
      final response = await http.post(
          Uri.parse('${Helper.baseUrl()}/api/v1/laboratory/activity'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(dataActivity.toSend()),
      );
      if(response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('print response from api ${jsonEncode(responseData)}');
        if (responseData['status'] != 500) {
          final data = responseData['data'];
          TDJoLaboratory joLaboratory = TDJoLaboratory.fromJson(data);
          debugPrint('print data response jo laboratory ${jsonEncode(joLaboratory)}');
          List<TDJoLaboratoryActivityStages> listLabStage = joLaboratory.laboratoryActivityStages ?? [];
          debugPrint('print data response list lab stage ${jsonEncode(listLabStage)}');
          for (int s = 0; s < listLabStage.length; s++) {
            TDJoLaboratoryActivityStages stage = listLabStage[s];
            debugPrint('print data response stage ${jsonEncode(stage)}');
            await TDJoLaboratoryActivityStages.updateUploaded(stage.code.toString());
            List<TDJoLaboratoryActivity> activities = listLabStage[s].listLabActivity ?? [];
            for (int a = 0; a < activities.length; a++) {
              TDJoLaboratoryActivity activity = activities[a];
              debugPrint('print data response activity ${jsonEncode(activity)}');
              await TDJoLaboratoryActivity.updateUploaded(activity.code ?? '');
            }

            if(stage.mStatuslaboratoryprogresId == 6){
              List<TDJoLaboratoryAttachment> attachments = stage.listLabAttachment ?? [];
              for(int at = 0; at < attachments.length; at++){
                await TDJoLaboratoryAttachment.updateUploaded(attachments[at].code ?? '');
              }
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
        final base64 = await Helper.convertPhotosToBase64(data.pathPhoto ?? '');//
        data.pathPhoto = 'data:image/png;base64,${base64}';
      }
      debugPrint('print payload inspection photo yang dikirim ${jsonEncode(dataSend)}');
      final response = await http.post(
          Uri.parse('${Helper.baseUrl()}/api/v1/inspection/photo'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(dataSend)
      );
      debugPrint('Data berhasil dikirim: ${response.body}');
      if(response.statusCode == 200){
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('print response from api ${jsonEncode(responseData)}');
        if(responseData['status'] != 500){
          List<dynamic> dataList = responseData['data'];
          List<TDJoInspectionPict> data = dataList
              .map((item) => TDJoInspectionPict.fromJson(item as Map<String, dynamic>))
              .toList();
          for(int p = 0; p < data.length; p++){
            TDJoInspectionPict item = data[p];
            await TDJoInspectionPict.updateUploaded(item.code ?? '');
          }
        }
      }
    }
  }

  static void sendDataFinalizeLaboratory() async{
    TDJoFinalizeLaboratoryV2? dataLaboratory = await TDJoFinalizeLaboratoryV2.getSendData();
    if(dataLaboratory != null){
      debugPrint('print data finalize laboratory sebelum encode ${jsonEncode(dataLaboratory)}');
      List<TDJoDocumentLaboratoryV2> details = dataLaboratory.listDocument ?? [];
      for(int d = 0; d< details.length; d++){
        TDJoDocumentLaboratoryV2 detail = details[d];
        final filename = detail.fileName ?? ''; // contoh data asdasdasdasd.adasdasd.asdasdasd.pdf
        final fileType = RegExp(r'\.([a-zA-Z0-9]+)$').firstMatch(filename)?.group(1) ?? '';
        final base64 = await Helper.convertPhotosToBase64(detail.pathFile ?? '');
        //if(fileType == "pdf"){
          detail.pathFile = '${base64}';
        //}else{
          //detail.pathFile = 'data:application/pdf;base64,${base64}';
          //detail.pathFile = '${base64}';
        //}
      }
      debugPrint('print data finalize laboratory ${jsonEncode(dataLaboratory)}');
      final response = await http.post(
          Uri.parse('${Helper.baseUrl()}/api/v1/laboratory/document'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(dataLaboratory)
      );
      if(response.statusCode == 200){
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('print response from api ${jsonEncode(responseData)}');
        if(responseData['status'] != 500){
          dynamic dataList = responseData['data'];
          TDJoFinalizeLaboratoryV2 item = TDJoFinalizeLaboratoryV2.fromJson(dataList as Map<String, dynamic>);
          await TDJoFinalizeLaboratoryV2.updateUploaded(item.code ?? '');
          List<TDJoDocumentLaboratoryV2> documents = item.listDocument ?? [];
          for(int d = 0; d < documents.length; d++){
            TDJoDocumentLaboratoryV2 document = documents[d];
            await TDJoDocumentLaboratoryV2.updateUploaded(document.code ?? '');
          }
        }
      }
    }
  }

  static void sendDataFinalizeInspection() async{
    TDJoFinalizeInspectionV2? dataFinalize = await TDJoFinalizeInspectionV2.getSendData();
    if(dataFinalize != null){
      TDJoFinalizeInspectionV2 item = dataFinalize;
      List<TDJoDocumentInspectionV2> details = item.listDocument ?? [];
      for(int d = 0; d< details.length; d++){
        TDJoDocumentInspectionV2 detail = details[d];
        final filename = detail.fileName ?? ''; // contoh data asdasdasdasd.adasdasd.asdasdasd.pdf
        final fileType = RegExp(r'\.([a-zA-Z0-9]+)$').firstMatch(filename)?.group(1) ?? '';
        final base64 = await Helper.convertPhotosToBase64(detail.pathFile ?? '');
        detail.pathFile = '${base64}';
      }

      final response = await http.post(
          Uri.parse('${Helper.baseUrl()}/api/v1/inspection/document'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(dataFinalize)
      );
      if(response.statusCode == 200){
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('print response from api ${jsonEncode(responseData)}');
        if(responseData['status'] != 500){
          dynamic dataList = responseData['data'];
          TDJoFinalizeInspectionV2 data = TDJoFinalizeInspectionV2.fromJson(dataList as Map<String, dynamic>);
          await TDJoFinalizeInspectionV2.updateUploaded(data.code ?? '');
          List<TDJoDocumentInspectionV2> documents = data.listDocument ?? [];
          for(int d = 0; d < documents.length; d++){
            TDJoDocumentInspectionV2 document = documents[d];
            await TDJoDocumentInspectionV2.updateUploaded(document.code ?? '');
          }
        }
      }
    }
  }

  void syncMaster() async{
    final response = await http.post(
        Uri.parse('${Helper.baseUrl()}/api/v1/sync/master'),
        headers: {'Content-Type': 'application/json'},
    );
    if(response.statusCode == 200){
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      var data = responseData['data'];
      var mapJo = data['listjo'];
      List<THJo> thJoies = (mapJo as List)
          .map((jo) => THJo.fromJson(jo as Map<String, dynamic>))
          .toList();
      for(int t=0; t < thJoies.length; t++){
        THJo item =thJoies[t];
        if(item.id != null){
          await THJo.syncData(item);
        }
      }

    }
  }
}
