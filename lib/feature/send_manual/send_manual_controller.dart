import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';

class SendManualController extends BaseController{

  List<Map<String,String>> dataJo = [
    {
      "title" : "JO123 - JO On Progress",
      "data" : "2024-05-20  08:00:00"
    },
    {
      "title" : "JO234 - JO Waiting For Confirmation Client",
      "data" : "2024-05-20  06:00:00"
    },
  ];

  @override
  void onInit(){

  }

  void loadingDialog(List<Map<String,String>> joList){
    Get.dialog(
      AlertDialog(
        title: Center(child: Text("Pending Data",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
            ),
          )
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Mohon untuk tetap berada di halaman ini sampai proses selesai"),
            SizedBox(height: 16,),
            Column(
                children: [
                  for(var jo in joList) Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
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
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(jo["title"]!,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(jo["data"]!),
                        ),
                      ],
                    ),
                  )
                ]
            ),
            Center(
              child: LoadingAnimationWidget.prograssiveDots(color: primaryColor, size: 80),
            )
          ],
        ),
      ),
    );
  }

  void openDialog(String type, String text) {
    Get.dialog(
      AlertDialog(
        title: Text(type,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
          ),
        ),
        content: Text(text),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

}