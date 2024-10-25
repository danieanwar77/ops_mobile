import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/core/core/constant/app_constant.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/data/model/jo_daily_photo.dart';
import 'package:ops_mobile/data/model/jo_detail_model.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity5.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity6.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity_lab.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity_lab5.dart';
import 'package:ops_mobile/data/model/jo_pic_model.dart';
import 'package:ops_mobile/data/model/jo_send_model.dart';
import 'package:ops_mobile/data/model/login_data_model.dart';
import 'package:ops_mobile/data/model/response_jo_insert_activity.dart';
import 'package:ops_mobile/data/model/response_jo_insert_activity5.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_acitivity_stages.dart';
import 'package:ops_mobile/data/respository/repository.dart';
import 'package:ops_mobile/data/sqlite.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:ops_mobile/feature/lab_activity_detail/lab_activity_detail_screen.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class JoDetailController extends BaseController {
  // Data User
  Rx<Data?> userData = Rx(Data());

  // Settings
  final PathProviderPlatform providerAndroid = PathProviderPlatform.instance;
  final picker = ImagePicker();
  RxBool activitySubmitted = RxBool(false);
  final _formKey = GlobalKey<FormState>();

  // Detail Data
  late int id;
  late int statusId;
  List<String> activityStages = [
    'Waiting for Arrival',
    'Ship Arrived',
    'Ship Berthing',
    'Work Commence',
    'Work Complete',
    'Report to Client'
  ];
  int picInspector = 0;
  int picLaboratory = 0;
  List<Tab> joDetailTab = [];
  List<Tab> joWaitingTab = [];
  bool isLoadingJO = false;
  bool isLoadingJOImage = false;
  //Rx<DataDetail> dataJoDetail = Rx(DataDetail());
  Rx<DataDetail> dataJoDetail = Rx(DataDetail());
  Rx<DataPIC> dataJoPIC = Rx(DataPIC());

  // Activity Inspection Data
  RxList<DataDailyPhoto> dataJoDailyPhotos = RxList();
  // Rx<DataListActivity> dataListActivity = Rx(DataListActivity());
  RxList<DataActivity> dataListActivity = RxList();
  Rx<DataListActivity5> dataListActivity5 = Rx(DataListActivity5());
  RxList<String> barges = RxList();
  RxList<String> activity5Barges = RxList();
  RxList<TextEditingController> bargesController = RxList();
  Rx<DataListActivity6> dataListActivity6 = Rx(DataListActivity6());
  Rx<Activity6Attachments> dataListActivity6Attachments =
      Rx(Activity6Attachments());

  // Activity Lab Data
  Rx<DataListActivityLab> dataListActivityLab = Rx(DataListActivityLab());
  Rx<DataListActivityLab5> dataListActivityLab5 = Rx(DataListActivityLab5());
  RxList<Laboratory> labs = RxList();

  // Activity Inspection Photo Variables & Temporary
  RxList<File> dailyActivityPhotos = RxList();
  RxList<File> dailyActivityPhotosTemp = RxList();
  RxList<String> dailyActivityPhotosDescText = RxList();
  RxList<String> dailyActivityPhotosDescTextTemp = RxList();
  RxList<TextEditingController> dailyActivityPhotosDesc = RxList();
  RxList<TextEditingController> dailyActivityPhotosDescTemp = RxList();
  RxInt adddailyActivityPhotosCount = RxInt(0);
  Rx<TextEditingController> dailyActivityPhotosDescEdit =
      TextEditingController().obs;
  Rx<File> activityPreviewFoto = Rx(File(''));

  // Activity Inspection Variables & Temporary
  RxList<Activity> activityList = RxList();
  RxList<Activity> activityListStages = RxList();
  RxList<TextEditingController> activityListTextController = RxList();
  int activityStage = 1;
  RxList<TextEditingController> jettyListTextController = RxList();
  RxList<TextEditingController> initialDateActivity5ListTextController =
      RxList();
  RxList<TextEditingController> finalDateActivity5ListTextController = RxList();
  RxList<TextEditingController> deliveryQtyListTextController = RxList();
  TextEditingController activityDate = TextEditingController();
  bool activityDateValidate = true;
  TextEditingController activityStartTime = TextEditingController();
  bool activityStartTimeValidate = true;
  TextEditingController activityEndTime = TextEditingController();
  bool activityEndTimeValidate = true;
  TextEditingController activityText = TextEditingController();
  bool activityTextValidate = true;
  TextEditingController activityRemarks = TextEditingController();
  RxBool editActivityMode = RxBool(false);
  RxInt editActivityIndex = 0.obs;

  // Activity 5 Inspection Variables & Temporary
  RxInt activity5FormCount = 1.obs;
  RxList<FormDataArray> activity5List = RxList();
  RxList<FormDataArray> activity5ListStages = RxList();
  RxList<Transhipment> activity5TranshipmentList = RxList();
  TextEditingController vesselController = TextEditingController();
  TextEditingController uomController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  int bargesCount = 0;
  int activity5bargesCount = 0;

  // Activity 6 Inspection Variables & Temporary
  RxList<Activity> activity6List = RxList();
  RxList<Activity> activity6ListStages = RxList();
  RxList<TextEditingController> activity6ListTextController = RxList();
  Rx<TextEditingController> certificateNumberTextController =
      TextEditingController().obs;
  Rx<TextEditingController> certificateDateTextController =
      TextEditingController().obs;
  Rx<TextEditingController> certificateBlankoNumberTextController =
      TextEditingController().obs;
  Rx<TextEditingController> certificateLHVNumberTextController =
      TextEditingController().obs;
  Rx<TextEditingController> certificateLSNumberTextController =
      TextEditingController().obs;

  // Activity 6 Inspection Variables & Temporary
  TextEditingController activity6Date = TextEditingController();
  TextEditingController activity6StartTime = TextEditingController();
  TextEditingController activity6EndTime = TextEditingController();
  TextEditingController activity6Text = TextEditingController();
  TextEditingController activity6Remarks = TextEditingController();
  RxList<File> activity6Attachments = RxList();
  RxList<File> activity6AttachmentsStage = RxList();

  // Activities Documents
  RxList<Map<String, dynamic>> documentInspection = RxList();
  RxList<File> documentInspectionAttachments = RxList();
  RxList<Map<String, dynamic>> documentLaboratory = RxList();
  RxList<File> documentLaboratoryAttachments = RxList();
  //Rx<File> activityPreviewFoto = Rx(File(''));

  @override
  void onInit() async {
    var dataUser = await SqlHelper.getUserDetail('1234');
    userData.value = Data(
        id : dataUser.first['id'],
        fullname: dataUser.first['fullname'],
        nip: dataUser.first['e_number'],
        positionId: dataUser.first['jabatan_id'],
        position: dataUser.first['jabatan'],
        divisionId: dataUser.first['division_id'],
        division: dataUser.first['division'].toString(),
        superior: dataUser.first['superior_id'].toString()
    );
    debugPrint('data user: ${jsonEncode(userData.value)}');

    var argument = await Get.arguments;
    id = argument['id'];
    statusId = argument['status'];
    isLoadingJO == true;
    // final data = await SqlHelper.getDetailJo(id);
    // debugPrint('data detail : ${jsonEncode(data)}');
    //await getJoDetailLocal();
    isLoadingJO == false;
    update();
    await getData();
    debugPrint('activity stage now: $activityStage');

    super.onInit();
  }

  // Get Data

  Future<void> getData() async {
    //await getJoDetail();
    await getJoDetailLocal();
    picInspector = int.parse(dataJoDetail.value.detail?.idPicInspector != null
        ? dataJoDetail.value.detail!.idPicInspector.toString() ==
                userData.value!.id.toString()
            ? dataJoDetail.value.detail!.idPicInspector.toString()
            : '0'
        : '0');
    update();
    picLaboratory = int.parse(dataJoDetail.value.detail?.idPicLaboratory != null
        ? dataJoDetail.value.detail!.idPicLaboratory.toString() ==
                userData.value!.id.toString()
            ? dataJoDetail.value.detail!.idPicLaboratory.toString()
            : '0'
        : '0');
    update();
    debugPrint('id pic inspector: $picInspector , laboratory: $picLaboratory');
    if(picInspector != '0' && picLaboratory == 0){
      joDetailTab = [
        Tab(
          text: 'Detail',
        ),
        Tab(
          text: 'KOS',
        ),
        Tab(
          text: 'PIC',
        ),
        Tab(
          text: 'Progress & Daily Activity',
        ),
      ];

      joWaitingTab = [
        Tab(
          text: 'Detail',
        ),
        Tab(
          text: 'KOS',
        ),
        Tab(
          text: 'PIC',
        ),
        Tab(
          text: 'Progress & Daily Activity',
        ),
        Tab(
          text: 'Document - Inspection',
        ),
      ];
      update();
    } else if(picInspector == 0 && picLaboratory != '0'){
      joDetailTab = [
        Tab(
          text: 'Detail',
        ),
        Tab(
          text: 'KOS',
        ),
        Tab(
          text: 'PIC',
        ),
        Tab(
          text: 'Laboratory Progress',
        ),
      ];

      joWaitingTab = [
        Tab(
          text: 'Detail',
        ),
        Tab(
          text: 'KOS',
        ),
        Tab(
          text: 'PIC',
        ),
        Tab(
          text: 'Laboratory Progress',
        ),
        Tab(
          text: 'Document - Laboratory',
        ),
      ];
      update();
    } else if(picInspector != '0' && picLaboratory != '0'){
      joDetailTab = [
        Tab(
          text: 'Detail',
        ),
        Tab(
          text: 'KOS',
        ),
        Tab(
          text: 'PIC',
        ),
        Tab(
          text: 'Progress & Daily Activity',
        ),
        Tab(
          text: 'Laboratory Progress',
        ),
      ];

      joWaitingTab = [
        Tab(
          text: 'Detail',
        ),
        Tab(
          text: 'KOS',
        ),
        Tab(
          text: 'PIC',
        ),
        Tab(
          text: 'Progress & Daily Activity',
        ),
        Tab(
          text: 'Laboratory Progress',
        ),
        Tab(
          text: 'Document - Inspection',
        ),
        Tab(
          text: 'Document - Laboratory',
        ),
      ];
      update();
    }
    //await getJoPIC();
    //await getJoPICLocal();
    // await getJoDailyPhoto();
    // await getJoDailyActivity();
    await getJoDailyActivityLocal();
    // await getJoDailyActivity5();
    // await getJoDailyActivity6();
    // await getJoDailyActivityLab();
    // await getJoDailyActivityLab5();
    isLoadingJO == false;
    update();
  }

  Future<void> getJoDetail() async {
    var response = await repository.getJoDetail(id) ?? JoDetailModel();
    debugPrint(jsonEncode(response));
    debugPrint('JO Laboratories: ${jsonEncode(response.data?.laboratory)}');
    dataJoDetail.value = response?.data ?? DataDetail();
    var labo = response.data?.laboratory ?? [];
    barges.value = dataJoDetail.value.detail?.barge?.split('|') ?? [];
    barges.value.forEach((_) {
      bargesController.value.add(TextEditingController());
    });
    if (labo!.isNotEmpty) {
      labs.value = labo!;
    }
    bargesCount = barges.value.length;
    activity5bargesCount = bargesCount;
    activity5Barges.value = barges.value;
    update();
    debugPrint('barges : ${jsonEncode(barges.value)}');
  }

  Future<void> getJoDetailLocal() async {
    final data = await SqlHelper.getDetailJo(id);
    debugPrint('data detail : ${jsonEncode(data.first)}');
    final sow = await SqlHelper.getDetailJoSow(id);
    debugPrint('data detail SOW : ${jsonEncode(sow)}');
    final oos = await SqlHelper.getDetailJoOos(id);
    debugPrint('data detail OOS : ${jsonEncode(oos)}');
    final lap = await SqlHelper.getDetailJoLap(id);
    debugPrint('data detail LAP : ${jsonEncode(lap)}');
    // final std = await SqlHelper.getDetailJoStdMethod(id);
    // debugPrint('data detail Std Method : ${jsonEncode(std)}');
    final pic = await SqlHelper.getDetailJoPicHistory(id);
    debugPrint('data detail PIC History : ${jsonEncode(pic)}');
    dataJoDetail.value = DataDetail.fromJson(data.first);
    final labo = await SqlHelper.getDetailJoLaboratoryList(id);
    debugPrint('data detail ListLaboratory : ${jsonEncode(labo)}');

    dataJoDetail.value = DataDetail(
      detail: DetailJo.fromJson(data.first),
      sow: sow.map((item){
        return Sow(
          id: item['id'],
          name: item['name']
        );
      }).toList(),
      oos: oos.map((item){
        return Oos(
          id: item['id'],
          name: item['name']
        );
      }).toList(),
      lap: lap.map((item){
        return Lap(
            id: item['id'],
            name: item['name']
        );
      }).toList(),
      stdMethod:
      // std.map((item){
      //   return StdMethod(
      //       id: item['id'],
      //       name: item['name']
      //   );
      // }).toList()
        []
        ,
      picHist: pic.map((item){
        return PicHist.fromJson(item);
      }).toList(),
      laboratory: labo.map((item){
        return Laboratory(
            laboratoriumId: item['laboratorium_id'],
            name: item['name']
        );
      }).toList()
    );

    barges.value = dataJoDetail.value.detail?.barge?.split('|') ?? [];
    barges.value.forEach((_) {
      bargesController.value.add(TextEditingController());
    });
    if(labo != null) {
      labo.forEach((lab) {
        labs.value.add(Laboratory.fromJson(lab));
      });
    }
    bargesCount = barges.value.length;
    activity5bargesCount = bargesCount;
    activity5Barges.value = barges.value;
    update();
    debugPrint('barges : ${jsonEncode(barges.value)}');
  }

  Future<void> getJoPIC() async {
    var response = await repository.getJoPIC(id) ?? JoPicModel();
    debugPrint('JO PIC: ${jsonEncode(response)}');
    dataJoPIC.value = response?.data ?? DataPIC();
  }

  Future<void> getJoPICLocal() async {
    //var response = await repository.getJoPIC(id) ?? JoPicModel();
    var response = await SqlHelper.getDetailJoPicHistory(id);
    debugPrint('JO PIC: ${jsonEncode(response)}');
    dataJoPIC.value = DataPIC.fromJson(response);
  }

  Future<void> getJoDailyPhoto() async {
    var response = await repository.getJoDailyPhoto(id) ?? JoDailyPhoto();
    debugPrint('JO Daily Photo: ${jsonEncode(response)}');
    if (response.data!.isNotEmpty) {
      dataJoDailyPhotos.value = response?.data ?? [];
      if (dataJoDailyPhotos.value.isNotEmpty) {
        isLoadingJOImage = true;
        update();
        dailyActivityPhotos.value = [];
        TextEditingController tempPhotoDesc = TextEditingController();
        dataJoDailyPhotos.value.forEach((data) async {
          final File photo = await getImagesFromUrl(data.pathPhoto!);
          dailyActivityPhotos.value.add(photo);
          tempPhotoDesc.text = data.keterangan ?? '';
          dailyActivityPhotosDesc.value.add(tempPhotoDesc);
          dailyActivityPhotosDescText.value.add(data.keterangan ?? '');
          update();
        });
        isLoadingJOImage = false;
        update();
      }
    }
  }

  Future<File> getImagesFromUrl(String strURL) async {
    debugPrint('image path: ${AppConstant.CORE_URL}$strURL');
    final http.Response responseData =
        await http.get(Uri.parse('${AppConstant.CORE_URL}/$strURL'));
    var uint8list = responseData.bodyBytes;
    var buffer = uint8list.buffer;
    ByteData byteData = ByteData.view(buffer);
    var filenameArr = strURL.split("/");
    var filename = filenameArr.last;
    var tempDir = await providerAndroid.getTemporaryPath();
    final File file = await File('${tempDir}/${filename}').writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    debugPrint('image file path: ${file}');
    return file;
  }

  Future<void> getJoDailyActivity() async {
    var response =
        await repository.getJoListDailyActivity(id) ?? JoListDailyActivity();
    debugPrint('JO Daily Activity: ${jsonEncode(response)}');
    dataListActivity.value = response.data?.data! ?? [];
    if (dataListActivity.value.isNotEmpty) {
      debugPrint(
          'stage now: ${dataListActivity.value.last.mStatusinspectionstagesId.toString()}');
      activityStage = int.parse(dataListActivity
              .value.last.mStatusinspectionstagesId
              .toString()) +
          1;
    }
    activityListStages.value.clear();
    dataListActivity.value.forEach((data) {
      activityListStages.value.add(Activity(
        id: data.inspectionActivityId,
        code: data.code,
        tHJoId: data.tHJoId,
        stageId: data.inspectionStagesId,
        mStatusinspectionstagesId: data.mStatusinspectionstagesId,
        transDate: data.transDate,
        startActivityTime: data.startActivityTime,
        endActivityTime: data.endActivityTime,
        activity: data.activity,
        createdBy: data.createdBy,
        remarks: data.remarks,
        createdAt: data.createdAt,
        updatedBy: data.updatedBy,
        updatedAt: data.updatedAt,
        isActive: data.isActive,
        isUpload: data.isUpload,
      ));
    });
    debugPrint("activitystage ${activityListStages.value}");
  }

  Future<void> getJoDailyActivityLocal() async {
    var response = await SqlHelper.getListActivity(id);
    debugPrint('JO Daily Activity: ${jsonEncode(response)}');
    dataListActivity.value = response.map((item){
      return DataActivity.fromJson(item);
    }).toList();
    activityListStages.value.clear(); // clear value
    if (dataListActivity.value.isNotEmpty) {
      activityListStages.value.clear();
      dataListActivity.value.forEach((data) {
        activityListStages.value.add(Activity(
          id: data.inspectionActivityId,
          code: data.code,
          tHJoId: data.tHJoId,
          stageId: data.inspectionStagesId,
          stageCode: data.stageCode,
          mStatusinspectionstagesId: data.mStatusinspectionstagesId,
          transDate: data.transDate,
          startActivityTime: data.startActivityTime,
          endActivityTime: data.endActivityTime,
          activity: data.activity,
          createdBy: data.createdBy,
          remarks: data.remarks,
          createdAt: data.createdAt,
          updatedBy: data.updatedBy,
          updatedAt: data.updatedAt,
          isActive: data.isActive,
          isUpload: data.isUpload,
        ));
      });
    }
    debugPrint('data activity: ${jsonEncode(activityListStages.value)}');
  }

  Future<void> getJoDailyActivity5() async {
    var response =
        await repository.getJoListDailyActivity5(id) ?? JoListDailyActivity5();
    debugPrint('JO Daily Activity 5: ${jsonEncode(response)}');
    if (response.data!.detail!.isNotEmpty) {
      dataListActivity5.value = response?.data ?? DataListActivity5();
      var data = dataListActivity5.value;
      var dataBarge = data.barge!.map((item) {
        return Barge(barge: item.barge);
      }).toList();
      var dataTranshipment = data.transhipment!.map((item) {
        return Transhipment(
          jetty: item.jetty,
          initialDate: item.initialDate,
          finalDate: item.finalDate,
          deliveryQty: item.deliveryQty.toString(),
        );
      }).toList();
      activity5ListStages.value.add(FormDataArray(
          tHJoId: id,
          mStatusinspectionstagesId: 5,
          uomId: 3,
          transDate: data.detail!.first.transDate,
          actualQty: data.detail!.first.actualQty.toString(),
          createdBy: 0,
          vessel: data.detail!.first.vessel,
          barge: dataBarge,
          transhipment: dataTranshipment));
    }
  }

  Future<void> getJoDailyActivity6() async {
    var response =
        await repository.getJoListDailyActivity6(id) ?? JoListDailyActivity6();
    debugPrint('JO Daily Activity 6: ${jsonEncode(response)}');
    debugPrint(
        'JO Daily Activity 6 Attachments: ${jsonEncode(response.image)}');
    dataListActivity6.value = response?.data ?? DataListActivity6();
    dataListActivity6Attachments.value =
        response?.image ?? Activity6Attachments();
    var data = dataListActivity6.value;
    var dataAttach = dataListActivity6Attachments.value;
    data.data?.forEach((act) {
      activity6ListStages.value.add(Activity(
          tHJoId: act.tHJoId,
          mStatusinspectionstagesId: act.mStatusinspectionstagesId,
          transDate: act.transDate,
          startActivityTime: act.startActivityTime,
          endActivityTime: act.endActivityTime,
          activity: act.activity,
          createdBy: 0,
          remarks: act.remarks));
    });
    dataAttach.attach?.forEach((attach) async {
      activity6Attachments.value = [];
      final File data = await getImagesFromUrl(attach.pathName!);
      activity6Attachments.value.add(data);
    });
  }

  // Activity Detail Functions

  void changeStatusJo() async {
    var response = await repository.changeStatusJo(id.toString(), 3.toString());
    if (response?.httpCode != 200) {
      debugPrint('Berhasil ubah status JO.');
      //openDialog('Success', 'Berhasil ubah status JO.');
    } else {
      debugPrint('Gagal ubah status JO');
      //openDialog('Failed', 'Gagal ubah status JO');
    }
  }

  // Activity Photo Functions

  Future cameraImage() async {
    File? image;
    try {
      final XFile? pic = await picker.pickImage(source: ImageSource.camera);
      final imageTemp = File(pic!.path);
      image = imageTemp;
      update();
      return image;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImage() async {
    File? image;
    try {
      final XFile? pic = await picker.pickImage(source: ImageSource.gallery);
      final imageTemp = File(pic!.path);
      image = imageTemp;
      update();
      return image;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void adddailyActivityPhotos(File foto, String desc) {
    dailyActivityPhotosTemp.value.add(foto);
    dailyActivityPhotosDescTextTemp.value.add(desc);
  }

  void adddailyActivityPhotoForm() {
    adddailyActivityPhotosCount.value++;
    dailyActivityPhotosDescTemp.value.add(TextEditingController());
    dailyActivityPhotosDescTextTemp.value.add('');
  }

  void removePhotoActivity() {
    dailyActivityPhotosTemp.value.removeLast();
    dailyActivityPhotosDescTemp.value.removeLast();
    dailyActivityPhotosDescTextTemp.value.removeLast();
    adddailyActivityPhotosCount.value--;
    update();
  }

  void editPhotoActivityDesc(int index, String desc) {
    dailyActivityPhotosDescText[index] = desc;
  }

  void sendActivityDailyPhoto() async {
    int success = 0;
    if (dailyActivityPhotosTemp.value.isNotEmpty &&
        dailyActivityPhotosDescTemp.value.isNotEmpty) {
      for (var i = 0; i < dailyActivityPhotosTemp.value.length; i++) {
        final File photo = dailyActivityPhotosTemp.value[i];
        final TextEditingController desc = dailyActivityPhotosDescTemp.value[i];
        String response = await sendPhotos(photo, desc.text);
        if (response == 'success') {
          success++;
          dailyActivityPhotos.value.add(photo);
          dailyActivityPhotosDesc.value.add(desc);
        }
      }
    } else {
      openDialog('Failed', 'Tidak ada foto yang diupload');
    }

    if (success == dailyActivityPhotos.value.length) {
      openDialog('Success', 'Foto berhasil dikirm');
      if (activityList.value.isEmpty) {
        changeStatusJo();
      }
      // changeStatusJo();
      getJoDailyPhoto();
      dailyActivityPhotosTemp.value = [];
      dailyActivityPhotosDescTemp.value = [];
      dailyActivityPhotosDescTextTemp.value = [];
      adddailyActivityPhotosCount.value = 0;
    } else {
      openDialog('Attention', 'Beberapa foto gagal dikirim');
    }
  }

  Future<String> updateActivityDailyPhoto(File image, int id, String desc) async {
    var response = await repository.updateActivityDailyPhoto(image, id, desc);
    if (response?.httpCode != 200) {
      return 'failed';
    } else {
      return 'success';
    }
  }

  Future<String> sendPhotos(File photo, String desc) async {
    var response = await repository.insertActivityDailyPhoto(photo, id, desc);
    if (response?.httpCode != 200) {
      return 'failed';
    } else {
      return 'success';
    }
  }

  Future<String> deletePhoto(int id) async {
    var response = await repository.deleteActivityPhoto(id);
    if (response?.message == null) {
      return 'failed';
    } else {
      return 'success';
    }
  }

  void drawerDailyActivityImage() {
    if (dailyActivityPhotosDescTemp.value.isEmpty) {
      adddailyActivityPhotosCount.value++;
      dailyActivityPhotosDescTemp.value.add(TextEditingController());
      dailyActivityPhotosDescTextTemp.value.add('');
    }
    Get.bottomSheet(
        GetBuilder(
          init: JoDetailController(),
          builder: (controller) => Container(
              margin: EdgeInsets.only(top: 48),
              padding: EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      topLeft: Radius.circular(24))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add JO Photos',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: primaryColor),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: adddailyActivityPhotosCount.value,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Photo ${index + 1}'),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      index <
                                              dailyActivityPhotosTemp
                                                  .value.length
                                          ? Column(
                                              children: [
                                                InkWell(
                                                    onTap: () async {
                                                      inspectionMediaPickerConfirmEdit(
                                                          index);
                                                    },
                                                    child: Image.file(
                                                      File(
                                                          dailyActivityPhotosTemp
                                                              .value[index]
                                                              .path),
                                                      fit: BoxFit.fitWidth,
                                                    )),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                              ],
                                            )
                                          : InkWell(
                                              onTap: () async {
                                                inspectionMediaPickerConfirm(
                                                    index);
                                              },
                                              child: Container(
                                                height: 54,
                                                width: 54,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: primaryColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.camera_alt_sharp,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      TextFormField(
                                        controller: dailyActivityPhotosDescTemp
                                            .value[index],
                                        onChanged: (value) {
                                          editPhotoActivityDesc(index, value);
                                        },
                                        cursorColor: onFocusColor,
                                        style: const TextStyle(
                                            color: onFocusColor),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: onFocusColor),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            labelText: 'Description',
                                            floatingLabelStyle: const TextStyle(
                                                color: onFocusColor),
                                            fillColor: onFocusColor),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  );
                                }),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    adddailyActivityPhotoForm();
                                    update();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 8),
                                    height: 42,
                                    width: 42,
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                adddailyActivityPhotosCount.value > 1
                                    ? InkWell(
                                        onTap: () {
                                          removePhotoActivity();
                                        },
                                        child: Container(
                                          height: 42,
                                          width: 42,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Center(
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: primaryColor),
                                    borderRadius: BorderRadius.circular(12))),
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                width: double.infinity,
                                child: Center(
                                    child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )))),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              addActivityDailyPhotoConfirm();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                width: double.infinity,
                                child: Center(
                                    child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )))),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              )),
        ),
        isScrollControlled: true);
  }

  void addActivityDailyPhotoConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah benar anda ingin menambahkan foto JO ini?'),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text(
              "OK",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              //debugPrint('data photo: ${jsonEncode(dailyActivityPhotosTemp.value)}');
              Get.back();
              sendActivityDailyPhoto();
            },
          ),
        ],
      ),
    );
  }

  void previewImage(int index, String photo, String desc) async {
    dailyActivityPhotosDescEdit.value.text = desc;
    activityPreviewFoto.value = await File(photo);
    Get.dialog(
      GetBuilder(
        init: JoDetailController(),
        builder: (controller) => AlertDialog(
          title: Row(
            children: [
              Text(
                'Photo and Description ${index + 1}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: primaryColor),
              ),
              dataJoDetail.value.detail?.statusJo == 'Assigned' ||
                      dataJoDetail.value.detail?.statusJo == 'On Progres'
                  ? InkWell(
                      onTap: () {
                        deleteActivityDailyPhotoConfirm(int.parse(
                            dataJoDailyPhotos.value[index].id!.toString()));
                      },
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                    )
                  : const SizedBox(),
              Spacer(),
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.close),
              )
            ],
          ),
          content: SizedBox(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      inspectionMediaPreviewPickerConfirmEdit(index);
                    },
                    child: Image.file(
                      File(activityPreviewFoto.value.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  // InkWell(
                  //   onTap: () async {
                  //     var image = await cameraImage();
                  //     foto.value = image;
                  //     //updateActivityDailyPhoto(foto, int.parse(dataJoDailyPhotos.value[index].id!.toString()));
                  //   },
                  //   child: Container(
                  //     height: 54,
                  //     width: 54,
                  //     decoration: BoxDecoration(
                  //         border: Border.all(color: primaryColor),
                  //         borderRadius: BorderRadius.circular(8)
                  //     ),
                  //     child: Center(
                  //       child: Icon(Icons.camera_alt_sharp,
                  //         color: primaryColor,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 16,
                  ),
                  dataJoDetail.value.detail?.statusJo == 'Assigned' ||
                          dataJoDetail.value.detail?.statusJo == 'On Progres'
                      ? TextFormField(
                          controller: dailyActivityPhotosDescEdit.value,
                          cursorColor: onFocusColor,
                          style: const TextStyle(color: onFocusColor),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: onFocusColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: 'Description',
                              floatingLabelStyle:
                                  const TextStyle(color: onFocusColor),
                              fillColor: onFocusColor),
                        )
                      : Text(desc),
                ],
              ),
            ),
          ),
          actions: [
            dataJoDetail.value.detail?.statusJo == 'Assigned' ||
                    dataJoDetail.value.detail?.statusJo == 'On Progres'
                ? ElevatedButton(
                    onPressed: () {
                      editPhotoActivityDesc(
                          index, dailyActivityPhotosDescEdit.value.text);
                      updateActivityConfirm(
                          File(photo),
                          int.parse(
                              dataJoDailyPhotos.value[index].id!.toString()),
                          dailyActivityPhotosDescEdit.value.text);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        width: double.infinity,
                        child: Center(
                            child: Text(
                          'Save',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ))))
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  void updateActivityConfirm(File foto, int index, String desc) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content:
            Text('Apakah benar anda ingin menyimpan perubahan foto JO ini?'),
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
              var result = await updateActivityDailyPhoto(foto, index, desc);
              if (result == 'success') {
                Get.back();
                openDialog("Success", "Berhasil ubah foto.");
                getJoDailyPhoto();
              } else {
                Get.back();
                openDialog("Failed", "Gagal ubah foto.");
              }
            },
          ),
        ],
      ),
    );
  }

  void deleteActivityDailyPhotoConfirm(int id) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah benar anda ingin menghapus foto JO ini?'),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text(
              "OK",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              Get.back();
              var delete = await deletePhoto(id);
              if (delete == 'success') {
                var index =
                    dataJoDailyPhotos.value.indexWhere((foto) => foto.id == id);
                dataJoDailyPhotos.value.removeAt(index);
                dailyActivityPhotos.value.removeAt(index);
                update();
                Get.back();
              } else {
                openDialog('Failed', 'Gagal hapus foto');
              }
              //sendActivityDailyPhoto();
            },
          ),
        ],
      ),
    );
  }

  Future inspectionMediaPickerConfirm(int index) async {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Photo Attachment',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Pilih sumber foto yang ingin dilampirkan.'),
        actions: [
          Row(
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 68,
                    height: 67,
                    child: ElevatedButton(
                        onPressed: () async {
                          Get.back();
                          var file = await cameraImage();
                          adddailyActivityPhotos(file, '');
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: primaryColor),
                                borderRadius: BorderRadius.circular(12))),
                        child: Center(
                            child: Icon(
                          Icons.camera_alt,
                          color: primaryColor,
                        ))),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 68,
                    height: 68,
                    child: ElevatedButton(
                        onPressed: () async {
                          Get.back();
                          var file = await pickImage();
                          adddailyActivityPhotos(file, '');
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: primaryColor),
                                borderRadius: BorderRadius.circular(12))),
                        child: Center(
                            child: Icon(
                          Icons.folder_rounded,
                          color: primaryColor,
                        ))),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future inspectionMediaPickerConfirmEdit(int index) async {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Photo Attachment',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Pilih sumber foto yang ingin dilampirkan.'),
        actions: [
          Row(
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 68,
                    height: 67,
                    child: ElevatedButton(
                        onPressed: () async {
                          Get.back();
                          var file = await cameraImage();
                          dailyActivityPhotosTemp.value[index] = file;
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: primaryColor),
                                borderRadius: BorderRadius.circular(12))),
                        child: Center(
                            child: Icon(
                          Icons.camera_alt,
                          color: primaryColor,
                        ))),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 68,
                    height: 68,
                    child: ElevatedButton(
                        onPressed: () async {
                          Get.back();
                          var file = await pickImage();
                          dailyActivityPhotosTemp.value[index] = file;
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: primaryColor),
                                borderRadius: BorderRadius.circular(12))),
                        child: Center(
                            child: Icon(
                          Icons.folder_rounded,
                          color: primaryColor,
                        ))),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future inspectionMediaPreviewPickerConfirmEdit(int index) async {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Photo Attachment',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Pilih sumber foto yang ingin dilampirkan.'),
        actions: [
          Row(
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 68,
                    height: 67,
                    child: ElevatedButton(
                        onPressed: () async {
                          Get.back();
                          var file = await cameraImage();
                          dailyActivityPhotos.value[index] = file;
                          activityPreviewFoto.value = file;
                          updateActivityDailyPhoto(
                              file,
                              int.parse(dataJoDailyPhotos.value[index].id!
                                  .toString()),
                              dailyActivityPhotosDescEdit.value.text);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: primaryColor),
                                borderRadius: BorderRadius.circular(12))),
                        child: Center(
                            child: Icon(
                          Icons.camera_alt,
                          color: primaryColor,
                        ))),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 68,
                    height: 68,
                    child: ElevatedButton(
                        onPressed: () async {
                          Get.back();
                          var file = await pickImage();
                          dailyActivityPhotos.value[index] = file;
                          activityPreviewFoto.value = file;
                          updateActivityDailyPhoto(
                              file,
                              int.parse(dataJoDailyPhotos.value[index].id!
                                  .toString()),
                              dailyActivityPhotosDescEdit.value.text);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: primaryColor),
                                borderRadius: BorderRadius.circular(12))),
                        child: Center(
                            child: Icon(
                          Icons.folder_rounded,
                          color: primaryColor,
                        ))),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Activity Inspection Functions

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 1));
    if (picked != null) {
      activityDate.text = DateFormat('yyyy-MM-dd').format(picked).toString();
    }
  }

  Future<String> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      //DateTime date = DateTime.now();
      //String second = date.second.toString().padLeft(2, '0');
      List timeSplit = picked.format(context).split(' ');
      String formattedTime = timeSplit[0];
      String time = '$formattedTime:00';
      return time;
    } else {
      return '';
    }
  }

  void addActivity() {
    if (activityList.value.isEmpty) {
      activityListTextController.value.add(TextEditingController());
    } else {
      if (activityList.value.last.transDate != activityDate.text) {
        activityListTextController.value.add(TextEditingController());
      }
    }

    // ambil remarks berdasarkan grouping activity dari transdate, ambil last remarks nya

    activityList.value.add(Activity(
      id: 0,
      code: '',
      tHJoId: id,
      stageId: 0,
      stageCode: '',
      mStatusinspectionstagesId: activityStage,
      transDate: activityDate.text,
      startActivityTime: activityStartTime.text,
      endActivityTime: activityEndTime.text,
      activity: activityText.text,
      createdBy: 0,
      remarks: '',
      createdAt: '',
      updatedBy: 0,
      updatedAt: '',
      isActive: 0,
      isUpload: 0,
    ));

    activityDate.text = '';
    activityStartTime.text = '';
    activityEndTime.text = '';
    activityText.text = '';
    update();

    debugPrint('activities: ${jsonEncode(activityList)}');
  }

  void toggleEditActivity(int index) {
    activityDate.text = activityList.value[index].transDate!;
    activityStartTime.text = activityList.value[index].startActivityTime!;
    activityEndTime.text = activityList.value[index].endActivityTime!;
    activityText.text = activityList.value[index].activity!;
    editActivityMode.value = true;
    editActivityIndex.value = index;
    update();
  }

  void editActivity() {
    activityList.value[editActivityIndex.value] = Activity(
      id: activityList.value[editActivityIndex.value].id ?? 0,
      code: activityList.value[editActivityIndex.value].code ?? '',
      tHJoId: id,
      stageId: activityList.value[editActivityIndex.value].stageId ?? 0,
      stageCode: activityList.value[editActivityIndex.value].stageCode ?? '',
      mStatusinspectionstagesId: activityStage,
      transDate: activityDate.text,
      startActivityTime: activityStartTime.text,
      endActivityTime: activityEndTime.text,
      activity: activityText.text,
      createdBy: userData.value!.id,
      remarks: activityList.value[editActivityIndex.value].remarks ?? '',
      createdAt: activityList.value[editActivityIndex.value].createdAt,
      updatedBy: activityList.value[editActivityIndex.value].updatedBy,
      updatedAt: activityList.value[editActivityIndex.value].updatedAt,
      isActive: activityList.value[editActivityIndex.value].isActive,
      isUpload: activityList.value[editActivityIndex.value].isUpload,
    );
    editActivityMode.value = false;
    activityDate.text = '';
    activityStartTime.text = '';
    activityEndTime.text = '';
    activityText.text = '';
    update();
    debugPrint('data activity item yang mau di edit: ${jsonEncode(activityList.value[editActivityIndex.value])}');
  }

  void editActivityRemarks(String date, String val, int index) {
    final TextEditingController remarksController =
        activityListTextController[index];
    debugPrint('text controller value : ${remarksController.text}');
    for (var i = 0; i < activityList.value.length; i++) {
      if (activityList.value[i].transDate.toString() == date) {
        activityList.value[i] = Activity(
          id: activityList.value[i].id,
          code: activityList.value[i].code,
          tHJoId: id,
          stageId: activityList.value[i].stageId ?? 0,
          stageCode: activityList.value[i].stageCode ?? '',
          mStatusinspectionstagesId: activityList.value[i].mStatusinspectionstagesId,
          transDate: activityList.value[i].transDate,
          startActivityTime: activityList.value[i].startActivityTime,
          endActivityTime: activityList.value[i].endActivityTime,
          activity: activityList.value[i].activity,
          createdBy: userData.value!.id,
          remarks: remarksController.text,
          createdAt: activityList.value[i].createdAt,
          updatedBy: activityList.value[i].updatedBy,
          updatedAt: activityList.value[i].updatedAt,
          isActive: activityList.value[i].isActive,
          isUpload: activityList.value[i].isUpload,
        );
      }
    }
  }

  void checkActivityList() {
    debugPrint('activities now: ${jsonEncode(activityList)}');
  }

  Future<void> removeActivity(int indexitem, int index, int stage) async {
    var dateLength = activityList.value
        .where((item) =>
    item.transDate == activityList.value[indexitem].transDate &&
        item.mStatusinspectionstagesId == stage)
        .length;
    if (dateLength == 1) {
      activityListTextController.value.removeAt(index);
    }
    activityList.value.removeAt(indexitem);
    update();
  }

  Future<void> removeActivityByDate(String date, int indexDate, int stage) async {
    activityList.value.removeWhere((item) =>
    item.transDate == date && item.mStatusinspectionstagesId == stage);
    activityListTextController.value.removeAt(indexDate);
    update();
  }

  Future<void> removeActivityLocal(int indexitem, int index, int stage, int id, String code, int stageId) async {
    debugPrint('id: $id, code: $code');
    if(id != 0 || code != ''){
      try{
        await SqlHelper.deleteActivity(id, code);
        var dateLength = activityList.value
            .where((item) =>
        item.transDate == activityList.value[indexitem].transDate &&
            item.mStatusinspectionstagesId == stage)
            .length;
        if (dateLength == 1) {
          activityListTextController.value.removeAt(index);
          update();
        }
        activityList.value.removeAt(indexitem);
        update();
      } catch(e) {
        debugPrint('error delete activity: ${e.toString()}');
      }
    } else {
      var dateLength = activityList.value
          .where((item) =>
      item.transDate == activityList.value[indexitem].transDate &&
          item.mStatusinspectionstagesId == stage)
          .length;
      if (dateLength == 1) {
        activityListTextController.value.removeAt(index);
        update();
      }
      activityList.value.removeAt(indexitem);
      update();
    }
    var checkStage = await SqlHelper.getActivityListStage(stageId);
    if(checkStage.length == 0){
      try{
        await SqlHelper.deleteActivityStage(id, code);
      } catch(e) {
        debugPrint('error delete activity stage: ${e.toString()}');
      }
    }
    update();
  }

  Future<void> removeActivityByDateLocal(String date, int indexDate, int stage, int id, String code) async {
    debugPrint('id: $id, code: $code');
    if(id != 0 && code != ''){
      try{
        await SqlHelper.deleteActivityStage(id, code);
        activityList.value.removeWhere((item) =>
        item.transDate == date && item.mStatusinspectionstagesId == stage);
        activityListTextController.value.removeAt(indexDate);
        update();
      } catch(e) {
        debugPrint('error delete activity stage: ${e.toString()}');
      }
    } else {
      activityList.value.removeWhere((item) =>
      item.transDate == date && item.mStatusinspectionstagesId == stage);
      activityListTextController.value.removeAt(indexDate);
      update();
    }
    update();
  }

  Map<String, List<Activity>> groupActivitiesByTransDate(RxList<Activity> activityList) {
    // Create a Map to store the grouped activities
    Map<String, List<Activity>> groupedActivities = {};

    // Iterate through each activity in the RxList
    for (var activity in activityList) {
      // Get the trans_date of the current activity
      String transDate = activity.transDate ?? "UnknowDate";

      // If the trans_date key doesn't exist in the Map, create it
      if (!groupedActivities.containsKey(transDate)) {
        groupedActivities[transDate] = [];
      }
      // Add the activity to the corresponding group
      groupedActivities[transDate]!.add(activity);
    }
    return groupedActivities;
  }

  Future<String?> editActivityStages() async {
    if (activityList.value
        .where((data) => data.mStatusinspectionstagesId == activityStage)
        .toList()
        .isNotEmpty) {
      debugPrint('data editan untuk edit : ${jsonEncode(activityList.value)}');
      for(var item in activityList.value){
        debugPrint("item result ${jsonEncode(item)}");
        debugPrint("item edit ${item.transDate}");
        final db = await SqlHelper.db();
        List<Map<String, dynamic>> result = await db.query(
          't_d_jo_inspection_activity_stages',
          where: 'trans_date = ? AND m_statusinspectionstages_id = ?', // Menggunakan AND untuk lebih dari satu kondisi
          whereArgs: [item.transDate, item.mStatusinspectionstagesId], // Masukkan argumen untuk id dan name
          limit: 1, // Limit untuk mendapatkan satu hasil saja
        );

        if(result.isNotEmpty){
          TDJoInspectionAcitivityStages header = TDJoInspectionAcitivityStages.fromJson(result.first);
          // update remarks, isactive,updated_at,updated_by
          //table t_d_jo_inspection_activity_stages dengan model TDJoInspectionAcitivityStages
          header = header.copyWith(
            remarks: item.remarks, // Update remarks dengan nilai baru
            isActive: "1", // Update status aktif
            updatedAt: DateTime.now().toIso8601String(), // Update waktu dengan waktu saat ini
            updatedBy: userData.value!.id.toString(), // Update dengan ID user yang melakukan update
          );

        }

      }
      var actDate = activityList.value
          .map((item) {
        return item.transDate;
      })
          .toSet()
          .toList();
      debugPrint('dates : ${jsonEncode(actDate)}');
      var actRemarks = activityList.value
          .map((item) {
        return item.remarks;
      })
          .toSet()
          .toList();
      debugPrint('dates remarks : ${jsonEncode(actRemarks)}');
      var itemCount = 0;
      var itemActCount = 0;

      // if(actDate.length == actRemarks.length){
      //   itemCount++;
      //
      //   for(var i = 0; i < actRemarks.length; i++){
      //     debugPrint('date : ${actDate[i]}');
      //     debugPrint('remarks : ${actRemarks[i]}');
      //     var activity = activityList.value.where((act) => act.transDate == actDate[i] && act.mStatusinspectionstagesId == activityStage).toList();
      //     debugPrint('activity di edit: ${jsonEncode(activity)}');
      //     for(var item in activity) {
      //       debugPrint('Activity - ${jsonEncode(item)}');
      //     }
      //     // for(var item in activity){
      //     //   itemActCount++;
      //     //   if(item.stageId!.toInt() != 0){
      //     //     debugPrint('yang mau dikirm kondisi stage id tidak 0 : ${actDate[i]!} ${userData.value!.id!.toInt()} ${item.stageId!.toInt()}');
      //     //     var checkId = await SqlHelper.getActivityStageId(actDate[i]!, userData.value!.id!.toInt(), item.stageId!.toInt());
      //     //     if(checkId.isNotEmpty && checkId.length == 1){
      //     //       var updateStage = await postUpdateActivityStageLocal(item.stageId!.toInt(), actRemarks[i]  ?? '', checkId.first['code'] ?? '');
      //     //       if(updateStage != 'success'){
      //     //         debugPrint('Problem with sending update SQL Activity Stage Item');
      //     //       }
      //     //       var checkActId = await SqlHelper.getActivityId( userData.value!.id!.toInt(), item.id?.toInt() ?? 0, item.code ?? '');
      //     //       if(checkActId.isNotEmpty && checkId.length > 0){
      //     //         var updateAct = await postUpdateActivityLocal(item.id!.toInt(), item.stageId!.toInt(), item.startActivityTime!, item.endActivityTime!, item.activity!, item.code!);
      //     //         if(updateAct != 'success'){
      //     //           debugPrint('Problem with sending update SQL Activity Item');
      //     //         }
      //     //       } else if(checkActId.isEmpty || checkId.length == 0) {
      //     //         var time = DateFormat('yyyyMMddHms').format(DateTime.now());
      //     //         var code = 'JOAIDA-${userData.value!.id!}-${time.toString()}$itemActCount';
      //     //         var sendAct = await postInsertActivityLocal(checkId.first['id'], item.startActivityTime!,item.endActivityTime!,item.activity!,code,userData.value!.id!.toInt());
      //     //         if(sendAct != 'success'){
      //     //           debugPrint('Problem with sending SQL Activity Item');
      //     //         }
      //     //       }
      //     //     }
      //     //     // else {
      //     //     //   var time = DateFormat('yyyyMMddHms').format(DateTime.now());
      //     //     //   var code = 'JOAID-${userData.value!.nip!}-${time.toString()}$itemCount';
      //     //     //   var sendStage = await postInsertActivityStageLocal(actDate[i]!, actRemarks[i]!, code );
      //     //     //   if(sendStage != 'success'){
      //     //     //     debugPrint('Problem with sending SQL Activity Stage');
      //     //     //   } else {
      //     //     //       var time = DateFormat('yyyyMMddHms').format(DateTime.now());
      //     //     //       var code = 'JOAIDA-${userData.value!.nip!}-${time.toString()}$itemCount';
      //     //     //       var stageAct = await SqlHelper.getActivityStage(actDate[i]!, userData.value!.id!.toInt());
      //     //     //       var sendAct = await postInsertActivityLocal(stageAct.first['id'], item.startActivityTime!,item.endActivityTime!,item.activity!,code,userData.value!.id!.toInt());
      //     //     //       if(sendAct != 'success'){
      //     //     //         debugPrint('Problem with sending SQL Activity Item');
      //     //     //       }
      //     //     //   }
      //     //     // }
      //     //   } else if(item.stageId == null || item.stageId!.toInt() == 0) {
      //     //     var time = DateFormat('yyyyMMddHms').format(DateTime.now());
      //     //     var code = 'JOAID-${userData.value!.id!}-${time.toString()}$itemCount';
      //     //     var sendStage = await postInsertActivityStageLocal(actDate[i]!, actRemarks[i]!, code );
      //     //     if(sendStage != 'success'){
      //     //       debugPrint('Problem with sending SQL Activity Stage');
      //     //     } else {
      //     //       var time = DateFormat('yyyyMMddHms').format(DateTime.now());
      //     //       var code = 'JOAIDA-${userData.value!.id!}-${time.toString()}$itemCount';
      //     //       var stageAct = await SqlHelper.getActivityStage(actDate[i]!, userData.value!.id!.toInt());
      //     //       var sendAct = await postInsertActivityLocal(stageAct.first['id'], item.startActivityTime!,item.endActivityTime!,item.activity!,code,userData.value!.id!.toInt());
      //     //       if(sendAct != 'success'){
      //     //         debugPrint('Problem with sending SQL Activity Item');
      //     //       }
      //     //     }
      //     //   }
      //     // }
      //     // itemActCount = 0;
      //   }
      // }

      // check ui
      activityListStages.value
          .removeWhere((act) => act.mStatusinspectionstagesId == activityStage);
      for (var item in activityList.value) {
        activityListStages.value.add(item);
      }
      activityList.value = [];
      activityListTextController.value = [];
      editActivityMode.value = false;
      activityDate.text = '';
      activityStartTime.text = '';
      activityEndTime.text = '';
      activityText.text = '';

      await getJoDailyActivity();
      // activityStage--;
      update();

      //activitySubmitted.value = true;
      return 'success';
    } else if (activityList.value
        .where((data) => data.mStatusinspectionstagesId == activityStage)
        .toList()
        .isEmpty) {
      return 'failed';
    }
  }

  Future<String?> addActivityStages() async {
    if (activityList.value
        .where((data) => data.mStatusinspectionstagesId == activityStage)
        .toList()
        .isNotEmpty) {
      var itemCount = 0;
      var itemActCount = 0;
      var actDate = activityList.value
          .map((item) {
        return item.transDate;
      })
          .toSet()
          .toList();
      var actRemarks = activityList.value
          .map((item) {
        return item.remarks;
      })
          .toSet()
          .toList();

      if(actDate.length == actRemarks.length){
        itemCount++;
        for(var i = 0; i < actRemarks.length; i++){
          debugPrint('date : ${actDate[i]}');
          var time = DateFormat('yyyyMMddHms').format(DateTime.now());
          var code = 'JOAID-${userData.value!.id!}-${time.toString()}$itemCount';
          var sendStage = await postInsertActivityStageLocal(actDate[i]!, actRemarks[i]!, code );
          if(sendStage != 'success'){
            debugPrint('Problem with sending SQL Activity Stage');
          } else {
            activityList.value.where((item) => item.transDate == actDate[i]).forEach((actItem)async{
              itemActCount++;
              var time = DateFormat('yyyyMMddHms').format(DateTime.now());
              var code = 'JOAIDA-${userData.value!.id!}-${time.toString()}$itemActCount';
              var stageAct = await SqlHelper.getActivityStage(actDate[i]!, userData.value!.id!.toInt());
              var sendAct = await postInsertActivityLocal(stageAct.first['id'], actItem.startActivityTime!,actItem.endActivityTime!,actItem.activity!,code,userData.value!.id!.toInt());
              if(sendAct != 'success'){
                debugPrint('Problem with sending SQL Activity Item');
              }
            });
            itemActCount = 0;
          }
        }
      }

      // var post = activityList.value
      //     .map((value) => Activity(
      //           tHJoId: value.tHJoId,
      //           mStatusinspectionstagesId: value.mStatusinspectionstagesId,
      //           transDate: value.transDate,
      //           startActivityTime: value.startActivityTime,
      //           endActivityTime: value.endActivityTime,
      //           activity: value.activity,
      //           createdBy: value.createdBy,
      //           remarks: value.remarks,
      //         ).toJson())
      //     .toList();

      // var send = await postInsertActivity(post);
      // if (send == 'success') {
      //   changeStatusJo();
      //   //activityStage++;
      //   for (var item in activityList.value) {
      //     activityListStages.value.add(item);
      //   }
      //   activityList.value = [];
      //   activityListTextController.value = [];
      //   editActivityMode.value = false;
      //   activityDate.text = '';
      //   activityStartTime.text = '';
      //   activityEndTime.text = '';
      //   activityText.text = '';
      // } else {
      //   return 'failed';
      // }

      // test ui
      for (var item in activityList.value) {
        activityListStages.value.add(item);
      }
      activityList.value = [];
      activityListTextController.value = [];
      editActivityMode.value = false;
      activityDate.text = '';
      activityStartTime.text = '';
      activityEndTime.text = '';
      activityText.text = '';

      activitySubmitted.value = true;
       await getJoDailyActivityLocal();
      // activityStage--;
      update();
      return 'success';
    } else if (activityList.value
        .where((data) => data.mStatusinspectionstagesId == activityStage)
        .toList()
        .isEmpty) {
      return 'failed';
    }
  }

  Future<String> postInsertActivity(data) async {
    var response = await repository.insertActivityInspection(data) ??
        ResponseJoInsertActivity();
    debugPrint('insert activity response: ${jsonEncode(response.message)}');
    if (response.message == 'Inspection berhasil ditambahkan.') {
      return 'success';
    } else {
      return 'failed';
    }
  }

  Future<String> postInsertActivityStageLocal(String transDate, String remarks, String code ) async {
    try{
      var time = DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now());
      await SqlHelper.insertActivityStage(id, activityStage, transDate, remarks, code, userData.value!.id!.toInt(), time.toString());
      return 'success';
    } catch(e) {
      return 'failed';
    }
  }

  Future<String> postInsertActivityLocal(int actStageId, String startTime, String endTime, String activity, String code, int idEmployee) async {
    try{
      var time = DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now());
      await SqlHelper.insertActivity(id, actStageId, startTime, endTime, activity, code, userData.value!.id!.toInt(), time);
      return 'success';
    } catch(e) {
      return 'failed';
    }
  }

  Future<void> validateActivityForm() async {
    if(activityDate.text == null || activityDate.text.isEmpty){
      activityDateValidate = false;
      update();
    }
    if(activityStartTime.text == null || activityStartTime.text.isEmpty){
      activityStartTimeValidate = false;
      update();
    }
    if(activityText.text == null || activityText.text.isEmpty){
      activityTextValidate = false;
      update();
    }
  }

  void drawerDailyActivity() {
    Get.bottomSheet(
        GetBuilder(
          init: JoDetailController(),
          builder: (controller) => Container(
              margin: EdgeInsets.only(top: 48),
              padding: EdgeInsets.all(24),
              width: double.infinity,
              height: 800,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      topLeft: Radius.circular(24))),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Stage Inspection',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Stage ${activityStage}: ${activityStages[activityStage - 1]}',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    showCursor: true,
                                    readOnly: true,
                                    controller: activityDate,
                                    cursorColor: onFocusColor,
                                    onTap: () {
                                      selectDate(Get.context!);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Field wajib diisi!';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(color: onFocusColor),
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              selectDate(Get.context!);
                                            },
                                            icon: Icon(Icons.calendar_today_rounded
                                            )),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: activityDateValidate == true ? onFocusColor : Colors.red),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        labelText: 'Date*',
                                        floatingLabelStyle:
                                        const TextStyle(color: onFocusColor),
                                        fillColor: onFocusColor),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text('Detail Activities'),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: activityStartTime,
                                          cursorColor: activityStartTimeValidate == true ? onFocusColor : Colors.red,
                                          onTap: () async {
                                            activityStartTime.text =
                                            await selectTime(Get.context!);
                                          },
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Field wajib diisi!';
                                            }
                                            return null;
                                          },
                                          style: const TextStyle(color: onFocusColor),
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: onFocusColor),
                                                borderRadius:
                                                BorderRadius.circular(12),
                                              ),
                                              labelText: 'Start Time*',
                                              floatingLabelStyle: const TextStyle(
                                                  color: onFocusColor),
                                              fillColor: onFocusColor),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: activityEndTime,
                                          cursorColor: onFocusColor,
                                          onTap: () async {
                                            activityEndTime.text =
                                            await selectTime(Get.context!);
                                          },
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Field wajib diisi!';
                                            }
                                            return null;
                                          },
                                          style: const TextStyle(color: onFocusColor),
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: onFocusColor),
                                                borderRadius:
                                                BorderRadius.circular(12),
                                              ),
                                              labelText: 'End Time*',
                                              floatingLabelStyle: const TextStyle(
                                                  color: onFocusColor),
                                              fillColor: onFocusColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(150),
                                    ],
                                    controller: activityText,
                                    cursorColor: onFocusColor,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Field wajib diisi!';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(color: onFocusColor),
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                          const BorderSide(color: onFocusColor),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        labelText: 'Activity*',
                                        floatingLabelStyle:
                                        const TextStyle(color: onFocusColor),
                                        fillColor: onFocusColor),
                                  ),
                                ]),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            InkWell(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (editActivityMode.value == false) {
                                    addActivity();
                                  } else {
                                    editActivity();
                                  }
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 8),
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Icon(
                                    editActivityMode.value == false
                                        ? Icons.add
                                        : Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            activityList.value.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: activityList.value
                                        .map((item) {
                                          return item.transDate;
                                        })
                                        .toSet()
                                        .toList()
                                        .length,
                                    itemBuilder: (context, index) {
                                      var activity = activityList.value
                                          .map((item) {
                                            return item.transDate;
                                          })
                                          .toSet()
                                          .toList()[index];
                                      return Column(
                                        children: [
                                          Card(
                                            color: Colors.white,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                  top: 8,
                                                  bottom: 16),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          'Date',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ),
                                                      VerticalDivider(width: 1),
                                                      SizedBox(width: 16),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child: Text(
                                                                activity ?? '-',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                                onTap: () {
                                                                  if (activity !=
                                                                      null) {
                                                                    removeActivityByDateConfirm(
                                                                        activity,
                                                                        index,
                                                                        activityStage);
                                                                  }
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .delete_forever,
                                                                  color: Colors
                                                                      .red,
                                                                ))
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 16),
                                                  ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount: activityList
                                                          .value.length,
                                                      itemBuilder:
                                                          (context, indexItem) {
                                                        if (activityList
                                                                .value[
                                                                    indexItem]
                                                                .transDate ==
                                                            activity) {
                                                          return Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child: Text(
                                                                  'Activities',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                              ),
                                                              VerticalDivider(
                                                                  width: 1),
                                                              SizedBox(
                                                                  width: 8),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Text(
                                                                  '${activityList.value[indexItem].startActivityTime ?? '-'} - ${activityList.value[indexItem].endActivityTime ?? '-'}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                              ),
                                                              VerticalDivider(
                                                                  width: 1),
                                                              SizedBox(
                                                                  width: 8),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        activityList.value[indexItem].activity ??
                                                                            '-',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                        onTap:
                                                                            () {
                                                                          toggleEditActivity(
                                                                              indexItem);
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .mode_edit_outlined,
                                                                          color:
                                                                              primaryColor,
                                                                        )),
                                                                    InkWell(
                                                                        onTap:
                                                                            () {
                                                                          removeActivityConfirm(
                                                                              activity!,
                                                                              indexItem,
                                                                              index,
                                                                              activityStage
                                                                          );
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .delete_forever,
                                                                          color:
                                                                              Colors.red,
                                                                        ))
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        } else {
                                                          return const SizedBox();
                                                        }
                                                      }),
                                                  const Divider(),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  index <
                                                          (activityListTextController
                                                              .value.length)
                                                      ? TextFormField(
                                                          inputFormatters: [
                                                            LengthLimitingTextInputFormatter(
                                                                250),
                                                          ],
                                                          controller:
                                                              activityListTextController[
                                                                  index],
                                                          onChanged: (value) {
                                                            debugPrint(value);
                                                            debugPrint(
                                                                'text remarks controller : ${activityListTextController[index].text}');
                                                            editActivityRemarks(
                                                                activity!,
                                                                value,
                                                                index);
                                                          },
                                                          cursorColor:
                                                              onFocusColor,
                                                          style: const TextStyle(
                                                              color:
                                                                  onFocusColor),
                                                          decoration:
                                                              InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(
                                                                            color:
                                                                                onFocusColor),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                  ),
                                                                  labelText:
                                                                      'Remarks',
                                                                  floatingLabelStyle:
                                                                      const TextStyle(
                                                                          color:
                                                                              onFocusColor),
                                                                  fillColor:
                                                                      onFocusColor),
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    })
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                checkActivityList();
                                cleanActivity();
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(color: primaryColor),
                                      borderRadius: BorderRadius.circular(12))),
                              child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  width: double.infinity,
                                  child: Center(
                                      child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )))),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                Get.back();
                                addActivityStageConfirm();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  width: double.infinity,
                                  child: Center(
                                      child: Text(
                                    'Submit',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )))),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              )),
        ),
        isScrollControlled: true);
  }

  void addActivityStageConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text(
            'Apakah benar anda akan submit stage ${activityStages[activityStage - 1]} ini? pastikan data yg anda input benar.'),
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
              var result = await addActivityStages();
              if (result == 'success') {
                Get.back();
                //openDialog("Success", "Activity Stage ${activityStage-1} berhasil ditambahkan");
                if (activityStage == 1) {
                  changeStatusJo();
                }
              } else {
                Get.back();
                openDialog("Failed",
                    "Activity Stage $activityStage masih kosong atau belum diinput");
              }
            },
          ),
        ],
      ),
    );
  }

  void nextStageActivityConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text(
            'Apakah anda ingin melanjutkan ke stage berikutnya? jika Ya, anda tidak bisa mengubah stage sebelumnya. Pastikan data yang anda input benar.'),
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
              activityStage++;
              activitySubmitted.value = false;
              update();
              Get.back();
            },
          ),
        ],
      ),
    );
  }


  Future<String> postUpdateActivity(data) async {
    var response = await repository.updateActivityInspection(data, id) ??
        ResponseJoInsertActivity();
    debugPrint('insert activity response: ${jsonEncode(response.message)}');
    if (response.message == 'Inspection berhasil ditambahkan.') {
      return 'success';
    } else {
      return 'failed';
    }
  }

  Future<String> postUpdateActivityStageLocal(int id, int idJo, String remarks, String code, int stage, String transDate, int isUpload) async {
    try{
      var time = DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now());
      //await SqlHelper.updateActivityStage(id, idJo, remarks, userData.value!.id!.toInt(), time, code, stage, transDate, isUpload);
      return 'success';
    } catch(e) {
      return 'failed';
    }
  }

  Future<String> postUpdateActivityLocal(int id,int idActStage,String startTime,String endTime,String activity,String code) async {
    try{
      var time = DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now());
      await SqlHelper.updateActivity(id, idActStage, startTime, endTime, activity, code, userData.value!.id!.toInt(), time);
      return 'success';
    } catch(e) {
      return 'failed';
    }
  }

  void drawerDailyActivityEdit(int stage) {
    activityList.value = activityListStages.value
        .where((item) => item.mStatusinspectionstagesId == activityStage)
        .toList();
    var activityEditTemp = activityList.value
        .map((item) {
          return item.transDate;
        })
        .toSet()
        .toList();
    activityEditTemp.forEach((item) {
      var text = activityList.value.lastWhere((act) => act.transDate == item);
      activityListTextController.value
          .add(TextEditingController(text: text.remarks));
    });
    update();
    debugPrint('data yang mau di edit: ${jsonEncode(activityList.value)}');
    Get.bottomSheet(
        GetBuilder(
          init: JoDetailController(),
          builder: (controller) => Container(
              margin: EdgeInsets.only(top: 48),
              padding: EdgeInsets.all(24),
              width: double.infinity,
              height: 800,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      topLeft: Radius.circular(24))),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit Stage Inspection',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Stage ${activityStage}: ${activityStages[activityStage - 1]}',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    showCursor: true,
                                    readOnly: true,
                                    controller: activityDate,
                                    cursorColor: onFocusColor,
                                    onTap: () {
                                      selectDate(Get.context!);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Field wajib diisi!';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(color: onFocusColor),
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              selectDate(Get.context!);
                                            },
                                            icon: const Icon(
                                                Icons.calendar_today_rounded)),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                          const BorderSide(color: onFocusColor),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        labelText: 'Date*',
                                        floatingLabelStyle:
                                        const TextStyle(color: onFocusColor),
                                        fillColor: onFocusColor),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text('Detail Activities'),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: activityStartTime,
                                          cursorColor: onFocusColor,
                                          onTap: () async {
                                            activityStartTime.text =
                                            await selectTime(Get.context!);
                                          },
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Field wajib diisi!';
                                            }
                                            return null;
                                          },
                                          style: const TextStyle(color: onFocusColor),
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: onFocusColor),
                                                borderRadius:
                                                BorderRadius.circular(12),
                                              ),
                                              labelText: 'Start Time*',
                                              floatingLabelStyle: const TextStyle(
                                                  color: onFocusColor),
                                              fillColor: onFocusColor),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: activityEndTime,
                                          cursorColor: onFocusColor,
                                          onTap: () async {
                                            activityEndTime.text =
                                            await selectTime(Get.context!);
                                          },
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Field wajib diisi!';
                                            }
                                            return null;
                                          },
                                          style: const TextStyle(color: onFocusColor),
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: onFocusColor),
                                                borderRadius:
                                                BorderRadius.circular(12),
                                              ),
                                              labelText: 'End Time*',
                                              floatingLabelStyle: const TextStyle(
                                                  color: onFocusColor),
                                              fillColor: onFocusColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(150),
                                    ],
                                    controller: activityText,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Field wajib diisi!';
                                      }
                                      return null;
                                    },
                                    cursorColor: onFocusColor,
                                    style: const TextStyle(color: onFocusColor),
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                          const BorderSide(color: onFocusColor),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        labelText: 'Activity*',
                                        floatingLabelStyle:
                                        const TextStyle(color: onFocusColor),
                                        fillColor: onFocusColor),
                                  ),
                                ]
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  if (editActivityMode.value == false) {
                                    addActivity();
                                  } else {
                                    editActivity();
                                  }
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 8),
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Icon(
                                    editActivityMode.value == false
                                        ? Icons.add
                                        : Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            activityList.value.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: activityList.value
                                        .map((item) {
                                          return item.transDate;
                                        })
                                        .toSet()
                                        .toList()
                                        .length,
                                    itemBuilder: (context, index) {
                                      var activity = activityList.value
                                          .map((item) {
                                            return item.transDate;
                                          })
                                          .toSet()
                                          .toList()[index];
                                      return Column(
                                        children: [
                                          Card(
                                            color: Colors.white,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                  top: 8,
                                                  bottom: 16),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          'Date',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ),
                                                      VerticalDivider(width: 1),
                                                      SizedBox(width: 16),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child: Text(
                                                                activity ?? '-',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                                onTap: () {
                                                                  if (activity !=
                                                                      null) {
                                                                    removeActivityByDateConfirmLocal(
                                                                        activity,
                                                                        index,
                                                                        activityStage,
                                                                        activityList.value[index].stageId?.toInt() ?? 0,
                                                                        activityList.value[index].stageCode ?? ''
                                                                    );
                                                                  }
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .delete_forever,
                                                                  color: Colors
                                                                      .red,
                                                                ))
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 16),
                                                  ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount: activityList
                                                          .value.length,
                                                      itemBuilder:
                                                          (context, indexItem) {
                                                        if (activityList
                                                                .value[
                                                                    indexItem]
                                                                .transDate ==
                                                            activity) {
                                                          return Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child: Text(
                                                                  'Activities',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                              ),
                                                              VerticalDivider(
                                                                  width: 1),
                                                              SizedBox(
                                                                  width: 8),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Text(
                                                                  '${activityList.value[indexItem].startActivityTime ?? '-'} - ${activityList.value[indexItem].endActivityTime ?? '-'}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                              ),
                                                              VerticalDivider(
                                                                  width: 1),
                                                              SizedBox(
                                                                  width: 8),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        activityList.value[indexItem].activity ??
                                                                            '-',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                        onTap:
                                                                            () {
                                                                          toggleEditActivity(
                                                                              indexItem);
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .mode_edit_outlined,
                                                                          color:
                                                                              primaryColor,
                                                                        )),
                                                                    InkWell(
                                                                        onTap:
                                                                            () {
                                                                          removeActivityConfirmLocal(
                                                                              activity!,
                                                                              indexItem,
                                                                              index,
                                                                              activityStage,
                                                                              activityList.value[indexItem].id?.toInt() ?? 0,
                                                                              activityList.value[indexItem].code ?? '',
                                                                              activityList.value[indexItem].stageId?.toInt() ?? 0
                                                                          );
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .delete_forever,
                                                                          color:
                                                                              Colors.red,
                                                                        ))
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        } else {
                                                          return const SizedBox();
                                                        }
                                                      }),
                                                  const Divider(),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  index <
                                                          (activityListTextController
                                                              .value.length)
                                                      ? TextFormField(
                                                          inputFormatters: [
                                                            LengthLimitingTextInputFormatter(
                                                                250),
                                                          ],
                                                          controller:
                                                              activityListTextController[
                                                                  index],
                                                          onChanged: (value) {
                                                            debugPrint(value);
                                                            debugPrint(
                                                                'text remarks controller : ${activityListTextController[index].text}');
                                                            editActivityRemarks(
                                                                activity!,
                                                                value,
                                                                index);
                                                          },
                                                          cursorColor:
                                                              onFocusColor,
                                                          style: const TextStyle(
                                                              color:
                                                                  onFocusColor),
                                                          decoration:
                                                              InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(
                                                                            color:
                                                                                onFocusColor),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                  ),
                                                                  labelText:
                                                                      'Remarks',
                                                                  floatingLabelStyle:
                                                                      const TextStyle(
                                                                          color:
                                                                              onFocusColor),
                                                                  fillColor:
                                                                      onFocusColor),
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    })
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                checkActivityList();
                                cleanActivity();
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(color: primaryColor),
                                      borderRadius: BorderRadius.circular(12))),
                              child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  width: double.infinity,
                                  child: Center(
                                      child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )))),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                Get.back();
                                editActivityStageConfirm();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  width: double.infinity,
                                  child: Center(
                                      child: Text(
                                    'Submit',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )))),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              )),
        ),
        isScrollControlled: true);
  }

  void editActivityStageConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text(
            'Apakah benar anda akan menyimpan perubahan stage ${activityStages[activityStage - 1]} ini? pastikan data yg anda input benar.'),
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
              var result = await editActivityStages();
              if (result == 'success') {
                Get.back();
                //openDialog("Success", "Activity Stage ${activityStage-1} berhasil ditambahkan");
              } else {
                Get.back();
                openDialog("Failed",
                    "Activity Stage $activityStage masih kosong atau belum diinput");
              }
            },
          ),
        ],
      ),
    );
  }

  void removeActivityConfirm(String date, int indexitem, int index, int stage) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah anda ingin menghapus activity date $date'),
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
              await removeActivity(indexitem, index, stage);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void removeActivityByDateConfirm(String date, int indexDate, int stage) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah anda ingin menghapus activity date $date'),
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
              await removeActivityByDate(date, indexDate, stage);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void removeActivityConfirmLocal(String date, int indexitem, int index, int stage, int id, String code, int stageId) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah anda ingin menghapus activity date $date'),
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
              await removeActivityLocal(indexitem, index, stage, id, code, stageId);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void removeActivityByDateConfirmLocal(String date, int indexDate, int stage, int stageId, String code) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah anda ingin menghapus activity date $date'),
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
              await removeActivityByDateLocal(date, indexDate, stage, stageId, code);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void cleanActivity(){
    activityList.value = [];
    activityListTextController.value = [];
    editActivityMode.value = false;
    activityDate.text = '';
    activityStartTime.text = '';
    activityEndTime.text = '';
    activityText.text = '';
  }

  // Activity 5 Inspection Functions

  Future<void> selectInitialDate5(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 1));
    if (picked != null) {
      initialDateActivity5ListTextController.value[index].text =
          DateFormat('yyyy-MM-dd').format(picked).toString();
    }
  }

  Future<void> selectFinalDate5(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 1));
    if (picked != null) {
      finalDateActivity5ListTextController.value[index].text =
          DateFormat('yyyy-MM-dd').format(picked).toString();
    }
  }

  void addBargeForm() {
    bargesController.value.add(TextEditingController());
    activity5Barges.value.add('');
    barges.value.add('');
    activity5bargesCount++;
    update();
  }

  void checkActivity5List() {
    debugPrint('activities 5 now: ${jsonEncode(activity5List)}');
  }

  void editBargeForm(int index) {
    barges.value[index] = bargesController.value[index].text;
  }

  void removeBargeForm() {
    bargesController.value.removeLast();
    activity5Barges.value.removeLast();
    activity5bargesCount--;
    update();
  }

  void addActivity5Form() {
    activity5FormCount++;
    jettyListTextController.value.add(TextEditingController());
    initialDateActivity5ListTextController.value.add(TextEditingController());
    finalDateActivity5ListTextController.value.add(TextEditingController());
    deliveryQtyListTextController.value.add(TextEditingController());
    activity5TranshipmentList.value.add(Transhipment());
    update();
  }

  void removeActivity5Form() {
    activity5FormCount--;
    jettyListTextController.value.removeLast();
    initialDateActivity5ListTextController.value.removeLast();
    finalDateActivity5ListTextController.value.removeLast();
    deliveryQtyListTextController.value.removeLast();
    activity5TranshipmentList.value.removeLast();
    update();
  }

  Future addActivity5() async {
    var barge = activity5Barges.value.map((barge) {
      return Barge(barge: barge);
    }).toList();
    activity5List.value.add(FormDataArray(
        tHJoId: id,
        mStatusinspectionstagesId: activityStage,
        uomId: 3,
        transDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        actualQty: qtyController.text,
        createdBy: userData.value!.id,
        vessel: vesselController.text,
        barge: barge,
        transhipment: activity5TranshipmentList.value));
  }

  Future<void> postInsertActivity5(data) async {
    var response = await repository.insertActivityInspection5(data) ??
        ResponseJoInsertActivity5();
    debugPrint('insert activity 5 response: ${jsonEncode(response.message)}');
  }

  void editActivity5Transhipment(int index) {
    activity5TranshipmentList.value[index] = Transhipment(
      jetty: jettyListTextController.value[index].text,
      initialDate: initialDateActivity5ListTextController.value[index].text,
      finalDate: finalDateActivity5ListTextController.value[index].text,
      deliveryQty: deliveryQtyListTextController.value[index].text,
    );
    debugPrint(
        'transhipment list : ${jsonEncode(activity5TranshipmentList.value)}');
  }

  Future<String?> addActivity5Stage() async {
    await addActivity5();
    if (activity5List.value.isNotEmpty) {
      //activityStage++;
      //postInsertActivity5(activity5List);
      for (var item in activity5List.value.toList()) {
        activity5ListStages.value.add(item);
      }
      activitySubmitted.value = true;
      // await getJoDailyActivity5();
      // activityStage--;
      update();
      return 'success';
    } else if (activity5List.value
        .where((data) => data.mStatusinspectionstagesId == activityStage)
        .toList()
        .isEmpty) {
      return 'failed';
    }
  }

  void cleanActivity5() {
    activity5List.value = [];
    jettyListTextController.value = [];
    initialDateActivity5ListTextController.value = [];
    finalDateActivity5ListTextController.value = [];
    deliveryQtyListTextController.value = [];
    activity5bargesCount = bargesCount;
    activity5Barges.value = barges.value;
    bargesCount = 0;
    barges.value = [];
    qtyController.text =
        dataJoDetail.value.detail?.qty.toString() ?? qtyController.text;
    uomController.text =
        dataJoDetail.value.detail?.uomName ?? uomController.text;
    vesselController.text =
        dataJoDetail.value.detail?.vessel ?? vesselController.text;
    activity5FormCount.value = 0;
    activity5TranshipmentList.value = [];
    if (activity5TranshipmentList.value.isEmpty) {
      jettyListTextController.value.add(TextEditingController());
      initialDateActivity5ListTextController.value.add(TextEditingController());
      finalDateActivity5ListTextController.value.add(TextEditingController());
      deliveryQtyListTextController.value.add(TextEditingController());
      activity5TranshipmentList.value.add(Transhipment());
    }
  }

  void drawerDailyActivity5() {
    qtyController.text = dataJoDetail.value.detail!.qty.toString() != null ? dataJoDetail.value.detail!.qty.toString() : '0';
    uomController.text = dataJoDetail.value.detail!.uomName ?? '';
    vesselController.text = dataJoDetail.value.detail!.vessel ?? '';
    if (activity5TranshipmentList.value.isEmpty) {
      jettyListTextController.value.add(TextEditingController());
      initialDateActivity5ListTextController.value.add(TextEditingController());
      finalDateActivity5ListTextController.value.add(TextEditingController());
      deliveryQtyListTextController.value.add(TextEditingController());
      activity5TranshipmentList.value.add(Transhipment());
    }
    Get.bottomSheet(
        GetBuilder(
          init: JoDetailController(),
          builder: (controller) => SizedBox(
            child: Container(
                margin: EdgeInsets.only(top: 48),
                padding: EdgeInsets.all(24),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(24),
                        topLeft: Radius.circular(24))),
                child: Obx(
                  () => Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Stage Inspection',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: primaryColor),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'Stage 5: Work Complete',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(12),
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^(\d+)?\.?\d{0,3}')),
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d*'))
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Field wajib diisi!';
                                    }
                                    return null;
                                  },
                                  controller: qtyController,
                                  cursorColor: onFocusColor,
                                  style: const TextStyle(color: onFocusColor),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Actual Qty*',
                                      floatingLabelStyle:
                                          const TextStyle(color: onFocusColor),
                                      fillColor: onFocusColor),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  controller: uomController,
                                  cursorColor: onFocusColor,
                                  style: const TextStyle(color: onFocusColor),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'UOM',
                                      floatingLabelStyle:
                                          const TextStyle(color: onFocusColor),
                                      fillColor: onFocusColor),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  controller: vesselController,
                                  cursorColor: onFocusColor,
                                  style: const TextStyle(color: onFocusColor),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Vessel',
                                      floatingLabelStyle:
                                          const TextStyle(color: onFocusColor),
                                      fillColor: onFocusColor),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                barges.value.isNotEmpty
                                    ? Column(children: [
                                        ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: activity5bargesCount,
                                            itemBuilder: (context, i) {
                                              bargesController.value[i].text =
                                                  barges.value[i];
                                              return Column(
                                                children: [
                                                  TextFormField(
                                                    controller:
                                                        bargesController.value[i],
                                                    cursorColor: onFocusColor,
                                                    onChanged: (value) {
                                                      editBargeForm(i);
                                                    },
                                                    style: const TextStyle(
                                                        color: onFocusColor),
                                                    decoration: InputDecoration(
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color:
                                                                      onFocusColor),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        labelText:
                                                            'Barge ${i + 1}',
                                                        floatingLabelStyle:
                                                            const TextStyle(
                                                                color:
                                                                    onFocusColor),
                                                        fillColor: onFocusColor),
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                ],
                                              );
                                            }),
                                      ])
                                    : const SizedBox(),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            addBargeForm();
                                          },
                                          style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12),
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12))),
                                          child: SizedBox(
                                              width: double.infinity,
                                              child: Center(
                                                  child: Text(
                                                'Add Barge',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              )))),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    activity5Barges.value.length > 1
                                        ? Expanded(
                                            flex: 1,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  removeBargeForm();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: 12),
                                                    backgroundColor: Colors.red,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12))),
                                                child: SizedBox(
                                                    width: double.infinity,
                                                    child: Center(
                                                        child: Text(
                                                      'Remove Barge',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )))),
                                          )
                                        : const Expanded(
                                            flex: 1, child: SizedBox()),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    const Expanded(flex: 1, child: SizedBox())
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const Divider(),
                                const SizedBox(
                                  height: 16,
                                ),
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: activity5FormCount.value,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'KOS Transhipment Form ${index + 1}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w700,
                                                      color: primaryColor),
                                                ),
                                              ),
                                              index ==
                                                      (activity5FormCount.value -
                                                          1)
                                                  ? Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            addActivity5Form();
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 8),
                                                            height: 42,
                                                            width: 42,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    primaryColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons.add,
                                                                color:
                                                                    Colors.white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        activity5FormCount.value >
                                                                1
                                                            ? InkWell(
                                                                onTap: () {
                                                                  removeActivity5Form();
                                                                },
                                                                child: Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              8),
                                                                  height: 42,
                                                                  width: 42,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .red,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : const SizedBox()
                                                      ],
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          jettyListTextController.value.length > 0
                                              ? TextFormField(
                                                  controller:
                                                      jettyListTextController
                                                          .value[index],
                                                  cursorColor: onFocusColor,
                                                  onChanged: (value) {
                                                    editActivity5Transhipment(
                                                        index);
                                                  },
                                                  style: const TextStyle(
                                                      color: onFocusColor),
                                                  decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    onFocusColor),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12),
                                                      ),
                                                      labelText: 'Jetty',
                                                      floatingLabelStyle:
                                                          const TextStyle(
                                                              color:
                                                                  onFocusColor),
                                                      fillColor: onFocusColor),
                                                )
                                              : const SizedBox(),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller:
                                                initialDateActivity5ListTextController
                                                    .value[index],
                                            cursorColor: onFocusColor,
                                            onTap: () {
                                              selectInitialDate5(context, index);
                                            },
                                            onChanged: (value) {
                                              editActivity5Transhipment(index);
                                            },
                                            style: const TextStyle(
                                                color: onFocusColor),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: onFocusColor),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              labelText: 'Initial Date',
                                              floatingLabelStyle: const TextStyle(
                                                  color: onFocusColor),
                                              fillColor: onFocusColor,
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    selectInitialDate5(
                                                        context, index);
                                                  },
                                                  icon: const Icon(Icons
                                                      .calendar_today_rounded)),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller:
                                                finalDateActivity5ListTextController
                                                    .value[index],
                                            cursorColor: onFocusColor,
                                            onTap: () {
                                              selectFinalDate5(context, index);
                                            },
                                            onChanged: (value) {
                                              editActivity5Transhipment(index);
                                            },
                                            style: const TextStyle(
                                                color: onFocusColor),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: onFocusColor),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              labelText: 'Final Date',
                                              floatingLabelStyle: const TextStyle(
                                                  color: onFocusColor),
                                              fillColor: onFocusColor,
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    selectInitialDate5(
                                                        context, index);
                                                  },
                                                  icon: const Icon(Icons
                                                      .calendar_today_rounded)),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller:
                                                deliveryQtyListTextController
                                                    .value[index],
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  12),
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^(\d+)?\.?\d{0,3}')),
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d*'))
                                            ],
                                            cursorColor: onFocusColor,
                                            onChanged: (value) {
                                              editActivity5Transhipment(index);
                                            },
                                            style: const TextStyle(
                                                color: onFocusColor),
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: onFocusColor),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                labelText: 'Delivery Qty',
                                                floatingLabelStyle:
                                                    const TextStyle(
                                                        color: onFocusColor),
                                                fillColor: onFocusColor),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller: uomController,
                                            enabled: false,
                                            cursorColor: onFocusColor,
                                            style: const TextStyle(
                                                color: onFocusColor),
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: onFocusColor),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                labelText: 'UOM',
                                                floatingLabelStyle:
                                                    const TextStyle(
                                                        color: onFocusColor),
                                                fillColor: onFocusColor),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                        ],
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(color: primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      width: double.infinity,
                                      child: Center(
                                          child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )))),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      addActivityStage5Confirm();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      width: double.infinity,
                                      child: Center(
                                          child: Text(
                                        'Submit',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )))),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ),
        isScrollControlled: true);
  }

  void addActivityStage5Confirm() async {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text(
            'Apakah benar anda akan submit stage work complete ini? pastikan data yg anda input benar.'),
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
              var result = await addActivity5Stage();
              if (result == 'success') {
                Get.back();
                cleanActivity5();
                Get.back();
                //openDialog("Success", "Activity Stage ${activityStage-1} berhasil ditambahkan");
              } else {
                Get.back();
                openDialog("Failed",
                    "Activity Stage $activityStage masih kosong atau belum diinput");
              }
            },
          ),
        ],
      ),
    );
  }

  void nextStageActivity5Confirm() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text(
            'Apakah anda ingin melanjutkan ke stage berikutnya? jika Ya, anda tidak bisa mengubah stage sebelumnya. Pastikan data yang anda input benar.'),
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
              activityStage++;
              activitySubmitted.value = false;
              update();
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Future editActivity5() async {
    var barge = activity5Barges.value.map((barge) {
      return Barge(barge: barge);
    }).toList();
    activity5List.value.first = FormDataArray(
        tHJoId: id,
        mStatusinspectionstagesId: activityStage,
        uomId: 3,
        transDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        actualQty: qtyController.text,
        createdBy: userData.value!.id,
        vessel: vesselController.text,
        barge: barge,
        transhipment: activity5TranshipmentList.value);
  }

  Future<String?> editActivity5Stage() async {
    editActivity5();
    if (activity5List.value.isNotEmpty) {
      //activityStage++;
      //postUpdateActivity5(activity5List);

      activity5ListStages.value = activity5List.value;

      // await getJoDailyActivity5();
      // activityStage--;
      update();
      return 'success';
    } else if (activity5List.value
        .where((data) => data.mStatusinspectionstagesId == activityStage)
        .toList()
        .isEmpty) {
      return 'failed';
    }
  }

  void drawerDailyActivity5Edit() {
    if (activity5List.value.isEmpty) {
      activity5List.value = activity5ListStages.value;
      qtyController.text = activity5List.value.first.actualQty ?? '';
      uomController.text = dataJoDetail.value.detail!.uomName ?? '';
      vesselController.text = activity5List.value.first.vessel ?? '';
      if (activity5List.value.first.barge!.isNotEmpty) {
        activity5List.value.first.barge!.forEach((item) {
          barges.value.add(item.barge.toString());
          bargesController.value.add(TextEditingController(text: item.barge));
          bargesCount++;
          activity5bargesCount++;
          update();
        });
      }
      jettyListTextController.value = [];
      initialDateActivity5ListTextController.value = [];
      finalDateActivity5ListTextController.value = [];
      deliveryQtyListTextController.value = [];
      activity5TranshipmentList.value = [];
      if (activity5List.value.first.transhipment!.isNotEmpty) {
        var transhipment = activity5List.value.first.transhipment!.toList();
        for (var item in transhipment) {
          activity5FormCount++;
          jettyListTextController.value
              .add(TextEditingController(text: item.jetty));
          initialDateActivity5ListTextController.value
              .add(TextEditingController(text: item.initialDate));
          finalDateActivity5ListTextController.value
              .add(TextEditingController(text: item.finalDate));
          deliveryQtyListTextController.value
              .add(TextEditingController(text: item.deliveryQty));
          activity5TranshipmentList.value.add(Transhipment(
              jetty: item.jetty,
              initialDate: item.initialDate,
              finalDate: item.finalDate,
              deliveryQty: item.deliveryQty));
        }
      }
    }
    Get.bottomSheet(
        GetBuilder(
          init: JoDetailController(),
          builder: (controller) => SizedBox(
            child: Container(
                margin: EdgeInsets.only(top: 48),
                padding: EdgeInsets.all(24),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(24),
                        topLeft: Radius.circular(24))),
                child: Obx(
                  () => Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Stage Inspection',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: primaryColor),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'Stage 5: Work Complete',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(12),
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^(\d+)?\.?\d{0,3}')),
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d*'))
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Field wajib diisi!';
                                    }
                                    return null;
                                  },
                                  controller: qtyController,
                                  cursorColor: onFocusColor,
                                  style: const TextStyle(color: onFocusColor),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Actual Qty*',
                                      floatingLabelStyle:
                                          const TextStyle(color: onFocusColor),
                                      fillColor: onFocusColor),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  controller: uomController,
                                  cursorColor: onFocusColor,
                                  style: const TextStyle(color: onFocusColor),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'UOM',
                                      floatingLabelStyle:
                                          const TextStyle(color: onFocusColor),
                                      fillColor: onFocusColor),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  controller: vesselController,
                                  cursorColor: onFocusColor,
                                  style: const TextStyle(color: onFocusColor),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Vessel',
                                      floatingLabelStyle:
                                          const TextStyle(color: onFocusColor),
                                      fillColor: onFocusColor),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                barges.value.isNotEmpty
                                    ? Column(children: [
                                        ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: activity5bargesCount,
                                            itemBuilder: (context, i) {
                                              bargesController.value[i].text =
                                                  barges.value[i];
                                              return Column(
                                                children: [
                                                  TextFormField(
                                                    controller:
                                                        bargesController.value[i],
                                                    cursorColor: onFocusColor,
                                                    onChanged: (value) {
                                                      editBargeForm(i);
                                                    },
                                                    style: const TextStyle(
                                                        color: onFocusColor),
                                                    decoration: InputDecoration(
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color:
                                                                      onFocusColor),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        labelText:
                                                            'Barge ${i + 1}',
                                                        floatingLabelStyle:
                                                            const TextStyle(
                                                                color:
                                                                    onFocusColor),
                                                        fillColor: onFocusColor),
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                ],
                                              );
                                            }),
                                      ])
                                    : const SizedBox(),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            addBargeForm();
                                          },
                                          style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12),
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12))),
                                          child: SizedBox(
                                              width: double.infinity,
                                              child: Center(
                                                  child: Text(
                                                'Add Barge',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              )))),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    activity5Barges.value.length > 1
                                        ? Expanded(
                                            flex: 1,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  removeBargeForm();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: 12),
                                                    backgroundColor: Colors.red,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12))),
                                                child: SizedBox(
                                                    width: double.infinity,
                                                    child: Center(
                                                        child: Text(
                                                      'Remove Barge',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )))),
                                          )
                                        : const Expanded(
                                            flex: 1, child: SizedBox()),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    const Expanded(flex: 1, child: SizedBox())
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const Divider(),
                                const SizedBox(
                                  height: 16,
                                ),
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: activity5FormCount.value,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'KOS Transhipment Form ${index + 1}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w700,
                                                      color: primaryColor),
                                                ),
                                              ),
                                              index ==
                                                      (activity5FormCount.value -
                                                          1)
                                                  ? Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            addActivity5Form();
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 8),
                                                            height: 42,
                                                            width: 42,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    primaryColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons.add,
                                                                color:
                                                                    Colors.white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        activity5FormCount.value >
                                                                1
                                                            ? InkWell(
                                                                onTap: () {
                                                                  removeActivity5Form();
                                                                },
                                                                child: Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              8),
                                                                  height: 42,
                                                                  width: 42,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .red,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : const SizedBox()
                                                      ],
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          jettyListTextController.value.length > 0
                                              ? TextFormField(
                                                  controller:
                                                      jettyListTextController
                                                          .value[index],
                                                  cursorColor: onFocusColor,
                                                  onChanged: (value) {
                                                    editActivity5Transhipment(
                                                        index);
                                                  },
                                                  style: const TextStyle(
                                                      color: onFocusColor),
                                                  decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    onFocusColor),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12),
                                                      ),
                                                      labelText: 'Jetty',
                                                      floatingLabelStyle:
                                                          const TextStyle(
                                                              color:
                                                                  onFocusColor),
                                                      fillColor: onFocusColor),
                                                )
                                              : const SizedBox(),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller:
                                                initialDateActivity5ListTextController
                                                    .value[index],
                                            cursorColor: onFocusColor,
                                            onTap: () {
                                              selectInitialDate5(context, index);
                                            },
                                            onChanged: (value) {
                                              editActivity5Transhipment(index);
                                            },
                                            style: const TextStyle(
                                                color: onFocusColor),
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: onFocusColor),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                labelText: 'Initial Date',
                                                floatingLabelStyle:
                                                    const TextStyle(
                                                        color: onFocusColor),
                                                fillColor: onFocusColor),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller:
                                                finalDateActivity5ListTextController
                                                    .value[index],
                                            cursorColor: onFocusColor,
                                            onTap: () {
                                              selectFinalDate5(context, index);
                                            },
                                            onChanged: (value) {
                                              editActivity5Transhipment(index);
                                            },
                                            style: const TextStyle(
                                                color: onFocusColor),
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: onFocusColor),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                labelText: 'Final Date',
                                                floatingLabelStyle:
                                                    const TextStyle(
                                                        color: onFocusColor),
                                                fillColor: onFocusColor),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller:
                                                deliveryQtyListTextController
                                                    .value[index],
                                            cursorColor: onFocusColor,
                                            onChanged: (value) {
                                              editActivity5Transhipment(index);
                                            },
                                            style: const TextStyle(
                                                color: onFocusColor),
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: onFocusColor),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                labelText: 'Delivery Qty',
                                                floatingLabelStyle:
                                                    const TextStyle(
                                                        color: onFocusColor),
                                                fillColor: onFocusColor),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller: uomController,
                                            enabled: false,
                                            cursorColor: onFocusColor,
                                            style: const TextStyle(
                                                color: onFocusColor),
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: onFocusColor),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                labelText: 'UOM',
                                                floatingLabelStyle:
                                                    const TextStyle(
                                                        color: onFocusColor),
                                                fillColor: onFocusColor),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                        ],
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    checkActivity5List();
                                    Get.back();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(color: primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      width: double.infinity,
                                      child: Center(
                                          child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )))),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      editActivityStage5Confirm();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      width: double.infinity,
                                      child: Center(
                                          child: Text(
                                        'Submit',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )))),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ),
        isScrollControlled: true);
  }

  Future<void> postUpdateActivity5(data) async {
    var response = await repository.updateActivityInspection5(data, id) ??
        ResponseJoInsertActivity5();
    debugPrint('insert activity 5 response: ${jsonEncode(response.message)}');
  }

  void editActivityStage5Confirm() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text(
            'Apakah benar anda akan menyimpan perubahan stage work complete ini? pastikan data yg anda input benar.'),
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
              var result = await editActivity5Stage();
              if (result == 'success') {
                Get.back();
                cleanActivity5();
                Get.back();
                //openDialog("Success", "Activity Stage ${activityStage-1} berhasil ditambahkan");
              } else {
                Get.back();
                openDialog("Failed",
                    "Activity Stage $activityStage masih kosong atau belum diinput");
              }
            },
          ),
        ],
      ),
    );
  }

  // Activity 6 Inspection Functions

  Future<void> selectDate6(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 1));
    if (picked != null) {
      activity6Date.text = DateFormat('yyyy-MM-dd').format(picked).toString();
    }
  }

  Future<String> selectTime6(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      DateTime date = DateTime.now();
      String second = date.second.toString().padLeft(2, '0');
      List timeSplit = picked.format(context).split(' ');
      String formattedTime = timeSplit[0];
      String time = '$formattedTime:$second';
      return time;
    } else {
      return '';
    }
  }

  void addActivity6() {
    debugPrint('activity 6 stage : $activityStage');
    if (activity6List.value.isEmpty) {
      activity6ListTextController.value.add(TextEditingController());
    } else {
      if (activity6List.value.last.transDate != activity6Date.text) {
        activity6ListTextController.value.add(TextEditingController());
      }
    }

    activity6List.value.add(Activity(
      tHJoId: id,
      mStatusinspectionstagesId: activityStage,
      transDate: activity6Date.text,
      startActivityTime: activity6StartTime.text,
      endActivityTime: activity6EndTime.text,
      activity: activity6Text.text,
      createdBy: 0,
      remarks: '',
    ));

    activity6Date.text = '';
    activity6StartTime.text = '';
    activity6EndTime.text = '';
    activity6Text.text = '';
    activitySubmitted.value == true;
    update();

    debugPrint('activities 6: ${jsonEncode(activity6List)}');
  }

  void toggleEditActivity6(int index) {
    activity6Date.text = activity6List.value[index].transDate!;
    activity6StartTime.text = activity6List.value[index].startActivityTime!;
    activity6EndTime.text = activity6List.value[index].endActivityTime!;
    activity6Text.text = activity6List.value[index].activity!;
    editActivityMode.value = true;
    editActivityIndex.value = index;
    update();
  }

  void editActivity6() {
    activity6List.value[editActivityIndex.value] = Activity(
      tHJoId: id,
      mStatusinspectionstagesId: activityStage,
      transDate: activity6Date.text,
      startActivityTime: activity6StartTime.text,
      endActivityTime: activity6EndTime.text,
      activity: activity6Text.text,
      createdBy: userData.value!.id,
      remarks: '',
    );
    editActivityMode.value = false;
    activity6Date.text = '';
    activity6StartTime.text = '';
    activity6EndTime.text = '';
    activity6Text.text = '';
    update();
  }

  void editActivity6Remarks(String date, String val, int index) {
    final TextEditingController remarksController =
        activity6ListTextController[index];
    debugPrint('text controller value : ${remarksController.text}');
    for (var i = 0; i < activity6List.value.length; i++) {
      if (activity6List.value[i].transDate.toString() == date) {
        activity6List.value[i] = Activity(
          tHJoId: id,
          mStatusinspectionstagesId:
              activity6List.value[i].mStatusinspectionstagesId,
          transDate: activity6List.value[i].transDate,
          startActivityTime: activity6List.value[i].startActivityTime,
          endActivityTime: activity6List.value[i].endActivityTime,
          activity: activity6List.value[i].activity,
          createdBy: userData.value!.id,
          remarks: remarksController.text,
        );
      }
    }
  }

  void checkActivity6List() {
    debugPrint('activities now: ${jsonEncode(activity6List.value)}');
  }

  void removeActivity6(int indexitem, int index, int stage) {
    debugPrint('index item : ${jsonEncode(activity6List.value)}');
    var dateLength = activity6List.value
        .where((item) =>
            item.transDate == activity6List.value[indexitem].transDate &&
            item.mStatusinspectionstagesId == stage)
        .length;
    if (dateLength == 1) {
      activity6ListTextController.value.removeAt(index);
    }
    activity6List.value.removeAt(indexitem);
    update();
  }

  void removeActivity6ByDate(String date, int indexDate, int stage) {
    activity6List.value.removeWhere((item) =>
        item.transDate == date && item.mStatusinspectionstagesId == stage);
    activity6ListTextController.value.removeAt(indexDate);
    update();
  }

  Future<String?> addActivity6Stages() async {
    if (activity6List.value
        .where((data) => data.mStatusinspectionstagesId == activityStage)
        .toList()
        .isNotEmpty) {
      //activityStage++;
      var post = activity6List.value
          .map((value) => Activity(
                tHJoId: value.tHJoId,
                mStatusinspectionstagesId: value.mStatusinspectionstagesId,
                transDate: value.transDate,
                startActivityTime: value.startActivityTime,
                endActivityTime: value.endActivityTime,
                activity: value.activity,
                createdBy: value.createdBy,
                remarks: value.remarks,
              ).toJson())
          .toList();
      //postInsertActivity(post);
      for (var item in activity6List.value) {
        activity6ListStages.value.add(item);
      }
      activity6AttachmentsStage.value = activity6AttachmentsStage.value;
      activity6AttachmentsStage.value = [];
      activityList.value = [];
      activityListTextController.value = [];
      editActivityMode.value = false;
      activityDate.text = '';
      activityStartTime.text = '';
      activityEndTime.text = '';
      activityText.text = '';

      activitySubmitted.value = true;

      // await getJoDailyActivity6();
      // activityStage--;
      update();
      return 'success';
    } else if (activity6List.value
        .where((data) => data.mStatusinspectionstagesId == activityStage)
        .toList()
        .isEmpty) {
      return 'failed';
    }
  }

  Future<void> postInsertActivity6(data) async {
    var response = await repository.insertActivityInspection6(data) ??
        ResponseJoInsertActivity5();
    debugPrint('insert activity response: ${jsonEncode(response.message)}');
  }

  void addActivity6Files(File attach) {
    activity6Attachments.value.add(attach);
  }

  void removeActivity6Files(int index) {
    activity6Attachments.value.removeAt(index);
  }

  void removeActivity6FilesConfirm(int index) {
    activity6Attachments.value.removeAt(index);
  }

  void cameraImageActivity6() async {
    File? image;
    try {
      final XFile? pic = await picker.pickImage(source: ImageSource.camera);
      if (pic != null) {
        final imageTemp = File(pic!.path);
        image = imageTemp;
        update();
        addActivity6Files(image);
      }
    } on PlatformException catch (e) {
      openDialog('Failed', e.message ?? 'Gagal menambahkan file');
    }
    openDialog('Success', 'Berhasil menambahkan file.');
  }

  void fileActivity6() async {
    try {
      final FilePickerResult? attach = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);
      if (attach != null) {
        final List<XFile> xFiles = attach.xFiles;
        xFiles.forEach((data) {
          final fileTemp = File(data!.path);
          final File file = fileTemp;
          update();
          addActivity6Files(file);
        });
        openDialog('Success', 'Berhasil menambahkan file.');
      }
    } on PlatformException catch (e) {
      openDialog('Failed', e.message ?? 'Gagal menambahkan file.');
    }
  }

  String checkFileType(String path) {
    final mimeType = lookupMimeType(path);

    if (mimeType!.startsWith('image/')) {
      return 'image';
    } else if (mimeType == 'application/pdf') {
      return 'doc';
    }
    return 'unsupported';
  }

  void drawerDailyActivity6() {
    Get.bottomSheet(
        GetBuilder(
          init: JoDetailController(),
          builder: (controller) => Container(
              margin: EdgeInsets.only(top: 48),
              padding: EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      topLeft: Radius.circular(24))),
              child: Obx(
                () => Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add Stage Inspection',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                'Stage 6: Report to Client',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                showCursor: true,
                                readOnly: true,
                                controller: activity6Date,
                                cursorColor: onFocusColor,
                                onTap: () {
                                  selectDate6(Get.context!);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Field wajib diisi!';
                                  }
                                  return null;
                                },
                                style: const TextStyle(color: onFocusColor),
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          selectDate6(Get.context!);
                                        },
                                        icon: const Icon(
                                            Icons.calendar_today_rounded)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      const BorderSide(color: onFocusColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Date*',
                                    floatingLabelStyle:
                                    const TextStyle(color: onFocusColor),
                                    fillColor: onFocusColor),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text('Detail Activities'),
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: activity6StartTime,
                                      cursorColor: onFocusColor,
                                      onTap: () async {
                                        activity6StartTime.text =
                                        await selectTime6(Get.context!);
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Field wajib diisi!';
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(color: onFocusColor),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: onFocusColor),
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          labelText: 'Start Time*',
                                          floatingLabelStyle: const TextStyle(
                                              color: onFocusColor),
                                          fillColor: onFocusColor),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: activity6EndTime,
                                      cursorColor: onFocusColor,
                                      onTap: () async {
                                        activity6EndTime.text =
                                        await selectTime6(Get.context!);
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Field wajib diisi!';
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(color: onFocusColor),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: onFocusColor),
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          labelText: 'End Time*',
                                          floatingLabelStyle: const TextStyle(
                                              color: onFocusColor),
                                          fillColor: onFocusColor),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                controller: activity6Text,
                                cursorColor: onFocusColor,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Field wajib diisi!';
                                  }
                                  return null;
                                },
                                style: const TextStyle(color: onFocusColor),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      const BorderSide(color: onFocusColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Activity*',
                                    floatingLabelStyle:
                                    const TextStyle(color: onFocusColor),
                                    fillColor: onFocusColor),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              InkWell(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (editActivityMode.value == false) {
                                      addActivity6();
                                    } else {
                                      editActivity6();
                                    }
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 8),
                                  height: 42,
                                  width: 42,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: Icon(
                                      editActivityMode.value == false
                                          ? Icons.add
                                          : Icons.check,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              activity6List.value.isNotEmpty
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: activity6List.value
                                          .map((item) {
                                            return item.transDate;
                                          })
                                          .toSet()
                                          .toList()
                                          .length,
                                      itemBuilder: (context, index) {
                                        var activity = activity6List.value
                                            .map((item) {
                                              return item.transDate;
                                            })
                                            .toSet()
                                            .toList()[index];
                                        return Column(
                                          children: [
                                            Card(
                                              color: Colors.white,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    top: 8,
                                                    bottom: 16),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Date',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ),
                                                        VerticalDivider(width: 1),
                                                        SizedBox(width: 16),
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                activity ?? '-',
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {},
                                                                  icon: Icon(
                                                                    Icons
                                                                        .delete_forever,
                                                                    color: Colors
                                                                        .red,
                                                                  ))
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount: activity6List
                                                            .value.length,
                                                        itemBuilder:
                                                            (context, indexItem) {
                                                          if (activity6List
                                                                  .value[
                                                                      indexItem]
                                                                  .transDate ==
                                                              activity) {
                                                            return Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    'Activities',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700),
                                                                  ),
                                                                ),
                                                                VerticalDivider(
                                                                    width: 1),
                                                                SizedBox(
                                                                    width: 8),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    '${activity6List.value[indexItem].startActivityTime ?? '-'} - ${activity6List.value[indexItem].endActivityTime ?? '-'}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700),
                                                                  ),
                                                                ),
                                                                VerticalDivider(
                                                                    width: 1),
                                                                SizedBox(
                                                                    width: 8),
                                                                Expanded(
                                                                  flex: 2,
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        activity6List
                                                                                .value[indexItem]
                                                                                .activity ??
                                                                            '-',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                        ),
                                                                      ),
                                                                      InkWell(
                                                                          onTap:
                                                                              () {
                                                                            toggleEditActivity6(
                                                                                indexItem);
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons
                                                                                .mode_edit_outlined,
                                                                            color:
                                                                                primaryColor,
                                                                          )),
                                                                      InkWell(
                                                                          onTap:
                                                                              () {
                                                                            removeActivity6(
                                                                                indexItem,
                                                                                index,
                                                                                6);
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons
                                                                                .delete_forever,
                                                                            color:
                                                                                Colors.red,
                                                                          ))
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            );
                                                          } else {
                                                            return const SizedBox();
                                                          }
                                                        }),
                                                    const Divider(),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          activity6ListTextController
                                                              .value[index],
                                                      onChanged: (value) {
                                                        debugPrint(value);
                                                        debugPrint(
                                                            'text remarks controller : ${activity6ListTextController.value[index].text}');
                                                        editActivity6Remarks(
                                                            activity!,
                                                            value,
                                                            index);
                                                      },
                                                      cursorColor: onFocusColor,
                                                      style: const TextStyle(
                                                          color: onFocusColor),
                                                      decoration: InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(12),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color:
                                                                        onFocusColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(12),
                                                          ),
                                                          labelText: 'Remarks',
                                                          floatingLabelStyle:
                                                              const TextStyle(
                                                                  color:
                                                                      onFocusColor),
                                                          fillColor:
                                                              onFocusColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      })
                                  : SizedBox(),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                'Attachment',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                  'File lampiran maksimal 5 file dengan ukuran total file maksimal 10 MB. Jenis file yang diperbolehkan hanya PDF/JPG/PNG/JPEG.'),
                              const SizedBox(
                                height: 16,
                              ),
                              activity6Attachments.value.isNotEmpty
                                  ? GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                      ),
                                      itemCount:
                                          activity6Attachments.value.length,
                                      itemBuilder: (content, index) {
                                        final File photo =
                                            activity6Attachments.value[index];
                                        final String fileType =
                                            checkFileType(photo.path);
                                        var filenameArr = photo.path.split("/");
                                        var filename = filenameArr.last;
                                        return fileType == 'image' ? SizedBox(
                                          width: 54,
                                          height: 66,
                                          child: Stack(
                                            children: [
                                              SizedBox(
                                                width: 54,
                                                height: 54,
                                                child: InkWell(
                                                  onTap: (){
                                                    controller.previewImageAct6(index, photo.path);
                                                  },
                                                  child: Image.file(
                                                    File(photo.path),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional.topEnd,
                                                child: SizedBox(
                                                  height: 12,
                                                  child: IconButton(
                                                      onPressed: (){
                                                        controller.removeActivity6Files(index);
                                                      },
                                                      icon: Icon(Icons.remove_circle,
                                                        size: 12,
                                                        color: Colors.red,
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ) : fileType == 'doc' ? SizedBox(
                                          width: 54,
                                          height: 66,
                                          child: Stack(
                                            children: [
                                              InkWell(
                                                onTap: (){
                                                  OpenFilex.open(photo.path);
                                                },
                                                child: SizedBox(
                                                  width: 54,
                                                  height: 54,
                                                  child: Center(
                                                      child: Column(
                                                        children: [
                                                          Image.asset('assets/icons/pdfIcon.png', height: 42,),
                                                          Text(filename, style: TextStyle(fontSize: 8), overflow: TextOverflow.ellipsis)
                                                        ],
                                                      )
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional.topEnd,
                                                child: SizedBox(
                                                  height: 12,
                                                  child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      onPressed: (){
                                                        controller.removeActivity6Files(index);
                                                      },
                                                      icon: Icon(Icons.remove_circle,
                                                        size: 12,
                                                        color: Colors.red,
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ) : SizedBox();
                                      })
                                  : const SizedBox(),
                              const SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                width: 68,
                                height: 68,
                                child: ElevatedButton(
                                    onPressed: () {
                                      mediaPickerConfirm();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(color: primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                    child: Center(
                                        child: Icon(
                                      Icons.folder_rounded,
                                      color: primaryColor,
                                    ))),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  checkActivity6List();
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: primaryColor),
                                        borderRadius: BorderRadius.circular(12))),
                                child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 12),
                                    width: double.infinity,
                                    child: Center(
                                        child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )))),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  addActivity6StageConfirm();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12))),
                                child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 12),
                                    width: double.infinity,
                                    child: Center(
                                        child: Text(
                                      'Submit',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )))),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              )),
        ),
        isScrollControlled: true);
  }

  void previewImageAct6(int index, String photo) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Text(
              'Attachment ${index + 1}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: primaryColor),
            ),
            InkWell(
              onTap: () {},
              child: Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.close),
            )
          ],
        ),
        content: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(
                File(photo),
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        actions: [],
      ),
    );
  }

  void mediaPickerConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'File Attachment',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Pilih sumber file yang ingin dilampirkan.'),
        actions: [
          Row(
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 68,
                    height: 67,
                    child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          cameraImageActivity6();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: primaryColor),
                                borderRadius: BorderRadius.circular(12))),
                        child: Center(
                            child: Icon(
                          Icons.camera_alt,
                          color: primaryColor,
                        ))),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 68,
                    height: 68,
                    child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          fileActivity6();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: primaryColor),
                                borderRadius: BorderRadius.circular(12))),
                        child: Center(
                            child: Icon(
                          Icons.folder_rounded,
                          color: primaryColor,
                        ))),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void drawerDailyActivity6Edit() {
    activity6List.value = [];
    activity6List.value = activity6ListStages.value.where((item) => item.mStatusinspectionstagesId == activityStage).toList();
    var activityEditTemp = activity6List.value.map((item){return item.transDate;}).toSet().toList();
    activityEditTemp.forEach((item){
      var text = activity6List.value.lastWhere((act) => act.transDate == item);
      activity6ListTextController.value.add(TextEditingController(text: text.remarks));
    });
    update();
    Get.bottomSheet(
        GetBuilder(
          init: JoDetailController(),
          builder: (controller) => Container(
              margin: EdgeInsets.only(top: 48),
              padding: EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      topLeft: Radius.circular(24))),
              child: Obx(
                () => Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add Stage Inspection',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                'Stage 6: Report to Client',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                showCursor: true,
                                readOnly: true,
                                controller: activity6Date,
                                cursorColor: onFocusColor,
                                onTap: () {
                                  selectDate6(Get.context!);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Form wajib diisi!';
                                  }
                                  return null;
                                },
                                style: const TextStyle(color: onFocusColor),
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          selectDate6(Get.context!);
                                        },
                                        icon: const Icon(
                                            Icons.calendar_today_rounded)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: onFocusColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Date*',
                                    floatingLabelStyle:
                                        const TextStyle(color: onFocusColor),
                                    fillColor: onFocusColor),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text('Detail Activities'),
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: activity6StartTime,
                                      cursorColor: onFocusColor,
                                      onTap: () async {
                                        activity6StartTime.text =
                                            await selectTime6(Get.context!);
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Form wajib diisi!';
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(color: onFocusColor),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: onFocusColor),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          labelText: 'Start Time*',
                                          floatingLabelStyle: const TextStyle(
                                              color: onFocusColor),
                                          fillColor: onFocusColor),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: activity6EndTime,
                                      cursorColor: onFocusColor,
                                      onTap: () async {
                                        activity6EndTime.text =
                                            await selectTime6(Get.context!);
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Form wajib diisi!';
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(color: onFocusColor),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: onFocusColor),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          labelText: 'End Time*',
                                          floatingLabelStyle: const TextStyle(
                                              color: onFocusColor),
                                          fillColor: onFocusColor),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                controller: activity6Text,
                                cursorColor: onFocusColor,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Form wajib diisi!';
                                  }
                                  return null;
                                },
                                style: const TextStyle(color: onFocusColor),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: onFocusColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Activity*',
                                    floatingLabelStyle:
                                        const TextStyle(color: onFocusColor),
                                    fillColor: onFocusColor),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              InkWell(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (editActivityMode.value == false) {
                                      addActivity6();
                                    } else {
                                      editActivity6();
                                    }
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 8),
                                  height: 42,
                                  width: 42,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: Icon(
                                      editActivityMode.value == false
                                          ? Icons.add
                                          : Icons.check,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              activity6List.value.isNotEmpty
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: activity6List.value
                                          .map((item) {
                                            return item.transDate;
                                          })
                                          .toSet()
                                          .toList()
                                          .length,
                                      itemBuilder: (context, index) {
                                        var activity = activity6List.value
                                            .map((item) {
                                              return item.transDate;
                                            })
                                            .toSet()
                                            .toList()[index];
                                        return Column(
                                          children: [
                                            Card(
                                              color: Colors.white,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    top: 8,
                                                    bottom: 16),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Date',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ),
                                                        VerticalDivider(width: 1),
                                                        SizedBox(width: 16),
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                activity ?? '-',
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                              IconButton(
                                                                  onPressed: () {
                                                                    removeActivity6ByDate(
                                                                        activity!,
                                                                        index,
                                                                        6);
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .delete_forever,
                                                                    color: Colors
                                                                        .red,
                                                                  ))
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount: activity6List
                                                            .value.length,
                                                        itemBuilder:
                                                            (context, indexItem) {
                                                          if (activity6List
                                                                  .value[
                                                                      indexItem]
                                                                  .transDate ==
                                                              activity) {
                                                            return Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    'Activities',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700),
                                                                  ),
                                                                ),
                                                                VerticalDivider(
                                                                    width: 1),
                                                                SizedBox(
                                                                    width: 8),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    '${activity6List.value[indexItem].startActivityTime ?? '-'} - ${activity6List.value[indexItem].endActivityTime ?? '-'}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700),
                                                                  ),
                                                                ),
                                                                VerticalDivider(
                                                                    width: 1),
                                                                SizedBox(
                                                                    width: 8),
                                                                Expanded(
                                                                  flex: 2,
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        activity6List
                                                                                .value[indexItem]
                                                                                .activity ??
                                                                            '-',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                        ),
                                                                      ),
                                                                      InkWell(
                                                                          onTap:
                                                                              () {
                                                                            toggleEditActivity6(
                                                                                indexItem);
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons
                                                                                .mode_edit_outlined,
                                                                            color:
                                                                                primaryColor,
                                                                          )),
                                                                      InkWell(
                                                                          onTap:
                                                                              () {
                                                                            removeActivity6(
                                                                                indexItem,
                                                                                index,
                                                                                6);
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons
                                                                                .delete_forever,
                                                                            color:
                                                                                Colors.red,
                                                                          ))
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            );
                                                          } else {
                                                            return const SizedBox();
                                                          }
                                                        }),
                                                    const Divider(),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          activity6ListTextController
                                                              .value[index],
                                                      onChanged: (value) {
                                                        debugPrint(value);
                                                        debugPrint(
                                                            'text remarks controller : ${activity6ListTextController.value[index].text}');
                                                        editActivity6Remarks(
                                                            activity!,
                                                            value,
                                                            index);
                                                      },
                                                      cursorColor: onFocusColor,
                                                      style: const TextStyle(
                                                          color: onFocusColor),
                                                      decoration: InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(12),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color:
                                                                        onFocusColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(12),
                                                          ),
                                                          labelText: 'Remarks',
                                                          floatingLabelStyle:
                                                              const TextStyle(
                                                                  color:
                                                                      onFocusColor),
                                                          fillColor:
                                                              onFocusColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      })
                                  : SizedBox(),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                'Attachment',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                  'File lampiran maksimal 5 file dengan ukuran total file maksimal 10 MB. Jenis file yang diperbolehkan hanya PDF/JPG/PNG/JPEG.'),
                              const SizedBox(
                                height: 16,
                              ),
                              activity6Attachments.value.isNotEmpty
                                  ? GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                      ),
                                      itemCount:
                                          activity6Attachments.value.length,
                                      itemBuilder: (content, index) {
                                        final File photo =
                                            activity6Attachments.value[index];
                                        final String fileType =
                                            checkFileType(photo.path);
                                        var filenameArr = photo.path.split("/");
                                        var filename = filenameArr.last;
                                        return fileType == 'image' ? SizedBox(
                                          width: 54,
                                          height: 66,
                                          child: Stack(
                                            children: [
                                              SizedBox(
                                                width: 54,
                                                height: 54,
                                                child: InkWell(
                                                  onTap: (){
                                                    controller.previewImageAct6(index, photo.path);
                                                  },
                                                  child: Image.file(
                                                    File(photo.path),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional.topEnd,
                                                child: SizedBox(
                                                  height: 12,
                                                  child: IconButton(
                                                      onPressed: (){
                                                        controller.removeActivity6Files(index);
                                                      },
                                                      icon: Icon(Icons.remove_circle,
                                                        size: 12,
                                                        color: Colors.red,
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ) : fileType == 'doc' ? SizedBox(
                                          width: 54,
                                          height: 66,
                                          child: Stack(
                                            children: [
                                              InkWell(
                                                onTap: (){
                                                  OpenFilex.open(photo.path);
                                                },
                                                child: SizedBox(
                                                  width: 54,
                                                  height: 54,
                                                  child: Center(
                                                      child: Column(
                                                        children: [
                                                          Image.asset('assets/icons/pdfIcon.png', height: 42,),
                                                          Text(filename, style: TextStyle(fontSize: 8), overflow: TextOverflow.ellipsis)
                                                        ],
                                                      )
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional.topEnd,
                                                child: SizedBox(
                                                  height: 12,
                                                  child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      onPressed: (){
                                                        controller.removeActivity6Files(index);
                                                      },
                                                      icon: Icon(Icons.remove_circle,
                                                        size: 12,
                                                        color: Colors.red,
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ) : SizedBox();
                                      })
                                  : const SizedBox(),
                              const SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                width: 68,
                                height: 68,
                                child: ElevatedButton(
                                    onPressed: () {
                                      mediaPickerConfirm();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(color: primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                    child: Center(
                                        child: Icon(
                                      Icons.folder_rounded,
                                      color: primaryColor,
                                    ))),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  checkActivity6List();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: primaryColor),
                                        borderRadius: BorderRadius.circular(12))),
                                child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 12),
                                    width: double.infinity,
                                    child: Center(
                                        child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )))),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  editActivity6StageConfirm();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12))),
                                child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 12),
                                    width: double.infinity,
                                    child: Center(
                                        child: Text(
                                      'Submit',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )))),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              )),
        ),
        isScrollControlled: true);
  }

  String? editActivity6Stages() {
    if (activity6List.value
        .where((data) => data.mStatusinspectionstagesId == activityStage)
        .toList()
        .isNotEmpty) {
      //activityStage++;
      var post = activity6List.value
          .map((value) => Activity(
                tHJoId: value.tHJoId,
                mStatusinspectionstagesId: value.mStatusinspectionstagesId,
                transDate: value.transDate,
                startActivityTime: value.startActivityTime,
                endActivityTime: value.endActivityTime,
                activity: value.activity,
                createdBy: value.createdBy,
                remarks: value.remarks,
              ).toJson())
          .toList();
      // postUpdateActivity6(post);
      // activityStage--;
      activity6ListStages.value = activity6List.value;
      activity6AttachmentsStage.value = activity6AttachmentsStage.value;
      activity6AttachmentsStage.value = [];
      activityList.value = [];
      activityListTextController.value = [];
      editActivityMode.value = false;
      activityDate.text = '';
      activityStartTime.text = '';
      activityEndTime.text = '';
      activityText.text = '';

      activitySubmitted.value = true;
      //activityStage--;
      update();
      return 'success';
    } else if (activity6List.value
        .where((data) => data.mStatusinspectionstagesId == activityStage)
        .toList()
        .isEmpty) {
      return 'failed';
    }
  }

  Future<void> postUpdateActivity6(data) async {
    var response = await repository.updateActivityInspection6(data, id) ??
        ResponseJoInsertActivity5();
    debugPrint('insert activity 6 response: ${jsonEncode(response.message)}');
  }

  void addActivity6StageConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text(
            'Apakah benar anda akan submit stage report to client ini? pastikan data yg anda input benar.'),
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
              var result = await addActivity6Stages();
              if (result == 'success') {
                Get.back();
                //openDialog("Success", "Activity Stage ${activityStage-1} berhasil ditambahkan");
                Get.back();
              } else {
                Get.back();
                openDialog("Failed",
                    "Activity Stage $activityStage masih kosong atau belum diinput");
              }
            },
          ),
        ],
      ),
    );
  }

  void editActivity6StageConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text(
            'Apakah benar anda akan menyimpan perubahan stage report to client ini? pastikan data yg anda input benar.'),
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
              var result = await editActivity6Stages();
              if (result == 'success') {
                Get.back();
                //openDialog("Success", "Activity Stage ${activityStage-1} berhasil ditambahkan");
                Get.back();
              } else {
                Get.back();
                openDialog("Failed",
                    "Activity Stage $activityStage masih kosong atau belum diinput");
              }
            },
          ),
        ],
      ),
    );
  }

  void finishStageActivityConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text(
            'Apakah benar anda ingin Finish JO Inspection ini? pastikan data yg anda input benar, karena anda tidak bisa mengubah data setelah Finish JO'),
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
              activityStage++;
              activitySubmitted.value = false;
              update();
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  // Activity Lab Functions

  void detailLabActivity(int? lab) {
    Get.to(LabActivityDetailScreen(), arguments: {'id': id, 'labId': lab});
  }

  void openDialog(String type, String text) {
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
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  // Activities Documents Functions

  Future<String?> addDocuments(String type) async {
    if (type == 'inspect') {
      if (certificateNumberTextController.value.text != '' &&
          certificateDateTextController.value.text != '' &&
          certificateBlankoNumberTextController.value.text != '' &&
          certificateLHVNumberTextController.value.text != '' &&
          certificateLSNumberTextController.value.text != '' &&
          documentInspectionAttachments.value.isNotEmpty) {
        documentInspection.value.add(<String, dynamic>{
          'certNumber': certificateNumberTextController.value.text,
          'certDate': certificateDateTextController.value.text,
          'certBlanko': certificateBlankoNumberTextController.value.text,
          'certLhv': certificateLHVNumberTextController.value.text,
          'certLs': certificateLSNumberTextController.value.text,
          'certAttachments': documentInspectionAttachments.value
        });
        return 'success';
      } else {
        return 'failed';
      }
    } else if (type == 'lab') {
      if (certificateNumberTextController.value.text != '' &&
          certificateDateTextController.value.text != '' &&
          certificateBlankoNumberTextController.value.text != '' &&
          certificateLHVNumberTextController.value.text != '' &&
          certificateLSNumberTextController.value.text != '' &&
          documentLaboratoryAttachments.value.isNotEmpty) {
        documentLaboratory.value.add(<String, dynamic>{
          'certNumber': certificateNumberTextController.value.text,
          'certDate': certificateDateTextController.value.text,
          'certBlanko': certificateBlankoNumberTextController.value.text,
          'certLhv': certificateLHVNumberTextController.value.text,
          'certLs': certificateLSNumberTextController.value.text,
          'certAttachments': documentInspectionAttachments.value
        });
        return 'success';
      } else {
        return 'failed';
      }
    }
  }

  void fileDocument(String type) async {
    try {
      final FilePickerResult? attach = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);
      if (attach != null) {
        final List<XFile> xFiles = attach.xFiles;
        xFiles.forEach((data) {
          final fileTemp = File(data!.path);
          final File file = fileTemp;
          update();
          if (type == 'inspect') {
            documentInspectionAttachments.value.add(file);
          } else {
            documentLaboratoryAttachments.value.add(file);
          }
        });
        openDialog('Success', 'Berhasil menambahkan file.');
      }
    } on PlatformException catch (e) {
      openDialog('Failed', e.message ?? 'Gagal menambahkan file.');
    }
  }

  void drawerAddDocument(String type) {
    Get.bottomSheet(
      GetBuilder(
        init: JoDetailController(),
        builder: (controller) => Container(
            margin: EdgeInsets.only(top: 48),
            padding: EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24),
                    topLeft: Radius.circular(24))),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Stage Inspection',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: primaryColor),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: activity6Text,
                            cursorColor: onFocusColor,
                            style: const TextStyle(color: onFocusColor),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: onFocusColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                labelText: 'No Certificate/Report*',
                                floatingLabelStyle:
                                    const TextStyle(color: onFocusColor),
                                fillColor: onFocusColor),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            showCursor: true,
                            readOnly: true,
                            controller: activity6Date,
                            cursorColor: onFocusColor,
                            onTap: () {
                              selectDate6(Get.context!);
                            },
                            style: const TextStyle(color: onFocusColor),
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      selectDate6(Get.context!);
                                    },
                                    icon: const Icon(
                                        Icons.calendar_today_rounded)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: onFocusColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                labelText: 'Date Certificate/Report*',
                                floatingLabelStyle:
                                    const TextStyle(color: onFocusColor),
                                fillColor: onFocusColor),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: activity6Text,
                            cursorColor: onFocusColor,
                            style: const TextStyle(color: onFocusColor),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: onFocusColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                labelText: 'No Blanko Certificate*',
                                floatingLabelStyle:
                                    const TextStyle(color: onFocusColor),
                                fillColor: onFocusColor),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: activity6Text,
                            cursorColor: onFocusColor,
                            style: const TextStyle(color: onFocusColor),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: onFocusColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                labelText: 'LHV Number*',
                                floatingLabelStyle:
                                    const TextStyle(color: onFocusColor),
                                fillColor: onFocusColor),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: activity6Text,
                            cursorColor: onFocusColor,
                            style: const TextStyle(color: onFocusColor),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: onFocusColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                labelText: 'LS Number*',
                                floatingLabelStyle:
                                    const TextStyle(color: onFocusColor),
                                fillColor: onFocusColor),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'Upload Attachment Certificate',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Note: PDF Only. Max 1 file. Max 2 MB',
                            style: TextStyle(fontSize: 10, color: Colors.green),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          activity6Attachments.value.isNotEmpty
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                  ),
                                  itemCount: activity6Attachments.value.length,
                                  itemBuilder: (content, index) {
                                    final File photo =
                                        activity6Attachments.value[index];
                                    final String fileType =
                                        checkFileType(photo.path);
                                    var filenameArr = photo.path.split("/");
                                    var filename = filenameArr.last;
                                    return fileType == 'image'
                                        ? SizedBox(
                                            width: 54,
                                            height: 54,
                                            child: InkWell(
                                              onTap: () {
                                                previewImageAct6(
                                                    index, photo.path);
                                              },
                                              child: Image.file(
                                                File(photo.path),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : fileType == 'doc'
                                            ? InkWell(
                                                onTap: () {
                                                  OpenFilex.open(photo.path);
                                                },
                                                child: SizedBox(
                                                  width: 54,
                                                  height: 54,
                                                  child: Center(
                                                      child: Column(
                                                    children: [
                                                      Image.asset(
                                                        'assets/icons/pdfIcon.png',
                                                        height: 42,
                                                      ),
                                                      Text(filename,
                                                          style: TextStyle(
                                                              fontSize: 8),
                                                          overflow: TextOverflow
                                                              .ellipsis)
                                                    ],
                                                  )),
                                                ),
                                              )
                                            : SizedBox();
                                  })
                              : const SizedBox(),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width: 68,
                            height: 68,
                            child: ElevatedButton(
                                onPressed: () {
                                  mediaPickerConfirm();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: primaryColor),
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                child: Center(
                                    child: Icon(
                                  Icons.folder_rounded,
                                  color: primaryColor,
                                ))),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              checkActivity6List();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: primaryColor),
                                    borderRadius: BorderRadius.circular(12))),
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                width: double.infinity,
                                child: Center(
                                    child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )))),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              addDocumentConfirm(type);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                width: double.infinity,
                                child: Center(
                                    child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )))),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            )),
      ),
      isScrollControlled: true,
    );
  }

  void checkDocumentList(String type) {
    debugPrint(
        'document now: ${jsonEncode(type == 'inspect' ? documentInspection.value : documentLaboratory.value)}');
  }

  void addDocumentConfirm(String type) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text(
            'Apakah benar anda akan submit finalisasi JO Inspection ini? pastikan data yg anda input benar karena jika anda submit, JO akan dicomplete-kan.'),
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
              var result = await addDocuments(type);
              if (result == 'success') {
                Get.back();
                openDialog("Success", "Finalisasi JO berhasil ditambahkan");
              } else {
                Get.back();
                openDialog(
                    "Failed", "Finalisasi JO masih kosong atau belum diinput");
              }
            },
          ),
        ],
      ),
    );
  }
}
