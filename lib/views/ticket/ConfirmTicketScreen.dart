// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:super_app/controllers/home_controller.dart';
// import 'package:super_app/controllers/payment_controller.dart';
// import 'package:super_app/controllers/ticket_controller.dart';
// import 'package:super_app/controllers/user_controller.dart';
// import 'package:super_app/utility/color.dart';
// import 'package:super_app/utility/dialog_helper.dart';
// import 'package:super_app/utility/myconstant.dart';
// import 'package:super_app/widget/buildAppBar.dart';
// import 'package:super_app/widget/buildBottomAppbar.dart';
// import 'package:super_app/widget/buildTextDetail.dart';
// import 'package:super_app/widget/buildUserDetail.dart';
// import 'package:super_app/widget/build_DotLine.dart';
// import 'package:super_app/widget/build_step_process.dart';
// import 'package:super_app/widget/reusableResultWithCode.dart';
// import 'package:super_app/widget/textfont.dart';

// class ConfirmTicketScreen extends StatefulWidget {
//   const ConfirmTicketScreen({super.key});

//   @override
//   State<ConfirmTicketScreen> createState() => _ConfirmTicketScreenState();
// }

// class _ConfirmTicketScreenState extends State<ConfirmTicketScreen> {
//   final homeController = Get.find<HomeController>();
//   final userController = Get.find<UserController>();
//   final ticketController = Get.put(TicketController());
//   final paymentController = Get.put(PaymentController());
//   final storage = GetStorage();

//   int _remainingTime = 600;
//   Timer? _countdownTimer;
//   void _startCountdownTimer() {
//     _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_remainingTime > 0) {
//         if (mounted) {
//           setState(() {
//             _remainingTime--;
//           });
//         }
//       } else {
//         timer.cancel();
//         _onCountdownComplete();
//       }
//     });
//   }

//   // Called when the countdown timer completes
//   void _onCountdownComplete() {
//     DialogHelper.showErrorWithFunctionDialog(
//       title: 'time_out',
//       description: 'try_again_later',
//       onClose: () {
//         Get.until((route) => route.isFirst);
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     userController.increasepage();
//     _startCountdownTimer();
//   }

//   @override
//   void dispose() {
//     _countdownTimer?.cancel();
//     super.dispose();
//     userController.decreasepage();
//   }

//   String _formatTime(int seconds) {
//     final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
//     final secs = (seconds % 60).toString().padLeft(2, '0');
//     return '$minutes:$secs';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: color_fff,
//       appBar: BuildAppBar(title: "confirm_payment"),
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.only(top: 20),
//         decoration: BoxDecoration(
//           color: color_fff,
//           border: Border.all(color: color_ddd),
//         ),
//         child: buildBottomAppbar(
//           bgColor: Theme.of(context).primaryColor,
//           title: 'confirm',
//           func: () {
//             ticketController.paymentProcess();
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 buildStepProcess(title: "3/3", desc: "detail"),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Iconsax.clock,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     const SizedBox(width: 5),
//                     TextFont(
//                       text: _formatTime(_remainingTime),
//                       fontSize: 14,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ],
//                 )
//               ],
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(vertical: 15),
//               padding: EdgeInsets.symmetric(vertical: 10),
//               width: Get.width,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: cr_fdeb,
//               ),
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: buildUserDetail(
//                       profile:
//                           userController.userProfilemodel.value.profileImg ??
//                               MyConstant.profile_default,
//                       from: true,
//                       msisdn: userController.rxMsisdn.value,
//                       name: userController.profileName.value,
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   const buildDotLine(color: cr_ef33, dashlenght: 7),
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: buildUserDetail(
//                       profile: ticketController.ticketDetail.value.logo ??
//                           MyConstant.profile_default,
//                       from: false,
//                       msisdn: ticketController.ticketDetail.value.description
//                           .toString(),
//                       name: ticketController.ticketDetail.value.title!,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextFont(
//               text: 'amount_transfer',
//               fontWeight: FontWeight.w500,
//               fontSize: 11,
//               color: cr_7070,
//             ),
//             Row(
//               children: [
//                 TextFont(
//                   text: fn.format(int.parse(
//                       ticketController.ticketDetail.value.price.toString())),
//                   fontWeight: FontWeight.w500,
//                   fontSize: 20,
//                   color: cr_b326,
//                 ),
//                 TextFont(
//                   text: '.00 LAK',
//                   fontWeight: FontWeight.w500,
//                   fontSize: 20,
//                   color: cr_b326,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             buildTextDetail(
//               title: "fee",
//               detail: '0',
//               money: true,
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
