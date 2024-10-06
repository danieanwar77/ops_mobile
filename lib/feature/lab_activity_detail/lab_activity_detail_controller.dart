import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/data/model/jo_send_model.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity_lab.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity_lab5.dart';
import 'package:ops_mobile/data/model/response_jo_insert_activity5_lab.dart';
import 'package:ops_mobile/data/model/response_jo_insert_activity_lab.dart';
import 'package:ops_mobile/data/storage.dart';

import '../../data/model/user_model.dart';

class LabActivityDetailController extends BaseController{

  Rx<Data?> userData = Rx(Data());
  bool isLoading = false;
  RxList<DataActivityLab> dataListActivityLab = RxList();
  RxList<DataActivityLab5> dataListActivityLab5 = RxList();
  RxList<File> dailyActivityLabPhotos = RxList();
  RxInt adddailyActivityLabPhotosCount = RxInt(1);
  RxList<ActivityLab> activityLabList = RxList();
  RxList<ActivityLab> activityLabListStages = RxList();
  RxList<ActivityAct5Lab> activity5LabList = RxList();
  RxList<ActivityAct5Lab> activity5LabListStages = RxList();
  RxList<TextEditingController> activityLabListTextController = RxList();
  int activityLabStage = 1;
  List<String> labStagesName = ['Sample on Delivery', 'Sample Received', 'Preparation for Analyze', 'Analyze on Progress', 'Issued Analyzed Result'];

  late int id;
  late int labId;
  final picker = ImagePicker();
  TextEditingController activityDate = TextEditingController();
  TextEditingController activityStartTime = TextEditingController();
  TextEditingController activityEndTime = TextEditingController();
  TextEditingController activityText = TextEditingController();
  TextEditingController activityRemarks = TextEditingController();
  RxBool editActivityMode = false.obs;
  RxInt editActivityIndex = 0.obs;
  RxString prelim = ''.obs;
  RxInt tat = 0.obs;
  TextEditingController sampleReceived = TextEditingController();
  TextEditingController samplePreparation = TextEditingController();
  TextEditingController sampleAnalyzed = TextEditingController();

  @override
  void onInit() async {
    userData.value = Data.fromJson(jsonDecode(await StorageCore().storage.read('login')));
    var argument = await Get.arguments;
    id = argument['id'];
    labId = argument['labId'];
    debugPrint('arguments lab: id = $id, labId = $labId');
    isLoading == true;
    await getData();
    update();
    super.onInit();
  }

  Future<void> getData() async{
    await getJoDailyActivityLab();
    await getJoDailyActivityLab5();
    isLoading == false;
    update();
  }

  Future<void> getJoDailyActivityLab() async{
    var response = await repository.getJoListDailyActivityLab(id,labId) ?? JoListDailyActivityLab();
    debugPrint('Jo Daily Activity Lab: ${jsonEncode(response)}');
    dataListActivityLab.value = response?.data?.data ?? [];
    if(dataListActivityLab.value.isNotEmpty){
      dataListActivityLab.value.forEach((item){
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
        )
        );
      });
    }
    activityLabStage = activityLabStage + int.parse(activityLabListStages.value.last.mStatuslaboratoryprogresId.toString());
    update();
  }

  Future<void> getJoDailyActivityLab5() async{
    var response = await repository.getJoListDailyActivityLab5(6) ?? JoListDailyActivityLab5();
    debugPrint('JO Daily Activity Lab 5: ${jsonEncode(response)}');
    dataListActivityLab5.value = response?.data?.data ?? [];
    if(dataListActivityLab5.value.isNotEmpty){
      dataListActivityLab5.value.forEach((item){
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

  void countPrelimTat(){
    prelim.value = activity5LabListStages.value.first.transDate ?? '';
    var dateFormat = DateFormat('yyyy-MM-dd');
    var format = DateFormat('HH:mm');
    var startDate = dateFormat.parse(activityLabListStages.value.first.transDate!);
    var endDate = dateFormat.parse(activity5LabListStages.value.first.transDate!);

    if(startDate == endDate){
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

  void adddailyActivityLabPhotos(File foto){
    dailyActivityLabPhotos.value.add(foto);
  }

  void removePhotoActivity(){
    dailyActivityLabPhotos.value.removeLast();
    adddailyActivityLabPhotosCount.value--;
    update();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(Duration(days:1)),
        lastDate: DateTime(2101));
    if (picked != null) {
      activityDate.text = DateFormat('yyyy-MM-dd').format(picked).toString();
    }
  }

  Future<String> _selectTime(BuildContext context) async {
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

  void addActivity(){
    if(activityLabList.value.isEmpty){
      activityLabListTextController.value.add(TextEditingController());
    } else {
      if (activityLabList.value.last.transDate != activityDate.text) {
        activityLabListTextController.value.add(TextEditingController());
      }
    }

    activityLabList.value.add(ActivityLab(
      tHJoId: id,
      tDJoLaboratoryId: labId,
      mStatuslaboratoryprogresId: activityLabStage,
      transDate: activityDate.text,
      startActivityTime: activityStartTime.text,
      endActivityTime: activityEndTime.text,
      activity: activityText.text,
      createdBy: userData.value?.id ?? 0,
      remarks: '',
    ));

    activityDate.text = '';
    activityStartTime.text = '';
    activityEndTime.text = '';
    activityText.text = '';
    update();

    debugPrint('activities: ${jsonEncode(activityLabList)}');
  }

  void toggleEditActivity(int index){
    activityDate.text = activityLabList.value[index].transDate!;
    activityStartTime.text = activityLabList.value[index].startActivityTime!;
    activityEndTime.text = activityLabList.value[index].endActivityTime!;
    activityText.text = activityLabList.value[index].activity!;
    editActivityMode.value = true;
    editActivityIndex.value = index;
    update();
  }

  void editActivity(){
    activityLabList.value[editActivityIndex.value] = ActivityLab(
      tHJoId: id,
      tDJoLaboratoryId: labId,
      mStatuslaboratoryprogresId: activityLabStage,
      transDate: activityDate.text,
      startActivityTime: activityStartTime.text,
      endActivityTime: activityEndTime.text,
      activity: activityText.text,
      remarks: '',
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
    for (var i = 0; i < activityLabList.value.length; i++){
      if(activityLabList.value[i].transDate.toString() == date){
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

  void checkActivityList(){
    debugPrint('activities now: ${jsonEncode(activityLabList.value)}');
  }

  void removeActivity(int indexitem, int index){
    var dateLength = activityLabList.value.where((item) => item.transDate == activityLabList.value[indexitem].transDate).length;
    if(dateLength == 1){
      activityLabListTextController.value.removeAt(index);
    }
    activityLabList.value.removeAt(indexitem);
    update();
  }

  Future<String?> addActivityStages() async {
    if(activityLabList.value.where((data) => data.mStatuslaboratoryprogresId == activityLabStage).toList().isNotEmpty){
      activityLabStage++;
      postInsertActivityLab(activityLabList.value);
      for(var item in activityLabList.value){
        activityLabListStages.value.add(item);
      }
      activityLabList.value = [];
      activityLabListTextController.value = [];
      editActivityMode.value = false;
      activityDate.text = '';
      activityStartTime.text = '';
      activityEndTime.text = '';
      activityText.text = '';
      update();
      return 'success';
    } else if(activityLabList.value.where((data) => data.mStatuslaboratoryprogresId == activityLabStage).toList().isEmpty) {
      return 'failed';
    }
  }

  Future<void> postInsertActivityLab(data) async {
    var response = await repository.insertActivityLab(data) ?? ResponseJoInsertActivityLab();
    debugPrint('insert activity Lab response: ${jsonEncode(response.message)}');
  }

  void drawerDailyActivityLab(){
    Get.bottomSheet(
        GetBuilder(
          init: LabActivityDetailController(),
          builder: (controller) => Container(
              margin: EdgeInsets.only(top: 24),
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
                            showCursor: true,
                            readOnly: true,
                            controller: activityDate,
                            cursorColor: onFocusColor,
                            onTap: (){
                              _selectDate(Get.context!);
                            },
                            style: const TextStyle(color: onFocusColor),
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: (){
                                      _selectDate(Get.context!);
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
                                  onTap: () async {
                                    activityStartTime.text = await _selectTime(Get.context!);
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
                                  onTap: () async {
                                    activityEndTime.text = await _selectTime(Get.context!);
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
                                      labelText: 'End Time*',
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
                          const SizedBox(height: 16,),
                          InkWell(
                            onTap: (){
                              if(editActivityMode.value == false){
                                addActivity();
                              } else {
                                editActivity();
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
                                child: Icon(Icons.add,
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
                              itemBuilder: (context, index)
                              { var activity = activityLabList.value.map((item){return item.transDate;}).toSet().toList()[index];
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
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: activityLabList.value.length,
                                              itemBuilder: (context, indexItem){
                                                if(activityLabList.value[indexItem].transDate == activity){
                                                  return Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          'Activities',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w700),
                                                        ),
                                                      ),
                                                      VerticalDivider(width: 1),
                                                      SizedBox(width: 8),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          '${activityLabList.value[indexItem].startActivityTime ?? '-'} - ${activityLabList.value[indexItem].endActivityTime ?? '-'}',
                                                          style: TextStyle(
                                                              fontSize: 14,
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
                                                            Text(
                                                              activityLabList.value[indexItem].activity ?? '-',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            InkWell(
                                                                onTap: () {
                                                                  toggleEditActivity(indexItem);
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .mode_edit_outlined,
                                                                  color:
                                                                  primaryColor,
                                                                )),
                                                            InkWell(
                                                                onTap: () {
                                                                  removeActivity(indexItem, index);
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
                                            controller: activityLabListTextController[index],
                                            onChanged: (value){
                                              debugPrint(value);
                                              debugPrint('text remarks controller : ${activityLabListTextController[index].text}');
                                              editActivityRemarks(activity!, value, index);
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
        content: Text('Apakah benar anda akan submit stage sample on delivery ini? pastikan data yg anda input benar.'),
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
              var result = await addActivityStages();
              if(result == 'success'){
                Get.back();
                openDialog("Success", "Activity Stage ${activityLabStage-1} berhasil ditambahkan");
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

  Future<String?> addActivity5LabStages() async {
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
    postInsertActivity5Lab(activity5LabList.value);
    activity5LabListStages.value.add(data);
    countPrelimTat();
    return 'success';
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
              padding: EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))
              ),
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
                              addActivity5LabStageConfirm();
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
              )
          ),
        isScrollControlled: true
    );
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
        content: Text('Apakah benar anda akan menyimpan perubahan stage issued analyzed result ini? pastikan data yg anda input benar.'),
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
              var result = await addActivity5LabStages();
              if(result == 'success'){
                Get.back();
                openDialog("Success", "Activity Stage ${activityLabStage-1} berhasil ditambahkan");
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
}