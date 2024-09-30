import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/feature/notification/notification_controller.dart';
import 'package:ops_mobile/feature/notifications/notifications_controller.dart';

class NotificationScreen extends StatelessWidget{
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: NotificationController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: const Text('Firebase push Notification'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                controller.notificationAlert,
              ),
              Text(
                controller.title,
              ),
            ],
          ),
        ),
      ),
    );
  }
}