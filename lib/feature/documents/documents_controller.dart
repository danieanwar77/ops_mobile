import 'dart:convert';
import 'dart:io';

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

class DocumentsController extends BaseController{

  // Settings
  final picker = ImagePicker();

  RxString documentType = ''.obs;

  // Activities Documents
  late File? sampleFile;
  late File? uploadFile;
  TextEditingController documentCertificateNumber = TextEditingController();
  TextEditingController documentCertificateDate = TextEditingController();
  TextEditingController documentCertificateBlanko = TextEditingController();
  TextEditingController documentCertificateLhv = TextEditingController();
  TextEditingController documentCertificateLs = TextEditingController();
  RxList<Map<String, dynamic>> documents = RxList();
  RxList<List<File>> documentsAttachments = RxList();
  RxList<File> documentAttachments = RxList();

  @override
  void onInit()async{
    var arguments = await Get.arguments;
    documentType.value = arguments['type'] ?? '';
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
      documentCertificateDate.text = DateFormat('yyyy-MM-dd').format(picked).toString();
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
        documentAttachments.add(image);
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
          allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);
      if (attach != null) {
        final List<XFile> xFiles = attach.xFiles;
        xFiles.forEach((data) {
          final fileTemp = File(data!.path);
          final File file = fileTemp;
          documentAttachments.add(file);
          update();
        });
        openDialog('Success', 'Berhasil menambahkan file.');
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Stage Inspection',
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
                                final File photo =
                                documentAttachments.value[index];
                                final String fileType =
                                checkFileType(photo.path);
                                var filenameArr = photo.path.split("/");
                                var filename = filenameArr.last;
                                return fileType == 'image'
                                    ? SizedBox(
                                  width: 54,
                                  height: 54,
                                  child: InkWell(
                                    onTap: () {
                                      previewImage(
                                          index, photo.path, '');
                                    },
                                    child: Image.file(
                                      File(photo.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                                    : fileType == 'doc'
                                    ? InkWell(
                                  onTap: () {
                                    OpenFilex.open(photo.path);
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
                                  mediaPickerConfirm();
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
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
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
                              await addDocuments(type);
                              Get.back();
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Stage Inspection',
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
                                final File photo =
                                documentAttachments.value[index];
                                final String fileType =
                                checkFileType(photo.path);
                                var filenameArr = photo.path.split("/");
                                var filename = filenameArr.last;
                                return fileType == 'image'
                                    ? SizedBox(
                                  width: 54,
                                  height: 54,
                                  child: InkWell(
                                    onTap: () {
                                      previewImage(
                                          index, photo.path, '');
                                    },
                                    child: Image.file(
                                      File(photo.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                                    : fileType == 'doc'
                                    ? InkWell(
                                  onTap: () {
                                    OpenFilex.open(photo.path);
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
                                  mediaPickerConfirm();
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
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
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
                              await addDocuments(documentType.value);
                              Get.back();
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

  Future<void> addDocuments(String type) async {
    if (documentCertificateNumber.text != '' &&
        documentCertificateDate.text != '' &&
        documentCertificateBlanko.text != '' &&
        documentCertificateLhv.text != '' &&
        documentCertificateLs.text != '' &&
        documentAttachments.value.isNotEmpty) {
        documents.value.add(
            <String, String>{
              'certNumber': documentCertificateNumber.value.text,
              'certDate': documentCertificateDate.value.text,
              'certBlanko': documentCertificateBlanko.value.text,
              'certLhv': documentCertificateLhv.value.text,
              'certLs': documentCertificateLs.value.text
            }
        );
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
      documents.value[index] =
          <String, String>{
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
            child: const Text("Close"),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }
}