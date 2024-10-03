import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/feature/lab_activity_detail/lab_activity_detail_controller.dart';

class LabActivityDetailScreen extends StatelessWidget{
  const LabActivityDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: LabActivityDetailController(),
        builder: (controller) => Scaffold(
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: primaryColor,
            leading: GestureDetector(
                onTap: () => Get.back<void>(),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                )),
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
                                    const Text('Lab 1',
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
                                        Text('${controller.tat.value.toString() ??  '-'} Hours',
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
                                              (controller.activityLabStage < 6 ) ? IconButton(
                                                  onPressed: (){
                                                    controller.activityLabStage < 5 ?
                                                    controller.drawerDailyActivityLab()
                                                    : controller.drawerDailyActivity5Lab();
                                                  },
                                                  icon: Image.asset('assets/icons/addactivity.png', height: 32,)
                                              ) : const SizedBox()
                                            ]
                                        ),
                                        const SizedBox(height: 16),
                                        controller.activityLabListStages.value.isNotEmpty ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:[
                                              controller.activityLabListStages.value.where((item) => item.mStatuslaboratoryprogresId == 1).isNotEmpty ? Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text('Stage 1: Waiting For Arrival',
                                                      style: TextStyle(
                                                          color: green,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w700
                                                      ),
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
                                                                flex: 1,
                                                                child:
                                                                Text('${progressActivity.startActivityTime ?? '-'} - ${progressActivity.endActivityTime ?? '-'}',
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w700
                                                                  ),
                                                                ),
                                                              ),
                                                              VerticalDivider(width: 1),
                                                              SizedBox(width:8),
                                                              Expanded(
                                                                flex: 2,
                                                                child:
                                                                Text(progressActivity.activity ?? '-',
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
                                                    const Text('Stage 2: Ship Arrived',
                                                      style: TextStyle(
                                                          color: green,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w700
                                                      ),
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
                                                                flex: 1,
                                                                child:
                                                                Text('${progressActivity.startActivityTime ?? '-'} - ${progressActivity.endActivityTime ?? '-'}',
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w700
                                                                  ),
                                                                ),
                                                              ),
                                                              VerticalDivider(width: 1),
                                                              SizedBox(width:8),
                                                              Expanded(
                                                                flex: 2,
                                                                child:
                                                                Text(progressActivity.activity ?? '-',
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
                                                    const Text('Stage 3: Ship Berthing',
                                                      style: TextStyle(
                                                          color: green,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w700
                                                      ),
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
                                                                flex: 1,
                                                                child:
                                                                Text('${progressActivity.startActivityTime ?? '-'} - ${progressActivity.endActivityTime ?? '-'}',
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w700
                                                                  ),
                                                                ),
                                                              ),
                                                              VerticalDivider(width: 1),
                                                              SizedBox(width:8),
                                                              Expanded(
                                                                flex: 2,
                                                                child:
                                                                Text(progressActivity.activity ?? '-',
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                              )
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
                                                    const Text('Stage 4: Work Commence',
                                                      style: TextStyle(
                                                          color: green,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w700
                                                      ),
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
                                                                flex: 1,
                                                                child:
                                                                Text('${progressActivity.startActivityTime ?? '-'} - ${progressActivity.endActivityTime ?? '-'}',
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w700
                                                                  ),
                                                                ),
                                                              ),
                                                              VerticalDivider(width: 1),
                                                              SizedBox(width:8),
                                                              Expanded(
                                                                flex: 2,
                                                                child:
                                                                Text(progressActivity.activity ?? '-',
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
                                            const Text('Stage 5: Issued Analyzed Result',
                                              style: TextStyle(
                                                  color: green,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700
                                              ),
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
                                                                    Text('${activity.startActivityTime ?? '-'} - ${activity.endActivityTime ?? '-'}',
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
                                                                    Text(activity.totalSampleReceived.toString() ?? '-',
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
                                                                  Text(activity.totalSamplePreparation.toString() ?? '-',
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
                                                                    Text(activity.totalSampleAnalyzed.toString() ?? '-',
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
                                        ) : const SizedBox()
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