import 'package:flutter/material.dart';
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
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
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
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.notifications_none_sharp),
                          SizedBox(width: 16,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('JO',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14
                                ),
                              ),
                              Text('Status: Assigned',
                                style: TextStyle(
                                    fontSize: 14
                                ),
                              ),
                              Text('KOS: Quality Research on PIT',
                                style: TextStyle(
                                    fontSize: 14
                                ),
                              ),
                              SizedBox(height: 16,),
                              Text('2022-05-12  18:08:19',
                                style: TextStyle(
                                    fontSize: 12
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
          ),
        )
    );
  }
}