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
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity_stages.dart';
import 'package:ops_mobile/data/sqlite.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:path_provider_android/path_provider_android.dart';

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
    // if(dataJoList.value.isNotEmpty) {
    //   dataJoList.value.forEach((list) async {
    //     await getJoInspectionActivity(list.joId ?? 0);
    //     if(inspectionActivityList.value.isNotEmpty) {
    //       inspectionActivityList.value.where((act) => act.mStatusinspectionstagesId == 1).toList();
    //       var activity = inspectionActivityList.value.where((act) => act.mStatusinspectionstagesId != 5 ).toList();
    //       var activity5 = inspectionActivityList.value.where((act) => act.mStatusinspectionstagesId == 5 ).toList();
    //       var activity6 = activity.where((act) => act.mStatusinspectionstagesId == 6 ).toList();
    //       debugPrint('inspection activity : ${jsonEncode(activity)}');
    //       debugPrint('inspection activity 5 : ${jsonEncode(activity5)}');
    //       debugPrint('inspection activity 6 : ${jsonEncode(activity6)}');
    //     }
    //   });
    // }
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

  Future<void> getDetailJo(int id)async{

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