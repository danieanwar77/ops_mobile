import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/data/model/t_d_jo_finalize_inspection.dart';
import 'package:ops_mobile/data/model/t_d_jo_finalize_laboratory.dart';
import 'package:ops_mobile/data/sqlite.dart';
import 'package:ops_mobile/data/storage.dart';

class DocumentsController extends BaseController {
  // Settings
  final picker = ImagePicker();

  RxString documentType = ''.obs;
  RxString idJo = ''.obs;
  RxInt statusJo = 0.obs;


  // Activities Documents
  late File? sampleFile;
  late File? uploadFile;
  TextEditingController documentCertificateNumber = TextEditingController();
  TextEditingController documentCertificateDate = TextEditingController();
  TextEditingController documentCertificateBlanko = TextEditingController();
  TextEditingController documentCertificateLhv = TextEditingController();
  TextEditingController documentCertificateLs = TextEditingController();
  RxList<Map<String, dynamic>> documents = RxList();
  RxList<List<String>> documentsAttachments = RxList();
  RxList<String> documentAttachments = RxList();
  final _formKey = GlobalKey<FormState>();
  final _formKeyEdit = GlobalKey<FormState>();

  @override
  void onInit() async {
    update();
    var arguments = await Get.arguments;
    documentType.value = arguments['type'] ?? '';
    idJo.value = arguments['id'] ?? '0';
    statusJo.value = arguments['status'] ?? 0;
    update();
    debugPrint('document type : ${documentType.value}');
    drawerAddDocument(documentType.value);
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 1));
    if (picked != null) {
      documentCertificateDate.text =
          DateFormat('yyyy-MM-dd').format(picked).toString();
    }
  }

  void previewImage(int index, String photo, String desc) async {
    var image = await File(photo);
    Get.dialog(
      GetBuilder(
        init: DocumentsController(),
        builder: (controller) => AlertDialog(
          title: Row(
            children: [
              Text(
                'Photo and Description ${index + 1}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: primaryColor),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.close),
              )
            ],
          ),
          content: SizedBox(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.file(
                    File(image.path),
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(desc),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void cameraImageDocument() async {
    File? image;
    try {
      final XFile? pic = await picker.pickImage(source: ImageSource.camera);
      if (pic != null) {
        final imageTemp = File(pic!.path);
        image = imageTemp;
        documentAttachments.add(image.path);
        update();
      }
    } on PlatformException catch (e) {
      openDialog('Failed', e.message ?? 'Gagal menambahkan file');
    }
    openDialog('Success', 'Berhasil menambahkan file.');
  }

  void fileDocument() async {
    try {
      final FilePickerResult? attach = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          //allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);
          allowedExtensions: ['pdf']);
      if (attach != null) {
        final List<XFile> xFiles = attach.xFiles;
        xFiles.forEach((data) {
          final fileTemp = File(data!.path);
          final File file = fileTemp;
          documentAttachments.add(file.path);
          update();
        });
        //openDialog('Success', 'Berhasil menambahkan file.');
      }
    } on PlatformException catch (e) {
      openDialog('Failed', e.message ?? 'Gagal menambahkan file.');
    }
  }

  String checkFileType(String path) {
    final mimeType = lookupMimeType(path);

    if (mimeType!.startsWith('image/')) {
      return 'image';
    } else if (mimeType == 'application/pdf') {
      return 'doc';
    }
    return 'unsupported';
  }

  void mediaPickerConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'File Attachment',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text('Pilih sumber file yang ingin dilampirkan.'),
        actions: [
          Row(
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 68,
                    height: 67,
                    child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          cameraImageDocument();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: primaryColor),
                                borderRadius: BorderRadius.circular(12))),
                        child: Center(
                            child: Icon(
                          Icons.camera_alt,
                          color: primaryColor,
                        ))),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 68,
                    height: 68,
                    child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          fileDocument();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: primaryColor),
                                borderRadius: BorderRadius.circular(12))),
                        child: Center(
                            child: Icon(
                          Icons.folder_rounded,
                          color: primaryColor,
                        ))),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void drawerAddDocument(String type) {
    Get.bottomSheet(
      GetBuilder(
        init: DocumentsController(),
        builder: (controller) => Container(
            margin: EdgeInsets.only(top: 48),
            padding: EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24),
                    topLeft: Radius.circular(24))),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                        child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Document ${documentType.value == 'inspect' ? 'Inspection' : 'Laboratory'}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: primaryColor),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: documentCertificateNumber,
                            cursorColor: onFocusColor,
                            style: const TextStyle(color: onFocusColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field wajib diisi!';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: onFocusColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                labelText: 'No Certificate/Report*',
                                floatingLabelStyle:
                                    const TextStyle(color: onFocusColor),
                                fillColor: onFocusColor),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            showCursor: true,
                            readOnly: true,
                            controller: documentCertificateDate,
                            cursorColor: onFocusColor,
                            onTap: () {
                              selectDate(Get.context!);
                            },
                            style: const TextStyle(color: onFocusColor),
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      selectDate(Get.context!);
                                    },
                                    icon: const Icon(
                                        Icons.calendar_today_rounded)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: onFocusColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                labelText: 'Date Certificate/Report*',
                                floatingLabelStyle:
                                    const TextStyle(color: onFocusColor),
                                fillColor: onFocusColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field wajib diisi!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: documentCertificateBlanko,
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
                                labelText: 'No Blanko Certificate*',
                                floatingLabelStyle:
                                    const TextStyle(color: onFocusColor),
                                fillColor: onFocusColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field wajib diisi!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: documentCertificateLhv,
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
                                labelText: 'LHV Number*',
                                floatingLabelStyle:
                                    const TextStyle(color: onFocusColor),
                                fillColor: onFocusColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field wajib diisi!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: documentCertificateLs,
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
                                labelText: 'LS Number*',
                                floatingLabelStyle:
                                    const TextStyle(color: onFocusColor),
                                fillColor: onFocusColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field wajib diisi!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'Upload Attachment Certificate',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Note: PDF Only. Max 1 file. Max 2 MB',
                            style: TextStyle(fontSize: 10, color: Colors.green),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          documentAttachments.value.isNotEmpty
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                  ),
                                  itemCount: documentAttachments.value.length,
                                  itemBuilder: (content, index) {
                                    final String photo =
                                        documentAttachments.value[index];
                                    final String fileType =
                                        checkFileType(photo);
                                    var filenameArr = photo.split("/");
                                    var filename = filenameArr.last;
                                    return fileType == 'image'
                                        ? Stack(
                                          children: [
                                            SizedBox(
                                              width: 54,
                                              height: 54,
                                              child: InkWell(
                                                onTap: () {
                                                  previewImage(
                                                      index, photo, '');
                                                },
                                                child: Image.file(
                                                  File(photo),
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
                                                      controller.removeFiles(index);
                                                    },
                                                    icon: Icon(Icons.remove_circle,
                                                      size: 12,
                                                      color: Colors.red,
                                                    )
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                        : fileType == 'doc'
                                            ? Stack(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    OpenFilex.open(photo);
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
                                                        Text(filename,
                                                            style: TextStyle(
                                                                fontSize: 8),
                                                            overflow: TextOverflow
                                                                .ellipsis)
                                                      ],
                                                    )),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: AlignmentDirectional.topEnd,
                                                  child: SizedBox(
                                                    height: 12,
                                                    child: IconButton(
                                                        padding: EdgeInsets.zero,
                                                        onPressed: (){
                                                          controller.removeFiles(index);
                                                        },
                                                        icon: Icon(Icons.remove_circle,
                                                          size: 12,
                                                          color: Colors.red,
                                                        )
                                                    ),
                                                  ),
                                                ),
                                              ]
                                            )
                                            : SizedBox();
                                  })
                              : const SizedBox(),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width: 68,
                            height: 68,
                            child: ElevatedButton(
                                onPressed: () {
                                  fileDocument();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: primaryColor),
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                child: Center(
                                    child: Icon(
                                  Icons.folder_rounded,
                                  color: primaryColor,
                                ))),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    )),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              clearDocumentForm();
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: primaryColor),
                                    borderRadius: BorderRadius.circular(12))),
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                width: double.infinity,
                                child: Center(
                                    child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )))),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () async {
                              debugPrint('form key ${_formKey.currentState}');
                              if (_formKey.currentState!.validate()) {
                                await addDocuments(type);
                                Get.back();
                              }
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
                                    child: Text(
                                  'Add',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )))),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            )),
      ),
      isScrollControlled: true,
    );
  }

  void drawerEditDocument(int index) {
    documentCertificateNumber.text = documents.value[index]['certNumber'];
    documentCertificateDate.text = documents.value[index]['certDate'];
    documentCertificateBlanko.text = documents.value[index]['certBlanko'];
    documentCertificateLhv.text = documents.value[index]['certLhv'];
    documentCertificateLs.text = documents.value[index]['certLs'];
    documentAttachments.value = documentsAttachments[index];
    Get.bottomSheet(
      GetBuilder(
        init: DocumentsController(),
        builder: (controller) => Container(
            margin: EdgeInsets.only(top: 48),
            padding: EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24),
                    topLeft: Radius.circular(24))),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                        child: Form(
                      key: _formKeyEdit,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edit Document ${documentType.value == 'inspect' ? 'Inspection' : 'Laboratory'}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: primaryColor),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: documentCertificateNumber,
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
                                labelText: 'No Certificate/Report*',
                                floatingLabelStyle:
                                    const TextStyle(color: onFocusColor),
                                fillColor: onFocusColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field wajib diisi!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            showCursor: true,
                            readOnly: true,
                            controller: documentCertificateDate,
                            cursorColor: onFocusColor,
                            onTap: () {
                              selectDate(Get.context!);
                            },
                            style: const TextStyle(color: onFocusColor),
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      selectDate(Get.context!);
                                    },
                                    icon: const Icon(
                                        Icons.calendar_today_rounded)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: onFocusColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                labelText: 'Date Certificate/Report*',
                                floatingLabelStyle:
                                    const TextStyle(color: onFocusColor),
                                fillColor: onFocusColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field wajib diisi!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: documentCertificateBlanko,
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
                                labelText: 'No Blanko Certificate*',
                                floatingLabelStyle:
                                    const TextStyle(color: onFocusColor),
                                fillColor: onFocusColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field wajib diisi!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: documentCertificateLhv,
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
                                labelText: 'LHV Number*',
                                floatingLabelStyle:
                                    const TextStyle(color: onFocusColor),
                                fillColor: onFocusColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field wajib diisi!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: documentCertificateLs,
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
                                labelText: 'LS Number*',
                                floatingLabelStyle:
                                    const TextStyle(color: onFocusColor),
                                fillColor: onFocusColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field wajib diisi!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'Upload Attachment Certificate',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Note: PDF Only. Max 1 file. Max 2 MB',
                            style: TextStyle(fontSize: 10, color: Colors.green),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          documentAttachments.value.isNotEmpty
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                  ),
                                  itemCount: documentAttachments.value.length,
                                  itemBuilder: (content, index) {
                                    final String photo =
                                        documentAttachments.value[index];
                                    final String fileType =
                                        checkFileType(photo);
                                    var filenameArr = photo.split("/");
                                    var filename = filenameArr.last;
                                    return fileType == 'image'
                                        ? Stack(
                                          children: [
                                            SizedBox(
                                              width: 54,
                                              height: 54,
                                              child: InkWell(
                                                onTap: () {
                                                  previewImage(
                                                      index, photo, '');
                                                },
                                                child: Image.file(
                                                  File(photo),
                                                  fit: BoxFit.cover,
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
                                                      controller.removeFiles(index);
                                                    },
                                                    icon: Icon(Icons.remove_circle,
                                                      size: 12,
                                                      color: Colors.red,
                                                    )
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                        : fileType == 'doc'
                                            ? Stack(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    OpenFilex.open(photo);
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
                                                        Text(filename,
                                                            style: TextStyle(
                                                                fontSize: 8),
                                                            overflow: TextOverflow
                                                                .ellipsis)
                                                      ],
                                                    )),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: AlignmentDirectional.topEnd,
                                                  child: SizedBox(
                                                    height: 12,
                                                    child: IconButton(
                                                        padding: EdgeInsets.zero,
                                                        onPressed: (){
                                                          controller.removeFiles(index);
                                                        },
                                                        icon: Icon(Icons.remove_circle,
                                                          size: 12,
                                                          color: Colors.red,
                                                        )
                                                    ),
                                                  ),
                                                ),
                                              ]
                                            )
                                            : SizedBox();
                                  })
                              : const SizedBox(),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width: 68,
                            height: 68,
                            child: ElevatedButton(
                                onPressed: () {
                                  fileDocument();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: primaryColor),
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                child: Center(
                                    child: Icon(
                                  Icons.folder_rounded,
                                  color: primaryColor,
                                ))),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    )),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              clearDocumentForm();
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: primaryColor),
                                    borderRadius: BorderRadius.circular(12))),
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                width: double.infinity,
                                child: Center(
                                    child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )))),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () async {
                              if (_formKeyEdit.currentState!.validate()) {
                                debugPrint('State ${documentType.value}');
                                // await addDocuments(documentType.value);
                                await editDocuments(index);
                                Get.back();
                              }
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
                                    child: Text(
                                  'Edit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )))),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            )),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> addDocuments(String type) async {
    if (documentCertificateNumber.text != '' &&
        documentCertificateDate.text != '' &&
        documentCertificateBlanko.text != '' &&
        documentCertificateLhv.text != '' &&
        documentCertificateLs.text != '' &&
        documentAttachments.value.isNotEmpty) {
      documents.value.add(<String, String>{
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'certNumber': documentCertificateNumber.value.text,
        'certDate': documentCertificateDate.value.text,
        'certBlanko': documentCertificateBlanko.value.text,
        'certLhv': documentCertificateLhv.value.text,
        'certLs': documentCertificateLs.value.text
      });
      documentsAttachments.value.add(documentAttachments.value);
    }
    documentAttachments.value = [];
    documentCertificateNumber.text = '';
    documentCertificateDate.text = '';
    documentCertificateBlanko.text = '';
    documentCertificateLhv.text = '';
    documentCertificateLs.text = '';
    update();
    debugPrint('documents : ${jsonEncode(documents.value)}');
  }

  Future<void> editDocuments(int index) async {
    if (documentCertificateNumber.text != '' &&
        documentCertificateDate.text != '' &&
        documentCertificateBlanko.text != '' &&
        documentCertificateLhv.text != '' &&
        documentCertificateLs.text != '' &&
        documentAttachments.value.isNotEmpty) {
      documents.value[index] = <String, String>{
        'certNumber': documentCertificateNumber.value.text,
        'certDate': documentCertificateDate.value.text,
        'certBlanko': documentCertificateBlanko.value.text,
        'certLhv': documentCertificateLhv.value.text,
        'certLs': documentCertificateLs.value.text
      };
      documentsAttachments.value[index] = documentAttachments.value;
    }
    documentAttachments.value = [];
    documentCertificateNumber.text = '';
    documentCertificateDate.text = '';
    documentCertificateBlanko.text = '';
    documentCertificateLhv.text = '';
    documentCertificateLs.text = '';
    update();
    debugPrint('documents : ${jsonEncode(documents.value)}');
  }

  Future<void> deleteDocumentUI(String id) async {
    // documents  remove by id
    documents.removeWhere((document) => document['id'] == id);
    update();
  }

  Future<void> editListDocument(int index) async {
    if (documentCertificateNumber.text != '' &&
        documentCertificateDate.text != '' &&
        documentCertificateBlanko.text != '' &&
        documentCertificateLhv.text != '' &&
        documentCertificateLs.text != '' &&
        documentAttachments.value.isNotEmpty) {
      documents.value[index] = {
        'id': documents.value[index]['id'], // mempertahankan id yang ada
        'certNumber': documentCertificateNumber.value.text,
        'certDate': documentCertificateDate.value.text,
        'certBlanko': documentCertificateBlanko.value.text,
        'certLhv': documentCertificateLhv.value.text,
        'certLs': documentCertificateLs.value.text
      };
      documentsAttachments.value[index] = documentAttachments.value;
      // cari document berdasarkan index. ubah value certnumber sampai certls
      // documents.value.add(
      //   <String, String>{
      //     'id': DateTime.now().millisecondsSinceEpoch.toString(),
      //     'certNumber': documentCertificateNumber.value.text,
      //     'certDate': documentCertificateDate.value.text,
      //     'certBlanko': documentCertificateBlanko.value.text,
      //     'certLhv': documentCertificateLhv.value.text,
      //     'certLs': documentCertificateLs.value.text
      //   }
      // );
      // documentsAttachments.value.add(documentAttachments.value);
    }
    documentAttachments.value = [];
    documentCertificateNumber.text = '';
    documentCertificateDate.text = '';
    documentCertificateBlanko.text = '';
    documentCertificateLhv.text = '';
    documentCertificateLs.text = '';
    update();
  }
  
  void clearDocumentForm(){
    documentAttachments.value = [];
    documentCertificateNumber.text = '';
    documentCertificateDate.text = '';
    documentCertificateBlanko.text = '';
    documentCertificateLhv.text = '';
    documentCertificateLs.text = '';
    update();
  }

  void addDocumentConfirm(String type) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text(
            'Apakah benar anda akan submit finalisasi JO Inspection ini? pastikan data yg anda input benar karena jika anda submit, JO akan dicomplete-kan.'),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text(
              "OK",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              Get.back();
              Get.back();
              //await addDocuments(type);
            },
          ),
        ],
      ),
    );
  }

  void previewImageList(int index, String photo) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Text(
              'Attachment ${index + 1}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: primaryColor),
            ),
            InkWell(
              onTap: () {},
              child: Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.close),
            )
          ],
        ),
        content: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(
                File(photo),
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        actions: [],
      ),
    );
  }

  void removeFiles(int index) {
    debugPrint('documents attach before remove : ${jsonEncode(documentsAttachments.value)}');
    debugPrint('document attach before remove : ${jsonEncode(documentAttachments.value)}');
    documentAttachments.value.removeAt(index);
    update();
    debugPrint('documents attach after remove : ${jsonEncode(documentsAttachments.value)}');
    debugPrint('document attach after remove : ${jsonEncode(documentAttachments.value)}');
  }

  void openDialog(String type, String text) {
    Get.dialog(
      AlertDialog(
        title: Text(
          type,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text(text),
        actions: [
          TextButton(
            child: const Text("Ok"),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  void openDialogV2(String type, String text, VoidCallback callback) {
    Get.dialog(
      AlertDialog(
        title: Text(
          type,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
        ),
        content: Text(text),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text(
              "Ok",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: callback,
          ),
        ],
      ),
    );
  }

  Future<void> submitDocumentInspec() async {
    var dataUser = await StorageCore().storage.read('user');
    debugPrint("submit login ${jsonDecode(dataUser)}");
    var employee = jsonDecode(dataUser);
    var employeeId = employee.first['id'];
    //submit login [{id: 624, password_aes: 1nSpPO+ndJ8m4n8f3fOscA==}]
    debugPrint('Submit Document Inspection ${employeeId}');
    //RxList<Map<String, dynamic>> documents = RxList();
    //berdasarkan list document dimana isi id,name,
    /**
     * 'id': documents.value[index]['id'], // mempertahankan id yang ada
        'certNumber': documentCertificateNumber.value.text,
        'certDate': documentCertificateDate.value.text,
        'certBlanko': documentCertificateBlanko.value.text,
        'certLhv': documentCertificateLhv.value.text,
        'certLs': documentCertificateLs.value.text
     */
    final db = await SqlHelper.db();
    // DocumentModel doc = DocumentModel(
    //   id: document['id'],
    //   certNumber: document['certNumber'],
    //   certDate: document['certDate'],
    //   certBlanko: document['certBlanko'],
    //   certLhv: document['certLhv'],
    //   certLs: document['certLs'],
    // );

    // Loop melalui dokumen dan simpan ke SQLite
    late TDJoFinalizeInspection tdJoDocumentInspect;
    late TDJoFinalizeLaboratory tdJoDocumentLab;

    for (var document in documents.value) {
      if(documentType.value == 'inspect') {
        tdJoDocumentInspect = TDJoFinalizeInspection(
          tHJoId: int.parse(idJo.value),
          noReport: document['certNumber'],
          dateReport: document['certDate'],
          noBlankoCertificate: document['certBlanko'],
          lhvNumber: document['certLhv'],
          lsNumber: document['certLs'],
          code: "JDOI-${employeeId}-${DateTime
              .now()
              .millisecondsSinceEpoch
              .toString()}",
          isActive: 1,
          isUpload: 0,
          createdBy: employeeId,
          createdAt: DateTime.now().toString(),
          updatedBy: 0,
          updatedAt: '',
        );
        update();
        debugPrint('document details: ${jsonEncode(tdJoDocumentInspect)}');
      } else {
        tdJoDocumentLab = TDJoFinalizeLaboratory(
            tDJoLabId: int.parse(idJo.value),
            noReport: document['certNumber'],
            dateReport: document['certDate'],
            noBlankoCertificate: document['certBlanko'],
            lhvNumber: document['certLhv'],
            lsNumber: document['certLs'],
            pathPdf: '-',
            code: "JDOI-${employeeId}-${DateTime
                .now()
                .millisecondsSinceEpoch
                .toString()}",
            isActive: 1,
            isUpload: 0,
            createdBy: employeeId,
            createdAt: DateTime.now().toString(),
            updatedBy: 0,
            updatedAt: ''
        );
        update();
        debugPrint('document details: ${jsonEncode(tdJoDocumentLab)}');
      }


      // Menyimpan dokumen ke SQLite
      if(documentType.value == 'inspect') {
        await db.insert(
            't_d_jo_finalize_inspection',  // Nama tabel
            tdJoDocumentInspect.toJson()
        );


      } else {
        await db.insert(
            't_d_jo_finalize_laboratory',  // Nama tabel
            tdJoDocumentLab.toJson()
        );
      }
    }
    // Get.back();
    // Get.back();
  }

  Future<void> sendDocuments() async {

  }
}
