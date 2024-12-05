import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:ops_mobile/base/component/custom_image.dart';
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
import 'package:ops_mobile/data/model/t_d_jo_document_inspection.dart';
import 'package:ops_mobile/data/model/t_d_jo_document_laboratory.dart';
import 'package:ops_mobile/data/model/t_d_jo_finalize_inspection_model.dart';
import 'package:ops_mobile/data/model/t_d_jo_finalize_laboratory.dart';
import 'package:ops_mobile/data/model/t_d_jo_finalize_laboratory_model.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity_stages.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_pict.dart';
import 'package:ops_mobile/data/respository/repository.dart';
import 'package:ops_mobile/data/sqlite.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:ops_mobile/feature/documents/documents_screen.dart';
import 'package:ops_mobile/feature/lab_activity_detail/lab_activity_detail_screen.dart';
import 'package:ops_mobile/utils/helper.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:url_launcher/url_launcher.dart';

class JoWaitingController extends BaseController {
  // Data User
  Rx<Data?> userData = Rx(Data());
  late var settingsData;

  // Settings
  final PathProviderPlatform providerAndroid = PathProviderPlatform.instance;
  final picker = ImagePicker();
  RxBool activitySubmitted = RxBool(false);
  final _formKey = GlobalKey<FormState>();

  TextEditingController searchLabText = TextEditingController();

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
  Rx<DataDetail> dataJoDetail = Rx(DataDetail());
  Rx<DataPIC> dataJoPIC = Rx(DataPIC());

  // Activity Inspection Data
  RxList<DataDailyPhoto> dataJoDailyPhotos = RxList();
  Rx<DataListActivity> dataListActivity = Rx(DataListActivity());
  Rx<DataListActivity5> dataListActivity5 = Rx(DataListActivity5());
  RxList<String> barges = RxList();
  RxList<String> activity5Barges = RxList();
  RxList<TextEditingController> bargesController = RxList();
  Rx<DataListActivity6> dataListActivity6 = Rx(DataListActivity6());
  Rx<Activity6Attachments> dataListActivity6Attachments =
  Rx(Activity6Attachments());

  RxList<TDJoInspectionActivityStages> stageList = RxList();

  // Activity Lab Data
  Rx<DataListActivityLab> dataListActivityLab = Rx(DataListActivityLab());
  Rx<DataListActivityLab5> dataListActivityLab5 = Rx(DataListActivityLab5());
  RxList<Laboratory> labs = RxList();
  RxList<Laboratory> labsTemp = RxList();

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

  RxList<TDJoInspectionPict> dailyActivityPhotosV2 = RxList();

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
  late File? sampleFile;
  late File? uploadFile;
  TextEditingController documentCertificateNumber = TextEditingController();
  TextEditingController documentCertificateDate = TextEditingController();
  TextEditingController documentCertificateBlanko = TextEditingController();
  TextEditingController documentCertificateLhv = TextEditingController();
  TextEditingController documentCertificateLs = TextEditingController();
  RxList<Map<String, dynamic>> documentInspection = RxList();
  RxList<File> documentInspectionAttachments = RxList();
  RxList<Map<String, dynamic>> documentLaboratory = RxList();
  RxList<File> documentLaboratoryAttachments = RxList();
  RxList<Map<String, dynamic>> documentMap = RxList();

  RxList<TDJoFinalizeInspectionModel> inspectionDocuments = RxList();
  RxList<TDJoDocumentInspection> inspectionDocumentsFiles = RxList();
  RxList<TDJoFinalizeLaboratoryModel> laboratoryDocuments = RxList();
  RxList<TDJoDocumentLaboratory> laboratoryDocumentsFiles = RxList();

  @override
  void onInit() async {
    // var user = jsonDecode(await StorageCore().storage.read('user'));
    // debugPrint('data user: ${user}');
    var dataUser = jsonDecode(await StorageCore().storage.read('user'));
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
    debugPrint('data users: ${jsonEncode(userData.value)}');
    // sampleFile = File('assets/sample/sample1.pdf');
    var argument = await Get.arguments;
    id = argument['id'];
    statusId = argument['status'];
    isLoadingJO == true;
    searchLabText.addListener(searchLab);
    update();
    await getData();
    //await getJoDetailLocal();
    debugPrint('activity stage now: $activityStage');

    super.onInit();
  }

  // Get Data

  Rx<bool> loadingSpk = false.obs;
  Future<void> downloadSpk()async{
    try{
      loadingSpk.value = true;
      bool coneection = await Helper.checkConnection();
      if(coneection){
        final  idJo = id;
        final response = await http.get(
            Uri.parse('${Helper.baseUrl()}/api/v1/pdf/assignment/$idJo'),
            headers: {'Content-Type': 'application/json'}
        );
        if(response.statusCode ==200){
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          final urlDoc = responseData['data'];
          await launchUrl(Uri.parse(urlDoc), mode: LaunchMode.externalApplication);
          // if (await canLaunchUrl(Uri.parse(urlDoc))) {
          //
          // } else {
          //   openDialog('Attenction', 'Gagal  menampilkan document');
          // }
        }else{
          openDialog('Attenction', 'Gagal  mendownload document');
        }
      }else{
        openDialog('Attenction', 'Periksa koneksi Internet Anda');
      }
      loadingSpk.value = false;
    }catch(e){
      loadingSpk.value = false;
      openDialog('Attenction', 'Periksa koneksi Internet Anda');
    }
  }

  Future<void> getJoDetailLocal() async {
    final data = await SqlHelper.getDetailJo(id);
    debugPrint('print data id jo $id');
    debugPrint('print data detail : ${jsonEncode(data.first)}');
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

  Future<void> getData() async {
    await getJoDetailLocal();
    debugPrint('data employee pic: ${dataJoDetail.value.detail?.idPicInspector}, ${dataJoDetail.value.detail?.idPicLaboratory}');
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
   // await getJoPIC();
    await getJoPICLocal();
   await getJoDailyPhotoV2();
   //  await getJoDailyPhoto();
   //  await getJoDailyActivity();
   await getJoDailyActivityLocalV2();
   //  await getJoDailyActivity5();
   //  await getJoDailyActivity6();
    // await getJoDailyActivityLab();
    // await getJoDailyActivityLab5();
    await getJoInspectionDocuments();
    await getJoLaboratoryDocuments();
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

  Future<void> getJoPIC() async {
    var response = await repository.getJoPIC(id) ?? JoPicModel();
    debugPrint('JO PIC: ${jsonEncode(response)}');
    dataJoPIC.value = response?.data ?? DataPIC();
  }

  Future<void> getJoPICLocal() async {
    //var response = await repository.getJoPIC(id) ?? JoPicModel();
    var response = await SqlHelper.getDetailJoPicHistory(id);
    debugPrint('JO PIC: ${jsonEncode(response)}');
    var lab = dataJoDetail.value.laboratory?.map((lab){return {'name': lab.name};}).toList();
    dataJoPIC.value = DataPIC.fromJson({
      'detail' : {
        'etta_vessel' : dataJoDetail.value.detail?.ettaVessel ?? '-',
        'start_date_of_attendance' : dataJoDetail.value.detail?.startDateOfAttendance ?? '-',
        'end_date_of_attendance' : dataJoDetail.value.detail?.endDateOfAttendance ?? '-',
        'lokasi_kerja' : dataJoDetail.value.detail?.lokasiKerja ?? '-',
        'pic_laboratory' : dataJoDetail.value.detail?.picLaboratory ?? '-',
        'pic_inspector' : dataJoDetail.value.detail?.picInspector ?? '-'
      },
      'lab' : lab ?? [],
      'assign_history' : response,
    });
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

    List<TDJoInspectionPict> pict =
    result.map((json) => TDJoInspectionPict.fromJson(json)).toList();
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
    dataListActivity.value = response?.data ?? DataListActivity();
    if (dataListActivity.value.data!.isNotEmpty) {
      debugPrint(
          'stage now: ${dataListActivity.value.data!.last.mStatusinspectionstagesId.toString()}');
      activityStage = int.parse(dataListActivity
          .value.data!.last.mStatusinspectionstagesId
          .toString()) +
          1;
    }
    activityListStages.value.clear();
    dataListActivity.value.data?.forEach((data) {
      activityListStages.value.add(Activity(
        tHJoId: data.tHJoId,
        mStatusinspectionstagesId: data.mStatusinspectionstagesId,
        transDate: data.transDate,
        startActivityTime: data.startActivityTime,
        endActivityTime: data.endActivityTime,
        activity: data.activity,
        createdBy: data.createdBy,
        remarks: data.remarks,
      ));
    });
  }

  void searchLab(){
    final String search = searchLabText.text;
    debugPrint('hasil search text nya: $search');
    var dataSearch = labsTemp.value.where((value) => ( value.name?.toLowerCase() == search.toLowerCase() || (value.name?.toLowerCase() ?? '').contains(search.toLowerCase()) ) ).toList();
    debugPrint('hasil search: ${jsonEncode(dataSearch)}');
    labs.value = dataSearch;
    if(search == ''){
      labs.value = labsTemp.value;
      update();
    }
    update();
  }

  Future<void> getJoDailyActivityLocalV2() async {
    stageList.value = [];
    List<Map<String, dynamic>> result = [];
    final db = await SqlHelper.db();

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
      debugPrint('data modifiable nya nih: ${jsonEncode(result)}');
      await Future<dynamic>.delayed(const Duration(milliseconds: 500));

      // Create a modifiable list of stages
      List<Map<String, dynamic>> modifiableResult =
      result.map((stage) => Map<String, dynamic>.from(stage)).toList();

      for (var stage in modifiableResult) {
        debugPrint('data modifiable update: ${jsonEncode(stage)}');
        int tHJoId = stage['t_h_jo_id'];
        int stageId = stage[
        'id']; // use this or 't_d_jo_inspection_activity_stages_id' if it exists
        int stageStatusId = stage['m_statusinspectionstages_id'];
        debugPrint('params nya ini: $tHJoId, $stageId, $stageStatusId');

        activityStage = stageStatusId;
        activitySubmitted.value = true;
        update();

        // Query related data from t_d_jo_inspection_activity
        List<Map<String, dynamic>> activityResult = await db.query(
          't_d_jo_inspection_activity',
          where:
          't_h_jo_id = ? and t_d_jo_inspection_activity_stages_id = ? and is_active = ?',
          // add additional criteria if necessary
          whereArgs: [tHJoId, stageId, 1],
        );
        debugPrint("print activity result 1517  ${activityResult}");

        List<Map<String, dynamic>> activityBarge = await db.query(
          't_d_jo_inspection_activity_barge',
          where:
          't_h_jo_id = ? and t_d_jo_inspection_activity_stages_id = ? and is_active = ?',
          // add additional criteria if necessary
          whereArgs: [tHJoId, stageId, 1],
        );

        List<Map<String, dynamic>> activityVessel = await db.query(
            't_d_jo_inspection_activity_vessel',
            where:
            't_h_jo_id = ? and t_d_jo_inspection_activity_stages_id = ? and is_active = ?',
            // add additional criteria if necessary
            whereArgs: [tHJoId, stageId, 1],
            limit: 1);

        List<Map<String, dynamic>> activityStageTranshipment =
        await db.rawQuery('''
          SELECT t.*, u.name as uom_name
          FROM t_d_jo_inspection_activity_stages_transhipment AS t
          LEFT JOIN m_uom AS u ON t.uom_id = u.id
          WHERE t.t_d_inspection_stages_id = ? AND t.is_active = ?
        ''', [stageId, 1]);

        debugPrint(
            "print stage Transhipment 1541 ${activityStageTranshipment}");
        // Add activityResult to the current stage
        stage['listactivity'] = activityResult;
        stage['listactivitybarge'] = activityBarge;
        stage['listactivitytranshipment'] = activityStageTranshipment;
        if (activityVessel.length > 0) {
          stage['activityvesel'] = activityVessel[0]; //first index
        } else {
          stage['activityvesel'] = null;
        }
      }

      // Convert the modifiableResult list to List<TDJoInspectionActivityStages>
      List<TDJoInspectionActivityStages> stagesList = modifiableResult
          .map((json) => TDJoInspectionActivityStages.fromJson(json))
          .toList();

      stageList.value = stagesList;

      if (stageList.value
          .where((item) => item.mStatusinspectionstagesId == 6)
          .isNotEmpty) {
        await getJoDailyActivity6AttachmentLocal();
      }

      debugPrint("print stage list 1559  ${jsonEncode(stagesList)}");
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      update();
    }
  }

  // Future<void> getJoDailyActivity5() async {
  //   var response =
  //       await repository.getJoListDailyActivity5(id) ?? JoListDailyActivity5();
  //   debugPrint('JO Daily Activity 5: ${jsonEncode(response)}');
  //   if (response.data!.detail!.isNotEmpty) {
  //     dataListActivity5.value = response?.data ?? DataListActivity5();
  //     var data = dataListActivity5.value;
  //     var dataBarge = data.barge!.map((item) {
  //       return Barge(barge: item.barge);
  //     }).toList();
  //     var dataTranshipment = data.transhipment!.map((item) {
  //       return Transhipment(
  //         jetty: item.jetty,
  //         initialDate: item.initialDate,
  //         finalDate: item.finalDate,
  //         deliveryQty: item.deliveryQty.toString(),
  //       );
  //     }).toList();
  //     activity5ListStages.value.add(FormDataArray(
  //         tHJoId: id,
  //         mStatusinspectionstagesId: 5,
  //         uomId: 3,
  //         transDate: data.detail!.first.transDate,
  //         actualQty: data.detail!.first.actualQty.toString(),
  //         createdBy: 0,
  //         vessel: data.detail!.first.vessel,
  //         barge: dataBarge,
  //         transhipment: dataTranshipment));
  //   }
  // }

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
      return File(json['path_name']);
    }).toList();
    update();

    activity6AttachmentsStage.value = attachments;
    activity6Attachments.value = attachments;
    update();
  }

  Future<void> getJoInspectionDocuments() async {
    final data = await SqlHelper.getInspectionDocument(id);
    inspectionDocuments.value = data.map((item){
      return TDJoFinalizeInspectionModel.fromJson(item);
    }).toList();
    debugPrint('data document : ${jsonEncode(inspectionDocuments.value)}');
    final dataId = data.map((value){return value['id'];}).toList();
    final dataDocument = await SqlHelper.getInspectionDocumentFiles(dataId);
    inspectionDocumentsFiles.value = dataDocument.map((item){
      return TDJoDocumentInspection.fromJson(item);
    }).toList();
    debugPrint('data document files : ${jsonEncode(inspectionDocumentsFiles.value)}');
  }

  Future<void> getJoLaboratoryDocuments() async {
    final data = await SqlHelper.getLaboratoryDocument(id);
    laboratoryDocuments.value = data.map((item){
      return TDJoFinalizeLaboratoryModel.fromJson(item);
    }).toList();
    debugPrint('data document : ${jsonEncode(laboratoryDocuments.value)}');
    final dataId = data.map((value){return value['id'];}).toList();
    final dataDocument = await SqlHelper.getLaboratoryDocumentFiles(dataId);
    laboratoryDocumentsFiles.value = dataDocument.map((item){
      return TDJoDocumentLaboratory.fromJson(item);
    }).toList();
    debugPrint('data document files : ${jsonEncode(laboratoryDocumentsFiles.value)}');
  }

  void detailLabActivity(int? lab, String name, int joLabId) {
    Get.to(LabActivityDetailScreen(), arguments: {'id': id, 'labId': lab, 'name': name, 'joLabId' : joLabId});
  }

  // Activity Detail Functions

  void previewImage(int index, String photo, String desc, TDJoInspectionPict pict) async {
    dailyActivityPhotosDescEdit.value.text = desc;
    activityPreviewFoto.value = await File(photo);
    Get.dialog(
      StatefulBuilder(
          builder: (context, state) {
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
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.close),
                  )
                ],
              ),
              content: Obx(
                    () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom != 0 ? 66.h : 180.h,
                        width: MediaQuery.sizeOf(context).width.w,
                        child: CustomImage(path: activityPreviewFoto.value.path),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    dataJoDetail.value.detail?.statusJo == 'Assigned' ||
                        dataJoDetail.value.detail?.statusJo == 'On Progres'
                        ? SizedBox(
                      child: TextFormField(
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
                      ),
                    )
                        : Text(desc),
                  ],
                ),
              ),
              actions: [],
            );
          }
      ),
    );
  }

  void previewImage6(int index, String photo, String desc) async {
    dailyActivityPhotosDescEdit.value.text = desc;
    activityPreviewFoto.value = await File(photo);
    Get.dialog(
      GetBuilder(
        init: JoWaitingController(),
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
                  Image.file(
                    File(activityPreviewFoto.value.path),
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 16,
                  ),

                  const SizedBox(
                    height: 16,
                  ),
                  Text(desc),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void cameraImageDocument() async {
    File? image;
    try {
      final XFile? pic = await picker.pickImage(source: ImageSource.camera);
      if (pic != null) {
        final imageTemp = File(pic!.path);
        image = imageTemp;
        documentInspectionAttachments.add(image);
        update();
      }
    } on PlatformException catch (e) {
      openDialog('Failed', e.message ?? 'Gagal menambahkan file');
    }
    openDialog('Success', 'Berhasil menambahkan file.');
  }

  void fileDocument() async {
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
          documentInspectionAttachments.add(file);
          update();
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
                          cameraImageDocument();
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
                          fileDocument();
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

  // Activities Documents Functions

  Future<void> addDocuments(String type) async {
    if (documentCertificateNumber.text != '' &&
        documentCertificateDate.text != '' &&
        documentCertificateBlanko.text != '' &&
        documentCertificateLhv.text != '' &&
        documentCertificateLs.text != '' &&
        documentLaboratoryAttachments.value.isNotEmpty) {
      documentMap.value.add({
        'certNumber': certificateNumberTextController.value.text,
        'certDate': certificateDateTextController.value.text,
        'certBlanko': certificateBlankoNumberTextController.value.text,
        'certLhv': certificateLHVNumberTextController.value.text,
        'certLs': certificateLSNumberTextController.value.text,
      });
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 1));
    if (picked != null) {
      documentCertificateDate.text = DateFormat('yyyy-MM-dd').format(picked).toString();
    }
  }

  void drawerAddDocument(String type) {
    Get.bottomSheet(
      GetBuilder(
        init: JoWaitingController(),
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
                            controller: documentCertificateNumber,
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
                            controller: documentCertificateDate,
                            cursorColor: onFocusColor,
                            onTap: () {
                              selectDate(Get.context!);
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
                                labelText: 'Date Certificate/Report*',
                                floatingLabelStyle:
                                const TextStyle(color: onFocusColor),
                                fillColor: onFocusColor),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: documentCertificateBlanko,
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
                            controller: documentCertificateLhv,
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
                            controller: documentCertificateLs,
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
                          documentInspectionAttachments.value.isNotEmpty
                              ? GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                              ),
                              itemCount: documentInspectionAttachments.value.length,
                              itemBuilder: (content, index) {
                                final File photo =
                                documentInspectionAttachments.value[index];
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
                                      previewImage6(
                                          index, photo.path, '');
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
              Get.back();
              Get.back();
              //await addDocuments(type);
              Get.to<void>(() => const DocumentsScreen(),arguments: {
                'type' : type,
              });
            },
          ),
        ],
      ),
    );
  }

  void previewImageList(int index, String photo) {
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
}
