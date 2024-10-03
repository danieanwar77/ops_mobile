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
                child: Column(
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
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
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text(
                          'Select Item',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: controller.items
                            .map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
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
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () {

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
                                  'Log In',
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
        )
    );
  }
}