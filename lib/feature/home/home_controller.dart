import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
import 'package:ops_mobile/data/model/jo_list_model.dart';
import 'package:ops_mobile/data/model/jo_pic_model.dart';
import 'package:ops_mobile/data/model/login_data_model.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:ops_mobile/feature/login/login_screen.dart';

class HomeController extends BaseController{

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
    userData.value = Data.fromJson(jsonDecode(await StorageCore().storage.read('login')));
    debugPrint('data users: ${jsonEncode(userData.value)}');
    connectivityResult = await (Connectivity().checkConnectivity());
    //await getJO();
    super.onInit();
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

  Future<void> getJO() async {
    // if(connectivityResult.contains(ConnectivityResult.none)){
    //   RxList<DataJo> dataJoList = ;
    //   RxList<DataDetail> dataJoDetail = ;
    //   RxList<DataPIC> dataJoPIC = ;
    //   RxList<DataDailyPhoto> dataJoDailyPhotos = ;
    //   RxList<DataActivity> dataListActivity = ;
    //   RxList<DataActivity5> dataListActivity5 = ;
    //   RxList<DataActivity6> dataListActivity6 = ;
    //   RxList<DataActivityLab> dataListActivityLab = ;
    //   RxList<DataActivityLab5> dataListActivityLab5 = ;
    // }
    loadingDialog();
    await Future.forEach(status, (id) => getJoList(id));
    if(dataJoList.value.isNotEmpty){
      await StorageCore().storage.write('data_jo_list', jsonEncode(dataJoList.value));

      dataJoList.value.forEach((data)async{
        final int id = data.joId!;
        await getJoDetail(id);
        await getJoPIC(id);
        await getJoDailyPhoto(id);
        await getJoDailyActivity(id);
        await getJoDailyActivity5(id);
        await getJoDailyActivity6(id);
        await getJoDailyActivityLab(id);
        await getJoDailyActivityLab5(id);
      });

      Future.delayed(Duration(seconds: 5),() async {
        // debugPrint('check JO Daily Activity 5: ${jsonEncode(dataListActivity5.value)}');
        if(dataJoDetail.isNotEmpty){
          await StorageCore().storage.write('data_jo_detail', jsonEncode(dataJoDetail.value));
        }
        if(dataJoPIC.isNotEmpty){
          await StorageCore().storage.write('data_jo_pic', jsonEncode(dataJoPIC.value));
        }
        if(dataJoDailyPhotos.isNotEmpty){
          await StorageCore().storage.write('data_daily_photos', jsonEncode(dataJoDailyPhotos.value));
        }
        if(dataListActivity.isNotEmpty){
          await StorageCore().storage.write('data_daily_activity', jsonEncode(dataListActivity.value));
        }
        if(dataListActivity5.isNotEmpty){
          await StorageCore().storage.write('data_daily_activity_five', jsonEncode(dataListActivity5.value));
        }
        if(dataListActivity6.isNotEmpty){
          await StorageCore().storage.write('data_daily_activity_six', jsonEncode(dataListActivity6.value));
        }
        if(dataListActivityLab.isNotEmpty){
          await StorageCore().storage.write('data_daily_activity_lab', jsonEncode(dataListActivityLab.value));
        }
        if(dataListActivityLab5.isNotEmpty){
          await StorageCore().storage.write('data_daily_activity_lab_five', jsonEncode(dataListActivityLab5.value));
        }
        Get.back();
        openDialog("Success", "Berhasil mengambil data JO");
      });
    }
    debugPrint('data JO from storage: ${jsonEncode(jsonDecode(await StorageCore().storage.read('data_jo_list')))}');
    // debugPrint('data JO Detail from storage: ${jsonEncode(jsonDecode(await StorageCore().storage.read('data_jo_detail')))}');
    // debugPrint('data JO PIC from storage: ${jsonEncode(jsonDecode(await StorageCore().storage.read('data_jo_pic')))}');
    // debugPrint('data JO Daily Photos from storage: ${jsonEncode(jsonDecode(await StorageCore().storage.read('data_daily_photos')))}');
    // debugPrint('data JO Activities from storage: ${jsonEncode(jsonDecode(await StorageCore().storage.read('data_daily_activity')))}');
    //
    // debugPrint('data JO Activity 5 from storage: ${jsonEncode(jsonDecode(await StorageCore().storage.read('data_daily_activity_five')))}');
    // debugPrint('data JO Activity 6 from storage: ${jsonEncode(jsonDecode(await StorageCore().storage.read('data_daily_activity_six')))}');
    // debugPrint('data JO Activities Lab from storage: ${jsonEncode(jsonDecode(await StorageCore().storage.read('data_daily_activity_lab')))}');
    // debugPrint('data JO Activity Lab 5 from storage: ${jsonEncode(jsonDecode(await StorageCore().storage.read('data_daily_activity_lab_five')))}');
    //
    // Get.back();
    // openDialog("Success", "Berhasil mengambil data JO");
  }

  void getJoList(int statusJo) async {
    var response = await repository.getJoList(statusJo) ?? JoListModel();
    if(response.data!.data != null){
      response.data!.data!.forEach((value){
        dataJoList.value.add(DataJo.fromJson(jsonDecode(jsonEncode(value))));
      });
    }
    debugPrint("JO List: ${jsonEncode(dataJoList.value)}");
  }

  void getJoListFromStorage() async {
    var response = await jsonDecode(await StorageCore().storage.read('data_jo_list'));
    if(response.isNotEmpty){
      response.forEach((value){
        dataJoList.value.add(DataJo.fromJson(jsonDecode(jsonEncode(value))));
      });
    }
    debugPrint("JO List: ${jsonEncode(dataJoList.value)}");
  }

  Future<void> getJoDetail(int id) async{
    var response = await repository.getJoDetail(id) ?? JoDetailModel();
    debugPrint(jsonEncode(response));
    dataJoDetail.value.add(response?.data ?? DataDetail());
  }

  Future<void> getJoDetailFromStorage() async{
    var response = await jsonDecode(await StorageCore().storage.read('data_jo_detail'));
    debugPrint(jsonEncode(response));
    if(response.isNotEmpty){
      response.forEach((value) {
        dataJoDetail.value.add(DataDetail.fromJson(value));
        }
      );
    }
  }

  Future<void> getJoPIC(int id) async{
    var response = await repository.getJoPIC(id) ?? JoPicModel();
    debugPrint('JO PIC: ${jsonEncode(response)}');
    dataJoPIC.value.add(response?.data ?? DataPIC());
  }

  Future<void> getJoPICFromStorage() async{
    var response = await jsonDecode(await StorageCore().storage.read('data_jo_pic'));
    debugPrint('JO PIC: ${jsonEncode(response)}');
    if(response.isNotEmpty){
      response.forEach((value){
        dataJoPIC.value.add(DataPIC.fromJson(value));
      }
      );
    }
  }

  Future<String?> networkImageToBase64(String imageUrl) async {
    debugPrint('image path: ${AppConstant.CORE_URL}$imageUrl');
    http.Response response = await http.get(Uri.parse('${AppConstant.CORE_URL}/$imageUrl'));
    final bytes = response?.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

  Future<void> getJoDailyPhoto(id) async{
    var response = await repository.getJoDailyPhoto(id) ?? JoDailyPhoto();
    debugPrint('JO Daily Photo: ${jsonEncode(response)}');
    //dataJoDailyPhotos.value = response?.data ?? [];
    if(response!.data != null) {
      response!.data!.forEach((data) async {
        final String photo = await networkImageToBase64(data.pathPhoto!) ?? '';
        dataJoDailyPhotos.value.add(DataDailyPhoto(
          id: data.id,
          tHJoId: data.tHJoId,
          pathPhoto: photo,
          keterangan: data.keterangan,
          createdAt: data.createdAt,
          updatedAt: data.updatedAt,
        )
        );
      });
    }
  }

  Future<void> getJoDailyPhotoFromStorage() async{
    var response = await jsonDecode(await StorageCore().storage.read('data_daily_photos'));
    debugPrint('JO Daily Photo: ${jsonEncode(response)}');
    //dataJoDailyPhotos.value = response?.data ?? [];
    if(response.isNotEmpty) {
      response.forEach((value){
        dataJoDailyPhotos.value.add(DataDailyPhoto.fromJson(value));
      });
    }
  }

  Future<void> getJoDailyActivity(id) async{
    var response = await repository.getJoListDailyActivity(id) ?? JoListDailyActivity();
    debugPrint('JO Daily Activity: ${jsonEncode(response)}');
    if(response.data?.data! != null){
      response.data!.data!.forEach((data){
        dataListActivity.value.add(data);
      });
    }
  }

  Future<void> getJoDailyActivityFromStorage() async{
    var response = await jsonDecode(await StorageCore().storage.read('data_daily_activity'));
    debugPrint('JO Daily Activity: ${jsonEncode(response)}');
    if(response.isNotEmpty){
      response.forEach((value){
        dataListActivity.value.add(DataActivity.fromJson(value));
      });
    }
  }

  Future<void> getJoDailyActivity5(id) async{
    var response = await repository.getJoListDailyActivity5(id) ?? JoListDailyActivity5();
    debugPrint('JO Daily Activity 5: ${jsonEncode(response)}');
    if(response.data! != null){
        dataListActivity5.value.add(response.data!);
    }
  }

  Future<void> getJoDailyActivity5FromStorage() async{
    var response = await jsonDecode(await StorageCore().storage.read('data_daily_activity5'));
    debugPrint('JO Daily Activity 5: ${jsonEncode(response)}');
    if(response.isNotEmpty){
      response.forEach((value){
        dataListActivity5.value.add(DataListActivity5.fromJson(value));
      });
    }
  }

  Future<void> getJoDailyActivity6(id) async{
    var response = await repository.getJoListDailyActivity6(id) ?? JoListDailyActivity6();
    debugPrint('JO Daily Activity 6: ${jsonEncode(response)}');
    if(response.data?.data! != null){
      response.data!.data!.forEach((data){
        dataListActivity6.value.add(data);
      });
    }
  }

  Future<void> getJoDailyActivity6FromStorage() async{
    var response = await jsonDecode(await StorageCore().storage.read('data_daily_activity6'));
    debugPrint('JO Daily Activity 6: ${jsonEncode(response)}');
    if(response.isNotEmpty){
      response.forEach((value){
        dataListActivity6.value.add(DataActivity6.fromJson(value));
      });
    }
  }

  Future<void> getJoDailyActivityLab(id) async{
    var response = await repository.getJoListDailyActivityLab(6) ?? JoListDailyActivityLab();
    debugPrint('Jo Daily Activity Lab: ${jsonEncode(response)}');
    if(response.data?.data! != null){
      response.data!.data!.forEach((data){
        dataListActivityLab.value.add(data);
      });
    }
  }

  Future<void> getJoDailyActivityLabFromStorage(id) async{
    var response = await jsonDecode(await StorageCore().storage.read('data_daily_activity_lab'));
    debugPrint('Jo Daily Activity Lab: ${jsonEncode(response)}');
    if(response.isNotEmpty){
      response.forEach((value){
        dataListActivityLab.value.add(DataActivityLab.fromJson(value));
      });
    }
  }


  Future<void> getJoDailyActivityLab5(id) async{
    var response = await repository.getJoListDailyActivityLab5(6) ?? JoListDailyActivityLab5();
    debugPrint('JO Daily Activity Lab 5: ${jsonEncode(response)}');
    if(response.data?.data! != null){
      response.data!.data!.forEach((data){
        dataListActivityLab5.value.add(data);
      });
    }
  }

  Future<void> getJoDailyActivityLab5FromStorage(id) async{
    var response = await jsonDecode(await StorageCore().storage.read('data_daily_activity_lab5'));
    debugPrint('JO Daily Activity Lab 5: ${jsonEncode(response)}');
    if(response.isNotEmpty){
      response.forEach((value){
        dataListActivityLab5.value.add(DataActivityLab5.fromJson(value));
      });
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

}