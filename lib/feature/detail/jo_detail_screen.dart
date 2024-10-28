import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/data/model/jo_send_model.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_pict.dart';
import 'package:ops_mobile/feature/detail/jo_detail_controller.dart';
import 'package:ops_mobile/utils/helper.dart';

class JoDetailScreen extends StatelessWidget {
  const JoDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: JoDetailController(),
      builder: (controller) => controller.isLoadingJO == false ? DefaultTabController(
          length: controller.joDetailTab.length,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                controller.activity6ListStages.value.isNotEmpty && controller.activityStage == 6 ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                      backgroundColor: green,
                      child: Image.asset(
                        'assets/icons/finishjo.png',
                        width: 21,
                          height: 21
                      )),
                ) : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                      backgroundColor: Color(0xffFF5C70),
                      child: Icon(
                        Icons.description,
                        color: Colors.white,
                        size: 21,
                      )),
                )
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
            body: NestedScrollView(
                physics: const NeverScrollableScrollPhysics(),
                headerSliverBuilder: (context, value){
                  return [
                    SliverToBoxAdapter(
                      child: TabBar(
                        padding: EdgeInsets.zero,
                        isScrollable: true,
                        labelColor: primaryColor,
                        unselectedLabelColor: Color(0xff727272),
                        tabAlignment: TabAlignment.start,
                        tabs: controller.joDetailTab,
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  children: controller.joDetailTab.map((Tab e){
                      return switch(e.text){
                      'Detail' => SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            child: Card(
                              color: Colors.white,
                              child: Obx(
                                    () => Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const Expanded( child:
                                                  Text('SO ID',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.code ?? '-',
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
                                                  Text('JO ID',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.soCode ?? '-',
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
                                                  Text('SO Created Date',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.soCreatedAt ?? '-',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),)
                                                ],
                                              ),
                                              const Divider(
                                                  thickness: 0.4
                                              ),
                                              Row(
                                                children: [
                                                  const Expanded( child:
                                                  Text('JO Date',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.joCreatedDate ?? '-',
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
                                                  Text('Status',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.statusJo ?? '-',
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
                                                  Text('SBU',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.sbuName ?? '-',
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
                                                  Text('Commodity',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child: Text(controller.dataJoDetail.value.detail?.commodityName ?? '-',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),)
                                                ],
                                              ),
                                              const Divider(
                                                  thickness: 0.4
                                              ),
                                              Row(
                                                children: [
                                                  const Expanded( child:
                                                  Text('Company',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child: Text(controller.dataJoDetail.value.detail?.companyName ?? '-',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),)
                                                ],
                                              ),
                                              const Divider(
                                                  thickness: 0.4
                                              ),
                                              Row(
                                                children: [
                                                  const Expanded( child:
                                                  Text('Client Category',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.mClientCategoryName ?? '-',
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
                                                  Text('Project Title',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.projectTittle ?? '-',
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
                                                  Text('Region',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.region ?? '-',
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
                                                  Text('Branch',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.branch ?? '-',
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
                                                  Text('Site Office',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.siteOffice ?? '-',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                        thickness: 0.4
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.sizeOf(context).width - 40,
                                          child: ExpansionTile(
                                            shape: Border.all(color: Colors.transparent),
                                            title: const Text('Survey Location',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: primaryColor
                                              ),
                                            ),
                                            childrenPadding: const EdgeInsets.symmetric(horizontal : 16),
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  const Expanded( child:
                                                  Text('Survey Location',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.surveyLocation ?? '-',
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
                                                  Text('Country',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.countrySurvey ?? '-',
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
                                                  Text('Province',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.provinceSurvey ?? '-',
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
                                                  Text('City',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.citySurvey ?? '-',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                            thickness: 0.4
                                        ),
                                        SizedBox(
                                          width: MediaQuery.sizeOf(context).width - 40,
                                          child: ExpansionTile(
                                            shape: Border.all(color: Colors.transparent),
                                            title: const Text('Loading Port',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: primaryColor
                                              ),
                                            ),
                                            childrenPadding: const EdgeInsets.symmetric(horizontal : 16),
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  const Expanded( child:
                                                  Text('Country',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.loadingPortCountry ?? '-',
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
                                                  Text('Province',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.loadingPortProvince ?? '-',
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
                                                  Text('City',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.loadingPortCity ?? '-',
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
                                                  Text('Origin Country',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.loadingPortCountry ?? '-',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                            thickness: 0.4
                                        ),
                                        SizedBox(
                                          width: MediaQuery.sizeOf(context).width - 40,
                                          child: ExpansionTile(
                                            shape: Border.all(color: Colors.transparent),
                                            title: const Text('Discharging Port',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: primaryColor
                                              ),
                                            ),
                                            childrenPadding: const EdgeInsets.symmetric(horizontal : 16),
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  const Expanded( child:
                                                  Text('Discharging Port',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child: Text(controller.dataJoDetail.value.detail?.dischargePort ?? '-',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),)
                                                ],
                                              ),
                                              const Divider(
                                                  thickness: 0.4
                                              ),
                                              Row(
                                                children: [
                                                  const Expanded( child:
                                                  Text('Country',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.dischargePortCountry ?? '-',
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
                                                  Text('Province',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.dischargePortProvince ?? '-',
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
                                                  Text('City',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.dischargePortCity ?? '-',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                            thickness: 0.4
                                        ),
                                        SizedBox(
                                          width: MediaQuery.sizeOf(context).width - 40,
                                          child: ExpansionTile(
                                            shape: Border.all(color: Colors.transparent),
                                            title: const Text('Supply Chain Information & Others',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: primaryColor
                                              ),
                                            ),
                                            childrenPadding: const EdgeInsets.symmetric(horizontal : 16),
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  const Expanded( child:
                                                  Text('Destination Country',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.destinationCountry ?? '-',
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
                                                  Text('Destination Category',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.destinationCategoryName ?? '-',
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
                                                  Text('Job Category',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.jobCategoryName ?? '-',
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
                                                  Text('Market Segmentation',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.marketSegmentName ?? '-',
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
                                                  Text('Sub Market Segmentation',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.subMarketSegmentName ?? '-',
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
                                                  Text('Supplier',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.supplierName ?? '-',
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
                                                  Text('Trader 1',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.trader1Name ?? '-',
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
                                                  Text('Trader 2',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.trader2Name ?? '-',
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
                                                  Text('Trader 3',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child: Text(controller.dataJoDetail.value.detail?.trader3Name ?? '-',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),)
                                                ],
                                              ),
                                              const Divider(
                                                  thickness: 0.4
                                              ),
                                              Row(
                                                children: [
                                                  const Expanded( child:
                                                  Text('End Buyer',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.endBuyerName ?? '-',
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
                                                  Text('Notes',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.notes ?? '-',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 24,)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      'KOS' => SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            child: Card(
                              color: Colors.white,
                              child: Obx(
                                    () => Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Expanded( child: Text('Kind Of Services',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child: Text(controller.dataJoDetail.value.detail?.kosName ??'-',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),)
                                                ],
                                              ),
                                              const Divider(
                                                  thickness: 0.4
                                              ),
                                              Row(
                                                children: [
                                                  const Expanded( child:
                                                  Text("Order Start - End Date",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1.0),
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
                                                  Text('Vessel',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.vessel ?? '-',
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
                                              controller.barges.value.isNotEmpty ? Column(
                                                children: [
                                                  for(int i = 0; i < controller.barges.value.length; i++) Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded( child:
                                                          Text('Barge ${i+1}',
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w700
                                                            ),
                                                          ),
                                                          ),
                                                          const VerticalDivider(width: 1),
                                                          const SizedBox(width:16),
                                                          Expanded( child:
                                                          Text(controller.barges.value[i] ?? '-',
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
                                                ],
                                              ) : Column(
                                                children: [
                                                  const Row(
                                                    children: [
                                                      Expanded( child:
                                                      Text('Barge 1',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w700
                                                        ),
                                                      ),
                                                      ),
                                                      VerticalDivider(width: 1),
                                                      SizedBox(width:16),
                                                      Expanded( child:
                                                      Text('-',
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
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Expanded( child:
                                                  Text('Qty',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.qty.toString() ?? '-',
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
                                                  Text('UOM',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoDetail.value.detail?.uomName ?? '-',
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
                                              const Text('SOW :',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700
                                                ),
                                              ),
                                              controller.dataJoDetail.value.sow!.isNotEmpty ? Column(
                                                children: [
                                                  for(var i = 0; i < controller.dataJoDetail.value.sow!.length; i++)  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('${i+1}.',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      const SizedBox(width:16),
                                                      Expanded( child:
                                                      Text(controller.dataJoDetail.value.sow![i].name ?? '-',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ) : const SizedBox(),
                                              const Divider(
                                                  thickness: 0.4
                                              ),
                                              const Text('OOS :',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700
                                                ),
                                              ),
                                              controller.dataJoDetail.value.oos!.isNotEmpty ? Column(
                                                children: [
                                                  for(var i = 0; i < controller.dataJoDetail.value.oos!.length; i++)  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('${i+1}.',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      const SizedBox(width:16),
                                                      Expanded( child:
                                                      Text(controller.dataJoDetail.value.oos![i].name ?? '-',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ) : const SizedBox(),
                                              const Divider(
                                                  thickness: 0.4
                                              ),
                                              const Text('Lab Analysis Parameter :',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700
                                                ),
                                              ),
                                              controller.dataJoDetail.value.lap!.isNotEmpty ? Column(
                                                children: [
                                                  for(var i = 0; i < controller.dataJoDetail.value.lap!.length; i++)  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("${i+1}.",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      SizedBox(width:16),Expanded( child: Text(controller.dataJoDetail.value.lap![i].name ?? '-',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),)
                                                    ],
                                                  ),
                                                ],
                                              ) : const SizedBox(),
                                              const Divider(
                                                  thickness: 0.4
                                              ),
                                              const Text('Standard Method :',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700
                                                ),
                                              ),
                                              controller.dataJoDetail.value.stdMethod!.isNotEmpty ? Column(
                                                children: [
                                                  for(var i = 0; i < controller.dataJoDetail.value.stdMethod!.length; i++)  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('${i+1}.',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      const SizedBox(width:16),
                                                      Expanded( child:
                                                      Text(controller.dataJoDetail.value.stdMethod![i].name ?? '-',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ) : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      'PIC' => SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            child: Card(
                              color: Colors.white,
                              child: Obx(
                                    () => Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Expanded( child: Text('ETA Vessel',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoPIC.value.detail?.ettaVessel ??'-',
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
                                                  Text('Date of Attendance',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1.0),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text('${controller.dataJoPIC.value.detail?.startDateOfAttendance ?? '-'} - ${controller.dataJoPIC.value.detail?.endDateOfAttendance ?? '-'}',
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
                                                  Text('Lokasi Kerja',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoPIC.value.detail?.lokasiKerja ?? '-',
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
                                              const Text('Assign PIC Inspection',
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
                                                  Text('PIC Inspection',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoPIC.value.detail?.picInspector ?? '-',
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
                                              const Text('Assign PIC Laboratory',
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
                                                  Text('PIC Laboratory',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  ),
                                                  const VerticalDivider(width: 1),
                                                  const SizedBox(width:16),
                                                  Expanded( child:
                                                  Text(controller.dataJoPIC.value.detail?.picLaboratory ?? '-',
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
                                              controller.dataJoPIC.value != null ? Column(
                                                children: [
                                                  controller.dataJoPIC.value.lab != null ? Column(
                                                      children: [
                                                        for(var i = 0; i < controller.dataJoPIC.value.lab!.length; i++)  Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Expanded( child:
                                                                Text('Laboratory ${i+1}',
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w700
                                                                  ),
                                                                ),
                                                                ),
                                                                const VerticalDivider(width: 1),
                                                                const SizedBox(width:16),
                                                                Expanded( child:
                                                                Text(controller.dataJoPIC.value.lab![i].name ?? '-',
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
                                                      ]
                                                  ) : const SizedBox(),
                                                ],
                                              ) : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.sizeOf(context).width - 40,
                                            child: ExpansionTile(
                                              shape: Border.all(color: Colors.transparent),
                                              title: const Text('Assign History',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: primaryColor
                                                ),
                                              ),
                                              childrenPadding: const EdgeInsets.symmetric(horizontal : 16),
                                              children: <Widget>[
                                                controller.barges.value.isNotEmpty ? Column(
                                                  children: [
                                                    for(var i = controller.dataJoPIC.value.assignHistory!.length; i > 0 ; i--) Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text('Assign ${i}',
                                                            style: const TextStyle(
                                                                color: green,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w700
                                                            ),
                                                          ),
                                                          const SizedBox(height: 16),
                                                          Row(
                                                              children: [
                                                                const Expanded( child:
                                                                Text('Assign Date',
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w700
                                                                  ),
                                                                ),
                                                                ),
                                                                const VerticalDivider(width: 1),
                                                                const SizedBox(width:16),
                                                                Expanded( child:
                                                                Text(controller.dataJoPIC.value.assignHistory![i-1].assignedDate ?? '-',
                                                                  style: const TextStyle(
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                ),
                                                              ]
                                                          ),
                                                          const Divider(
                                                              thickness: 0.4
                                                          ),
                                                          Row(
                                                              children: [
                                                                const Expanded( child:
                                                                Text('Assign By',
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w700
                                                                  ),
                                                                ),
                                                                ),
                                                                const VerticalDivider(width: 1),
                                                                const SizedBox(width:16),
                                                                Expanded( child:
                                                                Text(controller.dataJoPIC.value.assignHistory![i-1].assignBy ??'-',
                                                                  style: const TextStyle(
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                ),
                                                              ]
                                                          ),
                                                          const Divider(
                                                              thickness: 0.4
                                                          ),
                                                          Row(
                                                              children: [
                                                                const Expanded( child:
                                                                Text('Remarks',
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w700
                                                                  ),
                                                                ),
                                                                ),
                                                                const VerticalDivider(width: 1),
                                                                const SizedBox(width:16),
                                                                Expanded( child:
                                                                Text(controller.dataJoPIC.value.assignHistory![i-1].remarks ?? '-',
                                                                  style: const TextStyle(
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                ),
                                                              ]
                                                          )  ,
                                                          const Divider(
                                                              thickness: 0.4
                                                          ),
                                                          Row(
                                                              children: [
                                                                const Expanded( child:
                                                                Text('Previous ETA Vessel',
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w700
                                                                  ),
                                                                ),
                                                                ),
                                                                const VerticalDivider(width: 1),
                                                                const SizedBox(width:16),
                                                                Expanded( child:
                                                                Text(controller.dataJoPIC.value.assignHistory![i-1].ettaVessel ?? '-',
                                                                  style: const TextStyle(
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                ),
                                                              ]
                                                          ),
                                                          const Divider(
                                                              thickness: 0.4
                                                          ),
                                                          Row(
                                                              children: [
                                                                const Expanded( child:
                                                                Text('Previous Date of Attendance',
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w700
                                                                  ),
                                                                ),
                                                                ),
                                                                const VerticalDivider(width: 1),
                                                                const SizedBox(width:16),
                                                                Expanded( child:
                                                                Text('${controller.dataJoPIC.value.assignHistory![i-1].startDateOfAttendance ?? '-'} - ${controller.dataJoPIC.value.assignHistory![i-1].endDateOfAttendance ?? '-'}',
                                                                  style: const TextStyle(
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                ),
                                                              ]
                                                          ),
                                                          const Divider(
                                                              thickness: 0.4
                                                          ),
                                                          Row(
                                                              children:[
                                                                const Expanded( child:
                                                                Text('Previous Lokasi Kerja',
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w700
                                                                  ),
                                                                ),
                                                                ),
                                                                const VerticalDivider(width: 1),
                                                                const SizedBox(width:16),
                                                                Expanded( child:
                                                                Text(controller.dataJoPIC.value.assignHistory![i-1].lokasiKerja ?? '-',
                                                                  style: const TextStyle(
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                ),
                                                              ]
                                                          ),
                                                          const Divider(
                                                              thickness: 0.4
                                                          ),
                                                          Row(
                                                              children:[
                                                                const Expanded( child:
                                                                Text('Previous PIC Inspection',
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w700
                                                                  ),
                                                                ),
                                                                ),
                                                                const VerticalDivider(width: 1),
                                                                const SizedBox(width:16),
                                                                Expanded( child:
                                                                Text(controller.dataJoPIC.value.assignHistory![i-1].picInspector ?? '-',
                                                                  style: const TextStyle(
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                ),
                                                              ]
                                                          ),
                                                          const Divider(
                                                              thickness: 0.4
                                                          ),
                                                          Row(
                                                              children:[
                                                                const Expanded( child:
                                                                Text('Previous PIC Laboratory',
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w700
                                                                  ),
                                                                ),
                                                                ),
                                                                const VerticalDivider(width: 1),
                                                                const SizedBox(width:16),
                                                                Expanded( child:
                                                                Text(controller.dataJoPIC.value.assignHistory![i-1].picLaboratory ?? '-',
                                                                  style: const TextStyle(
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                ),
                                                              ]
                                                          ),
                                                          const Divider(
                                                              thickness: 0.4
                                                          ),
                                                        ]
                                                    )
                                                  ],
                                                ) : const SizedBox(),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      'Progress & Daily Activity' => SingleChildScrollView(
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
                                              const Text('Inspection Progress',
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
                                                  Text('Order Start - End Date',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
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
                                              Text('Photos',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700
                                                ),
                                              ),
                                              const Divider(
                                                  thickness: 0.4
                                              ),
                                              controller.isLoadingJOImage == false ?
                                              controller.dailyActivityPhotosV2.value.isNotEmpty ? GridView.builder(
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 5,
                                                    mainAxisSpacing: 8,
                                                    crossAxisSpacing: 8,
                                                  ),
                                                  itemCount: controller.dailyActivityPhotosV2.value.length,
                                                  itemBuilder: (content, index){
                                                    //final File photo = controller.dailyActivityPhotosV2.value[index];
                                                    TDJoInspectionPict pict = controller.dailyActivityPhotosV2.value[index];
                                                    return InkWell(
                                                      onTap: (){
                                                        controller.previewImage(index,pict!.pathPhoto!,pict!.keterangan!,pict);
                                                      },
                                                      child: SizedBox(
                                                        width: 54,
                                                        height: 54,
                                                        child: Image.file(
                                                          File(pict!.pathPhoto!),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                              ) : const SizedBox() :
                                              Expanded(
                                                  child: Center(
                                                      child: CircularProgressIndicator()
                                                  )
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                  ),
                                  controller.dataJoDetail.value.detail?.statusJo == 'Assigned' || controller.dataJoDetail.value.detail?.statusJo == 'On Progres' ? Column(
                                      children: [
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap:(){
                                                  controller.drawerDailyActivityImage();
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 1, color: primaryColor),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Row(
                                                      children: [
                                                        Icon(
                                                            Icons.camera_alt_sharp,
                                                            color: primaryColor
                                                        ),
                                                        Expanded(
                                                            child: Center(
                                                                child:
                                                                Text('Add Photo',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w700,
                                                                      color: primaryColor
                                                                  ),
                                                                )
                                                            )
                                                        )
                                                      ]
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                child: const SizedBox()
                                            ),
                                          ],
                                        ),
                                      ]
                                  ) : const SizedBox(),
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
                                                        controller.dataJoDetail.value.detail?.statusJo != 'On Progres' ? Container(
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
                                                        controller.activity6ListStages.value.isEmpty ? controller.dataJoDetail.value.detail?.statusJo == 'Assigned' || controller.dataJoDetail.value.detail?.statusJo == 'On Progres' ? IconButton(
                                                            onPressed: (){
                                                              debugPrint("activitySubmitted ${controller.activitySubmitted.value}");
                                                              debugPrint("activityStage ${controller.activityStage}");
                                                              // if(controller.activityStage == 1){
                                                              //   controller.nextStageActivityConfirm();
                                                              //   //controller.drawerDailyActivity();
                                                              // }
                                                              if(controller.activitySubmitted.value == true){
                                                                controller.activityStage == 1 ? controller.nextStageActivityConfirm() :
                                                                controller.activityStage > 1 && controller.activityStage < 5 ? controller.nextStageActivityConfirm()
                                                                    : controller.activityStage == 5 ? controller.nextStageActivity5Confirm()
                                                                    : controller.finishStageActivityConfirm();
                                                              } else {
                                                                controller.activityStage == 1 ? controller.drawerDailyActivity() :
                                                                controller.activityStage > 1 && controller.activityStage < 5 ? controller.drawerDailyActivity()
                                                                    : controller.activityStage == 5 ? controller.drawerDailyActivity5()
                                                                    : controller.drawerDailyActivity6();
                                                              }
                                                            },
                                                            icon: Image.asset('assets/icons/addactivity.png', height: 32,)
                                                        ) : const SizedBox() : const SizedBox(),
                                                      ]
                                                  ),
                                                  const SizedBox(height: 16),
                                                  controller.stageList.value.isNotEmpty ? Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children:[
                                                        controller.stageList.value.where((item) => item.mStatusinspectionstagesId == 1).isNotEmpty ? Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  const Text('Stage 1: Waiting For Arrival',
                                                                    style: TextStyle(
                                                                        color: green,
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.w700
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 8),
                                                                  controller.activityStage == 1 ? InkWell(
                                                                      onTap: () {
                                                                        controller.drawerDailyActivityEdit(1);
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
                                                              //controller.stageList.value
                                                              for(var progressActivity in controller.stageList.value.where((item) => item.mStatusinspectionstagesId == 1))
                                                                Column(
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
                                                                    ListView.builder(
                                                                      shrinkWrap: true,
                                                                      physics: NeverScrollableScrollPhysics(),
                                                                      itemCount: progressActivity.listActivity?.length ?? 0,
                                                                      itemBuilder: (context, index){
                                                                        final activity = progressActivity.listActivity?[index];
                                                                        return  Row(
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
                                                                              Text('${Helper.formatToHourMinute(activity!.startActivityTime!) ?? '-'} - ${Helper.formatToHourMinute(activity!.endActivityTime!) ?? '-'}',
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
                                                                              Text(activity?.activity ?? '-',
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        );
                                                                      },
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
                                                        controller.stageList.value.where((item) => item.mStatusinspectionstagesId == 2).isNotEmpty ? Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  const Text('Stage 2: Ship Arrived',
                                                                    style: TextStyle(
                                                                        color: green,
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.w700
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 8),
                                                                  controller.activityStage == 2 ? InkWell(
                                                                      onTap: () {
                                                                        controller.drawerDailyActivityEdit(2);
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
                                                              for(var progressActivity in controller.stageList.value.where((item) => item.mStatusinspectionstagesId == 2))
                                                                Column(
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
                                                                      ListView.builder(
                                                                        shrinkWrap: true,
                                                                        physics: NeverScrollableScrollPhysics(),
                                                                        itemCount: progressActivity.listActivity?.length ?? 0,
                                                                        itemBuilder: (context, index){
                                                                          final activity = progressActivity.listActivity?[index];
                                                                          return  Row(
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
                                                                                Text('${Helper.formatToHourMinute(activity!.startActivityTime!) ?? '-'} - ${Helper.formatToHourMinute(activity!.endActivityTime!) ?? '-'}',
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
                                                                                Text(activity?.activity ?? '-',
                                                                                  style: TextStyle(
                                                                                    fontSize: 14,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          );
                                                                        },
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
                                                        controller.stageList.value.where((item) => item.mStatusinspectionstagesId == 3).isNotEmpty ? Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  const Text('Stage 3: Ship Berthing',
                                                                    style: TextStyle(
                                                                        color: green,
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.w700
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 8),
                                                                  controller.activityStage == 3 ? InkWell(
                                                                      onTap: () {
                                                                        controller.drawerDailyActivityEdit(3);
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
                                                              for(var progressActivity in controller.stageList.value.where((item) => item.mStatusinspectionstagesId == 3))
                                                                Column(
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
                                                                      ListView.builder(
                                                                        shrinkWrap: true,
                                                                        physics: NeverScrollableScrollPhysics(),
                                                                        itemCount: progressActivity.listActivity?.length ?? 0,
                                                                        itemBuilder: (context, index){
                                                                          final activity = progressActivity.listActivity?[index];
                                                                          return  Row(
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
                                                                                Text('${Helper.formatToHourMinute(activity!.startActivityTime!) ?? '-'} - ${Helper.formatToHourMinute(activity!.endActivityTime!) ?? '-'}',
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
                                                                                Text(activity?.activity ?? '-',
                                                                                  style: TextStyle(
                                                                                    fontSize: 14,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          );
                                                                        },
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
                                                        controller.stageList.value.where((item) => item.mStatusinspectionstagesId == 4).isNotEmpty ? Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  const Text('Stage 4: Work Commence',
                                                                    style: TextStyle(
                                                                        color: green,
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.w700
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 8),
                                                                  controller.activityStage == 4 ? InkWell(
                                                                      onTap: () {
                                                                        controller.drawerDailyActivityEdit(4);
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
                                                              for(var progressActivity in controller.stageList.value.where((item) => item.mStatusinspectionstagesId == 4))
                                                                Column(
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
                                                                      ListView.builder(
                                                                        shrinkWrap: true,
                                                                        physics: NeverScrollableScrollPhysics(),
                                                                        itemCount: progressActivity.listActivity?.length ?? 0,
                                                                        itemBuilder: (context, index){
                                                                          final activity = progressActivity.listActivity?[index];
                                                                          return  Row(
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
                                                                                Text('${Helper.formatToHourMinute(activity!.startActivityTime!) ?? '-'} - ${Helper.formatToHourMinute(activity!.endActivityTime!) ?? '-'}',
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
                                                                                Text(activity?.activity ?? '-',
                                                                                  style: TextStyle(
                                                                                    fontSize: 14,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          );
                                                                        },
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
                                                  controller.activity5ListStages.value.isNotEmpty ? Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Text('Stage 5: Work Complete',
                                                              style: TextStyle(
                                                                  color: green,
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            ),
                                                            const SizedBox(width: 8),
                                                            controller.activityStage == 5 ? InkWell(
                                                                onTap: () {
                                                                  controller.drawerDailyActivity5Edit();
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
                                                            Text(controller.activity5ListStages.value.first.transDate ?? '-',
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
                                                            Text('Activity Time',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            ),
                                                            ),
                                                            VerticalDivider(width: 1),
                                                            SizedBox(width:16),
                                                            Expanded( child:
                                                            Text('-',
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
                                                            Text('Actual Qty',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            ),
                                                            ),
                                                            VerticalDivider(width: 1),
                                                            SizedBox(width:16),
                                                            Expanded( child:
                                                            Text(controller.activity5ListStages.value.first.actualQty ?? '-',
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
                                                            Text(controller.dataJoDetail.value.detail?.uomName ?? '-',
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
                                                            Text('Vessel',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            ),
                                                            ),
                                                            VerticalDivider(width: 1),
                                                            SizedBox(width:16),
                                                            Expanded( child:
                                                            Text(controller.activity5ListStages.value.first.vessel ?? '-',
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
                                                        controller.activity5ListStages.value.first.barge!.isNotEmpty ? Column(
                                                          children: [
                                                            ListView.builder(
                                                                shrinkWrap: true,
                                                                physics: NeverScrollableScrollPhysics(),
                                                                itemCount: controller.activity5ListStages.value.first.barge!.length,
                                                                itemBuilder: (context,index){
                                                                  return Column(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Expanded( child:
                                                                            Text('Barge ${index + 1}',
                                                                              style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.w700
                                                                              ),
                                                                            ),
                                                                            ),
                                                                            VerticalDivider(width: 1),
                                                                            SizedBox(width:16),
                                                                            Expanded( child:
                                                                            Text(controller.activity5ListStages.value.first.barge![index].barge ?? '-',
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
                                                          ],
                                                        ) : const SizedBox(),
                                                        controller.activity5ListStages.value.first.transhipment!.isNotEmpty ? Column(
                                                          children: [
                                                            ListView.builder(
                                                                shrinkWrap: true,
                                                                physics: NeverScrollableScrollPhysics(),
                                                                itemCount: controller.activity5ListStages.value.first.transhipment!.length,
                                                                itemBuilder: (context,index){
                                                                  return Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text('KOS Transhipment ${index + 1}',
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w700
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 16),
                                                                        Row(
                                                                          children: [
                                                                            Expanded( child:
                                                                            Text('Jetty',
                                                                              style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.w700
                                                                              ),
                                                                            ),
                                                                            ),
                                                                            VerticalDivider(width: 1),
                                                                            SizedBox(width:16),
                                                                            Expanded( child:
                                                                            Text(controller.activity5ListStages.value.first.transhipment![index].jetty ?? '-',
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
                                                                            Text('Initial Date',
                                                                              style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.w700
                                                                              ),
                                                                            ),
                                                                            ),
                                                                            VerticalDivider(width: 1),
                                                                            SizedBox(width:16),
                                                                            Expanded( child:
                                                                            Text(controller.activity5ListStages.value.first.transhipment![index].initialDate ?? '-',
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
                                                                            Text('Final Date',
                                                                              style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.w700
                                                                              ),
                                                                            ),
                                                                            ),
                                                                            VerticalDivider(width: 1),
                                                                            SizedBox(width:16),
                                                                            Expanded( child:
                                                                            Text(controller.activity5ListStages.value.first.transhipment![index].finalDate ?? '-',
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
                                                                            Text('Delivery Qty',
                                                                              style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.w700
                                                                              ),
                                                                            ),
                                                                            ),
                                                                            VerticalDivider(width: 1),
                                                                            SizedBox(width:16),
                                                                            Expanded( child:
                                                                            Text(controller.activity5ListStages.value.first.transhipment![index].deliveryQty ?? '-',
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
                                                                            Text('UOM',
                                                                              style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.w700
                                                                              ),
                                                                            ),
                                                                            ),
                                                                            VerticalDivider(width: 1),
                                                                            SizedBox(width:16),
                                                                            Expanded( child:
                                                                            Text(controller.dataJoDetail.value.detail?.uomName ?? '-',
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
                                                          ],
                                                        ) : const SizedBox(),
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
                                                            controller.activityStage == 6 ? InkWell(
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
                                                              Activity act6 = controller.activity6ListStages.value[index];
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
                                                                          flex: 1,
                                                                          child:
                                                                          Text('${act6.startActivityTime ?? '-'} - ${act6.endActivityTime ?? '-'}',
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
                                                                          Text(act6.activity ?? '-',
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
                                                        controller.activity6Attachments.value.isNotEmpty ? GridView.builder(
                                                            shrinkWrap: true,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 5,
                                                              mainAxisSpacing: 8,
                                                              crossAxisSpacing: 8,
                                                            ),
                                                            itemCount: controller.activity6Attachments.value.length,
                                                            itemBuilder: (content, index){
                                                              final File attach = controller.activity6Attachments.value[index];
                                                              final String fileType = controller.checkFileType(attach.path);
                                                              var filenameArr = attach.path.split("/");
                                                              var filename = filenameArr.last;
                                                              return fileType == 'image' ? SizedBox(
                                                                width: 54,
                                                                height: 66,
                                                                child: Stack(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 54,
                                                                      height: 54,
                                                                      child: InkWell(
                                                                        onTap: (){
                                                                          controller.previewImageAct6(index, attach.path);
                                                                        },
                                                                        child: Image.file(
                                                                          File(attach.path),
                                                                          fit: BoxFit.cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment: AlignmentDirectional.topEnd,
                                                                      child: SizedBox(
                                                                        height: 12,
                                                                        child: IconButton(
                                                                            onPressed: (){
                                                                              controller.removeActivity6Files(index);
                                                                            },
                                                                            icon: Icon(Icons.remove_circle,
                                                                              size: 12,
                                                                              color: Colors.red,
                                                                            )
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ) : fileType == 'doc' ? SizedBox(
                                                                width: 54,
                                                                height: 66,
                                                                child: Stack(
                                                                  children: [
                                                                    InkWell(
                                                                      onTap: (){
                                                                        OpenFilex.open(attach.path);
                                                                      },
                                                                      child: SizedBox(
                                                                        width: 54,
                                                                        height: 54,
                                                                        child: Center(
                                                                            child: Column(
                                                                              children: [
                                                                                Image.asset('assets/icons/pdfIcon.png', height: 42,),
                                                                                Text(filename, style: TextStyle(fontSize: 8), overflow: TextOverflow.ellipsis)
                                                                              ],
                                                                            )
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment: AlignmentDirectional.topEnd,
                                                                      child: SizedBox(
                                                                        height: 12,
                                                                        child: IconButton(
                                                                            padding: EdgeInsets.zero,
                                                                            onPressed: (){
                                                                              controller.removeActivity6Files(index);
                                                                            },
                                                                            icon: Icon(Icons.remove_circle,
                                                                              size: 12,
                                                                              color: Colors.red,
                                                                            )
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
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
                      'Laboratory Progress' => SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Obx(() => Column(
                              children: [
                                controller.labs.value.isNotEmpty ? ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: controller.labs.value.length,
                                    itemBuilder: (context,index){
                                      var lab = controller.labs.value[index];
                                      return Column(
                                        children: [
                                          SizedBox(
                                            child: InkWell(
                                              onTap: (){
                                                controller.detailLabActivity(int.parse(lab.laboratoriumId.toString()));
                                              },
                                              child: Card(
                                                  color: Colors.white,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(16),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(lab.name ?? '-',
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w700
                                                                ),
                                                              ),
                                                            ),
                                                            Icon(Icons.chevron_right)
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                        ],
                                      );
                                    }
                                ) : SizedBox(
                                  child: InkWell(
                                    onTap: (){
                                      controller.detailLabActivity(0);
                                    },
                                    child: Card(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text('lab -',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w700
                                                      ),
                                                    ),
                                                  ),
                                                  Icon(Icons.chevron_right)
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ]
                          ),
                          ),
                        ),
                      ),
                      _ => const Placeholder()
                      };
                    }
                  ).toList()
                )
            )
          ),
      ) : Column(
        children: [
          Expanded(
              child: Center(
                  child: CircularProgressIndicator()
              )
          ),
        ],
      ),
    );
  }
}


