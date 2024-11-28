import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
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
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity_barge.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity_stages.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity_stages_transhipment.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity_vessel.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_attachment.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_pict.dart';
import 'package:ops_mobile/data/model/t_h_jo.dart';
import 'package:ops_mobile/data/sqlite.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:ops_mobile/feature/lab_activity_detail/lab_activity_detail_screen.dart';
import 'package:ops_mobile/utils/helper.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class JoDetailController extends BaseController {
  // Data User
  Rx<Data?> userData = Rx(Data());

  // Settings
  final PathProviderPlatform providerAndroid = PathProviderPlatform.instance;
  final picker = ImagePicker();
  RxBool activitySubmitted = false.obs;
  RxBool activityFinished = false.obs;
  final _formKey = GlobalKey<FormState>();

  // Detail Data
  late int id;
  late int statusId;
  List<String> activityStages = ['Waiting for Arrival', 'Ship Arrived', 'Ship Berthing', 'Work Commence', 'Work Complete', 'Report to Client'];
  int picInspector = 0;
  int picLaboratory = 0;
  List<Tab> joDetailTab = [];
  List<Tab> joWaitingTab = [];
  bool isLoadingJO = false;
  bool isLoadingJOImage = false;
  String inspectionFinishDate = '';
  String laboratoryFinishDate = '';
  String pickedTime = '';

  TextEditingController searchLabText = TextEditingController();

  //Rx<DataDetail> dataJoDetail = Rx(DataDetail());
  Rx<DataDetail> dataJoDetail = Rx(DataDetail());
  Rx<DataPIC> dataJoPIC = Rx(DataPIC());
  RxList<Map<String, dynamic>> resultActivity = RxList();

  // Activity Inspection Data
  RxList<DataDailyPhoto> dataJoDailyPhotos = RxList();

  // Rx<DataListActivity> dataListActivity = Rx(DataListActivity());
  RxList<DataActivity> dataListActivity = RxList();
  Rx<DataListActivity5> dataListActivity5 = Rx(DataListActivity5());
  RxList<String> barges = RxList();
  RxList<String> activity5Barges = RxList();
  RxList<TextEditingController> bargesController = RxList();
  Rx<DataListActivity6> dataListActivity6 = Rx(DataListActivity6());
  Rx<Activity6Attachments> dataListActivity6Attachments = Rx(Activity6Attachments());
  RxList<TDJoInspectionActivityStages> stageList = RxList();
  RxList<TDJoInspectionActivityStages> stageListModal = RxList();

  // Activity Lab Data
  Rx<DataListActivityLab> dataListActivityLab = Rx(DataListActivityLab());
  Rx<DataListActivityLab5> dataListActivityLab5 = Rx(DataListActivityLab5());
  RxList<Laboratory> labs = RxList();
  RxList<Laboratory> labsTemp = RxList();

  // Activity Inspection Photo Variables & Temporary
  RxList<File> dailyActivityPhotos = RxList();
  RxList<TDJoInspectionPict> dailyActivityPhotosV2 = RxList();
  RxList<String> dailyActivityPhotosTemp = RxList();
  RxList<String> dailyActivityPhotosDescText = RxList();
  RxList<String> dailyActivityPhotosDescTextTemp = RxList();
  RxList<TextEditingController> dailyActivityPhotosDesc = RxList();
  RxList<TextEditingController> dailyActivityPhotosDescTemp = RxList();
  RxInt adddailyActivityPhotosCount = RxInt(0);
  Rx<TextEditingController> dailyActivityPhotosDescEdit = TextEditingController().obs;
  Rx<File> activityPreviewFoto = Rx(File(''));

  // Activity Inspection Variables & Temporary
  RxList<Activity> activityList = RxList();
  RxList<Activity> activityListStages = RxList();
  RxList<TextEditingController> activityListTextController = RxList();
  int activityStage = 1;
  RxList<TextEditingController> jettyListTextController = RxList();
  RxList<TextEditingController> initialDateActivity5ListTextController = RxList();
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
  RxBool enabledDate = RxBool(true);

  // Activity 5 Inspection Variables & Temporary
  RxInt activity5FormCount = 1.obs;
  RxList<FormDataArray> activity5List = RxList();
  RxList<FormDataArray> activity5ListStages = RxList();
  RxList<TDJoInspectionActivityStagesTranshipment> activity5TranshipmentList = RxList();
  TextEditingController vesselController = TextEditingController();
  TextEditingController uomController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  int bargesCount = 0;
  int activity5bargesCount = 0;

  // Activity 6 Inspection Variables & Temporary
  RxList<Activity> activity6List = RxList();
  RxList<Activity> activity6ListStages = RxList();
  RxList<TextEditingController> activity6ListTextController = RxList();
  Rx<TextEditingController> certificateNumberTextController = TextEditingController().obs;
  Rx<TextEditingController> certificateDateTextController = TextEditingController().obs;
  Rx<TextEditingController> certificateBlankoNumberTextController = TextEditingController().obs;
  Rx<TextEditingController> certificateLHVNumberTextController = TextEditingController().obs;
  Rx<TextEditingController> certificateLSNumberTextController = TextEditingController().obs;

  // Activity 6 Inspection Variables & Temporary
  TextEditingController activity6Date = TextEditingController();
  TextEditingController activity6StartTime = TextEditingController();
  TextEditingController activity6EndTime = TextEditingController();
  TextEditingController activity6Text = TextEditingController();
  TextEditingController activity6Remarks = TextEditingController();
  RxList<TDJoInspectionAttachment> activity6Attachments = RxList();
  RxList<TDJoInspectionAttachment> activity6AttachmentsStage = RxList();

  // Activities Documents
  RxList<Map<String, dynamic>> documentInspection = RxList();
  RxList<File> documentInspectionAttachments = RxList();
  RxList<Map<String, dynamic>> documentLaboratory = RxList();
  RxList<File> documentLaboratoryAttachments = RxList();

  Rx<THJo> joRx = THJo().obs;
  Rx<bool> isReportClient = RxBool(false);

  @override
  Future<void> onInit() async {
    final dataUser = jsonDecode(await StorageCore().storage.read('user'));
    userData.value = Data(
        id: dataUser.first['id'],
        fullname: dataUser.first['fullname'],
        nip: dataUser.first['e_number'],
        positionId: dataUser.first['jabatan_id'],
        position: dataUser.first['jabatan'],
        divisionId: dataUser.first['division_id'],
        division: dataUser.first['division'].toString(),
        superior: dataUser.first['superior_id'].toString());
    debugPrint('data user: ${jsonEncode(userData.value)}');

    final argument = await Get.arguments;
    id = argument['id'];
    statusId = argument['status'];
    isLoadingJO = true;
    isLoadingJO = false;
    searchLabText.addListener(searchLab);
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
        ? dataJoDetail.value.detail!.idPicInspector.toString() == userData.value!.id.toString()
            ? dataJoDetail.value.detail!.idPicInspector.toString()
            : '0'
        : '0');
    update();
    picLaboratory = int.parse(dataJoDetail.value.detail?.idPicLaboratory != null
        ? dataJoDetail.value.detail!.idPicLaboratory.toString() == userData.value!.id.toString()
            ? dataJoDetail.value.detail!.idPicLaboratory.toString()
            : '0'
        : '0');
    update();
    debugPrint('id pic inspector: $picInspector , laboratory: $picLaboratory');
    if (picInspector != '0' && picLaboratory == 0) {
      if (Get.context?.mounted ?? false) {
        joDetailTab = [
          const Tab(
            text: 'Detail',
          ),
          const Tab(
            text: 'KOS',
          ),
          const Tab(
            text: 'PIC',
          ),
          const Tab(
            text: 'Progress & Daily Activity',
          ),
        ];

        joWaitingTab = [
          const Tab(
            text: 'Detail',
          ),
          const Tab(
            text: 'KOS',
          ),
          const Tab(
            text: 'PIC',
          ),
          const Tab(
            text: 'Progress & Daily Activity',
          ),
          const Tab(
            text: 'Document - Inspection',
          ),
        ];
      }
      update();
    } else if (picInspector == 0 && picLaboratory != '0') {
      joDetailTab = [
        const Tab(
          text: 'Detail',
        ),
        const Tab(
          text: 'KOS',
        ),
        const Tab(
          text: 'PIC',
        ),
        const Tab(
          text: 'Laboratory Progress',
        ),
      ];

      joWaitingTab = [
        const Tab(
          text: 'Detail',
        ),
        const Tab(
          text: 'KOS',
        ),
        const Tab(
          text: 'PIC',
        ),
        const Tab(
          text: 'Laboratory Progress',
        ),
        const Tab(
          text: 'Document - Laboratory',
        ),
      ];
      update();
    } else if (picInspector != '0' && picLaboratory != '0') {
      joDetailTab = [
        const Tab(
          text: 'Detail',
        ),
        const Tab(
          text: 'KOS',
        ),
        const Tab(
          text: 'PIC',
        ),
        const Tab(
          text: 'Progress & Daily Activity',
        ),
        const Tab(
          text: 'Laboratory Progress',
        ),
      ];

      joWaitingTab = [
        const Tab(
          text: 'Detail',
        ),
        const Tab(
          text: 'KOS',
        ),
        const Tab(
          text: 'PIC',
        ),
        const Tab(
          text: 'Progress & Daily Activity',
        ),
        const Tab(
          text: 'Laboratory Progress',
        ),
        const Tab(
          text: 'Document - Inspection',
        ),
        const Tab(
          text: 'Document - Laboratory',
        ),
      ];
      update();
    }
    //await getJoPIC();
    //await getJoPICLocal();
    await getJoDailyPhotoV2();
    // await getJoDailyActivity();
    // await getJoDailyActivityLocal();
    await getJoDailyActivityLocalV2();
    // await getJoDailyActivity5();
    // await getJoDailyActivity6();
    // await getJoDailyActivityLab();
    // await getJoDailyActivityLab5();
    isLoadingJO = false;
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
      labsTemp.value = labo!;
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
    debugPrint('inspect finish date nya nih: ${data.first['inspection_finished_date']}');
    debugPrint('lab finish date nya nih: ${data.first['laboratory_finished_date']}');
    update();
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
        sow: sow.map((item) {
          return Sow(id: item['id'], name: item['name']);
        }).toList(),
        oos: oos.map((item) {
          return Oos(id: item['id'], name: item['name']);
        }).toList(),
        lap: lap.map((item) {
          return Lap(id: item['id'], name: item['name']);
        }).toList(),
        stdMethod:
            // std.map((item){
            //   return StdMethod(
            //       id: item['id'],
            //       name: item['name']
            //   );
            // }).toList()
            [],
        picHist: pic.map((item) {
          return PicHist.fromJson(item);
        }).toList(),
        laboratory: labo.map((item) {
          return Laboratory(id: item['t_d_jo_laboratory_id'], laboratoriumId: item['laboratorium_id'], name: item['name'], maxStage: item['max_stage']);
        }).toList());
    barges.value = dataJoDetail.value.detail?.barge?.split('|') ?? [];
    if (barges.value.length != 0) {
      barges.value.forEach((_) {
        bargesController.value.add(TextEditingController());
      });
    }
    if (labo != null) {
      labo.forEach((lab) {
        labs.value.add(Laboratory.fromJson(lab));
        labsTemp.value.add(Laboratory.fromJson(lab));
      });
    }
    bargesCount = barges.value.length != 0 ? barges.value.length : 0;
    activity5bargesCount = bargesCount;
    activity5Barges.value = barges.value;
    update();
    if (dataJoDetail.value.inspectionFinishedDate != '' && dataJoDetail.value.laboratoryFinishedDate == '') {
      activityFinished.value = true;
    } else if (dataJoDetail.value.inspectionFinishedDate == '' && dataJoDetail.value.laboratoryFinishedDate != '') {
      activityFinished.value = true;
    } else if (dataJoDetail.value.inspectionFinishedDate != '' && dataJoDetail.value.laboratoryFinishedDate != '') {
      activityFinished.value = true;
    }
    update();
    debugPrint('finishnya nih: ${activityFinished.value}');
    debugPrint('barges : ${jsonEncode(barges.value)}');
  }

  Future<void> getJoDailyActivityLocalV2() async {
    stageList.value = [];
    List<Map<String, dynamic>> result = [];
    final db = await SqlHelper.db();

    THJo joRslt = await THJo.getJoById(id);
    debugPrint("print data jo ${joRslt.toJson()}");
    joRx.value = joRslt;

    // Retrieve data from the database
    try {
      result = await db.rawQuery('''
         SELECT
         s.*, u.name as uom_name
         FROM t_d_jo_inspection_activity_stages AS s
          LEFT JOIN m_uom AS u ON s.uom_id = u.id
          WHERE s.t_h_jo_id = $id AND s.is_active = 1
        ''');

      /// Buffer the query
      await Future<dynamic>.delayed(const Duration(milliseconds: 500));

      // Create a modifiable list of stages
      List<Map<String, dynamic>> modifiableResult = result.map((stage) => Map<String, dynamic>.from(stage)).toList();

      for (var stage in modifiableResult) {
        debugPrint('data modifiable update: ${jsonEncode(stage)}');
        int tHJoId = stage['t_h_jo_id'];
        int stageId = stage['id']; // use this or 't_d_jo_inspection_activity_stages_id' if it exists
        int stageStatusId = stage['m_statusinspectionstages_id'];
        debugPrint('params nya ini: $tHJoId, $stageId, $stageStatusId');

        activityStage = stageStatusId;
        activitySubmitted.value = true;
        update();

        // Query related data from t_d_jo_inspection_activity
        List<Map<String, dynamic>> activityResult = await db.query(
          't_d_jo_inspection_activity',
          where: 't_h_jo_id = ? and t_d_jo_inspection_activity_stages_id = ? and is_active = ?',
          // add additional criteria if necessary
          whereArgs: [tHJoId, stageId, 1],
        );
        debugPrint("print activity result 1517  ${activityResult}");

        List<Map<String, dynamic>> activityBarge = await db.query(
          't_d_jo_inspection_activity_barge',
          where: 't_h_jo_id = ? and t_d_jo_inspection_activity_stages_id = ? and is_active = ?',
          // add additional criteria if necessary
          whereArgs: [tHJoId, stageId, 1],
        );

        List<Map<String, dynamic>> activityVessel = await db.query('t_d_jo_inspection_activity_vessel',
            where: 't_h_jo_id = ? and t_d_jo_inspection_activity_stages_id = ? and is_active = ?',
            // add additional criteria if necessary
            whereArgs: [tHJoId, stageId, 1],
            limit: 1);

        List<Map<String, dynamic>> activityStageTranshipment = await db.rawQuery('''
          SELECT t.*, u.name as uom_name
          FROM t_d_jo_inspection_activity_stages_transhipment AS t
          LEFT JOIN m_uom AS u ON t.uom_id = u.id
          WHERE t.t_d_inspection_stages_id = ? AND t.is_active = ?
        ''', [stageId, 1]);

        debugPrint("print stage Transhipment 1541 ${activityStageTranshipment} stage ${stageId}");
        // Add activityResult to the current stage
        stage['listactivity'] = activityResult;
        stage['listactivitybarge'] = activityBarge;
        stage['listactivitystagetranshipment'] = activityStageTranshipment;
        if (activityVessel.length > 0) {
          stage['activityvesel'] = activityVessel[0]; //first index
        } else {
          stage['activityvesel'] = null;
        }
      }

      // Convert the modifiableResult list to List<TDJoInspectionActivityStages>
      List<TDJoInspectionActivityStages> stagesList = modifiableResult.map((json) => TDJoInspectionActivityStages.fromJson(json)).toList();

      stageList.value = stagesList;

      if (stageList.value.where((item) => item.mStatusinspectionstagesId == 6).isNotEmpty) {
        await getJoDailyActivity6AttachmentLocal();
        isReportClient.value = true;
      }

      debugPrint("print stage list 1559  ${jsonEncode(stagesList)}");
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      activity6Attachments.value = [];
      update();
    }
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
    final http.Response responseData = await http.get(Uri.parse('${AppConstant.CORE_URL}/$strURL'));
    var uint8list = responseData.bodyBytes;
    var buffer = uint8list.buffer;
    ByteData byteData = ByteData.view(buffer);
    var filenameArr = strURL.split("/");
    var filename = filenameArr.last;
    var tempDir = await providerAndroid.getTemporaryPath();
    final File file = await File('${tempDir}/${filename}').writeAsBytes(buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    debugPrint('image file path: ${file}');
    return file;
  }

  Future<void> getJoDailyActivity() async {
    var response = await repository.getJoListDailyActivity(id) ?? JoListDailyActivity();
    debugPrint('JO Daily Activity: ${jsonEncode(response)}');
    dataListActivity.value = response.data?.data! ?? [];
    if (dataListActivity.value.isNotEmpty) {
      debugPrint('stage now: ${dataListActivity.value.last.mStatusinspectionstagesId.toString()}');
      activityStage = int.parse(dataListActivity.value.last.mStatusinspectionstagesId.toString()) + 1;
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
    dataListActivity.value = response.map((item) {
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

  Future<void> getJoDailyActivity6() async {
    var response = await repository.getJoListDailyActivity6(id) ?? JoListDailyActivity6();
    debugPrint('JO Daily Activity 6: ${jsonEncode(response)}');
    debugPrint('JO Daily Activity 6 Attachments: ${jsonEncode(response.image)}');
    dataListActivity6.value = response?.data ?? DataListActivity6();
    dataListActivity6Attachments.value = response?.image ?? Activity6Attachments();
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
      // activity6Attachments.value.add(data);
    });
  }

  Future<void> getJoDailyActivity6AttachmentLocal() async {
    final db = await SqlHelper.db();
    List<Map<String, dynamic>> result = await db.query(
      't_d_jo_inspection_attachment',
      where: 't_h_jo_id = ? and is_active = 1',
      whereArgs: [id],
    );

    debugPrint('activity stage 6 attachmentnya: ${jsonEncode(result)}');

    // dailyActivityPhotos.value = [];
    // dailyActivityPhotosDesc.value = [];
    // dailyActivityPhotosDescText.value = [];
    // dailyActivityPhotosV2.value = [];
    var attachments = result.map((json) {
      return TDJoInspectionAttachment.fromJson(json);
    }).toList();
    update();

    activity6AttachmentsStage.value = attachments;
    update();
  }

  void searchLab() {
    final String search = searchLabText.text;
    debugPrint('hasil search text nya: $search');
    var dataSearch = labsTemp.value.where((value) => (value.name?.toLowerCase() == search.toLowerCase() || (value.name?.toLowerCase() ?? '').contains(search.toLowerCase()))).toList();
    debugPrint('hasil search: ${jsonEncode(dataSearch)}');
    labs.value = dataSearch;
    if (search == '') {
      labs.value = labsTemp.value;
      update();
    }
    update();
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

  Future<void> changeStatusJoLocal() async {
    try {
      final db = await SqlHelper.db();
      db.execute('''
          UPDATE t_h_jo
          SET m_statusjo_id = 3
          WHERE id = $id;
        ''');
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      update();
    }
  }

  // Activity Photo Functions

  Future cameraImage() async {
    File? image;
    try {
      final XFile? pic = await picker.pickImage(source: ImageSource.camera, imageQuality: 15);
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
      final XFile? pic = await picker.pickImage(source: ImageSource.gallery, imageQuality: 15);
      final imageTemp = File(pic!.path);
      image = imageTemp;
      update();
      return image;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void adddailyActivityPhotos(int index, File foto, String desc) {
    dailyActivityPhotosTemp.value[index] = foto.path;
    dailyActivityPhotosDescTextTemp.value[index] = desc;
  }

  void adddailyActivityPhotoForm() {
    adddailyActivityPhotosCount.value++;
    dailyActivityPhotosTemp.value.add('');
    dailyActivityPhotosDescTemp.value.add(TextEditingController());
    dailyActivityPhotosDescTextTemp.value.add('');
  }

  void removePhotoActivityByIndex(int index) {
    dailyActivityPhotosTemp.value.removeAt(index);
    dailyActivityPhotosDescTemp.value.removeAt(index);
    dailyActivityPhotosDescTextTemp.value.removeAt(index);
    adddailyActivityPhotosCount.value--;
  }

  void removePhotoActivity() {
    dailyActivityPhotosTemp.value.removeLast();
    dailyActivityPhotosDescTemp.value.removeLast();
    dailyActivityPhotosDescTextTemp.value.removeLast();
    adddailyActivityPhotosCount.value--;
  }

  void editPhotoActivityDesc(int index, String desc) {
    dailyActivityPhotosDescText[index] = desc;
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
    //clear data
    dailyActivityPhotosTemp.value = [];
    adddailyActivityPhotosCount.value = 0;
    dailyActivityPhotosDescTemp.value = [];
    dailyActivityPhotosDescTextTemp.value = [];
    //insert data
    dailyActivityPhotosTemp.value.add('');
    adddailyActivityPhotosCount.value++;
    dailyActivityPhotosDescTemp.value.add(TextEditingController());
    dailyActivityPhotosDescTextTemp.value.add('');

    Get.bottomSheet(
        GetBuilder(
          init: JoDetailController(),
          builder: (controller) => Container(
              margin: const EdgeInsets.only(top: 48),
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add JO Photos',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: primaryColor),
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
                            Form(
                              key: _formKey,
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: adddailyActivityPhotosCount.value,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text('Photo ${index + 1}'),
                                            SizedBox(width: 8),
                                            index > 0
                                                ? InkWell(
                                                    onTap: () {
                                                      removePhotoActivityByIndex(index);
                                                      debugPrint('Delete index');
                                                    },
                                                    child: const ImageIcon(AssetImage("assets/icons/deleteStage.png"), color: Colors.red, size: 16),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        dailyActivityPhotosTemp.value[index] != ''
                                            ? InkWell(
                                                onTap: () async {
                                                  inspectionMediaPickerConfirm(index);
                                                },
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  child: Image.file(
                                                    height: 72,
                                                    width: 72,
                                                    File(dailyActivityPhotosTemp.value[index]),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ))
                                            : InkWell(
                                                onTap: () async {
                                                  inspectionMediaPickerConfirm(index);
                                                },
                                                child: Container(
                                                  height: 54,
                                                  width: 54,
                                                  decoration: BoxDecoration(border: Border.all(color: primaryColor), borderRadius: BorderRadius.circular(8)),
                                                  child: const Center(
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
                                          controller: dailyActivityPhotosDescTemp.value[index],
                                          onChanged: (value) {
                                            editPhotoActivityDesc(index, value);
                                          },
                                          enabled: (dailyActivityPhotosTemp.value[index] != ""),
                                          validator: (value) {
                                            if (dailyActivityPhotosTemp.value[index] != "" && (value == null || value.isEmpty)) {
                                              return 'Deskripsi wajib diisi!';
                                            }
                                            return null;
                                          },
                                          cursorColor: onFocusColor,
                                          style: const TextStyle(color: onFocusColor),
                                          inputFormatters: [
                                            new LengthLimitingTextInputFormatter(150),
                                          ],
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: onFocusColor),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              labelText: 'Description',
                                              floatingLabelStyle: const TextStyle(color: onFocusColor),
                                              fillColor: onFocusColor),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    adddailyActivityPhotoForm();
                                    update();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    height: 42,
                                    width: 42,
                                    decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8)),
                                    child: const Center(
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
                                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                                          child: const Center(
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
                            onPressed: () async {
                              Get.back();
                              dailyActivityPhotosTemp.value.clear();
                              dailyActivityPhotosDescTemp.value.clear();
                              adddailyActivityPhotosCount.value = 0;
                              await getJoDailyActivityLocalV2();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                            child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                width: double.infinity,
                                child: const Center(
                                    child: Text(
                                  'Cancel',
                                  style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                                )))),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (editActivityMode.value == false) {
                                  addActivityDailyPhotoConfirm();
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                width: double.infinity,
                                child: const Center(
                                    child: Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
    List<String> dailyPhoto = dailyActivityPhotosTemp.value;
    bool isValid = true;
    for (int i = 0; i < dailyPhoto.length; i++) {
      if (dailyPhoto[i].length == 0) {
        isValid = false;
        break;
      }
    }

    if (isValid) {
      Get.dialog(
        AlertDialog(
          title: const Text(
            'Attention',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
          ),
          content: const Text('Apakah benar anda ingin menambahkan foto JO ini?'),
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
                sendActivityDailyPhotoV2();
                Get.back();
                Get.back();
              },
            ),
          ],
        ),
      );
    } else {
      openDialog("Attenction", "Photo belum diambil"); // modified attention
    }
  }

  void previewImage(int index, String photo, String desc, TDJoInspectionPict pict) async {
    debugPrint('index image edit: $index');
    dailyActivityPhotosDescEdit.value.text = desc;
    activityPreviewFoto.value = await File(photo);
    Get.dialog(
      GetBuilder(
          init: JoDetailController(),
          builder: (controller) {
            var photoPreview = activityPreviewFoto.value;
            return AlertDialog(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Photo and Description ${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  dataJoDetail.value.detail?.statusJo == 'Assigned' || dataJoDetail.value.detail?.statusJo == 'On Progres'
                      ? InkWell(
                          onTap: () {
                            deleteActivityDailyPhotoConfirm(pict!.id!.toInt());
                          },
                          child: const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
                        )
                      : const SizedBox(),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
              content: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(Get.context!).viewInsets.bottom != 0 ? 100.h : 200.h,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                await inspectionMediaPreviewPickerConfirmEdit(index);
                                photoPreview = activityPreviewFoto.value;
                                update();
                              },
                              child: Center(
                                child: SizedBox(
                                  height: MediaQuery.of(Get.context!).viewInsets.bottom != 0 ? 66.h : 180.h,
                                  width: MediaQuery.sizeOf(Get.context!).width.w,
                                  child: Image.file(
                                    photoPreview,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            dataJoDetail.value.detail?.statusJo == 'Assigned' || dataJoDetail.value.detail?.statusJo == 'On Progres'
                                ? SizedBox(
                                    child: TextFormField(
                                      controller: dailyActivityPhotosDescEdit.value,
                                      cursorColor: onFocusColor,
                                      style: const TextStyle(color: onFocusColor),
                                      inputFormatters: [
                                        new LengthLimitingTextInputFormatter(150),
                                      ],
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: onFocusColor),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          labelText: 'Description',
                                          floatingLabelStyle: const TextStyle(color: onFocusColor),
                                          fillColor: onFocusColor),
                                    ),
                                  )
                                : Text(desc),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                dataJoDetail.value.detail?.statusJo == 'Assigned' || dataJoDetail.value.detail?.statusJo == 'On Progres'
                    ? ElevatedButton(
                        onPressed: () {
                          updateActivityDailyPhotoConfirm(index, pict!.id!.toInt(), dailyActivityPhotosDescEdit.value.text);
                          // editPhotoActivityDescV2(index, pict!.id!.toInt(),
                          //     dailyActivityPhotosDescEdit.value.text);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            width: double.infinity,
                            child: const Center(
                                child: Text(
                              'Save',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ))))
                    : const SizedBox(),
              ],
            );
          }),
    );
  }

  void updateActivityConfirm(File foto, int index, String desc) {
    if (desc.length == 0) {
      openDialog("Attention", "Photo descriksi tidak boleh kosong");
    } else {
      Get.dialog(
        AlertDialog(
          title: const Text(
            'Attention',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
          ),
          content: const Text('Apakah benar anda ingin menyimpan perubahan foto JO ini?'),
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
                  getJoDailyPhotoV2();
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
  }

  void deleteActivityDailyPhotoConfirm(int id) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: const Text('Apakah benar anda ingin menghapus foto JO ini?'),
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
              var delete = await deletePhotoV2(id);
              if (delete == 'success') {
                await getJoDailyPhotoV2();
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
        title: const Text(
          'Photo Attachment',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: const Text('Pilih sumber foto yang ingin dilampirkan.'),
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
                          adddailyActivityPhotos(index, file, '');
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                        child: const Center(
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
                          debugPrint('file yang mau diinput: ${file.path}');
                          adddailyActivityPhotos(index, file, '');
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                        child: const Center(
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
        title: const Text(
          'Photo Attachment',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: const Text('Pilih sumber foto yang ingin dilampirkan.'),
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
                            backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                        child: const Center(
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
                            backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                        child: const Center(
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
        title: const Text(
          'Photo Attachment',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: const Text('Pilih sumber foto yang ingin dilampirkan.'),
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
                          debugPrint('update image path: ${file.path}');
                          activityPreviewFoto.value = file;
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                        child: const Center(
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
                          updateActivityDailyPhoto(file, int.parse(dataJoDailyPhotos.value[index].id!.toString()), dailyActivityPhotosDescEdit.value.text);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                        child: const Center(
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
    final DateTime? picked =
        await showDatePicker(context: context, firstDate: DateTime.now().subtract(const Duration(days: 1)), lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1));
    if (picked != null) {
      activityDate.text = DateFormat('yyyy-MM-dd').format(picked).toString();
    }
  }

  Future<String> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: pickedTime != '' ? TimeOfDay(hour:int.parse(pickedTime.split(":")[0]),minute: int.parse(pickedTime.split(":")[1])) : TimeOfDay.now(),
        builder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                // Using 24-Hour format
                  alwaysUse24HourFormat: true),
              // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
              child: childWidget!);
        }
    );
    if (picked != null) {
      //debugPrint('hasil pick time:${picked.hour}:${picked.minute}');
      final String time = '${picked.hour}:${picked.minute}';
      // List timeSplit = picked.format(context).split(' ');
      // final String formattedTime = timeSplit[0];
      // final String time = formattedTime;
      return time;
    } else {
      return '';
    }
  }

  // START V2

  void addActivityV2() {
    TDJoInspectionActivity activity = new TDJoInspectionActivity(
      id: DateTime.now().millisecondsSinceEpoch,
      tHJoId: id,
      //Date now to int
      activity: activityText.text,
      endActivityTime: activityEndTime.text,
      startActivityTime: activityStartTime.text,
      isActive: 1,
      isUpload: 0,
    );

    final List<TDJoInspectionActivity> listActivity = [];
    listActivity.add(activity);

    List<TDJoInspectionActivityStages> oldTdJoInspections = stageListModal.value;

    TDJoInspectionActivityStages? matchingStage = oldTdJoInspections.firstWhere(
      (stage) => stage.transDate == activityDate.text,
      orElse: () => TDJoInspectionActivityStages(),
    );

    debugPrint('Matching old Stage ${jsonEncode(matchingStage.toJson())}');
    //jika transdate tidak null dan transdate tidak sama "" maka update old data
    if (matchingStage.transDate != null && matchingStage.transDate.toString() != "") {
      matchingStage.listActivity?.add(activity);
      //sudah otomatis ke update karena update secara langsung
    } else {
      TDJoInspectionActivityStages stages = TDJoInspectionActivityStages(transDate: activityDate.text, mStatusinspectionstagesId: activityStage, listActivity: listActivity);
      stageListModal.add(stages);
      activityListTextController.value.add(TextEditingController());
    }

    activityDate.text = '';
    activityStartTime.text = '';
    activityEndTime.text = '';
    activityText.text = '';
    update();
  }

  void deleteActivityHeaderV2(String transdate) {
    final List<TDJoInspectionActivityStages> stageListModalOld = stageListModal.map((stage) => TDJoInspectionActivityStages.fromJson(stage.toJson())).toList();
    //stageListModalOld.removeWhere((stage) => stage.transDate == transdate);
    int removeIndex = stageListModalOld.indexWhere((stage) => stage.transDate == transdate);

    if (removeIndex != -1) {
      // Remove the stage based on transdate
      stageListModalOld.removeAt(removeIndex);
      stageListModal.value = stageListModalOld;

      // Remove corresponding TextEditingController based on the removed index
      if (removeIndex < activityListTextController.value.length) {
        activityListTextController.value.removeAt(removeIndex);
      }
    }

    //stageList.value = stageListModalOld;
    //remove activityListTextController berdasarkan index stageListModalOld.removeWhere
    activityListTextController.value.add(TextEditingController());
    update();
  }

  void deleteActivityDetailV2(String transDate, String actDelete) {
    //Copy old data
    final List<TDJoInspectionActivityStages> stageListModalOld = stageListModal.map((stage) => TDJoInspectionActivityStages.fromJson(stage.toJson())).toList();

    TDJoInspectionActivityStages? matchingStage = stageListModalOld.firstWhere(
      (stage) => stage.transDate == transDate,
      orElse: () => TDJoInspectionActivityStages(),
    );
    if (matchingStage.transDate != null && matchingStage.transDate.toString() != "") {
      matchingStage.listActivity?.removeWhere((activity) => activity.activity == actDelete);

      int index = stageListModalOld.indexWhere((stage) => stage.transDate == matchingStage.transDate);

      if (index != -1) {
        stageListModalOld[index] = matchingStage;
      }
    }
    stageListModal.value = stageListModalOld;
    update();
  }

  void editActivityDetailV2(String transDate, String actEdit) {
    TDJoInspectionActivityStages? matchingStage = stageListModal.value.firstWhere(
      (stage) => stage.transDate == transDate,
      orElse: () => TDJoInspectionActivityStages(),
    );

    if (matchingStage.transDate != null && matchingStage.transDate.toString() != "") {
      //matchingStage.listActivity?.removeWhere((activity) => activity.activity == actEdit);
      TDJoInspectionActivity? matchinAtivity = matchingStage.listActivity?.firstWhere((act) => act.activity == actEdit, orElse: TDJoInspectionActivity.new);

      debugPrint('yang lagi di editin: ${jsonEncode(matchinAtivity)}');

      if (matchinAtivity != null && matchinAtivity.activity.toString() != "") {
        activityDate.text = matchingStage!.transDate!;
        activityStartTime.text = matchinAtivity.startActivityTime!;
        activityEndTime.text = matchinAtivity.endActivityTime!;
        activityText.text = matchinAtivity.activity!;
        editActivityMode.value = true;
        enabledDate.value = false;
        editActivityIndex.value = matchinAtivity.id!.toInt();
        update();
      }
    }
  }

  void updateActivityDetailV2() {
    // edit Rx
    TDJoInspectionActivityStages? matchingStage = stageListModal.value.firstWhere(
      (stage) => stage.transDate == activityDate.text,
      orElse: () => TDJoInspectionActivityStages(),
    );

    if (matchingStage.transDate != null && matchingStage.transDate.toString() != "") {
      TDJoInspectionActivity? matchinAtivity = matchingStage.listActivity?.firstWhere((act) => act.id == editActivityIndex.value, orElse: TDJoInspectionActivity.new);

      if (matchinAtivity != null && (matchinAtivity.id ?? 0) > 0) {
        matchinAtivity.startActivityTime = activityStartTime.text;
        matchinAtivity.endActivityTime = activityEndTime.text;
        matchinAtivity.activity = activityText.text;

        //update ke activity
        int? indexDetail = matchingStage.listActivity?.indexWhere((act) => act!.id! == matchinAtivity!.id!);

        if (indexDetail != null && indexDetail != -1) {
          matchingStage.listActivity![indexDetail] = matchinAtivity;
        }

        int index = stageListModal.indexWhere((stage) => stage.transDate == matchingStage.transDate);
        if (index != -1) {
          stageListModal[index] = matchingStage;
        }

        cleanActivity();
        update(); // Notify observers
      }
    }
  }

  Future<bool> saveActivityStageV2() async {
    final db = await SqlHelper.db();
    List<TDJoInspectionActivityStages> stages = stageListModal.value;
    final createdBy = userData.value!.id;
    stages.asMap().forEach((index, stage) async {
      debugPrint("data input ${jsonEncode(stage.toJson())}");
      TDJoInspectionActivityStages data = TDJoInspectionActivityStages(
        tHJoId: id,
        mStatusinspectionstagesId: stage.mStatusinspectionstagesId,
        transDate: stage.transDate,
        code: "JOIAST-${stage.mStatusinspectionstagesId}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}",
        isUpload: "0",
        isActive: "1",
        createdBy: userData.value!.id,
        createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
        remarks: activityListTextController.value[index].text,
      );
      int result = await db.insert("t_d_jo_inspection_activity_stages", data.toInsert());
      //dapatkan id yang baru insert
      List<TDJoInspectionActivity> details = stage.listActivity ?? [];
      details.forEach((activity) async {
        TDJoInspectionActivity detail = TDJoInspectionActivity(
            tHJoId: id,
            tDJoInspectionActivityStagesId: result,
            startActivityTime: activity.startActivityTime,
            endActivityTime: activity.endActivityTime,
            activity: activity.activity,
            code: 'JOIAS-${stage.mStatusinspectionstagesId}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}',
            isActive: 1,
            isUpload: 0,
            createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
            createdBy: createdBy);
        await db.insert("t_d_jo_inspection_activity", detail.toInsert());
      });
    });
    stageListModal.value = [];
    activityListTextController.value = [];
    return true;
  }

  Future<bool> editActivityStagesV2() async {
    try {
      final db = await SqlHelper.db();
      List<TDJoInspectionActivityStages> stages = stageListModal.value;
      final createdBy = userData.value!.id;
      //deactive semua aktifitas dan stagenya
      // update table t_d_jo_inspection_activity_stages set is_active =0 berdasarkan thjoid dan transdate dan mStatusinspectionstagesId
      int result = await db.update(
        't_d_jo_inspection_activity_stages',
        {'is_active': 0}, // The new value for the is_active field
        where: 't_h_jo_id = ?  AND m_statusinspectionstages_id = ?',
        whereArgs: [id, activityStage],
      );

      //debugPrint("data input edit deactive ${result} ${id} ${statusId}");
      debugPrint("data input edit remarks ${activityListTextController.value}");

      stages.asMap().forEach((index, stage) async {
        debugPrint("data input edit ${jsonEncode(stage.toJson())}");
        if (stage.id != null) {
          TDJoInspectionActivityStages data = TDJoInspectionActivityStages(
              isUpload: "0",
              isActive: "1",
              updatedBy: userData.value!.id.toString(),
              updatedAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
              remarks: activityListTextController.value[index].text);

          int updated = await db.update(
            't_d_jo_inspection_activity_stages',
            data.toEdit(),
            where: 'id = ? ',
            whereArgs: [stage.id],
          );

          //inactive detail
          int detail = await db.update(
            't_d_jo_inspection_activity',
            {'is_active': 0}, // The new value for the is_active field
            where: 't_d_jo_inspection_activity_stages_id = ?',
            whereArgs: [stage.id],
          );
          List<TDJoInspectionActivity> listActivity = stage.listActivity ?? [];
          listActivity.forEach((activity) async {
            if (activity.code != null) {
              //Update
              TDJoInspectionActivity detail = TDJoInspectionActivity(
                  startActivityTime: activity.startActivityTime,
                  endActivityTime: activity.endActivityTime,
                  activity: activity.activity,
                  isActive: 1,
                  isUpload: 0,
                  updatedAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
                  updatedBy: createdBy.toString());
              update();
              debugPrint('data yang update nya : ${jsonEncode(detail)}');

              int updated = await db.update(
                't_d_jo_inspection_activity',
                detail.toEdit(),
                where: 'id = ?',
                whereArgs: [activity.id],
              );
              debugPrint("Print Edit ${activity.id} ${updated}");
            } else {
              //insert
              TDJoInspectionActivity detail = TDJoInspectionActivity(
                  tHJoId: id,
                  tDJoInspectionActivityStagesId: stage.id,
                  startActivityTime: activity.startActivityTime,
                  endActivityTime: activity.endActivityTime,
                  activity: activity.activity,
                  code: 'JOIA-${stage.mStatusinspectionstagesId}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}',
                  isActive: 1,
                  isUpload: 0,
                  createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
                  createdBy: createdBy);
              int raw = await db.insert("t_d_jo_inspection_activity", detail.toInsert());
              debugPrint("Print Edit ${activity.id} ${raw}");
            }
          });
        } else {
          TDJoInspectionActivityStages data = TDJoInspectionActivityStages(
            tHJoId: id,
            mStatusinspectionstagesId: stage.mStatusinspectionstagesId,
            transDate: stage.transDate,
            code: "JOIAST-${stage.mStatusinspectionstagesId}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}",
            isUpload: "0",
            isActive: "1",
            createdBy: userData.value!.id,
            remarks: activityListTextController.value[index].text,
            createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
          );
          int result = await db.insert("t_d_jo_inspection_activity_stages", data.toInsert());
          List<TDJoInspectionActivity> details = stage.listActivity ?? [];
          details.forEach((activity) async {
            TDJoInspectionActivity detail = TDJoInspectionActivity(
                tHJoId: id,
                tDJoInspectionActivityStagesId: result,
                startActivityTime: activity.startActivityTime,
                endActivityTime: activity.endActivityTime,
                activity: activity.activity,
                code: 'JOIA-${stage.mStatusinspectionstagesId}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}',
                isActive: 1,
                isUpload: 0,
                createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
                createdBy: createdBy);
            await db.insert("t_d_jo_inspection_activity", detail.toInsert());
          });
        }
      });
      stageListModal.value = [];
      activityListTextController.value = [];
      return true;
    } catch (e) {
      // Handle any parsing errors
      return false; // Return the original time if parsing fails
    }
  }

  void sendActivityDailyPhotoV2() async {
    int success = 0;
    final db = await SqlHelper.db();
    //t_h_jo_id = id
    //createdBy
    final createdBy = userData.value!.id;
    //DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now())
    if (dailyActivityPhotosTemp.value.isNotEmpty && dailyActivityPhotosDescTemp.value.isNotEmpty) {
      for (var i = 0; i < dailyActivityPhotosTemp.value.length; i++) {
        final File photo = File(dailyActivityPhotosTemp.value[i]);
        final TextEditingController desc = dailyActivityPhotosDescTemp.value[i];
        TDJoInspectionPict pict = TDJoInspectionPict(
            tHJoId: id,
            pathPhoto: photo.path,
            keterangan: desc.text.toString(),
            code: "JOIP-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now()).toString()}",
            createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
            isActive: 1,
            isUpload: 1);
        int result = await db.insert("t_d_jo_inspection_pict", pict.toJson());

        if (result > 0) {
          success++;
          //dailyActivityPhotos.value.add(photo);
          //dailyActivityPhotosDesc.value.add(desc);
        }
      }
    } else {
      openDialog('Failed', 'Tidak ada foto yang diSimpan');
    }

    debugPrint("count input db ${success}");
    debugPrint("count input ui ${dailyActivityPhotos.value.length}");
    if (success == dailyActivityPhotosTemp.value.length) {
      //openDialog('Success', 'Foto berhasil dikirm');
      if (dataJoDetail.value.detail?.idStatusJo == 2 && activityList.value.isEmpty) {
        await changeStatusJoLocal();
      }
      // changeStatusJo();
      getJoDailyPhotoV2();
      dailyActivityPhotosTemp.value = [];
      dailyActivityPhotosDescTemp.value = [];
      dailyActivityPhotosDescTextTemp.value = [];
      adddailyActivityPhotosCount.value = 0;
    } else {
      openDialog('Attention', 'Beberapa foto gagal dikirim');
    }
  }

  Future<void> getJoDailyPhotoV2() async {
    final db = await SqlHelper.db();
    List<Map<String, dynamic>> result = await db.query(
      't_d_jo_inspection_pict',
      where: 't_h_jo_id = ? and is_active = 1',
      whereArgs: [id],
    );
    dailyActivityPhotos.value = [];
    dailyActivityPhotosDesc.value = [];
    dailyActivityPhotosDescText.value = [];
    dailyActivityPhotosV2.value = [];

    List<TDJoInspectionPict> pict = result.map((json) => TDJoInspectionPict.fromJson(json)).toList();
    dailyActivityPhotosV2.value = pict;
    // TextEditingController tempPhotoDesc = TextEditingController();
    // result.forEach((item) async{
    //   //final File photo = await getImagesFromUrl(item['path_photo']);
    //  // dailyActivityPhotos.value.add(item['path_photo']);
    //   tempPhotoDesc.text = item['keterangan'] ?? '';
    //   dailyActivityPhotosDesc.value.add(tempPhotoDesc);
    //   dailyActivityPhotosDescText.value.add(item['keterangan'] ?? '');
    // });

    // var response = await repository.getJoDailyPhoto(id) ?? JoDailyPhoto();
    // debugPrint('JO Daily Photo: ${jsonEncode(response)}');
    // if (response.data!.isNotEmpty) {
    //   dataJoDailyPhotos.value = response?.data ?? [];
    //   if (dataJoDailyPhotos.value.isNotEmpty) {
    //     isLoadingJOImage = true;
    //     update();
    //     dailyActivityPhotos.value = [];
    //     TextEditingController tempPhotoDesc = TextEditingController();
    //     dataJoDailyPhotos.value.forEach((data) async {
    //       final File photo = await getImagesFromUrl(data.pathPhoto!);
    //       dailyActivityPhotos.value.add(photo);
    //       tempPhotoDesc.text = data.keterangan ?? '';
    //       dailyActivityPhotosDesc.value.add(tempPhotoDesc);
    //       dailyActivityPhotosDescText.value.add(data.keterangan ?? '');
    //       update();
    //     });
    //     isLoadingJOImage = false;
    //     update();
    //   }
    // }
  }

  Future<String> deletePhotoV2(int id) async {
    final db = await SqlHelper.db();

    int result = await db.update('t_d_jo_inspection_pict', {"is_active": 0}, where: "id = ?", whereArgs: [id]);

    if (result == 0) {
      return 'failed';
    } else {
      return 'success';
    }
  }

  void updateActivityDailyPhotoConfirm(int index, int idEdit, String desc) {
    if (desc.length == 0) {
      openDialog("Attention", "Photo deskripsi tidak boleh kosong");
    } else {
      Get.dialog(
        AlertDialog(
          title: const Text(
            'Attention',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
          ),
          content: const Text('Apakah benar anda ingin menyimpan perubahan foto JO ini?'),
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
                editPhotoActivityDescV2(index, idEdit, desc);
                Get.back();
                Get.back();
                //sendActivityDailyPhoto();
              },
            ),
          ],
        ),
      );
    }
  }

  void editPhotoActivityDescV2(int index, int idEdit, String desc) async {
    final db = await SqlHelper.db();

    int result = await db.update('t_d_jo_inspection_pict', {"path_photo": activityPreviewFoto.value.path, "keterangan": desc}, where: "id = ?", whereArgs: [idEdit]);
    if (result > 0) {
      await getJoDailyPhotoV2();
    }
    update();
  }

  Future<String?> addActivity5StageV2() async {
    await addActivity5();
    try {
      final db = await SqlHelper.db();
      final createdBy = userData.value!.id;
      for (var item in activity5List.value) {
        debugPrint("form item ${item.toJson()}");
        TDJoInspectionActivityStages data = TDJoInspectionActivityStages(
            tHJoId: item.tHJoId,
            mStatusinspectionstagesId: item.mStatusinspectionstagesId,
            transDate: item.transDate,
            code: "JOIAST-${item.mStatusinspectionstagesId}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}",
            isUpload: "0",
            isActive: "1",
            createdBy: userData.value!.id,
            createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
            uomId: item.uomId.toString(),
            actualQty: item.actualQty);
        int rawStage = await db.insert("t_d_jo_inspection_activity_stages", data.toInsert());
        TDJoInspectionActivity detail = TDJoInspectionActivity(
            tHJoId: item.tHJoId,
            tDJoInspectionActivityStagesId: rawStage,
            code: 'JOIA-5-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}',
            isActive: 1,
            isUpload: 0,
            activity: '-',
            createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
            createdBy: createdBy);
        int rawAct = await db.insert("t_d_jo_inspection_activity", detail.toInsert());

        TDJoInspectionActivityVessel dVesel = TDJoInspectionActivityVessel(
          tHJoId: item.tHJoId,
          tDJoInspectionActivityStagesId: rawStage,
          vessel: item.vessel,
          code: "JOIAV-${item.mStatusinspectionstagesId}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}",
          isUpload: 0,
          isActive: 1,
          createdBy: createdBy,
          createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
        );

        int rawVesel = await db.insert("t_d_jo_inspection_activity_vessel", dVesel.toInsert());

        var bargeCount = 0;
        for (var barge in item!.barge!) {
          bargeCount++;
          debugPrint('barge nya yang mau diinsert : ${barge.barge}');
          if (barge.barge != null || barge.barge != '') {
            TDJoInspectionActivityBarge dBarge = TDJoInspectionActivityBarge(
              tHJoId: item.tHJoId,
              tDJoInspectionActivityStagesId: rawStage,
              barge: barge.barge,
              code: "JOIAB-${item.mStatusinspectionstagesId}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}-${bargeCount}",
              isUpload: 0,
              isActive: 1,
              createdBy: createdBy,
              createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
            );

            await db.insert("t_d_jo_inspection_activity_barge", dBarge.toInsert());
          }
        }

        var transhipmentCount = 0;
        for (var transhipment in item!.transhipment!) {
          if (transhipment.deliveryQty != null && transhipment.deliveryQty != "") {
            transhipmentCount++;
            TDJoInspectionActivityStagesTranshipment dTranshipment = TDJoInspectionActivityStagesTranshipment(
              uomId: item.uomId,
              tDInspectionStagesId: rawStage,
              tDJoInspectionActivityId: rawAct,
              initialDate: transhipment.initialDate,
              finalDate: transhipment.finalDate,
              jetty: transhipment.jetty,
              deliveryQty: double.parse(transhipment!.deliveryQty!.toString()),
              code: "JOIAT-${item.mStatusinspectionstagesId}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}-${transhipmentCount}",
              isUpload: 0,
              isActive: 1,
              createdBy: createdBy,
              createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
            );
            await db.insert("t_d_jo_inspection_activity_stages_transhipment", dTranshipment.toInsert());
          }
        }
      }
      return 'success';
    } catch (e) {
      print("print error insert stage 5  $e");
      return 'failed';
    }
  }

  num idJoActStage = 0;
  num idJoAct = 0;

  void drawerDailyActivity5EditV2() {
    //ambil state 5
    stageList.forEach((item) => {debugPrint("data json ${item.toJson()}")});
    TDJoInspectionActivityStages? filteredStage = stageList.value.firstWhere(
      (itemStage) => itemStage.mStatusinspectionstagesId == 5,
      orElse: () => TDJoInspectionActivityStages.new(), // Mengembalikan null jika tidak ditemukan
    );
    debugPrint("print data stage 5 edit ${jsonEncode(filteredStage.toJson())}");
    if (filteredStage!.id! > 0) {
      idJoActStage = filteredStage!.id!;
      activity5List.value = activity5ListStages.value;
      qtyController.text = filteredStage.actualQty ?? ''; //activity5List.value.first.actualQty ?? '';
      uomController.text = filteredStage.uomName ?? ''; //dataJoDetail.value.detail!.uomName ?? '';
      if (filteredStage.activityVesel != null) {
        vesselController.text = filteredStage.activityVesel?.vessel ?? ''; //activity5List.value.first.vessel ?? '';
      }
      List<TDJoInspectionActivity> listActivity = filteredStage.listActivity ?? [];
      if (listActivity.isNotEmpty) {
        idJoAct = listActivity!.first!.id!;
      }
      List<TDJoInspectionActivityBarge> listbarge = filteredStage.listActivityBarge ?? [];
      if (listbarge.isNotEmpty) {
        barges.value = [];
        bargesCount = 0;
        bargesController.value = [];
        activity5bargesCount = 0;
        activity5Barges.value = [];
        listbarge.forEach((iBarge) {
          barges.value.add(iBarge.barge ?? '');
          activity5Barges.value.add(iBarge.barge ?? '');
          bargesController.value.add(TextEditingController(text: iBarge.barge ?? ''));
          bargesCount++;
          activity5bargesCount++;
          debugPrint("print barge ${iBarge.barge}");
        });
      }

      jettyListTextController.value = [];
      initialDateActivity5ListTextController.value = [];
      finalDateActivity5ListTextController.value = [];
      deliveryQtyListTextController.value = [];
      activity5TranshipmentList.value = [];
      List<TDJoInspectionActivityStagesTranshipment> listTranshipment = filteredStage.listActivityStageTranshipment ?? [];
      debugPrint("print data transhipment stage 5 ${jsonEncode(filteredStage.listActivityStageTranshipment)}");
      if (listTranshipment.isNotEmpty) {
        listTranshipment.forEach((iTranshipment) {
          jettyListTextController.value.add(TextEditingController(text: iTranshipment.jetty));
          initialDateActivity5ListTextController.value.add(TextEditingController(text: iTranshipment.initialDate));
          finalDateActivity5ListTextController.value.add(TextEditingController(text: iTranshipment.finalDate));
          deliveryQtyListTextController.value.add(TextEditingController(text: iTranshipment.deliveryQty.toString()));

          activity5TranshipmentList.value.add(iTranshipment);
        });
      } else {
        jettyListTextController.value.add(TextEditingController(text: ""));
        initialDateActivity5ListTextController.value.add(TextEditingController(text: ""));
        finalDateActivity5ListTextController.value.add(TextEditingController(text: ""));
        deliveryQtyListTextController.value.add(TextEditingController(text: ""));
        activity5TranshipmentList.value.add(TDJoInspectionActivityStagesTranshipment());
      }
      activity5ListStages.value = [
        FormDataArray(
            tHJoId: id,
            mStatusinspectionstagesId: 5,
            uomId: dataJoDetail.value.detail?.uomId ?? 0,
            transDate: filteredStage.transDate,
            actualQty: filteredStage.actualQty,
            transhipment: activity5TranshipmentList)
      ];
      update();
    }
    Get.bottomSheet(
        GetBuilder(
          init: JoDetailController(),
          builder: (controller) => SizedBox(
            child: Container(
                margin: const EdgeInsets.only(top: 48),
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))),
                child: Obx(
                  () => Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Edit Stage Inspection',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: primaryColor),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'Stage 5: Work Complete',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(12),
                                    FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,3}')),
                                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
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
                                        borderSide: const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Actual Qty*',
                                      floatingLabelStyle: const TextStyle(color: onFocusColor),
                                      fillColor: onFocusColor),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  controller: uomController,
                                  cursorColor: onFocusColor,
                                  enabled: false,
                                  style: const TextStyle(color: onFocusColor),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'UOM',
                                      floatingLabelStyle: const TextStyle(color: onFocusColor),
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
                                        borderSide: const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Vessel',
                                      floatingLabelStyle: const TextStyle(color: onFocusColor),
                                      fillColor: onFocusColor),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                barges.value.isNotEmpty
                                    ? Column(children: [
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: activity5bargesCount,
                                            itemBuilder: (context, i) {
                                              bargesController.value[i].text = barges.value[i];
                                              return Column(
                                                children: [
                                                  TextFormField(
                                                    controller: bargesController.value[i],
                                                    cursorColor: onFocusColor,
                                                    onChanged: (value) {
                                                      editBargeForm(i);
                                                    },
                                                    style: const TextStyle(color: onFocusColor),
                                                    decoration: InputDecoration(
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: const BorderSide(color: onFocusColor),
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        labelText: 'Barge ${i + 1}',
                                                        floatingLabelStyle: const TextStyle(color: onFocusColor),
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
                                              padding: const EdgeInsets.symmetric(vertical: 12), backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                          child: const SizedBox(
                                              width: double.infinity,
                                              child: Center(
                                                  child: Text(
                                                'Add Barge',
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              )))),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    activity5Barges.value.length > 1
                                        ? Expanded(
                                            flex: 1,
                                            child: ElevatedButton(
                                                onPressed: removeBargeForm,
                                                style: ElevatedButton.styleFrom(
                                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                                    backgroundColor: Colors.red,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                                child: const SizedBox(
                                                    width: double.infinity,
                                                    child: Center(
                                                        child: Text(
                                                      'Delete',
                                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                    )))),
                                          )
                                        : const Expanded(flex: 1, child: SizedBox()),
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
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: activity5TranshipmentList.value.length,
                                    itemBuilder: (context, index) {
                                      var transhipment = activity5TranshipmentList[index];
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'KOS Transhipment Form ${index + 1}',
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: primaryColor),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      addActivity5Form();
                                                    },
                                                    child: Container(
                                                      margin: const EdgeInsets.only(right: 8),
                                                      height: 42,
                                                      width: 42,
                                                      decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8)),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  index > 0
                                                      ? InkWell(
                                                          onTap: removeActivity5Form,
                                                          child: Container(
                                                            margin: const EdgeInsets.only(right: 8),
                                                            height: 42,
                                                            width: 42,
                                                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                                                            child: const Center(
                                                              child: Icon(
                                                                Icons.remove,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox()
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller: jettyListTextController.value[index],
                                            cursorColor: onFocusColor,
                                            onChanged: (value) {
                                              editActivity5Transhipment(index);
                                            },
                                            inputFormatters: [
                                              new LengthLimitingTextInputFormatter(150),
                                            ],
                                            style: const TextStyle(color: onFocusColor),
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: onFocusColor),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                labelText: 'Jetty',
                                                floatingLabelStyle: const TextStyle(color: onFocusColor),
                                                fillColor: onFocusColor),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller: initialDateActivity5ListTextController.value[index],
                                            cursorColor: onFocusColor,
                                            readOnly: true,
                                            onTap: () {
                                              selectInitialDate5(context, index);
                                            },
                                            onChanged: (value) {
                                              editActivity5Transhipment(index);
                                            },
                                            style: const TextStyle(color: onFocusColor),
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: onFocusColor),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                labelText: 'Initial Date',
                                                floatingLabelStyle: const TextStyle(color: onFocusColor),
                                                fillColor: onFocusColor),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller: finalDateActivity5ListTextController.value[index],
                                            cursorColor: onFocusColor,
                                            readOnly: true,
                                            onTap: () {
                                              selectFinalDate5(context, index);
                                            },
                                            onChanged: (value) {
                                              editActivity5Transhipment(index);
                                            },
                                            style: const TextStyle(color: onFocusColor),
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: onFocusColor),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                labelText: 'Final Date',
                                                floatingLabelStyle: const TextStyle(color: onFocusColor),
                                                fillColor: onFocusColor),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller: deliveryQtyListTextController.value[index],
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(12),
                                              FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,3}')),
                                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
                                            ],
                                            cursorColor: onFocusColor,
                                            onChanged: (value) {
                                              editActivity5Transhipment(index);
                                            },
                                            style: const TextStyle(color: onFocusColor),
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: onFocusColor),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                labelText: 'Delivery Qty',
                                                floatingLabelStyle: const TextStyle(color: onFocusColor),
                                                fillColor: onFocusColor),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller: uomController,
                                            enabled: false,
                                            cursorColor: onFocusColor,
                                            style: const TextStyle(color: onFocusColor),
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: onFocusColor),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                labelText: 'UOM',
                                                floatingLabelStyle: const TextStyle(color: onFocusColor),
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
                                  onPressed: () async {
                                    checkActivity5List();
                                    Get.back();
                                    await getJoDailyActivityLocalV2();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      width: double.infinity,
                                      child: const Center(
                                          child: Text(
                                        'Cancel',
                                        style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
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
                                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      width: double.infinity,
                                      child: const Center(
                                          child: Text(
                                        'Submit',
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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

  Future<String?> editActivity5StageV2() async {
    editActivity5V2();
    // try{
    final db = await SqlHelper.db();
    final createdBy = userData.value!.id;
    for (var item in activity5List.value) {
      debugPrint("form item ${item.toJson()}");
      TDJoInspectionActivityStages data = TDJoInspectionActivityStages(
          tHJoId: item.tHJoId,
          mStatusinspectionstagesId: item.mStatusinspectionstagesId,
          transDate: item.transDate,
          // code: "JOIAST-${item.mStatusinspectionstagesId}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}",
          isUpload: "0",
          isActive: "1",
          updatedBy: createdBy.toString(),
          updatedAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
          uomId: item.uomId.toString(),
          actualQty: item.actualQty);
      int updated = await db.update(
        't_d_jo_inspection_activity_stages',
        data.toEdit(),
        where: 't_h_jo_id = ? and m_statusinspectionstages_id = ? ',
        whereArgs: [data.tHJoId, data.mStatusinspectionstagesId],
      );

      debugPrint("print updated t_d_jo_inspection_activity_stages ${updated}");
      TDJoInspectionActivity detail = TDJoInspectionActivity(
        tHJoId: item.tHJoId,
        //tDJoInspectionActivityStagesId: updated,
        // code: 'JOIA-5-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}',
        isActive: 1,
        isUpload: 0,
        activity: '-',
        updatedBy: createdBy.toString(),
        updatedAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
      );
      int rawAct = await db.update("t_d_jo_inspection_activity", detail.toEdit(), where: 't_h_jo_id = ? and t_d_jo_inspection_activity_stages_id = ?', whereArgs: [detail.tHJoId, idJoActStage]);
      debugPrint("print updated t_d_jo_inspection_activity ${rawAct}");

      TDJoInspectionActivityVessel dVesel = TDJoInspectionActivityVessel(
        tHJoId: item.tHJoId,
        tDJoInspectionActivityStagesId: updated,
        vessel: item.vessel,
        code: "JOIAV-${item.mStatusinspectionstagesId}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}",
        isUpload: 0,
        isActive: 1,
        createdBy: createdBy,
        createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
      );

      int rawVesel =
          await db.update("t_d_jo_inspection_activity_vessel", dVesel.toEdit(), where: 't_h_jo_id = ? and t_d_jo_inspection_activity_stages_id = ?', whereArgs: [detail.tHJoId, idJoActStage]);

      await db.update("t_d_jo_inspection_activity_barge", {"is_active": 0, "is_upload": 0}, where: "t_h_jo_id = ?", whereArgs: [item.tHJoId]);
      for (var barge in item!.barge!) {
        TDJoInspectionActivityBarge dBarge = TDJoInspectionActivityBarge(
          tHJoId: item.tHJoId,
          tDJoInspectionActivityStagesId: idJoActStage,
          barge: barge.barge,
          code: "JOIAB-${item.mStatusinspectionstagesId}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}",
          isUpload: 0,
          isActive: 1,
          createdBy: createdBy,
          updatedBy: createdBy.toString(),
          createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
          updatedAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
        );
        int rawBarge = await db.insert("t_d_jo_inspection_activity_barge", dBarge.toInsert());
      }
      await db.update("t_d_jo_inspection_activity_stages_transhipment", {"is_active": 0, "is_upload": 0}, where: "t_d_inspection_stages_id = ?", whereArgs: [idJoActStage]);
      var transhipmentCount = 0;
      for (var transhipment in item!.transhipment!) {
        debugPrint('print data transhipment ${transhipment.toJson()}');
        if (transhipment.deliveryQty != null && transhipment.deliveryQty != "") {
          transhipmentCount++;
          TDJoInspectionActivityStagesTranshipment dTranshipment = TDJoInspectionActivityStagesTranshipment(
            tDInspectionStagesId: idJoActStage,
            tDJoInspectionActivityId: idJoAct,
            initialDate: transhipment.initialDate,
            finalDate: transhipment.finalDate,
            jetty: transhipment.jetty,
            deliveryQty: double.parse(transhipment!.deliveryQty!.toString()),
            code: "JOIAT-5-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}-${transhipmentCount}",
            isUpload: 0,
            isActive: 1,
            createdBy: createdBy,
            uomId: item.uomId,
            createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
            updatedBy: createdBy.toString(),
            updatedAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
          );
          if (dTranshipment.id == null) {
            await db.insert("t_d_jo_inspection_activity_stages_transhipment", dTranshipment.toInsert());
          } else {
            await db.update("t_d_jo_inspection_activity_stages_transhipment", dTranshipment.toEdit());
          }
        }
      }
    }
    return 'success';
    // }catch (e) {
    //   debugPrint("print error updated Stage 5 inpesction ${jsonEncode(e)}");
    //   return 'failed';
    // }
  }

  Future editActivity5V2() async {
    activity5Barges.value = barges.value;
    var barge = barges.value.map((barge) {
      return Barge(barge: barge);
    }).toList();
    activity5List.value = [
      FormDataArray(
          tHJoId: id,
          mStatusinspectionstagesId: 5,
          uomId: dataJoDetail.value.detail?.uomId ?? 0,
          transDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          actualQty: qtyController.text,
          createdBy: userData.value!.id,
          vessel: vesselController.text,
          barge: barge,
          transhipment: activity5TranshipmentList.value)
    ];
    debugPrint('activity 5 yang di edit : ${jsonEncode(activity5List.value.first)}');
  }

  void drawerDailyActivity6V2() {
    Get.bottomSheet(
        GetBuilder(
          init: JoDetailController(),
          builder: (controller) => Container(
              margin: const EdgeInsets.only(top: 48),
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))),
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
                              const Text(
                                'Add Stage Inspection',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: primaryColor),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                'Stage 6: Report to Client',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                showCursor: true,
                                readOnly: true,
                                controller: activityDate,
                                enabled: enabledDate.value,
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
                                        icon: const Icon(Icons.calendar_today_rounded)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: onFocusColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Date*',
                                    floatingLabelStyle: const TextStyle(color: onFocusColor),
                                    fillColor: onFocusColor),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text('Detail Activities'),
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
                                        pickedTime = activityStartTime.text;
                                        update();
                                        activityStartTime.text = await selectTime6(Get.context!);
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
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: onFocusColor),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          labelText: 'Start Time*',
                                          floatingLabelStyle: const TextStyle(color: onFocusColor),
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
                                        pickedTime = activityEndTime.text;
                                        update();
                                        activityEndTime.text = await selectTime6(Get.context!);
                                      },
                                      style: const TextStyle(color: onFocusColor),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: onFocusColor),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          labelText: 'End Time',
                                          floatingLabelStyle: const TextStyle(color: onFocusColor),
                                          fillColor: onFocusColor),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextFormField(
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
                                      borderSide: const BorderSide(color: onFocusColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Activity*',
                                    floatingLabelStyle: const TextStyle(color: onFocusColor),
                                    fillColor: onFocusColor),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              InkWell(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (editActivityMode.value == false) {
                                      addActivityV2();
                                    } else {
                                      updateActivityDetailV2();
                                    }
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  height: 42,
                                  width: 42,
                                  decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: Icon(
                                      editActivityMode.value == false ? Icons.add : Icons.check,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              stageListModal.value.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: stageListModal.value.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        TDJoInspectionActivityStages stage = stageListModal.value[index];
                                        return Column(
                                          children: [
                                            Card(
                                                color: Colors.white,
                                                child: Padding(
                                                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                flex: 2,
                                                                child: Text(
                                                                  'Date',
                                                                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                )),
                                                            const VerticalDivider(width: 1),
                                                            const SizedBox(width: 16),
                                                            Expanded(
                                                                flex: 2,
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      stage.transDate ?? '-',
                                                                      style: TextStyle(fontSize: 12.sp),
                                                                    ),
                                                                    const SizedBox(width: 6),
                                                                    InkWell(
                                                                      onTap: () {
                                                                        debugPrint('Delete header');
                                                                        removeActivityByDateConfirm(stage!.transDate!, index, stage.mStatusinspectionstagesId!.toInt());
                                                                      },
                                                                      child: const ImageIcon(AssetImage("assets/icons/deleteStage.png"), color: Colors.red, size: 16),
                                                                    )
                                                                  ],
                                                                )),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            const Expanded(
                                                                flex: 1,
                                                                child: Text(
                                                                  'Activities',
                                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                                                )),
                                                            const VerticalDivider(
                                                              width: 1,
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            Expanded(
                                                                flex: 3,
                                                                child: Column(
                                                                  children: [
                                                                    ListView.builder(
                                                                        shrinkWrap: true,
                                                                        physics: const NeverScrollableScrollPhysics(),
                                                                        itemCount: stage.listActivity!.length ?? 0,
                                                                        itemBuilder: (context, indexDetail) {
                                                                          TDJoInspectionActivity activity = stage.listActivity![indexDetail];
                                                                          return Padding(
                                                                            padding: const EdgeInsets.only(bottom: 8.0),
                                                                            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                              Expanded(
                                                                                  flex: 1,
                                                                                  child: Text('${activity.startActivityTime} - ${activity.endActivityTime}',
                                                                                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700))),
                                                                              const VerticalDivider(
                                                                                width: 1,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 8,
                                                                              ),
                                                                              Expanded(
                                                                                  flex: 2,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Text(
                                                                                          activity.activity ?? '-',
                                                                                          style: TextStyle(fontSize: 12.sp),
                                                                                        ),
                                                                                      ),
                                                                                      InkWell(
                                                                                        onTap: () {
                                                                                          debugPrint('Edit activity 6 ');
                                                                                          editActivity6DetailV2(stage!.transDate!, activity!.activity!);
                                                                                        },
                                                                                        child: const ImageIcon(AssetImage("assets/icons/editActivity.png"), color: primaryColor, size: 16),
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        width: 6,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 18,
                                                                                        width: 18,
                                                                                        child: Ink(
                                                                                          decoration: ShapeDecoration(color: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                                                                                          child: InkWell(
                                                                                            onTap: () {
                                                                                              debugPrint('Hapus detail');
                                                                                              removeActivityConfirm(stage!.transDate!, indexDetail, index, stage!.mStatusinspectionstagesId!.toInt(),
                                                                                                  activity.activity ?? '', activity.startActivityTime!, activity.endActivityTime ?? '');
                                                                                            },
                                                                                            child: const Icon(Icons.remove, color: Colors.white, size: 12),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ))
                                                                            ]),
                                                                          );
                                                                        }),
                                                                  ],
                                                                )
                                                            )
                                                          ],
                                                        ),
                                                        TextFormField(
                                                          inputFormatters: [
                                                            LengthLimitingTextInputFormatter(250),
                                                          ],
                                                          controller: activityListTextController[index],
                                                          onChanged: (value) {},
                                                          cursorColor: onFocusColor,
                                                          style: const TextStyle(color: onFocusColor),
                                                          decoration: InputDecoration(
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderSide: const BorderSide(color: onFocusColor),
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              labelText: 'Remarks',
                                                              floatingLabelStyle: const TextStyle(color: onFocusColor),
                                                              fillColor: onFocusColor),
                                                        )
                                                      ],
                                                    )))
                                          ],
                                        );
                                      },
                                    )
                                  : const SizedBox(),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                'Attachment',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text('File lampiran maksimal 5 file dengan ukuran total file maksimal 10 MB. Jenis file yang diperbolehkan hanya PDF/JPG/PNG/JPEG.'),
                              const SizedBox(
                                height: 16,
                              ),
                              activity6Attachments.value.isNotEmpty
                                  ? GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                      ),
                                      itemCount: activity6Attachments.value.length,
                                      itemBuilder: (content, index) {
                                        final TDJoInspectionAttachment photo = activity6Attachments.value[index];
                                        final String fileType = checkFileType(photo.pathName!);
                                        var filename = photo.fileName!;
                                        return fileType == 'image'
                                            ? SizedBox(
                                                width: 68,
                                                height: 68,
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets.only(top: 5),
                                                      width: 63,
                                                      height: 63,
                                                      child: InkWell(
                                                        onTap: () {
                                                          // controller
                                                          //     .previewImageAct6(
                                                          //         index,
                                                          //         photo.pathName!);
                                                          mediaPickerEditConfirm(index);
                                                        },
                                                        child: Image.file(
                                                          File(photo.pathName!),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 68,
                                                      height: 68,
                                                      child: Align(
                                                        alignment: Alignment.topRight,
                                                        child: InkWell(
                                                            onTap: () {
                                                              controller.removeActivity6Files(index);
                                                            },
                                                            child: Image.asset('assets/icons/close.png', width: 24)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : fileType == 'doc'
                                                ? SizedBox(
                                                    width: 68,
                                                    height: 68,
                                                    child: Stack(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            // OpenFilex.open(
                                                            //     photo.pathName!);
                                                            mediaPickerEditConfirm(index);
                                                          },
                                                          child: Container(
                                                            margin: const EdgeInsets.only(top: 5),
                                                            width: 63,
                                                            height: 63,
                                                            child: Center(
                                                                child: Column(
                                                              children: [
                                                                Image.asset(
                                                                  'assets/icons/pdfIcon.png',
                                                                  height: 42,
                                                                ),
                                                                Text(filename, style: const TextStyle(fontSize: 8), overflow: TextOverflow.ellipsis)
                                                              ],
                                                            )),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 68,
                                                          height: 68,
                                                          child: Align(
                                                            alignment: Alignment.topRight,
                                                            child: InkWell(
                                                                onTap: () {
                                                                  controller.removeActivity6Files(index);
                                                                },
                                                                child: Image.asset('assets/icons/close.png', width: 24)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : const SizedBox();
                                      })
                                  : const SizedBox(),
                              const SizedBox(
                                height: 16,
                              ),
                              activity6Attachments.value.length < 5
                                  ? SizedBox(
                                      width: 68,
                                      height: 68,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            mediaPickerConfirm();
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                                          child: const Center(
                                              child: Icon(
                                            Icons.folder_rounded,
                                            color: primaryColor,
                                          ))),
                                    )
                                  : const SizedBox(),
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
                                onPressed: () async {
                                  checkActivity6List();
                                  Get.back();
                                  await getJoDailyActivityLocalV2();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                                child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    width: double.infinity,
                                    child: const Center(
                                        child: Text(
                                      'Cancel',
                                      style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
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
                                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    width: double.infinity,
                                    child: const Center(
                                        child: Text(
                                      'Submit',
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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

  void addActivity6V2() {
    TDJoInspectionActivity activity = new TDJoInspectionActivity(
      id: DateTime.now().millisecondsSinceEpoch, //Date now to int
      activity: activity6Text.text,
      endActivityTime: activity6EndTime.text,
      startActivityTime: activity6StartTime.text,
    );

    List<TDJoInspectionActivity> listActivity = [];
    listActivity.add(activity);

    List<TDJoInspectionActivityStages> oldTdJoInspections = stageListModal.value;

    TDJoInspectionActivityStages? matchingStage = oldTdJoInspections.firstWhere(
      (stage) => stage.transDate == activity6Date.text,
      orElse: () => TDJoInspectionActivityStages(),
    );

    debugPrint('Matching old Stage ${jsonEncode(matchingStage.toJson())}');
    //jika transdate tidak null dan transdate tidak sama "" maka update old data
    if (matchingStage.transDate != null && matchingStage.transDate.toString() != "") {
      matchingStage.listActivity?.add(activity);
      //sudah otomatis ke update karena update secara langsung
    } else {
      TDJoInspectionActivityStages stages = new TDJoInspectionActivityStages(transDate: activity6Date.text, mStatusinspectionstagesId: activityStage, listActivity: listActivity);
      stageListModal.add(stages);
      activity6ListTextController.value.add(TextEditingController());
    }

    activity6Date.text = '';
    activity6StartTime.text = '';
    activity6EndTime.text = '';
    activity6Text.text = '';
    debugPrint("print stage list modal report client ${jsonEncode(stageListModal)}");
    update();
  }

  void editActivity6DetailV2(String transDate, String actEdit) {
    TDJoInspectionActivityStages? matchingStage = stageListModal.value.firstWhere(
      (stage) => stage.transDate == transDate,
      orElse: () => TDJoInspectionActivityStages(),
    );

    debugPrint('activity 6 yang mau diedit:${jsonEncode(stageListModal.value)}');

    if (matchingStage.transDate != null && matchingStage.transDate.toString() != "") {
      //matchingStage.listActivity?.removeWhere((activity) => activity.activity == actEdit);
      TDJoInspectionActivity? matchinAtivity = matchingStage.listActivity?.firstWhere((act) => act.activity == actEdit, orElse: TDJoInspectionActivity.new);

      if (matchinAtivity != null && matchinAtivity.activity.toString() != "") {
        activityDate.text = matchingStage!.transDate!;
        activityStartTime.text = matchinAtivity.startActivityTime!;
        activityEndTime.text = matchinAtivity.endActivityTime!;
        activityText.text = matchinAtivity.activity!;
        editActivityMode.value = true;
        enabledDate.value = false;
        editActivityIndex.value = matchinAtivity!.id!.toInt();
        update();
      }
    }
  }

  void updateActivity6DetailV2() {
    // edit Rx
    TDJoInspectionActivityStages? matchingStage = stageListModal.value.firstWhere(
      (stage) => stage.transDate == activity6Date.text,
      orElse: () => TDJoInspectionActivityStages(),
    );

    debugPrint("print data update inspection ${jsonEncode(matchingStage)}");
    if (matchingStage.transDate != null && matchingStage.transDate.toString() != "") {
      TDJoInspectionActivity? matchinAtivity = matchingStage.listActivity?.firstWhere((act) => act.id == editActivityIndex.value, orElse: TDJoInspectionActivity.new);

      if (matchinAtivity != null && (matchinAtivity.id ?? 0) > 0) {
        matchinAtivity.startActivityTime = activity6StartTime.text;
        matchinAtivity.endActivityTime = activity6EndTime.text;
        matchinAtivity.activity = activity6Text.text;

        //update ke activity
        int? indexDetail = matchingStage.listActivity?.indexWhere((act) => act!.id! == matchinAtivity!.id!);

        if (indexDetail != null && indexDetail != -1) {
          matchingStage.listActivity![indexDetail] = matchinAtivity;
        }

        int index = stageListModal.indexWhere((stage) => stage.transDate == matchingStage.transDate);

        if (index != -1) {
          stageListModal[index] = matchingStage;
        }

        // Reset the edit mode and index
        cleanActivity();
        // activity6Date.text = '';
        // activity6StartTime.text = '';
        // activity6EndTime.text = '';
        // activity6Text.text = '';
        update(); // Notify observers
      }
    }
  }

  Future<bool> saveActivity6Stages() async {
    try {
      final db = await SqlHelper.db();
      List<TDJoInspectionActivityStages> stages = stageListModal.value;
      final createdBy = userData.value!.id;

      stages.asMap().forEach((index, stage) async {
        debugPrint("data input ${jsonEncode(stage.toJson())}");
        TDJoInspectionActivityStages data = TDJoInspectionActivityStages(
          tHJoId: id,
          mStatusinspectionstagesId: stage.mStatusinspectionstagesId,
          transDate: stage.transDate,
          code: "JOIAST-${stage.mStatusinspectionstagesId}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}",
          isUpload: "0",
          isActive: "1",
          createdBy: userData.value!.id,
          createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
          remarks: activityListTextController.value[index].text,
        );
        int result = await db.insert("t_d_jo_inspection_activity_stages", data.toInsert());
        //dapatkan id yang baru insert
        List<TDJoInspectionActivity> details = stage.listActivity ?? [];
        details.forEach((activity) async {
          TDJoInspectionActivity detail = TDJoInspectionActivity(
              tHJoId: id,
              tDJoInspectionActivityStagesId: result,
              startActivityTime: activity.startActivityTime,
              endActivityTime: activity.endActivityTime,
              activity: activity.activity,
              code: 'JOIAS-${stage.mStatusinspectionstagesId}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}',
              isActive: 1,
              isUpload: 0,
              createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
              createdBy: createdBy);
          await db.insert("t_d_jo_inspection_activity", detail.toInsert());
        });
      });

      //save file attachment
      //List<TDJoInspectionAttachment> listFile = activity6Attachments.value ?? [];
      debugPrint("print list file attachment ${activity6Attachments.value}");
      var attachmentCount = 0;
      for (var file in activity6Attachments.value) {
        debugPrint('nyang mau di input attachnya: ${jsonEncode(file)}');
        attachmentCount++;
        var filename = file.fileName!;
        TDJoInspectionAttachment attach = TDJoInspectionAttachment(
            tHJoId: id,
            tDJoInspectionActivityStagesId: stages.first.id,
            fileName: filename,
            pathName: file.pathName,
            code: 'JOIAF-${activityStage}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}-${attachmentCount}',
            isActive: 1,
            isUpload: 0,
            createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
            createdBy: createdBy);
        await db.insert('t_d_jo_inspection_attachment', attach.toJson());
      }

      // stageListModal.value.asMap().forEach((index, stage) async {
      //   stageCount++;
      //   debugPrint("data input ${jsonEncode(stage.toJson())}");
      //   TDJoInspectionActivityStages data = TDJoInspectionActivityStages(
      //     tHJoId: id,
      //     mStatusinspectionstagesId: stage.mStatusinspectionstagesId,
      //     transDate: stage.transDate,
      //     code:
      //         "JOIAST-${stage.mStatusinspectionstagesId}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}-${stageCount}",
      //     isUpload: "0",
      //     isActive: "1",
      //     createdBy: userData.value!.id,
      //     createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
      //     remarks: activityListTextController.value[index].text,
      //   );
      //
      //   int result = await db.insert(
      //       "t_d_jo_inspection_activity_stages", data.toInsert());
      //
      //   //dapatkan id yang baru insert
      //   List<TDJoInspectionActivity> details = stage.listActivity ?? [];
      //   var activityCount = 0;
      //   details.forEach((activity) async {
      //     activityCount++;
      //     TDJoInspectionActivity detail = TDJoInspectionActivity(
      //         tHJoId: id,
      //         tDJoInspectionActivityStagesId: result,
      //         startActivityTime: activity.startActivityTime,
      //         endActivityTime: activity.endActivityTime,
      //         activity: activity.activity,
      //         code:
      //             'JOIAS-${stage.mStatusinspectionstagesId}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}-${activityCount}',
      //         isActive: 1,
      //         isUpload: 0,
      //         createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
      //         createdBy: createdBy);
      //     await db.insert("t_d_jo_inspection_activity", detail.toInsert());
      //   });
      //
      //   //save file attachment
      //   //List<TDJoInspectionAttachment> listFile = activity6Attachments.value ?? [];
      //   debugPrint("print list file attachment ${activity6Attachments.value}");
      //   var attachmentCount = 0;
      //   for (var file in activity6Attachments.value) {
      //     debugPrint('nyang mau di input attachnya: ${jsonEncode(file)}');
      //     attachmentCount++;
      //     var filename = file.fileName!;
      //     TDJoInspectionAttachment attach = TDJoInspectionAttachment(
      //         tHJoId: id,
      //         tDJoInspectionActivityStagesId: result,
      //         fileName: filename,
      //         pathName: file.pathName,
      //         code:
      //             'JOIAF-${stage.mStatusinspectionstagesId}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}-${attachmentCount}',
      //         isActive: 1,
      //         isUpload: 0,
      //         createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
      //         createdBy: createdBy);
      //     await db.insert('t_d_jo_inspection_attachment', attach.toJson());
      //   }
      // });
      stageListModal.value = [];
      activityListTextController.value = [];
      activitySubmitted.value = true;
      cleanActivity();
      return true;
    } catch (e) {
      debugPrint("print error save activity 6 ${e}");
      return false;
    }
    // if (activity6List.value
    //     .where((data) => data.mStatusinspectionstagesId == activityStage)
    //     .toList()
    //     .isNotEmpty) {
    //   //activityStage++;
    //   var post = activity6List.value
    //       .map((value) => Activity(
    //     tHJoId: value.tHJoId,
    //     mStatusinspectionstagesId: value.mStatusinspectionstagesId,
    //     transDate: value.transDate,
    //     startActivityTime: value.startActivityTime,
    //     endActivityTime: value.endActivityTime,
    //     activity: value.activity,
    //     createdBy: value.createdBy,
    //     remarks: value.remarks,
    //   ).toJson())
    //       .toList();
    //   //postInsertActivity(post);
    //   for (var item in activity6List.value) {
    //     activity6ListStages.value.add(item);
    //   }
    //   activity6AttachmentsStage.value = activity6AttachmentsStage.value;
    //   activity6AttachmentsStage.value = [];
    //   activityList.value = [];
    //   activityListTextController.value = [];
    //   editActivityMode.value = false;
    //   activityDate.text = '';
    //   activityStartTime.text = '';
    //   activityEndTime.text = '';
    //   activityText.text = '';
    //
    //   activitySubmitted.value = true;
    //
    //   // await getJoDailyActivity6();
    //   // activityStage--;
    //   update();
    //   return 'success';
    // } else if (activity6List.value
    //     .where((data) => data.mStatusinspectionstagesId == activityStage)
    //     .toList()
    //     .isEmpty) {
    //   return 'failed';
    // }
  }

  void drawerDailyActivityContek() {
    Get.bottomSheet(
        GetBuilder(
          init: JoDetailController(),
          builder: (controller) => Container(
              margin: const EdgeInsets.only(top: 48),
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              height: 800,
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Add Stage Inspection',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: primaryColor),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Stage ${activityStage}: ${activityStages[activityStage - 1]}',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                TextFormField(
                                  showCursor: true,
                                  readOnly: true,
                                  controller: activityDate,
                                  enabled: enabledDate.value,
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
                                          icon: const Icon(Icons.calendar_today_rounded)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: activityDateValidate == true ? onFocusColor : Colors.red),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Date*',
                                      floatingLabelStyle: const TextStyle(color: onFocusColor),
                                      fillColor: onFocusColor),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const Text('Detail Activities'),
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
                                          activityStartTime.text = await selectTime(Get.context!);
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
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(color: onFocusColor),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            labelText: 'Start Time*',
                                            floatingLabelStyle: const TextStyle(color: onFocusColor),
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
                                        readOnly: true,
                                        onTap: () async {
                                          activityEndTime.text = await selectTime(Get.context!);
                                        },
                                        style: const TextStyle(color: onFocusColor),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(color: onFocusColor),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            labelText: 'End Time',
                                            floatingLabelStyle: const TextStyle(color: onFocusColor),
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
                                        borderSide: const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Activity*',
                                      floatingLabelStyle: const TextStyle(color: onFocusColor),
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
                                    addActivity6V2();
                                  } else {
                                    updateActivityDetailV2();
                                  }
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Icon(
                                    editActivityMode.value == false ? Icons.add : Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            stageListModal.value.isNotEmpty
                                ? ListView.builder(
                                    itemCount: stageListModal.value.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      TDJoInspectionActivityStages stage = stageListModal.value[index];
                                      return Column(
                                        children: [
                                          Card(
                                              color: Colors.white,
                                              child: Padding(
                                                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Expanded(
                                                              flex: 2,
                                                              child: Text(
                                                                'Date',
                                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                                              )),
                                                          const VerticalDivider(width: 1),
                                                          const SizedBox(width: 16),
                                                          Expanded(
                                                              flex: 2,
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child: Text(
                                                                      stage.transDate ?? '-',
                                                                      style: const TextStyle(fontSize: 14),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      debugPrint('Delete header');
                                                                      deleteActivityHeaderV2(stage!.transDate!);
                                                                    },
                                                                    child: const Icon(Icons.delete_forever, color: Colors.red),
                                                                  )
                                                                ],
                                                              )),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      ListView.builder(
                                                          shrinkWrap: true,
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          itemCount: stage.listActivity!.length ?? 0,
                                                          itemBuilder: (context, indexDetail) {
                                                            TDJoInspectionActivity activity = stage.listActivity![indexDetail];
                                                            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                              const Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    'Activities',
                                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                                                  )),
                                                              const VerticalDivider(
                                                                width: 1,
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text('${activity.startActivityTime} - ${activity.endActivityTime}',
                                                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700))),
                                                              const VerticalDivider(
                                                                width: 1,
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Expanded(
                                                                  flex: 2,
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Text(
                                                                          activity.activity ?? '-',
                                                                          style: const TextStyle(fontSize: 14),
                                                                        ),
                                                                      ),
                                                                      InkWell(
                                                                        onTap: () {
                                                                          debugPrint('Edit ');
                                                                          editActivity6DetailV2(stage!.transDate!, activity!.activity!);
                                                                        },
                                                                        child: const Icon(
                                                                          Icons.mode_edit_outlined,
                                                                          color: primaryColor,
                                                                        ),
                                                                      ),
                                                                      InkWell(
                                                                        onTap: () {
                                                                          debugPrint('Hapus detail');
                                                                          deleteActivityDetailV2(stage!.transDate!, activity!.activity!);
                                                                        },
                                                                        child: const Icon(
                                                                          Icons.delete_forever,
                                                                          color: Colors.red,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ))
                                                            ]);
                                                          }),
                                                      TextFormField(
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(250),
                                                        ],
                                                        controller: activityListTextController[index],
                                                        onChanged: (value) {},
                                                        cursorColor: onFocusColor,
                                                        style: const TextStyle(color: onFocusColor),
                                                        decoration: InputDecoration(
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderSide: const BorderSide(color: onFocusColor),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            labelText: 'Remarks',
                                                            floatingLabelStyle: const TextStyle(color: onFocusColor),
                                                            fillColor: onFocusColor),
                                                      )
                                                    ],
                                                  )))
                                        ],
                                      );
                                    },
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                //checkActivityList();
                                cleanActivity();
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  width: double.infinity,
                                  child: const Center(
                                      child: Text(
                                    'Cancel',
                                    style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
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
                              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  width: double.infinity,
                                  child: const Center(
                                      child: Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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

  // END V2

  void checkActivityList() {
    debugPrint('activities now: ${jsonEncode(activityList)}');
  }

  Future<void> removeActivity(int indexitem, int index, int stage) async {
    var dateLength = activityList.value.where((item) => item.transDate == activityList.value[indexitem].transDate && item.mStatusinspectionstagesId == stage).length;
    if (dateLength == 1) {
      activityListTextController.value.removeAt(index);
    }
    activityList.value.removeAt(indexitem);
    update();
  }

  Future<void> removeActivityByDate(String date, int indexDate, int stage) async {
    activityList.value.removeWhere((item) => item.transDate == date && item.mStatusinspectionstagesId == stage);
    activityListTextController.value.removeAt(indexDate);
    update();
  }

  Future<void> removeActivityLocal(int indexitem, int index, int stage, int id, String code, int stageId) async {
    debugPrint('id: $id, code: $code');
    if (id != 0 || code != '') {
      try {
        await SqlHelper.deleteActivity(id, code);
        var dateLength = activityList.value.where((item) => item.transDate == activityList.value[indexitem].transDate && item.mStatusinspectionstagesId == stage).length;
        if (dateLength == 1) {
          activityListTextController.value.removeAt(index);
          update();
        }
        activityList.value.removeAt(indexitem);
        update();
      } catch (e) {
        debugPrint('error delete activity: ${e.toString()}');
      }
    } else {
      var dateLength = activityList.value.where((item) => item.transDate == activityList.value[indexitem].transDate && item.mStatusinspectionstagesId == stage).length;
      if (dateLength == 1) {
        activityListTextController.value.removeAt(index);
        update();
      }
      activityList.value.removeAt(indexitem);
      update();
    }
    var checkStage = await SqlHelper.getActivityListStage(stageId);
    if (checkStage.length == 0) {
      try {
        await SqlHelper.deleteActivityStage(id, code);
      } catch (e) {
        debugPrint('error delete activity stage: ${e.toString()}');
      }
    }
    update();
  }

  Future<void> removeActivityByDateLocal(String date, int indexDate, int stage, int id, String code) async {
    debugPrint('id: $id, code: $code');
    if (id != 0 && code != '') {
      try {
        await SqlHelper.deleteActivityStage(id, code);
        activityList.value.removeWhere((item) => item.transDate == date && item.mStatusinspectionstagesId == stage);
        activityListTextController.value.removeAt(indexDate);
        update();
      } catch (e) {
        debugPrint('error delete activity stage: ${e.toString()}');
      }
    } else {
      activityList.value.removeWhere((item) => item.transDate == date && item.mStatusinspectionstagesId == stage);
      activityListTextController.value.removeAt(indexDate);
      update();
    }
    update();
  }

  void drawerDailyActivity() {
    Get.bottomSheet(
        GetBuilder(
          init: JoDetailController(),
          builder: (controller) => Container(
              margin: const EdgeInsets.only(top: 48),
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              height: 800,
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Add Stage Inspection',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: primaryColor),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Stage ${activityStage}: ${activityStages[activityStage - 1]}',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                TextFormField(
                                  showCursor: true,
                                  readOnly: true,
                                  controller: activityDate,
                                  enabled: enabledDate.value,
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
                                          icon: const Icon(Icons.calendar_today_rounded)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: activityDateValidate == true ? onFocusColor : Colors.red),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Date*',
                                      floatingLabelStyle: const TextStyle(color: onFocusColor),
                                      fillColor: onFocusColor),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const Text('Detail Activities'),
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
                                          activityStartTime.text = await selectTime(Get.context!);
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
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(color: onFocusColor),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            labelText: 'Start Time*',
                                            floatingLabelStyle: const TextStyle(color: onFocusColor),
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
                                        readOnly: true,
                                        onTap: () async {
                                          activityEndTime.text = await selectTime(Get.context!);
                                        },
                                        style: const TextStyle(color: onFocusColor),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(color: onFocusColor),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            labelText: 'End Time',
                                            floatingLabelStyle: const TextStyle(color: onFocusColor),
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
                                        borderSide: const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Activity*',
                                      floatingLabelStyle: const TextStyle(color: onFocusColor),
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
                                    addActivityV2();
                                  } else {
                                    updateActivityDetailV2();
                                  }
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Icon(
                                    editActivityMode.value == false ? Icons.add : Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            stageListModal.value.isNotEmpty
                                ? ListView.builder(
                                    itemCount: stageListModal.value.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      TDJoInspectionActivityStages stage = stageListModal.value[index];
                                      return Column(
                                        children: [
                                          Card(
                                              color: Colors.white,
                                              child: Padding(
                                                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              flex: 2,
                                                              child: Text(
                                                                'Date',
                                                                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700),
                                                              )),
                                                          const VerticalDivider(width: 1),
                                                          const SizedBox(width: 16),
                                                          Expanded(
                                                              flex: 2,
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    stage.transDate ?? '-',
                                                                    style: TextStyle(fontSize: 11.sp),
                                                                  ),
                                                                  const SizedBox(width: 6),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      debugPrint('Delete header');
                                                                      removeActivityByDateConfirm(stage!.transDate!, index, stage.mStatusinspectionstagesId!.toInt());
                                                                    },
                                                                    child: const ImageIcon(AssetImage("assets/icons/deleteStage.png"), color: Colors.red, size: 16),
                                                                  )
                                                                ],
                                                              )),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                              flex: 1,
                                                              child: Text(
                                                                'Activities',
                                                                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700),
                                                              )),
                                                          const VerticalDivider(
                                                            width: 1,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Expanded(
                                                            flex: 3,
                                                              child: Column(
                                                              children: [
                                                                ListView.builder(
                                                                    shrinkWrap: true,
                                                                    physics: const NeverScrollableScrollPhysics(),
                                                                    itemCount: stage.listActivity!.length ?? 0,
                                                                    itemBuilder: (context, indexDetail) {
                                                                      TDJoInspectionActivity activity = stage.listActivity![indexDetail];
                                                                      return Padding(
                                                                        padding: const EdgeInsets.only(bottom: 8.0),
                                                                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                          Expanded(
                                                                              flex: 1,
                                                                              child: Text('${activity.startActivityTime} - ${activity.endActivityTime}',
                                                                                  style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700))),
                                                                          const VerticalDivider(
                                                                            width: 1,
                                                                          ),
                                                                          const SizedBox(
                                                                            width: 8,
                                                                          ),
                                                                          Expanded(
                                                                              flex: 2,
                                                                              child: Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      activity.activity ?? '-',
                                                                                      style: TextStyle(fontSize: 11.sp),
                                                                                    ),
                                                                                  ),
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      debugPrint('Edit');
                                                                                      editActivityDetailV2(stage!.transDate!, activity!.activity!);
                                                                                    },
                                                                                    child: const ImageIcon(AssetImage("assets/icons/editActivity.png"), color: primaryColor, size: 16),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 6,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 18,
                                                                                    width: 18,
                                                                                    child: Ink(
                                                                                      decoration: ShapeDecoration(color: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                                                                                      child: InkWell(
                                                                                        onTap: () {
                                                                                          debugPrint('Hapus detail');
                                                                                          removeActivityConfirm(stage!.transDate!, indexDetail, index, stage!.mStatusinspectionstagesId!.toInt(),
                                                                                              activity.activity ?? '', activity.startActivityTime!, activity.endActivityTime ?? '');
                                                                                        },
                                                                                        child: const Icon(Icons.remove, color: Colors.white, size: 12),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ))
                                                                        ]),
                                                                      );
                                                                    }),
                                                              ],
                                                            )
                                                          )
                                                        ],
                                                      ),
                                                      const Divider(),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      TextFormField(
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(250),
                                                        ],
                                                        controller: activityListTextController[index],
                                                        onChanged: (value) {},
                                                        cursorColor: onFocusColor,
                                                        style: const TextStyle(color: onFocusColor),
                                                        decoration: InputDecoration(
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderSide: const BorderSide(color: onFocusColor),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            labelText: 'Remarks',
                                                            floatingLabelStyle: const TextStyle(color: onFocusColor),
                                                            fillColor: onFocusColor),
                                                      )
                                                    ],
                                                  )))
                                        ],
                                      );
                                    },
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                //checkActivityList();
                                cleanActivity();
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  width: double.infinity,
                                  child: const Center(
                                      child: Text(
                                    'Cancel',
                                    style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                                  )))),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                addActivityStageConfirm();
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  width: double.infinity,
                                  child: const Center(
                                      child: Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
        title: const Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah benar anda akan submit stage ${activityStages[activityStage - 1]} ini? pastikan data yg anda input benar.'),
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
              bool result = await saveActivityStageV2();
              if (result) {
                Get.back();
                Get.back();
                await getJoDailyActivityLocalV2();
                if (activityStage == 1) {
                  await changeStatusJoLocal();
                }
              } else {
                Get.back();
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
        title: const Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: const Text('Apakah anda ingin melanjutkan ke stage berikutnya? jika Ya, anda tidak bisa mengubah stage sebelumnya. Pastikan data yang anda input benar.'),
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

  void drawerDailyActivityEdit(int stage) {
    List<TDJoInspectionActivityStages> filteredStages = stageList.value.where((itemStage) => itemStage.mStatusinspectionstagesId == stage).toList();
    activityListTextController.value = [];
    filteredStages.forEach((item) {
      activityListTextController.value.add(TextEditingController(text: item.remarks));
    });
    stageListModal.value = filteredStages;

    update();
    debugPrint('data yang mau di edit: ${filteredStages}');
    debugPrint('data yang mau di edit: ${jsonEncode(stageListModal.value)}');
    Get.bottomSheet(
        GetBuilder(
          init: JoDetailController(),
          builder: (controller) => Container(
              margin: const EdgeInsets.only(top: 48),
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              height: 800,
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Edit Stage Inspection',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: primaryColor),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Stage ${activityStage}: ${activityStages[activityStage - 1]}',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                TextFormField(
                                  showCursor: true,
                                  readOnly: true,
                                  controller: activityDate,
                                  enabled: enabledDate.value,
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
                                          icon: const Icon(Icons.calendar_today_rounded)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Date*',
                                      floatingLabelStyle: const TextStyle(color: onFocusColor),
                                      fillColor: onFocusColor),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const Text('Detail Activities'),
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
                                          activityStartTime.text = await selectTime(Get.context!);
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
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(color: onFocusColor),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            labelText: 'Start Time*',
                                            floatingLabelStyle: const TextStyle(color: onFocusColor),
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
                                        readOnly: true,
                                        onTap: () async {
                                          activityEndTime.text = await selectTime(Get.context!);
                                        },
                                        style: const TextStyle(color: onFocusColor),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(color: onFocusColor),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            labelText: 'End Time',
                                            floatingLabelStyle: const TextStyle(color: onFocusColor),
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
                                        borderSide: const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Activity*',
                                      floatingLabelStyle: const TextStyle(color: onFocusColor),
                                      fillColor: onFocusColor),
                                ),
                              ]),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  if (editActivityMode.value == false) {
                                    addActivityV2();
                                  } else {
                                    updateActivityDetailV2();
                                  }
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Icon(
                                    editActivityMode.value == false ? Icons.add : Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            stageListModal.value.isNotEmpty
                                ? ListView.builder(
                                    itemCount: stageListModal.value.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      TDJoInspectionActivityStages stage = stageListModal.value[index];
                                      return Column(
                                        children: [
                                          Card(
                                              color: Colors.white,
                                              child: Padding(
                                                  padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              flex: 2,
                                                              child: Text(
                                                                'Date',
                                                                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700),
                                                              )),
                                                          const VerticalDivider(width: 1),
                                                          const SizedBox(width: 16),
                                                          Expanded(
                                                              flex: 2,
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    stage.transDate ?? '-',
                                                                    style: TextStyle(fontSize: 11.sp),
                                                                  ),
                                                                  const SizedBox(width: 6),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      removeActivityByDateConfirm(stage!.transDate!, index, stage.mStatusinspectionstagesId!.toInt());
                                                                    },
                                                                    child: const ImageIcon(AssetImage("assets/icons/deleteStage.png"), color: Colors.red, size: 16),
                                                                  )
                                                                ],
                                                              )),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                              flex: 1,
                                                              child: Text(
                                                                'Activities',
                                                                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700),
                                                              )),
                                                          const VerticalDivider(
                                                            width: 1,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Expanded(
                                                            flex: 3,
                                                              child: Column(
                                                                children: [
                                                                  ListView.builder(
                                                                      shrinkWrap: true,
                                                                      physics: const NeverScrollableScrollPhysics(),
                                                                      itemCount: stage.listActivity!.length ?? 0,
                                                                      itemBuilder: (context, indexDetail) {
                                                                        TDJoInspectionActivity activity = stage.listActivity![indexDetail];
                                                                        return Padding(
                                                                          padding: const EdgeInsets.only(bottom: 8.0),
                                                                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                            Expanded(
                                                                                flex: 1,
                                                                                child: Text('${Helper.formatToHourMinute(activity!.startActivityTime!)} - ${Helper.formatToHourMinute(activity!.endActivityTime!)}',
                                                                                    style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700))),
                                                                            const VerticalDivider(
                                                                              width: 1,
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 8,
                                                                            ),
                                                                            Expanded(
                                                                                flex: 2,
                                                                                child: Row(
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: Text(
                                                                                        activity.activity ?? '-',
                                                                                        style: TextStyle(fontSize: 11.sp),
                                                                                      ),
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        debugPrint('Edit');
                                                                                        editActivityDetailV2(stage!.transDate!, activity!.activity!);
                                                                                      },
                                                                                      child: const ImageIcon(AssetImage("assets/icons/editActivity.png"), color: primaryColor, size: 16),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 6,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 18,
                                                                                      width: 18,
                                                                                      child: Ink(
                                                                                        decoration: ShapeDecoration(color: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                                                                                        child: InkWell(
                                                                                          onTap: () {
                                                                                            debugPrint('Hapus detail');
                                                                                            //deleteActivityDetailV2(stage!.transDate!, activity!.activity!);
                                                                                            removeActivityConfirm(stage!.transDate!, indexDetail, index, stage!.mStatusinspectionstagesId!.toInt(),
                                                                                                activity.activity ?? '', activity.startActivityTime!, activity.endActivityTime ?? '');
                                                                                          },
                                                                                          child: const Icon(Icons.remove, color: Colors.white, size: 12),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ))
                                                                          ]),
                                                                        );
                                                                      }),
                                                                ],
                                                              )
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 16,
                                                      ),
                                                      TextFormField(
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(250),
                                                        ],
                                                        controller: activityListTextController[index],
                                                        onChanged: (value) {},
                                                        cursorColor: onFocusColor,
                                                        style: const TextStyle(color: onFocusColor),
                                                        decoration: InputDecoration(
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderSide: const BorderSide(color: onFocusColor),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            labelText: 'Remarks',
                                                            floatingLabelStyle: const TextStyle(color: onFocusColor),
                                                            fillColor: onFocusColor),
                                                      )
                                                    ],
                                                  )))
                                        ],
                                      );
                                    },
                                  )
                                : const SizedBox()
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
                                  backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  width: double.infinity,
                                  child: const Center(
                                      child: Text(
                                    'Cancel',
                                    style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
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
                              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  width: double.infinity,
                                  child: const Center(
                                      child: Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
        title: const Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah benar anda akan menyimpan perubahan stage ${activityStages[activityStage - 1]} ini? pastikan data yg anda input benar.'),
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
              bool result = await editActivityStagesV2();
              if (result) {
                Get.back();
                await getJoDailyActivityLocalV2();
              } else {
                Get.back();
              }
            },
          ),
        ],
      ),
    );
  }

  void removeActivityConfirm(String date, int indexitem, int index, int stage, String activity, String start, String? end) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah anda ingin menghapus activity time ${start} - ${end} ?'),
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
              deleteActivityDetailV2(date, activity);
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
        title: const Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah anda ingin menghapus activity date $date ?'),
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
            onPressed: () {
              deleteActivityHeaderV2(date);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void cleanActivity() {
    //activityList.value = [];
    //activityListTextController.value = [];
    //stageListModal.value = [];
    editActivityMode.value = false;
    enabledDate.value = true;
    editActivityMode.value = false;
    editActivityIndex.value = 0;
    activityDate.text = '';
    activityStartTime.text = '';
    activityEndTime.text = '';
    activityText.text = '';
  }

  // Activity 5 Inspection Functions

  Future<void> selectInitialDate5(BuildContext context, int index) async {
    final DateTime? picked =
        await showDatePicker(context: context, firstDate: DateTime.now().subtract(const Duration(days: 1)), lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1));
    if (picked != null) {
      initialDateActivity5ListTextController.value[index].text = DateFormat('yyyy-MM-dd').format(picked).toString();
    }
  }

  Future<void> selectFinalDate5(BuildContext context, int index) async {
    final DateTime? picked =
        await showDatePicker(context: context, firstDate: DateTime.now().subtract(const Duration(days: 1)), lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1));
    if (picked != null) {
      finalDateActivity5ListTextController.value[index].text = DateFormat('yyyy-MM-dd').format(picked).toString();
    }
  }

  void addBargeForm() {
    activity5Barges.value = [];
    barges.value = [];
    bargesController.value.add(TextEditingController());
    activity5bargesCount = bargesController.value.length;
    update();
    for (var item in bargesController.value) {
      activity5Barges.value.add(item.text);
      barges.value.add(item.text);
    }
    debugPrint('jumlah barges controller saat ini: controller count ${bargesController.value.length}, barges count ${barges.value.length}, form barges count ${activity5Barges.value.length}');
  }

  void checkActivity5List() {
    debugPrint('activities 5 now: ${jsonEncode(activity5List)}');
  }

  void editBargeForm(int index) {
    barges.value[index] = bargesController.value[index].text;
    update();
    debugPrint("index ${index} value ${barges.value[index]}");
  }

  void removeBargeForm() {
    bargesController.value.removeLast();
    activity5Barges.value.removeLast();
    activity5bargesCount--;
    barges.value.removeLast();
    update();
    debugPrint('jumlah barges controller saat ini: controller count ${bargesController.value.length}, barges count ${barges.value.length}, form barges count ${activity5Barges.value.length}');
  }

  void addActivity5Form() {
    activity5FormCount++;
    jettyListTextController.value.add(TextEditingController());
    initialDateActivity5ListTextController.value.add(TextEditingController());
    finalDateActivity5ListTextController.value.add(TextEditingController());
    deliveryQtyListTextController.value.add(TextEditingController());
    activity5TranshipmentList.value.add(TDJoInspectionActivityStagesTranshipment());
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
    var barge = bargesController.value.map((item) {
      return Barge(barge: item.text);
    }).toList();
    activity5List.value.add(FormDataArray(
        tHJoId: id,
        mStatusinspectionstagesId: activityStage,
        uomId: dataJoDetail.value.detail?.uomId ?? 0,
        transDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        actualQty: qtyController.text,
        createdBy: userData.value!.id,
        vessel: vesselController.text,
        barge: barge,
        transhipment: activity5TranshipmentList.value));
  }

  void editActivity5Transhipment(int index) {
    activity5TranshipmentList.value[index] = activity5TranshipmentList.value[index].copyWith(
      jetty: jettyListTextController.value[index].text,
      initialDate: initialDateActivity5ListTextController.value[index].text,
      finalDate: finalDateActivity5ListTextController.value[index].text,
      deliveryQty: deliveryQtyListTextController.value[index].text == '' ? 0 : double.parse(deliveryQtyListTextController.value[index].text),
    );
    debugPrint('transhipment list : ${jsonEncode(activity5TranshipmentList.value)}');
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
    qtyController.text = dataJoDetail.value.detail?.qty.toString() ?? qtyController.text;
    uomController.text = dataJoDetail.value.detail?.uomName ?? uomController.text;
    vesselController.text = dataJoDetail.value.detail?.vessel ?? vesselController.text;
    activity5FormCount.value = 0;
    activity5TranshipmentList.value = [];
    // if (activity5TranshipmentList.value.isEmpty) {
    //   jettyListTextController.value.add(TextEditingController());
    //   initialDateActivity5ListTextController.value.add(TextEditingController());
    //   finalDateActivity5ListTextController.value.add(TextEditingController());
    //   deliveryQtyListTextController.value.add(TextEditingController());
    //   activity5TranshipmentList.value.add(TDJoInspectionActivityStagesTranshipment());
    // }
  }

  void drawerDailyActivity5() {
    qtyController.text = dataJoDetail.value.detail!.qty != null ? dataJoDetail.value.detail!.qty.toString() : '';
    uomController.text = dataJoDetail.value.detail!.uomName ?? '';
    vesselController.text = dataJoDetail.value.detail!.vessel ?? '';
    if (activity5TranshipmentList.value.isEmpty) {
      jettyListTextController.value.add(TextEditingController());
      initialDateActivity5ListTextController.value.add(TextEditingController());
      finalDateActivity5ListTextController.value.add(TextEditingController());
      deliveryQtyListTextController.value.add(TextEditingController());
      activity5TranshipmentList.value.add(TDJoInspectionActivityStagesTranshipment());
    }
    Get.bottomSheet(
        GetBuilder(
          init: JoDetailController(),
          builder: (controller) => SizedBox(
            child: Container(
                margin: const EdgeInsets.only(top: 48),
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))),
                child: Obx(
                  () => Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add Stage Inspection',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: primaryColor),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'Stage 5: Work Complete',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(12),
                                    FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,3}')),
                                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
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
                                        borderSide: const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Actual Qty*',
                                      floatingLabelStyle: const TextStyle(color: onFocusColor),
                                      fillColor: onFocusColor),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  controller: uomController,
                                  cursorColor: onFocusColor,
                                  enabled: false,
                                  style: const TextStyle(color: onFocusColor),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'UOM',
                                      floatingLabelStyle: const TextStyle(color: onFocusColor),
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
                                        borderSide: const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Vessel',
                                      floatingLabelStyle: const TextStyle(color: onFocusColor),
                                      fillColor: onFocusColor),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                barges.value.isNotEmpty
                                    ? Column(children: [
                                        ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: activity5bargesCount,
                                            itemBuilder: (context, i) {
                                              bargesController.value[i].text = barges.value[i];
                                              return Column(
                                                children: [
                                                  TextFormField(
                                                    controller: bargesController.value[i],
                                                    cursorColor: onFocusColor,
                                                    onChanged: (value) {
                                                      editBargeForm(i);
                                                    },
                                                    style: const TextStyle(color: onFocusColor),
                                                    decoration: InputDecoration(
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: const BorderSide(color: onFocusColor),
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        labelText: 'Barge ${i + 1}',
                                                        floatingLabelStyle: const TextStyle(color: onFocusColor),
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
                                              padding: const EdgeInsets.symmetric(vertical: 12), backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                          child: const SizedBox(
                                              width: double.infinity,
                                              child: Center(
                                                  child: Text(
                                                'Add Barge',
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                                    backgroundColor: Colors.red,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                                child: const SizedBox(
                                                    width: double.infinity,
                                                    child: Center(
                                                        child: Text(
                                                      'Delete',
                                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                    )))),
                                          )
                                        : const Expanded(flex: 1, child: SizedBox()),
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
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: activity5TranshipmentList.value.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'KOS Transhipment Form ${index + 1}',
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: primaryColor),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      addActivity5Form();
                                                    },
                                                    child: Container(
                                                      margin: const EdgeInsets.only(right: 8),
                                                      height: 42,
                                                      width: 42,
                                                      decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8)),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  index > 0
                                                      ? InkWell(
                                                          onTap: () {
                                                            removeActivity5Form();
                                                          },
                                                          child: Container(
                                                            margin: const EdgeInsets.only(right: 8),
                                                            height: 42,
                                                            width: 42,
                                                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                                                            child: const Center(
                                                              child: Icon(
                                                                Icons.remove,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox()
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller: jettyListTextController.value[index],
                                            validator: (value){
                                              return validationTranshipment(index,value,0);
                                            },
                                            cursorColor: onFocusColor,
                                            inputFormatters: [
                                              new LengthLimitingTextInputFormatter(150),
                                            ],
                                            onChanged: (value) {
                                              editActivity5Transhipment(index);
                                            },
                                            style: const TextStyle(color: onFocusColor),
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: onFocusColor),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                labelText: 'Jetty',
                                                floatingLabelStyle: const TextStyle(color: onFocusColor),
                                                fillColor: onFocusColor),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller: initialDateActivity5ListTextController.value[index],
                                            readOnly: true,
                                            validator: (value){
                                              return validationTranshipment(index,value,1);
                                            },
                                            cursorColor: onFocusColor,
                                            onTap: () {
                                              selectInitialDate5(context, index);
                                            },
                                            onChanged: (value) {
                                              editActivity5Transhipment(index);
                                            },
                                            style: const TextStyle(color: onFocusColor),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: onFocusColor),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              labelText: 'Initial Date',
                                              floatingLabelStyle: const TextStyle(color: onFocusColor),
                                              fillColor: onFocusColor,
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    selectInitialDate5(context, index);
                                                  },
                                                  icon: const Icon(Icons.calendar_today_rounded)),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller: finalDateActivity5ListTextController.value[index],
                                            validator: (value){
                                              return validationTranshipment(index,value,2);
                                            },
                                            readOnly: true,
                                            cursorColor: onFocusColor,
                                            onTap: () {
                                              selectFinalDate5(context, index);
                                            },
                                            onChanged: (value) {
                                              editActivity5Transhipment(index);
                                            },
                                            style: const TextStyle(color: onFocusColor),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: onFocusColor),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              labelText: 'Final Date',
                                              floatingLabelStyle: const TextStyle(color: onFocusColor),
                                              fillColor: onFocusColor,
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    selectInitialDate5(context, index);
                                                  },
                                                  icon: const Icon(Icons.calendar_today_rounded)),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller: deliveryQtyListTextController.value[index],
                                            validator: (value){
                                              return validationTranshipment(index,value,3);
                                            },
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(12),
                                              FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,3}')),
                                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
                                            ],
                                            cursorColor: onFocusColor,
                                            onChanged: (value) {
                                              editActivity5Transhipment(index);
                                            },
                                            style: const TextStyle(color: onFocusColor),
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: onFocusColor),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                labelText: 'Delivery Qty',
                                                floatingLabelStyle: const TextStyle(color: onFocusColor),
                                                fillColor: onFocusColor
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller: uomController,
                                            enabled: false,
                                            cursorColor: onFocusColor,
                                            style: const TextStyle(color: onFocusColor),
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: onFocusColor),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                labelText: 'UOM',
                                                floatingLabelStyle: const TextStyle(color: onFocusColor),
                                                fillColor: onFocusColor),
                                          ),
                                          const SizedBox(height: 16,),
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
                                      backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      width: double.infinity,
                                      child: const Center(
                                          child: Text(
                                        'Cancel',
                                        style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
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
                                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      width: double.infinity,
                                      child: const Center(
                                          child: Text(
                                        'Submit',
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
        title: const Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: const Text('Apakah benar anda akan submit stage work complete ini? pastikan data yg anda input benar.'),
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
              var result = await addActivity5StageV2();
              if (result == 'success') {
                Get.back();
                cleanActivity5();
                Get.back();
                await getJoDailyActivityLocalV2();
              } else {
                Get.back();
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
        title: const Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: const Text('Apakah anda ingin melanjutkan ke stage berikutnya? jika Ya, anda tidak bisa mengubah stage sebelumnya. Pastikan data yang anda input benar.'),
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
              stageListModal.value = [];
              activityListTextController.value = [];
              update();
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Future editActivity5() async {
    var barge = barges.value.map((barge) {
      return Barge(barge: barge);
    }).toList();
    debugPrint('barges nya nih: ${jsonEncode(barge)}');
    activity5List.value.first = FormDataArray(
        tHJoId: id,
        mStatusinspectionstagesId: activityStage,
        uomId: dataJoDetail.value.detail?.uomId ?? 0,
        transDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        actualQty: qtyController.text,
        createdBy: userData.value!.id,
        vessel: vesselController.text,
        barge: barge,
        transhipment: activity5TranshipmentList.value);
  }

  void editActivityStage5Confirm() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: const Text('Apakah benar anda akan menyimpan perubahan stage work complete ini? pastikan data yg anda input benar.'),
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
              var result = await editActivity5StageV2();
              if (result == 'success') {
                Get.back();
                cleanActivity5();
                Get.back();
                await getJoDailyActivityLocalV2();
              } else {
                Get.back();
              }
            },
          ),
        ],
      ),
    );
  }

  // Activity 6 Inspection Functions

  Future<void> selectDate6(BuildContext context) async {
    final DateTime? picked =
        await showDatePicker(context: context, firstDate: DateTime.now().subtract(const Duration(days: 1)), lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1));
    if (picked != null) {
      activityDate.text = DateFormat('yyyy-MM-dd').format(picked).toString();
    }
  }

  Future<String> selectTime6(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: pickedTime != '' ?
      TimeOfDay(hour:int.parse(pickedTime.split(":")[0]),minute: int.parse(pickedTime.split(":")[1]))
          : TimeOfDay.now(),
        builder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                // Using 24-Hour format
                  alwaysUse24HourFormat: true),
              // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
              child: childWidget!);
        }
    );
    if (picked != null) {
      final String time = '${picked.hour}:${picked.minute}';
      // List timeSplit = picked.format(context).split(' ');
      // final String formattedTime = timeSplit[0];
      // final String time = formattedTime;
      return time;
    } else {
      return '';
    }
  }

  void checkActivity6List() {
    debugPrint('activities now: ${jsonEncode(activity6List.value)}');
  }

  void addActivity6Files(String path) {
    activity6Attachments.value.add(TDJoInspectionAttachment(
      tHJoId: id,
      pathName: path,
      fileName: path.split('/').last,
      isActive: 1,
      isUpload: 0,
      createdBy: userData.value?.id ?? 0,
      createdAt: DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()).toString(),
    ));
    debugPrint('file yangdi add: ${jsonEncode(activity6Attachments.value.last)}');
  }

  void editActivity6Files(String path, index) {
    activity6Attachments.value[index] = TDJoInspectionAttachment(
      tHJoId: id,
      pathName: path,
      fileName: path.split('/').last,
      isActive: 1,
      isUpload: 0,
      createdBy: userData.value?.id ?? 0,
      createdAt: DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()).toString(),
    );
    debugPrint('file yangdi edit: ${jsonEncode(activity6Attachments.value.last)}');
  }

  void removeActivity6Files(int index) {
    activity6Attachments.value.removeAt(index);
    update();

    // var file = activity6Attachments.value[index];
    // if(file.id != null){
    //   activity6Attachments.value[index] = TDJoInspectionAttachment(
    //     id: file.id ?? null,
    //     tHJoId: file.tHJoId,
    //     pathName: file.pathName,
    //     fileName: file.fileName,
    //     isActive: 0,
    //     isUpload: 0,
    //     createdBy: file.createdBy,
    //     updatedBy: userData.value?.id ?? 0,
    //     createdAt: file.createdAt,
    //     updatedAt: DateFormat('yyyy-MM-dd hh:mm:ss').format(
    //         DateTime.now()).toString(),
    //   );
    //   update();
    // } else {
    //   activity6Attachments.value.removeAt(index);
    // }
  }

  void removeActivity6FilesConfirm(int index) {
    activity6Attachments.value.removeAt(index);
  }

  void cameraImageActivity6() async {
    var total = 0;
    activity6Attachments.value.forEach((item) async {
      final fileBytes = await File(item.pathName!).readAsBytes();
      total = total + fileBytes.lengthInBytes;
      update();
    });
    File? image;
    try {
      final XFile? pic = await picker.pickImage(source: ImageSource.camera, imageQuality: 10);
      if (pic != null) {
        final imageTemp = File(pic!.path);
        image = imageTemp;
        final imageFileBytes = await File(image.path).readAsBytes();

        if (total + imageFileBytes.lengthInBytes > 10000000) {
          openDialog("Attention", 'Total File lebih dari 10 MB!');
          update();
        } else {
          final imageName = image.path.split('/').last;
          final dir = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
          bool exists = await Directory('$dir/ops/files/').exists();

          if (exists == false) {
            Directory('$dir/ops/files/').create();
          }

          image.rename('$dir/ops/files/$imageName');
          update();
          addActivity6Files(image.path);
        }
      }
    } on PlatformException catch (e) {
      openDialog('Failed', e.message ?? 'Gagal menambahkan file');
    }
    //openDialog('Success', 'Berhasil menambahkan file.');
  }

  void fileActivity6() async {
    var total = 0;
    activity6Attachments.value.forEach((item) async {
      final fileBytes = await File(item.pathName!).readAsBytes();
      total = total + fileBytes.lengthInBytes;
      update();
    });

    try {
      final FilePickerResult? attach =
          await FilePicker.platform.pickFiles(allowCompression: true, compressionQuality: 10, allowMultiple: true, type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);
      if (attach != null) {
        final List<XFile> xFiles = attach.xFiles;
        xFiles.forEach((data) async {
          final fileTemp = File(data!.path);
          final File file = fileTemp;
          final checkFileBytes = await File(file.path).readAsBytes();
          if (total + checkFileBytes.lengthInBytes > 10000000) {
            openDialog("Attention", 'Total File lebih dari 10 MB!');
            return;
          } else {
            addActivity6Files(file.path);
          }
          update();
        });
        //openDialog('Success', 'Berhasil menambahkan file.');
      }
    } on PlatformException catch (e) {
      openDialog('Failed', e.message ?? 'Gagal menambahkan file.');
    }
  }

  void cameraImageActivity6Update(int index) async {
    var total = 0;

    activity6Attachments.value.forEach((item) async {
      final fileBytes = await File(item.pathName!).readAsBytes();
      total = total + fileBytes.lengthInBytes;
      update();
    });
    File? image;
    try {
      final XFile? pic = await picker.pickImage(source: ImageSource.camera, imageQuality: 10);
      if (pic != null) {
        final imageTemp = File(pic!.path);
        image = imageTemp;
        final imageFileBytes = await File(image.path).readAsBytes();

        if (total + imageFileBytes.lengthInBytes > 10000000) {
          openDialog("Attention", 'Total File lebih dari 10 MB!');
          update();
        } else {
          final imageName = image.path.split('/').last;
          final dir = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
          bool exists = await Directory('$dir/ops/files/').exists();

          if (exists == false) {
            Directory('$dir/ops/files/').create();
          }

          image.rename('$dir/ops/files/$imageName');
          update();
          editActivity6Files(image.path, index);
        }
      }
    } on PlatformException catch (e) {
      openDialog('Failed', e.message ?? 'Gagal menambahkan file');
    }
    //openDialog('Success', 'Berhasil menambahkan file.');
  }

  void fileActivity6Update(int index) async {
    var total = 0;
    activity6Attachments.value.forEach((item) async {
      final fileBytes = await File(item.pathName!).readAsBytes();
      total = total + fileBytes.lengthInBytes;
      update();
    });

    try {
      final FilePickerResult? attach =
          await FilePicker.platform.pickFiles(allowCompression: true, compressionQuality: 10, allowMultiple: true, type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);
      if (attach != null) {
        final List<XFile> xFiles = attach.xFiles;
        xFiles.forEach((data) async {
          final fileTemp = File(data!.path);
          final File file = fileTemp;
          final checkFileBytes = await File(file.path).readAsBytes();
          if (total + checkFileBytes.lengthInBytes > 10000000) {
            openDialog("Attention", 'Total File lebih dari 10 MB!');
            return;
          } else {
            editActivity6Files(file.path, index);
          }
          update();
        });
        //openDialog('Success', 'Berhasil menambahkan file.');
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

  void previewImageAct6(int index, String photo) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Text(
              'Attachment ${index + 1}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
            ),
            // InkWell(
            //   onTap: () {
            //     removeActivity6Files(index);
            //   },
            //   child: Icon(
            //     Icons.delete_forever,
            //     color: Colors.red,
            //   ),
            // ),
            const Spacer(),
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.close),
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
        title: const Text(
          'File Attachment',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: const Text('Pilih sumber file yang ingin dilampirkan.'),
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
                            backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                        child: const Center(
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
                            backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                        child: const Center(
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

  void mediaPickerEditConfirm(int index) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'File Attachment',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: const Text('Pilih sumber file yang ingin dilampirkan.'),
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
                          cameraImageActivity6Update(index);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                        child: const Center(
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
                          fileActivity6Update(index);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                        child: const Center(
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

  void drawerDailyActivity6Edit() async {
    activity6List.value = [];
    activity6List.value = activity6ListStages.value.where((item) => item.mStatusinspectionstagesId == activityStage).toList();

    List<TDJoInspectionActivityStages> filteredStages = stageList.value.where((itemStage) => itemStage.mStatusinspectionstagesId == 6).toList();
    activityListTextController.value = [];
    filteredStages.forEach((item) {
      activityListTextController.value.add(TextEditingController(text: item.remarks));
    });
    stageListModal.value = filteredStages;
    activity6Attachments.value = activity6AttachmentsStage.value;
    update();
    Get.bottomSheet(
        GetBuilder(
          init: JoDetailController(),
          builder: (controller) => Container(
              margin: const EdgeInsets.only(top: 48),
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))),
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
                              const Text(
                                'Edit Stage Inspection',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: primaryColor),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                'Stage 6: Report to Client',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                showCursor: true,
                                readOnly: true,
                                controller: activityDate,
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
                                        icon: const Icon(Icons.calendar_today_rounded)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: onFocusColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Date*',
                                    floatingLabelStyle: const TextStyle(color: onFocusColor),
                                    fillColor: onFocusColor),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text('Detail Activities'),
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
                                        pickedTime = activityStartTime.text;
                                        update();
                                        activityStartTime.text = await selectTime6(Get.context!);
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
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: onFocusColor),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          labelText: 'Start Time*',
                                          floatingLabelStyle: const TextStyle(color: onFocusColor),
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
                                      readOnly: true,
                                      onTap: () async {
                                        pickedTime = activityEndTime.text;
                                        update();
                                        activityEndTime.text = await selectTime6(Get.context!);
                                      },
                                      style: const TextStyle(color: onFocusColor),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: onFocusColor),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          labelText: 'End Time',
                                          floatingLabelStyle: const TextStyle(color: onFocusColor),
                                          fillColor: onFocusColor),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                controller: activityText,
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
                                      borderSide: const BorderSide(color: onFocusColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Activity*',
                                    floatingLabelStyle: const TextStyle(color: onFocusColor),
                                    fillColor: onFocusColor),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              InkWell(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (editActivityMode.value == false) {
                                      addActivityV2();
                                    } else {
                                      updateActivityDetailV2();
                                    }
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  height: 42,
                                  width: 42,
                                  decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: Icon(
                                      editActivityMode.value == false ? Icons.add : Icons.check,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              stageListModal.value.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: stageListModal.value.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        TDJoInspectionActivityStages stage = stageListModal.value[index];
                                        return Column(
                                          children: [
                                            Card(
                                                color: Colors.white,
                                                child: Padding(
                                                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                flex: 2,
                                                                child: Text(
                                                                  'Date',
                                                                  style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700),
                                                                )),
                                                            const VerticalDivider(width: 1),
                                                            const SizedBox(width: 16),
                                                            Expanded(
                                                                flex: 2,
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      stage.transDate ?? '-',
                                                                      style: TextStyle(fontSize: 11.sp),
                                                                    ),
                                                                    const SizedBox(width: 6),
                                                                    InkWell(
                                                                      onTap: () {
                                                                        debugPrint('Delete header');
                                                                        removeActivityByDateConfirm(stage!.transDate!, index, stage.mStatusinspectionstagesId!.toInt());
                                                                      },
                                                                      child: const ImageIcon(AssetImage("assets/icons/deleteStage.png"), color: Colors.red, size: 16),
                                                                    )
                                                                  ],
                                                                )),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Expanded(
                                                                flex: 1,
                                                                child: Text(
                                                                  'Activities',
                                                                  style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700),
                                                                )),
                                                            const VerticalDivider(
                                                              width: 1,
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            Expanded(
                                                                flex: 3,
                                                                child: Column(
                                                                  children: [
                                                                    ListView.builder(
                                                                        shrinkWrap: true,
                                                                        physics: const NeverScrollableScrollPhysics(),
                                                                        itemCount: stage.listActivity!.length ?? 0,
                                                                        itemBuilder: (context, indexDetail) {
                                                                          TDJoInspectionActivity activity = stage.listActivity![indexDetail];
                                                                          return Padding(
                                                                            padding: const EdgeInsets.only(bottom: 8.0),
                                                                            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                              Expanded(
                                                                                  flex: 1,
                                                                                  child: Text('${Helper.formatToHourMinute(activity!.startActivityTime!)} - ${Helper.formatToHourMinute(activity!.endActivityTime!)}',
                                                                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700))),
                                                                              const VerticalDivider(
                                                                                width: 1,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 8,
                                                                              ),
                                                                              Expanded(
                                                                                  flex: 2,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Text(
                                                                                          activity.activity ?? '-',
                                                                                          style: TextStyle(fontSize: 11.sp),
                                                                                        ),
                                                                                      ),
                                                                                      InkWell(
                                                                                        onTap: () {
                                                                                          debugPrint('Edit');
                                                                                          editActivityDetailV2(stage!.transDate!, activity!.activity!);
                                                                                        },
                                                                                        child: const ImageIcon(AssetImage("assets/icons/editActivity.png"), color: primaryColor, size: 16),
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        width: 6,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 18,
                                                                                        width: 18,
                                                                                        child: Ink(
                                                                                          decoration: ShapeDecoration(color: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                                                                                          child: InkWell(
                                                                                            onTap: () {
                                                                                              debugPrint('Hapus detail');
                                                                                              removeActivityConfirm(stage!.transDate!, indexDetail, index, stage!.mStatusinspectionstagesId!.toInt(),
                                                                                                  activity.activity ?? '', activity.startActivityTime!, activity.endActivityTime ?? '');
                                                                                            },
                                                                                            child: const Icon(Icons.remove, color: Colors.white, size: 12),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ))
                                                                            ]),
                                                                          );
                                                                        }),
                                                                  ],
                                                                )
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          width: 16,
                                                        ),
                                                        TextFormField(
                                                          inputFormatters: [
                                                            LengthLimitingTextInputFormatter(250),
                                                          ],
                                                          controller: activityListTextController[index],
                                                          onChanged: (value) {},
                                                          cursorColor: onFocusColor,
                                                          style: const TextStyle(color: onFocusColor),
                                                          decoration: InputDecoration(
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderSide: const BorderSide(color: onFocusColor),
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              labelText: 'Remarks',
                                                              floatingLabelStyle: const TextStyle(color: onFocusColor),
                                                              fillColor: onFocusColor),
                                                        )
                                                      ],
                                                    )))
                                          ],
                                        );
                                      },
                                    )
                                  : const SizedBox(),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                'Attachment',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text('File lampiran maksimal 5 file dengan ukuran total file maksimal 10 MB. Jenis file yang diperbolehkan hanya PDF/JPG/PNG/JPEG.'),
                              const SizedBox(
                                height: 16,
                              ),
                              activity6Attachments.value.isNotEmpty
                                  ? GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                      ),
                                      itemCount: activity6Attachments.value.length,
                                      itemBuilder: (content, index) {
                                        final TDJoInspectionAttachment photo = activity6Attachments.value[index];
                                        final String fileType = checkFileType(photo.pathName!);
                                        var filename = photo.fileName!;
                                        return fileType == 'image'
                                            ? SizedBox(
                                                width: 68,
                                                height: 68,
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets.only(top: 5),
                                                      width: 63,
                                                      height: 63,
                                                      child: InkWell(
                                                        onTap: () {
                                                          // controller
                                                          //     .previewImageAct6(
                                                          //         index,
                                                          //         photo.pathName!);
                                                          mediaPickerEditConfirm(index);
                                                        },
                                                        child: Image.file(
                                                          File(photo.pathName!),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 68,
                                                      height: 68,
                                                      child: Align(
                                                        alignment: Alignment.topRight,
                                                        child: InkWell(
                                                            onTap: () {
                                                              controller.removeActivity6Files(index);
                                                            },
                                                            child: Image.asset('assets/icons/close.png', width: 24)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : fileType == 'doc'
                                                ? SizedBox(
                                                    width: 68,
                                                    height: 68,
                                                    child: Stack(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            // OpenFilex.open(
                                                            //     photo.pathName!);
                                                            mediaPickerEditConfirm(index);
                                                          },
                                                          child: Container(
                                                            margin: const EdgeInsets.only(top: 5),
                                                            width: 63,
                                                            height: 63,
                                                            child: Center(
                                                                child: Column(
                                                              children: [
                                                                Spacer(),
                                                                Image.asset(
                                                                  'assets/icons/pdfIcon.png',
                                                                  height: 42,
                                                                ),
                                                                Text(filename, style: const TextStyle(fontSize: 8), overflow: TextOverflow.ellipsis)
                                                              ],
                                                            )),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 68,
                                                          height: 68,
                                                          child: Align(
                                                              alignment: Alignment.topRight,
                                                              child: InkWell(
                                                                  onTap: () {
                                                                    controller.removeActivity6Files(index);
                                                                  },
                                                                  child: Image.asset('assets/icons/close.png', width: 24))),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : const SizedBox();
                                      })
                                  : const SizedBox(),
                              const SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                width: 68,
                                height: 68,
                                child: activity6Attachments.value.length < 5
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          // var total = 0;
                                          // activity6Attachments.value.forEach((item) async {
                                          //   final fileBytes = await File(item.pathName!).readAsBytes();
                                          //   total = total + fileBytes.lengthInBytes;
                                          // });
                                          mediaPickerConfirm();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                                        child: const Center(
                                            child: Icon(
                                          Icons.folder_rounded,
                                          color: primaryColor,
                                        )))
                                    : const SizedBox(),
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
                                onPressed: () async {
                                  Get.back();
                                  // checkActivity6List();
                                  await getJoDailyActivity6AttachmentLocal();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                                child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    width: double.infinity,
                                    child: const Center(
                                        child: Text(
                                      'Cancel',
                                      style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
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
                                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    width: double.infinity,
                                    child: const Center(
                                        child: Text(
                                      'Submit',
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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

  Future<bool> editActivity6StagesV2() async {
    try {
      final db = await SqlHelper.db();
      List<TDJoInspectionActivityStages> stages = stageListModal.value;
      final createdBy = userData.value!.id;
      //deactive semua aktifitas dan stagenya
      // update table t_d_jo_inspection_activity_stages set is_active =0 berdasarkan thjoid dan transdate dan mStatusinspectionstagesId
      int result = await db.update(
        't_d_jo_inspection_activity_stages',
        {'is_active': 0}, // The new value for the is_active field
        where: 't_h_jo_id = ?  AND m_statusinspectionstages_id = ?',
        whereArgs: [id, activityStage],
      );

      //debugPrint("data input edit deactive ${result} ${id} ${statusId}");
      debugPrint("data input edit remarks ${activityListTextController.value}");

      stages.asMap().forEach((index, stage) async {
        debugPrint("data input edit ${jsonEncode(stage.toJson())}");
        if (stage.id != null) {
          TDJoInspectionActivityStages data = TDJoInspectionActivityStages(
              isUpload: "0",
              isActive: "1",
              updatedBy: userData.value!.id.toString(),
              updatedAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
              remarks: activityListTextController.value[index].text);

          int updated = await db.update(
            't_d_jo_inspection_activity_stages',
            data.toEdit(),
            where: 'id = ? ',
            whereArgs: [stage.id],
          );

          //inactive detail
          int detail = await db.update(
            't_d_jo_inspection_activity',
            {'is_active': 0}, // The new value for the is_active field
            where: 't_d_jo_inspection_activity_stages_id = ?',
            whereArgs: [stage.id],
          );
          List<TDJoInspectionActivity> listActivity = stage.listActivity ?? [];
          listActivity.forEach((activity) async {
            if (activity.code != null) {
              //Update
              TDJoInspectionActivity detail = TDJoInspectionActivity(
                  startActivityTime: activity.startActivityTime,
                  endActivityTime: activity.endActivityTime,
                  activity: activity.activity,
                  isActive: 1,
                  isUpload: 0,
                  updatedAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
                  updatedBy: createdBy.toString());
              update();
              debugPrint('data yang update nya : ${jsonEncode(detail)}');

              int updated = await db.update(
                't_d_jo_inspection_activity',
                detail.toEdit(),
                where: 'id = ?',
                whereArgs: [activity.id],
              );
              debugPrint("Print Edit ${activity.id} ${updated}");
            } else {
              //insert
              TDJoInspectionActivity detail = TDJoInspectionActivity(
                  tHJoId: id,
                  tDJoInspectionActivityStagesId: stage.id,
                  startActivityTime: activity.startActivityTime,
                  endActivityTime: activity.endActivityTime,
                  activity: activity.activity,
                  code: 'JOIA-${stage.mStatusinspectionstagesId}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}',
                  isActive: 1,
                  isUpload: 0,
                  createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
                  createdBy: createdBy);
              int raw = await db.insert("t_d_jo_inspection_activity", detail.toInsert());
              debugPrint("Print Edit ${activity.id} ${raw}");
            }
          });
        } else {
          TDJoInspectionActivityStages data = TDJoInspectionActivityStages(
            tHJoId: id,
            mStatusinspectionstagesId: stage.mStatusinspectionstagesId,
            transDate: stage.transDate,
            code: "JOIAST-${stage.mStatusinspectionstagesId}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}",
            isUpload: "0",
            isActive: "1",
            createdBy: userData.value!.id,
            remarks: activityListTextController.value[index].text,
            createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
          );
          int result = await db.insert("t_d_jo_inspection_activity_stages", data.toInsert());
          List<TDJoInspectionActivity> details = stage.listActivity ?? [];
          details.forEach((activity) async {
            TDJoInspectionActivity detail = TDJoInspectionActivity(
                tHJoId: id,
                tDJoInspectionActivityStagesId: result,
                startActivityTime: activity.startActivityTime,
                endActivityTime: activity.endActivityTime,
                activity: activity.activity,
                code: 'JOIA-${stage.mStatusinspectionstagesId}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}',
                isActive: 1,
                isUpload: 0,
                createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
                createdBy: createdBy);
            await db.insert("t_d_jo_inspection_activity", detail.toInsert());
          });
        }
      });

      await db.update('t_d_jo_inspection_attachment', {'is_active': 0}, where: 't_h_jo_id = ?', whereArgs: [id]);
      debugPrint("print list file attachment ${activity6Attachments.value}");
      var attachmentCount = 0;
      for (var file in activity6Attachments.value) {
        debugPrint('nyang mau di update attachnya: ${jsonEncode(file)}');
        attachmentCount++;
        if (file.id != null) {
          // var filename = file.fileName!;
          TDJoInspectionAttachment attach = file.copyWith(tDJoInspectionActivityStagesId: stages.first.id, updatedAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()), updatedBy: createdBy);
          TDJoInspectionAttachment(
              tHJoId: file.tHJoId,
              tDJoInspectionActivityStagesId: stages.first.id,
              fileName: file.fileName,
              pathName: file.pathName,
              code: file.code,
              isActive: 1,
              isUpload: 0,
              updatedAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
              updatedBy: createdBy);
          debugPrint('debug attach nya: ${jsonEncode(attach.toEdit())}');
          await db.update('t_d_jo_inspection_attachment', attach.toEdit(), where: 'id = ?', whereArgs: [file.id]);
        } else {
          var filename = file.fileName!;
          TDJoInspectionAttachment attach = TDJoInspectionAttachment(
              tHJoId: id,
              tDJoInspectionActivityStagesId: stages.first.id,
              fileName: filename,
              pathName: file.pathName,
              code: 'JOIAF-${activityStage}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}-${attachmentCount}',
              isActive: 1,
              isUpload: 0,
              createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
              createdBy: createdBy);
          await db.insert('t_d_jo_inspection_attachment', attach.toJson());
        }
      }

      //  if(activity6Attachments.value.isNotEmpty){
      //       var count = 0;
      //       activity6Attachments.value.forEach((attachment){
      //         count++;
      //         attachmentValues.add({
      //         'id': attachment.id ?? null,
      //         't_h_jo_id' : id,
      //         't_d_jo_inspection_activity_stages_id' : null,
      //         'path_name' : attachment.pathName,
      //         'file_name' : attachment.fileName,
      //         'code' : attachment.code ?? 'JOIAF-6-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}-$count',
      //         'is_active' : attachment.isActive,
      //         'is_upload' : attachment.isUpload,
      //         'created_by' : attachment.createdBy,
      //         'updated_by' : attachment.id == null ? null : createdBy,
      //         'created_at' : attachment.createdAt,
      //         'updated_at' : attachment.id == null ? null : DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()).toString(),
      //         });
      //         // attachmentValues.add('''($id,'${attachment.pathName}','${attachment.fileName}','JOIAF-6-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}-$count',1,0,${createdBy},'${DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now())}')''');
      //         // update();
      //       });
      //     }

      stageListModal.value = [];
      activityListTextController.value = [];
      return true;
    } catch (e) {
      // Handle any parsing errors
      return false; // Return the original time if parsing fails
    }
  }

  void addActivity6StageConfirm() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: const Text('Apakah benar anda akan submit stage report to client ini? pastikan data yg anda input benar.'),
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
              bool result = await saveActivity6Stages();
              debugPrint("print result saveActivity6Stages");
              if (result == true) {
                Get.back();
                Get.back();
                activity6Attachments.value = [];
                stageListModal.value = [];
                activityListTextController.value = [];
                await getJoDailyActivityLocalV2();
                await getJoDailyActivity6AttachmentLocal();
              } else {
                Get.back();
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
        title: const Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: const Text('Apakah benar anda akan menyimpan perubahan stage report to client ini? pastikan data yg anda input benar.'),
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
              final bool result = await editActivity6StagesV2();
              if (result == true) {
                Get.back();
                Get.back();
                await getJoDailyActivityLocalV2();
                await getJoDailyActivity6AttachmentLocal();
              } else {
                Get.back();
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
        title: const Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: const Text('Apakah benar anda ingin Finish JO Inspection ini? pastikan data yg anda input benar, karena anda tidak bisa mengubah data setelah Finish JO'),
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
              await finishJo();
              await getData();
              update();
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Future<void> finishJo() async {
    try {
      final db = await SqlHelper.db();
      final timeFinish = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString();
      db.execute('''
          UPDATE t_h_jo SET inspection_finished_date = '${timeFinish}' WHERE id = ${dataJoDetail.value.detail!.id};
        ''');
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      update();
    }
  }

  // Activity Lab Functions

  void detailLabActivity(int? lab, String name, int joLabId) {
    Get.to(const LabActivityDetailScreen(), arguments: {'id': id, 'labId': lab, 'name': name, 'joLabId': joLabId});
  }

  void openDialog(String type, String text) {
    Get.dialog(
      AlertDialog(
        title: Text(
          type,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
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
      final FilePickerResult? attach = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);
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

  String? validationTranshipment(int index, String? value,int type) {
    final jetty = jettyListTextController.value[index].text;
    final initialDate = initialDateActivity5ListTextController.value[index].text;
    final finalDate = finalDateActivity5ListTextController.value[index].text;
    final deliveryQty =  deliveryQtyListTextController.value[index].text;
    debugPrint('print data transhipment jetty ${jetty} initialdate ${initialDate} final date ${finalDate} deliveryQty ${deliveryQty}');
    if(jetty.length > 0 || initialDate.length > 0 || finalDate.length > 0 || deliveryQty.length > 0){
      switch (type) {
        case 0:
          return jetty.isNotEmpty ? null : 'Form wajib diisi';
        case 1:
          return initialDate.isNotEmpty ? null : 'Form wajib diisi';
        case 2:
          return finalDate.isNotEmpty ? null : 'Form wajib diisi';
        case 3:
          return deliveryQty.isNotEmpty ? null : 'Form wajib diisi';
        default:
          return null; // Jika type tidak sesuai
      }
    }
    return null;
  }
}
