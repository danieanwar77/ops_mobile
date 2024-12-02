import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/data/model/send_manual_model.dart';
import 'package:ops_mobile/feature/send_manual/send_manual_controller.dart';

class SendManualScreen extends StatelessWidget{
  const SendManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: SendManualController(),
        builder: (controller) => Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            title: const Text('Pending Data',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
            actions: [
              IconButton(
                  onPressed: ()async{
                    controller.dataJoList.value = controller.joSendManualList.value;
                    controller.loadingDialog();
                    Future.delayed(const Duration(seconds: 3),(){
                      Get.back<void>();
                      controller.makeAFile();
                      controller.openDialog('Attention', 'Data berhasil dikirim');
                    });
                  },
                  icon: Image.asset('assets/icons/sendall.png')
              )
            ],
          ),
          body: SafeArea(
              child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            itemCount: controller.dataSendList.length,
                            itemBuilder: (context, index){
                              var joItem = controller.dataSendList[index];
                              return Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${joItem.module}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    const SizedBox(height: 8,),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                            child: SizedBox(
                                              height: 48,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(joItem.transDate),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: (){
                                                // listData.add(data);
                                                controller.loadingDialog();
                                                Future.delayed(const Duration(seconds: 3),(){
                                                  Get.back<void>();
                                                  controller.makeAFile();
                                                  //controller.openDialog('Attention', 'Data berhasil dikirim');
                                                });
                                              },
                                              icon: Image.asset('assets/icons/send.png', height: 32,)
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 24,)
                                  ],
                                )
                              );
                            }
                        ),
                      ),
                    ),
                  ],
                ),

          ),
        )
    );
  }
}