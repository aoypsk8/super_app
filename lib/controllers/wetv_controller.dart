// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/services/api/dio_client.dart';
import 'package:intl/intl.dart';
import 'package:super_app/views/weTV/ResultWeTVScreen.dart';

import '../services/helper/random.dart';
import '../models/wetv_model.dart';
import '../utility/dialog_helper.dart';
import 'log_controller.dart';

class WeTVController extends GetxController {
  final paymentController = Get.put(PaymentController());
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final logController = LogController();
  final storage = GetStorage();

  late RxList<WeTvModel> wetvmodel = RxList();
  Rx<WeTvList> wetvdetail = WeTvList().obs;
  late RxList<WeTvList> wetvlist = RxList();
  late RxList<WeTvHistory> wetvhistory = RxList();
  RxString title = 'WeTV'.obs;
  RxString wetvCode = ''.obs;
  RxString rxTransID = ''.obs;
  RxString rxPayDatetime = ''.obs;
  RxBool loading = false.obs;
  RxString rxNote = ''.obs;
  RxString rxFee = '0'.obs;

  var logPaymentReq;
  var logPaymentRes;

  // clear() {
  //   wetvmodel = RxList();
  //   wetvdetail = WeTvList().obs;
  //   wetvhistory = RxList();
  //   wetvlist = RxList();
  //   title = 'WeTV'.obs;
  //   wetvCode.value = '';
  //   rxTransID.value = '';

  //   logPaymentReq = null;
  //   logPaymentRes = null;
  // }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    fetchWeTvList();
    fetchwetvhistory();
  }

  fetchWeTvList() async {
    List<String> urlSplit =
        homeController.menudetail.value.url.toString().split(";");
    var response = await DioClient.postEncrypt(urlSplit[0], {});
    wetvlist.value =
        response.map<WeTvList>((json) => WeTvList.fromJson(json)).toList();
  }

  wetvpayment(amout) async {
    userController.fetchBalance();
    rxTransID.value = homeController.menudetail.value.description.toString() +
        await randomNumber().fucRandomNumber();
    if (userController.mainBalance.value >= int.parse(amout)) {
      var response;
      var data;
      var url;
      response = await paymentController.cashoutWallet(
        rxTransID.value,
        amout,
        '0',
        homeController.menudetail.value.groupNameEN.toString(),
        '',
        '',
        '',
        homeController.menudetail.value.groupNameEN.toString(),
      );
      if (response["resultCode"] == 0) {
        List<String> urlSplit =
            homeController.menudetail.value.url.toString().split(";");
        data = {
          "TranID": rxTransID.value,
          "weid": wetvdetail.value.weid,
          "amount": wetvdetail.value.price,
          "PhoneUser": storage.read('msisdn'),
        };

        // //! save befor log
        // logController.insertBeforePayment(
        //     homeController.menudetail.value.groupNameEN.toString(), data);

        var response = await DioClient.postEncrypt(urlSplit[1], data);

        //! save log
        logPaymentReq = data;
        logPaymentRes = response;
        logController.insertAllLog(
          homeController.menudetail.value.groupNameEN.toString(),
          rxTransID.value,
          '',
          homeController.menudetail.value.groupNameEN.toString(),
          '',
          '',
          amout.toString(),
          0,
          '0',
          '',
          null,
          logPaymentReq,
          logPaymentRes,
        );
        if (response['ResultCode'] == '200') {
          //? save parameter to result screen
          // rxTimeStamp.value = response['CreateDate'];
          // rxPaymentAmount.value = response['Amount'];
          // Get.to(() => const ResultTempBScreen());
          wetvCode.value = response["Code"];
          rxPayDatetime.value =
              DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
          Get.to(() => ResultWeTVscreen());
        } else {
          DialogHelper.showErrorWithFunctionDialog(
              description: response['ResultDesc'],
              onClose: () {
                Get.close(userController.pageclose.value);
              });
        }
      } else {
        //? cashout fail
        DialogHelper.showErrorDialogNew(description: response['resultDesc']);
      }
    } else {
      DialogHelper.showErrorDialogNew(description: 'Your balance not enough.');
    }

    // var response = await DioClient.post(urlSplit[1], {
    //   "TranID": rxTranID.value,
    //   "weid": wetvdetail.value.weid,
    //   "amount": wetvdetail.value.price,
    //   "PhoneUser": storage.read('msisdn'),
    // });
    // if (response != null) {
    //   if (response["ResultCode"] == "200") {
    //     wetvCode.value = response["Code"];
    //     Get.to(() => WeTVBill());
    //   }
    // } else {
    //   paymentController.cashin(paymentController.rxtransid.value,
    //       wetvdetail.value.price.toString(), response['ResultCode']);
    // }
  }

  fetchwetvhistory() async {
    List<String> urlSplit =
        homeController.menudetail.value.url.toString().split(";");
    var response = await DioClient.postEncrypt(loading: false, urlSplit[2], {
      "msisdn": storage.read('msisdn'),
    });
    // print('xxxxxx ${response.toString()}');
    if (response != null) {
      wetvhistory.value = response
          .map<WeTvHistory>((json) => WeTvHistory.fromJson(json))
          .toList();
    }
  }
}
