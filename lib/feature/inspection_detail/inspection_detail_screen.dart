import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:ops_mobile/app.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/feature/inspection_detail/inspection_detail_controller.dart';

class InspectionDetailScreen extends StatelessWidget{
  const InspectionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: InspectionDetailController(),
        builder: (controller){
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              automaticallyImplyLeading: true,
              title: Text(
                'Document - ${controller.documentType}',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 16),
              ),
            ),
            body: SafeArea(child:
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    child: Obx(
                          () => Column(
                        children: [
                          Text('Certificate 1',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: green
                            ),
                          ),
                          const SizedBox(height:16),
                          Row(
                            children: [
                              const Expanded( child:
                              Text('No Certificate/Report',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              ),
                              const VerticalDivider(width: 1),
                              const SizedBox(width:16),
                              Expanded( child:
                              Text('-',
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
                              Text('Date Certificate/Report',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              ),
                              const VerticalDivider(width: 1),
                              const SizedBox(width:16),
                              Expanded( child:
                              Text('-',
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
                              Text('No Blanko Certificate',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              ),
                              const VerticalDivider(width: 1),
                              const SizedBox(width:16),
                              Expanded( child:
                              Text('-',
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
                              Text('LHV Number',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              ),
                              const VerticalDivider(width: 1),
                              const SizedBox(width:16),
                              Expanded( child:
                              Text('-',
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
                              Text('LS Number',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              ),
                              const VerticalDivider(width: 1),
                              const SizedBox(width:16),
                              Expanded( child:
                              Text('-',
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
                              Text('Upload Attachment Certificate',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              ),
                              const VerticalDivider(width: 1),
                              const SizedBox(width:16),
                              Expanded( child:
                              InkWell(
                                onTap: (){
                                  //OpenFilex.open(controller.sampleFile?.path ?? '');
                                },
                                child: SizedBox(
                                  width: 54,
                                  height: 54,
                                  child: Center(
                                      child: Column(
                                        children: [
                                          Image.asset('assets/icons/pdfIcon.png', height: 42,),
                                          Text('Sample1.pdf', style: TextStyle(fontSize: 8), overflow: TextOverflow.ellipsis)
                                        ],
                                      )
                                  ),
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
                    ),
                  )
                ],
              ),
            ))
          );
        });
  }
}