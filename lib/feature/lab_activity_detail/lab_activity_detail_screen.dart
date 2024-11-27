import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory_attachment.dart';
import 'package:ops_mobile/feature/lab_activity_detail/lab_activity_detail_controller.dart';
import 'package:ops_mobile/utils/helper.dart';

class LabActivityDetailScreen extends StatelessWidget{
  const LabActivityDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: LabActivityDetailController(),
        builder: (controller) => Scaffold(
          appBar: AppBar(
            actions: [
              controller.activity6ListStages.value.isNotEmpty && controller.activityLabStage == 6 ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                    backgroundColor: green,
                    child: Image.asset(
                        'assets/icons/finishjo.png',
                        width: 21,
                        height: 21
                    )),
              ) : const SizedBox(),
            ],
            centerTitle: false,
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            automaticallyImplyLeading: true,
            title: const Text(
              'JO Details',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 16),
            ),
          ),
          body: SafeArea( child:
          SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Obx(() => Column(
                    children: [
                      SizedBox(
                        child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(controller.labName ?? '-',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700
                                    ),
                                  ),
                                  const SizedBox(height: 16,),
                                  Row(
                                    children: [
                                      const Expanded( child:
                                      Text('Prelim',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700
                                        ),
                                      ),
                                      ),
                                      const VerticalDivider(width: 1),
                                      const SizedBox(width:16),
                                      Expanded( child:
                                      Text(controller.prelim.value ?? '-',
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      )
                                    ],
                                  ),
                                  const Divider(
                                      thickness: 0.4
                                  ),
                                  Row(
                                    children: [
                                      const Expanded( child:
                                      Text('TAT',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700
                                        ),
                                      ),
                                      ),
                                      const VerticalDivider(width: 1),
                                      const SizedBox(width:16),
                                      Expanded( child:
                                      Text('${controller.tat.value.toString() ??  '-'} Jam',
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      )
                                    ],
                                  ),
                                  const Divider(
                                      thickness: 0.4
                                  ),
                                ],
                              ),
                            )
                        ),
                      ),
                      const SizedBox( height: 16),
                      SizedBox(
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                    children: [
                                      Row(
                                          children: [
                                            Text('Daily Activity',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: primaryColor
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            (controller.activityLabStage == 1 ) ? Container(
                                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text('New',
                                                    style: TextStyle(
                                                        color: Colors.white
                                                    )
                                                )
                                            ) : const SizedBox(),
                                            Spacer(),
                                            controller.activity6ListStages.value.isEmpty && (controller.statusId == 2 || controller.statusId == 3) ? IconButton(
                                                onPressed: (){
                                                  if(controller.activitySubmitted.value == true){
                                                    controller.activityLabStage == 1 ? controller.nextStageActivityConfirm() :
                                                    controller.activityLabStage > 1 && controller.activityLabStage < 5 ? controller.nextStageActivityConfirm()
                                                        : controller.activityLabStage == 5 ? controller.nextStageActivity5LabConfirm()
                                                        : controller.finishStageActivityConfirm();
                                                  } else {
                                                    controller.activityLabStage == 1 ? controller.drawerDailyActivityLab() :
                                                    controller.activityLabStage > 1 && controller.activityLabStage < 5 ? controller.drawerDailyActivityLab()
                                                        : controller.activityLabStage == 5 ? controller.drawerDailyActivity5Lab()
                                                        : controller.drawerDailyActivity6();
                                                  }
                                                },
                                                icon: Image.asset('assets/icons/addactivity.png', height: 32,)
                                            ) : const SizedBox(),
                                          ]
                                      ),
                                      const SizedBox(height: 16),
                                      controller.activityLabListStages.value.isNotEmpty ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:[
                                            controller.activityLabListStages.value.where((item) => item.mStatuslaboratoryprogresId == 1).isNotEmpty ? Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text('Stage 1: Sample on Delivery',
                                                        style: TextStyle(
                                                            color: green,
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w700
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      controller.activityLabStage == 1 ? InkWell(
                                                          onTap: () {
                                                            controller.drawerDailyActivityLabEdit();
                                                          },
                                                          child: const Icon(
                                                              Icons
                                                                  .mode_edit_outlined,
                                                              color:
                                                              primaryColor,
                                                              size: 18
                                                          )
                                                      ) : const SizedBox(),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  for(var progressActivity in controller.activityLabListStages.value.where((item) => item.mStatuslaboratoryprogresId == 1)) Column(
                                                      children:[
                                                        Row(
                                                          children: [
                                                            Expanded( child:
                                                            Text('Date',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            ),
                                                            ),
                                                            VerticalDivider(width: 1),
                                                            SizedBox(width:16),
                                                            Expanded( child:
                                                            Text(progressActivity.transDate ?? '-',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            )
                                                          ],
                                                        ),
                                                        const Divider(
                                                            thickness: 0.4
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child:
                                                              Text('Activities',
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w700
                                                                ),
                                                              ),
                                                            ),
                                                            VerticalDivider(width: 1),
                                                            SizedBox(width:8),
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  ListView.builder(
                                                                      shrinkWrap: true,
                                                                      physics: NeverScrollableScrollPhysics(),
                                                                      itemCount: progressActivity.listLabActivity?.length,
                                                                      itemBuilder: (context, indexItem){
                                                                        var activityItem = progressActivity.listLabActivity![indexItem];
                                                                        return Row(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                '${activityItem.startActivityTime ?? '-'} - ${activityItem.endActivityTime ?? '-'}',
                                                                                style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .w700),
                                                                              ),
                                                                            ),
                                                                            VerticalDivider(width: 1),
                                                                            SizedBox(width: 8),
                                                                            Expanded(
                                                                              flex: 2,
                                                                              child: Text(
                                                                                activityItem.activity ?? '-',
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        );
                                                                      })
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(
                                                            thickness: 0.4
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded( child:
                                                            Text('Remarks',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            ),
                                                            ),
                                                            VerticalDivider(width: 1),
                                                            SizedBox(width:16),
                                                            Expanded( child:
                                                            Text(progressActivity.remarks ?? '-',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            )
                                                          ],
                                                        ),
                                                        const Divider(
                                                            thickness: 0.4
                                                        ),
                                                      ]
                                                  ),
                                                ]
                                            ) : const SizedBox(),
                                            controller.activityLabListStages.value.where((item) => item.mStatuslaboratoryprogresId == 2).isNotEmpty ? Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text('Stage 2: Sample Received',
                                                        style: TextStyle(
                                                            color: green,
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w700
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      controller.activityLabStage == 2 ? InkWell(
                                                          onTap: () {
                                                            controller.drawerDailyActivityLabEdit();
                                                          },
                                                          child: Icon(
                                                              Icons
                                                                  .mode_edit_outlined,
                                                              color:
                                                              primaryColor,
                                                              size: 18
                                                          )
                                                      ) : const SizedBox(),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  for(var progressActivity in controller.activityLabListStages.value.where((item) => item.mStatuslaboratoryprogresId == 2)) Column(
                                                      children:[
                                                        Row(
                                                          children: [
                                                            Expanded( child:
                                                            Text('Date',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            ),
                                                            ),
                                                            VerticalDivider(width: 1),
                                                            SizedBox(width:16),
                                                            Expanded( child:
                                                            Text(progressActivity.transDate ?? '-',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            )
                                                          ],
                                                        ),
                                                        const Divider(
                                                            thickness: 0.4
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child:
                                                              Text('Activities',
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w700
                                                                ),
                                                              ),
                                                            ),
                                                            VerticalDivider(width: 1),
                                                            SizedBox(width:8),
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  ListView.builder(
                                                                      shrinkWrap: true,
                                                                      physics: NeverScrollableScrollPhysics(),
                                                                      itemCount: progressActivity.listLabActivity?.length,
                                                                      itemBuilder: (context, indexItem){
                                                                        var activityItem = progressActivity.listLabActivity![indexItem];
                                                                        return Row(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                '${activityItem.startActivityTime ?? '-'} - ${activityItem.endActivityTime ?? '-'}',
                                                                                style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .w700),
                                                                              ),
                                                                            ),
                                                                            VerticalDivider(width: 1),
                                                                            SizedBox(width: 8),
                                                                            Expanded(
                                                                              flex: 2,
                                                                              child: Text(
                                                                                activityItem.activity ?? '-',
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        );
                                                                      })
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(
                                                            thickness: 0.4
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded( child:
                                                            Text('Remarks',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            ),
                                                            ),
                                                            VerticalDivider(width: 1),
                                                            SizedBox(width:16),
                                                            Expanded( child:
                                                            Text(progressActivity.remarks ?? '-',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            )
                                                          ],
                                                        ),
                                                        const Divider(
                                                            thickness: 0.4
                                                        ),
                                                      ]
                                                  ),
                                                ]
                                            ) : const SizedBox(),
                                            controller.activityLabListStages.value.where((item) => item.mStatuslaboratoryprogresId == 3).isNotEmpty ? Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text('Stage 3: Preparation for Analyze',
                                                        style: TextStyle(
                                                            color: green,
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w700
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      controller.activityLabStage == 3 ? InkWell(
                                                          onTap: () {
                                                            controller.drawerDailyActivityLabEdit();
                                                          },
                                                          child: Icon(
                                                              Icons
                                                                  .mode_edit_outlined,
                                                              color:
                                                              primaryColor,
                                                              size: 18
                                                          )
                                                      ) : const SizedBox(),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  for(var progressActivity in controller.activityLabListStages.value.where((item) => item.mStatuslaboratoryprogresId == 3)) Column(
                                                      children:[
                                                        Row(
                                                          children: [
                                                            Expanded( child:
                                                            Text('Date',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            ),
                                                            ),
                                                            VerticalDivider(width: 1),
                                                            SizedBox(width:16),
                                                            Expanded( child:
                                                            Text(progressActivity.transDate ?? '-',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            )
                                                          ],
                                                        ),
                                                        const Divider(
                                                            thickness: 0.4
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child:
                                                              Text('Activities',
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w700
                                                                ),
                                                              ),
                                                            ),
                                                            VerticalDivider(width: 1),
                                                            SizedBox(width:8),
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  ListView.builder(
                                                                      shrinkWrap: true,
                                                                      physics: NeverScrollableScrollPhysics(),
                                                                      itemCount: progressActivity.listLabActivity?.length,
                                                                      itemBuilder: (context, indexItem){
                                                                        var activityItem = progressActivity.listLabActivity![indexItem];
                                                                        return Row(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                '${activityItem.startActivityTime ?? '-'} - ${activityItem.endActivityTime ?? '-'}',
                                                                                style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .w700),
                                                                              ),
                                                                            ),
                                                                            VerticalDivider(width: 1),
                                                                            SizedBox(width: 8),
                                                                            Expanded(
                                                                              flex: 2,
                                                                              child: Text(
                                                                                activityItem.activity ?? '-',
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        );
                                                                      })
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded( child:
                                                            Text('Remarks',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            ),
                                                            ),
                                                            VerticalDivider(width: 1),
                                                            SizedBox(width:16),
                                                            Expanded( child:
                                                            Text(progressActivity.remarks ?? '-',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            )
                                                          ],
                                                        ),
                                                        const Divider(
                                                            thickness: 0.4
                                                        ),
                                                      ]
                                                  ),
                                                ]
                                            ) : const SizedBox(),
                                            controller.activityLabListStages.value.where((item) => item.mStatuslaboratoryprogresId == 4).isNotEmpty ? Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text('Stage 4: Analyze on Progress',
                                                        style: TextStyle(
                                                            color: green,
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w700
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      controller.activityLabStage == 4 ? InkWell(
                                                          onTap: () {
                                                            controller.drawerDailyActivityLabEdit();
                                                          },
                                                          child: Icon(
                                                              Icons
                                                                  .mode_edit_outlined,
                                                              color:
                                                              primaryColor,
                                                              size: 18
                                                          )
                                                      ) : const SizedBox(),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  for(var progressActivity in controller.activityLabListStages.value.where((item) => item.mStatuslaboratoryprogresId == 4)) Column(
                                                      children:[
                                                        Row(
                                                          children: [
                                                            Expanded( child:
                                                            Text('Date',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            ),
                                                            ),
                                                            VerticalDivider(width: 1),
                                                            SizedBox(width:16),
                                                            Expanded( child:
                                                            Text(progressActivity.transDate ?? '-',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            )
                                                          ],
                                                        ),
                                                        const Divider(
                                                            thickness: 0.4
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child:
                                                              Text('Activities',
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w700
                                                                ),
                                                              ),
                                                            ),
                                                            VerticalDivider(width: 1),
                                                            SizedBox(width:8),
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  ListView.builder(
                                                                      shrinkWrap: true,
                                                                      physics: NeverScrollableScrollPhysics(),
                                                                      itemCount: progressActivity.listLabActivity?.length,
                                                                      itemBuilder: (context, indexItem){
                                                                        var activityItem = progressActivity.listLabActivity![indexItem];
                                                                        return Row(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                '${activityItem.startActivityTime ?? '-'} - ${activityItem.endActivityTime ?? '-'}',
                                                                                style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .w700),
                                                                              ),
                                                                            ),
                                                                            VerticalDivider(width: 1),
                                                                            SizedBox(width: 8),
                                                                            Expanded(
                                                                              flex: 2,
                                                                              child: Text(
                                                                                activityItem.activity ?? '-',
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        );
                                                                      })
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(
                                                            thickness: 0.4
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded( child:
                                                            Text('Remarks',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            ),
                                                            ),
                                                            VerticalDivider(width: 1),
                                                            SizedBox(width:16),
                                                            Expanded( child:
                                                            Text(progressActivity.remarks ?? '-',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            )
                                                          ],
                                                        ),
                                                        const Divider(
                                                            thickness: 0.4
                                                        ),
                                                      ]
                                                  ),
                                                ]
                                            ) : const SizedBox(),
                                          ]
                                      ) : const SizedBox(),
                                      controller.activity5LabListStages.value.isNotEmpty ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Text('Stage 5: Issued Analyzed Result',
                                                  style: TextStyle(
                                                      color: green,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w700
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                controller.activityLabStage == 5 ? InkWell(
                                                    onTap: () {
                                                      controller.drawerDailyActivity5LabEdit();
                                                    },
                                                    child: const Icon(Icons.mode_edit_outlined,
                                                        color: primaryColor,
                                                        size: 18
                                                    )
                                                ) : const SizedBox(),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            ListView.builder(
                                                physics: NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: controller.activity5LabListStages.value.length,
                                                itemBuilder: (context, index){
                                                  var activity = controller.activity5LabListStages.value[index];
                                                  return Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Column(
                                                            children:[
                                                              Row(
                                                                children: [
                                                                  Expanded( child:
                                                                  Text('Activity Date',
                                                                    style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.w700
                                                                    ),
                                                                  ),
                                                                  ),
                                                                  VerticalDivider(width: 1),
                                                                  SizedBox(width:16),
                                                                  Expanded( child:
                                                                  Text(activity.transDate ?? '-',
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                    ),
                                                                  ),
                                                                  )
                                                                ],
                                                              ),
                                                              const Divider(
                                                                  thickness: 0.4
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                    Text('Activity Time',
                                                                      style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w700
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  VerticalDivider(width: 1),
                                                                  SizedBox(width:16),
                                                                  Expanded(
                                                                    child:
                                                                    Text('${Helper.formatToHourMinuteFromDate(activity.createdAt ?? '')}',
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const Divider(
                                                                  thickness: 0.4
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                    Text('Total Sample Received',
                                                                      style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w700
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  VerticalDivider(width: 1),
                                                                  SizedBox(width:16),
                                                                  Expanded(
                                                                    child:
                                                                    Text(Helper.formatNumber(activity.totalSampleReceived.toString()),
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const Divider(
                                                                  thickness: 0.4
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded( child:
                                                                  Text('Total Sample Preparation',
                                                                    style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.w700
                                                                    ),
                                                                  ),
                                                                  ),
                                                                  VerticalDivider(width: 1),
                                                                  SizedBox(width:16),
                                                                  Expanded( child:
                                                                  Text(Helper.formatNumber(activity.totalSamplePreparation.toString()),
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                    ),
                                                                  ),
                                                                  )
                                                                ],
                                                              ),
                                                              const Divider(
                                                                  thickness: 0.4
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                    Text('Total Sample Analyzed',
                                                                      style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w700
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  VerticalDivider(width: 1),
                                                                  SizedBox(width:16),
                                                                  Expanded(
                                                                    child:
                                                                    Text(Helper.formatNumber(activity.totalSampleAnalyzed.toString()),
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const Divider(
                                                                  thickness: 0.4
                                                              ),
                                                            ]
                                                        )
                                                      ]
                                                  );
                                                }
                                            )
                                          ]
                                      ) : const SizedBox(),
                                      controller.activity6ListStages.value.isNotEmpty ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Text('Stage 6: Report to Client',
                                                  style: TextStyle(
                                                      color: green,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w700
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                controller.activityLabStage == 6 ? InkWell(
                                                    onTap: () {
                                                      controller.drawerDailyActivity6Edit();
                                                    },
                                                    child: Icon(
                                                        Icons
                                                            .mode_edit_outlined,
                                                        color:
                                                        primaryColor,
                                                        size: 18
                                                    )
                                                ) : const SizedBox(),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemCount: controller.activity6ListStages.value.length,
                                                itemBuilder: (context, index){
                                                  var act6 = controller.activity6ListStages.value[index];
                                                  return Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded( child:
                                                            Text('Date',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            ),
                                                            ),
                                                            VerticalDivider(width: 1),
                                                            SizedBox(width:16),
                                                            Expanded( child:
                                                            Text(act6.transDate ?? '-',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            )
                                                          ],
                                                        ),
                                                        const Divider(
                                                            thickness: 0.4
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child:
                                                              Text('Activities',
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w700
                                                                ),
                                                              ),
                                                            ),
                                                            VerticalDivider(width: 1),
                                                            SizedBox(width:8),
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  ListView.builder(
                                                                      shrinkWrap: true,
                                                                      physics: NeverScrollableScrollPhysics(),
                                                                      itemCount: act6.listLabActivity?.length,
                                                                      itemBuilder: (context, indexItem){
                                                                        var activityItem = act6.listLabActivity![indexItem];
                                                                        return Row(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                '${activityItem.startActivityTime ?? '-'} - ${activityItem.endActivityTime ?? '-'}',
                                                                                style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .w700),
                                                                              ),
                                                                            ),
                                                                            VerticalDivider(width: 1),
                                                                            SizedBox(width: 8),
                                                                            Expanded(
                                                                              flex: 2,
                                                                              child: Text(
                                                                                activityItem.activity ?? '-',
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        );
                                                                      })
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(
                                                            thickness: 0.4
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded( child:
                                                            Text('Remarks',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            ),
                                                            ),
                                                            VerticalDivider(width: 1),
                                                            SizedBox(width:16),
                                                            Expanded( child:
                                                            Text(act6.remarks ?? '-',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            )
                                                          ],
                                                        ),
                                                        const Divider(
                                                            thickness: 0.4
                                                        ),
                                                      ]
                                                  );
                                                }
                                            ),
                                            const SizedBox(height: 16),
                                            Text('Attachment',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            controller.activity6AttachmentsStage.value.isNotEmpty ? GridView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 5,
                                                  mainAxisSpacing: 8,
                                                  crossAxisSpacing: 8,
                                                ),
                                                itemCount: controller.activity6AttachmentsStage.value.length,
                                                itemBuilder: (content, index){
                                                  final TDJoLaboratoryAttachment attach = controller.activity6AttachmentsStage.value[index];
                                                  final String fileType = controller.checkFileType(attach.pathName!);
                                                  var filename = attach.fileName;
                                                  return fileType == 'image' ? SizedBox(
                                                    width: 54,
                                                    height: 66,
                                                    child: SizedBox(
                                                      width: 54,
                                                      height: 54,
                                                      child: InkWell(
                                                        onTap: (){
                                                          controller.previewImageAct6(index, attach.pathName!);
                                                        },
                                                        child: Image.file(
                                                          File(attach.pathName!),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ) : fileType == 'doc' ? SizedBox(
                                                    width: 54,
                                                    height: 66,
                                                    child: InkWell(
                                                      onTap: (){
                                                        OpenFilex.open(attach.pathName!);
                                                      },
                                                      child: SizedBox(
                                                        width: 54,
                                                        height: 54,
                                                        child: Center(
                                                            child: Column(
                                                              children: [
                                                                Image.asset('assets/icons/pdfIcon.png', height: 42,),
                                                                Text(filename!, style: TextStyle(fontSize: 8), overflow: TextOverflow.ellipsis)
                                                              ],
                                                            )
                                                        ),
                                                      ),
                                                    ),
                                                  ) : SizedBox();
                                                }
                                            ) : const SizedBox()
                                          ]
                                      ) : const SizedBox(),
                                    ]
                                )
                            ),
                          )
                      )
                    ]
                ),
                )
            ),
          ),
          ),
        )
    );
  }

}