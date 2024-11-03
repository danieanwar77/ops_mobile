import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/feature/assigned/assigned_controller.dart';
import 'package:ops_mobile/feature/detail/jo_detail_screen.dart';
import 'package:ops_mobile/feature/waiting/jo_waiting_screen.dart';

class AssignedScreen extends StatelessWidget{
  const AssignedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AssignedController(),
        builder: (controller) => Obx(() => Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              title: Text('JO ${controller.listStatus[controller.statusJo.value]}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            body: SafeArea(
                child: controller.statusJo.value == 0 && controller.employeeId.value == 0 ? CircularProgressIndicator() : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controller.searchText,
                          cursorColor: onFocusColor,
                          style: const TextStyle(color: onFocusColor),
                          // onChanged: (value){
                          //   controller.searchJo(value);
                          // },
                          decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.search_sharp,
                                color: Colors.black26,
                              ),
                              filled: true,
                              fillColor: const Color(0xfff9fafb),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black26),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black26),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: primaryColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: 'Cari JO',
                              labelStyle: const TextStyle(
                                color: Colors.black26
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.never
                          ),
                        ),
                        const SizedBox(height: 16,),
                        Obx(() => controller.dataJoList.value.isNotEmpty ? ListView.builder(itemCount: controller.dataJoList.value.length, primary: false, shrinkWrap: true, itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              if(controller.dataJoList.value[index].mStatusjoId == 1 || controller.dataJoList.value[index].mStatusjoId == 2 || controller.dataJoList.value[index].mStatusjoId == 3){
                                Get.to<void>(JoDetailScreen.new, arguments: {
                                  'id': controller.dataJoList.value[index].joId,
                                  'status': controller.dataJoList.value[index]
                                      .mStatusjoId
                                });
                              } else {
                                Get.to<void>(JoWaitingScreen.new, arguments: {
                                  'id': controller.dataJoList.value[index].joId,
                                  'status': controller.dataJoList.value[index]
                                      .mStatusjoId
                                });
                              }
                            },
                            child: Card(
                              color: Colors.white,
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex:1,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('JO ID', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),),
                                                  ],
                                                ),
                                              ),
                                              const VerticalDivider(color: Colors.transparent,),
                                              Expanded(
                                                flex:2,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(controller.dataJoList.value[index].joId.toString() ?? '-', style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex:1,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('SBU', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),),
                                                  ],
                                                ),
                                              ),
                                              const VerticalDivider(color: Colors.transparent,),
                                              Expanded(
                                                flex:2,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(controller.dataJoList.value[index].sbuName ?? '-', style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex:1,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('KOS', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),),
                                                  ],
                                                ),
                                              ),
                                              const VerticalDivider(color: Colors.transparent,),
                                              Expanded(
                                                flex:2,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(controller.dataJoList.value[index].kosName ?? '-', style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex:1,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Company', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),),
                                                  ],
                                                ),
                                              ),
                                              const VerticalDivider(color: Colors.transparent,),
                                              Expanded(
                                                flex:2,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(controller.dataJoList.value[index].companyName ?? '-', style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Text(controller.dataJoList.value[index].createdAt!, style: TextStyle(fontWeight: FontWeight.w400, color: Color(0xff828282), fontSize: 9),),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right, color: primaryColor,)
                                  ],
                                ),
                              ),
                            ),
                          )
                        ) : Center(
                          child: Text('Data Kosong'),
                        ),
                        )
                      ],
                    ),
                  ),
                )
            ),
          ),
        )
    );
  }
}