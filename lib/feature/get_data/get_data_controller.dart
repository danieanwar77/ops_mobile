import 'package:get/get.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';

class GetDataController extends BaseController{

  RxBool isLoading = false.obs;
  List<String> items = ['item1','item2','item3'];
  RxString selectedValue = RxString('');

  @override
  void onInit(){
    selectedValue.value = items.first;
  }
}