import 'package:get/get.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';

class DocumentsController extends BaseController{

  String documentType = '';

  @override
  void onInit()async{
    var arguments = await Get.arguments;
    documentType =  arguments['type'];
    update();
  }
}