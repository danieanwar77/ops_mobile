import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity6.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity_lab.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity_lab5.dart';
import 'package:ops_mobile/data/model/response_jo_insert_activity5.dart';
import 'package:ops_mobile/data/model/response_jo_insert_activity5_lab.dart';
import 'package:ops_mobile/data/model/response_jo_insert_activity_lab.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory_activity.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory_activity_stages.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory_attachment.dart';
import 'package:ops_mobile/data/model/t_h_jo.dart';
import 'package:ops_mobile/data/sqlite.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:ops_mobile/utils/helper.dart';

import 'package:ops_mobile/data/model/login_data_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class LabActivityDetailController extends BaseController{

  // Data User
  Rx<Data?> userData = Rx(Data());

  // Settings
  late int id;
  RxInt statusId = 0.obs;
  late int labId;
  late int joLabId;
  String labName = '';
  final picker = ImagePicker();
  bool isLoading = false;
  int activityLabStage = 1;
  List<String> labStagesName = ['Sample on Delivery', 'Sample Received', 'Preparation for Analyze', 'Analyze on Progress', 'Issued Analyzed Result', 'Report to Client'];
  RxString prelim = ''.obs;
  RxInt tat = 0.obs;
  RxBool activitySubmitted = RxBool(false);
  final _formKey = GlobalKey<FormState>();

  // Detail Data
  RxList<DataActivityLab> dataListActivityLab = RxList();
  RxList<DataActivityLab5> dataListActivityLab5 = RxList();
  RxList<File> dailyActivityLabPhotos = RxList();
  RxInt adddailyActivityLabPhotosCount = 0.obs;

  // Activity Lab Variables & Temporary
  RxList<TDJoLaboratoryActivityStages> activityLabList = RxList();
  RxList<TDJoLaboratoryActivityStages> activityLabListStages = RxList();
  TextEditingController activityDate = TextEditingController();
  TextEditingController activityStartTime = TextEditingController();
  TextEditingController activityEndTime = TextEditingController();
  TextEditingController activityText = TextEditingController();
  TextEditingController activityRemarks = TextEditingController();
  RxBool editActivityMode = false.obs;
  RxInt editActivityIndex = 0.obs;

  // Activity 5 Lab Variables & Temporary
  RxList<TDJoLaboratoryActivityStages> activity5LabList = RxList();
  RxList<TDJoLaboratoryActivityStages> activity5LabListStages = RxList();
  RxList<TextEditingController> activityLabListTextController = RxList();
  TextEditingController sampleReceived = TextEditingController();
  TextEditingController samplePreparation = TextEditingController();
  TextEditingController sampleAnalyzed = TextEditingController();

  // Activity 6 Lab Variables & Temporary
  Rx<DataListActivity6> dataListActivity6 = Rx(DataListActivity6());
  Rx<Activity6Attachments> dataListActivity6Attachments = Rx(Activity6Attachments());

  // Activity 6 Lab Variables & Temporary
  RxList<TDJoLaboratoryActivityStages> activity6List = RxList();
  RxList<TDJoLaboratoryActivityStages> activity6ListStages = RxList();
  RxList<TextEditingController> activity6ListTextController = RxList();
  Rx<TextEditingController> certificateNumberTextController = TextEditingController().obs;
  Rx<TextEditingController> certificateDateTextController = TextEditingController().obs;
  Rx<TextEditingController> certificateBlankoNumberTextController = TextEditingController().obs;
  Rx<TextEditingController> certificateLHVNumberTextController = TextEditingController().obs;
  Rx<TextEditingController> certificateLSNumberTextController = TextEditingController().obs;

  // Activity 6 Lab Variables & Temporary
  TextEditingController activity6Date = TextEditingController();
  TextEditingController activity6StartTime = TextEditingController();
  TextEditingController activity6EndTime = TextEditingController();
  TextEditingController activity6Text = TextEditingController();
  TextEditingController activity6Remarks = TextEditingController();
  RxList<TDJoLaboratoryAttachment> activity6Attachments = RxList();
  RxList<TDJoLaboratoryAttachment> activity6AttachmentsStage = RxList();

  Rx<THJo> joRx = THJo().obs;

  final ScrollController scrollController = ScrollController();

  Future<void> scrollToBottom() async {
    await Future.delayed(Duration(milliseconds: 100));
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
      debugPrint('print data scroll bottom');
    }
    debugPrint('print data scroll bottom no has clients');
  }

  @override
  void onInit() async {
    debugPrint('print data previous page ${Get.previousRoute}');
    var dataUser = jsonDecode(await StorageCore().storage.read('user'));
    userData.value = Data(
        id: dataUser.first['id'],
        fullname: dataUser.first['fullname'],
        nip: dataUser.first['e_number'],
        positionId: dataUser.first['jabatan_id'],
        position: dataUser.first['jabatan'],
        divisionId: dataUser.first['division_id'],
        division: dataUser.first['division'].toString(),
        superior: dataUser.first['superior_id'].toString());
    var argument = await Get.arguments;
    id = argument['id'];
    labId = argument['labId'];
    labName = argument['name'];
    joLabId = argument['joLabId'];
    debugPrint('arguments lab: 12 id = $id, labId = $labId, joLabId = $joLabId, statusJo = ${statusId}');
    isLoading = true;
    update();
    await getData();
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

  Future<void> getData() async{

    debugPrint('params: $id,${userData.value!.id!.toInt()}, $labId');
    THJo thJo = await THJo.getJoById(id);
    //try{
      activityLabListStages.value.clear();
      activity5LabListStages.value.clear();
      activity6ListStages.value.clear();
      activitySubmitted.value = false;
      activityLabStage = 1;
      var response = await SqlHelper.getDetailActivityLaboratory(id,userData.value!.id!.toInt(), labId);
      var text = '';
      var joGroup = groupBy(response, (item) => item['id']);
      joGroup.forEach((key,jo){
        var transactionDateTime = jo.first['stage_created_at'];
        var statusJo = jo.first['status_jo'];
        statusId.value = statusJo;
        update();
        var typeGroup = groupBy(jo, (item) => item['jo_type']);
        typeGroup.forEach((typeKey,joType){
          debugPrint('type jo nya: ${typeKey}');
          var statusGroup = groupBy(joType, (item) => item['status_type']);
          if(typeKey == 'laboratory'){
            statusGroup.forEach((statusKey,status){
              debugPrint("status nya: ${statusKey}");
              var labGroup = groupBy(status, (item) => item['laboratorium_id']);
              labGroup.forEach((labKey,labItem){
                debugPrint("lab item length: ${labItem.length}");
                activityLabStage = 1;
                update();
                debugPrint("lab nya: $labKey");
                if(labKey != null){
                  var stageGroup = groupBy(labItem, (item) => item['stage_id']);

                  stageGroup.forEach((stageKey, stage){
                    var laboratory = {};
                    debugPrint("stage nya: ${stageKey}");

                    if(stageKey != null){
                      activitySubmitted.value = true;
                      Map<String, dynamic> stageHead = {
                        'id' : 0,
                        'd_jo_laboratory_id' : 0,
                        't_h_jo_id' : 0,
                        'm_statuslaboratoryprogres_id' : 0,
                        'trans_date' : '',
                        'remarks' : '',
                        'created_by' : 0,
                        'updated_by' : 0,
                        'created_at' : '',
                        'updated_at' : '',
                        'total_sample_received' : 0,
                        'total_sample_analyzed' : 0,
                        'total_sample_preparation' : 0,
                        'code' : '',
                        'is_active' : 0,
                        'is_upload' : 0,
                      };
                      List<TDJoLaboratoryActivity> activityItems = [];
                      // IssuedAnalyzedResult issuedAnalyzedResult = IssuedAnalyzedResult();
                      List<TDJoLaboratoryAttachment> attachments = [];

                      stage.forEach((stageItem){
                        activityLabStage = stageItem['progress_id'];
                        if(stageHead['id'] != stageItem['stage_id']){
                          stageHead = {
                            'id' : stageItem['stage_id'],
                            'd_jo_laboratory_id' : stageItem['jo_laboratory_id'],
                            't_h_jo_id' : stageItem['id'],
                            'm_statuslaboratoryprogres_id' : stageItem['progress_id'],
                            'trans_date' : stageItem['trans_date'],
                            'remarks' : stageItem['remarks'],
                            'created_by' : stageItem['stage_created_by'],
                            'updated_by' : stageItem['stage_updated_by'],
                            'created_at' : stageItem['stage_created_at'],
                            'updated_at' : stageItem['stage_updated_at'],
                            'total_sample_received' : stageItem['total_sample_received'],
                            'total_sample_analyzed' : stageItem['total_sample_analyzed'],
                            'total_sample_preparation' : stageItem['total_sample_preparation'],
                            'code' : stageItem['stage_code'],
                            'is_active' : stageItem['stage_is_active'],
                            'is_upload' : stageItem['stage_is_upload']
                          };
                          update();
                        }
                        if (stageItem['progress_id'] == 5){
                          activityItems.add(TDJoLaboratoryActivity.fromJson({
                            "id": stageItem['activity_id'],
                            "t_d_jo_laboratory_activity_stages_id": stageItem['stage_id'],
                            "t_d_jo_laboratory_id": stageItem['jo_laboratory_id'],
                            "start_activity_time": Helper.formatToHourMinute(stageItem['start_activity_time']),
                            "end_activity_time": Helper.formatToHourMinute(stageItem['end_activity_time']),
                            "activity": stageItem['activity'],
                            "code": stageItem['activity_code'],
                            "is_active": stageItem['activity_is_active'],
                            "is_upload": stageItem['activity_is_upload'],
                            "created_by": stageItem['activity_created_by'],
                            "updated_by": stageItem['activity_updated_by'],
                            "created_at": stageItem['activity_created_at'],
                            "updated_at": stageItem['activity_updated_at']
                          }));
                          update();
                          final finish = stageItem['activity_created_at'] ?? '';
                          final initial = status.where((item) => item['progress_id'] == 1).toList().first['activity_created_at'] ?? '';
                          //disabled
                           debugPrint('first date : ${initial}, last date : ${finish}');
                           DateTime first = DateTime.parse(initial);
                           DateTime last = DateTime.parse(finish);
                          Duration difference = last.difference(first);
                          double hoursDifference = difference.inMinutes / 60;
                           prelim.value = initial.split(' ').first;
                           tat.value = hoursDifference.toInt();
                          // update();
                        }
                        if (stageItem['progress_id'] == 6) {
                          debugPrint('print stageItem 6 activity ${stageItem['activity']}');
                          if ((stageItem['activity'] != null || stageItem['activity'] != '') && activityItems.where((item) => item.code == stageItem['activity_code']).isEmpty) {
                            activityItems.add(TDJoLaboratoryActivity.fromJson({
                              "id": stageItem['activity_id'],
                              "t_d_jo_laboratory_activity_stages_id": stageItem['stage_id'],
                              "t_d_jo_laboratory_id": stageItem['jo_laboratory_id'],
                              "start_activity_time": Helper.formatToHourMinute(stageItem['start_activity_time'] ?? ''),
                              "end_activity_time": Helper.formatToHourMinute(stageItem['end_activity_time'] ?? ''),
                              "activity": stageItem['activity'],
                              "code": stageItem['activity_code'],
                              "is_active": stageItem['activity_is_active'],
                              "is_upload": stageItem['activity_is_upload'],
                              "created_by": stageItem['activity_created_by'],
                              "updated_by": stageItem['activity_updated_by'],
                              "created_at": stageItem['activity_created_at'],
                              "updated_at": stageItem['activity_updated_at']
                            }));
                            update();
                          }
                          if ((stageItem['path_name'] != null && stageItem['path_name'] != '') && attachments.where((item) => item.id == stageItem['attachment_id']).isEmpty) {
                            attachments.add(TDJoLaboratoryAttachment.fromJson({
                              "id": stageItem['attachment_id'],
                              "t_d_jo_laboratory_id": stageItem['jo_laboratory_id'],
                              "m_statuslaboratoryprogres_id": stageItem['progress_id'],
                              "path_name": stageItem['path_name'],
                              "file_name": stageItem['file_name'],
                              "code": stageItem['attachment_code'],
                              "is_active": stageItem['attachment_is_active'],
                              "is_upload": stageItem['attachment_is_upload'],
                              "created_by": stageItem['attachment_created_by'],
                              "updated_by": stageItem['attachment_updated_by'],
                              "created_at": stageItem['attachment_created_at'],
                              "updated_at": stageItem['attachment_updated_at']
                            }));
                            update();
                          }
                        } else {
                          if ((stageItem['activity_code'] != null && stageItem['activity_code'] != '') && activityItems.where((item) => item.code == stageItem['activity_code']).isEmpty){
                            activityItems.add(TDJoLaboratoryActivity.fromJson({
                              "id": stageItem['activity_id'],
                              "t_d_jo_laboratory_activity_stages_id": stageItem['stage_id'],
                              "t_d_jo_laboratory_id": stageItem['jo_laboratory_id'],
                              "start_activity_time": stageItem['start_activity_time'],
                              "end_activity_time": stageItem['end_activity_time'],
                              "activity": stageItem['activity'],
                              "code": stageItem['activity_code'],
                              "is_active": stageItem['activity_is_active'],
                              "is_upload": stageItem['activity_is_upload'],
                              "created_by": stageItem['activity_created_by'],
                              "updated_by": stageItem['activity_updated_by'],
                              "created_at": stageItem['activity_created_at'],
                              "updated_at": stageItem['activity_updated_at']
                            }));
                            update();
                          }
                        }
                      });

                      if(stageHead['m_statuslaboratoryprogres_id'] < 5){
                        activityLabListStages.value.add(TDJoLaboratoryActivityStages(
                            id : stageHead['id'],
                            dJoLaboratoryId : stageHead['d_jo_laboratory_id'],
                            tHJoId : stageHead['id'],
                            mStatuslaboratoryprogresId : stageHead['m_statuslaboratoryprogres_id'],
                            transDate : stageHead['trans_date'],
                            remarks : stageHead['remarks'],
                            createdBy : stageHead['created_by'],
                            updatedBy : stageHead['updated_by'] is String ? stageHead['updated_by'] : stageHead['updated_by'].toString(),
                            createdAt : stageHead['created_at'],
                            updatedAt : stageHead['updated_at'],
                            //totalSampleReceived : stageHead['total_sample_received'],
                            //totalSampleAnalyzed : stageHead['total_sample_analyzed'],
                            //totalSamplePreparation : stageHead['total_sample_preparation'],
                            code : stageHead['code'],
                            isActive : stageHead['is_active'],
                            isUpload : stageHead['is_upload'],
                            listLabActivity: activityItems,
                            listLabAttachment: attachments
                        )
                        );
                        debugPrint('print data laboratory activity ${jsonEncode(activityItems)}');
                      } else if(stageHead['m_statuslaboratoryprogres_id'] == 5) {
                        activity5LabListStages.value.add(TDJoLaboratoryActivityStages(
                            id : stageHead['id'],
                            dJoLaboratoryId : stageHead['d_jo_laboratory_id'],
                            tHJoId : stageHead['id'],
                            mStatuslaboratoryprogresId : stageHead['m_statuslaboratoryprogres_id'],
                            transDate : stageHead['trans_date'],
                            remarks : stageHead['remarks'],
                            createdBy : stageHead['created_by'],
                            updatedBy : stageHead['updated_by'],
                            createdAt : stageHead['created_at'],
                            updatedAt : stageHead['updated_at'],
                            totalSampleReceived : stageHead['total_sample_received'].toInt(),
                            totalSampleAnalyzed : stageHead['total_sample_analyzed'].toInt(),
                            totalSamplePreparation : stageHead['total_sample_preparation'].toInt(),
                            code : stageHead['code'],
                            isActive : stageHead['is_active'],
                            isUpload : stageHead['is_upload'],
                            listLabActivity: activityItems,
                            listLabAttachment: attachments
                        )
                        );
//                        debugPrint('isian laboratory activity 5: ${jsonEncode(activity5LabListStages.value.last)}');
                      } else if(stageHead['m_statuslaboratoryprogres_id'] == 6) {
                        activity6ListStages.value.add(TDJoLaboratoryActivityStages(
                            id : stageHead['id'],
                            dJoLaboratoryId : stageHead['d_jo_laboratory_id'],
                            tHJoId : stageHead['id'],
                            mStatuslaboratoryprogresId : stageHead['m_statuslaboratoryprogres_id'],
                            transDate : stageHead['trans_date'],
                            remarks : stageHead['remarks'],
                            createdBy : stageHead['created_by'],
                            updatedBy : stageHead['updated_by'],
                            createdAt : stageHead['created_at'],
                            updatedAt : stageHead['updated_at'],
                            // totalSampleReceived : stageHead['total_sample_received'],
                            // totalSampleAnalyzed : stageHead['total_sample_analyzed'],
                            // totalSamplePreparation : stageHead['total_sample_preparation'],
                            code : stageHead['code'],
                            isActive : stageHead['is_active'],
                            isUpload : stageHead['is_upload'],
                            listLabActivity: activityItems,
                            listLabAttachment: attachments
                        )
                        );
                        activity6AttachmentsStage.value = attachments;
                        debugPrint('isian laboratory activity 6: ${jsonEncode(activity6ListStages.value.last)}');
                      }
                    }
                  });
                }
              });

            });
          }

        });
      });
      if(thJo.id != null){
        joRx.value = thJo;
        debugPrint('print data  jo ${joRx.value.toJson()}');
      }
    // } catch(e){
    //   debugPrint('error get data: $e');
    // } finally {
      update();
    // }

  }

  // Settings

  void countPrelimTat(){

    final finish = activity5LabList.value.first.listLabActivity!.first!.createdAt;
    final initial = activityLabListStages.value.where((item) => item.mStatuslaboratoryprogresId == 1).first.createdAt;
    // DateTime first = DateTime.parse(initial!);
    // DateTime last = DateTime.parse(finish!);
    // prelim.value = initial.split(' ').first;
    // tat.value = getDiffHours(first,last);
  }

  int getDiffHours(DateTime start, DateTime end) {

    Duration diff = end.difference(start);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    return hours;
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

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
    File image;
    try {
      final pic = await picker.pickImage(source: ImageSource.gallery);
      final imageTemp = File(pic!.path);
      image = imageTemp;
      return image;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

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

  // Activity Lab Photo Functions

  void adddailyActivityLabPhotos(File foto){
    dailyActivityLabPhotos.value.add(foto);
  }

  void removePhotoActivity(){
    dailyActivityLabPhotos.value.removeLast();
    adddailyActivityLabPhotosCount.value--;
    update();
  }

  // Activity Lab Functions

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
      initialEntryMode: TimePickerEntryMode.dialOnly,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Localizations.override(
            context: context,
            locale: const Locale('en', 'GB'),
            child: child,
          ),
        );
      },
    );
    if (picked != null) {
      debugPrint('print data picked time ${picked.format(context)}');
      List timeSplit = picked.format(context).split(' ');
      String formattedTime = timeSplit[0];
      String time = '$formattedTime';
      return time;
    } else {
      return '';
    }
  }

  // > Add Functions

  void addActivity(){
    if(activityLabList.value.isEmpty){
      activityLabListTextController.value.add(TextEditingController());
      activityLabList.value.add(TDJoLaboratoryActivityStages(
          tHJoId: id,
          dJoLaboratoryId: joLabId,
          mStatuslaboratoryprogresId: activityLabStage,
          transDate: activityDate.text,
          isActive: 1,
          createdBy: userData.value?.id ?? 0,
          createdAt: DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(DateTime.now())
              .toString(),
          listLabActivity: [TDJoLaboratoryActivity(
            startActivityTime: activityStartTime.text,
            endActivityTime: activityEndTime.text,
            activity: activityText.text,
            isActive: 1,
            createdBy: userData.value?.id ?? 0,
            createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(
                DateTime.now()).toString(),
          )
          ]
      ));
    } else {
      if (activityLabList.value
          .where((item) => item.transDate == activityDate.text)
          .isEmpty) {
        activityLabListTextController.value.add(TextEditingController());
        activityLabList.value.add(TDJoLaboratoryActivityStages(
            tHJoId: id,
            dJoLaboratoryId: joLabId,
            mStatuslaboratoryprogresId: activityLabStage,
            transDate: activityDate.text,
            isActive: 1,
            createdBy: userData.value?.id ?? 0,
            createdAt: DateFormat('yyyy-MM-dd HH:mm:ss')
                .format(DateTime.now())
                .toString(),
            listLabActivity: [TDJoLaboratoryActivity(
              startActivityTime: activityStartTime.text,
              endActivityTime: activityEndTime.text,
              activity: activityText.text,
              isActive: 1,
              createdBy: userData.value?.id ?? 0,
              createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(
                  DateTime.now()).toString(),
            )
            ]
        ));
      } else {
        var stageIndex = activityLabList.value.indexWhere((item) =>
        item.transDate == activityDate.text && item.isActive == 1);
        activityLabList.value[stageIndex].listLabActivity!.add(
            TDJoLaboratoryActivity(
              startActivityTime: activityStartTime.text,
              endActivityTime: activityEndTime.text,
              activity: activityText.text,
              isActive: 1,
              createdBy: userData.value?.id ?? 0,
              createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(
                  DateTime.now()).toString(),
            ));
      }
    }

    activityDate.text = '';
    activityStartTime.text = '';
    activityEndTime.text = '';
    activityText.text = '';
    update();

    debugPrint('activities: ${jsonEncode(activityLabList)}');
  }

  void toggleEditActivity(int index, int itemIndex){
    activityDate.text = activityLabList.value[index].transDate!;
    activityStartTime.text = activityLabList.value[index].listLabActivity![itemIndex].startActivityTime!;
    activityEndTime.text = activityLabList.value[index].listLabActivity![itemIndex].endActivityTime!;
    activityText.text = activityLabList.value[index].listLabActivity![itemIndex].activity!;
    editActivityMode.value = true;
    editActivityIndex.value = itemIndex;
    update();
  }

  void editActivity(int itemIndex){
    var stageIndex = activityLabList.value.indexWhere((item) => item.transDate == activityDate.text);
    TDJoLaboratoryActivity oldData = activityLabList.value[stageIndex].listLabActivity![itemIndex];

    activityLabList.value[stageIndex].listLabActivity![itemIndex] = oldData.copyWith(
        startActivityTime: activityStartTime.text,
        endActivityTime: activityEndTime.text,
        activity: activityText.text,
        isActive: 1,
        updatedBy: userData.value?.id ?? 0,
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(
            DateTime.now()).toString(),
    );
    editActivityMode.value = false;
    activityDate.text = '';
    activityStartTime.text = '';
    activityEndTime.text = '';
    activityText.text = '';
    update();
  }

  void editActivityRemarks(String date, String val, int index){
    final TextEditingController remarksController = activityLabListTextController[index];
    debugPrint('text controller value : ${remarksController.text}');
    var stageIndex = activityLabList.value.indexWhere((item) => item.transDate == date);
    TDJoLaboratoryActivityStages stage = activityLabList.value[stageIndex]; // ambil data lama
    //activityLabList.value[stageIndex].remarks = remarksController.text;
    activityLabList.value[stageIndex] = TDJoLaboratoryActivityStages(
      id : stage.id,
      dJoLaboratoryId : stage.dJoLaboratoryId,
      tHJoId : stage.tHJoId,
      mStatuslaboratoryprogresId : stage.mStatuslaboratoryprogresId,
      transDate : stage.transDate,
      remarks : remarksController.text,
      createdBy : stage.createdBy,
      updatedBy : stage.updatedBy,
      createdAt : stage.createdAt,
      updatedAt : stage.updatedAt,
      totalSampleReceived : stage.totalSampleReceived,
      totalSampleAnalyzed : stage.totalSampleAnalyzed,
      totalSamplePreparation : stage.totalSamplePreparation,
      code : stage.code,
      isActive : 1,
      isUpload : 0,
      listLabActivity: stage.listLabActivity,
      listLabAttachment: stage.listLabAttachment,
    );
  }

  void checkActivityList(){
    debugPrint('activities now: ${jsonEncode(activityLabList.value)}');
  }

  Future<void> removeActivity(int index, int indexitem, int stage)async{

    var stageItem = activityLabList.value[index].listLabActivity![indexitem];
    activityLabList.value[index].listLabActivity!.removeAt(indexitem);

    // if(activityLabList.value[index].listLabActivity!.isEmpty){
    //   activityLabListTextController.value.removeAt(index);
    //   activityLabList.value.removeAt(index);
    // }


    update();
  }

  Future<void> removeActivityByDate(String date, int indexDate, int stageProgress)async{
    var stage = activityLabList.value.where((item) => item.transDate == date && item.mStatuslaboratoryprogresId == activityLabStage).first;
    var indexStage = activityLabList.value.indexWhere((item) => item.transDate == date && item.mStatuslaboratoryprogresId == activityLabStage);
    activityLabList.value.removeAt(indexStage);
    activityLabListTextController.value.removeAt(indexStage);
    update();
  }

  //Function untuk menyimpan stage dan activity ke sqlite
  Future<String?> saveActivityStage() async {
    try {
      final db =  await SqlHelper.db();
      final createdBy = userData.value!.id;

      List<TDJoLaboratoryActivityStages> copiedList = List.from(activityLabList.value);
      List<TDJoLaboratoryActivityStages> dataActStage = copiedList.where((data) => data.mStatuslaboratoryprogresId == activityLabStage).toList();

      for(int i = 0 ; i < dataActStage.length; i++){
        debugPrint('json activity stage ${jsonEncode(dataActStage[i].toJson())}');
        TDJoLaboratoryActivityStages dataStage = dataActStage[i].copyWith(
            createdBy: createdBy,
            isUpload: 0,
            code: "JOLAS-${activityLabStage == 0 ? 1 : activityLabStage}-${createdBy}-${Helper.generateUniqueCode()}-${i}"
        );
        int result = await db.insert("t_d_jo_laboratory_activity_stages",dataStage.toInsert());
        List<TDJoLaboratoryActivity> actStage = dataStage.listLabActivity ?? [];
        for(int j = 0; j < actStage.length; j++){
          TDJoLaboratoryActivity dataAct = actStage[j].copyWith(
              tDJoLaboratoryActivityStagesId: result,
              tDJoLaboratoryId: dataStage.dJoLaboratoryId,
              createdBy: createdBy,
              isUpload: 0,
              code: "JOLA-${activityLabStage == 0 ? 1 : activityLabStage}-${createdBy}-${Helper.generateUniqueCode()}-${j}"
          );
          int rsltAct = await db.insert("t_d_jo_laboratory_activity",dataAct.toInsert());
        }
      }
      clearActivityLabForm();
      await changeStatusJoLocal();
      return 'success';
    }catch(e){
      debugPrint("error insert activity lab ${e}");
      return 'failed';
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
      debugPrint('print id jo yang diupdate $id');
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      update();
    }
  }

  void drawerDailyActivityLab(){
    activityLabListTextController.value= [];
    activityLabList.value = [];
    Get.bottomSheet(
        GetBuilder(
          init: LabActivityDetailController(),
          builder: (controller) => Container(
              margin: EdgeInsets.only(top: 48),
              padding: EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))
              ),
              child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Add Stage Laboratory',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: primaryColor
                            ),
                          ),
                          const SizedBox(height: 16,),
                          Text('Stage ${activityLabStage}: ${labStagesName[activityLabStage-1]}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                          const SizedBox(height: 16,),
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
                                  onTap: (){
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
                                          onPressed: (){
                                            selectDate(Get.context!);
                                          },
                                          icon: const Icon(Icons.calendar_today_rounded)
                                      ),
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
                                const SizedBox(height: 16,),
                                Text('Detail Activities'),
                                const SizedBox(height: 16,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: activityStartTime,
                                        cursorColor: onFocusColor,
                                        readOnly: true,
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
                                              borderSide:
                                              const BorderSide(color: onFocusColor),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            labelText: 'Start Time*',
                                            floatingLabelStyle:
                                            const TextStyle(color: onFocusColor),
                                            fillColor: onFocusColor),
                                      ),
                                    ),
                                    const SizedBox(width: 8,),
                                    Expanded(
                                      child: TextFormField(
                                        controller: activityEndTime,
                                        cursorColor: onFocusColor,
                                        readOnly: true,
                                        onTap: () async {
                                          activityEndTime.text = await selectTime(Get.context!);
                                        },
                                        // validator: (value) {
                                        //   if (value == null || value.isEmpty) {
                                        //     return 'Field wajib diisi!';
                                        //   }
                                        //   return null;
                                        // },
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
                                            labelText: 'End Time',
                                            floatingLabelStyle:
                                            const TextStyle(color: onFocusColor),
                                            fillColor: onFocusColor),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16,),
                                TextFormField(
                                  controller: activityText,
                                  cursorColor: onFocusColor,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(150),
                                  ],
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
                              ],
                            ),
                          ),
                          const SizedBox(height: 16,),
                          InkWell(
                            onTap: (){
                              if (_formKey.currentState!.validate()) {
                                if(editActivityMode.value == false){
                                  addActivity();
                                } else {
                                  editActivity(editActivityIndex.value);
                                }
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 8),
                              height: 42,
                              width: 42,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(8)
                              ),
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
                          const SizedBox(height: 16,),
                          activityLabList.value.isNotEmpty ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: activityLabList.value.map((item){return item.transDate;}).toSet().toList().length,
                              itemBuilder: (context, index) {
                                var date = activityLabList.value.map((item){return item.transDate;}).toSet().toList()[index];
                                var activity = activityLabList.value[index];
                                return Column(
                                  children: [
                                    Card(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 8,
                                          bottom: 16
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text('Date',
                                                    style: TextStyle(
                                                      fontSize: 11.sp,
                                                      fontWeight: FontWeight.w700
                                                    ),
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
                                                        date ?? '-',
                                                        style: TextStyle(
                                                          fontSize: 11.sp,
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                        onTap:
                                                            () {
                                                          removeActivityByDateConfirm(date!, index, activityLabStage);
                                                        },
                                                        child: const ImageIcon(
                                                            AssetImage("assets/icons/deleteStage.png"),
                                                            color: Colors.red,
                                                            size: 18
                                                        ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'Activities',
                                                    style: TextStyle(
                                                        fontSize: 11.sp,
                                                        fontWeight:
                                                        FontWeight
                                                            .w700),
                                                  ),
                                                ),
                                                VerticalDivider(width: 1),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  flex: 3,
                                                    child: Column(
                                                      children: [
                                                        ListView.builder(
                                                            shrinkWrap: true,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            itemCount: activity.listLabActivity?.length,
                                                            itemBuilder: (context, indexItem){
                                                              if(activityLabList.value[index].transDate == date){
                                                                var activityItem = activity.listLabActivity![indexItem];
                                                                return Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        '${activityItem.startActivityTime ?? '-'} - ${activityItem.endActivityTime ?? '-'}',
                                                                        style: TextStyle(
                                                                            fontSize: 10.sp,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 8),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: Text(
                                                                              activityItem.activity ?? '-',
                                                                              style: TextStyle(
                                                                                fontSize: 11.sp,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                              onTap: () {
                                                                                toggleEditActivity(index, indexItem);
                                                                              },
                                                                              child: ImageIcon(
                                                                                  AssetImage("assets/icons/editActivity.png"),
                                                                                  color: primaryColor,
                                                                                  size: 12.h
                                                                              ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width: 6,
                                                                          ),
                                                                          SizedBox(
                                                                            height: 12.h,
                                                                            width: 12.h,
                                                                            child: Ink(
                                                                              decoration: ShapeDecoration(
                                                                                  color: Colors.red,
                                                                                  shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(4.w)
                                                                                  )
                                                                              ),
                                                                              child: InkWell(
                                                                                  onTap: () {
                                                                                    removeActivityConfirm("${activityItem.startActivityTime} - ${activityItem.endActivityTime}", indexItem, index, activityLabStage); //check tambahkan activity yang mau dihapus
                                                                                  },
                                                                                  child: Icon(
                                                                                      Icons.remove,
                                                                                      color: Colors.white,
                                                                                      size: 10.h
                                                                                  )
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                );
                                                              } else {
                                                                return const SizedBox();
                                                              }
                                                            })
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
                                            controller: activityLabListTextController[index],
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  250),
                                            ],
                                            onChanged: (value){
                                              editActivityRemarks(date!, value, index);
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
                              }) : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () async {
                              clearActivityLabForm();
                              Get.back();
                              await getData();
                              await scrollToBottom();
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
                                    )
                                )
                            )
                        ),
                      ),
                      const SizedBox(width: 16,),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              addActivityLabStageConfirm();
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
                                    )
                                )
                            )
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16,),
                ],
              ),
              )
          ),
        ),
        isScrollControlled: true
    );
  }

  void clearActivityLabForm(){
    activityLabList.value = [];
    activityLabListTextController.value = [];
    editActivityMode.value = false;
    activityDate.text = '';
    activityStartTime.text = '';
    activityEndTime.text = '';
    activityText.text = '';
    activitySubmitted.value = true;
    update();
  }

  void addActivityLabStageConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text('Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
          ),
        ),
        content: Text('Apakah benar anda akan submit stage ${labStagesName[activityLabStage - 1]} ini? pastikan data yg anda input benar.'),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text("OK",
              style: TextStyle(
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              var result = await saveActivityStage();
              if(result == 'success'){
                Get.back();
                Get.back();
                await getData();
                await scrollToBottom();
              } else {
                Get.back();
                openDialog("Failed", "Activity Stage $activityLabStage masih kosong atau belum diinput");
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
        content: Text('Apakah anda ingin menghapus activity time $date?'),
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
              await removeActivity(index, indexitem, stage);//check tambahkan activity yang dihapus
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
        content: Text('Apakah anda ingin menghapus activity date $date?'),
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
              await removeActivityByDate(date, indexDate, stage);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  // > Update Functions
  Future<String> updateActivityLab() async {
    try {
      // Your logic here
      final createdBy = userData.value!.id;
      final db = await SqlHelper.db();

      List<TDJoLaboratoryActivityStages> copiedList = List.from(activityLabList.value);
      List<TDJoLaboratoryActivityStages> dataActStage = copiedList.where((data) => data.mStatuslaboratoryprogresId == activityLabStage).toList();
      await db.update("t_d_jo_laboratory_activity_stages",{"is_active" : 0,'is_upload': 0},where: "d_jo_laboratory_id = ? and m_statuslaboratoryprogres_id=?", whereArgs: [joLabId,activityLabStage]);
      for(int i = 0; i < dataActStage.length; i++){
        TDJoLaboratoryActivityStages dataStage = dataActStage[i];
        if(dataStage.id == null){
          TDJoLaboratoryActivityStages dataStage = dataActStage[i].copyWith(
              createdBy: createdBy,
              isUpload: 0,
              code: "JOLAS-${activityLabStage == 0 ? 1 : activityLabStage}-${createdBy}-${Helper.generateUniqueCode()}-${i}"
          );

          int result = await db.insert("t_d_jo_laboratory_activity_stages",dataStage.toInsert());

          List<TDJoLaboratoryActivity> actStage = dataStage.listLabActivity ?? [];
          for(int j = 0; j < actStage.length; j++) {
            TDJoLaboratoryActivity dataAct = actStage[j].copyWith(
                tDJoLaboratoryActivityStagesId: result,
                tDJoLaboratoryId: dataStage.dJoLaboratoryId,
                createdBy: createdBy,
                isUpload: 0,
                code: "JOLA-${activityLabStage == 0 ? 1 : activityLabStage}-${createdBy}-${Helper.generateUniqueCode()}-${j}"
            );
            int rsltAct = await db.insert("t_d_jo_laboratory_activity", dataAct.toInsert());
          }
        }else{
          TDJoLaboratoryActivityStages dataStage = dataActStage[i].copyWith(
            dJoLaboratoryId: joLabId,
            updatedBy: createdBy.toString(),
            updatedAt: DateTime.now().toString(),
            isUpload: 0,
            isActive: 1, //check lagi perlu gak
          );

          //update t_d_jo_laboratory_activity_stages menjadi is_active  = 0 berdasarkan tDJoLaboratoryActivityStagesId

          await db.update("t_d_jo_laboratory_activity_stages",dataStage.toEdit(),where: "id=?",whereArgs: [dataStage.id]);
          await db.update("t_d_jo_laboratory_activity",{"is_active" : 0,'is_upload': 0},where: "t_d_jo_laboratory_activity_stages_id = ?", whereArgs: [dataStage.id]);
          List<TDJoLaboratoryActivity> actStage = dataStage.listLabActivity ?? [];
          for(int j = 0; j < actStage.length; j++) {
            debugPrint("data print actiivty stage ${jsonEncode(actStage[j])}");
            if(actStage[j].id ==null){
              TDJoLaboratoryActivity dataAct = actStage[j].copyWith(
                  tDJoLaboratoryActivityStagesId: dataStage.id,
                  tDJoLaboratoryId: dataStage.dJoLaboratoryId,
                  createdBy: createdBy,
                  isUpload: 0,
                  code: "JOLA-${activityLabStage == 0 ? 1 : activityLabStage}-${createdBy}-${Helper.generateUniqueCode()}-${j}"
              );
              int rsltAct = await db.insert("t_d_jo_laboratory_activity", dataAct.toInsert());
            }else{
              TDJoLaboratoryActivity dataAct = actStage[j].copyWith(
                tDJoLaboratoryActivityStagesId: dataStage.id,
                tDJoLaboratoryId: dataStage.dJoLaboratoryId,
                updatedBy: createdBy,
                updatedAt: DateTime.now().toString(),
                isUpload: 0,
              );
              int rsltAct = await db.update("t_d_jo_laboratory_activity", dataAct.toEdit(),whereArgs: [dataAct.id],where: "id=?");
            }
          }
        }
      }
      debugPrint('activity lab saat ini : ${activityLabStage}');
      clearActivityLabForm();
      return 'success';
    } catch (e) {
      debugPrint("print error insert ${e}");
      return 'failed';
    }
  }

  Future<void> updateInsertActivityLab(data) async {
    var response = await repository.insertActivityLab(data) ?? ResponseJoInsertActivityLab();
    debugPrint('insert activity Lab response: ${jsonEncode(response.message)}');
  }

  void drawerDailyActivityLabEdit(){
    //ambil list activity stage yang mau diedit
    activityLabList.value = activityLabListStages.value.where((item) => item.mStatuslaboratoryprogresId == activityLabStage).toList();
    activityLabList.value.forEach((item){
      activityLabListTextController.value.add(TextEditingController(text: item.remarks));
    });
    activityLabList.forEach((item){
      debugPrint('Print data lab yang diedit ${jsonEncode(item)}');
    });

    Get.bottomSheet(
        GetBuilder(
          init: LabActivityDetailController(),
          builder: (controller) => Container(
              margin: EdgeInsets.only(top: 48),
              padding: EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))
              ),
              child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Edit Stage Laboratory',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: primaryColor
                            ),
                          ),
                          const SizedBox(height: 16,),
                          Text('Stage ${activityLabStage}: ${labStagesName[activityLabStage-1]}',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                          const SizedBox(height: 16,),
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
                                  onTap: (){
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
                                          onPressed: (){
                                            selectDate(Get.context!);
                                          },
                                          icon: const Icon(Icons.calendar_today_rounded)
                                      ),
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
                                const SizedBox(height: 16,),
                                Text('Detail Activities'),
                                const SizedBox(height: 16,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: activityStartTime,
                                        cursorColor: onFocusColor,
                                        readOnly: true,
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
                                              borderSide:
                                              const BorderSide(color: onFocusColor),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            labelText: 'Start Time*',
                                            floatingLabelStyle:
                                            const TextStyle(color: onFocusColor),
                                            fillColor: onFocusColor),
                                      ),
                                    ),
                                    const SizedBox(width: 8,),
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
                                              borderSide:
                                              const BorderSide(color: onFocusColor),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            labelText: 'End Time',
                                            floatingLabelStyle:
                                            const TextStyle(color: onFocusColor),
                                            fillColor: onFocusColor),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16,),
                                TextFormField(
                                  controller: activityText,
                                  cursorColor: onFocusColor,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(150),
                                  ],
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
                              ],
                            ),
                          ),
                          const SizedBox(height: 16,),
                          InkWell(
                            onTap: (){
                              if (_formKey.currentState!.validate()) {
                                if(editActivityMode.value == false){
                                  addActivity();
                                } else {
                                  editActivity(editActivityIndex.value);
                                }
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 8),
                              height: 42,
                              width: 42,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(8)
                              ),
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
                          const SizedBox(height: 16,),
                          activityLabList.value.isNotEmpty ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: activityLabList.value.map((item){return item.transDate;}).toSet().toList().length,
                              itemBuilder: (context, index) {
                                var date = activityLabList.value.map((item){return item.transDate;}).toSet().toList()[index];
                                var activity = activityLabList.value[index];
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
                                                      fontSize: 11.sp,
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
                                                        date ?? '-',
                                                        style: TextStyle(
                                                          fontSize: 11.sp,
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed:
                                                            () {
                                                          removeActivityByDateConfirm(date!, index, activityLabStage);
                                                        },
                                                        icon: const ImageIcon(
                                                            AssetImage("assets/icons/deleteStage.png"),
                                                            color: Colors.red,
                                                            size: 18
                                                        ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'Activities',
                                                  style: TextStyle(
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                      FontWeight
                                                          .w700),
                                                ),
                                              ),
                                              VerticalDivider(width: 1),
                                              SizedBox(width: 8),
                                              Expanded(
                                                flex: 3,
                                                  child: Column(
                                                    children: [
                                                      ListView.builder(
                                                          shrinkWrap: true,
                                                          physics: NeverScrollableScrollPhysics(),
                                                          itemCount: activity.listLabActivity?.length,
                                                          itemBuilder: (context, indexItem){
                                                            var activityItem = activity.listLabActivity![indexItem];
                                                            if(activityLabList.value[index].transDate == date){
                                                              return Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child: Text(
                                                                      '${activityItem.startActivityTime ?? '-'} - ${activityItem.endActivityTime ?? '-'}',
                                                                      style: TextStyle(
                                                                          fontSize: 10.sp,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                    ),
                                                                  ),
                                                                  VerticalDivider(width: 1),
                                                                  SizedBox(width: 8),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child: Text(
                                                                            activityItem.activity ?? '-',
                                                                            style: TextStyle(
                                                                              fontSize: 11.sp,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                            onTap: () {
                                                                              toggleEditActivity(index, indexItem);
                                                                            },
                                                                            child: const Icon(
                                                                              Icons.mode_edit_outlined,
                                                                              color: primaryColor,
                                                                            )
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 6,
                                                                        ),
                                                                        SizedBox(
                                                                          height: 12.h,
                                                                          width: 12.h,
                                                                          child: Ink(
                                                                            decoration: ShapeDecoration(
                                                                                color: Colors.red,
                                                                                shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(4.w)
                                                                                )
                                                                            ),
                                                                            child: InkWell(
                                                                                onTap: () {
                                                                                  removeActivityConfirm("${activityItem.startActivityTime} - ${activityItem.endActivityTime}", indexItem, index, activityLabStage);
                                                                                },
                                                                                child: Icon(
                                                                                    Icons.remove,
                                                                                    color: Colors.white,
                                                                                    size: 10.h
                                                                                )
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              );
                                                            } else {
                                                              return const SizedBox();
                                                            }
                                                          }
                                                          )
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
                                            controller: activityLabListTextController[index],
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  250),
                                            ],
                                            onChanged: (value){
                                              debugPrint(value);
                                              debugPrint('text remarks controller : ${activityLabListTextController[index].text}');
                                              editActivityRemarks(date!, value, index);
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
                              }) : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              clearActivityLabForm();
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
                                    )
                                )
                            )
                        ),
                      ),
                      const SizedBox(width: 16,),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              editActivityLabStageConfirm();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: Container(
                                padding:
                                const EdgeInsets.symmetric(vertical: 12),
                                width: double.infinity,
                                child: const Center(
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )
                                )
                            )
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16,),
                ],
              ),
              )
          ),
        ),
        isScrollControlled: true
    );
  }

  void editActivityLabStageConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text('Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
          ),
        ),
        content: Text('Apakah benar anda akan menyimpan perubahan stage ${labStagesName[activityLabStage - 1]} ini? pastikan data yg anda input benar.'),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text("OK",
              style: TextStyle(
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              var result = await updateActivityLab();
              if(result == 'success'){
                Get.back();
                Get.back();
                await getData();
                await scrollToBottom();
                //openDialog("Success", "Activity Stage ${activityLabStage-1} berhasil ditambahkan");
              } else {
                Get.back();
                openDialog("Failed", "Activity Stage $activityLabStage masih kosong atau belum diinput");
              }
            },
          ),
        ],
      ),
    );
  }

  void nextStageActivityConfirm(){
    Get.dialog(
      AlertDialog(
        title: Text('Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
          ),
        ),
        content: Text('Apakah anda ingin melanjutkan ke stage berikutnya? jika Ya, anda tidak bisa mengubah stage sebelumnya. Pastikan data yang anda input benar.'),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text("OK",
              style: TextStyle(
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              activityLabStage++;
              activitySubmitted.value = false;
              update();
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  // Activity 5 Lab Functions

  // > Add Functions

  Future<String?> addActivity5LabStages() async {
    final db = await SqlHelper.db();
    final createdBy = userData.value!.id;
    activity5LabListStages.value = [];
    var data = TDJoLaboratoryActivityStages(
      tHJoId: id,
      dJoLaboratoryId: joLabId,
      mStatuslaboratoryprogresId: activityLabStage,
      transDate: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
      totalSampleReceived: int.parse(sampleReceived.text.toString()),
      totalSampleAnalyzed: int.parse(sampleAnalyzed.text.toString()),
      totalSamplePreparation: int.parse(samplePreparation.text.toString()),
      isActive: 1,
      isUpload: 0,
      createdBy: userData.value?.id ?? 0,
      createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString(),
      code: 'JOLAS-5-${createdBy}-${Helper.generateUniqueCode()}',
    );
    int result = await db.insert("t_d_jo_laboratory_activity_stages", data.toInsert());
    TDJoLaboratoryActivity detail =  TDJoLaboratoryActivity(
      tDJoLaboratoryActivityStagesId: result,
              tDJoLaboratoryId: joLabId,
              startActivityTime: DateFormat('HH:mm').format(DateTime.now()).toString(),
              endActivityTime: '',
              activity: '-',
              isActive: 1,
              isUpload: 0,
              code: 'JOLAS-5-${createdBy}-${Helper.generateUniqueCode()}',
              createdBy: userData.value?.id ?? 0,
              createdAt: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .format(DateTime.now())
                  .toString(),
            );
    int rsltDetail = await db.insert("t_d_jo_laboratory_activity",detail.toInsert());
    activity5LabList.value.add(data);
    activitySubmitted.value = true;
    return 'success';
  }

  Future<String> insertLocalActivity5Lab() async {
    try {
      // Your logic here
      final createdBy = userData.value!.id;
      //TDJoLaboratory joLab = joLaboratory.value;

      List<String> stageValues = [];
      List<String> activityValues = [];

      activity5LabList.value.asMap().forEach((index,stage){
        stageValues.add('''(${joLabId},${id},${activityLabStage == 0 ? 1 : activityLabStage},'${stage.transDate}','',${stage.totalSampleReceived},${stage.totalSampleAnalyzed},${stage.totalSamplePreparation},$createdBy,'${DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now())}','JOLAS-${activityLabStage == 0 ? 1 : activityLabStage}-${createdBy}-${Helper.generateUniqueCode()}',1,0)''');
        update();
        if(stage.listLabActivity!.isNotEmpty){
          var count = 0;
          stage.listLabActivity!.forEach((activity){
            count++;
            activityValues.add('''((SELECT id FROM t_d_jo_laboratory_activity_stages WHERE trans_date = '${stage.transDate}' AND m_statuslaboratoryprogres_id = ${activityLabStage == 0 ? 1 : activityLabStage} LIMIT 1),${joLabId},'${activity.startActivityTime}','${activity.endActivityTime}','${activity.activity}','JOLA-${activityLabStage == 0 ? 1 : activityLabStage}-${createdBy}-${Helper.generateUniqueCode()}$count',1,0,${createdBy},'${DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now())}')''');
            update();
          });
        }
      });

      debugPrint("stage 5 join: ${stageValues.join(',')}");
      debugPrint("stage 5 join: ${activityValues.join(',')}");

      await SqlHelper.insertLaboratoryActivity5(stageValues.join(','), activityValues.join(','));

      debugPrint('activity lab saat ini : ${activityLabStage}');
      update();
      activitySubmitted.value = true;
      return 'success';
    } catch (e) {
      debugPrint("print error insert ${e}");
      return 'failed';
    }
  }

  Future<void> postInsertActivity5Lab(data) async {
    var response = await repository.insertActivity5Lab(data) ?? ResponseJoInsertActivity5Lab();
    debugPrint('insert activity 5 Lab response: ${jsonEncode(response.message)}');
  }

  void drawerDailyActivity5Lab(){
    Get.bottomSheet(
        GetBuilder(
            init: LabActivityDetailController(),
            builder: (controller) => Container(
              margin: EdgeInsets.only(top: 48),
              padding: EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Add Stage Laboratory',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor
                              ),
                            ),
                            const SizedBox(height: 16,),
                            Text('Stage ${activityLabStage}: ${labStagesName[activityLabStage-1]}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            const SizedBox(height: 16,),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(12),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field wajib diisi!';
                                }
                                return null;
                              },
                              controller: sampleReceived,
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
                                  labelText: 'Total sample received*',
                                  floatingLabelStyle:
                                  const TextStyle(color: onFocusColor),
                                  fillColor: onFocusColor),
                            ),
                            const SizedBox(height: 16,),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(12),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field wajib diisi!';
                                }
                                return null;
                              },
                              controller: samplePreparation,
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
                                  labelText: 'Total sample preparation*',
                                  floatingLabelStyle:
                                  const TextStyle(color: onFocusColor),
                                  fillColor: onFocusColor),
                            ),
                            const SizedBox(height: 16,),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(12),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field wajib diisi!';
                                }
                                return null;
                              },
                              controller: sampleAnalyzed,
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
                                  labelText: 'Total sample analyzed*',
                                  floatingLabelStyle:
                                  const TextStyle(color: onFocusColor),
                                  fillColor: onFocusColor),
                            ),
                            const SizedBox(height: 16,),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                clearActivity5LabForm();
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
                                      )
                                  )
                              )
                          ),
                        ),
                        const SizedBox(width: 16,),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  addActivity5LabStageConfirm();
                                  update();
                                }
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
                                      )
                                  )
                              )
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16,),
                  ],
                ),
              ),
            )
        ),
        isScrollControlled: true
    );
  }

  void clearActivity5LabForm(){
    activity5LabList.value.clear();
  }

  void addActivity5LabStageConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text('Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
          ),
        ),
        content: Text('Apakah benar anda akan submit stage issued analyzed result ini? pastikan data yg anda input benar.'),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text("OK",
              style: TextStyle(
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              var result = await addActivity5LabStages();
              if(result == 'success'){
                Get.back();
                Get.back();
                await getData();
                await scrollToBottom();
              } else {
                Get.back();
                openDialog("Failed", "Activity Stage $activityLabStage masih kosong atau belum diinput");
              }
            },
          ),
        ],
      ),
    );
  }

  // > Edit Functions

  Future<String?> editActivity5LabStages() async {
    activity5LabListStages.value = [];
    final db = await SqlHelper.db();
    var data = TDJoLaboratoryActivityStages(
      tHJoId: id,
      dJoLaboratoryId: joLabId,
      mStatuslaboratoryprogresId: activityLabStage,
      transDate: DateFormat('yyyy-MM-dd')
          .format(DateTime.now())
          .toString(),
      totalSampleReceived: int.parse(sampleReceived.text),
      totalSampleAnalyzed: int.parse(sampleAnalyzed.text),
      totalSamplePreparation: int.parse(samplePreparation.text),
      isActive: 1,
      isUpload: 0,
      createdBy: userData.value?.id ?? 0,
      createdAt: DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(DateTime.now())
          .toString(),
      updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(DateTime.now())
          .toString(),
      listLabActivity: [
        TDJoLaboratoryActivity(
          tDJoLaboratoryId: joLabId,
          startActivityTime: '',
          endActivityTime: '',
          activity: '',
          isActive: 1,
          isUpload: 0,
          createdBy: userData.value?.id ?? 0,
          createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString(),
        )
      ],
    );
    await db.update("t_d_jo_laboratory_activity_stages", data.toEdit(),where: "d_jo_laboratory_id = ? and m_statuslaboratoryprogres_id = ? ", whereArgs: [joLabId,5]);
    return 'success';
  }

  Future<String> updateInsertLocalActivity5Lab() async {
    try {
      // Your logic here
      final createdBy = userData.value!.id;

      List<String> stageValues = [];
      List<String> activityValues = [];

      activity5LabList.value.asMap().forEach((index,stage){
        stageValues.add('''(${stage.id ?? null},${joLabId},${id},${activityLabStage == 0 ? 1 : activityLabStage},'${stage.transDate}','',${stage.totalSampleReceived},${stage.totalSampleAnalyzed},${stage.totalSamplePreparation},$createdBy,'${Helper.generateUniqueCode()}','${stage.code ?? 'JOLAS-${activityLabStage == 0 ? 1 : activityLabStage}-${createdBy}-${Helper.generateUniqueCode()}'}',${stage.isActive},0)''');
        update();
        if(stage.listLabActivity!.isNotEmpty){
          var count = 0;
          stage.listLabActivity!.forEach((activity){
            count++;
            activityValues.add('''(${activity.id ?? null},${activity.tDJoLaboratoryActivityStagesId ?? '''(SELECT id FROM t_d_jo_laboratory_activity_stages WHERE trans_date = '${stage.transDate}' AND m_statuslaboratoryprogres_id = ${activityLabStage == 0 ? 1 : activityLabStage} LIMIT 1)'''},${joLabId},'${activity.startActivityTime}','${activity.endActivityTime}','${activity.activity}','${activity.code ?? 'JOLA-${activityLabStage == 0 ? 1 : activityLabStage}-${createdBy}-${Helper.generateUniqueCode()}$count'}',${activity.isActive == 1 ? 1 : 0},0,${createdBy},'${DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now())}')''');
            update();
          });
        }
      });

      debugPrint("stage join: ${stageValues.join(',')}");
      debugPrint("stage join: ${activityValues.join(',')}");

      await SqlHelper.updateLaboratoryActivity5(stageValues.join(','), activityValues.join(','));

      debugPrint('activity lab saat ini : ${activityLabStage}');
      update();
      activitySubmitted.value = true;
      return 'success';
    } catch (e) {
      debugPrint("print error insert ${e}");
      return 'failed';
    }
  }

  Future<void> updateInsertActivity5Lab(data) async {
    var response = await repository.insertActivity5Lab(data) ?? ResponseJoInsertActivity5Lab();
    debugPrint('insert activity 5 Lab response: ${jsonEncode(response.message)}');
  }

  void drawerDailyActivity5LabEdit(){
    if(activity5LabList.value.isEmpty){
      var labAct = activity5LabListStages.value.first;
      sampleReceived.text = int.parse(labAct.totalSampleReceived!.toString()).toString();
      sampleAnalyzed.text = int.parse(labAct.totalSampleAnalyzed!.toString()).toString();
      samplePreparation.text = int.parse(labAct.totalSamplePreparation!.toString()).toString();
    }
    Get.bottomSheet(
        GetBuilder(
            init: LabActivityDetailController(),
            builder: (controller) => Container(
              margin: EdgeInsets.only(top: 48),
              padding: EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Edit Stage Laboratory',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor
                              ),
                            ),
                            const SizedBox(height: 16,),
                            Text('Stage ${activityLabStage}: ${labStagesName[activityLabStage-1]}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            const SizedBox(height: 16,),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(12),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field wajib diisi!';
                                }
                                return null;
                              },
                              controller: sampleReceived,
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
                                  labelText: 'Total sample received*',
                                  floatingLabelStyle:
                                  const TextStyle(color: onFocusColor),
                                  fillColor: onFocusColor),
                            ),
                            const SizedBox(height: 16,),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(12),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field wajib diisi!';
                                }
                                return null;
                              },
                              controller: samplePreparation,
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
                                  labelText: 'Total sample preparation*',
                                  floatingLabelStyle:
                                  const TextStyle(color: onFocusColor),
                                  fillColor: onFocusColor),
                            ),
                            const SizedBox(height: 16,),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(12),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field wajib diisi!';
                                }
                                return null;
                              },
                              controller: sampleAnalyzed,
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
                                  labelText: 'Total sample analyzed*',
                                  floatingLabelStyle:
                                  const TextStyle(color: onFocusColor),
                                  fillColor: onFocusColor),
                            ),
                            const SizedBox(height: 16,),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                clearActivity5LabForm();
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
                                      )
                                  )
                              )
                          ),
                        ),
                        const SizedBox(width: 16,),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  editActivity5LabStageConfirm();
                                }
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
                                        'Save',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )
                                  )
                              )
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16,),
                  ],
                ),
              ),
            )
        ),
        isScrollControlled: true
    );
  }

  void editActivity5LabStageConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text('Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
          ),
        ),
        content: Text('Apakah benar anda akan menyimpan perubahan stage issued analyzed result ini? pastikan data yg anda input benar.'),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text("OK",
              style: TextStyle(
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              var result = await editActivity5LabStages();
              if(result == 'success'){
                Get.back();
                Get.back();
               await getData();
                await scrollToBottom();
              } else {
                Get.back();
                openDialog("Failed", "Activity Stage $activityLabStage masih kosong atau belum diinput");
              }
            },
          ),
        ],
      ),
    );
  }

  void nextStageActivity5LabConfirm(){
    Get.dialog(
      AlertDialog(
        title: Text('Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
          ),
        ),
        content: Text('Apakah anda ingin melanjutkan ke stage berikutnya? jika Ya, anda tidak bisa mengubah stage sebelumnya. Pastikan data yang anda input benar.'),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text("OK",
              style: TextStyle(
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              activityLabStage++;
              activitySubmitted.value = false;
              update();
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  // Activity 6 Functions

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
      initialEntryMode: TimePickerEntryMode.dialOnly,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Localizations.override(
          context: context,
          locale: const Locale('en', 'GB'),
          child: child,
        );
      },
    );
    if (picked != null) {
      List timeSplit = picked.format(context).split(' ');
      String formattedTime = timeSplit[0];
      String time = '$formattedTime';
      return time;
    } else {
      return '';
    }
  }

  void addActivity6() {
    debugPrint('activity 6 stage : $activityLabStage');
    if(activity6List.value.isEmpty){
      activity6ListTextController.value.add(TextEditingController());
      activity6List.value.add(TDJoLaboratoryActivityStages(
          tHJoId: id,
          dJoLaboratoryId: joLabId,
          mStatuslaboratoryprogresId: activityLabStage,
          transDate: activity6Date.text,
          isActive: 1,
          createdBy: userData.value?.id ?? 0,
          createdAt: DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(DateTime.now())
              .toString(),
          listLabActivity: [TDJoLaboratoryActivity(
            startActivityTime: activity6StartTime.text,
            endActivityTime: activity6EndTime.text,
            activity: activity6Text.text,
            isActive: 1,
            createdBy: userData.value?.id ?? 0,
            createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(
                DateTime.now()).toString(),
          )
          ]
      ));
    } else {
      if (activity6List.value
          .where((item) => item.transDate == activity6Date.text)
          .isEmpty) {
        activity6ListTextController.value.add(TextEditingController());
        activity6List.value.add(TDJoLaboratoryActivityStages(
            tHJoId: id,
            dJoLaboratoryId: joLabId,
            mStatuslaboratoryprogresId: activityLabStage,
            transDate: activity6Date.text,
            isActive: 1,
            createdBy: userData.value?.id ?? 0,
            createdAt: DateFormat('yyyy-MM-dd HH:mm:ss')
                .format(DateTime.now())
                .toString(),
            listLabActivity: [TDJoLaboratoryActivity(
              startActivityTime: activity6StartTime.text,
              endActivityTime: activity6EndTime.text,
              activity: activity6Text.text,
              isActive: 1,
              createdBy: userData.value?.id ?? 0,
              createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(
                  DateTime.now()).toString(),
            )
            ]
        ));
      } else {
        var stageIndex = activity6List.value.indexWhere((item) =>
        item.transDate == activity6Date.text && item.isActive == 1);
        activity6List.value[stageIndex].listLabActivity!.add(
            TDJoLaboratoryActivity(
              startActivityTime: activity6StartTime.text,
              endActivityTime: activity6EndTime.text,
              activity: activity6Text.text,
              isActive: 1,
              createdBy: userData.value?.id ?? 0,
              createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(
                  DateTime.now()).toString(),
            ));
      }
    }

    activity6Date.text = '';
    activity6StartTime.text = '';
    activity6EndTime.text = '';
    activity6Text.text = '';
    activitySubmitted.value == true;
    update();

    debugPrint('activities 6: ${jsonEncode(activity6List)}');
  }

  void toggleEditActivity6(int index, int itemIndex) {
    activity6Date.text = activity6List.value[index].transDate!;
    activity6StartTime.text = activity6List.value[index].listLabActivity![itemIndex].startActivityTime!;
    activity6EndTime.text = activity6List.value[index].listLabActivity![itemIndex].endActivityTime!;
    activity6Text.text = activity6List.value[index].listLabActivity![itemIndex].activity!;
    editActivityMode.value = true;
    editActivityIndex.value = itemIndex;
    update();
  }

  void editActivity6(int itemIndex) {
    var stageIndex = activity6List.value.indexWhere((item) => item.transDate == activity6Date.text);

    activity6List.value[stageIndex].listLabActivity![itemIndex] = TDJoLaboratoryActivity(
      startActivityTime: activity6StartTime.text,
      endActivityTime: activity6EndTime.text,
      activity: activity6Text.text,
      isActive: 1,
      createdBy: userData.value?.id ?? 0,
      createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(
          DateTime.now()).toString(),
    );
    editActivityMode.value = false;
    activity6Date.text = '';
    activity6StartTime.text = '';
    activity6EndTime.text = '';
    activity6Text.text = '';
    update();
  }

  void editActivity6Remarks(String date, String val, int index) {
    final TextEditingController remarksController = activity6ListTextController[index];
    debugPrint('text controller value : ${remarksController.text}');
    var stageIndex = activity6List.value.indexWhere((item) => item.transDate == date);
    TDJoLaboratoryActivityStages stage = activity6List.value[stageIndex];
    //activityLabList.value[stageIndex].remarks = remarksController.text;
    activity6List.value[stageIndex] = TDJoLaboratoryActivityStages(
      id : stage.id,
      dJoLaboratoryId : stage.dJoLaboratoryId,
      tHJoId : stage.tHJoId,
      mStatuslaboratoryprogresId : stage.mStatuslaboratoryprogresId,
      transDate : stage.transDate,
      remarks : remarksController.text,
      createdBy : stage.createdBy,
      updatedBy : stage.updatedBy,
      createdAt : stage.createdAt,
      updatedAt : stage.updatedAt,
      totalSampleReceived : stage.totalSampleReceived,
      totalSampleAnalyzed : stage.totalSampleAnalyzed,
      totalSamplePreparation : stage.totalSamplePreparation,
      code : stage.code,
      isActive : 1,
      isUpload : 0,
      listLabActivity: stage.listLabActivity,
      listLabAttachment: stage.listLabAttachment,
    );
  }

  void checkActivity6List() {
    debugPrint('activities now: ${jsonEncode(activity6List.value)}');
  }

  Future<void> removeActivity6(int index, int indexitem, int stage)async {
    // debugPrint("print index ${index} index item ${indexitem}");
    // var stageItem = activity6List.value[index].listLabActivity![indexitem];
    // if(stageItem.id != null){
    //   // activity6List.value[index].listLabActivity![indexitem] = TDJoLaboratoryActivity(
    //   //   id: stageItem.id,
    //   //   tDJoLaboratoryActivityStagesId: stageItem.tDJoLaboratoryActivityStagesId,
    //   //   tDJoLaboratoryId: stageItem.tDJoLaboratoryId,
    //   //   startActivityTime: stageItem.startActivityTime,
    //   //   endActivityTime: stageItem.endActivityTime,
    //   //   activity: stageItem.activity,
    //   //   code: stageItem.code,
    //   //   isActive: 0,
    //   //   isUpload: stageItem.isUpload,
    //   //   createdBy: stageItem.createdBy,
    //   //   updatedBy: stageItem.updatedBy,
    //   //   createdAt: stageItem.createdAt,
    //   //   updatedAt: stageItem.updatedAt,
    //   // );
    //   activity6List.value[index].listLabActivity!.removeAt(indexitem);
    // } else {
    //   activity6List.value[index].listLabActivity!.removeAt(indexitem);
    // }
    //
    // if(activity6List.value[index].listLabActivity!.isEmpty){
    //   activity6ListTextController.value.removeAt(index);
    //   activity6List.value.removeAt(index);
    // }

    var stageItem = activity6List.value[index].listLabActivity![indexitem];
    activity6List.value[index].listLabActivity!.removeAt(indexitem);

    update();
  }

  Future<void> removeActivity6ByDate(String date, int indexDate, int stageProgress)async{
    debugPrint("print date ${date} ${indexDate} stage ${stageProgress}");
    var stage = activity6List.value.where((item) => item.transDate == date && item.mStatuslaboratoryprogresId == 6).first;
    var indexStage = activity6List.value.indexWhere((item) => item.transDate == date && item.mStatuslaboratoryprogresId == 6);
    if(stage.id != null){
      // activity6List.value[indexStage] = TDJoLaboratoryActivityStages(
      //   id : stage.id,
      //   dJoLaboratoryId : stage.dJoLaboratoryId,
      //   tHJoId : stage.tHJoId,
      //   mStatuslaboratoryprogresId : stage.mStatuslaboratoryprogresId,
      //   transDate : stage.transDate,
      //   remarks : stage.remarks,
      //   createdBy : stage.createdBy,
      //   updatedBy : stage.updatedBy,
      //   createdAt : stage.createdAt,
      //   updatedAt : stage.updatedAt,
      //   totalSampleReceived : stage.totalSampleReceived,
      //   totalSampleAnalyzed : stage.totalSampleAnalyzed,
      //   totalSamplePreparation : stage.totalSamplePreparation,
      //   code : stage.code,
      //   isActive : 0,
      //   isUpload : 0,
      //   listLabActivity: stage.listLabActivity,
      //   listLabAttachment: stage.listLabAttachment,
      // );
      activity6List.value.removeAt(indexStage);
    } else {
      activity6List.value.removeAt(indexStage);
    }
    //activityLabList.value.removeWhere((item) => item.transDate == date && item.mStatuslaboratoryprogresId == stageProgress);
    activity6ListTextController.value.removeAt(indexStage);
    update();
  }

  void removeActivity6Confirm(String date, int indexitem, int index, int stage) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah anda ingin menghapus activity time $date?'),
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
              await removeActivity6(index, indexitem, stage);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void removeActivity6ByDateConfirm(String date, int indexDate, int stage) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah anda ingin menghapus activity date $date?'),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () async {
              Get.back();
            }

          ),
          TextButton(
            child: const Text(
              "OK",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              await removeActivity6ByDate(date, indexDate, stage);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Future<String?> addActivity6Stages() async {
    if (activity6List.value.where((data) => data.mStatuslaboratoryprogresId == 6).toList().isNotEmpty) {
      //activityStage++;
      final createdBy = userData.value!.id;
      final db = await SqlHelper.db();
      debugPrint('print data activity 6 ${jsonEncode(activity6List)}');
      var attachment =  activity6Attachments.value;
      debugPrint("print lab attahment ${attachment}");
      for(int i = 0; i < activity6List.length; i++) {
        debugPrint('print data activity ${jsonEncode(activity6List[i].toJson())}');
        TDJoLaboratoryActivityStages dataStage = TDJoLaboratoryActivityStages(
          code: 'JOLAS-5-${createdBy}-${Helper.generateUniqueCode()}${i}',
          dJoLaboratoryId: activity6List[i].dJoLaboratoryId,
          tHJoId: activity6List[i].tHJoId,
          mStatuslaboratoryprogresId: activity6List[i].mStatuslaboratoryprogresId,
          transDate: activity6List[i].transDate,
          remarks: activity6List[i].remarks,
          createdBy: activity6List[i].createdBy,
          createdAt: activity6List[i].createdAt,
          isActive: 1,
          isUpload: 0
        );
        int result = await db.insert("t_d_jo_laboratory_activity_stages", dataStage.toInsert());
        List<TDJoLaboratoryActivity> actStage = activity6List[i].listLabActivity ?? [];
        for (int j = 0; j < actStage.length; j++) {
          TDJoLaboratoryActivity dataAct = actStage[j].copyWith(
              startActivityTime: actStage[j].startActivityTime,
              endActivityTime: actStage[j].endActivityTime,
              activity: actStage[j].activity,
              tDJoLaboratoryActivityStagesId: result,
              tDJoLaboratoryId: dataStage.dJoLaboratoryId,
              createdBy: createdBy,
              isActive: 1,
              isUpload: 0,
              code: "JOLA-5-${createdBy}-${Helper.generateUniqueCode()}-${j}"
          );
          int rsltAct = await db.insert("t_d_jo_laboratory_activity", dataAct.toInsert());
        }
      }

      for(int a=0; a < attachment.length; a++){
        TDJoLaboratoryAttachment attachmentData = attachment[a].copyWith(
          code: "JOLA-A-${createdBy}-${Helper.generateUniqueCode()}"
        );
        int resultAttachment = await db.insert("t_d_jo_laboratory_attachment", attachmentData.toInsert());
        debugPrint('print data attachment ${attachmentData.toInsert()} id ${resultAttachment}');
      }
      //activity6AttachmentsStage.value = activity6Attachments.value;
      activity6Attachments.value = [];
      activity6List.value = [];
      activity6ListTextController.value = [];
      editActivityMode.value = false;
      activity6Date.text = '';
      activity6StartTime.text = '';
      activity6EndTime.text = '';
      activity6Text.text = '';

      activitySubmitted.value = true;

      update();
      return 'success';
    } else if (activity6List.value
        .where((data) => data.mStatuslaboratoryprogresId == 6)
        .toList()
        .isEmpty) {
      return 'failed';
    }
  }

  Future<String> insertLocalActivity6() async {
    try {
      // Your logic here
      final createdBy = userData.value!.id;
      final db = await SqlHelper.db();
      //TDJoLaboratory joLab = joLaboratory.value;

      List<String> stageValues = [];
      List<String> activityValues = [];
      List<String> attachmentValues = [];

      debugPrint('print data activity 6 ${jsonEncode(activity6List)}');
      var attachment =  activity6Attachments.value;
      debugPrint("print lab attahment ${attachment}");

      debugPrint("stage join: ${stageValues.join(',')}");
      debugPrint("activity join: ${activityValues.join(',')}");

      //await SqlHelper.insertLaboratoryActivity6(stageValues.join(','), activityValues.join(','), attachmentValues.join(','));

      debugPrint('activity lab saat ini : ${activityLabStage}');
      update();
      activitySubmitted.value = true;
      return 'success';
    } catch (e) {
      debugPrint("print error insert ${e}");
      return 'failed';
    }
  }

  Future<void> postInsertActivity6(data) async {
    var response = await repository.insertActivityInspection6(data) ?? ResponseJoInsertActivity5();
    debugPrint('insert activity response: ${jsonEncode(response.message)}');
  }

  void addActivity6Files(String path) {
    activity6Attachments.value.add(TDJoLaboratoryAttachment(
      tDJoLaboratoryId: joLabId,
      mStatuslaboratoryprogresId: activityLabStage,
      pathName: path,
      fileName: path.split('/').last,
      isActive: 1,
      isUpload: 0,
      createdBy: userData.value?.id ?? 0,
      createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(
          DateTime.now()).toString(),
    ));
  }

  void cameraImageActivity6() async {
    File? image;
    try {
      final XFile? pic = await picker.pickImage(source: ImageSource.camera);
      if (pic != null) {
        final imageTemp = File(pic!.path);
        image = imageTemp;
        final imageName = image.path.split('/').last;
        final dir = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
        bool exists = await Directory('$dir/ops/files/').exists();

        if(exists == false){
          Directory('$dir/ops/files/').create();
        }

        image.rename('$dir/ops/files/$imageName');
        update();
        addActivity6Files(image.path);
      }
    } on PlatformException catch (e) {
      openDialog('Failed', e.message ?? 'Gagal menambahkan file');
    }
  }

  void fileActivity6() async {
    var total = 0;
    activity6Attachments.value.forEach((item) async {
      final fileBytes = await File(item.pathName!).readAsBytes();
      total = total + fileBytes.lengthInBytes;
      update();
    });
    try {
      final FilePickerResult? attach = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);
      if (attach != null) {
        final List<XFile> xFiles = attach.xFiles;
        if((activity6Attachments.value.length + xFiles.length) > 5 ){
          openDialog("Attenction", "File attachment maksimal 5");
        }else{
          xFiles.forEach((data) async {
            final fileTemp = File(data!.path);
            final File file = fileTemp;
            final fileName = file.path.split('/').last;
            final checkFileBytes = await File(file.path).readAsBytes();
            if (total + checkFileBytes.lengthInBytes > 10000000) {
              openDialog("Attention", 'Total File lebih dari 10 MB!');
              return;
            } else {
              final dir = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
              bool exists = await Directory('$dir/ops/files/').exists();
              if(exists == false){
                Directory('$dir/ops/files/').create();
              }
              file.rename('$dir/ops/files/$fileName');
              addActivity6Files(file.path);
              update();
            }

          });
        }
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
          init: LabActivityDetailController(),
          builder: (controller) => Container(
              margin: EdgeInsets.only(top: 48),
              padding: EdgeInsets.all(24),
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      topLeft: Radius.circular(24)
                  )
              ),
              child: Obx(() => Form(
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
                                'Add Stage Laboratory',
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
                              Column(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
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
                                              readOnly: true,
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
                                              readOnly: true,
                                              onTap: () async {
                                                activity6EndTime.text =
                                                await selectTime6(Get.context!);
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
                                                  labelText: 'End Time',
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
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(
                                              150),
                                        ],
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
                                    ],
                                  ),
                                ],
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
                                      editActivity6(editActivityIndex.value);
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
                                    var date = activity6List.value
                                        .map((item) {
                                      return item.transDate;
                                    })
                                        .toSet()
                                        .toList()[index];
                                    var activity = activity6List.value[index];
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
                                                            fontSize: 11.sp,
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
                                                              date ?? '-',
                                                              style: TextStyle(
                                                                fontSize: 11.sp,
                                                              ),
                                                            ),
                                                          ),
                                                          InkWell(
                                                              onTap: () {removeActivity6ByDateConfirm(date!, index, 6);
                                                              },
                                                              child: const ImageIcon(
                                                                  AssetImage("assets/icons/deleteStage.png"),
                                                                  color: Colors.red,
                                                                  size: 18
                                                              ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
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
                                                            11.sp,
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
                                                      flex: 3,
                                                        child: Column(
                                                          children: [
                                                            ListView.builder(
                                                                shrinkWrap: true,
                                                                physics:
                                                                NeverScrollableScrollPhysics(),
                                                                itemCount: activity.listLabActivity?.length,
                                                                itemBuilder:
                                                                    (context, indexItem) {
                                                                  var activityItem = activity.listLabActivity![indexItem];
                                                                  if (activity6List
                                                                      .value[
                                                                  index]
                                                                      .transDate ==
                                                                      date) {
                                                                    return Row(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            '${activityItem.startActivityTime ?? '-'} - ${activityItem.endActivityTime ?? '-'}',
                                                                            style: TextStyle(
                                                                                fontSize:
                                                                                10.sp,
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
                                                                                child: Text(
                                                                                  activityItem.activity ??
                                                                                      '-',
                                                                                  style:
                                                                                  TextStyle(
                                                                                    fontSize:
                                                                                    11.sp,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              InkWell(
                                                                                  onTap:
                                                                                      () {
                                                                                    toggleEditActivity6(
                                                                                        index,
                                                                                        indexItem);
                                                                                  },
                                                                                  child: ImageIcon(
                                                                                      AssetImage("assets/icons/editActivity.png"),
                                                                                      color: primaryColor,
                                                                                      size: 12.h
                                                                                  ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 6,
                                                                              ),
                                                                              SizedBox(
                                                                                height: 12.h,
                                                                                width: 12.h,
                                                                                child: Ink(
                                                                                  decoration: ShapeDecoration(
                                                                                      color: Colors.red,
                                                                                      shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(4.w)
                                                                                      )
                                                                                  ),
                                                                                  child: InkWell(
                                                                                      onTap:
                                                                                          () {
                                                                                        removeActivity6Confirm(date!, indexItem, index, 6);
                                                                                      },
                                                                                      child: Icon(
                                                                                          Icons.remove,
                                                                                          color: Colors.white,
                                                                                          size: 10.h
                                                                                      )
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    );
                                                                  } else {
                                                                    return const SizedBox();
                                                                  }
                                                                })
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
                                                  controller:
                                                  activity6ListTextController
                                                      .value[index],
                                                  onChanged: (value) {
                                                    editActivity6Remarks(
                                                        date!,
                                                        value,
                                                        index);
                                                  },
                                                  inputFormatters: [
                                                    LengthLimitingTextInputFormatter(
                                                        250),
                                                  ],
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
                                    final TDJoLaboratoryAttachment photo = activity6Attachments.value[index];
                                    final String fileType = checkFileType(photo.pathName!);
                                    var filename = photo.fileName;
                                    return fileType == 'image' ? Stack(
                                      children: [
                                        Container(
                                          width: 63,
                                          height: 63,
                                          child: ClipRect(
                                            child: InkWell(
                                              onTap: (){
                                                mediaPickerEditConfirm(index);
                                              },
                                              child: Image.file(
                                                File(photo.pathName!),
                                              ),
                                            ),
                                          )
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton(
                                            onPressed: () {
                                              controller.removeActivity6Files(index);
                                            },
                                            icon: Image.asset('assets/icons/close.png', width: 24,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ) : fileType == 'doc' ? SizedBox(
                                      width: 68,
                                      height: 68,
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: (){
                                              OpenFilex.open(photo.pathName!);
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(top: 5),
                                              width: 63,
                                              height: 63,
                                              child: Center(
                                                  child: Column(
                                                    children: [
                                                      Image.asset('assets/icons/pdfIcon.png', height: 42,),
                                                      Text(filename!, style: TextStyle(fontSize: 8), overflow: TextOverflow.ellipsis)
                                                    ],
                                                  )
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 68,
                                            height: 68,
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                  onTap: (){
                                                    controller.removeActivity6Files(index);
                                                  },
                                                  child: Image.asset('assets/icons/close.png', width: 24)
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
                              activity6Attachments.value.length < 5 ? SizedBox(
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
                              ): const SizedBox(),
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
                                  clearActivity6LabForm();
                                  Get.back();
                                  await getData();
                                  await scrollToBottom();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: primaryColor),
                                        borderRadius: BorderRadius.circular(12)
                                    )
                                ),
                                child: Container(
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                    width: double.infinity,
                                    child: const Center(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )
                                    )
                                )
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: ElevatedButton(
                                onPressed: addActivity6StageConfirm,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)
                                    )
                                ),
                                child: Container(
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                    width: double.infinity,
                                    child: const Center(
                                        child: Text(
                                          'Submit',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )
                                    )
                                )
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              )
          ),
        ),
        isScrollControlled: true);
  }

  void clearActivity6LabForm(){
    activity6Attachments.value = [];
    activity6List.value = [];
    activity6ListTextController.value = [];
    editActivityMode.value = false;
    activity6Date.text = '';
    activity6StartTime.text = '';
    activity6EndTime.text = '';
    activity6Text.text = '';
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
            // InkWell(
            //   onTap: () {
            //     removeActivity6Files(index);
            //   },
            //   child: Icon(
            //     Icons.delete_forever,
            //     color: Colors.red,
            //   ),
            // ),
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
    activity6List.value = activity6ListStages.value.where((item) => item.mStatuslaboratoryprogresId == activityLabStage).toList();
    var activityEditTemp = activity6List.value.map((item){return item.transDate;}).toSet().toList();
    activity6List.forEach((item){
      activity6ListTextController.value.add(TextEditingController(text: item.remarks));
    });
    activity6Attachments.value = activity6AttachmentsStage.value;
    update();
    Get.bottomSheet(
        GetBuilder(
          init: LabActivityDetailController(),
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
                                'Edit Stage Laboratory',
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
                                      readOnly: true,
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
                                      readOnly: true,
                                      onTap: () async {
                                        activity6EndTime.text = await selectTime6(Get.context!);
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
                                          labelText: 'End Time',
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
                                inputFormatters: [
                                  new LengthLimitingTextInputFormatter(150),
                                ],
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
                                  if (editActivityMode.value == false) {
                                    addActivity6();
                                  } else {
                                    editActivity6(editActivityIndex.value);
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
                                    var date = activity6List.value
                                        .map((item) {
                                      return item.transDate;
                                    })
                                        .toSet()
                                        .toList()[index];
                                    var activity = activity6List.value[index];
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
                                                            fontSize: 11.sp,
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
                                                              date ?? '-',
                                                              style: TextStyle(
                                                                fontSize: 11.sp,
                                                              ),
                                                            ),
                                                          ),
                                                          IconButton(
                                                              onPressed: () {
                                                                removeActivity6ByDateConfirm(date!, index, 6);

                                                              },
                                                              icon: const ImageIcon(
                                                                  AssetImage("assets/icons/deleteStage.png"),
                                                                  color: Colors.red,
                                                                  size: 18
                                                              ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
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
                                                      flex: 3,
                                                      child: Column(
                                                          children: [
                                                            ListView.builder(
                                                                shrinkWrap: true,
                                                                physics:
                                                                NeverScrollableScrollPhysics(),
                                                                itemCount: activity.listLabActivity?.length,
                                                                itemBuilder:
                                                                    (context, indexItem) {
                                                                  var activityItem = activity.listLabActivity![indexItem];
                                                                  if (activity.transDate ==
                                                                      date) {
                                                                    return Row(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        SizedBox(
                                                                            width: 8),
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            '${activityItem.startActivityTime ?? '-'} - ${activityItem.endActivityTime ?? '-'}',
                                                                            style: TextStyle(
                                                                                fontSize:
                                                                                10.sp,
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
                                                                                child: Text(
                                                                                  activityItem.activity ??
                                                                                      '-',
                                                                                  style:
                                                                                  TextStyle(
                                                                                    fontSize:
                                                                                    11.sp,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              InkWell(
                                                                                  onTap:
                                                                                      () {
                                                                                    toggleEditActivity6(
                                                                                        index,
                                                                                        indexItem);
                                                                                  },
                                                                                  child:
                                                                                  Icon(
                                                                                    Icons
                                                                                        .mode_edit_outlined,
                                                                                    color:
                                                                                    primaryColor,
                                                                                  )
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 6,
                                                                              ),
                                                                              SizedBox(
                                                                                height: 12.h,
                                                                                width: 12.h,
                                                                                child: Ink(
                                                                                  decoration: ShapeDecoration(
                                                                                      color: Colors.red,
                                                                                      shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(4.w)
                                                                                      )
                                                                                  ),
                                                                                  child: InkWell(
                                                                                      onTap: () {
                                                                                            removeActivity6Confirm(date!, indexItem, index, 6);
                                                                                      },
                                                                                      child: Icon(
                                                                                          Icons.remove,
                                                                                          color: Colors.white,
                                                                                          size: 10.h
                                                                                      )
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    );
                                                                  } else {
                                                                    return const SizedBox();
                                                                  }
                                                                })
                                                          ]
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const Divider(),
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                TextFormField(
                                                  controller: activity6ListTextController.value[index],
                                                  inputFormatters: [
                                                    new LengthLimitingTextInputFormatter(250),
                                                  ],
                                                  onChanged: (value) {
                                                    editActivity6Remarks(date!, value, index);
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
                                    final TDJoLaboratoryAttachment photo = activity6Attachments.value[index];
                                    final String fileType = checkFileType(photo.pathName!);
                                    var filename = photo.fileName;
                                    return fileType == 'image' ? SizedBox(
                                      width: 68,
                                      height: 68,
                                      child: Stack(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(top: 5),
                                            width: 63,
                                            height: 63,
                                            child: InkWell(
                                              onTap: (){
                                                //controller.previewImageAct6(index, photo.pathName!);
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
                                                  onTap: (){
                                                    controller.removeActivity6Files(index);
                                                  },
                                                  child: Image.asset('assets/icons/close.png', width: 24)
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ) : fileType == 'doc' ? SizedBox(
                                      width: 68,
                                      height: 68,
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: (){
                                              OpenFilex.open(photo.pathName!);
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(top: 5),
                                              width: 63,
                                              height: 63,
                                              child: Center(
                                                  child: Column(
                                                    children: [
                                                      Image.asset('assets/icons/pdfIcon.png', height: 42,),
                                                      Text(filename!, style: TextStyle(fontSize: 8), overflow: TextOverflow.ellipsis)
                                                    ],
                                                  )
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 68,
                                            height: 68,
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                  onTap: (){
                                                    controller.removeActivity6Files(index);
                                                  },
                                                  child: Image.asset('assets/icons/close.png', width: 24)
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
                              activity6Attachments.value.length < 5 ? SizedBox(
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
                              ) : const SizedBox(),
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
                                  clearActivity6LabForm();
                                  Get.back();
                                  await getData();
                                  await scrollToBottom();
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
                                          'Save',
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

  Future<String?> editActivity6Stages() async {
    if (activity6List.value.where((data) => data.mStatuslaboratoryprogresId == activityLabStage).toList().isNotEmpty) {
      final createdBy = userData.value!.id;
      final db = await SqlHelper.db();

      var attachment =  activity6Attachments.value;
      await db.update("t_d_jo_laboratory_activity_stages", {"is_active": 0},where: "m_statuslaboratoryprogres_id=? and d_jo_laboratory_id= ?",whereArgs: [6,joLabId]);
      for(int i = 0; i < activity6List.length; i++) {
        TDJoLaboratoryActivityStages labActStage = activity6List[i];
        if(labActStage.id == null){
          TDJoLaboratoryActivityStages dataStage = TDJoLaboratoryActivityStages(
              code: 'JOLAS-6-${createdBy}-${Helper.generateUniqueCode()}${i}',
              dJoLaboratoryId: activity6List[i].dJoLaboratoryId,
              tHJoId: activity6List[i].tHJoId,
              mStatuslaboratoryprogresId: activity6List[i].mStatuslaboratoryprogresId,
              transDate: activity6List[i].transDate,
              remarks: activity6List[i].remarks,
              createdBy: activity6List[i].createdBy,
              createdAt: activity6List[i].createdAt,
              isActive: 1,
              isUpload: 0
          );
          int result = await db.insert("t_d_jo_laboratory_activity_stages", dataStage.toInsert());
          List<TDJoLaboratoryActivity> actStage = activity6List[i].listLabActivity ?? [];
          for (int j = 0; j < actStage.length; j++) {
            TDJoLaboratoryActivity dataAct = actStage[j].copyWith(
                startActivityTime: actStage[j].startActivityTime,
                endActivityTime: actStage[j].endActivityTime,
                activity: actStage[j].activity,
                tDJoLaboratoryActivityStagesId: result,
                tDJoLaboratoryId: dataStage.dJoLaboratoryId,
                createdBy: createdBy,
                isActive: 1,
                isUpload: 0,
                code: "JOLA-6-${createdBy}-${Helper.generateUniqueCode()}-${j}"
            );
            int rsltAct = await db.insert("t_d_jo_laboratory_activity", dataAct.toInsert());
          }
        }else{
          TDJoLaboratoryActivityStages dataStage = TDJoLaboratoryActivityStages(
              mStatuslaboratoryprogresId: activity6List[i].mStatuslaboratoryprogresId,
              transDate: activity6List[i].transDate,
              remarks: activity6List[i].remarks,
              createdBy: activity6List[i].createdBy,
              createdAt: activity6List[i].createdAt,
              isActive: 1,
              isUpload: 0,
            id: labActStage.id
          );
          await db.update("t_d_jo_laboratory_activity_stages", dataStage.toEdit(),where: "id=?",whereArgs: [dataStage.id]);
          List<TDJoLaboratoryActivity> actStage = activity6List[i].listLabActivity ?? [];
          await db.update("t_d_jo_laboratory_activity", {"is_active": 0},where: "t_d_jo_laboratory_activity_stages_id=?",whereArgs: [dataStage.id]);
          for (int j = 0; j < actStage.length; j++) {
            TDJoLaboratoryActivity dataAct = actStage[j].copyWith(
                startActivityTime: actStage[j].startActivityTime,
                endActivityTime: actStage[j].endActivityTime,
                activity: actStage[j].activity,
                tDJoLaboratoryActivityStagesId: dataStage.id,
                tDJoLaboratoryId: joLabId,
                createdBy: createdBy,
                isActive: 1,
                isUpload: 0,
                code: "JOLA-6-${createdBy}-${Helper.generateUniqueCode()}-${j}"
            );
            debugPrint('print data TDJoLaboratoryActivity  ${jsonEncode(dataAct.toJson())}');
            if(dataAct.id == null){
              int rsltAct = await db.insert("t_d_jo_laboratory_activity", dataAct.toInsert());
            }else{
              await db.update("t_d_jo_laboratory_activity", dataAct.toEdit(),where: "id=?",whereArgs: [dataAct.id]);
            }

          }
        }

      }

      //set is_active = 1 untuk sementara
      await db.update("t_d_jo_laboratory_attachment",{"is_active": 0},whereArgs: [joLabId],where: "t_d_jo_laboratory_id=?");
      for(int a=0; a < attachment.length; a++){
        TDJoLaboratoryAttachment attachmentData = attachment[a].copyWith(
            code: "JOLA-A-${createdBy}-${Helper.generateUniqueCode()}",
          tDJoLaboratoryId: joLabId,
          isActive: 1,
          isUpload: 0,
        );
        if(attachmentData.id == null){
          await db.insert("t_d_jo_laboratory_attachment", attachmentData.toInsert());
        }else{
          await db.update("t_d_jo_laboratory_attachment",attachmentData.toEdit(),whereArgs: [attachmentData.id],where: "id=?");
        }

        debugPrint('print data attachment ${attachment[a].toJson()}');
      }
      //activity6ListStages.value = activity6List.value;
      //activity6AttachmentsStage.value = activity6Attachments.value;
      activity6Attachments.value = [];
      activityLabList.value = [];
      activityLabListTextController.value = [];
      editActivityMode.value = false;
      activityDate.text = '';
      activityStartTime.text = '';
      activityEndTime.text = '';
      activityText.text = '';

      activitySubmitted.value = true;
      update();
      return 'success';
    } else if (activity6List.value
        .where((data) => data.mStatuslaboratoryprogresId == activityLabStage)
        .toList()
        .isEmpty) {
      return 'failed';
    }
  }

  Future<String> updateInsertLocalActivity6() async {
    try {
      // Your logic here
      final updatedBy = userData.value!.id;

      List<String> stageValues = [];
      List<String> activityValues = [];
      List<Map<String,dynamic>> attachmentValues = [];

      activity6List.value.asMap().forEach((index,stage){
        stageValues.add('''(${stage.id ?? null},${joLabId},${id},${6},'${stage.transDate}','${activityLabListTextController.value[index].text}',${stage.id != null ? stage.createdBy : updatedBy}, ${stage.id != null ? updatedBy : 0}, ''${DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now())}'', '${DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now())}','${stage.code ?? 'JOLAS-6-${updatedBy}-${Helper.generateUniqueCode()}'}',${stage.isActive},0)''');
        update();
        if(stage.listLabActivity!.isNotEmpty){
          var count = 0;
          stage.listLabActivity!.forEach((activity){
            count++;
            activityValues.add('''(${activity.id ?? null},${activity.tDJoLaboratoryActivityStagesId ?? '''(SELECT id FROM t_d_jo_laboratory_activity_stages WHERE trans_date = '${stage.transDate}' AND m_statuslaboratoryprogres_id = 6 LIMIT 1)'''},${joLabId},'${activity.startActivityTime}','${activity.endActivityTime}','${activity.activity}','${activity.code ?? 'JOLA-6-${updatedBy}-${Helper.generateUniqueCode()}$count'}',${activity.isActive == 1 ? 1 : 0},${activity.id != null ? updatedBy : 0},${activity.id != null ? activity.createdBy : updatedBy}, ${activity.id != null ? updatedBy : 0},'${DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now())}','${activity.id != null ? DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()) : null}')''');
            update();
          });
        }
      });

      if(activity6Attachments.value.isNotEmpty){
        var count = 0;
        activity6Attachments.value.forEach((attachment){
          count++;
        });
      }

      debugPrint("stage join: ${stageValues.join(',')}");
      debugPrint("stage join: ${activityValues.join(',')}");

      await SqlHelper.updateLaboratoryActivity6(stageValues.join(','), activityValues.join(','), attachmentValues);

      debugPrint('activity lab saat ini : ${activityLabStage}');
      update();
      activitySubmitted.value = true;
      return 'success';
    } catch (e) {
      debugPrint("print error insert ${e}");
      return 'failed';
    }
  }

  Future<void> postUpdateActivity6(data) async {
    var response = await repository.updateActivityInspection6(data, id) ?? ResponseJoInsertActivity5();
    debugPrint('insert activity 6 response: ${jsonEncode(response.message)}');
  }

  void addActivity6StageConfirm() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: const Text(
            'Apakah benar anda akan submit stage report to client ini? pastikan data yg anda input benar.'),
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
              var result = await addActivity6Stages();
              if (result == 'success') {
                Get.back();
                Get.back();
                await getData();
                await scrollToBottom();
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
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: const Text(
            'Apakah benar anda akan menyimpan perubahan stage report to client ini? pastikan data yg anda input benar.'),
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
              var result = await editActivity6Stages();
              if (result == 'success') {
                Get.back();
                Get.back();
                await getData();
                await scrollToBottom();
              } else {
                Get.back();
                openDialog("Failed", "Activity Stage $activityLabStage gagal diinput");
              }
            },
          ),
        ],
      ),
    );
  }

  void removeActivity6Files(int index) {
    activity6Attachments.value.removeAt(index);
    update();
  }

  void removeActivity6FilesConfirm(int index) {
    activity6Attachments.value.removeAt(index);
    update();
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
            'Apakah benar anda ingin Finish JO Lab ini? pastikan data yg anda input benar, karena anda tidak bisa mengubah data setelah Finish JO'),
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
              // activityLabStage++;
              await finishJoLab();
              activitySubmitted.value = false;
              update();
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Future<void> finishJoLab()async{
    try{
      final db = await SqlHelper.db();
      final time = DateTime.now();
      await db.execute('''UPDATE t_h_jo SET laboratory_finished_date = '${time}' WHERE id = ${id};''');
      debugPrint(" print data jo  ${id}");
    } catch(e){
      debugPrint(e.toString());
    } finally {
      update();
    }
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

  void finishLabConfirm() {
    Get.dialog(
      AlertDialog(
        title: const Text("Attention",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
          ),
        ),
        content: const Text("Apakah benar anda ingin Finish JO Lab ini? pastikan data yg anda input benar, karena anda tidak bisa mengubah data setelah Finish JO"),
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
              await finishJoLab();
              await getData();
              Get.back();
            },
          ),
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
          final fileName = file.path.split('/').last;
          final checkFileBytes = await File(file.path).readAsBytes();
          if (total + checkFileBytes.lengthInBytes > 10000000) {
            openDialog("Attention", 'Total File lebih dari 10 MB!');
            return;
          }else {
            final dir = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
            bool exists = await Directory('$dir/ops/files/').exists();
            if(exists == false){
              Directory('$dir/ops/files/').create();
            }
            file.rename('$dir/ops/files/$fileName');
            editActivity6Files(file.path, index);
            update();
          }
          update();
        });
      }
    } on PlatformException catch (e) {
      openDialog('Failed', e.message ?? 'Gagal menambahkan file.');
    }
  }

  void editActivity6Files(String path, index) {
    activity6Attachments.value[index] = TDJoLaboratoryAttachment(
      tDJoLaboratoryId: id,
      pathName: path,
      fileName: path.split('/').last,
      isActive: 1,
      isUpload: 0,
      createdBy: userData.value?.id ?? 0,
      createdAt: DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()).toString(),
    );
    debugPrint('file yangdi edit: ${jsonEncode(activity6Attachments.value.last)}');
  }

}