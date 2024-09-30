import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/feature/documents/documents_controller.dart';

class DocumentsScreen extends StatelessWidget{
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: DocumentsController(),
        builder: (controller) => Scaffold(
          appBar: AppBar(
            title: Text('Documents - ${controller.documentType ?? ''}'),
          ),
          body: Column(
            children: [],
          ),
        )
    );
  }
}