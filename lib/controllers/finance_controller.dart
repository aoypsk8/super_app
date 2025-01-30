// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/log_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/models/model-institution/finance_account_model.dart';
import 'package:super_app/models/model-institution/finance_model.dart';
import 'package:super_app/services/api/dio_client.dart';
import 'package:super_app/services/helper/random.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:intl/intl.dart';

class FinanceController extends GetxController {
  final HomeController homeController = Get.find();
  final UserController userController = Get.find();
  final logController = Get.put(LogController());
  final paymentController = Get.put(PaymentController());
  final storage = GetStorage();

  RxList<FinanceModel> financeModel = <FinanceModel>[].obs;
  Rx<FinanceModel> financeModelDetail = FinanceModel().obs;
  Rx<FinanceAccountModel> financeAccModel = FinanceAccountModel().obs;

  RxString rxTimeStamp = ''.obs;
  RxString rxTransID = ''.obs;
  RxString rxAccNo = ''.obs;
  RxString rxAccName = ''.obs;
  RxString rxAccessToken = ''.obs;
  RxString rxNote = ''.obs;
  RxString rxFee = '0'.obs;
  RxString rxPaymentAmount = ''.obs;

  //! Log
  var logVerify;
  var logPaymentReq;
  var logPaymentRes;

  fetchInstitution() async {
    List<String> urlSplit =
        homeController.menudetail.value.url.toString().split(";");
    var url = urlSplit[0];
    var response =
        await DioClient.postEncrypt(loading: false, url, key: 'backup', {});
    financeModel.value = response
        .map<FinanceModel>((json) => FinanceModel.fromJson(json))
        .toList();
  }

  getToken() async {
    List<String> urlSplit =
        homeController.menudetail.value.url.toString().split(";");
    var url = urlSplit[1];
    // var url = "/Finance/token";
    var body = {
      'client_id': storage.read('msisdn'),
      'client_secret': '77a6891ea6af486f90f7ccd1a6bf77d5',
      'username': 'MmoneyX',
      'password': '1@qqasx3\$dfi'
    };
    var response = await DioClient.postEncrypt(
      url,
      body,
      key: 'backup',
      loading: false,
    );
    if (response["code"] == 0) {
      rxAccessToken.value = response["access_token"];
    }
  }

  verifyAccount() async {
    rxTransID.value = homeController.menudetail.value.description! +
        await randomNumber().fucRandomNumber();
    List<String> urlSplit =
        homeController.menudetail.value.url.toString().split(";");
    var url = urlSplit[2];
    // var url = "/Finance/verify";
    var body = {
      "Id": financeModelDetail.value.id!,
      "TranID": rxTransID.value,
      "AccNo": rxAccNo.value,
      // "AccNo": "000201002082371",
      "PhoneUser": storage.read('msisdn'),
      "token": rxAccessToken.value
    };
    var response = await DioClient.postEncrypt(url, body, key: 'backup');
    logVerify = response;
    if (response["code"] == 0) {
      financeAccModel.value = FinanceAccountModel.fromJson(response);
      rxAccNo.value = financeAccModel.value.accno!;
      rxAccName.value = financeAccModel.value.name!;
      Get.toNamed("/paymentFinace");
    } else {
      DialogHelper.showErrorDialogNew(description: response["msg"]);
    }
  }

  void paymentProcess() async {
    // Get.toNamed("/resultFinance");
    userController.fetchBalance();
    if (userController.mainBalance.value >= int.parse(rxPaymentAmount.value)) {
      var url;
      var data;
      var response;
      rxFee.value = financeModelDetail.value.fee!;
      response = await paymentController.cashoutWallet(
        rxTransID.value,
        rxPaymentAmount.value,
        rxFee.value,
        homeController.menudetail.value.groupNameEN,
        financeModelDetail.value.id,
        rxNote.value,
        rxAccNo.value,
        financeModelDetail.value.title,
      );
      if (response["resultCode"] == 0) {
        List<String> urlSplit =
            homeController.menudetail.value.url.toString().split(";");
        url = urlSplit[3];
        // url = "/Finance/confirm";
        data = {
          "Id": financeModelDetail.value.id,
          "TranID": rxTransID.value,
          "AccNo": rxAccNo.value,
          "PhoneUser": storage.read('msisdn'),
          "AccName": rxAccName.value,
          "Amount": rxPaymentAmount.value,
          "Fee": rxFee.value,
          "Remark": rxNote.value,
          "token": rxAccessToken.value
        };

        // //! save befor log
        // logController.insertBeforePayment(
        //     homeController.menudetail.value.groupNameEN, data);

        var response = await DioClient.postEncrypt(url, data,
            key: 'backup', bearer: rxAccessToken.value);
        //! save log
        logPaymentReq = data;
        logPaymentRes = response;
        logController.insertAllLog(
          "homeController.menudetail.value.groupNameEN.toString()",
          rxTransID.value,
          financeModelDetail.value.logo!,
          financeModelDetail.value.title!,
          rxAccNo.value,
          rxAccName.value,
          rxPaymentAmount.value,
          0,
          rxFee.value,
          rxNote.value,
          logVerify,
          logPaymentReq,
          logPaymentRes,
        );
        if (response['code'] == 0) {
          //! save parameter to result screen
          rxTimeStamp.value = response["created"];
          rxPaymentAmount.value = response['amount'].toString();
          saveHistoryFinnace(rxAccNo.value, rxAccName.value);
          Get.toNamed("/resultFinace");
        } else {
          DialogHelper.showErrorWithFunctionDialog(
              description: response['msg'],
              onClose: () {
                Get.close(userController.pageclose.value);
              });
        }
      } else {
        //! cashout fail
        DialogHelper.showErrorDialogNew(description: response['resultDesc']);
      }
    } else {
      DialogHelper.showErrorDialogNew(description: 'Your balance not enough.');
    }
  }

  void saveHistoryFinnace(String msisdn, String fullname) async {
    final box = GetStorage();
    String? myDataString = box.read('historyFinance');
    if (myDataString == null) {
      var myData0 = [
        {
          'timeStamp': DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now()),
          'msisdn': msisdn,
          'fullname': fullname,
        }
      ];
      await box.write('historyFinance', json.encode(myData0));
    } else {
      List<Map<String, dynamic>> myData = (json.decode(myDataString) as List)
          .map((item) => item as Map<String, dynamic>)
          .toList();
      bool exists = false;
      for (var item in myData) {
        if (item['msisdn'] == msisdn) {
          item['timeStamp'] =
              DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
          exists = true;
          break;
        }
      }
      if (!exists) {
        myData.add({
          'timeStamp': DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now()),
          'msisdn': msisdn,
          'fullname': fullname,
        });
      }
      await box.write('historyFinance', json.encode(myData));
    }
  }
}
