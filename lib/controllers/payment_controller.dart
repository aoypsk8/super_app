import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/log_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/models/cashout_model.dart';
import 'package:super_app/services/api/dio_client.dart';
import 'package:super_app/utility/checksum_util.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';

class PaymentController extends GetxController {
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final logController = LogController();
  final storage = GetStorage();
  String userCashOut = "appx";
  String passCashOut = "a97e51d90b254deaa5c1271436d42397";
  RxString rxTokenCashOut = ''.obs;
  Rx<RequestCashoutModel> reqCashOutModel = RequestCashoutModel().obs;

  getTokenCashOut() async {
    rxTokenCashOut.value = '';
    var url = "${MyConstant.urlCashOut}/getToken";
    var body = {"username": userCashOut, "password": passCashOut};
    var response = await DioClient.postEncrypt(loading: false, url, body);
    if (response['resultCode'] == '0000') {
      rxTokenCashOut.value = response['token'];
    } else {
      DialogHelper.showErrorDialogNew(description: response['resultDesc']);
    }
  }

  Future<bool> reqCashOut({
    required transID,
    required amount,
    required toAcc,
    required chanel,
    required provider,
    package = "",
    required remark,
    closepage = 3,
  }) async {
    bool isSuccess = false;
    await getTokenCashOut();
    var url = "${MyConstant.urlCashOut}/ReqCashOut";
    var body = {
      "fromAccountRef": storage.read('msisdn'),
      "transAmount": amount,
      "transRemark": remark,
      "transRefCol1": "${storage.read('msisdn')}|$toAcc",
      "transRefCol2": chanel,
      "transRefCol3": provider,
      "transRefCol4": package,
      "transId": transID,
      "uuid": checkSum(
          transID, storage.read('msisdn'), '', amount.toString(), remark),
      "token": userController.rxToken.value
    };
    var response = await DioClient.postEncrypt(url, body,
        key: 'openkey', token: rxTokenCashOut.value);
    if (response['resultCode'] == "0000") {
      reqCashOutModel.value = RequestCashoutModel.fromJson(response);
      isSuccess = true;
      return isSuccess;
    } else {
      // DialogHelper.showErrorDialog(description: response['resultDesc']);
      DialogHelper.showErrorWithFunctionDialog(
          description: response['resultDesc'],
          onClose: () {
            Get.close(closepage);
          });
      return isSuccess;
    }
  }

  Future<bool> confirmCashOut() async {
    bool isSuccess = false;
    var response;
    var url = "${MyConstant.urlCashOut}/CashOut";
    var body = jsonEncode(reqCashOutModel.value);
    response = await DioClient.postEncrypt(url, body,
        key: 'openkey', token: rxTokenCashOut.value);
    logController.insertCashOutLog(
      jsonDecode(body)['transID'],
      storage.read('msisdn'),
      homeController.menudetail.value.groupNameEN,
      response,
    );
    if (response['resultCode'] == "0000") {
      isSuccess = true;
      return isSuccess;
    } else {
      DialogHelper.showErrorWithFunctionDialog(
          description: response['resultDesc'],
          onClose: () {
            Get.close(3);
          });
      return isSuccess;
    }
  }

  cashoutWallet(transid, amount, fee, channel, detailChanel, remark, toAcc,
      provider) async {
    var data = {
      "transID": transid,
      "msisdn": storage.read('msisdn'),
      "amount": amount,
      "fee": fee,
      "channel": channel,
      "type": MyConstant.desRoute,
      "remark": remark,
      "from_acc": storage.read('msisdn'),
      "to_acc": toAcc,
      "provider": provider
    };
    var response =
        await DioClient.postEncrypt('${MyConstant.urlGateway}/CashOut', data);
    return response;
  }
}
