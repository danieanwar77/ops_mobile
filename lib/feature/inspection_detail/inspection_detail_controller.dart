import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';

class InspectionDetailController extends BaseController{

  late String documentType;
  RxList<Map<String, dynamic>> documents = RxList();
  RxList<File> documentsAttachments = RxList();

  @override
  void onInit(){
    var arguments = Get.arguments();
    documentType = arguments['type'] ?? '';
    documents.value = arguments['documents'] ?? [];
    documentsAttachments.value = arguments['attachments'] ?? [];
    update();
    debugPrint('document type : $documentType');
    debugPrint('documents : ${jsonEncode(documents.value)}');
    debugPrint('attachments : ${documentsAttachments.value.length}');
  }

}