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

  final List<String> listStatus = ['New', 'Assigned', 'On Progress', 'Waiting Approval Client', 'Completed', 'Waiting for Cancellation', 'Canceled'];
  RxInt statusJo = 0.obs;
  RxInt employeeId = 0.obs;

  @override
  void onInit()async {
    var argument = await Get.arguments;
    debugPrint('arguments : ${argument['status']}');
    statusJo.value = argument['status'];
    employeeId.value = argument['employeeId'];
    update();

    final data = await SqlHelper.getListJo(employeeId.value.toString(),statusJo.value.toString());
    debugPrint('data list : ${jsonEncode(data)}');
    // getJoList();
    await getJoListLocal();
    super.onInit();
  }

  void getJoList() async {
    var response = await repository.getJoList(statusJo.value, employeeId.value) ?? JoListModel();
    if(response.data!.data!.isNotEmpty){
      response.data!.data!.forEach((value){
        dataJoList.value.add(DataJo.fromJson(jsonDecode(jsonEncode(value))));
      });
    }
    debugPrint("JO List: ${jsonEncode(dataJoList.value)}");
    update();
  }

  Future<void> getJoListLocal() async{
    final data = await SqlHelper.getListJo(employeeId.value.toString(),statusJo.value.toString());
    data.forEach((value){
      dataJoList.value.add(DataJo.fromJson(jsonDecode(jsonEncode(value))));
    });
  }

}