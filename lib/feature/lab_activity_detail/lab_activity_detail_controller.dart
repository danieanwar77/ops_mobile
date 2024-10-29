import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity6.dart';
import 'package:ops_mobile/data/model/jo_send_model.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity_lab.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity_lab5.dart';
import 'package:ops_mobile/data/model/response_jo_insert_activity5.dart';
import 'package:ops_mobile/data/model/response_jo_insert_activity5_lab.dart';
import 'package:ops_mobile/data/model/response_jo_insert_activity_lab.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory_activity.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory_activity_stages.dart';
import 'package:ops_mobile/data/sqlite.dart';

import 'package:ops_mobile/data/model/login_data_model.dart';
import 'package:ops_mobile/utils/helper.dart';

class LabActivityDetailController extends BaseController {
  // Data User
  Rx<Data?> userData = Rx(Data());

  // Settings
  late int id;
  late int labId;
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
  RxInt adddailyActivityLabPhotosCount = RxInt(1);

  // Activity Lab Variables & Temporary
  RxList<ActivityLab> activityLabList = RxList();
  RxList<ActivityLab> activityLabListStages = RxList();
  TextEditingController activityDate = TextEditingController();
  TextEditingController activityStartTime = TextEditingController();
  TextEditingController activityEndTime = TextEditingController();
  TextEditingController activityText = TextEditingController();
  TextEditingController activityRemarks = TextEditingController();
  RxBool editActivityMode = false.obs;
  RxInt editActivityIndex = 0.obs;
  RxInt editActivityHeader = 0.obs;

  // Activity 5 Lab Variables & Temporary
  RxList<ActivityAct5Lab> activity5LabList = RxList();
  RxList<ActivityAct5Lab> activity5LabListStages = RxList();
  RxList<TextEditingController> activityLabListTextController = RxList();
  TextEditingController sampleReceived = TextEditingController();
  TextEditingController samplePreparation = TextEditingController();
  TextEditingController sampleAnalyzed = TextEditingController();

  // Activity 6 Lab Variables & Temporary
  Rx<DataListActivity6> dataListActivity6 = Rx(DataListActivity6());
  Rx<Activity6Attachments> dataListActivity6Attachments = Rx(Activity6Attachments());

  // Activity 6 Lab Variables & Temporary
  RxList<Activity> activity6List = RxList();
  RxList<Activity> activity6ListStages = RxList();
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
  RxList<File> activity6Attachments = RxList();
  RxList<File> activity6AttachmentsStage = RxList();

  // Data model
  Rx<TDJoLaboratory> joLaboratory = Rx(TDJoLaboratory.new());
  RxList<TDJoLaboratoryActivityStages> stageList = RxList();
  RxList<TDJoLaboratoryActivityStages> stageListModal = RxList();
  RxBool enabledDate = RxBool(true);


  @override
  void onInit() async {
    //userData.value = Data.fromJson(jsonDecode(await StorageCore().storage.read('login')));
    var dataUser = await SqlHelper.getUserDetail('1234');
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

    var argument = await Get.arguments;
    id = argument['id'];
    labId = argument['labId'];
    debugPrint('print arguments idJO = $id, labId = $labId');
    isLoading == true;
    await getData();
    update();
    super.onInit();
  }

  // Get Data

  Future<void> getData() async {
    await getLaboratory(id, labId);
    await getListActivity();
    // await getJoDailyActivityLab();
    // await getJoDailyActivityLab5();
    // await getJoDailyActivityLab6();
    isLoading == false;
    update();
  }

  getLaboratory(int idJo, int idLab) async {
    final db = await SqlHelper.db();
    List<Map<String, dynamic>> rsltLab = await db.rawQuery('''
    SELECT a.*, b.name as laboratorium_name from t_d_jo_laboratory as a 
      left join m_laboratorium as b on a.laboratorium_id = b.id 
      where 
        a.t_h_jo_id = ?
      and 
        a.laboratorium_id = ?;
   ''', [idJo, idLab]);

    if (rsltLab.isNotEmpty) {
      joLaboratory.value = TDJoLaboratory.fromJson(rsltLab.first);
      update();
    }
    debugPrint("print jo laboratory ${jsonEncode(joLaboratory.value)}");
  }

  getListActivity() async {
    final db = await SqlHelper.db();
    List<Map<String, dynamic>> rsltLabStages = await db.rawQuery('''
    SELECT a.* from t_d_jo_laboratory_activity_stages as a 
        left join t_d_jo_laboratory  as b on a.d_jo_laboratory_id = b.id 
      where 
        b.t_h_jo_id = ?
      and 
        b.laboratorium_id = ? and a.is_active = 1
       order by a.id
    ''', [id, labId]);
    List<Map<String, dynamic>> mutableRsltLabStages = rsltLabStages.map((e) => Map<String, dynamic>.from(e)).toList();

    for (var iLabStage in mutableRsltLabStages) {
      List<Map<String, dynamic>> rsltLabActs = await db.rawQuery('''
        SELECT * from t_d_jo_laboratory_activity 
          where 
            t_d_jo_laboratory_activity_stages_id = ? 
          and 
            t_d_jo_laboratory_id = ? and is_active = 1
        ''', [iLabStage['id'], joLaboratory.value.id]);
      iLabStage['list_lab_activity'] = rsltLabActs;
      if (iLabStage['m_statuslaboratoryprogres_id'] == 6) {
        List<Map<String, dynamic>> rsltLabAttachs = await db.rawQuery('''
          SELECT * from t_d_jo_laboratory_attachment
            where 
              t_d_jo_laboratory_id = ? 
            and 
              is_active = 1
            and 
              m_statuslaboratoryprogres_id = 6
          ''', [joLaboratory.value.id]);
        iLabStage['list_lab_attachment'] = rsltLabAttachs;
      }
    }
    List<TDJoLaboratoryActivityStages> listLabStages = mutableRsltLabStages.map((item) => TDJoLaboratoryActivityStages.fromJson(item)).toList();
    stageList.value = listLabStages;
    update();
    debugPrint("print jo lab ${jsonEncode(listLabStages)}");
  }

  Future<void> getJoDailyActivityLab() async {
    var response = await repository.getJoListDailyActivityLab(id, labId) ?? JoListDailyActivityLab();
    debugPrint('Jo Daily Activity Lab: ${jsonEncode(response)}');
    dataListActivityLab.value = response?.data?.data ?? [];
    if (dataListActivityLab.value.isNotEmpty) {
      dataListActivityLab.value.forEach((item) {
        activityLabListStages.value.add(ActivityLab(
          tHJoId: id,
          tDJoLaboratoryId: item.dJoLaboratoryId,
          mStatuslaboratoryprogresId: item.mStatuslaboratoryprogresId,
          transDate: item.transDate,
          startActivityTime: item.startActivityTime,
          endActivityTime: item.endActivityTime,
          activity: item.activity,
          createdBy: 0,
          remarks: item.remarks,
        ));
      });
    }
    activityLabStage = activityLabStage + int.parse(activityLabListStages.value.last.mStatuslaboratoryprogresId.toString());
    update();
  }

  Future<void> getJoDailyActivityLab5() async {
    var response = await repository.getJoListDailyActivityLab5(6) ?? JoListDailyActivityLab5();
    debugPrint('JO Daily Activity Lab 5: ${jsonEncode(response)}');
    dataListActivityLab5.value = response?.data?.data ?? [];
    if (dataListActivityLab5.value.isNotEmpty) {
      dataListActivityLab5.value.forEach((item) {
        activity5LabListStages.value.add(ActivityAct5Lab(
          tHJoId: id,
          tDJoLaboratoryId: labId,
          mStatuslaboratoryprogresId: item.mStatuslaboratoryprogresId,
          transDate: item.transDate,
          startActivityTime: item.startActivityTime,
          endActivityTime: item.endActivityTime,
          totalSampleReceived: int.parse(item.totalSampleReceived.toString()),
          totalSampleAnalyzed: int.parse(item.totalSampleAnalyzed.toString()),
          totalSamplePreparation: int.parse(item.totalSamplePreparation.toString()),
          createdBy: 0,
        ));
      });
    }
    countPrelimTat();
    activityLabStage++;
    update();
  }

  Future<void> getJoDailyActivityLab6() async {}

  // Settings

  void countPrelimTat() {
    prelim.value = activity5LabListStages.value.first.transDate ?? '';
    var dateFormat = DateFormat('yyyy-MM-dd');
    var format = DateFormat('HH:mm');
    var startDate = dateFormat.parse(activityLabListStages.value.first.transDate!);
    var endDate = dateFormat.parse(activity5LabListStages.value.first.transDate!);

    if (startDate == endDate) {
      var startDateTime = format.parse(activityLabListStages.value.first.startActivityTime!);
      var endDateTime = format.parse(activity5LabListStages.value.first.endActivityTime!);
      var countHours = getDiffHours(startDateTime, endDateTime);
      debugPrint('check count hours $countHours');
      tat.value = countHours;
    } else {
      var startDateTime = format.parse(activityLabListStages.value.first.startActivityTime!);
      var endDateTime = format.parse(activity5LabListStages.value.first.endActivityTime!);
      var startHourDay = format.parse('24:00:00');
      var endHourDay = format.parse('00:00:00');

      var startEndHour = getDiffHours(startDateTime, startHourDay);
      var endEndHour = getDiffHours(endHourDay, endDateTime);

      var difference = daysBetween(startDate, endDate);
      var countHours = 0;

      countHours = ((difference - 2) * 24) + (startEndHour + endEndHour);

      // debugPrint('check > start : $startEndHour, end: $endEndHour');
      // debugPrint('check count hours $countHours');

      tat.value = countHours;
    }
  }

  int getDiffHours(DateTime start, DateTime end) {
    Duration diff = end.difference(start);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    //debugPrint('$hours hours $minutes minutes');
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

  void adddailyActivityLabPhotos(File foto) {
    dailyActivityLabPhotos.value.add(foto);
  }

  void removePhotoActivity() {
    dailyActivityLabPhotos.value.removeLast();
    adddailyActivityLabPhotosCount.value--;
    update();
  }

  // Activity Lab Functions

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked =
        await showDatePicker(context: context, firstDate: DateTime.now().subtract(Duration(days: 1)), lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1));
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

  // > Add Functions

  void addActivity() {
    // if (activityLabList.value.isEmpty) {
    //   activityLabListTextController.value.add(TextEditingController());
    // } else {
    //   if (activityLabList.value.last.transDate != activityDate.text) {
    //     activityLabListTextController.value.add(TextEditingController());
    //   }
    // }

    TDJoLaboratoryActivity activity = new TDJoLaboratoryActivity(
      id: DateTime.now().millisecondsSinceEpoch, //Date now to int
      activity: activityText.text,
      endActivityTime: activityEndTime.text,
      startActivityTime: activityStartTime.text,
    );

    List<TDJoLaboratoryActivity> listActivity = [];
    listActivity.add(activity);

    List<TDJoLaboratoryActivityStages> oldTdJoInspections = stageListModal.value;

    TDJoLaboratoryActivityStages? matchingStage = oldTdJoInspections.firstWhere(
      (stage) => stage.transDate == activityDate.text,
      orElse: () => TDJoLaboratoryActivityStages(),
    );

    debugPrint('print jo lab   ${jsonEncode(matchingStage.toJson())}');
    if (matchingStage.transDate != null && matchingStage.transDate.toString() != "") {
      matchingStage.listLabActivity?.add(activity);
      debugPrint("print data matchingStage ${jsonEncode(matchingStage)}");
    } else {
      TDJoLaboratoryActivityStages stages = new TDJoLaboratoryActivityStages(transDate: activityDate.text, mStatuslaboratoryprogresId: activityLabStage, listLabActivity: listActivity);
      stageListModal.add(stages);
      activityLabListTextController.value.add(TextEditingController());
    }
    update();

    cleanFormDialog();
    update();

    debugPrint("print activity ${jsonEncode(listActivity)}");
    debugPrint('print activity stage: ${jsonEncode(stageListModal)}');
  }

  void cleanFormDialog() {
    // activityDate.text = '';
    // activityStartTime.text = '';
    // activityEndTime.text = '';
    // activityText.text = '';
  }

  void toggleEditActivity(int index) {
    activityDate.text = activityLabList.value[index].transDate!;
    activityStartTime.text = activityLabList.value[index].startActivityTime!;
    activityEndTime.text = activityLabList.value[index].endActivityTime!;
    activityText.text = activityLabList.value[index].activity!;
    editActivityMode.value = true;
    editActivityIndex.value = index;
    update();
  }

  void editActivity() {
    List<TDJoLaboratoryActivityStages> joLabActStages = stageListModal.value
        .map((stage) => stage.copyWith())
        .toList();
    List<TDJoLaboratoryActivity> joLabActList = joLabActStages[editActivityHeader.value].listLabActivity ??  [];
    TDJoLaboratoryActivity jobLacAct = joLabActList[editActivityIndex.value];
    jobLacAct.activity = activityText.text;
    jobLacAct.endActivityTime= activityEndTime.text;
    jobLacAct.startActivityTime = activityStartTime.text;

    //Asign to list header
    joLabActStages[editActivityHeader.value].listLabActivity![editActivityIndex.value] = jobLacAct;
    stageListModal.value = joLabActStages;

    cleanFormDialog();
    editActivityIndex.value = 0;
    editActivityHeader.value = 0;
    editActivityMode.value = false;
    enabledDate.value = true;
    update();
  }

  Future<String?> saveStageLab() async {
    try {
      // Your logic here
      final db = await SqlHelper.db();
      List<TDJoLaboratoryActivityStages> stages = stageListModal.value;
      final createdBy = userData.value!.id;
      debugPrint("print jo id ${id}");
      debugPrint("print jo lab ${jsonEncode(joLaboratory.value)}");
      TDJoLaboratory joLab = joLaboratory.value;
      stages.asMap().forEach((index, stage) async {
        debugPrint("print jo lab stage ${jsonEncode(stage)}");
        TDJoLaboratoryActivityStages labStage = TDJoLaboratoryActivityStages(
          dJoLaboratoryId: joLab.id,
          tHJoId: joLab.tHJoId,
          mStatuslaboratoryprogresId: activityLabStage,
          transDate: stage.transDate,
          remarks: activityLabListTextController.value[index].text,
          createdBy: createdBy,
          //updatedBy: createdBy,
          createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
          code: "JOLAS-${activityLabStage}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}",
          isActive: 1,
          isUpload: 0,
        );
        int rsltLabStage = await db.insert("t_d_jo_laboratory_activity_stages", labStage.toInsert());

        List<TDJoLaboratoryActivity> labActs = stage.listLabActivity ?? [];
        labActs.forEach((iActivity) async {
          TDJoLaboratoryActivity labActivity = TDJoLaboratoryActivity(
            tDJoLaboratoryActivityStagesId: rsltLabStage,
            tDJoLaboratoryId: joLab.id,
            startActivityTime: iActivity.startActivityTime ?? '',
            endActivityTime: iActivity.endActivityTime ?? '',
            activity: iActivity.activity ?? '',
            code: "JOLA-${activityLabStage}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}",
            isActive: 1,
            isUpload: 0,
            createdBy: createdBy,
            createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
          );

          await db.insert("t_d_jo_laboratory_activity",labActivity.toJson());
        });
      });
      return 'success';
    } catch (e) {
      debugPrint("print error insert ${e}");
      return 'failed';
    }
  }

  void drawerDailyActivityLabEdit(int statuslaboratoryprogres) {
    List<TDJoLaboratoryActivityStages> joLabActStages = stageList.value
        .map((stage) => stage.copyWith())
        .toList();
    debugPrint("print stageList ${stageListModal.value}");
    List<TDJoLaboratoryActivityStages> filterLabActStage = joLabActStages.where((iLabActStage) => iLabActStage.mStatuslaboratoryprogresId == statuslaboratoryprogres).toList();
    activityLabListTextController.value = [];
    filterLabActStage.forEach((itemLab) {
      activityLabListTextController.value.add(TextEditingController(text: itemLab.remarks));
    });
    stageListModal.value = filterLabActStage;
    update();
    debugPrint("print stageListModal ${jsonEncode(stageListModal.value)}");
    Get.bottomSheet(
        GetBuilder(
          init: LabActivityDetailController(),
          builder: (controller) => Container(
              margin: EdgeInsets.only(top: 48),
              padding: EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))),
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
                              'Edit Stage Laboratory',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: primaryColor),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Stage ${activityLabStage}: ${labStagesName[activityLabStage - 1]}',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
                                          onTap: () async {
                                            activityEndTime.text = await selectTime(Get.context!);
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
                                              labelText: 'End Time*',
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
                                          borderSide: const BorderSide(color: onFocusColor),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        labelText: 'Activity*',
                                        floatingLabelStyle: const TextStyle(color: onFocusColor),
                                        fillColor: onFocusColor),
                                  ),
                                ],
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
                                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8)),
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
                            controller.stageListModal.value.isNotEmpty
                                ? ListView.builder(
                              itemCount: controller.stageListModal.value.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                TDJoLaboratoryActivityStages stage = controller.stageListModal.value[index];
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
                                                                //deleteActivityHeaderV2(stage!.transDate!);
                                                                removeActivityByDateConfirm(stage!.transDate!,index,0);
                                                              },
                                                              child: const Icon(Icons.delete_forever, color: Colors.red),
                                                            )
                                                          ],
                                                        )
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemCount: stage.listLabActivity!.length ?? 0,
                                                    itemBuilder: (context, indexDetail) {
                                                      TDJoLaboratoryActivity activity = stage.listLabActivity![indexDetail];
                                                      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              'Activities',
                                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                                            )),
                                                        VerticalDivider(
                                                          width: 1,
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Text('${Helper.formatToHourMinute(activity!.startActivityTime!)} - ${Helper.formatToHourMinute(activity!.endActivityTime!)}',
                                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700))),
                                                        const VerticalDivider(
                                                          width: 1,
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Expanded(
                                                            flex: 2,
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    activity.activity ?? '-',
                                                                    style: TextStyle(fontSize: 14),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    debugPrint('Edit');
                                                                    editActivityDetailV2(stage!.transDate!, index,indexDetail);
                                                                  },
                                                                  child: Icon(
                                                                    Icons.mode_edit_outlined,
                                                                    color: primaryColor,
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    debugPrint('Hapus detail');
                                                                    //deleteActivityDetailV2(stage!.transDate!, activity!.activity!);
                                                                    removeActivityConfirm(stage!.transDate!,indexDetail,index,0);
                                                                  },
                                                                  child: Icon(
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
                                                  controller: activityLabListTextController[index],
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
                                            )
                                        )
                                    )
                                  ],
                                );
                              },
                            )
                                : SizedBox()
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
                                  backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  width: double.infinity,
                                  child: Center(
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
                                editActivityLabStageConfirm();
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  width: double.infinity,
                                  child: Center(
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

  void drawerDailyActivityLab() {
    Get.bottomSheet(
        GetBuilder(
          init: LabActivityDetailController(),
          builder: (controller) => Container(
              margin: EdgeInsets.only(top: 48),
              padding: EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))),
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
                              'Add Stage Laboratory',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: primaryColor),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Stage ${activityLabStage}: ${labStagesName[activityLabStage - 1]}',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
                                          onTap: () async {
                                            activityEndTime.text = await selectTime(Get.context!);
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
                                              labelText: 'End Time*',
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
                                          borderSide: const BorderSide(color: onFocusColor),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        labelText: 'Activity*',
                                        floatingLabelStyle: const TextStyle(color: onFocusColor),
                                        fillColor: onFocusColor),
                                  ),
                                ],
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
                                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8)),
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
                            controller.stageListModal.value.isNotEmpty
                                ? ListView.builder(
                              itemCount: controller.stageListModal.value.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                TDJoLaboratoryActivityStages stage = controller.stageListModal.value[index];
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
                                                                //deleteActivityHeaderV2(stage!.transDate!);
                                                                removeActivityByDateConfirm(stage!.transDate!,index,0);
                                                              },
                                                              child: const Icon(Icons.delete_forever, color: Colors.red),
                                                            )
                                                          ],
                                                        )
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemCount: stage.listLabActivity!.length ?? 0,
                                                    itemBuilder: (context, indexDetail) {
                                                      TDJoLaboratoryActivity activity = stage.listLabActivity![indexDetail];
                                                      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              'Activities',
                                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                                            )),
                                                        VerticalDivider(
                                                          width: 1,
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Text('${Helper.formatToHourMinute(activity!.startActivityTime!)} - ${Helper.formatToHourMinute(activity!.endActivityTime!)}',
                                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700))),
                                                        const VerticalDivider(
                                                          width: 1,
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Expanded(
                                                            flex: 2,
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    activity.activity ?? '-',
                                                                    style: TextStyle(fontSize: 14),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    debugPrint('Edit');
                                                                    editActivityDetailV2(stage!.transDate!, index,indexDetail);
                                                                  },
                                                                  child: Icon(
                                                                    Icons.mode_edit_outlined,
                                                                    color: primaryColor,
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    debugPrint('Hapus detail');
                                                                    //deleteActivityDetailV2(stage!.transDate!, activity!.activity!);
                                                                    removeActivityConfirm(stage!.transDate!,indexDetail,index,0);
                                                                  },
                                                                  child: Icon(
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
                                                  controller: activityLabListTextController[index],
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
                                            )
                                        )
                                    )
                                  ],
                                );
                              },
                            )
                                : SizedBox()
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
                                  backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  width: double.infinity,
                                  child: Center(
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
                                addActivityLabStageConfirm();
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  width: double.infinity,
                                  child: Center(
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

  // END CRUD

  void editActivityRemarks(String date, String val, int index) {
    final TextEditingController remarksController = activityLabListTextController[index];
    debugPrint('text controller value : ${remarksController.text}');
    for (var i = 0; i < activityLabList.value.length; i++) {
      if (activityLabList.value[i].transDate.toString() == date) {
        activityLabList.value[i] = ActivityLab(
          tHJoId: id,
          tDJoLaboratoryId: activityLabList.value[i].tDJoLaboratoryId,
          mStatuslaboratoryprogresId: activityLabStage,
          transDate: activityLabList.value[i].transDate,
          startActivityTime: activityLabList.value[i].startActivityTime,
          endActivityTime: activityLabList.value[i].endActivityTime,
          activity: activityLabList.value[i].activity,
          createdBy: activityLabList.value[i].createdBy,
          remarks: remarksController.text,
        );
      }
    }
  }

  void checkActivityList() {
    debugPrint('activities now: ${jsonEncode(activityLabList.value)}');
  }

  Future<void> removeActivity(int indexDetail, int indexHeader, int stage,String date) async {
    List<TDJoLaboratoryActivityStages> joLabActStages = stageListModal.value
        .map((stage) => stage.copyWith())
        .toList();
    List<TDJoLaboratoryActivity> joLabAct = joLabActStages[indexHeader].listLabActivity ??  [];
    joLabAct.removeAt(indexDetail);
    joLabActStages[indexHeader].listLabActivity = joLabAct;

    //joLabActStages.removeWhere((item) => item.transDate == date);
    stageListModal.value = joLabActStages;
    //activityLabList.value.removeWhere((item) => item.transDate == date && item.mStatuslaboratoryprogresId == stage);

    update();
  }

  Future<void> removeActivityByDate(String date, int indexDate, int stage) async {
    List<TDJoLaboratoryActivityStages> joLabActStages = stageListModal.value
        .map((stage) => stage.copyWith())
        .toList();
    joLabActStages.removeWhere((item) => item.transDate == date);
    stageListModal.value = joLabActStages;
    //activityLabList.value.removeWhere((item) => item.transDate == date && item.mStatuslaboratoryprogresId == stage);
    activityLabListTextController.value.removeAt(indexDate);
    update();
  }

  Future<void> postInsertActivityLab(data) async {
    var response = await repository.insertActivityLab(data) ?? ResponseJoInsertActivityLab();
    debugPrint('insert activity Lab response: ${jsonEncode(response.message)}');
  }


  void addActivityLabStageConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah benar anda akan submit stage ${labStagesName[activityLabStage - 1]} ini? pastikan data yg anda input benar.'),
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
              var result = await saveStageLab();
              if (result == 'success') {
                Get.back();
                Get.back();
                // if (activityLabStage == 1) {
                //   changeStatusJo();
                // }
                await getListActivity();

                //openDialog("Success", "Activity Stage ${activityLabStage-1} berhasil ditambahkan");
              } else {
                openDialog("Failed", "Activity Stage $activityLabStage masih kosong atau belum diinput");
                Get.back();
              }
            },
          ),
        ],
      ),
    );
  }

  void editActivityDetailV2(String transDate, int indexHeader,int indexDetail) {
    TDJoLaboratoryActivityStages? matchingStage = stageListModal.value.firstWhere(
          (stage) => stage.transDate == transDate,
      orElse: () => TDJoLaboratoryActivityStages(),
    );

    if (matchingStage.transDate != null && matchingStage.transDate.toString() != "") {
      TDJoLaboratoryActivity? matchinAtivity = matchingStage.listLabActivity![indexDetail];

      if (matchinAtivity != null && matchinAtivity.activity.toString() != "") {
        activityDate.text = matchingStage!.transDate!;
        activityStartTime.text = matchinAtivity.startActivityTime!;
        activityEndTime.text = matchinAtivity.endActivityTime!;
        activityText.text = matchinAtivity.activity!;
        editActivityMode.value = true;
        enabledDate.value = false;
        editActivityIndex.value = indexDetail;
        editActivityHeader.value = indexHeader;
        update();
      }
    }
  }

  void removeActivityConfirm(String date, int indexDetail, int indexHeader, int stage) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
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
              await removeActivity(indexDetail, indexHeader, stage,date);
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
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

  // > Update Functions

  Future<String?> editActivityStages() async {
    try {
      final db = await SqlHelper.db();
      final createdBy = userData.value!.id;
      TDJoLaboratory joLab = joLaboratory.value;
      List<TDJoLaboratoryActivityStages> joLabActStages = stageListModal.value
          .map((stage) => stage.copyWith())
          .toList();

      int resultDeactive = await db.update(
          "t_d_jo_laboratory_activity_stages",
          {"is_active": 0},
          whereArgs: [activityLabStage, joLab.id],
          where: "m_statuslaboratoryprogres_id = ? and d_jo_laboratory_id = ?"
      );

      joLabActStages.asMap().forEach((index, stage) async {
        debugPrint("print data lab stage ${jsonEncode(stage)}");

        if (stage.id != null) {
          int resultDeactiveDetail = await db.update(
              "t_d_jo_laboratory_activity",
              {"is_active": 0},
              whereArgs: [stage.id],
              where: "t_d_jo_laboratory_activity_stages_id = ?"
          );

          TDJoLaboratoryActivityStages dataStage = TDJoLaboratoryActivityStages(
              dJoLaboratoryId: stage.dJoLaboratoryId,
              tHJoId: stage.tHJoId,
              remarks: activityLabListTextController.value[index].text,
              updatedBy: createdBy,
              updatedAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
              isActive: 1,
              isUpload: 0
          );

          await db.update(
              "t_d_jo_laboratory_activity_stages",
              dataStage.toEdit(),
              where: "id = ?",
              whereArgs: [stage.id]
          );

          List<TDJoLaboratoryActivity> labActs = stage.listLabActivity ?? [];
          List<TDJoLaboratoryActivity> labActsWithNullId = labActs.where((activity) => activity.tDJoLaboratoryActivityStagesId == null).toList();
          List<TDJoLaboratoryActivity> labActsWithNotNull = labActs.where((activity) => activity.tDJoLaboratoryActivityStagesId != null).toList();
          labActsWithNullId.forEach((labAct) async {
            TDJoLaboratoryActivity labActivity = TDJoLaboratoryActivity(
              tDJoLaboratoryActivityStagesId: stage.id,
              tDJoLaboratoryId: joLab.id,
              startActivityTime: labAct.startActivityTime ?? '',
              endActivityTime: labAct.endActivityTime ?? '',
              activity: labAct.activity ?? '',
              code: "JOLA-${activityLabStage}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}",
              isActive: 1,
              isUpload: 0,
              createdBy: createdBy,
              createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
            );

            await db.insert("t_d_jo_laboratory_activity",labActivity.toJson());
          });
          labActsWithNotNull.forEach((lacActEdt) async{
            TDJoLaboratoryActivity labActivity = TDJoLaboratoryActivity(
              tDJoLaboratoryActivityStagesId: stage.id,
              tDJoLaboratoryId: joLab.id,
              startActivityTime: lacActEdt.startActivityTime ?? '',
              endActivityTime: lacActEdt.endActivityTime ?? '',
              activity: lacActEdt.activity ?? '',
              code: "JOLA-${activityLabStage}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}",
              isActive: 1,
              isUpload: 0,
              createdBy: createdBy,
              createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
            );

            await db.update("t_d_jo_laboratory_activity",labActivity.toEdit(),where: "id = ?",whereArgs: [lacActEdt.id]);
          });
        } else {
          // Insert new stage
          TDJoLaboratoryActivityStages labStage = TDJoLaboratoryActivityStages(
            dJoLaboratoryId: joLab.id,
            tHJoId: joLab.tHJoId,
            mStatuslaboratoryprogresId: activityLabStage,
            transDate: stage.transDate,
            remarks: activityLabListTextController.value[index].text,
            createdBy: createdBy,
            createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
            code: "JOLAS-${activityLabStage}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}",
            isActive: 1,
            isUpload: 0,
          );

          int rsltLabStage = await db.insert(
              "t_d_jo_laboratory_activity_stages",
              labStage.toInsert()
          );

          List<TDJoLaboratoryActivity> labActs = stage.listLabActivity ?? [];
          labActs.forEach((iActivity) async{
            TDJoLaboratoryActivity labActivity = TDJoLaboratoryActivity(
              tDJoLaboratoryActivityStagesId: rsltLabStage,
              tDJoLaboratoryId: joLab.id,
              startActivityTime: iActivity.startActivityTime ?? '',
              endActivityTime: iActivity.endActivityTime ?? '',
              activity: iActivity.activity ?? '',
              code: "JOLA-${activityLabStage}-${createdBy}-${DateFormat('yyyyMMddHms').format(DateTime.now())}",
              isActive: 1,
              isUpload: 0,
              createdBy: createdBy,
              createdAt: DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now()),
            );

            await db.insert("t_d_jo_laboratory_activity",labActivity.toJson());
          });
        }
      });
      cleanFormDialog();
      return 'success';
    } catch (e) {
      return 'failed';
    }
  }


  Future<void> updateInsertActivityLab(data) async {
    var response = await repository.insertActivityLab(data) ?? ResponseJoInsertActivityLab();
    debugPrint('insert activity Lab response: ${jsonEncode(response.message)}');
  }

  void editActivityLabStageConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah benar anda akan menyimpan perubahan stage sample on delivery ini? pastikan data yg anda input benar.'),
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
                Get.back();
                await getListActivity();
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

  void nextStageActivityConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah anda ingin melanjutkan ke stage berikutnya? jika Ya, anda tidak bisa mengubah stage sebelumnya. Pastikan data yang anda input benar.'),
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
    activity5LabListStages.value = [];
    var data = ActivityAct5Lab(
      tHJoId: id,
      tDJoLaboratoryId: labId,
      mStatuslaboratoryprogresId: activityLabStage,
      transDate: '2024-10-03',
      startActivityTime: '02:30:00',
      endActivityTime: '03:30:00',
      totalSampleReceived: int.parse(sampleReceived.text),
      totalSampleAnalyzed: int.parse(sampleAnalyzed.text),
      totalSamplePreparation: int.parse(samplePreparation.text),
      createdBy: userData.value?.id ?? 0,
    );
    activity5LabList.value.add(data);
    // postInsertActivity5Lab(activity5LabList.value);
    activity5LabListStages.value.add(data);
    activitySubmitted.value = true;
    update();
    countPrelimTat();
    return 'success';
  }

  Future<void> postInsertActivity5Lab(data) async {
    var response = await repository.insertActivity5Lab(data) ?? ResponseJoInsertActivity5Lab();
    debugPrint('insert activity 5 Lab response: ${jsonEncode(response.message)}');
  }

  void drawerDailyActivity5Lab() {
    debugPrint('stage lab now: $activityLabStage');
    debugPrint('submit stage state: ${activitySubmitted.value}');
    Get.bottomSheet(
        GetBuilder(
            init: LabActivityDetailController(),
            builder: (controller) => Container(
                  margin: EdgeInsets.only(top: 48),
                  padding: EdgeInsets.all(24),
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))),
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
                                Text(
                                  'Add Stage Laboratory',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: primaryColor),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  'Stage ${activityLabStage}: ${labStagesName[activityLabStage - 1]}',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  inputFormatters: [LengthLimitingTextInputFormatter(12), FilteringTextInputFormatter.digitsOnly],
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
                                        borderSide: const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Total sample received*',
                                      floatingLabelStyle: const TextStyle(color: onFocusColor),
                                      fillColor: onFocusColor),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  inputFormatters: [LengthLimitingTextInputFormatter(12), FilteringTextInputFormatter.digitsOnly],
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
                                        borderSide: const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Total sample preparation*',
                                      floatingLabelStyle: const TextStyle(color: onFocusColor),
                                      fillColor: onFocusColor),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  inputFormatters: [LengthLimitingTextInputFormatter(12), FilteringTextInputFormatter.digitsOnly],
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
                                        borderSide: const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Total sample analyzed*',
                                      floatingLabelStyle: const TextStyle(color: onFocusColor),
                                      fillColor: onFocusColor),
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
                                      backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      width: double.infinity,
                                      child: Center(
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
                                      addActivity5LabStageConfirm();
                                      update();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      width: double.infinity,
                                      child: Center(
                                          child: Text(
                                        'Save',
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
        isScrollControlled: true);
  }

  void addActivity5LabStageConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah benar anda akan submit stage issued analyzed result ini? pastikan data yg anda input benar.'),
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
              var result = await addActivity5LabStages();
              if (result == 'success') {
                Get.back();
                Get.back();
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

  // > Edit Functions

  Future<String?> editActivity5LabStages() async {
    activity5LabListStages.value = [];
    var data = ActivityAct5Lab(
      tHJoId: id,
      tDJoLaboratoryId: labId,
      mStatuslaboratoryprogresId: activityLabStage,
      transDate: '2024-10-03',
      startActivityTime: '02:30:00',
      endActivityTime: '03:30:00',
      totalSampleReceived: int.parse(sampleReceived.text),
      totalSampleAnalyzed: int.parse(sampleAnalyzed.text),
      totalSamplePreparation: int.parse(samplePreparation.text),
      createdBy: userData.value?.id ?? 0,
    );
    activity5LabList.value.add(data);
    //updateInsertActivity5Lab(activity5LabList.value);
    activity5LabListStages.value.add(data);
    countPrelimTat();
    return 'success';
  }

  Future<void> updateInsertActivity5Lab(data) async {
    var response = await repository.insertActivity5Lab(data) ?? ResponseJoInsertActivity5Lab();
    debugPrint('insert activity 5 Lab response: ${jsonEncode(response.message)}');
  }

  void drawerDailyActivity5LabEdit() {
    debugPrint('stage lab now: $activityLabStage');
    debugPrint('submit stage state: $activitySubmitted');
    if (activity5LabList.value.isEmpty) {
      var labAct = activity5LabListStages.value.first;
      sampleReceived.text = labAct.totalSampleReceived!.toString();
      sampleAnalyzed.text = labAct.totalSampleAnalyzed!.toString();
      samplePreparation.text = labAct.totalSamplePreparation!.toString();
    }
    Get.bottomSheet(
        GetBuilder(
            init: LabActivityDetailController(),
            builder: (controller) => Container(
                  margin: EdgeInsets.only(top: 48),
                  padding: EdgeInsets.all(24),
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))),
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
                                Text(
                                  'Add Stage Laboratory',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: primaryColor),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  'Stage ${activityLabStage}: ${labStagesName[activityLabStage - 1]}',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  inputFormatters: [LengthLimitingTextInputFormatter(12), FilteringTextInputFormatter.digitsOnly],
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
                                        borderSide: const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Total sample received*',
                                      floatingLabelStyle: const TextStyle(color: onFocusColor),
                                      fillColor: onFocusColor),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  inputFormatters: [LengthLimitingTextInputFormatter(12), FilteringTextInputFormatter.digitsOnly],
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
                                        borderSide: const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Total sample preparation*',
                                      floatingLabelStyle: const TextStyle(color: onFocusColor),
                                      fillColor: onFocusColor),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  inputFormatters: [LengthLimitingTextInputFormatter(12), FilteringTextInputFormatter.digitsOnly],
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
                                        borderSide: const BorderSide(color: onFocusColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Total sample analyzed*',
                                      floatingLabelStyle: const TextStyle(color: onFocusColor),
                                      fillColor: onFocusColor),
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
                                      backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      width: double.infinity,
                                      child: Center(
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
                                      editActivity5LabStageConfirm();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      width: double.infinity,
                                      child: Center(
                                          child: Text(
                                        'Save',
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
        isScrollControlled: true);
  }

  void editActivity5LabStageConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah benar anda akan menyimpan perubahan stage issued analyzed result ini? pastikan data yg anda input benar.'),
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
              var result = await editActivity5LabStages();
              if (result == 'success') {
                Get.back();
                Get.back();
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

  void nextStageActivity5LabConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah anda ingin melanjutkan ke stage berikutnya? jika Ya, anda tidak bisa mengubah stage sebelumnya. Pastikan data yang anda input benar.'),
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
    final DateTime? picked =
        await showDatePicker(context: context, firstDate: DateTime.now().subtract(Duration(days: 1)), lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1));
    if (picked != null) {
      activity6Date.text = DateFormat('yyyy-MM-dd').format(picked).toString();
    }
  }

  Future<String> selectTime6(BuildContext context) async {
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

  void addActivity6() {
    debugPrint('activity 6 stage : $activityLabStage');
    if (activity6List.value.isEmpty) {
      activity6ListTextController.value.add(TextEditingController());
    } else {
      if (activity6List.value.last.transDate != activity6Date.text) {
        activity6ListTextController.value.add(TextEditingController());
      }
    }

    activity6List.value.add(Activity(
      tHJoId: id,
      mStatusinspectionstagesId: activityLabStage,
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
      mStatusinspectionstagesId: activityLabStage,
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
    final TextEditingController remarksController = activity6ListTextController[index];
    debugPrint('text controller value : ${remarksController.text}');
    for (var i = 0; i < activity6List.value.length; i++) {
      if (activity6List.value[i].transDate.toString() == date) {
        activity6List.value[i] = Activity(
          tHJoId: id,
          mStatusinspectionstagesId: activity6List.value[i].mStatusinspectionstagesId,
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

  Future<void> removeActivity6(int indexitem, int index, int stage) async {
    debugPrint('index item : ${jsonEncode(activity6List.value)}');
    var dateLength = activity6List.value.where((item) => item.transDate == activity6List.value[indexitem].transDate && item.mStatusinspectionstagesId == stage).length;
    if (dateLength == 1) {
      activity6ListTextController.value.removeAt(index);
    }
    activity6List.value.removeAt(indexitem);
    update();
  }

  Future<void> removeActivity6ByDate(String date, int indexDate, int stage) async {
    activity6List.value.removeWhere((item) => item.transDate == date && item.mStatusinspectionstagesId == stage);
    activity6ListTextController.value.removeAt(indexDate);
    update();
  }

  void removeActivity6Confirm(String date, int indexitem, int index, int stage) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
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
              await removeActivity6(indexitem, index, stage);
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
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
              await removeActivity6ByDate(date, indexDate, stage);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Future<String?> addActivity6Stages() async {
    if (activity6List.value.where((data) => data.mStatusinspectionstagesId == activityLabStage).toList().isNotEmpty) {
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
      activityLabList.value = [];
      activityLabListTextController.value = [];
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
    } else if (activity6List.value.where((data) => data.mStatusinspectionstagesId == activityLabStage).toList().isEmpty) {
      return 'failed';
    }
  }

  Future<void> postInsertActivity6(data) async {
    var response = await repository.insertActivityInspection6(data) ?? ResponseJoInsertActivity5();
    debugPrint('insert activity response: ${jsonEncode(response.message)}');
  }

  void addActivity6Files(File attach) {
    activity6Attachments.value.add(attach);
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
      final FilePickerResult? attach = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);
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
          init: LabActivityDetailController(),
          builder: (controller) => Container(
              margin: EdgeInsets.only(top: 48),
              padding: EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))),
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
                                        activity6StartTime.text = await selectTime6(Get.context!);
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
                                      controller: activity6EndTime,
                                      cursorColor: onFocusColor,
                                      onTap: () async {
                                        activity6EndTime.text = await selectTime6(Get.context!);
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
                                          labelText: 'End Time*',
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
                                controller: activity6Text,
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
                                                padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            'Date',
                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                  onTap: () {
                                                                    removeActivity6ByDateConfirm(activity!, index, 6);
                                                                  },
                                                                  child: Icon(
                                                                    Icons.delete_forever,
                                                                    color: Colors.red,
                                                                  ))
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    ListView.builder(
                                                        shrinkWrap: true,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        itemCount: activity6List.value.length,
                                                        itemBuilder: (context, indexItem) {
                                                          if (activity6List.value[indexItem].transDate == activity) {
                                                            return Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    'Activities',
                                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                                                  ),
                                                                ),
                                                                VerticalDivider(width: 1),
                                                                SizedBox(width: 8),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    '${activity6List.value[indexItem].startActivityTime ?? '-'} - ${activity6List.value[indexItem].endActivityTime ?? '-'}',
                                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
                                                                          activity6List.value[indexItem].activity ?? '-',
                                                                          style: TextStyle(
                                                                            fontSize: 14,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      InkWell(
                                                                          onTap: () {
                                                                            toggleEditActivity6(indexItem);
                                                                          },
                                                                          child: Icon(
                                                                            Icons.mode_edit_outlined,
                                                                            color: primaryColor,
                                                                          )),
                                                                      InkWell(
                                                                          onTap: () {
                                                                            removeActivity6Confirm(activity!, indexItem, index, 6);
                                                                          },
                                                                          child: Icon(
                                                                            Icons.delete_forever,
                                                                            color: Colors.red,
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
                                                      controller: activity6ListTextController.value[index],
                                                      onChanged: (value) {
                                                        debugPrint(value);
                                                        debugPrint('text remarks controller : ${activity6ListTextController.value[index].text}');
                                                        editActivity6Remarks(activity!, value, index);
                                                      },
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(250),
                                                      ],
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
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text('File lampiran maksimal 5 file dengan ukuran total file maksimal 10 MB. Jenis file yang diperbolehkan hanya PDF/JPG/PNG/JPEG.'),
                              const SizedBox(
                                height: 16,
                              ),
                              activity6Attachments.value.isNotEmpty
                                  ? GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                      ),
                                      itemCount: activity6Attachments.value.length,
                                      itemBuilder: (content, index) {
                                        final File photo = activity6Attachments.value[index];
                                        final String fileType = checkFileType(photo.path);
                                        var filenameArr = photo.path.split("/");
                                        var filename = filenameArr.last;
                                        return fileType == 'image'
                                            ? SizedBox(
                                                width: 54,
                                                height: 66,
                                                child: Stack(
                                                  children: [
                                                    SizedBox(
                                                      width: 54,
                                                      height: 54,
                                                      child: InkWell(
                                                        onTap: () {
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
                                                            onPressed: () {
                                                              controller.removeActivity6Files(index);
                                                            },
                                                            icon: Icon(
                                                              Icons.remove_circle,
                                                              size: 12,
                                                              color: Colors.red,
                                                            )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : fileType == 'doc'
                                                ? SizedBox(
                                                    width: 54,
                                                    height: 66,
                                                    child: Stack(
                                                      children: [
                                                        InkWell(
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
                                                                Text(filename, style: TextStyle(fontSize: 8), overflow: TextOverflow.ellipsis)
                                                              ],
                                                            )),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: AlignmentDirectional.topEnd,
                                                          child: SizedBox(
                                                            height: 12,
                                                            child: IconButton(
                                                                padding: EdgeInsets.zero,
                                                                onPressed: () {
                                                                  controller.removeActivity6Files(index);
                                                                },
                                                                icon: Icon(
                                                                  Icons.remove_circle,
                                                                  size: 12,
                                                                  color: Colors.red,
                                                                )),
                                                          ),
                                                        ),
                                                      ],
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
                                        backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
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
                                    backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                                child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    width: double.infinity,
                                    child: Center(
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
                                    child: Center(
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

  void previewImageAct6(int index, String photo) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Text(
              'Attachment ${index + 1}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
            ),
            InkWell(
              onTap: () {
                removeActivity6Files(index);
              },
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
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
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
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
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
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
    activity6List.value = activity6ListStages.value.where((item) => item.mStatusinspectionstagesId == activityLabStage).toList();
    var activityEditTemp = activity6List.value
        .map((item) {
          return item.transDate;
        })
        .toSet()
        .toList();
    activityEditTemp.forEach((item) {
      var text = activity6List.value.lastWhere((act) => act.transDate == item);
      activity6ListTextController.value.add(TextEditingController(text: text.remarks));
    });
    update();
    Get.bottomSheet(
        GetBuilder(
          init: LabActivityDetailController(),
          builder: (controller) => Container(
              margin: EdgeInsets.only(top: 48),
              padding: EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))),
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
                                        activity6StartTime.text = await selectTime6(Get.context!);
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
                                      controller: activity6EndTime,
                                      cursorColor: onFocusColor,
                                      onTap: () async {
                                        activity6EndTime.text = await selectTime6(Get.context!);
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
                                          labelText: 'End Time*',
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
                                  if (editActivityMode.value == false) {
                                    addActivity6();
                                  } else {
                                    editActivity6();
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 8),
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
                                                padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Date',
                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                              ),
                                                              IconButton(
                                                                  onPressed: () {
                                                                    removeActivity6ByDate(activity!, index, 6);
                                                                  },
                                                                  icon: Icon(
                                                                    Icons.delete_forever,
                                                                    color: Colors.red,
                                                                  ))
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    ListView.builder(
                                                        shrinkWrap: true,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        itemCount: activity6List.value.length,
                                                        itemBuilder: (context, indexItem) {
                                                          if (activity6List.value[indexItem].transDate == activity) {
                                                            return Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    'Activities',
                                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                                                  ),
                                                                ),
                                                                VerticalDivider(width: 1),
                                                                SizedBox(width: 8),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    '${activity6List.value[indexItem].startActivityTime ?? '-'} - ${activity6List.value[indexItem].endActivityTime ?? '-'}',
                                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
                                                                          activity6List.value[indexItem].activity ?? '-',
                                                                          style: TextStyle(
                                                                            fontSize: 14,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      InkWell(
                                                                          onTap: () {
                                                                            toggleEditActivity6(indexItem);
                                                                          },
                                                                          child: Icon(
                                                                            Icons.mode_edit_outlined,
                                                                            color: primaryColor,
                                                                          )),
                                                                      InkWell(
                                                                          onTap: () {
                                                                            removeActivity6(indexItem, index, 6);
                                                                          },
                                                                          child: Icon(
                                                                            Icons.delete_forever,
                                                                            color: Colors.red,
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
                                                      controller: activity6ListTextController.value[index],
                                                      onChanged: (value) {
                                                        debugPrint(value);
                                                        debugPrint('text remarks controller : ${activity6ListTextController.value[index].text}');
                                                        editActivity6Remarks(activity!, value, index);
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
                                                          labelText: 'Remarks',
                                                          floatingLabelStyle: const TextStyle(color: onFocusColor),
                                                          fillColor: onFocusColor),
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
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text('File lampiran maksimal 5 file dengan ukuran total file maksimal 10 MB. Jenis file yang diperbolehkan hanya PDF/JPG/PNG/JPEG.'),
                              const SizedBox(
                                height: 16,
                              ),
                              activity6Attachments.value.isNotEmpty
                                  ? GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                      ),
                                      itemCount: activity6Attachments.value.length,
                                      itemBuilder: (content, index) {
                                        final File photo = activity6Attachments.value[index];
                                        final String fileType = checkFileType(photo.path);
                                        var filenameArr = photo.path.split("/");
                                        var filename = filenameArr.last;
                                        return fileType == 'image'
                                            ? SizedBox(
                                                width: 54,
                                                height: 66,
                                                child: Stack(
                                                  children: [
                                                    SizedBox(
                                                      width: 54,
                                                      height: 54,
                                                      child: InkWell(
                                                        onTap: () {
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
                                                            onPressed: () {
                                                              controller.removeActivity6Files(index);
                                                            },
                                                            icon: Icon(
                                                              Icons.remove_circle,
                                                              size: 12,
                                                              color: Colors.red,
                                                            )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : fileType == 'doc'
                                                ? SizedBox(
                                                    width: 54,
                                                    height: 66,
                                                    child: Stack(
                                                      children: [
                                                        InkWell(
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
                                                                Text(filename, style: TextStyle(fontSize: 8), overflow: TextOverflow.ellipsis)
                                                              ],
                                                            )),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: AlignmentDirectional.topEnd,
                                                          child: SizedBox(
                                                            height: 12,
                                                            child: IconButton(
                                                                padding: EdgeInsets.zero,
                                                                onPressed: () {
                                                                  controller.removeActivity6Files(index);
                                                                },
                                                                icon: Icon(
                                                                  Icons.remove_circle,
                                                                  size: 12,
                                                                  color: Colors.red,
                                                                )),
                                                          ),
                                                        ),
                                                      ],
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
                                        backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
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
                                    backgroundColor: Colors.white, shape: RoundedRectangleBorder(side: BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(12))),
                                child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    width: double.infinity,
                                    child: Center(
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
                                    editActivity6StageConfirm();
                                  }
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    width: double.infinity,
                                    child: Center(
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

  String? editActivity6Stages() {
    if (activity6List.value.where((data) => data.mStatusinspectionstagesId == activityLabStage).toList().isNotEmpty) {
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
      activityLabList.value = [];
      activityLabListTextController.value = [];
      editActivityMode.value = false;
      activityDate.text = '';
      activityStartTime.text = '';
      activityEndTime.text = '';
      activityText.text = '';

      activitySubmitted.value = true;
      // activityLabStage--;
      update();
      return 'success';
    } else if (activity6List.value.where((data) => data.mStatusinspectionstagesId == activityLabStage).toList().isEmpty) {
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
        title: Text(
          'Attention',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah benar anda akan submit stage report to client ini? pastikan data yg anda input benar.'),
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
                openDialog("Failed", "Activity Stage $activityLabStage gagal diinput");
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah benar anda akan menyimpan perubahan stage report to client ini? pastikan data yg anda input benar.'),
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Apakah benar anda ingin Finish JO Lab ini? pastikan data yg anda input benar, karena anda tidak bisa mengubah data setelah Finish JO'),
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

  void openDialog(String type, String text) {
    Get.dialog(
      AlertDialog(
        title: Text(
          type,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
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
}
