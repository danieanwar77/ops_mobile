import 'package:ops_mobile/data/network.dart';
import 'package:ops_mobile/data/respository/repository.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class BaseController extends GetxController {
  final network = Get.find<NetworkCore>();
  final storage = Get.find<StorageCore>();
  final repository = Get.find<Repository>();
}
