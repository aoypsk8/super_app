// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, unused_local_variable, avoid_print, await_only_futures

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:super_app/controllers/log_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/transfer_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/models/model-history/history_detail_model.dart';
import 'package:super_app/models/model-qr/generate_qr_model.dart';
import 'package:super_app/models/model-qr/qrmerchant_model.dart';
import 'package:super_app/services/helper/random.dart';
import 'package:super_app/utility/database_helper.dart';
import 'package:super_app/views/myqr/MyQrScreen.dart';
import '../services/api/dio_client.dart';
import '../utility/dialog_helper.dart';
import '../utility/myconstant.dart';
import 'home_controller.dart';

class QrController extends GetxController {
  final storage = GetStorage();
  final userController = Get.find<UserController>();
  final homeController = Get.find<HomeController>();
  final paymentController = Get.put(PaymentController());
  final logController = Get.put(LogController());
  final transferController = Get.put(TransferController());
  final dbHelper = DatabaseHelper.instance;

  Rx<QrModel> qrModel = QrModel().obs;
  Rx<GenerateQrModel> generateQrModel = GenerateQrModel().obs;
  RxList<HistoryDetailModel> proofLists = <HistoryDetailModel>[].obs;
  Rx<HistoryDetailModel> proofModel = HistoryDetailModel().obs;
  RxInt rxPaymentAmount = 0.obs;
  RxInt rxCouponAmount = 0.obs;
  RxInt rxTotalAmount = 0.obs;
  RxString rxTransID = ''.obs;
  RxString rxNote = ''.obs;
  RxString rxTimeStamp = ''.obs;
  RxInt rxFee = 0.obs;
  RxInt rxFeeConsumer = 0.obs;
  RxString rxQRcode = ''.obs;
  RxString rxProvider = ''.obs;
  RxString rxQrDynamicAmout = ''.obs;
  RxString rxRelativeTime = ''.obs;

  RxString rxTransrefCoupon = ''.obs;

  //? Log
  var logVerify;
  var logPaymentReq;
  var logPaymentRes;

  //! clear data
  clear() async {
    qrModel = QrModel().obs;
    rxPaymentAmount.value = 0;
    rxCouponAmount.value = 0;
    rxTotalAmount.value = 0;
    rxTransID.value = '';
    rxNote.value = '';
    rxTimeStamp.value = '';
    rxFee.value = 0;
    rxFeeConsumer = 0.obs;
    rxQRcode.value = '';
    rxProvider.value = '';
    rxQrDynamicAmout.value = '';
    rxRelativeTime.value = '';
    rxTransrefCoupon.value = '';
    logVerify = null;
    logPaymentReq = null;
    logPaymentRes = null;
  }

  generateQR_firstscreen(amount, qrtype, remark) async {
    String tranID = 'QR${await randomNumber().fucRandomNumber()}';
    var url = '${MyConstant.urlQR}/GenerateConsumerQR';
    var data = {
      "TranID": tranID,
      "Amount": amount,
      "PhoneUser": storage.read('msisdn'),
      "QrType": qrtype,
      "Remark": remark
    };
    var response =
        await DioClient.postEncrypt(url, data, key: 'lmmkey', loading: false);
    if (response["resultCode"] == "200") {
      generateQrModel.value = GenerateQrModel.fromJson(response);
    }
  }
}
