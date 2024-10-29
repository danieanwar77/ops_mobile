import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/feature/notifications/notifications_controller.dart';

class NotificationsScreen extends StatelessWidget{
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context){
    return GetBuilder(
        init: NotificationsController(),
        builder: (controller) => Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            title: const Text('Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Obx(() =>
                    controller.notifications.value.isNotEmpty ? Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.notifications.value.length,
                        itemBuilder: (context,index){
                          var notif = controller.notifications[index];
                          return InkWell(
                            onTap: (){
                                controller.openNotification(notif.id!, notif.joId, notif.mStatusjoId);
                            },
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: Stack(children: [
                                        Icon(Icons.notifications_none_sharp),
                                        notif.flagRead == 0 ? Align(
                                          alignment: AlignmentDirectional.topEnd,
                                          child: SizedBox(
                                            height: 12,
                                            child: Icon(Icons.circle,
                                                  size: 12,
                                                  color: Colors.red,
                                                )
                                          ),
                                        ) : const SizedBox(),
                                      ]),
                                    ),
                                    SizedBox(width: 16,),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('JO${notif.joId}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14
                                            ),
                                          ),
                                          Text(notif.message ?? '-',
                                            style: TextStyle(
                                                fontSize: 14
                                            ),
                                          ),
                                          const SizedBox(height: 8,),
                                          Text(notif.createdAt ?? '-',
                                            style: TextStyle(
                                                fontSize: 12
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ) : const SizedBox(),
                ),
              )
          ),
        )
    );
  }
}