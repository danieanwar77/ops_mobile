import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/feature/get_data/get_data_controller.dart';

class GetDataScreen extends StatelessWidget{
  const GetDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: GetDataController(),
        builder: (controller) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Ambil Data Harian',
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
                        controller: controller.dateTugas,
                        cursorColor: onFocusColor,
                        style: const TextStyle(color: onFocusColor),
                        onTap: (){
                          //controller.selectDate(Get.context!);
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: (){
                                  //controller.selectDate(Get.context!);
                                },
                                icon: const Icon(Icons.calendar_today_rounded)
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: onFocusColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelText: 'Tanggal Tugas',
                            floatingLabelStyle:
                            const TextStyle(color: onFocusColor),
                            fillColor: onFocusColor),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.black54),
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Row(
                          children: [
                            Text('Koneksi Data :',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black45
                              ),
                            ),
                            SizedBox(width: 8,),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  isExpanded: true,
                                  hint: Text(
                                    'Pilih Koneksi',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  items: controller.items
                                      .map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  })
                                      .toList(),
                                  value: controller.selectedValue.value,
                                  onChanged: (String? value) {
                                    controller.selectedValue.value = value ?? '';
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            controller.getGenData();
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
                                    'Download Data',
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