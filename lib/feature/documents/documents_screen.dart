import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/data/storage.dart';
import 'package:ops_mobile/feature/documents/documents_controller.dart';
import 'package:ops_mobile/feature/waiting/jo_waiting_screen.dart';

class DocumentsScreen extends StatelessWidget{
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: DocumentsController(),
        builder: (controller) => Obx(() => Scaffold(
            appBar: AppBar(
              centerTitle: false,
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              leading: IconButton(onPressed: (){
                  Get.off<void>(JoWaitingScreen.new, arguments: {'id': int.parse(controller.idJo.value), 'status': controller.statusJo.value});
              },
                  icon: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back)),
              title: Text(
                'Document - ${controller.documentType.value}',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 16),
              ),
            ),
            body: SafeArea(child:
            Stack(
              children: [SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child:
                      Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: SizedBox()),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor,
                            ),
                            child: IconButton(
                                onPressed: (){
                                  controller.drawerAddDocument(controller.documentType.value);
                                },
                                icon: Icon(Icons.add, color: Colors.white,)
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16,),
                      controller.documents.value.isNotEmpty ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.documents.value.length,
                          itemBuilder: (context,index){
                            var document = controller.documents.value[index];
                            return Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Certificate ${index + 1}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: green
                                      ),
                                    ),
                                    const SizedBox(height:16),
                                    Row(
                                      children: [
                                        const Expanded( child:
                                        Text('No Certificate/Report',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        ),
                                        const VerticalDivider(width: 1),
                                        const SizedBox(width:16),
                                        Expanded( child:
                                        Text(document['certNumber'] ?? '-',
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
                                        Text('Date Certificate/Report',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        ),
                                        const VerticalDivider(width: 1),
                                        const SizedBox(width:16),
                                        Expanded( child:
                                        Text(document['certDate'] ?? '-',
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
                                        Text('No Blanko Certificate',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        ),
                                        const VerticalDivider(width: 1),
                                        const SizedBox(width:16),
                                        Expanded( child:
                                        Text(document['certBlanko'] ?? '-',
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
                                        Text('LHV Number',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        ),
                                        const VerticalDivider(width: 1),
                                        const SizedBox(width:16),
                                        Expanded( child:
                                        Text(document['certLhv'] ?? '-',
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
                                        Text('LS Number',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        ),
                                        const VerticalDivider(width: 1),
                                        const SizedBox(width:16),
                                        Expanded( child:
                                        Text(document['certLs'] ?? '-',
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
                                    Padding(
                                      padding: const EdgeInsets.only(bottom:18.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex:1,
                                            child: Text('Upload Attachment Certificate',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          const VerticalDivider(width: 1),
                                          const SizedBox(width:16),
                                          // controller.documentsAttachments.value[index].isNotEmpty ? Expanded(
                                          //   flex: 1,
                                          //   child: GridView.builder(
                                          //       shrinkWrap: true,
                                          //       physics: NeverScrollableScrollPhysics(),
                                          //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          //         crossAxisCount: 3,
                                          //         mainAxisSpacing: 8,
                                          //         crossAxisSpacing: 8,
                                          //       ),
                                          //       itemCount: controller.documentsAttachments.value[index].length,
                                          //       itemBuilder: (content, indexItem){
                                          //         final String attach = controller.documentsAttachments.value[index][indexItem];
                                          //         final String fileType = controller.checkFileType(attach);
                                          //         var filenameArr = attach.split("/");
                                          //         var filename = filenameArr.last;
                                          //         return fileType == 'image' ? SizedBox(
                                          //           width: 54,
                                          //           height: 66,
                                          //           child: Stack(
                                          //             children: [
                                          //               SizedBox(
                                          //                 width: 54,
                                          //                 height: 54,
                                          //                 child: InkWell(
                                          //                   onTap: (){
                                          //                     controller.previewImageList(index, attach);
                                          //                   },
                                          //                   child: Image.file(
                                          //                     File(attach),
                                          //                     fit: BoxFit.cover,
                                          //                   ),
                                          //                 ),
                                          //               ),
                                          //
                                          //             ],
                                          //           ),
                                          //         ) : fileType == 'doc' ? SizedBox(
                                          //           width: 54,
                                          //           height: 66,
                                          //           child: Stack(
                                          //             children: [
                                          //               InkWell(
                                          //                 onTap: (){
                                          //                   OpenFilex.open(attach);
                                          //                 },
                                          //                 child: SizedBox(
                                          //                   width: 54,
                                          //                   height: 54,
                                          //                   child: Center(
                                          //                       child: Column(
                                          //                         children: [
                                          //                           Image.asset('assets/icons/pdfIcon.png', height: 34,),
                                          //                           Text(filename, style: TextStyle(fontSize: 8), overflow: TextOverflow.ellipsis)
                                          //                         ],
                                          //                       )
                                          //                   ),
                                          //                 ),
                                          //               ),
                                          //             ],
                                          //           ),
                                          //         ) : SizedBox();
                                          //       }
                                          //   ),
                                          // ) : const SizedBox()
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 54,
                                      height: 66,
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: (){
                                              OpenFilex.open(controller.documentsAttachments.value[index]);
                                            },
                                            child: SizedBox(
                                              width: 54,
                                              height: 54,
                                              child: Center(
                                                  child: Column(
                                                    children: [
                                                      Image.asset('assets/icons/pdfIcon.png', height: 34,),
                                                      Text(controller.documentsAttachments.value[index].split('/').last, style: TextStyle(fontSize: 8), overflow: TextOverflow.ellipsis)
                                                    ],
                                                  )
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                        thickness: 0.4
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.red),
                                                  borderRadius: BorderRadius.circular(16)
                                              ),
                                              child: Center(
                                                child: InkWell(
                                                  onTap: () => {
                                                    controller.deleteDocumentUI(document['id'])
                                                  } ,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.delete_outlined, color: Colors.red),
                                                      const SizedBox(width:8),
                                                      Text('Delete', style: TextStyle(color: Colors.red),),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                        ),
                                        const VerticalDivider(width: 1),
                                        const SizedBox(width:16),
                                        Expanded(
                                            child: InkWell(
                                              onTap: (){
                                                controller.drawerEditDocument(index);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.orange),
                                                    borderRadius: BorderRadius.circular(16)
                                                ),
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.edit,color: Colors.orange),
                                                      const SizedBox(width:8),
                                                      Text('Edit',style: TextStyle(color: Colors.orange),),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                      ) : const SizedBox(),
                      const SizedBox(height: 56,),
                    ],
                  ),
                ),
              ),
                controller.documents.value.isNotEmpty ?  Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            controller.openDialogV2(
                                'Attention',
                                'Apakah benar anda akan submit finalisasi JO Inspection ini? pastikan data yg anda  input benar karena jika anda submit, JO  akan dicomplete-kan.',
                                    () => {
                                  controller.submitDocumentInspec(),
                                      Get.back(),
                                      Get.back()
                                    });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: Container(
                              padding:
                              const EdgeInsets.symmetric(vertical: 12),
                              width: double.infinity,
                              child: const Center(
                                  child: Text('Submit',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                              )
                          )
                      ),
                    ],
                  ),
                ) : const SizedBox(),
              ]
            )
            )
          ),
        )
    );
  }
}