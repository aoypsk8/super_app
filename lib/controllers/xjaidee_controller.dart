// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:super_app/controllers/home_controller.dart';
// import 'package:super_app/controllers/log_controller.dart';
// import 'package:super_app/controllers/payment_controller.dart';
// import 'package:super_app/controllers/user_controller.dart';

// class XjaideeController extends GetxController {
//   final paymentController = Get.put(PaymentController());
//   final homeController = Get.find<HomeController>();
//   final userController = Get.find<UserController>();
//   final logController = LogController();
//   final storage = GetStorage();

//   late RxList<XjaideeModel> Xjaideemodel = RxList();
//   Rx<XjaideeList> Xjaideedetail = XjaideeList().obs;
//   late RxList<XjaideeList> Xjaideelist = RxList();
//   late RxList<XjaideeHistory> Xjaideehistory = RxList();
//   RxString title = 'Xjaidee'.obs;
//   RxString XjaideeCode = ''.obs;
//   RxString rxTransID = ''.obs;
//   RxString rxPayDatetime = ''.obs;
//   RxString rxNote = ''.obs;
//   RxString rxFee = '0'.obs;

//   var logPaymentReq;
//   var logPaymentRes;

//   final RxBool enableBottom = true.obs;

//   // clear() {
//   //   Xjaideemodel = RxList();
//   //   Xjaideedetail = XjaideeList().obs;
//   //   Xjaideehistory = RxList();
//   //   Xjaideelist = RxList();
//   //   title = 'Xjaidee'.obs;
//   //   XjaideeCode.value = '';
//   //   rxTransID.value = '';

//   //   logPaymentReq = null;
//   //   logPaymentRes = null;
//   // }

//   @override
//   void onReady() {
//     // TODO: implement onReady
//     super.onReady();
//     fetchXjaideeList();
//   }

//   fetchXjaideeList() async {
//     List<String> urlSplit =
//         homeController.menudetail.value.url.toString().split(";");
//     var response = await DioClient.postEncrypt(urlSplit[0], {});
//     Xjaideelist.value =
//         response.map<XjaideeList>((json) => XjaideeList.fromJson(json)).toList();
//   }

//   Xjaideepayment(amout) async {
//     userController.fetchBalance();
//     rxTransID.value = homeController.menudetail.value.description.toString() +
//         await randomNumber().fucRandomNumber();
//     if (userController.mainBalance.value >= int.parse(amout)) {
//       var response;
//       var data;
//       var url;
//       response = await paymentController.cashoutWallet(
//         rxTransID.value,
//         amout,
//         '0',
//         homeController.menudetail.value.groupNameEN.toString(),
//         '',
//         '',
//         '',
//         homeController.menudetail.value.groupNameEN.toString(),
//       );
//       if (response["resultCode"] == 0) {
//         List<String> urlSplit =
//             homeController.menudetail.value.url.toString().split(";");
//         data = {
//           "TranID": rxTransID.value,
//           "weid": Xjaideedetail.value.weid,
//           "amount": Xjaideedetail.value.price,
//           "PhoneUser": storage.read('msisdn'),
//         };

//         // //! save befor log
//         // logController.insertBeforePayment(
//         //     homeController.menudetail.value.groupNameEN.toString(), data);

//         var response = await DioClient.postEncrypt(urlSplit[1], data);

//         //! save log
//         logPaymentReq = data;
//         logPaymentRes = response;
//         logController.insertAllLog(
//           homeController.menudetail.value.groupNameEN.toString(),
//           rxTransID.value,
//           '',
//           homeController.menudetail.value.groupNameEN.toString(),
//           '',
//           '',
//           amout.toString(),
//           0,
//           '0',
//           '',
//           null,
//           logPaymentReq,
//           logPaymentRes,
//         );
//         if (response['ResultCode'] == '200') {
//           //? save parameter to result screen
//           // rxTimeStamp.value = response['CreateDate'];
//           // rxPaymentAmount.value = response['Amount'];
//           // Get.to(() => const ResultTempBScreen());
//           XjaideeCode.value = response["Code"];
//           rxPayDatetime.value =
//               DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
//           // Get.to(() => ResultXjaideescreen());
//           Get.to(ReusableResultWithCode(
//             fromAccountImage:
//                 userController.userProfilemodel.value.profileImg ??
//                     MyConstant.profile_default,
//             fromAccountName: userController.profileName.value,
//             fromAccountNumber: userController.rxMsisdn.value,
//             toAccountImage: Xjaideedetail.value.logo ?? MyConstant.profile_default,
//             toAccountName: title.value,
//             toAccountNumber: title.value,
//             amount: Xjaideedetail.value.price.toString(),
//             fee: rxFee.toString(),
//             transactionId: rxTransID.value,
//             timestamp: rxPayDatetime.value,
//             code: XjaideeCode.value,
//             fromHistory: false,
//           ));
//         } else {
//           DialogHelper.showErrorWithFunctionDialog(
//               description: response['ResultDesc'],
//               onClose: () {
//                 Get.close(userController.pageclose.value);
//               });
//         }
//       } else {
//         //? cashout fail
//         DialogHelper.showErrorDialogNew(description: response['resultDesc']);
//       }
//     } else {
//       DialogHelper.showErrorDialogNew(description: 'Your balance not enough.');
//     }
//   }
// }
