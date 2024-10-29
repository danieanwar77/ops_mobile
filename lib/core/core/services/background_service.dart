import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/data/model/jo_send_model.dart';
import 'package:ops_mobile/data/network.dart';
import 'package:ops_mobile/data/respository/repository.dart';

class BackgroundService extends BaseController {
  //final dataController = Get.put(DataController()); // Inisialisasi

  // Ubah nama metode menjadi startService
  static void startService(ServiceInstance service) {
    // Timer untuk mengirim data setiap 15 menit
    Timer.periodic(Duration(minutes: 1), (timer) async {
      if (service is AndroidServiceInstance) {
        timer.cancel();
        return;
      }

      // Data yang akan dikirim ke API
      Map<String, dynamic> requestData = {
        "key1": "value1",
        "key2": "value2",
      };

      var data = Activity.fromJson({
        "t_h_jo_id" : 7,
        "m_statusinspectionstages_id" : 4,
        "trans_date" : "2024-08-31",
        "start_activity_time" : "15:00:00",
        "end_activity_time" : "16:00:00",
        "activity" : "Menunggu Kedatangan Kapal",
        "created_by" : 0,
        "remarks" : "testing"
      });
      print('data yang dikirim background service: ${jsonEncode(data)}');
      await sendJoActivityInspection(data);

      // Opsional: Update notifikasi
      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: "Background Service",
          content: "Last sent at ${DateTime.now()}",
        );
      }
    });
  }

  static Future<void> sendJoActivityInspection(Activity data) async {
    final repositoryBackground = Get.find<Repository>();
    try{
      var response = await repositoryBackground.insertActivityInspection(data);
      print('response background service : ${response.message}');
    } catch(e){
      print('response error background service : ${jsonEncode(e)}');
    }
  }
}