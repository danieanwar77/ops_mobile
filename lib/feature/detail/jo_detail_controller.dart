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
import 'package:ops_mobile/data/respository/repository.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:ops_mobile/feature/lab_activity_detail/lab_activity_detail_screen.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class JoDetailController extends BaseController {

  Rx<Data?> userData = Rx(Data());

  final PathProviderPlatform providerAndroid = PathProviderPlatform.instance;
  int picInspector = 0;
  int picLaboratory = 0;
  bool isLoadingJO = false;
  Rx<DataDetail> dataJoDetail = Rx(DataDetail());
  Rx<DataPIC> dataJoPIC = Rx(DataPIC());
  RxList<DataDailyPhoto> dataJoDailyPhotos = RxList();
  Rx<DataListActivity> dataListActivity = Rx(DataListActivity());
  Rx<DataListActivity5> dataListActivity5 = Rx(DataListActivity5());
  Rx<DataListActivity6> dataListActivity6 = Rx(DataListActivity6());
  Rx<Activity6Attachments> dataListActivity6Attachments = Rx(Activity6Attachments());
  Rx<DataListActivityLab> dataListActivityLab = Rx(DataListActivityLab());
  Rx<DataListActivityLab5> dataListActivityLab5 = Rx(DataListActivityLab5());
  RxList<String> barges = RxList();
  RxList<String> activity5Barges = RxList();
  RxList<TextEditingController> bargesController = RxList();
  RxList<File> dailyActivityPhotos = RxList();
  RxList<String> dailyActivityPhotosDescText = RxList();
  RxList<TextEditingController> dailyActivityPhotosDesc = RxList();
  RxInt adddailyActivityPhotosCount = RxInt(1);
  Rx<TextEditingController> dailyActivityPhotosDescEdit = TextEditingController().obs;
  RxList<Laboratory> labs = RxList();
  RxList<Activity> activityList = RxList();
  RxList<Activity> activityListStages = RxList();
  RxList<TextEditingController> activityListTextController = RxList();
  int activityStage = 1;
  List<String> activityStages = ['Waiting for Arrival', 'Ship Arrived', 'Ship Berthing', 'Work Commence', 'Work Complete', 'Report to Client'];
  RxInt activity5FormCount = 1.obs;
  RxList<TextEditingController> jettyListTextController = RxList();
  RxList<TextEditingController> initialDateActivity5ListTextController = RxList();
  RxList<TextEditingController> finalDateActivity5ListTextController = RxList();
  RxList<TextEditingController> deliveryQtyListTextController = RxList();
  RxList<FormDataArray> activity5List = RxList();
  RxList<FormDataArray> activity5ListStages = RxList();
  RxList<Transhipment> activity5TranshipmentList = RxList();
  RxList<Activity> activity6List = RxList();
  RxList<Activity> activity6ListStages = RxList();
  RxList<TextEditingController> activity6ListTextController = RxList();
  Rx<TextEditingController> certificateNumberTextController = TextEditingController().obs;
  Rx<TextEditingController> certificateDateTextController = TextEditingController().obs;
  Rx<TextEditingController> certificateBlankoNumberTextController = TextEditingController().obs;
  Rx<TextEditingController> certificateLHVNumberTextController = TextEditingController().obs;
  Rx<TextEditingController> certificateLSNumberTextController = TextEditingController().obs;

  late int id;
  late int statusId;
  final picker = ImagePicker();
  TextEditingController activityDate = TextEditingController();
  TextEditingController activityStartTime = TextEditingController();
  TextEditingController activityEndTime = TextEditingController();
  TextEditingController activityText = TextEditingController();
  TextEditingController activityRemarks = TextEditingController();
  RxBool editActivityMode = RxBool(false);
  RxInt editActivityIndex = 0.obs;
  TextEditingController vesselController = TextEditingController();
  TextEditingController uomController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  int bargesCount = 0;
  int activity5bargesCount = 0;
  TextEditingController activity6Date = TextEditingController();
  TextEditingController activity6StartTime = TextEditingController();
  TextEditingController activity6EndTime = TextEditingController();
  TextEditingController activity6Text = TextEditingController();
  TextEditingController activity6Remarks = TextEditingController();
  RxList<File> activity6Attachments = RxList();
  RxList<File> activity6AttachmentsStage = RxList();

  RxList<Map<String, dynamic>> documentInspection = RxList();
  RxList<File> documentInspectionAttachments = RxList();
  RxList<Map<String, dynamic>> documentLaboratory = RxList();
  RxList<File> documentLaboratoryAttachments = RxList();

  @override
  void onInit()async{
    userData.value = Data.fromJson(jsonDecode(await StorageCore().storage.read('login')));
    debugPrint('data users: ${jsonEncode(userData.value)}');

    var argument = await Get.arguments;
    id = argument['id'];
    statusId = argument['status'];
    isLoadingJO == true;
    await getData();
    update();

    super.onInit();
  }

  Future<void> getData() async{
    await getJoDetail();
    picInspector = int.parse(dataJoDetail.value.detail?.idPicInspector != null ? dataJoDetail.value.detail!.idPicInspector.toString() == userData.value!.id.toString() ? dataJoDetail.value.detail!.idPicInspector.toString() : '0' : '0');
    picLaboratory = int.parse(dataJoDetail.value.detail?.idPicLaboratory != null ? dataJoDetail.value.detail!.idPicLaboratory.toString() == userData.value!.id.toString() ? dataJoDetail.value.detail!.idPicLaboratory.toString() : '0' : '0');
    debugPrint('id pic inspector: $picInspector , laboratory: $picLaboratory');
    await getJoPIC();
    await getJoDailyPhoto();
    await getJoDailyActivity();
    await getJoDailyActivity5();
    await getJoDailyActivity6();
    // await getJoDailyActivityLab();
    // await getJoDailyActivityLab5();
    isLoadingJO == false;
    update();
  }

  Future<void> getJoDetail() async{
    var response = await repository.getJoDetail(id) ?? JoDetailModel();
    debugPrint(jsonEncode(response));
    debugPrint('JO Laboratories: ${jsonEncode(response.data?.laboratory)}');
    dataJoDetail.value = response?.data ?? DataDetail();
    var labo = response.data?.laboratory ?? [];
    barges.value = dataJoDetail.value.detail?.barge?.split('|') ?? [];
    barges.value.forEach((_){
      bargesController.value.add(TextEditingController());
    });
    if(labo!.isNotEmpty){
      labs.value = labo!;
    }
    bargesCount = barges.value.length;
    activity5bargesCount = bargesCount;
    activity5Barges.value = barges.value;
    update();
    debugPrint('barges : ${jsonEncode(barges.value)}');
  }

  Future<void> getJoPIC() async{
    var response = await repository.getJoPIC(id) ?? JoPicModel();
    debugPrint('JO PIC: ${jsonEncode(response)}');
    dataJoPIC.value = response?.data ?? DataPIC();
  }

  Future<void> getJoDailyPhoto() async{
    var response = await repository.getJoDailyPhoto(id) ?? JoDailyPhoto();
    debugPrint('JO Daily Photo: ${jsonEncode(response)}');
    dataJoDailyPhotos.value = response?.data ?? [];
    if(dataJoDailyPhotos.value.isNotEmpty) {
      dataJoDailyPhotos.value.forEach((data) async {
        dailyActivityPhotos.value = [];
        final File photo = await getImagesFromUrl(data.pathPhoto!);
        dailyActivityPhotos.value.add(photo);
        dailyActivityPhotosDescText.value.add(data.keterangan ?? '');
      });
    }
  }

  Future<File> getImagesFromUrl(String strURL) async{
    debugPrint('image path: ${AppConstant.CORE_URL}$strURL');
    final http.Response responseData = await http.get(Uri.parse('${AppConstant.CORE_URL}/$strURL'));
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

  Future<void> getJoDailyActivity() async{
    var response = await repository.getJoListDailyActivity(id) ?? JoListDailyActivity();
    debugPrint('JO Daily Activity: ${jsonEncode(response)}');
    dataListActivity.value = response?.data ?? DataListActivity();
    if(dataListActivity.value.data!.isNotEmpty){
      debugPrint('stage now: ${dataListActivity.value.data!.last.mStatusinspectionstagesId.toString()}');
      activityStage = int.parse(dataListActivity.value.data!.last.mStatusinspectionstagesId.toString()) + 1;
    }
    dataListActivity.value.data?.forEach((data){
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

    }
    );
    // activityList.value.map((item){return item.transDate;}).toSet().toList().forEach((_){
    //     activityListTextController.value.add(TextEditingController());
    // });
  }

  Future<void> getJoDailyActivity5() async{
    var response = await repository.getJoListDailyActivity5(id) ?? JoListDailyActivity5();
    debugPrint('JO Daily Activity 5: ${jsonEncode(response)}');
    if(response.data!.detail!.isNotEmpty){
      dataListActivity5.value = response?.data ?? DataListActivity5();
      var data = dataListActivity5.value;
      var dataBarge = data.barge!.map((item){return Barge(barge: item.barge);}).toList();
      var dataTranshipment = data.transhipment!.map((item){return Transhipment(
        jetty: item.jetty,
        initialDate: item.initialDate,
        finalDate: item.finalDate,
        deliveryQty: item.deliveryQty.toString(),
      );}).toList();
      activity5ListStages.value.add(FormDataArray(
          tHJoId: id,
          mStatusinspectionstagesId: 5,
          uomId: 3,
          transDate: data.detail!.first.transDate,
          actualQty: data.detail!.first.actualQty.toString(),
          createdBy: 0,
          vessel: data.detail!.first.vessel,
          barge: dataBarge,
          transhipment: dataTranshipment
      ));
    }
    // if(dataListActivity5.value.data!.isNotEmpty){
    //   dataListActivity5.value.data!.forEach((data){
    //
    //   });
    // }
  }

  Future<void> getJoDailyActivity6() async{
    var response = await repository.getJoListDailyActivity6(id) ?? JoListDailyActivity6();
    debugPrint('JO Daily Activity 6: ${jsonEncode(response)}');
    debugPrint('JO Daily Activity 6 Attachments: ${jsonEncode(response.image)}');
    dataListActivity6.value = response?.data ?? DataListActivity6();
    dataListActivity6Attachments.value = response?.image ?? Activity6Attachments();
    var data = dataListActivity6.value;
    var dataAttach = dataListActivity6Attachments.value;
    data.data?.forEach((act){
      activity6ListStages.value.add(Activity(
        tHJoId: act.tHJoId,
        mStatusinspectionstagesId: act.mStatusinspectionstagesId,
        transDate: act.transDate,
        startActivityTime: act.startActivityTime,
        endActivityTime: act.endActivityTime,
        activity: act.activity,
        createdBy: 0,
        remarks: act.remarks
      ));
    });
    dataAttach.attach?.forEach((attach)async{
      activity6Attachments.value = [];
      final File data = await getImagesFromUrl(attach.pathName!);
      activity6Attachments.value.add(data);

    });
  }

  // Future<void> getJoDailyActivityLab() async{
  //   var response = await repository.getJoListDailyActivityLab(6) ?? JoListDailyActivityLab();
  //   debugPrint('Jo Daily Activity Lab: ${jsonEncode(response)}');
  //   dataListActivityLab.value = response?.data ?? DataListActivityLab();
  //   dataListActivityLab.value.data!.forEach((item){
  //     labs.value.add(item.laboratoriumName!);
  //   });
  //   update();
  // }
  //
  // Future<void> getJoDailyActivityLab5() async{
  //   var response = await repository.getJoListDailyActivityLab5(6) ?? JoListDailyActivityLab5();
  //   debugPrint('JO Daily Activity Lab 5: ${jsonEncode(response)}');
  //   dataListActivityLab5.value = response?.data ?? DataListActivityLab5();
  //   dataListActivityLab5.value.data!.forEach((item){
  //     labs.value.add(item.laboratoriumName!);
  //   });
  //   update();
  // }

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
  
  void adddailyActivityPhotos(File foto, String desc){
    dailyActivityPhotos.value.add(foto);
    dailyActivityPhotosDescText.value.add(desc);
  }

  void adddailyActivityPhotoForm(){
    adddailyActivityPhotosCount.value++;
    dailyActivityPhotosDesc.value.add(TextEditingController());
    dailyActivityPhotosDescText.value.add('');
  }

  void removePhotoActivity(){
    dailyActivityPhotos.value.removeLast();
    dailyActivityPhotosDesc.value.removeLast();
    adddailyActivityPhotosCount.value--;
    update();
  }

  void editPhotoActivityDesc(int index, String desc){
    dailyActivityPhotosDescText[index] = desc;
  }

  void sendActivityDailyPhoto() async {
    int success = 0;
    if(dailyActivityPhotos.value.isNotEmpty && dailyActivityPhotosDesc.value.isNotEmpty){
      for(var i = 0; i < dailyActivityPhotos.value.length; i++){
        final File photo = dailyActivityPhotos.value[i];
        final String desc = dailyActivityPhotosDesc.value[i].text;
        String response = await sendPhotos(photo, desc);
        if(response == 'success'){
          success++;
        }
      }
    } else {
      openDialog('Failed', 'Tidak ada foto yang diupload');
    }

    if(success == dailyActivityPhotos.value.length){
      openDialog('Success', 'Foto berhasil dikirm');
      if(activityList.value.isEmpty){
        changeStatusJo();
      }
      changeStatusJo();
      getJoDailyPhoto();
    } else {
      openDialog('Attention', 'Beberapa foto gagal dikirim');
    }

  }

  Future<String> updateActivityDailyPhoto(File image, int id) async {
    var response = await repository.updateActivityDailyPhoto(image, id);
    if(response?.httpCode != 200){
      return 'failed';
    } else {
      return 'success';
    }
  }

  Future<String> sendPhotos(File photo, String desc)async{
    var response = await repository.insertActivityDailyPhoto(photo, id, desc);
    if(response?.httpCode != 200){
      return 'failed';
    } else {
      return 'success';
    }
  }

  void changeStatusJo()async{
    var response = await repository.changeStatusJo(id.toString(), 3.toString());
    if(response?.httpCode != 200){
      openDialog('Success', 'Berhasil ubah status JO.');
    } else {
      openDialog('Failed', 'Gagal ubah status JO');
    }
  }

  void addActivityDailyPhotoConfirm() {
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
              Get.back();
              sendActivityDailyPhoto();
            },
          ),
        ],
      ),
    );
  }

  void drawerDailyActivityImage(){
    if(dailyActivityPhotosDesc.value.isEmpty){
      dailyActivityPhotosDesc.value.add(TextEditingController());
      dailyActivityPhotosDescText.value.add('');
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
              borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daily Activity',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: primaryColor
                  ),
                ),
                const SizedBox(height: 16,),
                Expanded(
                  child: SingleChildScrollView(
                    child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: adddailyActivityPhotosCount.value,
                              itemBuilder: (context, index){
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Photo ${adddailyActivityPhotosCount.value}'),
                                    const SizedBox(height: 8,),
                                    dailyActivityPhotos.value.isNotEmpty && dailyActivityPhotos.value.length == adddailyActivityPhotosCount.value ? Column(
                                      children: [
                                        Image.file(File(dailyActivityPhotos.value[index].path), fit: BoxFit.fitWidth,),
                                        const SizedBox(height: 8,),
                                      ],
                                    ) : const SizedBox(),
                                    InkWell(
                                      onTap: () async {
                                        var foto = await cameraImage();
                                        adddailyActivityPhotos(foto,'');
                                      },
                                      child: Container(
                                        height: 54,
                                        width: 54,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: primaryColor),
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: Center(
                                          child: Icon(Icons.camera_alt_sharp,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16,),
                                    TextFormField(
                                      controller: dailyActivityPhotosDesc.value[index],
                                      onChanged: (value){
                                        editPhotoActivityDesc(index, value);
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
                                          labelText: 'Description',
                                          floatingLabelStyle:
                                          const TextStyle(color: onFocusColor),
                                          fillColor: onFocusColor),
                                    ),
                                    const SizedBox(height: 16,),
                                  ],
                                );
                              }),
                          Row(
                            children: [
                              adddailyActivityPhotosCount.value < 5 ? InkWell(
                                onTap: (){
                                  adddailyActivityPhotoForm();
                                  update();
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
                              ) : const SizedBox(),
                              adddailyActivityPhotosCount.value > 1 ? InkWell(
                                onTap: (){
                                  removePhotoActivity();
                                },
                                child: Container(
                                  height: 42,
                                  width: 42,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Center(
                                    child: Icon(Icons.remove,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ) : const SizedBox(),
                            ],
                          ),
                          const SizedBox(height: 16,),
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
                                    )
                                )
                            )
                        ),
                    ),
                    const SizedBox(width: 16,),
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
                                    )
                                )
                            )
                        ),
                    ),
                  ],
                ),
                const SizedBox(height: 16,),
              ],
            )
        ),
      ),
      isScrollControlled: true
    );
  }

  void previewImage(int index,String photo, String desc){
    dailyActivityPhotosDescEdit.value.text = desc;
    Rx<File> foto = File(photo).obs;
    Get.dialog(
      GetBuilder(
        init: JoDetailController(),
        builder: (controller) => AlertDialog(
          title: Row(
            children: [
              Text('Photo and Description ${index + 1}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: primaryColor
                ),
              ),
              dataJoDetail.value.detail?.statusJo == 'Assigned' || dataJoDetail.value.detail?.statusJo == 'On Progres' ? InkWell(
                onTap: (){},
                child: Icon(Icons.delete_forever, color: Colors.red,),
              ) : const SizedBox(),
              Spacer(),
              IconButton(
                onPressed: (){
                  Get.back();
                },
                icon: Icon(Icons.close),
              )

            ],
          ),
          content: SizedBox(
            child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.file(
                    File(foto.value.path),
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16,),
                  InkWell(
                    onTap: () async {
                      var image = await cameraImage();
                      foto.value = image;
                      //updateActivityDailyPhoto(foto, int.parse(dataJoDailyPhotos.value[index].id!.toString()));
                    },
                    child: Container(
                      height: 54,
                      width: 54,
                      decoration: BoxDecoration(
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Center(
                        child: Icon(Icons.camera_alt_sharp,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  dataJoDetail.value.detail?.statusJo == 'Assigned' || dataJoDetail.value.detail?.statusJo == 'On Progres' ? TextFormField(
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
                  ) : Text(desc),
                ],
              ),
            ),
          ),
          actions: [
            dataJoDetail.value.detail?.statusJo == 'Assigned' || dataJoDetail.value.detail?.statusJo == 'On Progres' ? ElevatedButton(
                onPressed: () {
                  editPhotoActivityDesc(index, dailyActivityPhotosDescEdit.value.text);
                  updateActivityConfirm(File(photo), int.parse(dataJoDailyPhotos.value[index].id!.toString()));
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
            ) : const SizedBox(),
          ],
        ),
      ),
    );
  }

  void updateActivityConfirm(File foto, int index) {
    Get.dialog(
      AlertDialog(
        title: Text('Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
          ),
        ),
        content: Text('Apakah benar anda ingin menyimpan perubahan foto JO ini?'),
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
              var result = await updateActivityDailyPhoto(foto, index);
              if(result == 'success'){
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
    if(activityList.value.isEmpty){
      activityListTextController.value.add(TextEditingController());
    } else {
      if (activityList.value.last.transDate != activityDate.text) {
        activityListTextController.value.add(TextEditingController());
      }
    }

    activityList.value.add(Activity(
      tHJoId: id,
      mStatusinspectionstagesId: activityStage,
      transDate: activityDate.text,
      startActivityTime: activityStartTime.text,
      endActivityTime: activityEndTime.text,
      activity: activityText.text,
      createdBy: 0,
      remarks: '',
    ));

    activityDate.text = '';
    activityStartTime.text = '';
    activityEndTime.text = '';
    activityText.text = '';
    update();

    debugPrint('activities: ${jsonEncode(activityList)}');
  }

  void toggleEditActivity(int index){
    activityDate.text = activityList.value[index].transDate!;
    activityStartTime.text = activityList.value[index].startActivityTime!;
    activityEndTime.text = activityList.value[index].endActivityTime!;
    activityText.text = activityList.value[index].activity!;
    editActivityMode.value = true;
    editActivityIndex.value = index;
    update();
  }

  void editActivity(){
    activityList.value[editActivityIndex.value] = Activity(
      tHJoId: id,
      mStatusinspectionstagesId: activityStage,
      transDate: activityDate.text,
      startActivityTime: activityStartTime.text,
      endActivityTime: activityEndTime.text,
      activity: activityText.text,
      createdBy: userData.value!.id,
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
    final TextEditingController remarksController = activityListTextController[index];
    debugPrint('text controller value : ${remarksController.text}');
    for (var i = 0; i < activityList.value.length; i++){
      if(activityList.value[i].transDate.toString() == date){
        activityList.value[i] = Activity(
          tHJoId: id,
          mStatusinspectionstagesId: activityList.value[i].mStatusinspectionstagesId,
          transDate: activityList.value[i].transDate,
          startActivityTime: activityList.value[i].startActivityTime,
          endActivityTime: activityList.value[i].endActivityTime,
          activity: activityList.value[i].activity,
          createdBy: userData.value!.id,
          remarks: remarksController.text,
        );
      }
    }
  }

  void checkActivityList(){
    debugPrint('activities now: ${jsonEncode(activityList)}');
  }

  void removeActivity(int indexitem, int index){
    var dateLength = activityList.value.where((item) => item.transDate == activityList.value[indexitem].transDate).length;
    if(dateLength == 1){
      activityListTextController.value.removeAt(index);
    }
    activityList.value.removeAt(indexitem);
    update();
  }

  Future<String?> addActivityStages() async {
    if(activityList.value.where((data) => data.mStatusinspectionstagesId == activityStage).toList().isNotEmpty){
      var post = activityList.value.map((value) => Activity(
        tHJoId: value.tHJoId,
        mStatusinspectionstagesId: value.mStatusinspectionstagesId,
        transDate: value.transDate,
        startActivityTime: value.startActivityTime,
        endActivityTime: value.endActivityTime,
        activity: value.activity,
        createdBy: value.createdBy,
        remarks: value.remarks,
      ).toJson()).toList();
      var send = await postInsertActivity(post);
      if(send == 'success'){
        changeStatusJo();
        activityStage++;
        for(var item in activityList.value){
          activityListStages.value.add(item);
        }
        activityList.value = [];
        activityListTextController.value = [];
        editActivityMode.value = false;
        activityDate.text = '';
        activityStartTime.text = '';
        activityEndTime.text = '';
        activityText.text = '';
      } else {
        return 'failed';
      }
      return 'success';
    } else if(activityList.value.where((data) => data.mStatusinspectionstagesId == activityStage).toList().isEmpty) {
      return 'failed';
    }

  }

  Future<String> postInsertActivity(data) async {
    var response = await repository.insertActivityInspection(data) ?? ResponseJoInsertActivity();
    debugPrint('insert activity response: ${jsonEncode(response.message)}');
    if(response.message == 'Inspection berhasil ditambahkan.'){
      return 'success';
    } else {
      return 'failed';
    }
  }

  void drawerDailyActivity(){
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
                          Text('Add Stage Inspection',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: primaryColor
                            ),
                          ),
                          const SizedBox(height: 16,),
                          Text('Stage ${activityStage}: ${activityStages[activityStage - 1]}',
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
                                child: Icon(editActivityMode.value == false ? Icons.add : Icons.check,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16,),
                          activityList.value.isNotEmpty ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: activityList.value.map((item){return item.transDate;}).toSet().toList().length,
                            itemBuilder: (context, index)
                            { var activity = activityList.value.map((item){return item.transDate;}).toSet().toList()[index];
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
                                                      itemCount: activityList.value.length,
                                                      itemBuilder: (context, indexItem){
                                                        if(activityList.value[indexItem].transDate == activity){
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
                                                                  '${activityList.value[indexItem].startActivityTime ?? '-'} - ${activityList.value[indexItem].endActivityTime ?? '-'}',
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
                                                                      activityList.value[indexItem].activity ?? '-',
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
                                                    controller: activityListTextController[index],
                                                    onChanged: (value){
                                                      debugPrint(value);
                                                      debugPrint('text remarks controller : ${activityListTextController[index].text}');
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
                              checkActivityList();
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
                              addActivityStageConfirm();
                              //Get.back();
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

  Future<void> selectInitialDate5(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(Duration(days:1)),
        lastDate: DateTime(2101));
    if (picked != null) {
      initialDateActivity5ListTextController.value[index].text = DateFormat('yyyy-MM-dd').format(picked).toString();
    }
  }

  Future<void> selectFinalDate5(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(Duration(days:1)),
        lastDate: DateTime(2101));
    if (picked != null) {
      finalDateActivity5ListTextController.value[index].text = DateFormat('yyyy-MM-dd').format(picked).toString();
    }
  }

  void addBargeForm(){
    bargesController.value.add(TextEditingController());
    activity5Barges.value.add('');
  }

  void checkActivity5List(){
    debugPrint('activities 5 now: ${jsonEncode(activity5List)}');
  }

  void editBargeForm(int index){
    barges.value[index] = bargesController.value[index].text;
  }

  void removeBargeForm(){
    bargesController.value.removeLast();
    activity5Barges.value.removeLast();
  }

  void addActivity5Form(){
    activity5FormCount++;
    jettyListTextController.value.add(TextEditingController());
    initialDateActivity5ListTextController.value.add(TextEditingController());
    finalDateActivity5ListTextController.value.add(TextEditingController());
    deliveryQtyListTextController.value.add(TextEditingController());
    update();
  }

  void removeActivity5Form(){
    activity5FormCount--;
    jettyListTextController.value.removeLast();
    initialDateActivity5ListTextController.value.removeLast();
    finalDateActivity5ListTextController.value.removeLast();
    deliveryQtyListTextController.value.removeLast();
    update();
  }

  void addActivity5(){
    var barge = activity5Barges.value.map((barge){return Barge(barge: barge);}).toList();
    activity5List.value.add(FormDataArray(
            tHJoId: id,
            mStatusinspectionstagesId: activityStage,
            uomId: 3,
            transDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            actualQty: dataJoDetail.value.detail!.qty.toString(),
            createdBy: userData.value!.id,
            vessel: dataJoDetail.value.detail!.vessel,
            barge: barge,
            transhipment: activity5TranshipmentList
        )
    );
  }

  Future<void> postInsertActivity5(data) async {
    var response = await repository.insertActivityInspection5(data) ?? ResponseJoInsertActivity5();
    debugPrint('insert activity 5 response: ${jsonEncode(response.message)}');
  }

  void editActivity5Transhipment(int index){
    activity5TranshipmentList.value[index] = Transhipment(
      jetty: jettyListTextController.value[index].text,
      initialDate: initialDateActivity5ListTextController.value[index].text,
      finalDate: finalDateActivity5ListTextController.value[index].text,
      deliveryQty: deliveryQtyListTextController.value[index].text,
    );
  }

  String? addActivity5Stage(){
    addActivity5();
    if(activity5List.value.isNotEmpty){
      activityStage++;
      postInsertActivity5(activity5List);
      for(var item in activity5List.value){
        activity5ListStages.value.add(item);
      }
      activity5List.value = [];
      jettyListTextController.value = [];
      initialDateActivity5ListTextController.value = [];
      finalDateActivity5ListTextController.value = [];
      deliveryQtyListTextController.value = [];
      activity5bargesCount = bargesCount;
      activity5Barges.value = barges.value;

      qtyController.text = dataJoDetail.value.detail!.qty.toString();
      uomController.text = dataJoDetail.value.detail!.uomName!;
      vesselController.text = dataJoDetail.value.detail!.vessel!;
      activity5FormCount.value = 1;
      if(activity5TranshipmentList.value.isEmpty){
        jettyListTextController.value.add(TextEditingController());
        initialDateActivity5ListTextController.value.add(TextEditingController());
        finalDateActivity5ListTextController.value.add(TextEditingController());
        deliveryQtyListTextController.value.add(TextEditingController());
        activity5TranshipmentList.value.add(Transhipment());
      }
      update();
      return 'success';
    } else if(activity5List.value.where((data) => data.mStatusinspectionstagesId == activityStage).toList().isEmpty) {
      return 'failed';
    }
  }

  void drawerDailyActivity5(){
    qtyController.text = dataJoDetail.value.detail!.qty.toString();
    uomController.text = dataJoDetail.value.detail!.uomName!;
    vesselController.text = dataJoDetail.value.detail!.vessel!;
    if(activity5TranshipmentList.value.isEmpty){
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
                    borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add Stage Inspection',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: primaryColor
                      ),
                    ),
                    const SizedBox(height: 16,),
                    const Text('Stage 5: Work Complete',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    const SizedBox(height: 16,),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16,),
                            TextFormField(
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
                            const SizedBox(height: 16,),
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
                            const SizedBox(height: 16,),
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
                            const SizedBox(height: 16,),
                            barges.value.isNotEmpty ? Column(
                              children: [
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: activity5bargesCount,
                                  itemBuilder: (context,i){
                                    bargesController.value[i].text = barges.value[i];
                                    return Column(
                                      children: [
                                        TextFormField(
                                          controller: bargesController.value[i],
                                          cursorColor: onFocusColor,
                                          onChanged: (value){
                                            editBargeForm(i);
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
                                              labelText: 'Barge ${i+1}',
                                              floatingLabelStyle:
                                              const TextStyle(color: onFocusColor),
                                              fillColor: onFocusColor),
                                        ),
                                        const SizedBox(height: 16,),
                                      ],
                                    );
                                  }),
                              ]
                            ) : const SizedBox(),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        addBargeForm();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(vertical: 12),
                                          backgroundColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12))),
                                      child: SizedBox(
                                          width: double.infinity,
                                          child: Center(
                                              child: Text(
                                                'Add Barge',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              )
                                          )
                                      )
                                  ),
                                ),
                                const SizedBox(width: 16,),
                                activity5Barges.value.length > 1 ? Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        removeBargeForm();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(vertical: 12),
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12))),
                                      child: SizedBox(
                                          width: double.infinity,
                                          child: Center(
                                              child: Text(
                                                'Remove Barge',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              )
                                          )
                                      )
                                  ),
                                ) : const Expanded(
                                    flex: 1,
                                    child: SizedBox()
                                ),
                                const SizedBox(width: 16,),
                                const Expanded(
                                    flex: 1,
                                    child: SizedBox()
                                )
                              ],
                            ),
                            const SizedBox(height: 16,),
                            const Divider(),
                            const SizedBox(height: 16,),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: activity5FormCount.value,
                                itemBuilder: (context, index){
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text('KOS Transhipment Form ${index + 1}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: primaryColor
                                            ),
                                          ),
                                        ),
                                        index == (activity5FormCount.value - 1) ? Row(
                                          children: [
                                            InkWell(
                                              onTap: (){
                                                addActivity5Form();
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
                                            activity5FormCount.value > 1 ? InkWell(
                                              onTap: (){
                                                removeActivity5Form();
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(right: 8),
                                                height: 42,
                                                width: 42,
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius: BorderRadius.circular(8)
                                                ),
                                                child: Center(
                                                  child: Icon(Icons.remove,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ) : const SizedBox()
                                          ],
                                        ) : const SizedBox(),
                                      ],
                                    ),
                                    const SizedBox(height: 16,),
                                    TextFormField(
                                      controller: jettyListTextController.value[index],
                                      cursorColor: onFocusColor,
                                      onChanged: (value){
                                        editActivity5Transhipment(index);
                                      } ,
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
                                          labelText: 'Jetty',
                                          floatingLabelStyle:
                                          const TextStyle(color: onFocusColor),
                                          fillColor: onFocusColor),
                                    ),
                                    const SizedBox(height: 16,),
                                    TextFormField(
                                      controller: initialDateActivity5ListTextController.value[index],
                                      cursorColor: onFocusColor,
                                      onTap: (){
                                        selectInitialDate5(context, index);
                                      },
                                      onChanged: (value){
                                        editActivity5Transhipment(index);
                                      } ,
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
                                          labelText: 'Initial Date',
                                          floatingLabelStyle:
                                          const TextStyle(color: onFocusColor),
                                          fillColor: onFocusColor),
                                    ),
                                    const SizedBox(height: 16,),
                                    TextFormField(
                                      controller: finalDateActivity5ListTextController.value[index],
                                      cursorColor: onFocusColor,
                                      onTap: (){
                                        selectFinalDate5(context, index);
                                      },
                                      onChanged: (value){
                                        editActivity5Transhipment(index);
                                      } ,
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
                                          labelText: 'Final Date',
                                          floatingLabelStyle:
                                          const TextStyle(color: onFocusColor),
                                          fillColor: onFocusColor),
                                    ),
                                    const SizedBox(height: 16,),
                                    TextFormField(
                                      controller: deliveryQtyListTextController.value[index],
                                      cursorColor: onFocusColor,
                                      onChanged: (value){
                                        editActivity5Transhipment(index);
                                      } ,
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
                                          labelText: 'Delivery Qty',
                                          floatingLabelStyle:
                                          const TextStyle(color: onFocusColor),
                                          fillColor: onFocusColor),
                                    ),
                                    const SizedBox(height: 16,),
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
                                            borderSide:
                                            const BorderSide(color: onFocusColor),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          labelText: 'UOM',
                                          floatingLabelStyle:
                                          const TextStyle(color: onFocusColor),
                                          fillColor: onFocusColor),
                                    ),
                                    const SizedBox(height: 16,),
                                  ],
                                );
                                }
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                checkActivity5List();
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
                                addActivityStage5Confirm();
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
                )
            ),
          ),
        ),
        isScrollControlled: true
    );
  }

  Future<void> _selectDate6(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(Duration(days:1)),
        lastDate: DateTime(2101));
    if (picked != null) {
      activity6Date.text = DateFormat('yyyy-MM-dd').format(picked).toString();
    }
  }

  Future<String> _selectTime6(BuildContext context) async {
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

  void addActivity6(){
    if(activity6List.value.isEmpty){
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
    update();

    debugPrint('activities 6: ${jsonEncode(activity6List)}');
  }

  void toggleEditActivity6(int index){
    activity6Date.text = activity6List.value[index].transDate!;
    activity6StartTime.text = activity6List.value[index].startActivityTime!;
    activity6EndTime.text = activity6List.value[index].endActivityTime!;
    activity6Text.text = activity6List.value[index].activity!;
    editActivityMode.value = true;
    editActivityIndex.value = index;
    update();
  }

  void editActivity6(){
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

  void editActivity6Remarks(String date, String val, int index){
    final TextEditingController remarksController = activity6ListTextController[index];
    debugPrint('text controller value : ${remarksController.text}');
    for (var i = 0; i < activity6List.value.length; i++){
      if(activity6List.value[i].transDate.toString() == date){
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

  void checkActivity6List(){
    debugPrint('activities now: ${jsonEncode(activity6List.value)}');
  }

  void removeActivity6(int indexitem, int index){
    var dateLength = activity6List.value.where((item) => item.transDate == activity6List.value[indexitem].transDate).length;
    if(dateLength == 1){
      activity6ListTextController.value.removeAt(index);
    }
    activity6List.value.removeAt(indexitem);
    update();
  }

  String? addActivity6Stages(){
    if(activity6List.value.where((data) => data.mStatusinspectionstagesId == activityStage).toList().isNotEmpty){
      activityStage++;
      var post = activity6List.value.map((value) => Activity(
        tHJoId: value.tHJoId,
        mStatusinspectionstagesId: value.mStatusinspectionstagesId,
        transDate: value.transDate,
        startActivityTime: value.startActivityTime,
        endActivityTime: value.endActivityTime,
        activity: value.activity,
        createdBy: value.createdBy,
        remarks: value.remarks,
      ).toJson()).toList();
      //postInsertActivity(post);
      for(var item in activity6List.value){
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
      update();
      return 'success';
    } else if(activity6List.value.where((data) => data.mStatusinspectionstagesId == activityStage).toList().isEmpty) {
      return 'failed';
    }

  }

  Future<void> postInsertActivity6(data) async {
    var response = await repository.insertActivityInspection(data) ?? ResponseJoInsertActivity();
    debugPrint('insert activity response: ${jsonEncode(response.message)}');
  }

  void addActivity6Files(File attach){
    activity6Attachments.value.add(attach);
  }

  void cameraImageActivity6() async {
    File? image;
    try {
      final XFile? pic = await picker.pickImage(source: ImageSource.camera);
      if(pic != null){
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
      final FilePickerResult? attach = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.custom, allowedExtensions: ['jpg','jpeg','png','pdf']);
      if (attach != null) {
        final List<XFile> xFiles = attach.xFiles;
        xFiles.forEach((data){
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

    if (mimeType!.startsWith('image/')){
      return 'image';
    } else if(mimeType == 'application/pdf'){
      return 'doc';
    }
    return 'unsupported';
  }

  void drawerDailyActivity6(){
    Get.bottomSheet(
        GetBuilder(
          init:JoDetailController(),
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
                            Text('Add Stage Inspection',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor
                              ),
                            ),
                            const SizedBox(height: 16,),
                            const Text('Stage 6: Report to Client',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            const SizedBox(height: 16,),
                            TextFormField(
                              showCursor: true,
                              readOnly: true,
                              controller: activity6Date,
                              cursorColor: onFocusColor,
                              onTap: (){
                                _selectDate6(Get.context!);
                              },
                              style: const TextStyle(color: onFocusColor),
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: (){
                                        _selectDate6(Get.context!);
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
                                    controller: activity6StartTime,
                                    cursorColor: onFocusColor,
                                    onTap: () async {
                                      activity6StartTime.text = await _selectTime6(Get.context!);
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
                                    controller: activity6EndTime,
                                    cursorColor: onFocusColor,
                                    onTap: () async {
                                      activity6EndTime.text = await _selectTime6(Get.context!);
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
                                  labelText: 'Activity*',
                                  floatingLabelStyle:
                                  const TextStyle(color: onFocusColor),
                                  fillColor: onFocusColor),
                            ),
                            const SizedBox(height: 16,),
                            InkWell(
                              onTap: (){
                                if(editActivityMode.value == false){
                                  addActivity6();
                                } else {
                                  editActivity6();
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
                                  child: Icon(editActivityMode.value == false ? Icons.add : Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16,),
                            activity6List.value.isNotEmpty ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: activity6List.value.map((item){return item.transDate;}).toSet().toList().length,
                                itemBuilder: (context, index)
                                { var activity = activity6List.value.map((item){return item.transDate;}).toSet().toList()[index];
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
                                                itemCount: activity6List.value.length,
                                                itemBuilder: (context, indexItem){
                                                  if(activity6List.value[indexItem].transDate == activity){
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
                                                            '${activity6List.value[indexItem].startActivityTime ?? '-'} - ${activity6List.value[indexItem].endActivityTime ?? '-'}',
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
                                                                activity6List.value[indexItem].activity ?? '-',
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                              InkWell(
                                                                  onTap: () {
                                                                    toggleEditActivity6(indexItem);
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .mode_edit_outlined,
                                                                    color:
                                                                    primaryColor,
                                                                  )),
                                                              InkWell(
                                                                  onTap: () {
                                                                    removeActivity6(indexItem, index);
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
                                              controller: activity6ListTextController.value[index],
                                              onChanged: (value){
                                                debugPrint(value);
                                                debugPrint('text remarks controller : ${activity6ListTextController.value[index].text}');
                                                editActivity6Remarks(activity!, value, index);
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
                            const SizedBox(height: 16,),
                            const Text('Attachment',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            const SizedBox(height: 16,),
                            Text('File lampiran maksimal 5 file dengan ukuran total file maksimal 10 MB. Jenis file yang diperbolehkan hanya PDF/JPG/PNG/JPEG.'),
                            const SizedBox(height: 16,),
                            activity6Attachments.value.isNotEmpty ? GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                ),
                                itemCount: activity6Attachments.value.length,
                                itemBuilder: (content, index){
                                  final File photo = activity6Attachments.value[index];
                                  final String fileType = checkFileType(photo.path);
                                  var filenameArr = photo.path.split("/");
                                  var filename = filenameArr.last;
                                  return fileType == 'image' ? SizedBox(
                                    width: 54,
                                    height: 54,
                                    child: InkWell(
                                      onTap: (){
                                        previewImageAct6(index, photo.path);
                                      },
                                      child: Image.file(
                                        File(photo.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ) : fileType == 'doc' ? InkWell(
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
                                  ) : SizedBox();
                                }
                            ) : const SizedBox(),
                            const SizedBox(height: 16,),
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
                                          borderRadius: BorderRadius.circular(12))),
                                  child: Center(
                                      child: Icon(Icons.folder_rounded,
                                        color: primaryColor,
                                      )
                                  )
                              ),
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
                                      )
                                  )
                              )
                          ),
                        ),
                        const SizedBox(width: 16,),
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

  void detailLabActivity(int? lab) {
    Get.to(LabActivityDetailScreen(), arguments: {'id' : id, 'labId' : lab});
  }

  void addActivityStageConfirm() {
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
              var result = await addActivityStages();
              if(result == 'success'){
                Get.back();
                openDialog("Success", "Activity Stage ${activityStage-1} berhasil ditambahkan");
                if(activityStage-1 == 1) {
                  changeStatusJo();
                }
              } else {
                Get.back();
                openDialog("Failed", "Activity Stage $activityStage masih kosong atau belum diinput");
              }
            },
          ),
        ],
      ),
    );
  }

  void previewImageAct6(int index,String photo){
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Text('Attachment ${index + 1}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: primaryColor
              ),
            ),
            InkWell(
              onTap: (){},
              child: Icon(Icons.delete_forever, color: Colors.red,),
            ),
            Spacer(),
            IconButton(
              onPressed: (){
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

  void addActivityStage5Confirm() {
    Get.dialog(
      AlertDialog(
        title: Text('Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
          ),
        ),
        content: Text('Apakah benar anda akan menyimpan perubahan stage work complete ini? pastikan data yg anda input benar.'),
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
              var result = await addActivity5Stage();
              if(result == 'success'){
                Get.back();
                openDialog("Success", "Activity Stage ${activityStage-1} berhasil ditambahkan");
              } else {
                Get.back();
                openDialog("Failed", "Activity Stage $activityStage masih kosong atau belum diinput");
              }
            },
          ),
        ],
      ),
    );
  }

  void addActivity6StageConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text('Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
          ),
        ),
        content: Text('Apakah benar anda akan submit stage report to client ini? pastikan data yg anda input benar.'),
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
              var result = await addActivity6Stages();
              if(result == 'success'){
                Get.back();
                openDialog("Success", "Activity Stage ${activityStage-1} berhasil ditambahkan");
                if(activityStage-1 == 1) {
                  changeStatusJo();
                }
              } else {
                Get.back();
                openDialog("Failed", "Activity Stage $activityStage masih kosong atau belum diinput");
              }
            },
          ),
        ],
      ),
    );
  }

  void mediaPickerConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text('File Attachment',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
          ),
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
                            child: Icon(Icons.camera_alt,
                              color: primaryColor,
                            )
                        )
                    ),
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
                            child: Icon(Icons.folder_rounded,
                              color: primaryColor,
                            )
                        )
                    ),
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

  Future<String?> addDocuments(String type) async {
    if(type == 'inspect'){
      if(certificateNumberTextController.value.text != '' &&
      certificateDateTextController.value.text != ''&&
      certificateBlankoNumberTextController.value.text != '' &&
      certificateLHVNumberTextController.value.text != '' &&
      certificateLSNumberTextController.value.text != '' &&
      documentInspectionAttachments.value.isNotEmpty
      ){
        documentInspection.value.add(<String, dynamic>{
          'certNumber' : certificateNumberTextController.value.text,
          'certDate'  : certificateDateTextController.value.text,
          'certBlanko' : certificateBlankoNumberTextController.value.text,
          'certLhv' : certificateLHVNumberTextController.value.text,
          'certLs'  : certificateLSNumberTextController.value.text,
          'certAttachments' : documentInspectionAttachments.value
        });
        return 'success';
      } else {
        return 'failed';
      }
    }else if(type == 'lab'){
      if(certificateNumberTextController.value.text != '' &&
          certificateDateTextController.value.text != ''&&
          certificateBlankoNumberTextController.value.text != '' &&
          certificateLHVNumberTextController.value.text != '' &&
          certificateLSNumberTextController.value.text != '' &&
          documentLaboratoryAttachments.value.isNotEmpty
      ){
        documentLaboratory.value.add(<String, dynamic>{
          'certNumber' : certificateNumberTextController.value.text,
          'certDate'  : certificateDateTextController.value.text,
          'certBlanko' : certificateBlankoNumberTextController.value.text,
          'certLhv' : certificateLHVNumberTextController.value.text,
          'certLs'  : certificateLSNumberTextController.value.text,
          'certAttachments' : documentInspectionAttachments.value
        });
        return 'success';
      } else {
        return 'failed';
      }
    }
  }

  void fileDocument(String type) async {
    try {
      final FilePickerResult? attach = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.custom, allowedExtensions: ['jpg','jpeg','png','pdf']);
      if (attach != null) {
        final List<XFile> xFiles = attach.xFiles;
        xFiles.forEach((data){
          final fileTemp = File(data!.path);
          final File file = fileTemp;
          update();
          if(type == 'inspect'){
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

  void drawerAddDocument(String type){
    Get.bottomSheet(
        GetBuilder(
        init:JoDetailController(),
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
                        Text('Add Stage Inspection',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: primaryColor
                          ),
                        ),
                        const SizedBox(height: 16,),
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
                        const SizedBox(height: 16,),
                        TextFormField(
                          showCursor: true,
                          readOnly: true,
                          controller: activity6Date,
                          cursorColor: onFocusColor,
                          onTap: (){
                            _selectDate6(Get.context!);
                          },
                          style: const TextStyle(color: onFocusColor),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: (){
                                    _selectDate6(Get.context!);
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
                              labelText: 'Date Certificate/Report*',
                              floatingLabelStyle:
                              const TextStyle(color: onFocusColor),
                              fillColor: onFocusColor),
                        ),
                        const SizedBox(height: 16,),
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
                        const SizedBox(height: 16,),
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
                        const SizedBox(height: 16,),
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
                        const SizedBox(height: 16,),
                        const Text('Upload Attachment Certificate',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        const SizedBox(height: 16,),
                        Text('Note: PDF Only. Max 1 file. Max 2 MB',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.green
                          ),
                        ),
                        const SizedBox(height: 16,),
                        activity6Attachments.value.isNotEmpty ? GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                            itemCount: activity6Attachments.value.length,
                            itemBuilder: (content, index){
                              final File photo = activity6Attachments.value[index];
                              final String fileType = checkFileType(photo.path);
                              var filenameArr = photo.path.split("/");
                              var filename = filenameArr.last;
                              return fileType == 'image' ? SizedBox(
                                width: 54,
                                height: 54,
                                child: InkWell(
                                  onTap: (){
                                    previewImageAct6(index, photo.path);
                                  },
                                  child: Image.file(
                                    File(photo.path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ) : fileType == 'doc' ? InkWell(
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
                              ) : SizedBox();
                            }
                        ) : const SizedBox(),
                        const SizedBox(height: 16,),
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
                                      borderRadius: BorderRadius.circular(12))),
                              child: Center(
                                  child: Icon(Icons.folder_rounded,
                                    color: primaryColor,
                                  )
                              )
                          ),
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
                                  )
                              )
                          )
                      ),
                    ),
                    const SizedBox(width: 16,),
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
        )
      ,
      isScrollControlled: true,
    );
  }

  void checkDocumentList(String type){
    debugPrint('document now: ${jsonEncode(type == 'inspect' ? documentInspection.value : documentLaboratory.value)}');
  }

  void addDocumentConfirm(String type) {
    Get.dialog(
      AlertDialog(
        title: Text('Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
          ),
        ),
        content: Text('Apakah benar anda akan submit finalisasi JO Inspection ini? pastikan data yg anda input benar karena jika anda submit, JO akan dicomplete-kan.'),
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

              var result = await addDocuments(type);
              if(result == 'success'){
                Get.back();
                openDialog("Success", "Finalisasi JO berhasil ditambahkan");
              } else {
                Get.back();
                openDialog("Failed", "Finalisasi JO masih kosong atau belum diinput");
              }
            },
          ),
        ],
      ),
    );
  }

}