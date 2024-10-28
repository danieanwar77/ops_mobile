import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/feature/register_device/register_device_controller.dart';
import 'package:ops_mobile/feature/settings/settings_screen.dart';

class RegisterDeviceScreen extends StatelessWidget{
  const RegisterDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: RegisterDeviceController(),
      builder: (controller) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Get.off<void>(SettingsScreen.new);
          },
              icon: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back)),
          title: Text('Register Perangkat Pengguna',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Obx(() => Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    controller: controller.employeeIdText,
                    cursorColor: onFocusColor,
                    style: const TextStyle(color: onFocusColor),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: onFocusColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Kode Employee',
                        floatingLabelStyle:
                        const TextStyle(color: onFocusColor),
                        fillColor: onFocusColor),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    controller: controller.internetUrlText,
                    cursorColor: onFocusColor,
                    style: const TextStyle(color: onFocusColor),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: onFocusColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Alamat Internet',
                        floatingLabelStyle:
                        const TextStyle(color: onFocusColor),
                        fillColor: onFocusColor),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    controller: controller.localUrlText,
                    cursorColor: onFocusColor,
                    style: const TextStyle(color: onFocusColor),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: onFocusColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Alamat Lokal',
                        floatingLabelStyle:
                        const TextStyle(color: onFocusColor),
                        fillColor: onFocusColor),
                  ),
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        controller.registerConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: Container(
                          padding:
                          const EdgeInsets.symmetric(vertical: 12),
                          width: double.infinity,
                          child: Center(
                              child: controller.isLoading.value == true ? CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ) : Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                          )
                      )
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                ],
              ),
              ),
            ),
          ),
        ),
      )
    );
  }
}