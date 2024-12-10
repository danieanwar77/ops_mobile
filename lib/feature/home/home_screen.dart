import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ops_mobile/core/core/constant/colors.dart';
import 'package:ops_mobile/feature/assigned/assigned_screen.dart';
import 'package:ops_mobile/feature/home/home_controller.dart';
import 'package:ops_mobile/feature/notifications/notifications_screen.dart';
import 'package:ops_mobile/feature/send_manual/send_manual_screen.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context){
    return GetBuilder(
        init: HomeController(),
        builder: (controller) => Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height / 3,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                        Color(0xff324185),
                        Color(0xff31AABD)
                        ]
                    )
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap:(){
                                    controller.versionSyncDialog();
                                  },
                                  child: CircleAvatar(
                                    radius: 32,
                                    child: Image.asset('assets/icons/user.png'),
                                  ),
                                ),
                                const SizedBox(width: 18,),
                                Obx(()=> Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(controller.userData.value?.fullname ?? '-',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                            ),
                                          ),
                                          Text(controller.userData.value?.position ?? '-',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                            ),
                                          )
                                        ],
                                      )
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Get.to<void>(() => const NotificationsScreen())?.then((_) async{
                                      await controller.countNotif();
                                    });
                                  },
                                  icon: Stack(
                                    alignment: Alignment.center, // Menempatkan angka di tengah ikon
                                    children: [
                                      const Icon(Icons.notifications, color: Colors.white), // Ikon dasar
                                      controller.message == 0 ? const SizedBox() : Positioned(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red, // Warna latar belakang angka
                                            shape: BoxShape.circle, // Membuat angka dalam lingkaran
                                          ),
                                          padding: const EdgeInsets.all(3), // Padding untuk angka
                                          child: Text(
                                            controller.message.string, // Jumlah notifikasi
                                            style: TextStyle(
                                              color: Colors.white, // Warna teks
                                              fontSize:8, // Ukuran font angka
                                              fontWeight: FontWeight.bold, // Tebal teks
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: (){
                                      controller.logOutConfirm();
                                    },
                                    icon: const Icon(Icons.logout_sharp, color: Colors.white)
                                )
                              ],
                            ),
                            const SizedBox(height: 24,),
                            Obx(() => Text('Welcome ${controller.userData.value?.fullname ?? '-'}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50)
                          )
                        ),
                        child:
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24,),
                              const Text('Home',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 24,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: (MediaQuery.sizeOf(context).width / 3) - 36,
                                      child: InkWell(
                                        onTap: (){
                                          Get.to<void>(() => const AssignedScreen(), arguments: {'status': 2, 'employeeId' : controller.userData.value?.id ?? 0})?.then((_) async{
                                            controller.syncMaster();
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(bottom: 8),
                                              padding: const EdgeInsets.all(8),
                                              width: 64,
                                              height: 64,
                                              decoration: BoxDecoration(
                                                color: menuButtonColor,
                                                borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: Image.asset('assets/icons/assigned.png'),
                                            ),
                                            const Text('JO Assigned',
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      width: (MediaQuery.sizeOf(context).width / 3) - 32,
                                      child: InkWell(
                                        onTap: (){
                                          Get.to<void>(() => const AssignedScreen(), arguments: {'status': 3, 'employeeId': controller.userData.value?.id ?? 0})?.then((_) async{
                                            controller.syncMaster();
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(bottom: 8),
                                              padding: const EdgeInsets.all(8),
                                              width: 64,
                                              height: 64,
                                              decoration: BoxDecoration(
                                                  color: menuButtonColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: Image.asset('assets/icons/onprogress.png'),
                                            ),
                                            const Text('JO On Progress',
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      width: (MediaQuery.sizeOf(context).width / 3) - 36,
                                      child: InkWell(
                                        onTap: (){
                                          Get.to<void>(() => const AssignedScreen(), arguments: {'status': 4, 'employeeId' : controller.userData.value?.id ?? 0})?.then((_) async{
                                            controller.syncMaster();
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(bottom: 8),
                                              padding: const EdgeInsets.all(8),
                                              width: 64,
                                              height: 64,
                                              decoration: BoxDecoration(
                                                  color: menuButtonColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: Image.asset('assets/icons/approval.png'),
                                            ),
                                            const Text('JO Waiting\nApproval Client',
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: (MediaQuery.sizeOf(context).width / 3) - 36,
                                      child: InkWell(
                                        onTap: (){
                                          Get.to<void>(() => const AssignedScreen(), arguments: {'status': 6, 'employeeId' : controller.userData.value?.id ?? 0})?.then((_) async{
                                            controller.syncMaster();
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(bottom: 8),
                                              padding: const EdgeInsets.all(8),
                                              width: 64,
                                              height: 64,
                                              decoration: BoxDecoration(
                                                  color: menuButtonColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: Image.asset('assets/icons/waiting.png'),
                                            ),
                                            const Text('JO Waiting for\nCancellation',
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      width: (MediaQuery.sizeOf(context).width / 3) - 32,
                                      child: InkWell(
                                        onTap: (){
                                          Get.to<void>(() => const AssignedScreen(), arguments: {'status': 5, 'employeeId' : controller.userData.value?.id ?? 0})?.then((_) async{
                                            controller.syncMaster();
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(bottom: 8),
                                              padding: const EdgeInsets.all(8),
                                              width: 64,
                                              height: 64,
                                              decoration: BoxDecoration(
                                                  color: menuButtonColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: Image.asset('assets/icons/completed.png'),
                                            ),
                                            const Text('JO Completed',
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      width: (MediaQuery.sizeOf(context).width / 3) - 36,
                                      child: InkWell(
                                        onTap: (){
                                          Get.to<void>(() => const AssignedScreen(), arguments: {'status': 7, 'employeeId' : controller.userData.value?.id ?? 0})?.then((_) async{
                                            controller.syncMaster();
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(bottom: 8),
                                              padding: const EdgeInsets.all(8),
                                              width: 64,
                                              height: 64,
                                              decoration: BoxDecoration(
                                                  color: menuButtonColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: Image.asset('assets/icons/canceled.png'),
                                            ),
                                            const Text('JO Canceled',
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: (MediaQuery.sizeOf(context).width / 3) - 36,
                                      child: InkWell(
                                        onTap: (){
                                          Get.to<void>(() => const SendManualScreen());
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(bottom: 8),
                                              padding: const EdgeInsets.all(8),
                                              width: 64,
                                              height: 64,
                                              decoration: BoxDecoration(
                                                  color: menuButtonColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: Image.asset('assets/icons/manual.png'),
                                            ),
                                            const Text('Send Manual',
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24,),
                            ],
                          ),
                        ),
                      ),
                      CarouselSlider(
                        options: CarouselOptions(
                            height: 200,
                          onPageChanged: (index, reason) {
                            controller.changeSliderIndex(index);
                          }
                        ),
                        items: controller.item.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.asset('assets/images/slide.png',fit: BoxFit.cover,)
                              );
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16,),
                      DotsIndicator(
                        dotsCount: controller.item.length,
                        position: controller.indexItem,
                        decorator: const DotsDecorator(
                          color: unselectedColor, // Inactive color
                          activeColor: onFocusColor,
                        ),
                      ),
                      const SizedBox(height: 48,)
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}