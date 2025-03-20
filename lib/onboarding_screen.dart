// ignore_for_file: avoid_unnecessary_containers, avoid_print, prefer_const_constructors, prefer_final_fields, non_constant_identifier_names, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/splash_screen.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/textfont.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final storage = GetStorage();
  final controller = OnboardingData();
  final pageController = PageController();

  // ✅ Permission Status Variables
  PermissionStatus _notiStatus = PermissionStatus.denied;
  PermissionStatus _locationStatus = PermissionStatus.denied;
  PermissionStatus _cameraStatus = PermissionStatus.denied;
  PermissionStatus _contactStatus = PermissionStatus.denied;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Get.put(HomeController());
    storage.write('chkNoti', false);
    storage.write('chkLocation', false);
    storage.write('chkCamera', false);
    storage.write('chkContact', false);
    _chkPermision();
  }

  Future<void> _chkPermision() async {
    _notiStatus = await Permission.notification.status;
    _cameraStatus = await Permission.camera.status;
    _locationStatus = await Permission.location.status;
    _contactStatus = await Permission.contacts.status;

    setState(() {}); // ✅ Refresh UI after checking permissions
  }

  Future<void> _getStarted() async {
    storage.write("onboarding", true);
    Get.offAll(SplashScreen());
  }

  void _updatePermission() async {
    if (currentIndex < controller.items.length - 1) {
      await _reqPermission(currentIndex);
      setState(() {
        currentIndex++;
        pageController.animateToPage(
          currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    } else {
      _getStarted();
    }
  }

  Future<void> _reqPermission(int id) async {
    PermissionStatus status;
    switch (id) {
      case 0:
        status = await Permission.notification.request();
        storage.write('chkNoti', status.isGranted);
        break;
      case 1:
        status = await Permission.location.request();
        storage.write('chkLocation', status.isGranted);
        break;
      case 2:
        status = await Permission.camera.request();
        storage.write('chkCamera', status.isGranted);
        break;
      case 3:
        status = await Permission.contacts.request();
        storage.write('chkContact', status.isGranted);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            appbarLang(),
            Expanded(child: buildPageView()),
            buildDots(),
            buildButton(),
          ],
        ),
      ),
    );
  }

  Widget appbarLang() {
    return Container(
      padding: EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              if (storage.read('lang_id') != null && storage.read('lang_flat') != null) {
                // Get.to(() => Language());
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
              decoration: ShapeDecoration(
                color: Colors.black.withOpacity(0.05),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: storage.read('lang_id') == null && storage.read('lang_flat') == null
                  ? SizedBox(height: 6.w, width: 6.w)
                  : Row(
                      children: [
                        SizedBox(
                          height: 6.w,
                          width: 6.w,
                          child: SvgPicture.asset(storage.read('lang_flat')),
                        ),
                        SizedBox(width: 6),
                        TextFont(
                          text: storage.read('lang_id').toString().toUpperCase() == 'LO'
                              ? 'LA'
                              : storage.read('lang_id').toString().toUpperCase(),
                          poppin: true,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPageView() {
    return PageView.builder(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(), // ✅ Prevents user from skipping screens manually
      itemCount: controller.items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 5.h),
              SvgPicture.asset(
                controller.items[index].image,
                width: 80.w,
                height: 23.h,
              ),
              SizedBox(height: 15.sp),
              TextFont(
                text: controller.items[index].title,
                color: color_ed1,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextFont(
                  text: controller.items[index].description,
                  color: color_2d3,
                  fontSize: 10,
                  maxLines: 15,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildDots() {
    return Column(
      children: [
        TextFont(
          text: '${currentIndex + 1}/${controller.items.length}',
          color: color_999,
          poppin: true,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            controller.items.length,
            (index) => AnimatedContainer(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: currentIndex == index ? color_ed1 : Colors.grey,
              ),
              height: currentIndex == index ? 10 : 7,
              width: currentIndex == index ? 35 : 7,
              duration: const Duration(milliseconds: 500),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        width: Get.width * .9,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: currentIndex == controller.items.length - 1 ? color_ed1 : color_999,
        ),
        child: TextButton(
          onPressed: _updatePermission,
          child: TextFont(
            text: currentIndex == controller.items.length - 1 ? "Get started" : "Next",
            color: color_fff,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class OnboardingData {
  List<OnboardingInfo> items = [
    OnboardingInfo(
      title: "Notification",
      description: "consent_noti",
      image: "assets/boarding/noti.svg",
    ),
    OnboardingInfo(
      title: "Location Information",
      description: "consent_location",
      image: "assets/boarding/location.svg",
    ),
    OnboardingInfo(
      title: "Camera and Photos",
      description: "consent_camera",
      image: "assets/boarding/camera_qr.svg",
    ),
    OnboardingInfo(
      title: "Contact List",
      description: "consent_contact",
      image: "assets/boarding/contact.svg",
    ),
    OnboardingInfo(
      title: "You're ready to go!",
      description: "consent_start",
      image: "assets/boarding/start.svg",
    ),
  ];
}

class OnboardingInfo {
  final String title;
  final String description;
  final String image;

  OnboardingInfo({
    required this.title,
    required this.description,
    required this.image,
  });
}

// // ignore_for_file: avoid_unnecessary_containers, avoid_print, prefer_const_constructors, prefer_final_fields, non_constant_identifier_names, unused_field

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:sizer/sizer.dart';
// import 'package:super_app/controllers/home_controller.dart';
// import 'package:super_app/splash_screen.dart';
// import 'package:super_app/utility/color.dart';
// import 'package:super_app/widget/textfont.dart';

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final storage = GetStorage();
//   final controller = OnboardingData();
//   final pageController = PageController();

//   // ✅ Permission Status Variables
//   PermissionStatus _notiStatus = PermissionStatus.denied;
//   PermissionStatus _locationStatus = PermissionStatus.denied;
//   PermissionStatus _cameraStatus = PermissionStatus.denied;
//   PermissionStatus _contactStatus = PermissionStatus.denied;

//   int currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     Get.put(HomeController());
//     _chkPermission();
//   }

//   /// ✅ **Check All Permissions on App Start**
//   Future<void> _chkPermission() async {
//     _notiStatus = await Permission.notification.status;
//     _cameraStatus = await Permission.camera.status;
//     _locationStatus = await Permission.location.status;
//     _contactStatus = await Permission.contacts.status;

//     // ✅ Handle permanently denied permissions (Redirect to Settings)
//     if (_notiStatus.isPermanentlyDenied ||
//         _cameraStatus.isPermanentlyDenied ||
//         _locationStatus.isPermanentlyDenied ||
//         _contactStatus.isPermanentlyDenied) {
//       openAppSettings();
//     }

//     setState(() {}); // ✅ Refresh UI
//   }

//   Future<void> _getStarted() async {
//     storage.write("onboarding", true);
//     Get.offAll(SplashScreen());
//   }

//   /// ✅ **Request Permission & Move to Next Page**
//   void _updatePermission() async {
//     if (currentIndex < controller.items.length - 1) {
//       await _reqPermission(currentIndex);
//       setState(() {
//         currentIndex++;
//         pageController.animateToPage(
//           currentIndex,
//           duration: Duration(milliseconds: 500),
//           curve: Curves.easeInOut,
//         );
//       });
//     } else {
//       _getStarted();
//     }
//   }

//   /// ✅ **Request Specific Permission**
//   Future<void> _reqPermission(int id) async {
//     PermissionStatus status;
//     switch (id) {
//       case 0:
//         status = await Permission.notification.request();
//         break;
//       case 1:
//         status = await Permission.location.request();
//         break;
//       case 2:
//         status = await Permission.camera.request();
//         break;
//       case 3:
//         status = await Permission.contacts.request();
//         break;
//       default:
//         return;
//     }

//     // ✅ Handle permanently denied permissions (Redirect to Settings)
//     if (status.isPermanentlyDenied) {
//       openAppSettings();
//     }

//     // ✅ Save permission status
//     storage.write(_getStorageKey(id), status.isGranted);
//   }

//   /// ✅ **Helper Function for Storage Key**
//   String _getStorageKey(int id) {
//     switch (id) {
//       case 0:
//         return 'chkNoti';
//       case 1:
//         return 'chkLocation';
//       case 2:
//         return 'chkCamera';
//       case 3:
//         return 'chkContact';
//       default:
//         return '';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             appbarLang(),
//             Expanded(child: buildPageView()),
//             buildDots(),
//             buildButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget appbarLang() {
//     return Container(
//       padding: EdgeInsets.only(right: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           InkWell(
//             onTap: () {
//               if (storage.read('lang_id') != null && storage.read('lang_flat') != null) {
//                 // Get.to(() => Language());
//               }
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
//               decoration: ShapeDecoration(
//                 color: Colors.black.withOpacity(0.05),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//               ),
//               child: storage.read('lang_id') == null && storage.read('lang_flat') == null
//                   ? SizedBox(height: 6.w, width: 6.w)
//                   : Row(
//                       children: [
//                         SizedBox(
//                           height: 6.w,
//                           width: 6.w,
//                           child: SvgPicture.asset(storage.read('lang_flat')),
//                         ),
//                         SizedBox(width: 6),
//                         TextFont(
//                           text: storage.read('lang_id').toString().toUpperCase() == 'LO'
//                               ? 'LA'
//                               : storage.read('lang_id').toString().toUpperCase(),
//                           poppin: true,
//                         ),
//                       ],
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildPageView() {
//     return PageView.builder(
//       controller: pageController,
//       physics: NeverScrollableScrollPhysics(), // ✅ Prevents manual skipping
//       itemCount: controller.items.length,
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             children: [
//               SizedBox(height: 5.h),
//               SvgPicture.asset(
//                 controller.items[index].image,
//                 width: 80.w,
//                 height: 23.h,
//               ),
//               SizedBox(height: 15.sp),
//               TextFont(
//                 text: controller.items[index].title,
//                 color: color_ed1,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 textAlign: TextAlign.center,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 25),
//                 child: TextFont(
//                   text: controller.items[index].description,
//                   color: color_2d3,
//                   fontSize: 10,
//                   maxLines: 15,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget buildDots() {
//     return Column(
//       children: [
//         TextFont(
//           text: '${currentIndex + 1}/${controller.items.length}',
//           color: color_999,
//           poppin: true,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(
//             controller.items.length,
//             (index) => AnimatedContainer(
//               margin: const EdgeInsets.symmetric(horizontal: 2),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(50),
//                 color: currentIndex == index ? color_ed1 : Colors.grey,
//               ),
//               height: currentIndex == index ? 10 : 7,
//               width: currentIndex == index ? 35 : 7,
//               duration: const Duration(milliseconds: 500),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildButton() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: Container(
//         width: Get.width * .9,
//         height: 55,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: currentIndex == controller.items.length - 1 ? color_ed1 : color_999,
//         ),
//         child: TextButton(
//           onPressed: _updatePermission,
//           child: TextFont(
//             text: currentIndex == controller.items.length - 1 ? "Get started" : "Next",
//             color: color_fff,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class OnboardingData {
//   List<OnboardingInfo> items = [
//     OnboardingInfo(title: "Notification", description: "consent_noti", image: "assets/boarding/noti.svg"),
//     OnboardingInfo(
//         title: "Location Information", description: "consent_location", image: "assets/boarding/location.svg"),
//     OnboardingInfo(title: "Camera and Photos", description: "consent_camera", image: "assets/boarding/camera_qr.svg"),
//     OnboardingInfo(title: "Contact List", description: "consent_contact", image: "assets/boarding/contact.svg"),
//   ];
// }

// class OnboardingInfo {
//   final String title, description, image;
//   OnboardingInfo({required this.title, required this.description, required this.image});
// }
