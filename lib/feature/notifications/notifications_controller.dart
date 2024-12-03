import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/data/model/login_data_model.dart';
import 'package:ops_mobile/data/model/t_m_notif.dart';
import 'package:ops_mobile/data/sqlite.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:ops_mobile/feature/detail/jo_detail_screen.dart';
import 'package:ops_mobile/feature/waiting/jo_waiting_screen.dart';

class NotificationsController extends BaseController{
  
  RxList<TMNotif> notifications = RxList();
  Rx<Data?> userData = Rx(Data());

  @override
  Future<void> onInit() async {
    final dataUser = jsonDecode(await StorageCore().storage.read('user'));
    userData.value = Data(
    id: dataUser.first['id'],
    fullname: dataUser.first['fullname'],
    nip: dataUser.first['e_number'],
    positionId: dataUser.first['jabatan_id'],
    position: dataUser.first['jabatan'],
    divisionId: dataUser.first['division_id'],
    division: dataUser.first['division'].toString(),
    superior: dataUser.first['superior_id'].toString());
    debugPrint('data user: ${jsonEncode(userData.value)}');
    getNotifications(dataUser.first['id']);
    //update();
    super.onInit();
  }

  void getNotifications(int employeeId) async {
    final db = await SqlHelper.db();
    debugPrint('print data employee id ${employeeId}');
    var data = await db.rawQuery('''
      SELECT a.id , a.jo_id, b.m_statusjo_id, a.id_trans, a.message, a.employee_id, a.link,a.flag_active, a.flag_read, a.created_by, a.created_at, a.updated_by, a.updated_at 
      FROM t_mnotif a
      INNER JOIN t_h_jo b ON b.id = a.jo_id where a.employee_id = ? 
    ''',[employeeId]);
    if(data.isNotEmpty){
      data.forEach((item){
        notifications.value.add(TMNotif.fromJson(item));
      });
    }
    update();
    debugPrint('notifications : ${jsonEncode(notifications.value)}');
  }

  void openNotification(int id, int idJo, int status) async {
    try{
      final db = await SqlHelper.db();
      db.execute('''
      UPDATE t_mnotif SET
        flag_read = 1
        WHERE
        id = $id
      ''');
    } catch(e){
      debugPrint(jsonEncode(e));
    }

    if(status == 1 || status == 2 || status == 3){
      Get.off<void>(JoDetailScreen.new, arguments: {
        'id': idJo,
        'status': status
      });
    } else {
      Get.off<void>(JoWaitingScreen.new, arguments: {
        'id': idJo,
        'status': status
      });
    }
  }
}