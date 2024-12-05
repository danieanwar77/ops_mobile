import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:collection/collection.dart';
import 'package:encrypt/encrypt.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/data/model/jo_inspection_send_manual_model.dart';
import 'package:ops_mobile/data/model/jo_laboratory_send_manual_model.dart';
import 'package:ops_mobile/data/model/jo_list_model.dart';
import 'package:ops_mobile/data/model/login_data_model.dart';
import 'package:ops_mobile/data/model/send_manual_model.dart';
import 'package:ops_mobile/data/model/send_manual_v2.dart';
import 'package:ops_mobile/data/model/t_d_jo_document_inspection_v2.dart';
import 'package:ops_mobile/data/model/t_d_jo_document_laboratory_v2.dart';
import 'package:ops_mobile/data/model/t_d_jo_finalize_inspection_v2.dart';
import 'package:ops_mobile/data/model/t_d_jo_finalize_laboratory_v2.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity_stages.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity_stages_transhipment.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity_vessel.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_attachment.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_pict.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory_activity.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory_activity_stages.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory_attachment.dart';
import 'package:ops_mobile/data/model/t_h_jo.dart';
import 'package:ops_mobile/data/sqlite.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:ops_mobile/utils/helper.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:http/http.dart' as http;

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

  RxList<SendManualModel> dataJoList = RxList();

  final PathProviderAndroid providerAndroid = PathProviderAndroid();

  RxList<SendManualModel> joSendManualList = RxList();
  RxList<File> activityAttachments = RxList();
  RxList<SendManualV2> dataSendList = RxList();

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

  void loadingDialog(){
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
                  for(var data in dataJoList.value) Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
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
                            child: Text('JO${data.jo.toString()}',
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(data.transDate ?? '-'),
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
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
          ),
        ),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Future<void> getData()async{
    List<SendManualV2> data = await SendManualV2.dataPending();
    debugPrint('print data send manual ${jsonEncode(data)}');
    dataSendList.value = data;
    update();
  }

  Future<void> getListJo()async{
    try{
      var response = await SqlHelper.getDataInspectionForSendManual(userData.value!.id!.toInt());
      var text = '';
      var joGroup = groupBy(response, (item) => item['id']);

      joGroup.forEach((key,jo){
        debugPrint("jo nya: ${key}");
        List<InspectionActivity> inspectionActivity = [];
        List<FinalizeInspection> finalizeInspections = [];
        List<LaboratoryActivity> laboratoryActivity = [];
        List<FinalizeLaboratory>  finalizeLaboratories = [];
        var transactionDateTime = jo.first['stage_created_at'];
        var statusJo = jo.first['status_jo'];
        var typeGroup = groupBy(jo, (item) => item['jo_type']);
        typeGroup.forEach((typeKey,joType){
          debugPrint('type jo nya: ${typeKey}');
          var statusGroup = groupBy(joType, (item) => item['status_type']);
          if(typeKey == 'inspection'){
            statusGroup.forEach((statusKey,status){
              debugPrint("status nya: ${statusKey}");
              var stageGroup = groupBy(status, (item) => item['stage_id']);
              stageGroup.forEach((stageKey, stage){
                var inspection = {};
                debugPrint("stage nya: ${stageKey}");
                if(stageKey != null){

                  TdJoInspectionActivityStagesSm stageHead = TdJoInspectionActivityStagesSm();
                  List<TdJoInspectionActivitySm> activityItems = [];
                  ActivityWorkComplete workComplete = ActivityWorkComplete();
                  Header header = Header();
                  List<Barges>? barges = [];
                  List<Transhipment>? transhipment = [];
                  List<InspectionAttachments> attachments = [];

                  debugPrint('stage buat activity');

                  stage.forEach((stageItem){
                    debugPrint('si stage nya nih: ${jsonEncode(stageHead)}');
                    if(stageHead.id != stageItem['stage_id']){
                      stageHead = TdJoInspectionActivityStagesSm(
                          id: stageItem['stage_id'],
                          code: stageItem['stage_code'],
                          tHJoId:  stageItem['id'],
                          mStatusinspectionstagesId: stageItem['progress_id'],
                          transDate: stageItem['trans_date'],
                          remarks: stageItem['remarks'],
                          isActive: stageItem['is_active'],
                          isUpload: stageItem['is_upload'],
                          createdBy: stageItem['created_by'],
                          createdAt: stageItem['created_at'],
                          updatedBy: stageItem['updated_by'],
                          updatedAt: stageItem['updated_at']
                      );
                      update();
                    }
                    if (stageItem['progress_id'] == 5) {
                      if (activityItems.where((item) => item.code == stageItem['activity_code']).isEmpty) {
                        activityItems.add(TdJoInspectionActivitySm.fromJson({
                          "id": stageItem['activity_id'],
                          "code": stageItem['activity_code'],
                          "t_d_jo_inspection_activity_stages_id": stageItem['stage_id'],
                          "t_h_jo_id": stageItem['id'],
                          "start_activity_time": stageItem['start_activity_time'],
                          "end_activity_time": stageItem['end_activity_time'],
                          "activity": stageItem['activity'],
                          "is_active": stageItem['activity_is_active'],
                          "is_upload": stageItem['activity_is_upload'],
                          "created_by": stageItem['activity_created_by'],
                          "created_at": stageItem['activity_created_at'],
                          "updated_by": stageItem['activity_updated_by'],
                          "updated_at": stageItem['activity_updated_at']
                        }));
                        update();
                      }
                      if (header.code != stageItem['activity_code']) {
                        header = Header.fromJson({
                          "t_d_jo_inspection_activity_stages_id": stageItem['stage_id'],
                          "code": stageItem['activity_code'],
                          "actual_qty": stageItem['actual_qty'],
                          "uom_id": stageItem['uom_id'],
                          "vessel": {
                            "t_h_jo_id": stageItem['id'],
                            "t_d_jo_inspection_activity_stages_id": stageItem['stage_id'],
                            "vessel": stageItem['vessel'],
                            "code": stageItem['vessel_code'],
                            "is_active": stageItem['vessel_is_active'],
                            "is_upload": stageItem['vessel_is_upload'],
                            "created_by": stageItem['vessel_created_by'],
                            "created_at": stageItem['vessel_created_at'],
                            "updated_by": stageItem['vessel_updated_by'],
                            "updated_at": stageItem['vessel_updated_at']
                          }
                        });
                        update();
                      }
                      if ((stageItem['barge'] != null || stageItem['barge'] != '') && barges.where((item) => item.id == stageItem['barge_id']).isEmpty) {
                        barges.add(Barges.fromJson({
                          "id": stageItem['barge_id'],
                          "t_h_jo_id": stageItem['id'],
                          "t_d_jo_inspection_activity_stages_id": stageItem['stage_id'],
                          "barge": stageItem['barge'],
                          "code": stageItem['barge_code'],
                          "is_active": stageItem['barge_is_active'],
                          "is_upload": stageItem['barge_is_upload'],
                          "created_by": stageItem['barge_created_by'],
                          "created_at": stageItem['barge_created_at'],
                          "updated_by": stageItem['barge_updated_by'],
                          "updated_at": stageItem['barge_updated_at']
                        }));
                        update();
                      }
                      if ((stageItem['jetty'] != null || stageItem['jetty'] != '') && transhipment.where((item) => item!.id == stageItem['transhipment_id']).isEmpty) {
                        transhipment.add(Transhipment.fromJson({
                          "id": stageItem['transhipment_id'],
                          "t_d_jo_inspection_stages_id": stageItem['stage_id'],
                          "t_d_jo_inspection_activity_id": stageItem['activity_id'],
                          "initial_date": stageItem['initial_date'],
                          "final_date": stageItem['final_date'],
                          "jetty": stageItem['jetty'],
                          "delivery_qty": stageItem['delivery_qty'],
                          "is_active": stageItem['transhipment_is_active'],
                          "is_upload": stageItem['transhipment_is_upload'],
                          "created_by": stageItem['transhipment_created_by'],
                          "created_at": stageItem['transhipment_created_at'],
                          "updated_by": stageItem['transhipment_updated_by'],
                          "updated_at": stageItem['transhipment_updated_at']
                        }));
                        update();
                      }
                    } else if (stageItem['progress_id'] == 6) {
                      if ((stageItem['activity'] != null || stageItem['activity'] != '') && activityItems.where((item) => item.code == stageItem['activity_code']).isEmpty) {
                        activityItems.add(TdJoInspectionActivitySm.fromJson({
                          "id": stageItem['activity_id'],
                          "code": stageItem['activity_code'],
                          "t_d_jo_inspection_activity_stages_id": stageItem['stage_id'],
                          "t_h_jo_id": stageItem['id'],
                          "start_activity_time": stageItem['start_activity_time'],
                          "end_activity_time": stageItem['end_activity_time'],
                          "activity": stageItem['activity'],
                          "is_active": stageItem['activity_is_active'],
                          "is_upload": stageItem['activity_is_upload'],
                          "created_by": stageItem['activity_created_by'],
                          "created_at": stageItem['activity_created_at'],
                          "updated_by": stageItem['activity_updated_by'],
                          "updated_at": stageItem['activity_updated_at']
                        }));
                        update();
                      }
                      if ((stageItem['path_name'] != null || stageItem['path_name'] != '') && attachments.where((item) => item.id == stageItem['attachment_id']).isEmpty) {
                        attachments.add(InspectionAttachments.fromJson({
                          "id": stageItem['attachment_id'],
                          "t_h_jo_id": stageItem['id'],
                          "t_d_jo_inspection_activity_stages_id": stageItem['stage_id'],
                          "path_name": stageItem['path_name'],
                          "file_name": stageItem['file_name'],
                          "description": stageItem['description'],
                          "code": stageItem['attachment_code'],
                          "is_active": stageItem['attachment_is_active'],
                          "is_upload": stageItem['attachment_is_upload'],
                          "created_by": stageItem['attachment_created_by'],
                          "created_at": stageItem['attachment_created_at'],
                          "updated_by": stageItem['attachment_updated_by'],
                          "updated_at": stageItem['attachment_updated_at']
                        }));
                        update();
                      }
                    } else {
                      if ((stageItem['activity'] != null || stageItem['activity'] != '') && activityItems.where((item) => item.code == stageItem['activity_code']).isEmpty){
                        activityItems.add(TdJoInspectionActivitySm.fromJson({
                          "id": stageItem['activity_id'],
                          "code": stageItem['activity_code'],
                          "t_d_jo_inspection_activity_stages_id": stageItem['stage_id'],
                          "t_h_jo_id": stageItem['id'],
                          "start_activity_time": stageItem['start_activity_time'],
                          "end_activity_time": stageItem['end_activity_time'],
                          "activity": stageItem['activity'],
                          "is_active": stageItem['activity_is_active'],
                          "is_upload": stageItem['activity_is_upload'],
                          "created_by": stageItem['activity_created_by'],
                          "created_at": stageItem['activity_created_at'],
                          "updated_by": stageItem['activity_updated_by'],
                          "updated_at": stageItem['activity_updated_at']
                        }));
                        update();
                      }
                    }

                  });
                  //debugPrint('isian inspection activity: ${jsonEncode(inspection)}');
                  if(inspection != InspectionActivity()){
                    inspectionActivity.add(InspectionActivity(
                        tDJoInspectionActivityStages: stageHead,
                        tDJoInspectionActivity: activityItems,
                        activityWorkComplete: ActivityWorkComplete(
                            header: header,
                            barges: barges,
                            transhipment: transhipment
                        ),
                        attachments: attachments
                    ));
                    update();
                    debugPrint('isian inspection activity: ${jsonEncode(inspectionActivity.last)}');
                  }
                } else {

                  debugPrint('stage buat finalize inspection');

                  var finalizeGroup = groupBy(stage, (stage) => stage['finalize_id']);

                  finalizeGroup.forEach((key, finalizeItem){
                    FinalizeInspection finalizeInspection = FinalizeInspection();
                    List<InspectionDocuments> documents = [];
                    finalizeItem.forEach((stageItem){
                      if(stageItem['finalize_id'] != null){
                        if(documents.where((item) => item.id == stageItem['document_id']).isEmpty){
                          documents.add(InspectionDocuments(
                              id: stageItem['document_id'],
                              pathFile: stageItem['document_path_file'],
                              fileName: stageItem['documment_file_name']
                          ));
                          update();
                        }

                        finalizeInspection = FinalizeInspection(
                            id: stageItem['finalize_id'],
                            noReport: stageItem['no_report'],
                            dateReport : stageItem['date_report'],
                            noBlankoCertificate : stageItem['no_blanko_certificate'],
                            lhvNumber : stageItem['lhv_number'],
                            lsNumber : stageItem['ls_number'],
                            documents: documents
                        );
                        update();
                      }
                    });
                    if(key != null){
                      finalizeInspections.add(finalizeInspection);
                      update();
                      debugPrint('finalize inspection nya: ${jsonEncode(finalizeInspections.last)}');
                    }
                  });
                }
              });
            });
          } else if(typeKey == 'laboratory'){
            statusGroup.forEach((statusKey,status){
              debugPrint("status nya: ${statusKey}");
              var labGroup = groupBy(status, (item) => item['laboratorium_id']);
              labGroup.forEach((labKey,labItem){
                debugPrint("lab nya: $labKey");
                if(labKey != null){
                  var stageGroup = groupBy(labItem, (item) => item['stage_id']);

                  stageGroup.forEach((stageKey, stage){
                    var laboratory = {};
                    debugPrint("stage nya: ${stageKey}");

                    if(stageKey != null){
                      TDJoLaboratoryActivityStagesSm stageHead = TDJoLaboratoryActivityStagesSm();
                      List<TDJoLaboratoryActivitySm> activityItems = [];
                      IssuedAnalyzedResult issuedAnalyzedResult = IssuedAnalyzedResult();
                      List<LaboratoryAttachment> attachments = [];

                      stage.forEach((stageItem){
                        debugPrint('si stage nya nih: ${jsonEncode(stageItem)}');
                        if(stageHead.id != stageItem['stage_id']){
                          stageHead = TDJoLaboratoryActivityStagesSm(
                              id: stageItem['stage_id'],
                              code: stageItem['stage_code'],
                              tDJoLaboratoryId: stageItem['jo_laboratory_id'],
                              tHJoId:  stageItem['id'],
                              mStatuslaboratoryprogresId: stageItem['progress_id'],
                              transDate: stageItem['trans_date'],
                              remarks: stageItem['remarks'],
                              isActive: stageItem['is_active'],
                              isUpload: stageItem['is_upload'],
                              createdBy: stageItem['created_by'],
                              createdAt: stageItem['created_at'],
                              updatedBy: stageItem['updated_by'],
                              updatedAt: stageItem['updated_at']
                          );
                          update();
                        }
                        if (stageItem['progress_id'] == 5) {
                          var dateTime = stageItem['stage_created_at'].split(' ');
                          var date = dateTime.first;
                          var time = dateTime.last;
                          update();
                          if(activityItems.where((item) => item.tDJoLaboratoryActivityStagesId == stageItem['stage_id']).isEmpty){
                            issuedAnalyzedResult = IssuedAnalyzedResult.fromJson({
                              "t_d_jo_laboratory_activity_stages_id" : stageItem['stage_id'],
                              "t_d_jo_laboratory_id" : stageItem['jo_laboratory_id'],
                              "activity_date" : date,
                              "activity_time" : time,
                              "total_sample_received" : stageItem['total_sample_received'],
                              "total_sample_analyzed" : stageItem['total_sample_analyzed'],
                              "total_sample_preparation" : stageItem['total_sample_preparation'],
                            });
                            update();
                          }
                          if (activityItems.where((item) => item.code == stageItem['activity_code']).isEmpty) {
                            activityItems.add(TDJoLaboratoryActivitySm.fromJson({
                              "id": stageItem['activity_id'],
                              "code": stageItem['activity_code'],
                              "t_d_jo_laboratory_id": stageItem['jo_laboratory_id'],
                              "t_d_jo_laboratory_activity_stages_id": stageItem['stage_id'],
                              "t_h_jo_id": stageItem['id'],
                              "start_activity_time": stageItem['start_activity_time'],
                              "end_activity_time": stageItem['end_activity_time'],
                              "activity": stageItem['activity'],
                              "is_active": stageItem['activity_is_active'],
                              "is_upload": stageItem['activity_is_upload'],
                              "created_by": stageItem['activity_created_by'],
                              "created_at": stageItem['activity_created_at'],
                              "updated_by": stageItem['activity_updated_by'],
                              "updated_at": stageItem['activity_updated_at']
                            }));
                            update();
                          }
                        } else if (stageItem['progress_id'] == 6) {
                          if ((stageItem['activity'] != null || stageItem['activity'] != '') && activityItems.where((item) => item.code == stageItem['activity_code']).isEmpty) {
                            activityItems.add(TDJoLaboratoryActivitySm.fromJson({
                              "id": stageItem['activity_id'],
                              "code": stageItem['activity_code'],
                              "t_d_jo_laboratory_id": stageItem['jo_laboratory_id'],
                              "t_d_jo_laboratory_activity_stages_id": stageItem['stage_id'],
                              "t_h_jo_id": stageItem['id'],
                              "start_activity_time": stageItem['start_activity_time'],
                              "end_activity_time": stageItem['end_activity_time'],
                              "activity": stageItem['activity'],
                              "is_active": stageItem['activity_is_active'],
                              "is_upload": stageItem['activity_is_upload'],
                              "created_by": stageItem['activity_created_by'],
                              "created_at": stageItem['activity_created_at'],
                              "updated_by": stageItem['activity_updated_by'],
                              "updated_at": stageItem['activity_updated_at']
                            }));
                            update();
                          }
                          if ((stageItem['path_name'] != null || stageItem['path_name'] != '') && attachments.where((item) => item.id == stageItem['attachment_id']).isEmpty) {
                            attachments.add(LaboratoryAttachment.fromJson({
                              "id": stageItem['attachment_id'],
                              "t_h_jo_id": stageItem['id'],
                              "t_d_jo_laboratory_id": stageItem['jo_laboratory_id'],
                              "t_d_jo_laboratory_activity_stages_id": stageItem['stage_id'],
                              "path_name": stageItem['path_name'],
                              "file_name": stageItem['file_name'],
                              "description": stageItem['description'],
                              "code": stageItem['attachment_code'],
                              "is_active": stageItem['attachment_is_active'],
                              "is_upload": stageItem['attachment_is_upload'],
                              "created_by": stageItem['attachment_created_by'],
                              "created_at": stageItem['attachment_created_at'],
                              "updated_by": stageItem['attachment_updated_by'],
                              "updated_at": stageItem['attachment_updated_at']
                            }));
                            update();
                          }
                        } else {
                          if ((stageItem['activity'] != null || stageItem['activity'] != '') && activityItems.where((item) => item.code == stageItem['activity_code']).isEmpty){
                            activityItems.add(TDJoLaboratoryActivitySm.fromJson({
                              "id": stageItem['activity_id'],
                              "code": stageItem['activity_code'],
                              "t_d_jo_laboratory_id": stageItem['jo_laboratory_id'],
                              "t_d_jo_laboratory_activity_stages_id": stageItem['stage_id'],
                              "t_h_jo_id": stageItem['id'],
                              "start_activity_time": stageItem['start_activity_time'],
                              "end_activity_time": stageItem['end_activity_time'],
                              "activity": stageItem['activity'],
                              "is_active": stageItem['activity_is_active'],
                              "is_upload": stageItem['activity_is_upload'],
                              "created_by": stageItem['activity_created_by'],
                              "created_at": stageItem['activity_created_at'],
                              "updated_by": stageItem['activity_updated_by'],
                              "updated_at": stageItem['activity_updated_at']
                            }));
                            update();
                          }
                        }
                      });

                      if(laboratory != LaboratoryActivity()){
                        laboratoryActivity.add(LaboratoryActivity(
                          tDJoLaboratoryActivityStages: stageHead,
                          tDJoLaboratoryActivity: activityItems,
                          issuedAnalyzedResult: issuedAnalyzedResult,
                          attachment: attachments,
                        ));
                        update();
                        debugPrint('isian laboratory activity: ${jsonEncode(laboratoryActivity.last)}');
                      }
                    }
                    else {
                      debugPrint('stage buat finalize laboratory');

                      var finalizeGroup = groupBy(stage, (stage) => stage['finalize_id']);

                      finalizeGroup.forEach((key, finalizeItem){
                        FinalizeLaboratory finalizeLaboratory = FinalizeLaboratory();
                        List<LaboratoryDocuments> documents = [];
                        finalizeItem.forEach((stageItem){
                          if(stageItem['finalize_id'] != null){
                            if(documents.where((item) => item.id == stageItem['document_id']).isEmpty){
                              documents.add(LaboratoryDocuments(
                                  id: stageItem['document_id'],
                                  pathFile: stageItem['document_path_file'],
                                  fileName: stageItem['documment_file_name']
                              ));
                              update();
                            }

                            finalizeLaboratory = FinalizeLaboratory(
                                id: stageItem['finalize_id'],
                                noReport: stageItem['no_report'],
                                dateReport : stageItem['date_report'],
                                noBlankoCertificate : stageItem['no_blanko_certificate'],
                                lhvNumber : stageItem['lhv_number'],
                                lsNumber : stageItem['ls_number'],
                                documents: documents
                            );
                            update();
                          }
                        });
                        if(key != null){
                          finalizeLaboratories.add(finalizeLaboratory);
                          update();
                          debugPrint('finalize laboratorynya nya: ${jsonEncode(finalizeLaboratories.last)}');
                        }
                      });
                    }
                  });
                }
              });

            });
          }

        });

        joSendManualList.value.add(SendManualModel(
              jo : key,
              status : statusJo,
              transDate : transactionDateTime,
              inspection : JoInspectionSendManualModel(
                inspectionActivity: inspectionActivity,
                finalizeInspection: finalizeInspections,
              ),
              laboratory : JoLaboratorySendManualModel(
                laboratoryActivity: laboratoryActivity,
                finalizeLaboratory: finalizeLaboratories,
              ),
        ));

        // text = jsonEncode({
        //   "inspection activity" : inspectionActivity,
        //   "finalize inspection" : finalizeInspections,
        // });
      });

      text = jsonEncode(joSendManualList.value);
      update();

      final directory = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
      final File file = File('$directory/settings.txt');
      await file.writeAsString(text);
    } catch(e){
      debugPrint('error get data: $e');
    } finally {
      update();
    }
  }

  Future<void> makeAFile()async{
    var text = jsonEncode(dataJoList.value);
    update();
    final directory = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    final File file = File('$directory/joList.json');
    await file.writeAsString(text);
    dataJoList.value = [];
  }

  Future<bool> sendSingleData(SendManualV2 sendData) async{
    int type = sendData.type == null ? 0 : sendData!.type!.toInt();
    bool connection = await Helper.checkConnection();
    if(!connection){
      openDialog("Attenction", "Periksa koneksi ada");
      return false;
    }else{
      switch(type){
        case 1: {
          return await sendInspectionActivity(sendData);
        }
        case 2: {
          return await sendInspectionPhoto(sendData);
        }
        case 3:{
          return await  sendInspectionFinalize(sendData);
        }
        case 4: {
          return await sendLaboratoryActivity(sendData);
        }
        case 5: {
          return await sendLaboratoryFinalize(sendData);
        }
        default: {
          return false;
        }
      }
    }
  }

  Future<bool> sendLaboratoryFinalize(SendManualV2 sendData) async {
    try{
      int id = sendData.idTrans ==  null ? 0 : sendData.idTrans!.toInt();
      TDJoFinalizeLaboratoryV2? dataLaboratory = await TDJoFinalizeLaboratoryV2.getSendDataById(id);
      bool connection = await Helper.checkConnection();
      if(dataLaboratory != null && connection){
        List<TDJoDocumentLaboratoryV2> details = dataLaboratory.listDocument ?? [];
        for(int d = 0; d< details.length; d++){
          TDJoDocumentLaboratoryV2 detail = details[d];
          final filename = detail.fileName ?? ''; // contoh data asdasdasdasd.adasdasd.asdasdasd.pdf
          final fileType = RegExp(r'\.([a-zA-Z0-9]+)$').firstMatch(filename)?.group(1) ?? '';
          final base64 = await Helper.convertPhotosToBase64(detail.pathFile ?? '');
          detail.pathFile = '${base64}';
        }
        debugPrint('print data finalize laboratory ${jsonEncode(dataLaboratory)}');
        final response = await http.post(
            Uri.parse('${Helper.baseUrl()}/api/v1/laboratory/document'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(dataLaboratory)
        );
        if(response.statusCode == 200){
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          print('print response from api ${jsonEncode(responseData)}');
          if(responseData['status'] != 500){
            dynamic dataList = responseData['data'];
            TDJoFinalizeLaboratoryV2 item = TDJoFinalizeLaboratoryV2.fromJson(dataList as Map<String, dynamic>);
            await TDJoFinalizeLaboratoryV2.updateUploaded(item.code ?? '');
            List<TDJoDocumentLaboratoryV2> documents = item.listDocument ?? [];
            for(int d = 0; d < documents.length; d++){
              TDJoDocumentLaboratoryV2 document = documents[d];
              await TDJoDocumentLaboratoryV2.updateUploaded(document.code ?? '');
            }
          }else{
            return false;
          }
        }else{
          return false;
        }
      }else{
        return false;
      }
      return true;
    }catch(e){
      return false;
    }
  }
  
  Future<bool> sendInspectionFinalize(SendManualV2 sendData) async{
    try{
      int id = sendData.idTrans ==  null ? 0 : sendData.idTrans!.toInt();
      TDJoFinalizeInspectionV2? dataFinalize = await TDJoFinalizeInspectionV2.getSendDataById(id);
      debugPrint("print data finalize inspection ${jsonEncode(dataFinalize)}");
      if(dataFinalize != null){
        TDJoFinalizeInspectionV2 item = dataFinalize;
        List<TDJoDocumentInspectionV2> details = item.listDocument ?? [];
        for(int d = 0; d< details.length; d++){
          TDJoDocumentInspectionV2 detail = details[d];
          final filename = detail.fileName ?? ''; // contoh data asdasdasdasd.adasdasd.asdasdasd.pdf
          final fileType = RegExp(r'\.([a-zA-Z0-9]+)$').firstMatch(filename)?.group(1) ?? '';
          final base64 = await Helper.convertPhotosToBase64(detail.pathFile ?? '');
          detail.pathFile = '${base64}';
        }

        final response = await http.post(
            Uri.parse('${Helper.baseUrl()}/api/v1/inspection/document'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(dataFinalize)
        );
        if(response.statusCode == 200){
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          print('print response from api ${jsonEncode(responseData)}');
          if(responseData['status'] != 500){
            dynamic dataList = responseData['data'];
            TDJoFinalizeInspectionV2 data = TDJoFinalizeInspectionV2.fromJson(dataList as Map<String, dynamic>);
            await TDJoFinalizeInspectionV2.updateUploaded(data.code ?? '');
            List<TDJoDocumentInspectionV2> documents = data.listDocument ?? [];
            for(int d = 0; d < documents.length; d++){
              TDJoDocumentInspectionV2 document = documents[d];
              await TDJoDocumentInspectionV2.updateUploaded(document.code ?? '');
            }
            return true;
          }else{
            return false;
          }
        }else{
          return false;
        }
      }
      return true;
    }catch(e){
      debugPrint("print failed send data finalize inspection ${e}");
      return false;
    }
  }

  Future<bool> sendInspectionActivity(SendManualV2 sendData) async{
    try{
      debugPrint('print function sendDataInspection manual ');
      int id = sendData.idTrans ==  null ? 0 : sendData.idTrans!.toInt();
      THJo dataActivity = await THJo.getJoActivitySendById(id);
      List<TDJoInspectionActivityStages> stages = dataActivity.inspectionActivityStages ?? [];
      for(int s = 0; s < stages.length; s++){
        TDJoInspectionActivityStages stage = stages[s];
        debugPrint("debug print stage ${jsonEncode(stage)}");
      }
      bool connection = await Helper.checkConnection();
      if(!dataActivity.id.isNull && dataActivity.id != null && Helper.baseUrl().isNotEmpty){
        final response = await http.post(
            Uri.parse('${Helper.baseUrl()}/api/v1/inspection/activity'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(dataActivity.toSend())
        );
        debugPrint('print response kirim data jo  ${response.body}');
        if(response.statusCode == 200){
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          if(responseData['status'] != 500){
            final data = responseData['data'];
            THJo  thJo = THJo.fromJson(data);
            debugPrint('print data jo yang berhasil terkirim ${jsonEncode(data)}');
            List<TDJoInspectionActivityStages> stageSend = thJo.inspectionActivityStages ?? [];
            for(int s = 0; s < stageSend.length; s++){
              TDJoInspectionActivityStages dataStage = stageSend[s];
              await TDJoInspectionActivityStages.updateUploaded(dataStage.code ?? '');
              if(dataStage.listActivity != null){
                List<TDJoInspectionActivity> dataActs = dataStage.listActivity ?? [];
                for(int a= 0; a < dataActs.length; a++){
                  TDJoInspectionActivity  dataAct = dataActs[a];
                  await TDJoInspectionActivity.updateUploaded(dataAct.code ?? '');
                }
              }
              if(dataStage.listAttachment != null){
                List<TDJoInspectionAttachment> attachments = dataStage.listAttachment ?? [];
                for(int a=0; a <attachments.length; a++){
                  await TDJoInspectionAttachment.updateUploaded(attachments[a].code ?? '');
                }
              }
              if(dataStage.listActivityVessel != null){
                List<TDJoInspectionActivityVessel> vessels = dataStage.listActivityVessel ?? [];
                for(int v = 0; v < vessels.length; v++){
                  await TDJoInspectionActivityVessel.updateUploaded(vessels[v].code ?? '');
                }
              }
              if(dataStage.listActivityStageTranshipment != null){
                List<TDJoInspectionActivityStagesTranshipment> transhipments = dataStage.listActivityStageTranshipment ?? [];
                for(int t = 0; t < transhipments.length; t++){
                  await TDJoInspectionActivityStagesTranshipment.updateUploaded(transhipments[t].code ?? '');
                }
              }
            }
          }else{
            return false;
          }
        }else{
          return false;
        }
      }
      return true;
    }catch(e){
      return false;
    }
  }

  Future<bool> sendInspectionPhoto(SendManualV2 sendData) async{
    try{
      debugPrint('print sendDatamanual ');
      int id = sendData.idTrans == null ? 0 : sendData.idTrans!.toInt();
      List<TDJoInspectionPict> dataSend = await TDJoInspectionPict.getSendDataPictById(id);

      if(dataSend.isNotEmpty){
        for(TDJoInspectionPict data in dataSend){
          final base64 = await Helper.convertPhotosToBase64(data.pathPhoto ?? '');//
          data.pathPhoto = 'data:image/png;base64,${base64}';
        }
        debugPrint('print payload inspection photo yang dikirim ${jsonEncode(dataSend)}');
        final response = await http.post(
            Uri.parse('${Helper.baseUrl()}/api/v1/inspection/photo'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(dataSend)
        );
        debugPrint('Data berhasil dikirim: ${response.body}');
        if(response.statusCode == 200){
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          print('print response from api ${jsonEncode(responseData)}');
          if(responseData['status'] != 500){
            List<dynamic> dataList = responseData['data'];
            List<TDJoInspectionPict> data = dataList
                .map((item) => TDJoInspectionPict.fromJson(item as Map<String, dynamic>))
                .toList();
            for(int p = 0; p < data.length; p++){
              TDJoInspectionPict item = data[p];
              await TDJoInspectionPict.updateUploaded(item.code ?? '');
            }
          }else{
            return false;
          }
        }
      }
      return true;
    }catch(e){
      return false;
    }
  }

  Future<bool> sendLaboratoryActivity(SendManualV2 sendData) async{
    try{
        int id = sendData.idTrans ==  null ? 0 : sendData.idTrans!.toInt();
        THJo dataActivity = await THJo.getJoLaboratorySend();
        List<TDJoLaboratory> laboratories = dataActivity.laboratory ?? [];
        for(int i = 0; i < laboratories.length; i++){
          List<TDJoLaboratoryActivityStages> stages = laboratories[i].laboratoryActivityStages ?? [];
          for(int s = 0; s < stages.length; s++){
            if(stages[s].mStatuslaboratoryprogresId == 6){
              List<TDJoLaboratoryAttachment> attachments = stages[s].listLabAttachment ?? [];
              for(int a = 0; a < attachments.length; a++){
                attachments[a].pathName = await Helper.convertPhotosToBase64(attachments[a].pathName ?? '');
              }
            }
          }
        }
        if(dataActivity.id != null && Helper.baseUrl().isNotEmpty){
          //send data
          final response = await http.post(
            Uri.parse('${Helper.baseUrl()}/api/v1/laboratory/activity'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(dataActivity.toSend()),
          );
          if(response.statusCode == 200) {
            final Map<String, dynamic> responseData = jsonDecode(response.body);
            print('print response from api ${jsonEncode(responseData)}');
            if (responseData['status'] != 500) {
              final data = responseData['data'];
              TDJoLaboratory joLaboratory = TDJoLaboratory.fromJson(data);
              debugPrint('print data response jo laboratory ${jsonEncode(joLaboratory)}');
              List<TDJoLaboratoryActivityStages> listLabStage = joLaboratory.laboratoryActivityStages ?? [];
              debugPrint('print data response list lab stage ${jsonEncode(listLabStage)}');
              for (int s = 0; s < listLabStage.length; s++) {
                TDJoLaboratoryActivityStages stage = listLabStage[s];
                debugPrint('print data response stage ${jsonEncode(stage)}');
                await TDJoLaboratoryActivityStages.updateUploaded(stage.code.toString());
                List<TDJoLaboratoryActivity> activities = listLabStage[s].listLabActivity ?? [];
                for (int a = 0; a < activities.length; a++) {
                  TDJoLaboratoryActivity activity = activities[a];
                  debugPrint('print data response activity ${jsonEncode(activity)}');
                  await TDJoLaboratoryActivity.updateUploaded(activity.code ?? '');
                }

                if(stage.mStatuslaboratoryprogresId == 6){
                  List<TDJoLaboratoryAttachment> attachments = stage.listLabAttachment ?? [];
                  for(int at = 0; at < attachments.length; at++){
                    await TDJoLaboratoryAttachment.updateUploaded(attachments[at].code ?? '');
                  }
                }
              }
            }else{
              return false;
            }
          }else{
            return false;
          }
        }
        return true;
    }catch(e){
      return false;
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

}