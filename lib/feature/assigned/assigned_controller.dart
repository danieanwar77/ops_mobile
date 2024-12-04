import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/data/model/jo_assigned_model.dart';
import 'package:ops_mobile/data/model/jo_list_model.dart';
import 'package:ops_mobile/data/sqlite.dart';
import 'package:ops_mobile/data/storage.dart';

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

}