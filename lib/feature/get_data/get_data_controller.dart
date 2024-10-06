import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';

class GetDataController extends BaseController{

  RxBool isLoading = false.obs;
  List<String> items = ['Internet','Penyimpanan'];
  RxString selectedValue = RxString('');
  TextEditingController dateTugas = TextEditingController();

  @override
  void onInit(){
    selectedValue.value = items.first;
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(Duration(days:1)),
        lastDate: DateTime(2101));
    if (picked != null) {
      dateTugas.text = DateFormat('yyyy-MM-dd').format(picked).toString();
      update();
    }
  }
}