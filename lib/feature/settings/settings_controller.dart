import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';

class SettingsController extends BaseController{

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  RxBool obsecure = true.obs;
  bool isLoading = false;

  @override
  void onInit()async{
    Future.delayed(Duration(milliseconds: 500),(){
      drawerAddDocument();
    });
  }

  void drawerAddDocument(){
    Get.bottomSheet(
      GetBuilder(
        init:SettingsController(),
        builder: (controller) => Container(
                padding: EdgeInsets.all(24),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24))
                ),
                child: Obx(() => Column(
                  children: [
                    const SizedBox(
                      height: 48,
                    ),
                    TextFormField(
                      controller: password,
                      obscureText: controller.obsecure.value,
                      cursorColor: onFocusColor,
                      style: const TextStyle(color: onFocusColor),
                      decoration: InputDecoration(
                          prefixIcon:
                          const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                              onPressed: (){
                                controller.obsecure.value = !controller.obsecure.value;
                              },
                              icon: controller.obsecure.value ? Icon(Icons.visibility_off) : Icon(Icons.visibility)
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: onFocusColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelText: 'Password',
                          floatingLabelStyle:
                          const TextStyle(color: onFocusColor),
                          fillColor: onFocusColor),
                    ),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () async {
                          bool loginAdmin = await loginAdminSetting(password.text);
                          if(loginAdmin == true){
                            Get.back();
                            openDialog("Success", "Berhasil login admin.");
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
                                child: controller.isLoading == true ? CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ) : Text(
                                  'Log In',
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
            ),
            )
        ),
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
    );
  }

  Future<bool> loginAdminSetting(String password) async{
    if(password == 'admin'){
      return true;
    } else {
      openDialog("Failed", "Password salah.");
      return false;
    }
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

  void deleteSettingsConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text('Attention',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor
          ),
        ),
        content: Text('Apakah benar anda ingin menghapus data setting di device ini?'),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text("OK",
              style: TextStyle(
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              Get.back();
              // var result = await addDocuments(type);
              // if(result == 'success'){
              //   Get.back();
              //   openDialog("Success", "Finalisasi JO berhasil ditambahkan");
              // } else {
              //   Get.back();
              //   openDialog("Failed", "Finalisasi JO masih kosong atau belum diinput");
              // }
            },
          ),
        ],
      ),
    );
  }
}