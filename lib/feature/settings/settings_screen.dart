import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/feature/settings/settings_controller.dart';

class SettingsScreen extends StatelessWidget{
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context){
    return GetBuilder(
        init: SettingsController(),
        builder: (controller) =>
        Scaffold(
          appBar: AppBar(
            title: Text('Menu Admin'),
          ),
          body: SafeArea(child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 32,
                      height: 32,
                      child: Icon(Icons.phone_android),
                    ),
                    const SizedBox(width: 8,),
                    const Expanded(child: Text('Register Perangkat Pengguna')),
                    const SizedBox(
                      width: 32,
                      height: 32,
                      child: Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0.4,),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 32,
                      height: 32,
                      child: Icon(Icons.delete),
                    ),
                    const SizedBox(width: 8,),
                    const Expanded(child: Text('Hapus Data')),
                    const SizedBox(
                      width: 32,
                      height: 32,
                      child: Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0.4,),

            ],
          )),
        ));
  }
}