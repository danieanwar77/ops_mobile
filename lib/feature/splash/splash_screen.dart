import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:ops_mobile/feature/splash/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SplashController(),
      builder: (controller) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                const Spacer(),
                Image.asset('assets/images/logo.png', height: MediaQuery.sizeOf(context).height / 12,),
                const Spacer(),
                const Text('Powered by Intishaka'),
                Text('Version ${controller.version}'),
                SizedBox(height: MediaQuery.sizeOf(context).height / 8,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
