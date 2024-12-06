import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/data/model/jo_assigned_model.dart';
import 'package:ops_mobile/data/model/jo_list_model.dart';
import 'package:ops_mobile/data/model/t_h_jo.dart';
import 'package:ops_mobile/data/sqlite.dart';
import 'package:http/http.dart' as http;
import 'package:ops_mobile/utils/helper.dart';

class AssignedController extends BaseController{

  RxList<DataJo> dataJoList = RxList();
  RxList<DataJo> dataJoListTemp = RxList();

  final List<String> listStatus = ['New', 'Assigned', 'On Progress', 'Waiting Approval Client', 'Completed', 'Waiting for Cancellation', 'Canceled'];
  RxInt statusJo = 0.obs;
  RxInt employeeId = 0.obs;
  TextEditingController searchText = TextEditingController();

  @override
  void onInit()async {
    var argument = await Get.arguments;
    debugPrint('arguments : ${argument['status']}');
    debugPrint('arguments : ${argument['employeeId']}');
    statusJo.value = argument['status'];
    employeeId.value = argument['employeeId'];
    searchText.addListener(searchJo);
    update();

    //final data = await SqlHelper.getListJo(employeeId.value,statusJo.value);
    //debugPrint('status selected: ${statusJo.value}');
    //debugPrint('data list : ${jsonEncode(data)}');
    await getJoListLocal();
    super.onInit();
  }


  Future<void> getJoListLocal() async{
    final data = await SqlHelper.getListJo(employeeId.value,statusJo.value);
    debugPrint('status selected: ${statusJo.value}');
    debugPrint('data list : ${jsonEncode(data)}');
    data.forEach((value){
      dataJoList.value.add(DataJo.fromJson(jsonDecode(jsonEncode(value))));
      dataJoListTemp.value.add(DataJo.fromJson(jsonDecode(jsonEncode(value))));
    });
    update();
  }

  void searchJo() {
    final String search = searchText.text;
    var dataSearch = dataJoListTemp.value.where((value) => ( value.joId.toString() == search || value.joId.toString().contains(search) )
        || ( value.sbuName?.toLowerCase() == search.toLowerCase() ||  (value.sbuName?.toLowerCase() ?? '').contains(search.toLowerCase()) )
        || ( value.kosName?.toLowerCase() == search.toLowerCase() || (value.kosName?.toLowerCase() ?? '').contains(search.toLowerCase()) )
        || ( value.companyName?.toLowerCase() == search.toLowerCase() || (value.companyName?.toLowerCase() ?? '').contains(search.toLowerCase()) )).toList();
    debugPrint('hasil search: ${jsonEncode(dataSearch)}');
    dataJoList.value = dataSearch;
    if(search == ''){
      dataJoList.value = dataJoListTemp.value;
      update();
    }
    update();
  }

  RxBool isLoadingSync = false.obs;
  Future<void>reload() async {
    try{
      isLoadingSync.value = true;
      await Future.delayed(Duration(seconds: 2));
      var connectivityResult = await Connectivity().checkConnectivity();
      debugPrint('print connectionresult ${connectivityResult}');
      if (connectivityResult[0] == ConnectivityResult.none) {
        throw Exception('No Internet Connection');
      }
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
      isLoadingSync.value = false;
    }catch(e){
      debugPrint('error ${e}');
      isLoadingSync.value = false;
    }
  }

}