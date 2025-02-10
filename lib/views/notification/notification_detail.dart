// // ignore_for_file: sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:mmoney_lite/controller/home_controller.dart';
// import 'package:mmoney_lite/utility/colors.dart';
// import 'package:mmoney_lite/utility/myIcon.dart';
// import 'package:mmoney_lite/widgets/textfont.dart';
// import 'package:sizer/sizer.dart';
// import 'package:url_launcher/url_launcher.dart';

// class NotificationDetail extends StatefulWidget {
//   const NotificationDetail({super.key});

//   @override
//   State<NotificationDetail> createState() => _NotificationDetailState();
// }

// class _NotificationDetailState extends State<NotificationDetail> {
//   final homeController = Get.find<HomeController>();
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             automaticallyImplyLeading: true,
//             iconTheme: IconThemeData(color: Colors.black),
//             backgroundColor: Colors.white,
//           ),
//           body: SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.only(left: 24, right: 24),
//               child: Column(
//                 children: [header(), messageTitle()],
//               ),
//             ),
//           ),
//           bottomNavigationBar: closeBtn(),
//         ));
//   }

//   Widget header() {
//     var date = DateTime.parse(homeController.messageListDetail.value.createAt!);
//     return Column(
//       children: [
//         Row(
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30), color: cr_red),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SvgPicture.asset(
//                     MyIcon.ic_speaker,
//                     height: 5.5.w,
//                   ),
//                   SizedBox(
//                     width: 4,
//                   ),
//                   TextFont(
//                     text: homeController.messageListDetail.value.typeName!,
//                     fontSize: 10,
//                     color: Colors.white,
//                     noto: true,
//                   ),
//                 ],
//               ),
//             ),
//             Spacer(),
//             TextFont(
//               text: DateFormat("MMM dd, yyyy - HH:mm").format(date),
//               fontSize: 11,
//               color: Color(0xff636E72),
//               poppin: true,
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 16,
//         ),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(8),
//           child: homeController.messageListDetail.value.imgUrl == null ||
//                   homeController.messageListDetail.value.imgUrl == 'null' ||
//                   homeController.messageListDetail.value.imgUrl == ''
//               ? SvgPicture.asset(
//                   MyIcon.bgg_nopic,
//                   fit: BoxFit.fitHeight,
//                 )
//               : CachedNetworkImage(
//                   fit: BoxFit.fitWidth,
//                   progressIndicatorBuilder: (context, url, progress) =>
//                       SizedBox(),
//                   imageUrl: homeController.messageListDetail.value.imgUrl!,
//                   errorWidget: (context, url, error) => SvgPicture.asset(
//                     MyIcon.bgg_nopic,
//                     fit: BoxFit.fitHeight,
//                   ),
//                 ),
//         ),
//       ],
//     );
//   }

//   Widget messageTitle() {
//     return Container(
//       padding: EdgeInsets.only(top: 10, left: 3, right: 3),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextFont(
//             text: homeController.messageListDetail.value.title!,
//             fontWeight: FontWeight.w600,
//             noto: true,
//           ),
//           SizedBox(
//             height: 6,
//           ),
//           Align(
//             alignment: Alignment.centerRight,
//             child: GestureDetector(
//               onTap: () async {
//                 // if (global.browserStatus == 'INAPP') {
//                 //   Navigator.pushNamed(context, '/webview',
//                 //       arguments: {'url': global.messageUrl, 'title': ''});
//                 // } else if (global.browserStatus == 'PREVENTRECORD') {
//                 //   globController.seturl(global.messageUrl);
//                 //   Navigator.pushNamed(context, '/webviewprevcap');
//                 // } else {
//                 //   var url = '${global.messageUrl}';
//                 //   if (!await launchUrl(Uri.parse(url),
//                 //       mode: LaunchMode.externalApplication)) {
//                 //     throw 'Could not launch $url';
//                 //   }
//                 // }
//                 var url = '${homeController.messageListDetail.value.url}';
//                 if (!await launchUrl(Uri.parse(url),
//                     mode: LaunchMode.externalApplication)) {
//                   throw 'Could not launch $url';
//                 }
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(
//                   // color: cr_red,
//                   border: Border.all(
//                     color: Color(
//                         0xff636E72), //                   <--- border color
//                     width: 1.2,
//                   ),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.language, size: 4.w, color: Color(0xff636E72)),
//                     SizedBox(
//                       width: 4,
//                     ),
//                     TextFont(
//                       text: 'gotoWeb',
//                       fontSize: 10,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 8,
//           ),
//           TextFont(
//             text: homeController.messageListDetail.value.body!,
//             maxline: 100,
//             noto: true,
//           )
//         ],
//       ),
//     );
//   }

//   Widget closeBtn() {
//     return InkWell(
//         onTap: () => Get.back(),
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 22),
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment(0.00, -1.00),
//               end: Alignment(0, 1),
//               colors: [Color(0xffF14D58), Color(0xFFED1C29)],
//             ),
//           ),
//           child: TextFont(
//             text: 'close',
//             fontSize: 14,
//             textAlign: TextAlign.center,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ));
//   }
// }
