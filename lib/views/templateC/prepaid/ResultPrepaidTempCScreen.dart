// // ignore_for_file: sort_child_properties_last

// import 'dart:io';

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:keyboard_attachable/keyboard_attachable.dart';
// import 'package:mmoney_lite/controller/temp_c_controller.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pretty_qr_code/pretty_qr_code.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:sizer/sizer.dart';

// import '../../../utility/myconstant.dart';
// import '../../transferWallet/ResultTranferScreen.dart';
// import '../../../utility/colors.dart';
// import '../../../utility/myIcon.dart';
// import '../../../widgets/buildBottomAppbar.dart';
// import '../../../widgets/build_DotLine.dart';
// import '../../../widgets/textfont.dart';
// import '../../../controller/home_controller.dart';
// import '../../../controller/payment_controller.dart';
// import '../../../controller/user_controller.dart';

// class ResultPrepaidTempCScreen extends StatefulWidget {
//   const ResultPrepaidTempCScreen({super.key});

//   @override
//   State<ResultPrepaidTempCScreen> createState() => _ResultPrepaidTempCScreenState();
// }

// class _ResultPrepaidTempCScreenState extends State<ResultPrepaidTempCScreen> {
//   final homeController = Get.find<HomeController>();
//   final userController = Get.find<UserController>();
//   final paymentController = Get.find<PaymentController>();
//   final tempCcontroler = Get.find<TempCController>();
//   final storage = GetStorage();
//   final screenshotController = ScreenshotController();

//   @override
//   void initState() {
//     userController.increasepage();
//     Future.delayed(MyConstant.delayTime).then((_) {
//       _saveScreenshot();
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     userController.decreasepage();
//     super.dispose();
//   }

//   void _takeScreenshot() async {
//     screenshotController.capture().then((value) async {
//       if (value != null) {
//         final directory = await getApplicationDocumentsDirectory();
//         final imagePath = await File('${directory.path}/image.png').create();
//         await imagePath.writeAsBytes(value);
//         await Share.shareXFiles([XFile(imagePath.path)]);
//       }
//     });
//   }

//   _saveScreenshot() async {
//     screenshotController.capture().then((value) async {
//       if (value != null) {
//         final directory = await getApplicationDocumentsDirectory();
//         final imagePath = await File('${directory.path}/${tempCcontroler.rxTransID.value}.png').create();
//         await imagePath.writeAsBytes(value);
//         await GallerySaver.saveImage(imagePath.path);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//         body: Screenshot(
//           controller: screenshotController,
//           child: Container(
//             color: const Color(0xffD2D3D5),
//             child: Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Color(0xe6FFFFFF),
//                     Color(0x80D6D6D8),
//                     Color(0xffB3B5B8),
//                   ],
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   Positioned(
//                     top: 0,
//                     left: 0,
//                     right: 0,
//                     bottom: 0,
//                     child: Opacity(
//                       opacity: 0.4,
//                       child: SvgPicture.asset(
//                         MyIcon.bg_bill,
//                         fit: BoxFit.fitWidth,
//                       ),
//                     ),
//                   ),
//                   FooterLayout(
//                     child: Center(
//                       child: SingleChildScrollView(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             buildTextSuccess(),
//                             const SizedBox(height: 16),
//                             ClipPath(
//                                 clipper: MyCustomClipper(),
//                                 child: Container(
//                                   padding: const EdgeInsets.only(top: 40),
//                                   width: Get.width,
//                                   height: 30,
//                                   margin: const EdgeInsets.symmetric(horizontal: 34),
//                                   decoration: const BoxDecoration(
//                                     color: color_fff,
//                                   ),
//                                 )),
//                             ClipPath(
//                               clipper: TriangleClipper(),
//                               child: Container(
//                                 margin: const EdgeInsets.symmetric(horizontal: 34),
//                                 padding: const EdgeInsets.symmetric(vertical: 10),
//                                 decoration: const BoxDecoration(
//                                   borderRadius: BorderRadius.vertical(bottom: Radius.circular(7.0)),
//                                   color: color_fff,
//                                 ),
//                                 width: Get.width,
//                                 child: Stack(
//                                   alignment: Alignment.center,
//                                   children: [
//                                     Opacity(
//                                       opacity: 0.1,
//                                       child: SvgPicture.asset(
//                                         MyIcon.logox_slip,
//                                         width: 40.w,
//                                       ),
//                                     ),
//                                     Column(
//                                       children: [
//                                         buildHeaderTransID(),
//                                         const buildDotLine(color: color_ddd, dashlenght: 12),
//                                         buildFromAccToAcc(),
//                                         const SizedBox(height: 10),
//                                         buildPaymentAmount(),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                             vertical: 10,
//                                             horizontal: 20,
//                                           ),
//                                           child: TextFont(
//                                             text: tempCcontroler.rxNote.value,
//                                             maxline: 3,
//                                             noto: true,
//                                           ),
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 14),
//                             InkWell(
//                               onTap: () {
//                                 _takeScreenshot();
//                               },
//                               child: Container(
//                                 margin: const EdgeInsets.symmetric(horizontal: 34),
//                                 padding: const EdgeInsets.symmetric(vertical: 12),
//                                 decoration: ShapeDecoration(
//                                   color: Colors.white.withOpacity(0.6),
//                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     TextFont(
//                                       text: 'share',
//                                       color: color_f15,
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                     const SizedBox(width: 10),
//                                     SvgPicture.asset(
//                                       'images/icon/ic_share.svg',
//                                       fit: BoxFit.cover,
//                                       color: color_f15,
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 50),
//                           ],
//                         ),
//                       ),
//                     ),
//                     footer: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 14),
//                       child: buildBottomAppbar(
//                         title: 'close',
//                         bgColor: color_777,
//                         func: () async {
//                           await userController.fetchbalance();
//                           Get.close(userController.pageclose.value);
//                         },
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildTextSuccess() {
//     return SafeArea(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SvgPicture.asset(
//             'images/icon/ic_check.svg',
//             fit: BoxFit.cover,
//             width: 6.w,
//           ),
//           const SizedBox(width: 10),
//           TextFont(
//             text: 'transfer_success',
//             fontWeight: FontWeight.w700,
//             color: color_2d3,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildHeaderTransID() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             child: TextFont(
//               text: tempCcontroler.rxTransID.value,
//               color: color_777,
//               fontSize: 10,
//               poppin: true,
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextFont(
//                     text: 'mmoney_lite',
//                     color: color_777,
//                   ),
//                   TextFont(
//                     text: DateFormat('dd MMM, yyyy HH:mm').format(
//                       DateTime.parse(tempCcontroler.rxTimeStamp.replaceAll('/', '-')),
//                     ),
//                     fontSize: 10,
//                     poppin: true,
//                   ),
//                 ],
//               ),
//               Container(
//                 child: Row(
//                   children: [
//                     // Image.network(
//                     //   tempCcontroler.tempCdetail.value.groupLogo.toString(),
//                     //   width: 10.w,
//                     // ),
//                     // const SizedBox(width: 10),
//                     // SvgPicture.asset(
//                     //   MyIcon.logox_slip,
//                     //   width: 10.w,
//                     // ),

//                     PrettyQr(
//                       image: const AssetImage('images/logox.png'),
//                       size: 20.w,
//                       data: tempCcontroler.rxTransID.value,
//                       errorCorrectLevel: QrErrorCorrectLevel.M,
//                       typeNumber: null,
//                       roundEdges: false,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildFromAccToAcc() {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               TextFont(text: 'detail', fontWeight: FontWeight.w700),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFont(text: 'from', color: color_777),
//               Expanded(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         TextFont(
//                           text: userController.name.value,
//                           color: color_2d3,
//                           noto: true,
//                           fontSize: 11,
//                         ),
//                         TextFont(
//                           text: storage.read('msisdn'),
//                           color: color_2d3,
//                           poppin: true,
//                           fontSize: 12.5,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//           const Divider(color: color_ddd),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFont(text: 'to', color: color_777),
//               Expanded(
//                 child: TextFont(
//                   text:
//                       "${tempCcontroler.tempCdetail.value.groupTelecom} - ${tempCcontroler.tempCservicedetail.value.name}",
//                   color: color_2d3,
//                   noto: true,
//                   fontSize: 11,
//                   maxline: 2,
//                   textAlign: TextAlign.end,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFont(text: '', color: color_777),
//               Expanded(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextFont(
//                       text: tempCcontroler.rxAccNo.value,
//                       color: color_2d3,
//                       poppin: true,
//                       fontSize: 12.5,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFont(text: '', color: color_777),
//               Expanded(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextFont(
//                       text: tempCcontroler.rxAccName.value,
//                       color: color_2d3,
//                       noto: true,
//                       fontSize: 11,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           tempCcontroler.rxCouponAmount.value == 0
//               ? const SizedBox()
//               : Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     TextFont(text: 'coupon_kip', color: color_777),
//                     Expanded(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           TextFont(
//                             text: NumberFormat('#,###').format(tempCcontroler.rxCouponAmount.value),
//                             color: color_2d3,
//                             noto: true,
//                             fontSize: 12.5,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFont(text: 'amount_kip', color: color_777),
//               Expanded(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextFont(
//                       text: NumberFormat('#,###').format(tempCcontroler.rxPaymentAmount.value),
//                       color: color_2d3,
//                       noto: true,
//                       fontSize: 12.5,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Container buildPaymentAmount() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 24),
//       decoration: ShapeDecoration(
//         // color: Color(0xFFF5F5F5),
//         color: color_f14,
//         shape: RoundedRectangleBorder(
//           side: const BorderSide(width: 0.5, color: color_f14),
//           borderRadius: BorderRadius.circular(5),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(top: 4),
//             child: Column(
//               children: [
//                 TextFont(
//                   text: 'amount',
//                   color: color_fff,
//                   fontWeight: FontWeight.w700,
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(left: 20),
//                   child: Row(
//                     textBaseline: TextBaseline.alphabetic,
//                     crossAxisAlignment: CrossAxisAlignment.baseline,
//                     children: [
//                       TextFont(
//                         text: NumberFormat('#,###').format(double.parse(tempCcontroler.rxTotalAmount.value.toString())),
//                         poppin: true,
//                         fontWeight: FontWeight.w400,
//                         fontSize: 20,
//                         color: color_fff,
//                       ),
//                       const SizedBox(width: 5),
//                       TextFont(
//                         text: 'kip',
//                         fontWeight: FontWeight.w500,
//                         color: color_fff,
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
