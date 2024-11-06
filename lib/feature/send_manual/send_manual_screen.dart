import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
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
                    controller.loadingDialog(controller.dataJo);
                    Future.delayed(const Duration(seconds: 3),(){
                      Get.back<void>();
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
                            itemCount: controller.listStatus.length,
                            itemBuilder: (context, index){
                              final String listJo = controller.listStatus[index];
                              return Container(
                                child:
                                  controller.dataJoList.value.where((item) => item.mStatusjoId == index + 1).toList().length != 0 ?
                                      Column(
                                        children: [
                                          for(var assigned in controller.dataJoList.value.where((item) => item.mStatusjoId == 2).toList())
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('${assigned.code ?? ''} - ${listJo}',
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
                                                            child: Text('-'),
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                          onPressed: (){
                                                            // listData.add(data);
                                                            // controller.loadingDialog(listData);
                                                            // Future.delayed(const Duration(seconds: 3),(){
                                                            //   Get.back<void>();
                                                            //   controller.openDialog('Attention', 'Data berhasil dikirim');
                                                            // });
                                                          },
                                                          icon: Image.asset('assets/icons/send.png', height: 32,)
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 24,)
                                              ],
                                            )
                                        ]
                                      ) : const SizedBox(),
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