import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/feature/get_data/get_data_screen.dart';
import 'package:ops_mobile/feature/home/home_screen.dart';
import 'package:ops_mobile/feature/login/login_controller.dart';
import 'package:ops_mobile/feature/settings/settings_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {

  String token = '';
  @override
  void initState() {
    super.initState();
    // nanti aplikasikan di synchronizedata
    /// FCMZEIN START
    // FirebaseMessaging messaging = FirebaseMessaging.instance;
    //
    // messaging.getToken().then((token) => setState(() {
    //   setState(() {
    //     this.token = token.toString();
    //     print('firebase_token ${token}');
    //   });
    // }));
    /// FCMZEIN END
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: LoginController(),
        builder: (controller) => Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Obx(() => Column(
                        children: [
                          const Spacer(),
                          Image.asset(
                            'assets/images/logo.png',
                            height: MediaQuery.sizeOf(context).height / 12,
                          ),
                          const SizedBox(
                            height: 42,
                          ),
                          Row(
                            children: [
                              const Expanded(child:
                                SizedBox()
                              ),
                              InkWell(
                                onTap: (){
                                  Get.to(() => SettingsScreen());
                                },
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                child: Container(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      Text('Setting'),
                                      SizedBox(width: 4,),
                                      Icon(Icons.settings)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            controller: controller.username,
                            cursorColor: onFocusColor,
                            style: const TextStyle(color: onFocusColor),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: onFocusColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                labelText: 'Username',
                                floatingLabelStyle:
                                    const TextStyle(color: onFocusColor),
                                fillColor: onFocusColor),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            controller: controller.password,
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
                          const SizedBox(
                            height: 56,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                // Get.to<void>(() => const HomeScreen());
                                controller.logIn();
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
                          const SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Get.to<void>(const GetDataScreen());
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 0.5, color: primaryColor),
                                      borderRadius: BorderRadius.circular(12))),
                              child: Container(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                                  width: double.infinity,
                                  child: Center(
                                      child: Text(
                                        'Ambil Data',
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )
                                  )
                              )
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }
}
