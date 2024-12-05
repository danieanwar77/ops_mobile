import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/data/model/jo_send_model.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_pict.dart';
import 'package:ops_mobile/feature/detail/jo_detail_controller.dart';
import 'package:ops_mobile/feature/documents/documents_screen.dart';
import 'package:ops_mobile/feature/waiting/jo_waiting_controller.dart';
import 'package:ops_mobile/utils/helper.dart';

class JoWaitingScreen extends StatelessWidget {
  const JoWaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: JoWaitingController(),
        builder: (controller) => controller.isLoadingJO == false
            ? DefaultTabController(
                length: controller.joWaitingTab.length,
                child: Scaffold(
                    appBar: AppBar(
                      actions: [
                        controller.loadingSpk.value
                            ? const CircularProgressIndicator()
                            : IconButton(
                                onPressed: () async {
                                  await controller.downloadSpk();
                                },
                                icon: const CircleAvatar(
                                    backgroundColor: Color(0xffFF5C70),
                                    child: Icon(
                                      Icons.description,
                                      color: Colors.white,
                                      size: 21,
                                    )),
                              ),
                      ],
                      centerTitle: false,
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      automaticallyImplyLeading: true,
                      title: const Text(
                        'JO Details',
                        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 16),
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(kToolbarHeight),
                        child: Container(
                          color: Colors.white,
                          child: TabBar(
                            padding: EdgeInsets.zero,
                            isScrollable: true,
                            labelColor: primaryColor,
                            unselectedLabelColor: Color(0xff727272),
                            tabAlignment: TabAlignment.start,
                            tabs: controller.joWaitingTab,
                          ),
                        ),
                      ),
                    ),
                    body: TabBarView(
                        children: controller.joWaitingTab.map((Tab e) {
                      return switch (e.text) {
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
                                                      Expanded(
                                                        child: Text(
                                                          'SO ID',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.code ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'JO ID',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.soCode ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'SO Created Date',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.soCreatedAt ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'JO Date',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.joCreatedDate ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Status',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.statusJo ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'SBU',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.sbuName ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Commodity',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.commodityName ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Company',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.companyName ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Client Category',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.mClientCategoryName ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Project Title',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.projectTittle ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Region',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.region ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Branch',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.branch ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Site Office',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.siteOffice ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
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
                                        const Divider(thickness: 0.4),
                                        Column(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context).width - 40,
                                              child: ExpansionTile(
                                                shape: Border.all(color: Colors.transparent),
                                                title: Text(
                                                  'Survey Location',
                                                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: primaryColor),
                                                ),
                                                childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Survey Location',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.surveyLocation ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Country',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.countrySurvey ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Province',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.provinceSurvey ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'City',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.citySurvey ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(thickness: 0.4),
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context).width - 40,
                                              child: ExpansionTile(
                                                shape: Border.all(color: Colors.transparent),
                                                title: Text(
                                                  'Loading Port',
                                                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: primaryColor),
                                                ),
                                                childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Country',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.loadingPortCountry ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Province',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.loadingPortProvince ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'City',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.loadingPortCity ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Origin Country',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.loadingPortCountry ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(thickness: 0.4),
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context).width - 40,
                                              child: ExpansionTile(
                                                shape: Border.all(color: Colors.transparent),
                                                title: Text(
                                                  'Discharging Port',
                                                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: primaryColor),
                                                ),
                                                childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Discharging Port',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.dischargePort ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Country',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.dischargePortCountry ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Province',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.dischargePortProvince ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'City',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.dischargePortCity ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(thickness: 0.4),
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context).width - 40,
                                              child: ExpansionTile(
                                                shape: Border.all(color: Colors.transparent),
                                                title: Text(
                                                  'Supply Chain Information & Others',
                                                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: primaryColor),
                                                ),
                                                childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Destination Country',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.destinationCountry ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Destination Category',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.destinationCategoryName ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Job Category',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.jobCategoryName ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Market Segmentation',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.marketSegmentName ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Sub Market Segmentation',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.subMarketSegmentName ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Supplier',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.supplierName ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Trader 1',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.trader1Name ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Trader 2',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.trader2Name ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Trader 3',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.trader3Name ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'End Buyer',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.endBuyerName ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Notes',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.notes ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 24,
                                                  )
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
                                                      Expanded(
                                                        child: Text(
                                                          'Kind Of Services',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.kosName ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "Order Start - End Date",
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1.0),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Vessel',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.vessel ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  controller.barges.value.isNotEmpty
                                                      ? Column(
                                                          children: [
                                                            for (int i = 0; i < controller.barges.value.length; i++)
                                                              Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Text(
                                                                          'Barge ${i + 1}',
                                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                        ),
                                                                      ),
                                                                      const VerticalDivider(width: 1),
                                                                      const SizedBox(width: 16),
                                                                      Expanded(
                                                                        child: Text(
                                                                          controller.barges.value[i] ?? '-',
                                                                          style: TextStyle(
                                                                            fontSize: 12.sp,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  const Divider(thickness: 0.4),
                                                                ],
                                                              ),
                                                          ],
                                                        )
                                                      : Column(
                                                          children: [
                                                            const Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    'Barge 1',
                                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                                                  ),
                                                                ),
                                                                VerticalDivider(width: 1),
                                                                SizedBox(width: 16),
                                                                Expanded(
                                                                  child: Text(
                                                                    '-',
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            const Divider(thickness: 0.4),
                                                          ],
                                                        ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Qty',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.qty.toString() ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'UOM',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoDetail.value.detail?.uomName ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Text(
                                                    'SOW :',
                                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                  ),
                                                  controller.dataJoDetail.value.sow!.isNotEmpty
                                                      ? Column(
                                                          children: [
                                                            for (var i = 0; i < controller.dataJoDetail.value.sow!.length; i++)
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    '${i + 1}.',
                                                                    style: const TextStyle(
                                                                      fontSize: 14,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 16),
                                                                  Expanded(
                                                                    child: Text(
                                                                      controller.dataJoDetail.value.sow![i].name ?? '-',
                                                                      style: const TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                  const Divider(thickness: 0.4),
                                                  Text(
                                                    'OOS :',
                                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                  ),
                                                  controller.dataJoDetail.value.oos!.isNotEmpty
                                                      ? Column(
                                                          children: [
                                                            for (var i = 0; i < controller.dataJoDetail.value.oos!.length; i++)
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    '${i + 1}.',
                                                                    style: const TextStyle(
                                                                      fontSize: 14,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 16),
                                                                  Expanded(
                                                                    child: Text(
                                                                      controller.dataJoDetail.value.oos![i].name ?? '-',
                                                                      style: const TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                  const Divider(thickness: 0.4),
                                                  Text(
                                                    'Lab Analysis Parameter :',
                                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                  ),
                                                  controller.dataJoDetail.value.lap!.isNotEmpty
                                                      ? Column(
                                                          children: [
                                                            for (var i = 0; i < controller.dataJoDetail.value.lap!.length; i++)
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    "${i + 1}.",
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 16),
                                                                  Expanded(
                                                                    child: Text(
                                                                      controller.dataJoDetail.value.lap![i].name ?? '-',
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                  const Divider(thickness: 0.4),
                                                  Text(
                                                    'Standard Method :',
                                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                  ),
                                                  controller.dataJoDetail.value.stdMethod!.isNotEmpty
                                                      ? Column(
                                                          children: [
                                                            for (var i = 0; i < controller.dataJoDetail.value.stdMethod!.length; i++)
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    '${i + 1}.',
                                                                    style: const TextStyle(
                                                                      fontSize: 14,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 16),
                                                                  Expanded(
                                                                    child: Text(
                                                                      controller.dataJoDetail.value.stdMethod![i].name ?? '-',
                                                                      style: const TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                          ],
                                                        )
                                                      : const SizedBox(),
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
                                                      Expanded(
                                                        child: Text(
                                                          'ETA Vessel',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoPIC.value.detail?.ettaVessel ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Date of Attendance',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1.0),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          '${controller.dataJoPIC.value.detail?.startDateOfAttendance ?? '-'} - ${controller.dataJoPIC.value.detail?.endDateOfAttendance ?? '-'}',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Lokasi Kerja',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoPIC.value.detail?.lokasiKerja ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Text(
                                                    'Assign PIC Inspection',
                                                    style: TextStyle(color: primaryColor, fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'PIC Inspection',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoPIC.value.detail?.picInspector ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  Text(
                                                    'Assign PIC Laboratory',
                                                    style: TextStyle(color: primaryColor, fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'PIC Laboratory',
                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      const VerticalDivider(width: 1),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          controller.dataJoPIC.value.detail?.picLaboratory ?? '-',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(thickness: 0.4),
                                                  controller.dataJoPIC.value.lab != null
                                                      ? Column(
                                                          children: [
                                                            for (var i = 0; i < controller.dataJoPIC.value.lab!.length; i++)
                                                              Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Text(
                                                                          'Laboratory ${i + 1}',
                                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                        ),
                                                                      ),
                                                                      const VerticalDivider(width: 1),
                                                                      const SizedBox(width: 16),
                                                                      Expanded(
                                                                        child: Text(
                                                                          controller.dataJoPIC.value.lab![i].name ?? '-',
                                                                          style: TextStyle(
                                                                            fontSize: 12.sp,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  const Divider(thickness: 0.4),
                                                                ],
                                                              ),
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                                width: MediaQuery.sizeOf(context).width - 40,
                                                child: ExpansionTile(
                                                  shape: Border.all(color: Colors.transparent),
                                                  title: Text(
                                                    'Assign History',
                                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: primaryColor),
                                                  ),
                                                  childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
                                                  children: <Widget>[
                                                    controller.barges.value.isNotEmpty
                                                        ? Column(
                                                            children: [
                                                              for (var i = controller.dataJoPIC.value.assignHistory?.length ?? 0; i > 0; i--)
                                                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                  Text(
                                                                    'Assign ${i}',
                                                                    style: TextStyle(color: green, fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                  ),
                                                                  const SizedBox(height: 16),
                                                                  Row(children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Assign Date',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    const VerticalDivider(width: 1),
                                                                    const SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        controller.dataJoPIC.value.assignHistory![i - 1].assignedDate ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                                  const Divider(thickness: 0.4),
                                                                  Row(children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Assign By',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    const VerticalDivider(width: 1),
                                                                    const SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        controller.dataJoPIC.value.assignHistory![i - 1].assignBy ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                                  const Divider(thickness: 0.4),
                                                                  Row(children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Remarks',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    const VerticalDivider(width: 1),
                                                                    const SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        controller.dataJoPIC.value.assignHistory![i - 1].remarks ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                                  const Divider(thickness: 0.4),
                                                                  Row(children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Previous ETA Vessel',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    const VerticalDivider(width: 1),
                                                                    const SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        controller.dataJoPIC.value.assignHistory![i - 1].ettaVessel ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                                  const Divider(thickness: 0.4),
                                                                  Row(children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Previous Date of Attendance',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    const VerticalDivider(width: 1),
                                                                    const SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        '${controller.dataJoPIC.value.assignHistory![i - 1].startDateOfAttendance ?? '-'} - ${controller.dataJoPIC.value.assignHistory![i - 1].endDateOfAttendance ?? '-'}',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                                  const Divider(thickness: 0.4),
                                                                  Row(children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Previous Lokasi Kerja',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    const VerticalDivider(width: 1),
                                                                    const SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        controller.dataJoPIC.value.assignHistory![i - 1].lokasiKerja ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                                  const Divider(thickness: 0.4),
                                                                  Row(children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Previous PIC Inspection',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    const VerticalDivider(width: 1),
                                                                    const SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        controller.dataJoPIC.value.assignHistory![i - 1].picInspector ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                                  const Divider(thickness: 0.4),
                                                                  Row(children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Previous PIC Laboratory',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    const VerticalDivider(width: 1),
                                                                    const SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        controller.dataJoPIC.value.assignHistory![i - 1].picLaboratory ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                                  const Divider(thickness: 0.4),
                                                                ])
                                                            ],
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                )),
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
                                child: Obx(
                                  () => Column(children: [
                                    SizedBox(
                                      child: Card(
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Inspection Progress',
                                                  style: TextStyle(color: primaryColor, fontSize: 14.sp, fontWeight: FontWeight.w700),
                                                ),
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Order Start - End Date',
                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                      ),
                                                    ),
                                                    const VerticalDivider(width: 1),
                                                    const SizedBox(width: 16),
                                                    Expanded(
                                                      child: Text(
                                                        '-',
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const Divider(thickness: 0.4),
                                                Text(
                                                  'Photos',
                                                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                ),
                                                const Divider(thickness: 0.4),
                                                controller.isLoadingJOImage == false
                                                    ? controller.dailyActivityPhotosV2.value.isNotEmpty
                                                        ? GridView.builder(
                                                            shrinkWrap: true,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 5,
                                                              mainAxisSpacing: 8,
                                                              crossAxisSpacing: 8,
                                                            ),
                                                            itemCount: controller.dailyActivityPhotosV2.value.length,
                                                            itemBuilder: (content, index) {
                                                              //final File photo = controller.dailyActivityPhotosV2.value[index];
                                                              TDJoInspectionPict pict = controller.dailyActivityPhotosV2.value[index];
                                                              return InkWell(
                                                                onTap: () {
                                                                  controller.previewImage(index, pict!.pathPhoto!, pict!.keterangan!, pict);
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
                                                            })
                                                        : const SizedBox()
                                                    : Expanded(child: Center(child: CircularProgressIndicator())),
                                              ],
                                            ),
                                          )),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                        child: Card(
                                      color: Colors.white,
                                      child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Column(children: [
                                            Row(children: [
                                              Text(
                                                'Daily Activity',
                                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: primaryColor),
                                              ),
                                              const SizedBox(width: 8),
                                              controller.dataJoDetail.value.detail?.statusJo != ''
                                                  ? Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: primaryColor,
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      child: Text(controller.stageList.length == 0 ? "None" : controller.activityStages[controller.activityStage - 1],
                                                          style: TextStyle(color: Colors.white)))
                                                  : const SizedBox(),
                                              Spacer(),
                                            ]),
                                            const SizedBox(height: 16),
                                            controller.stageList.value.isNotEmpty
                                                ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                    controller.stageList.value.where((item) => item.mStatusinspectionstagesId == 1).isNotEmpty
                                                        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'Stage 1: Waiting For Arrival',
                                                                  style: TextStyle(color: green, fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(height: 8),
                                                            //controller.stageList.value
                                                            for (var progressActivity in controller.stageList.value.where((item) => item.mStatusinspectionstagesId == 1))
                                                              Column(children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Date',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        progressActivity.transDate ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                                ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  itemCount: progressActivity.listActivity?.length ?? 0,
                                                                  itemBuilder: (context, index) {
                                                                    final activity = progressActivity.listActivity?[index];
                                                                    return Row(
                                                                      children: [
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            'Activities',
                                                                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                        VerticalDivider(width: 1),
                                                                        SizedBox(width: 8),
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            '${Helper.formatToHourMinute(activity!.startActivityTime!) ?? '-'} - ${Helper.formatToHourMinute(activity!.endActivityTime!) ?? '-'}',
                                                                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                        VerticalDivider(width: 1),
                                                                        SizedBox(width: 8),
                                                                        Expanded(
                                                                          flex: 2,
                                                                          child: Text(
                                                                            activity?.activity ?? '-',
                                                                            style: TextStyle(
                                                                              fontSize: 12.sp,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    );
                                                                  },
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Remarks',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        progressActivity.remarks ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                              ]),
                                                          ])
                                                        : const SizedBox(),
                                                    controller.stageList.value.where((item) => item.mStatusinspectionstagesId == 2).isNotEmpty
                                                        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'Stage 2: Ship Arrived',
                                                                  style: TextStyle(color: green, fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                ),
                                                                const SizedBox(width: 8),
                                                              ],
                                                            ),
                                                            const SizedBox(height: 8),
                                                            for (var progressActivity in controller.stageList.value.where((item) => item.mStatusinspectionstagesId == 2))
                                                              Column(children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Date',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        progressActivity.transDate ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                                ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  itemCount: progressActivity.listActivity?.length ?? 0,
                                                                  itemBuilder: (context, index) {
                                                                    final activity = progressActivity.listActivity?[index];
                                                                    return Row(
                                                                      children: [
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            'Activities',
                                                                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                        VerticalDivider(width: 1),
                                                                        SizedBox(width: 8),
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            '${Helper.formatToHourMinute(activity!.startActivityTime!) ?? '-'} - ${Helper.formatToHourMinute(activity!.endActivityTime!) ?? '-'}',
                                                                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                        VerticalDivider(width: 1),
                                                                        SizedBox(width: 8),
                                                                        Expanded(
                                                                          flex: 2,
                                                                          child: Text(
                                                                            activity?.activity ?? '-',
                                                                            style: TextStyle(
                                                                              fontSize: 12.sp,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    );
                                                                  },
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Remarks',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        progressActivity.remarks ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                              ]),
                                                          ])
                                                        : const SizedBox(),
                                                    controller.stageList.value.where((item) => item.mStatusinspectionstagesId == 3).isNotEmpty
                                                        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'Stage 3: Ship Berthing',
                                                                  style: TextStyle(color: green, fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                ),
                                                                const SizedBox(width: 8),
                                                              ],
                                                            ),
                                                            const SizedBox(height: 8),
                                                            for (var progressActivity in controller.stageList.value.where((item) => item.mStatusinspectionstagesId == 3))
                                                              Column(children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Date',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        progressActivity.transDate ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                                ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  itemCount: progressActivity.listActivity?.length ?? 0,
                                                                  itemBuilder: (context, index) {
                                                                    final activity = progressActivity.listActivity?[index];
                                                                    return Row(
                                                                      children: [
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            'Activities',
                                                                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                        VerticalDivider(width: 1),
                                                                        SizedBox(width: 8),
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            '${Helper.formatToHourMinute(activity!.startActivityTime!) ?? '-'} - ${Helper.formatToHourMinute(activity!.endActivityTime!) ?? '-'}',
                                                                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                        VerticalDivider(width: 1),
                                                                        SizedBox(width: 8),
                                                                        Expanded(
                                                                          flex: 2,
                                                                          child: Text(
                                                                            activity?.activity ?? '-',
                                                                            style: TextStyle(
                                                                              fontSize: 12.sp,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    );
                                                                  },
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Remarks',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        progressActivity.remarks ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                              ]),
                                                          ])
                                                        : const SizedBox(),
                                                    controller.stageList.value.where((item) => item.mStatusinspectionstagesId == 4).isNotEmpty
                                                        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'Stage 4: Work Commence',
                                                                  style: TextStyle(color: green, fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                ),
                                                                const SizedBox(width: 8),
                                                              ],
                                                            ),
                                                            const SizedBox(height: 8),
                                                            for (var progressActivity in controller.stageList.value.where((item) => item.mStatusinspectionstagesId == 4))
                                                              Column(children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Date',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        progressActivity.transDate ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                                ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  itemCount: progressActivity.listActivity?.length ?? 0,
                                                                  itemBuilder: (context, index) {
                                                                    final activity = progressActivity.listActivity?[index];
                                                                    return Row(
                                                                      children: [
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            'Activities',
                                                                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                        VerticalDivider(width: 1),
                                                                        SizedBox(width: 8),
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            '${Helper.formatToHourMinute(activity!.startActivityTime!) ?? '-'} - ${Helper.formatToHourMinute(activity!.endActivityTime!) ?? '-'}',
                                                                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                        VerticalDivider(width: 1),
                                                                        SizedBox(width: 8),
                                                                        Expanded(
                                                                          flex: 2,
                                                                          child: Text(
                                                                            activity?.activity ?? '-',
                                                                            style: TextStyle(
                                                                              fontSize: 12.sp,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    );
                                                                  },
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Remarks',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        progressActivity.remarks ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                              ]),
                                                          ])
                                                        : const SizedBox(),
                                                    controller.stageList.value.where((item) => item.mStatusinspectionstagesId == 5).isNotEmpty
                                                        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                            Row(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      'Stage 5: Work Complete',
                                                                      style: TextStyle(color: green, fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                    ),
                                                                    const SizedBox(width: 8),
                                                                  ],
                                                                ),
                                                                const SizedBox(width: 8),
                                                              ],
                                                            ),
                                                            for (var progressActivity in controller.stageList.value.where((item) => item.mStatusinspectionstagesId == 5))
                                                              Column(children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Activity Date',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    const VerticalDivider(width: 1),
                                                                    const SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        progressActivity.transDate ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Activity Time',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        progressActivity.createdAt ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Actual Qty',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    const VerticalDivider(width: 1),
                                                                    const SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        //double.parse(progressActivity?.actualQty ?? '0').toString(),
                                                                        progressActivity?.actualQty ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'UOM',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        controller.dataJoDetail.value.detail?.uomName ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Vessel',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        progressActivity!.activityVesel?.vessel ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                                ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  itemCount: progressActivity.listActivityBarge?.length ?? 0,
                                                                  itemBuilder: (context, index) {
                                                                    final activityBarge = progressActivity.listActivityBarge?[index];
                                                                    return Column(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                                child: Text(
                                                                              'Barge ${index + 1}',
                                                                              style: TextStyle(
                                                                                fontSize: 12.sp,
                                                                                fontWeight: FontWeight.w700,
                                                                              ),
                                                                            )),
                                                                            VerticalDivider(
                                                                              width: 1,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 16,
                                                                            ),
                                                                            Expanded(
                                                                                child: Text(
                                                                              '${activityBarge!.barge!}',
                                                                              style: TextStyle(
                                                                                fontSize: 12.sp,
                                                                                fontWeight: FontWeight.w700,
                                                                              ),
                                                                            ))
                                                                          ],
                                                                        ),
                                                                        const Divider(
                                                                          thickness: 0.4,
                                                                        )
                                                                      ],
                                                                    );
                                                                  },
                                                                ),
                                                                ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  itemCount: progressActivity.listActivityStageTranshipment?.length ?? 0,
                                                                  itemBuilder: (context, index) {
                                                                    final transhipment = progressActivity.listActivityStageTranshipment?[index];
                                                                    return Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          'KOS Transhipment ${index + 1}',
                                                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                        ),
                                                                        const SizedBox(height: 16),
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text(
                                                                                'Jetty',
                                                                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                              ),
                                                                            ),
                                                                            VerticalDivider(width: 1),
                                                                            SizedBox(width: 16),
                                                                            Expanded(
                                                                              child: Text(
                                                                                transhipment!.jetty ?? '-',
                                                                                style: TextStyle(
                                                                                  fontSize: 12.sp,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        const Divider(thickness: 0.4),
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text(
                                                                                'Initial Date',
                                                                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                              ),
                                                                            ),
                                                                            VerticalDivider(width: 1),
                                                                            SizedBox(width: 16),
                                                                            Expanded(
                                                                              child: Text(
                                                                                transhipment!.initialDate ?? '-',
                                                                                style: TextStyle(
                                                                                  fontSize: 12.sp,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        const Divider(thickness: 0.4),
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text(
                                                                                'Final Date',
                                                                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                              ),
                                                                            ),
                                                                            VerticalDivider(width: 1),
                                                                            SizedBox(width: 16),
                                                                            Expanded(
                                                                              child: Text(
                                                                                transhipment!.finalDate ?? '-',
                                                                                style: TextStyle(
                                                                                  fontSize: 12.sp,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        const Divider(thickness: 0.4),
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text(
                                                                                'Delivery Qty',
                                                                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                              ),
                                                                            ),
                                                                            VerticalDivider(width: 1),
                                                                            SizedBox(width: 16),
                                                                            Expanded(
                                                                              child: Text(
                                                                                double.parse(transhipment!.deliveryQty!.toString()).toInt().toString() ?? '-',
                                                                                style: TextStyle(
                                                                                  fontSize: 12.sp,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        const Divider(thickness: 0.4),
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text(
                                                                                'UOM',
                                                                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                              ),
                                                                            ),
                                                                            VerticalDivider(width: 1),
                                                                            SizedBox(width: 16),
                                                                            Expanded(
                                                                              child: Text(
                                                                                transhipment!.uomName ?? '-',
                                                                                style: TextStyle(
                                                                                  fontSize: 12.sp,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        const Divider(thickness: 0.4),
                                                                      ],
                                                                    );
                                                                  },
                                                                )
                                                              ]),
                                                          ])
                                                        : const SizedBox(),
                                                  ])
                                                : const SizedBox(),
                                            controller.stageList.value.where((item) => item.mStatusinspectionstagesId == 6).isNotEmpty
                                                ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Stage 6: Report to Client',
                                                          style: TextStyle(color: green, fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                        const SizedBox(width: 8),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 16),
                                                    for (var progressActivity in controller.stageList.value.where((item) => item.mStatusinspectionstagesId == 6))
                                                      Column(children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                'Date',
                                                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                              ),
                                                            ),
                                                            VerticalDivider(width: 1),
                                                            SizedBox(width: 16),
                                                            Expanded(
                                                              child: Text(
                                                                progressActivity.transDate ?? '-',
                                                                style: TextStyle(
                                                                  fontSize: 12.sp,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const Divider(thickness: 0.4),
                                                        ListView.builder(
                                                          shrinkWrap: true,
                                                          physics: NeverScrollableScrollPhysics(),
                                                          itemCount: progressActivity.listActivity?.length ?? 0,
                                                          itemBuilder: (context, index) {
                                                            final activity = progressActivity.listActivity?[index];
                                                            return Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    'Activities',
                                                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                  ),
                                                                ),
                                                                VerticalDivider(width: 1),
                                                                SizedBox(width: 8),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    '${Helper.formatToHourMinute(activity!.startActivityTime!) ?? '-'} - ${Helper.formatToHourMinute(activity!.endActivityTime!) ?? '-'}',
                                                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                  ),
                                                                ),
                                                                VerticalDivider(width: 1),
                                                                SizedBox(width: 8),
                                                                Expanded(
                                                                  flex: 2,
                                                                  child: Text(
                                                                    activity?.activity ?? '-',
                                                                    style: TextStyle(
                                                                      fontSize: 12.sp,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                'Remarks',
                                                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                              ),
                                                            ),
                                                            VerticalDivider(width: 1),
                                                            SizedBox(width: 16),
                                                            Expanded(
                                                              child: Text(
                                                                progressActivity.remarks ?? '-',
                                                                style: TextStyle(
                                                                  fontSize: 12.sp,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const Divider(thickness: 0.4),
                                                      ]),
                                                    const SizedBox(height: 16),
                                                    Text(
                                                      'Attachment',
                                                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    controller.activity6Attachments.value.isNotEmpty
                                                        ? GridView.builder(
                                                            shrinkWrap: true,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 5,
                                                              mainAxisSpacing: 8,
                                                              crossAxisSpacing: 8,
                                                            ),
                                                            itemCount: controller.activity6Attachments.value.length,
                                                            itemBuilder: (content, index) {
                                                              final File attach = controller.activity6Attachments.value[index];
                                                              final String fileType = controller.checkFileType(attach.path);
                                                              var filenameArr = attach.path.split("/");
                                                              var filename = filenameArr.last;
                                                              return fileType == 'image'
                                                                  ? SizedBox(
                                                                      width: 54,
                                                                      height: 66,
                                                                      child: SizedBox(
                                                                        width: 54,
                                                                        height: 54,
                                                                        child: InkWell(
                                                                          onTap: () {
                                                                            controller.previewImageAct6(index, attach.path);
                                                                          },
                                                                          child: Image.file(
                                                                            File(attach.path),
                                                                            fit: BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : fileType == 'doc'
                                                                      ? SizedBox(
                                                                          width: 54,
                                                                          height: 66,
                                                                          child: InkWell(
                                                                            onTap: () {
                                                                              OpenFilex.open(attach.path);
                                                                            },
                                                                            child: SizedBox(
                                                                              width: 54,
                                                                              height: 54,
                                                                              child: Center(
                                                                                  child: Column(
                                                                                children: [
                                                                                  Image.asset(
                                                                                    'assets/icons/pdfIcon.png',
                                                                                    height: 42,
                                                                                  ),
                                                                                  Text(filename, style: TextStyle(fontSize: 8), overflow: TextOverflow.ellipsis)
                                                                                ],
                                                                              )),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : SizedBox();
                                                            })
                                                        : const SizedBox()
                                                  ])
                                                : const SizedBox(),
                                            const SizedBox(height: 16),
                                            controller.activityListStages.value.isNotEmpty
                                                ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                    controller.activityListStages.value.where((item) => item.mStatusinspectionstagesId == 1).isNotEmpty
                                                        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                            Text(
                                                              'Stage 1: Waiting For Arrival',
                                                              style: TextStyle(color: green, fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                            ),
                                                            const SizedBox(height: 8),
                                                            for (var progressActivity in controller.activityListStages.value.where((item) => item.mStatusinspectionstagesId == 1))
                                                              Column(children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Date',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        progressActivity.transDate ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        'Activities',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 8),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        '${progressActivity.startActivityTime ?? '-'} - ${progressActivity.endActivityTime ?? '-'}',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 8),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Text(
                                                                        progressActivity.activity ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Remarks',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        progressActivity.remarks ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                              ]),
                                                          ])
                                                        : const SizedBox(),
                                                    controller.activityListStages.value.where((item) => item.mStatusinspectionstagesId == 2).isNotEmpty
                                                        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                            Text(
                                                              'Stage 2: Ship Arrived',
                                                              style: TextStyle(color: green, fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                            ),
                                                            const SizedBox(height: 8),
                                                            for (var progressActivity in controller.activityListStages.value.where((item) => item.mStatusinspectionstagesId == 2))
                                                              Column(children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Date',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        progressActivity.transDate ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        'Activities',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 8),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        '${progressActivity.startActivityTime ?? '-'} - ${progressActivity.endActivityTime ?? '-'}',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 8),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Text(
                                                                        progressActivity.activity ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Remarks',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        progressActivity.remarks ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                              ]),
                                                          ])
                                                        : const SizedBox(),
                                                    controller.activityListStages.value.where((item) => item.mStatusinspectionstagesId == 3).isNotEmpty
                                                        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                            Text(
                                                              'Stage 3: Ship Berthing',
                                                              style: TextStyle(color: green, fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                            ),
                                                            const SizedBox(height: 8),
                                                            for (var progressActivity in controller.activityListStages.value.where((item) => item.mStatusinspectionstagesId == 3))
                                                              Column(children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Date',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        progressActivity.transDate ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        'Activities',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 8),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        '${progressActivity.startActivityTime ?? '-'} - ${progressActivity.endActivityTime ?? '-'}',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 8),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Text(
                                                                        progressActivity.activity ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Remarks',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        progressActivity.remarks ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                              ]),
                                                          ])
                                                        : const SizedBox(),
                                                    controller.activityListStages.value.where((item) => item.mStatusinspectionstagesId == 4).isNotEmpty
                                                        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                            Text(
                                                              'Stage 4: Work Commence',
                                                              style: TextStyle(color: green, fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                            ),
                                                            const SizedBox(height: 8),
                                                            for (var progressActivity in controller.activityListStages.value.where((item) => item.mStatusinspectionstagesId == 4))
                                                              Column(children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Date',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        progressActivity.transDate ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        'Activities',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 8),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        '${progressActivity.startActivityTime ?? '-'} - ${progressActivity.endActivityTime ?? '-'}',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 8),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Text(
                                                                        progressActivity.activity ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        'Remarks',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(width: 1),
                                                                    SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        progressActivity.remarks ?? '-',
                                                                        style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Divider(thickness: 0.4),
                                                              ]),
                                                          ])
                                                        : const SizedBox(),
                                                  ])
                                                : const SizedBox(),
                                            controller.activity5ListStages.value.isNotEmpty
                                                ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                    Text(
                                                      'Stage 5: Work Complete',
                                                      style: TextStyle(color: green, fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Activity Date',
                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        VerticalDivider(width: 1),
                                                        SizedBox(width: 16),
                                                        Expanded(
                                                          child: Text(
                                                            controller.activity5ListStages.value.first.transDate ?? '-',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const Divider(thickness: 0.4),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Activity Time',
                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        VerticalDivider(width: 1),
                                                        SizedBox(width: 16),
                                                        Expanded(
                                                          child: Text(
                                                            '-',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const Divider(thickness: 0.4),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Actual Qty',
                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        VerticalDivider(width: 1),
                                                        SizedBox(width: 16),
                                                        Expanded(
                                                          child: Text(
                                                            controller.activity5ListStages.value.first.actualQty ?? '-',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const Divider(thickness: 0.4),
                                                    Row(
                                                      children: [
                                                        const Expanded(
                                                          child: Text(
                                                            'Activity Date',
                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        VerticalDivider(width: 1),
                                                        SizedBox(width: 16),
                                                        Expanded(
                                                          child: Text(
                                                            controller.dataJoDetail.value.detail!.uomName ?? '-',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const Divider(thickness: 0.4),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Vessel',
                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        VerticalDivider(width: 1),
                                                        SizedBox(width: 16),
                                                        Expanded(
                                                          child: Text(
                                                            controller.activity5ListStages.value.first.vessel ?? '-',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const Divider(thickness: 0.4),
                                                    controller.activity5ListStages.value.first.barge!.isNotEmpty
                                                        ? Column(
                                                            children: [
                                                              ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  itemCount: controller.activity5ListStages.value.first.barge!.length,
                                                                  itemBuilder: (context, index) {
                                                                    return Column(children: [
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: Text(
                                                                              'Barge ${index + 1}',
                                                                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                            ),
                                                                          ),
                                                                          VerticalDivider(width: 1),
                                                                          SizedBox(width: 16),
                                                                          Expanded(
                                                                            child: Text(
                                                                              controller.activity5ListStages.value.first.barge![index].barge ?? '-',
                                                                              style: TextStyle(
                                                                                fontSize: 12.sp,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      const Divider(thickness: 0.4),
                                                                    ]);
                                                                  }),
                                                            ],
                                                          )
                                                        : const SizedBox(),
                                                    controller.activity5ListStages.value.first.transhipment!.isNotEmpty
                                                        ? Column(
                                                            children: [
                                                              ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  itemCount: controller.activity5ListStages.value.first.transhipment!.length,
                                                                  itemBuilder: (context, index) {
                                                                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                      Text(
                                                                        'KOS Transhipment ${index + 1}',
                                                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                      ),
                                                                      const SizedBox(height: 16),
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: Text(
                                                                              'Jetty',
                                                                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                            ),
                                                                          ),
                                                                          VerticalDivider(width: 1),
                                                                          SizedBox(width: 16),
                                                                          Expanded(
                                                                            child: Text(
                                                                              controller.activity5ListStages.value.first.transhipment![index].jetty ?? '-',
                                                                              style: TextStyle(
                                                                                fontSize: 12.sp,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      const Divider(thickness: 0.4),
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: Text(
                                                                              'Initial Date',
                                                                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                            ),
                                                                          ),
                                                                          VerticalDivider(width: 1),
                                                                          SizedBox(width: 16),
                                                                          Expanded(
                                                                            child: Text(
                                                                              controller.activity5ListStages.value.first.transhipment![index].initialDate ?? '-',
                                                                              style: TextStyle(
                                                                                fontSize: 12.sp,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      const Divider(thickness: 0.4),
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: Text(
                                                                              'Final Date',
                                                                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                            ),
                                                                          ),
                                                                          VerticalDivider(width: 1),
                                                                          SizedBox(width: 16),
                                                                          Expanded(
                                                                            child: Text(
                                                                              controller.activity5ListStages.value.first.transhipment![index].finalDate ?? '-',
                                                                              style: TextStyle(
                                                                                fontSize: 12.sp,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      const Divider(thickness: 0.4),
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: Text(
                                                                              'Delivery Qty',
                                                                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                            ),
                                                                          ),
                                                                          VerticalDivider(width: 1),
                                                                          SizedBox(width: 16),
                                                                          Expanded(
                                                                            child: Text(
                                                                              '0',
                                                                              style: TextStyle(
                                                                                fontSize: 12.sp,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      const Divider(thickness: 0.4),
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: Text(
                                                                              'UOM',
                                                                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                            ),
                                                                          ),
                                                                          VerticalDivider(width: 1),
                                                                          SizedBox(width: 16),
                                                                          Expanded(
                                                                            child: Text(
                                                                              controller.dataJoDetail.value.detail!.uomName ?? '-',
                                                                              style: TextStyle(
                                                                                fontSize: 12.sp,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      const Divider(thickness: 0.4),
                                                                    ]);
                                                                  }),
                                                            ],
                                                          )
                                                        : const SizedBox(),
                                                  ])
                                                : const SizedBox(),
                                            controller.activity6ListStages.value.isNotEmpty
                                                ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                    Text(
                                                      'Stage 6: Report to Client',
                                                      style: TextStyle(color: green, fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    ListView.builder(
                                                        shrinkWrap: true,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        itemCount: controller.activity6ListStages.value.length,
                                                        itemBuilder: (context, index) {
                                                          Activity act6 = controller.activity6ListStages.value[index];
                                                          return Column(children: [
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    'Date',
                                                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                  ),
                                                                ),
                                                                VerticalDivider(width: 1),
                                                                SizedBox(width: 16),
                                                                Expanded(
                                                                  child: Text(
                                                                    act6.transDate ?? '-',
                                                                    style: TextStyle(
                                                                      fontSize: 12.sp,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            const Divider(thickness: 0.4),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    'Activities',
                                                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                  ),
                                                                ),
                                                                VerticalDivider(width: 1),
                                                                SizedBox(width: 8),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    '${act6.startActivityTime ?? '-'} - ${act6.endActivityTime ?? '-'}',
                                                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                  ),
                                                                ),
                                                                VerticalDivider(width: 1),
                                                                SizedBox(width: 8),
                                                                Expanded(
                                                                  flex: 2,
                                                                  child: Text(
                                                                    act6.activity ?? '-',
                                                                    style: TextStyle(
                                                                      fontSize: 12.sp,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            const Divider(thickness: 0.4),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    'Remarks',
                                                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                                  ),
                                                                ),
                                                                VerticalDivider(width: 1),
                                                                SizedBox(width: 16),
                                                                Expanded(
                                                                  child: Text(
                                                                    act6.remarks ?? '-',
                                                                    style: TextStyle(
                                                                      fontSize: 12.sp,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            const Divider(thickness: 0.4),
                                                          ]);
                                                        }),
                                                    const SizedBox(height: 16),
                                                    Text(
                                                      'Attachment',
                                                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    controller.activity6Attachments.value.isNotEmpty
                                                        ? GridView.builder(
                                                            shrinkWrap: true,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 5,
                                                              mainAxisSpacing: 8,
                                                              crossAxisSpacing: 8,
                                                            ),
                                                            itemCount: controller.activity6Attachments.value.length,
                                                            itemBuilder: (content, index) {
                                                              final File attach = controller.activity6Attachments.value[index];
                                                              final String fileType = controller.checkFileType(attach.path);
                                                              var filenameArr = attach.path.split("/");
                                                              var filename = filenameArr.last;
                                                              return fileType == 'image'
                                                                  ? SizedBox(
                                                                      width: 54,
                                                                      height: 54,
                                                                      child: InkWell(
                                                                        onTap: () {
                                                                          controller.previewImage6(index, attach.path, '');
                                                                        },
                                                                        child: Image.file(
                                                                          File(attach.path),
                                                                          fit: BoxFit.cover,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : fileType == 'doc'
                                                                      ? InkWell(
                                                                          onTap: () {
                                                                            OpenFilex.open(attach.path);
                                                                          },
                                                                          child: SizedBox(
                                                                            width: 54,
                                                                            height: 54,
                                                                            child: Center(
                                                                                child: Column(
                                                                              children: [
                                                                                Image.asset(
                                                                                  'assets/icons/pdfIcon.png',
                                                                                  height: 42,
                                                                                ),
                                                                                Text(filename, style: TextStyle(fontSize: 8), overflow: TextOverflow.ellipsis)
                                                                              ],
                                                                            )),
                                                                          ),
                                                                        )
                                                                      : SizedBox();
                                                            })
                                                        : const SizedBox()
                                                  ])
                                                : const SizedBox(),
                                          ])),
                                    ))
                                  ]),
                                )),
                          ),
                        'Laboratory Progress' => SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Obx(
                                () => Column(children: [
                                  TextFormField(
                                    controller: controller.searchLabText,
                                    cursorColor: onFocusColor,
                                    style: const TextStyle(color: onFocusColor),
                                    decoration: InputDecoration(
                                        suffixIcon: const Icon(
                                          Icons.search_sharp,
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
                                        labelText: 'Cari Laboratory',
                                        labelStyle: const TextStyle(color: Colors.black26),
                                        floatingLabelBehavior: FloatingLabelBehavior.never),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  controller.labs.value.isNotEmpty
                                      ? ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: controller.labs.value.length,
                                          itemBuilder: (context, index) {
                                            var lab = controller.labs.value[index];
                                            return Column(
                                              children: [
                                                SizedBox(
                                                  child: InkWell(
                                                    onTap: () {
                                                      controller.detailLabActivity(lab.laboratoriumId!.toInt(), lab.name!, lab.id!.toInt());
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
                                                                    child: Text(
                                                                      lab.name ?? '-',
                                                                      style: TextStyle(
                                                                          fontSize: 12.sp,
                                                                          fontWeight: FontWeight.w700,
                                                                          color: lab.maxStage!.toInt() > 0 && lab.maxStage!.toInt() < 6
                                                                              ? stepperColor
                                                                              : lab.maxStage!.toInt() == 6
                                                                                  ? green
                                                                                  : Colors.black),
                                                                    ),
                                                                  ),
                                                                  Icon(Icons.chevron_right)
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                              ],
                                            );
                                          })
                                      : const SizedBox(),
                                  const SizedBox(height: 16),
                                ]),
                              ),
                            ),
                          ),
                        'Document - Inspection' => SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(children: [
                                controller.statusId == 4 && controller.inspectionDocuments.value.isEmpty
                                    ? Row(children: [
                                        Spacer(),
                                        IconButton(
                                            onPressed: () {
                                              Get.off<void>(DocumentsScreen.new, arguments: {'type': 'inspect', 'id': controller.id.toString(), 'status': controller.statusId});
                                              // controller.drawerAddDocument('inspect');
                                            },
                                            icon: Image.asset(
                                              'assets/icons/addactivity.png',
                                              height: 32,
                                            ))
                                      ])
                                    : const SizedBox(),
                                const SizedBox(height: 16),
                                controller.inspectionDocuments.value.isNotEmpty
                                    ? Card(
                                        color: Colors.white,
                                        child: SizedBox(
                                          width: MediaQuery.sizeOf(context).width - 40,
                                          child: ExpansionTile(
                                              shape: Border.all(color: Colors.transparent),
                                              title: Text(
                                                'Inspection Certificate',
                                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: primaryColor),
                                              ),
                                              childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
                                              expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                controller.inspectionDocuments.value.isNotEmpty
                                                    ? ListView.builder(
                                                        shrinkWrap: true,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        itemCount: controller.inspectionDocuments.value.length,
                                                        itemBuilder: (context, index) {
                                                          var inspect = controller.inspectionDocuments.value[index];
                                                          return Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'Certificate ${index + 1}',
                                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: green),
                                                              ),
                                                              const SizedBox(height: 16),
                                                              Row(
                                                                children: [
                                                                  const Expanded(
                                                                    child: Text(
                                                                      'No Certificate/Report',
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const VerticalDivider(width: 1),
                                                                  const SizedBox(width: 16),
                                                                  Expanded(
                                                                    child: Text(
                                                                      inspect.noReport ?? '-',
                                                                      style: const TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const Divider(thickness: 0.4),
                                                              Row(
                                                                children: [
                                                                  const Expanded(
                                                                    child: Text(
                                                                      'Date Certificate/Report',
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const VerticalDivider(width: 1),
                                                                  const SizedBox(width: 16),
                                                                  Expanded(
                                                                    child: Text(
                                                                      inspect.dateReport ?? '-',
                                                                      style: const TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const Divider(thickness: 0.4),
                                                              Row(
                                                                children: [
                                                                  const Expanded(
                                                                    child: Text(
                                                                      'No Blanko Certificate',
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const VerticalDivider(width: 1),
                                                                  const SizedBox(width: 16),
                                                                  Expanded(
                                                                    child: Text(
                                                                      inspect.noBlankoCertificate ?? '-',
                                                                      style: const TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const Divider(thickness: 0.4),
                                                              Row(
                                                                children: [
                                                                  const Expanded(
                                                                    child: Text(
                                                                      'LHV Number',
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const VerticalDivider(width: 1),
                                                                  const SizedBox(width: 16),
                                                                  Expanded(
                                                                    child: Text(
                                                                      inspect.lhvNumber ?? '-',
                                                                      style: const TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const Divider(thickness: 0.4),
                                                              Row(
                                                                children: [
                                                                  const Expanded(
                                                                    child: Text(
                                                                      'LS Number',
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const VerticalDivider(width: 1),
                                                                  const SizedBox(width: 16),
                                                                  Expanded(
                                                                    child: Text(
                                                                      inspect.lsNumber ?? '-',
                                                                      style: const TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const Divider(thickness: 0.4),
                                                              Row(
                                                                children: [
                                                                  const Expanded(
                                                                    child: Text(
                                                                      'Upload Attachment Certificate',
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const VerticalDivider(width: 1),
                                                                  const SizedBox(width: 16),
                                                                  controller.inspectionDocumentsFiles.value.isNotEmpty
                                                                      ? Expanded(
                                                                          flex: 1,
                                                                          child: GridView.builder(
                                                                              shrinkWrap: true,
                                                                              physics: NeverScrollableScrollPhysics(),
                                                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                                crossAxisCount: 3,
                                                                                mainAxisSpacing: 8,
                                                                                crossAxisSpacing: 8,
                                                                              ),
                                                                              itemCount: controller.inspectionDocumentsFiles.value.where((item) => item.tDJoFinalizeInspectionId == inspect.id).length,
                                                                              itemBuilder: (content, indexItem) {
                                                                                var fileList =
                                                                                    controller.inspectionDocumentsFiles.value.where((item) => item.tDJoFinalizeInspectionId == inspect.id).toList();
                                                                                final String attach = fileList[indexItem].pathFile!;
                                                                                final String fileType = controller.checkFileType(attach);
                                                                                var filenameArr = attach.split("/");
                                                                                var filename = filenameArr.last;
                                                                                return fileType == 'image'
                                                                                    ? SizedBox(
                                                                                        width: 54,
                                                                                        height: 66,
                                                                                        child: Stack(
                                                                                          children: [
                                                                                            SizedBox(
                                                                                              width: 54,
                                                                                              height: 54,
                                                                                              child: InkWell(
                                                                                                onTap: () {
                                                                                                  controller.previewImageList(index, attach);
                                                                                                },
                                                                                                child: Image.file(
                                                                                                  File(attach),
                                                                                                  fit: BoxFit.cover,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                    : fileType == 'doc'
                                                                                        ? SizedBox(
                                                                                            width: 54,
                                                                                            height: 66,
                                                                                            child: Stack(
                                                                                              children: [
                                                                                                InkWell(
                                                                                                  onTap: () {
                                                                                                    OpenFilex.open(attach);
                                                                                                  },
                                                                                                  child: SizedBox(
                                                                                                    width: 54,
                                                                                                    height: 58,
                                                                                                    child: Center(
                                                                                                        child: Column(
                                                                                                      children: [
                                                                                                        Image.asset(
                                                                                                          'assets/icons/pdfIcon.png',
                                                                                                          height: 30,
                                                                                                        ),
                                                                                                        Text(filename, style: TextStyle(fontSize: 8), overflow: TextOverflow.ellipsis)
                                                                                                      ],
                                                                                                    )),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          )
                                                                                        : SizedBox();
                                                                              }),
                                                                        )
                                                                      : const SizedBox()
                                                                ],
                                                              ),
                                                              const Divider(thickness: 0.4),
                                                            ],
                                                          );
                                                        })
                                                    : const SizedBox(),
                                              ]),
                                        ),
                                      )
                                    : Card(
                                        color: Colors.white,
                                        child: SizedBox(
                                          width: MediaQuery.sizeOf(context).width - 40,
                                          child: Padding(
                                            padding: const EdgeInsets.all(18),
                                            child: Text(
                                              'Inspection Certificate',
                                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: primaryColor),
                                            ),
                                          ),
                                        ),
                                      )
                              ]),
                            ),
                          ),
                        'Document - Laboratory' => SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(children: [
                                controller.statusId == 4 && controller.laboratoryDocuments.value.isEmpty
                                    ? Row(children: [
                                        Spacer(),
                                        IconButton(
                                            onPressed: () {
                                              Get.off<void>(DocumentsScreen.new, arguments: {'type': 'lab', 'id': controller.id.toString(), 'status': controller.statusId});
                                              // controller.drawerAddDocument('inspect');
                                            },
                                            icon: Image.asset(
                                              'assets/icons/addactivity.png',
                                              height: 32,
                                            ))
                                      ])
                                    : const SizedBox(),
                                const SizedBox(height: 16),
                                controller.laboratoryDocuments.value.isNotEmpty
                                    ? Card(
                                        color: Colors.white,
                                        child: SizedBox(
                                          width: MediaQuery.sizeOf(context).width - 40,
                                          child: ExpansionTile(
                                              shape: Border.all(color: Colors.transparent),
                                              title: Text(
                                                'Laboratory Certificate',
                                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: primaryColor),
                                              ),
                                              childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
                                              expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                controller.laboratoryDocuments.value.isNotEmpty
                                                    ? ListView.builder(
                                                        shrinkWrap: true,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        itemCount: controller.laboratoryDocuments.value.length,
                                                        itemBuilder: (context, index) {
                                                          var lab = controller.laboratoryDocuments.value[index];
                                                          return Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'Certificate ${index + 1}',
                                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: green),
                                                              ),
                                                              const SizedBox(height: 16),
                                                              Row(
                                                                children: [
                                                                  const Expanded(
                                                                    child: Text(
                                                                      'No Certificate/Report',
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const VerticalDivider(width: 1),
                                                                  const SizedBox(width: 16),
                                                                  Expanded(
                                                                    child: Text(
                                                                      lab.noReport ?? '-',
                                                                      style: const TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const Divider(thickness: 0.4),
                                                              Row(
                                                                children: [
                                                                  const Expanded(
                                                                    child: Text(
                                                                      'Date Certificate/Report',
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const VerticalDivider(width: 1),
                                                                  const SizedBox(width: 16),
                                                                  Expanded(
                                                                    child: Text(
                                                                      lab.dateReport ?? '-',
                                                                      style: const TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const Divider(thickness: 0.4),
                                                              Row(
                                                                children: [
                                                                  const Expanded(
                                                                    child: Text(
                                                                      'No Blanko Certificate',
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const VerticalDivider(width: 1),
                                                                  const SizedBox(width: 16),
                                                                  Expanded(
                                                                    child: Text(
                                                                      lab.noBlankoCertificate ?? '-',
                                                                      style: const TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const Divider(thickness: 0.4),
                                                              Row(
                                                                children: [
                                                                  const Expanded(
                                                                    child: Text(
                                                                      'LHV Number',
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const VerticalDivider(width: 1),
                                                                  const SizedBox(width: 16),
                                                                  Expanded(
                                                                    child: Text(
                                                                      lab.lhvNumber ?? '-',
                                                                      style: const TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const Divider(thickness: 0.4),
                                                              Row(
                                                                children: [
                                                                  const Expanded(
                                                                    child: Text(
                                                                      'LS Number',
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const VerticalDivider(width: 1),
                                                                  const SizedBox(width: 16),
                                                                  Expanded(
                                                                    child: Text(
                                                                      lab.lsNumber ?? '-',
                                                                      style: const TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const Divider(thickness: 0.4),
                                                              Row(
                                                                children: [
                                                                  const Expanded(
                                                                    child: Text(
                                                                      'Upload Attachment Certificate',
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const VerticalDivider(width: 1),
                                                                  const SizedBox(width: 16),
                                                                  controller.laboratoryDocumentsFiles.value.isNotEmpty
                                                                      ? Expanded(
                                                                          flex: 1,
                                                                          child: GridView.builder(
                                                                              shrinkWrap: true,
                                                                              physics: NeverScrollableScrollPhysics(),
                                                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                                crossAxisCount: 3,
                                                                                mainAxisSpacing: 8,
                                                                                crossAxisSpacing: 8,
                                                                              ),
                                                                              itemCount: controller.laboratoryDocumentsFiles.value.where((item) => item.tDJoFinalizeLaboratoryId == lab.id).length,
                                                                              itemBuilder: (content, indexItem) {
                                                                                var fileList =
                                                                                    controller.laboratoryDocumentsFiles.value.where((item) => item.tDJoFinalizeLaboratoryId == lab.id).toList();
                                                                                final String attach = fileList[indexItem].pathFile!;
                                                                                final String fileType = controller.checkFileType(attach);
                                                                                var filenameArr = attach.split("/");
                                                                                var filename = filenameArr.last;
                                                                                return fileType == 'image'
                                                                                    ? SizedBox(
                                                                                        width: 54,
                                                                                        height: 66,
                                                                                        child: Stack(
                                                                                          children: [
                                                                                            SizedBox(
                                                                                              width: 54,
                                                                                              height: 54,
                                                                                              child: InkWell(
                                                                                                onTap: () {
                                                                                                  controller.previewImageList(index, attach);
                                                                                                },
                                                                                                child: Image.file(
                                                                                                  File(attach),
                                                                                                  fit: BoxFit.cover,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                    : fileType == 'doc'
                                                                                        ? SizedBox(
                                                                                            width: 54,
                                                                                            height: 66,
                                                                                            child: Stack(
                                                                                              children: [
                                                                                                InkWell(
                                                                                                  onTap: () {
                                                                                                    OpenFilex.open(attach);
                                                                                                  },
                                                                                                  child: SizedBox(
                                                                                                    width: 54,
                                                                                                    height: 54,
                                                                                                    child: Center(
                                                                                                        child: Column(
                                                                                                      children: [
                                                                                                        Image.asset(
                                                                                                          'assets/icons/pdfIcon.png',
                                                                                                          height: 34,
                                                                                                        ),
                                                                                                        Text(filename, style: TextStyle(fontSize: 8), overflow: TextOverflow.ellipsis)
                                                                                                      ],
                                                                                                    )),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          )
                                                                                        : SizedBox();
                                                                              }),
                                                                        )
                                                                      : const SizedBox()
                                                                ],
                                                              ),
                                                              const Divider(thickness: 0.4),
                                                            ],
                                                          );
                                                        })
                                                    : const SizedBox(),
                                              ]),
                                        ),
                                      )
                                    : Card(
                                        color: Colors.white,
                                        child: SizedBox(
                                          width: MediaQuery.sizeOf(context).width - 40,
                                          child: Padding(
                                            padding: const EdgeInsets.all(18),
                                            child: Text(
                                              'Laboratory Certificate',
                                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: primaryColor),
                                            ),
                                          ),
                                        ),
                                      )
                              ]),
                            ),
                          ),
                        _ => const Column(
                            children: [
                              Expanded(child: Center(child: CircularProgressIndicator())),
                            ],
                          ),
                      };
                    }).toList())),
              )
            : Column(
                children: [
                  Expanded(child: Center(child: CircularProgressIndicator())),
                ],
              ));
  }
}
