import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/data/model/jo_inspection_send_manual_model.dart';
import 'package:ops_mobile/data/model/jo_list_model.dart';
import 'package:ops_mobile/data/model/login_data_model.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity_stages.dart';
import 'package:ops_mobile/data/sqlite.dart';
import 'package:ops_mobile/data/storage.dart';

class SendManualController extends BaseController{

  List<Map<String,String>> dataJo = [
    {
      "title" : "JO123 - JO On Progress",
      "data" : "2024-05-20  08:00:00"
    },
    {
      "title" : "JO234 - JO Waiting For Confirmation Client",
      "data" : "2024-05-20  06:00:00"
    },
  ];

  final List<String> listStatus = ['New', 'Assigned', 'On Progress', 'Waiting Approval Client', 'Completed', 'Waiting for Cancellation', 'Canceled'];

  Rx<Data?> userData = Rx(Data());

  RxList<DataJo> dataJoList = RxList();

  Rx<InspectionActivity> inspectionActivity = Rx(InspectionActivity());
  RxList<TDJoInspectionActivityStages> inspectionActivityList = RxList();
  RxList<File> activityAttachments = RxList();

  @override
  void onInit()async{
    var user = jsonDecode(await StorageCore().storage.read('login'));
    debugPrint('data user: ${user}');
    var data = await SqlHelper.getUserDetail(user['e_number'].toString());
    userData.value = Data(
        id : data.first['id'],
        fullname: data.first['fullname'],
        nip: data.first['e_number'],
        positionId: data.first['jabatan_id'],
        position: data.first['jabatan'],
        divisionId: data.first['division_id'],
        division: data.first['division'].toString(),
        superior: data.first['superior_id'].toString()
    );
    await getData();
  }

  void loadingDialog(List<Map<String,String>> joList){
    Get.dialog(
      AlertDialog(
        title: Center(child: Text("Pending Data",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
            ),
          )
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Mohon untuk tetap berada di halaman ini sampai proses selesai"),
            SizedBox(height: 16,),
            Column(
                children: [
                  for(var jo in joList) Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 0.1,
                              blurRadius: 7,
                              offset: Offset(0,8)
                          )
                        ]
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(jo["title"]!,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(jo["data"]!),
                        ),
                      ],
                    ),
                  )
                ]
            ),
            Center(
              child: LoadingAnimationWidget.prograssiveDots(color: primaryColor, size: 80),
            )
          ],
        ),
      ),
    );
  }

  void openDialog(String type, String text) {
    Get.dialog(
      AlertDialog(
        title: Text(type,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
          ),
        ),
        content: Text(text),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  Future<void> getData()async{
    await getListJo();
    if(dataJoList.value.isNotEmpty) {
      dataJoList.value.forEach((list) async {
        await getJoInspectionActivity(list.joId ?? 0);
        if(inspectionActivityList.value.isNotEmpty) {
          inspectionActivityList.value.where((act) => act.mStatusinspectionstagesId == 1).toList();
          var activity = inspectionActivityList.value.where((act) => act.mStatusinspectionstagesId != 5 ).toList();
          var activity5 = inspectionActivityList.value.where((act) => act.mStatusinspectionstagesId == 5 ).toList();
          var activity6 = activity.where((act) => act.mStatusinspectionstagesId == 6 ).toList();
          debugPrint('inspection activity : ${jsonEncode(activity)}');
          debugPrint('inspection activity 5 : ${jsonEncode(activity5)}');
          debugPrint('inspection activity 6 : ${jsonEncode(activity6)}');
        }
      });
      inspectionActivity.value = InspectionActivity(
        
      );
    }
  }

  Future<void> getListJo()async{
    final db = await SqlHelper.db();
    try{
      var query = '''
      SELECT 
      a.id as jo_id, 
      a.code, 
      b.id as id_h_so, 
      c.id as id_d_kos, 
      b.sbu_id, 
      d.name as sbu_name, 
      b.company_acc_id, 
      e.company_name, 
      a.m_statusjo_id, 
      f.name as statusjo_name, 
      g.name as kos_name, 
      a.created_at 
      FROM t_h_jo AS a 
      LEFT JOIN t_d_so_kos AS c ON a.m_kindofservice_id = c.id 
      LEFT JOIN t_h_so AS b ON a.t_so_id = b.id 
      LEFT JOIN m_sbu AS d ON d.id = b.sbu_id 
      LEFT JOIN t_h_lead_account AS e ON e.id = b.company_acc_id 
      LEFT JOIN m_statusjo AS f ON f.id = a.m_statusjo_id 
      LEFT JOIN m_kos AS g ON a.m_kindofservice_id = g.id 
      WHERE (a.pic_inspector = ${userData.value?.id ?? 0} OR a.pic_laboratory = ${userData.value?.id ?? 0})
      ''';
      final response = await db.rawQuery(query);
      response.forEach((value){
        dataJoList.value.add(DataJo.fromJson(jsonDecode(jsonEncode(value))));
      });
      update();
      debugPrint('data JOList : ${jsonEncode(dataJoList.value)}');
    } catch(e){

    } finally {
      update();
    }
  }

  Future<void> getDetailJo(int id)async{

  }

  Future<void> getJoInspectionActivity(int id)async{
    List<Map<String, dynamic>> result = [];
    final db = await SqlHelper.db();

    // Retrieve data from the database
    try {
      result = await db.rawQuery('''
         SELECT
         s.*, u.name as uom_name
         FROM t_d_jo_inspection_activity_stages AS s
          LEFT JOIN m_uom AS u ON s.uom_id = u.id
          WHERE s.t_h_jo_id = $id AND s.is_active = 1
        ''');

      /// Buffer the query
      debugPrint('data modifiable nya nih: ${jsonEncode(result)}');
      await Future<dynamic>.delayed(const Duration(milliseconds: 500));

      // Create a modifiable list of stages
      List<Map<String, dynamic>> modifiableResult =
      result.map((stage) => Map<String, dynamic>.from(stage)).toList();

      for (var stage in modifiableResult) {
        debugPrint('data modifiable update: ${jsonEncode(stage)}');
        int tHJoId = stage['t_h_jo_id'];
        int stageId = stage[
        'id']; // use this or 't_d_jo_inspection_activity_stages_id' if it exists
        int stageStatusId = stage['m_statusinspectionstages_id'];
        debugPrint('params nya ini: $tHJoId, $stageId, $stageStatusId');
        update();

        // Query related data from t_d_jo_inspection_activity
        List<Map<String, dynamic>> activityResult = await db.query(
          't_d_jo_inspection_activity',
          where:
          't_h_jo_id = ? and t_d_jo_inspection_activity_stages_id = ? and is_active = ?',
          // add additional criteria if necessary
          whereArgs: [tHJoId, stageId, 1],
        );
        debugPrint("print activity result 1517  ${activityResult}");

        List<Map<String, dynamic>> activityBarge = await db.query(
          't_d_jo_inspection_activity_barge',
          where:
          't_h_jo_id = ? and t_d_jo_inspection_activity_stages_id = ? and is_active = ?',
          // add additional criteria if necessary
          whereArgs: [tHJoId, stageId, 1],
        );

        List<Map<String, dynamic>> activityVessel = await db.query(
            't_d_jo_inspection_activity_vessel',
            where:
            't_h_jo_id = ? and t_d_jo_inspection_activity_stages_id = ? and is_active = ?',
            // add additional criteria if necessary
            whereArgs: [tHJoId, stageId, 1],
            limit: 1);

        List<Map<String, dynamic>> activityStageTranshipment =
        await db.rawQuery('''
          SELECT t.*, u.name as uom_name
          FROM t_d_jo_inspection_activity_stages_transhipment AS t
          LEFT JOIN m_uom AS u ON t.uom_id = u.id
          WHERE t.t_d_inspection_stages_id = ? AND t.is_active = ?
        ''', [stageId, 1]);

        debugPrint(
            "print stage Transhipment 1541 ${activityStageTranshipment}");
        // Add activityResult to the current stage
        stage['listactivity'] = activityResult;
        stage['listactivitybarge'] = activityBarge;
        stage['listactivitystagetranshipment'] = activityStageTranshipment;
        if (activityVessel.length > 0) {
          stage['activityvesel'] = activityVessel[0]; //first index
        } else {
          stage['activityvesel'] = null;
        }
      }

      // Convert the modifiableResult list to List<TDJoInspectionActivityStages>
      List<TDJoInspectionActivityStages> stagesList = modifiableResult
          .map((json) => TDJoInspectionActivityStages.fromJson(json))
          .toList();

      inspectionActivityList.value = stagesList;

      if (inspectionActivityList.value
          .where((item) => item.mStatusinspectionstagesId == 6)
          .isNotEmpty) {
        await getJoDailyActivity6AttachmentLocal(id);
      }

      debugPrint("print stage list 1559  ${jsonEncode(stagesList)}");
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      update();
    }
  }

  Future<void> getJoDailyActivity6AttachmentLocal(int id) async {
    final db = await SqlHelper.db();
    List<Map<String, dynamic>> result = await db.query(
      't_d_jo_inspection_attachment',
      where: 't_h_jo_id = ? and is_active = 1',
      whereArgs: [id],
    );

    debugPrint('activity stage 6 attachmentnya: ${jsonEncode(result)}');

    // dailyActivityPhotos.value = [];
    // dailyActivityPhotosDesc.value = [];
    // dailyActivityPhotosDescText.value = [];
    // dailyActivityPhotosV2.value = [];
    var attachments = result.map((json) {
      return File(json['path_name']);
    }).toList();
    update();

    activityAttachments.value = attachments;
    update();
  }

  Future<void> getJoLaboratoryActivity()async{

  }

  Future<void> getJoInspectionDocuments()async{

  }

  Future<void> getJoLaboratoryDocuments()async{

  }

}