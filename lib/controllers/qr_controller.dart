// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, unused_local_variable, avoid_print, await_only_futures, invalid_use_of_protected_member, unnecessary_null_comparison

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:super_app/controllers/log_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/transfer_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/models/history_detail_model.dart';
import 'package:super_app/models/generate_qr_model.dart';
import 'package:super_app/models/qrmerchant_model.dart';
import 'package:super_app/services/helper/random.dart';
import 'package:super_app/utility/database_helper.dart';
import 'package:super_app/views/myqr/MyQrScreen.dart';
import 'package:super_app/views/reusable_template/reusable_result.dart';
import 'package:super_app/views/scanqr/laoqr_payment_screen.dart';
import 'package:super_app/views/transferwallet/TransferScreen.dart';
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
      rxNote.value = remark;
      generateQrModel.value = GenerateQrModel.fromJson(response);
    }
  }

  fetchProofLists() async {
    var response = await dbHelper.queryAll();
    proofLists.value = response;
  }

  insertProof(HistoryDetailModel detail) async {
    var response = await dbHelper.insert(detail);
    fetchProofLists();
  }

  deleteProof(colName, val) async {
    var response = await dbHelper.deleteDataByCondition(colName, val);
    fetchProofLists();
  }

//!
  //! VERIFY QR
  //!------------------------------------------------------------------------------
  verifyQR(qrCode) async {
    if (qrCode.startsWith('https://')) {
      // Get.lazyPut<RedeemController>(() => RedeemController());
      // final RedeemController redeemController = Get.find();
      // await redeemController.verifyCode(qrCode, 'homeScreen');
    } else {
      // final creditcardController = Get.find<CreditcardController>();
      rxTransID.value = 'QR${await randomNumber().fucRandomNumber()}';
      Logger().d('$rxTransID');
      var url = '${MyConstant.urlQR}/VerifyQR';
      var data = {
        "transID": rxTransID.value,
        "PhoneUser": storage.read('msisdn'),
        "qrCode": qrCode,
        "type": MyConstant.desRoute,
        "version": homeController.appVersion.value
      };
      var response = await DioClient.postEncrypt(url, data, key: 'lmmkey');
      print(response);
      if (response["resultCode"] == "200") {
        //! Check LAO QR
        //!------------------------------------------------------------------------------
        if (response["Provider"] != "LMM") {
          homeController.menudetail.value.groupNameEN = "LQR";
          rxTransID.value = 'L${rxTransID.value}';
          rxQRcode.value = qrCode;
          qrModel.value = QrModel.fromJson(response);
          if (response["qrType"] == "dynamic" ||
              int.parse(qrModel.value.transAmount.toString()) > 0) {
            rxPaymentAmount.value =
                int.parse(qrModel.value.transAmount.toString());
            rxTotalAmount.value =
                int.parse(qrModel.value.transAmount.toString());
            rxFee.value = int.parse(qrModel.value.fee!);
            rxFeeConsumer.value = int.parse(qrModel.value.feeAmountConsumer!);
          }
          Get.to(() => LaoQrPaymentScreen());
        } else {
          //! Check M-Money MyQR or Merchant
          //!------------------------------------------------------------------------------
          if (response["Target"] == "CONSUMER") {
            homeController.menudetail.value.description = "TF";
            homeController.menudetail.value.groupNameEN = "Transfer";
            if (response["qrType"] == "static") {
              if (response["merchantMobile"] == storage.read('msisdn')) {
                DialogHelper.showErrorDialogNew(
                    description: 'Can\'t scan own QR');
              } else {
                transferController.destinationMsisdn.value =
                    response["merchantMobile"];
                final menuWithAppId14 =
                    homeController.menuModel.value.firstWhere(
                  (menu) => menu.menulists!.any((item) => item.appid == 14),
                );
                if (menuWithAppId14 != null) {
                  final matchedItem = menuWithAppId14.menulists!
                      .firstWhere((item) => item.appid == 14);
                  homeController.menutitle.value = matchedItem.groupNameEN!;
                  homeController.menudetail.value = matchedItem;
                }
                Get.to(() => const TransferScreen());
              }
            } else {
              var desMsisdn = response["merchantMobile"];
              var transferAmount = response["transAmount"].toString();
              var transferNote = response["Remark"];
              transferController.vertifyWallet(
                  desMsisdn, transferAmount, transferNote);
            }
          } else {
            homeController.menudetail.value.groupNameEN = "QR";
            rxQRcode.value = qrCode;
            qrModel.value = QrModel.fromJson(response);
            // await creditcardController.checkVisaPayment();
            if (response["qrType"] == "dynamic") {
              rxPaymentAmount.value =
                  int.parse(qrModel.value.transAmount.toString());
              rxTotalAmount.value =
                  int.parse(qrModel.value.transAmount.toString());
            }
            // Get.to(() => const QrPaymentScreen());
          }
        }
      } else {
        DialogHelper.showErrorWithFunctionDialog(
            description: response['resultDesc'],
            onClose: () {
              Get.close(userController.pageclose.value + 1);
            });
      }
    }
  }

  //!
  //! PAYMENT M-MONEY QR
  //!------------------------------------------------------------------------------
  paymentQR() async {
    var data;
    var url;
    var response;
    //? qry fee
    if (qrModel.value.qrType! == "dynamic") {
      rxFee.value = int.parse(qrModel.value.fee!);
    } else {
      await QueryFee();
    }
    //? cashout
    if (userController.totalBalance.value >= rxTotalAmount.value) {
      //? cashout from wallet
      response = await paymentController.cashoutWallet(
        rxTransID.value,
        rxTotalAmount.value,
        rxFee.value,
        'QR', // chanel
        '', // chanel detail
        rxNote.value,
        qrModel.value.merchantMobile,
        qrModel.value.provider,
      );
      if (response["resultCode"] == 0) {
        rxTransrefCoupon.value = response["data"]["transID"];
        //! confirm qr
        url = '${MyConstant.urlQR}/ConfirmQR';
        data = {
          "transID": rxTransID.value,
          "type": MyConstant.desRoute,
          "amount": rxTotalAmount.value,
          "Point": rxCouponAmount.value,
          "PhoneUser": storage.read('msisdn'),
          "qrCode": rxQRcode.value,
          "Provider": qrModel.value.provider!,
          "Remark": rxNote.value,
          "PhoneUser_Name":
              '${userController.userProfilemodel.value.name} ${userController.userProfilemodel.value.surname}'
        };
        response = await DioClient.postEncrypt(url, data, key: 'lmmkey');
        //! save log
        await saveLogQR(data, response);
        if (response['resultCode'] == "200") {
          rxTransID.value = response['transactionNo'];
          rxTimeStamp.value = response['CreatedDatetime'];
          rxTotalAmount.value = int.parse(response['transAmount']);
          Get.to(ReusableResultScreen(
            fromAccountImage:
                userController.userProfilemodel.value.profileImg ??
                    MyConstant.profile_default,
            fromAccountName: userController.profileName.value,
            fromAccountNumber: userController.rxMsisdn.value,
            toAccountImage: qrModel.value.logoUrl ?? MyConstant.profile_default,
            toAccountName: qrModel.value.shopName.toString(),
            toAccountNumber: qrModel.value.provider.toString(),
            toTitleProvider: '',
            amount: rxPaymentAmount.value.toString(),
            fee: '0',
            transactionId: rxTransID.value,
            note: rxNote.value,
            timestamp: rxTimeStamp.value,
          ));
        } else {
          DialogHelper.showErrorWithFunctionDialog(
            description: response['resultDesc'],
            onClose: () {
              Get.close(userController.pageclose.value + 1);
            },
          );
        }
      } else {
        DialogHelper.showErrorWithFunctionDialog(
          description: response['resultDesc'],
          onClose: () {
            Get.close(userController.pageclose.value + 1);
          },
        );
      }
    } else {
      DialogHelper.showErrorWithFunctionDialog(
        description: 'Your balance not enough.',
        onClose: () {
          Get.close(userController.pageclose.value + 1);
        },
      );
    }
  }

  //!
  //! PAYMENT LAO-QR
  //!------------------------------------------------------------------------------
  paymentLaoQR() async {
    var data;
    var url;
    var response;
    if (qrModel.value.qrType! == "dynamic") {
      rxFee.value = int.parse(qrModel.value.fee!);
    } else {
      await QueryFee();
    }
    if (userController.totalBalance.value >= rxTotalAmount.value) {
      if (await paymentController.confirmCashOut()) {
        url = '${MyConstant.urlQR}/LaoConfirmQR';
        data = {
          "PhoneUser": storage.read('msisdn'),
          "PhoneUser_Name":
              '${userController.userProfilemodel.value.name} ${userController.userProfilemodel.value.surname}',
          "transID": rxTransID.value,
          "qrType": qrModel.value.qrType,
          "refNo": qrModel.value.refNo,
          "merchantMobile": qrModel.value.merchantMobile,
          "qr": rxQRcode.value,
          "shopName": qrModel.value.shopName,
          "amount": rxTotalAmount.value,
          "Provider": qrModel.value.provider!,
          "fee": rxFee.value,
          "Remark": rxNote.value,
          "fee_consumer": rxFeeConsumer.value,
          "type": MyConstant.desRoute,
          "paymentTypeId": qrModel.value.paymentTypeId
        };
        response = await DioClient.postEncrypt(url, data, key: 'lmmkey');
        //! save log
        await saveLogQR(data, response);
        if (response['resultCode'] == "200") {
          rxTransID.value = response['transID'];
          rxTimeStamp.value = response['CreatedDatetime'];
          rxTotalAmount.value = int.parse(response['transAmount']);
          rxFee.value = int.parse(response['fee']);
          Get.to(ReusableResultScreen(
            fromAccountImage:
                userController.userProfilemodel.value.profileImg ??
                    MyConstant.profile_default,
            fromAccountName: userController.profileName.value,
            fromAccountNumber: userController.rxMsisdn.value,
            toAccountImage: qrModel.value.logoUrl ?? MyConstant.profile_default,
            toAccountName: qrModel.value.shopName.toString(),
            toAccountNumber: qrModel.value.provider.toString(),
            toTitleProvider: '',
            amount: rxPaymentAmount.value.toString(),
            fee: '0',
            transactionId: rxTransID.value,
            note: rxNote.value,
            timestamp: rxTimeStamp.value,
          ));
        } else {
          DialogHelper.showErrorWithFunctionDialog(
            description: response['resultDesc'],
            onClose: () {
              Get.close(userController.pageclose.value + 1);
            },
          );
        }
      }
    } else {
      DialogHelper.showErrorWithFunctionDialog(
        description: 'Your balance not enough.',
        onClose: () {
          Get.close(userController.pageclose.value + 1);
        },
      );
    }
  }

  //!
  //! Save LOG
  //!------------------------------------------------------------------------------
  Future<void> saveLogQR(data, response) async {
    logPaymentReq = data;
    logPaymentRes = response;
    await logController.insertAllLog(
      qrModel.value.provider == 'LMM' ? 'QR' : 'LQR',
      rxTransID.value,
      qrModel.value.logoUrl,
      qrModel.value.provider,
      qrModel.value.merchantMobile,
      qrModel.value.shopName,
      rxTotalAmount.value,
      rxCouponAmount.value,
      qrModel.value.provider == 'LMM' ? rxFee.value : rxFeeConsumer.value,
      rxNote.value,
      logVerify,
      logPaymentReq,
      logPaymentRes,
    );
  }

  //!
  //! QRY FEE
  //!------------------------------------------------------------------------------
  Future<void> QueryFee() async {
    var url = '${MyConstant.urlQR}/GetFee';
    var response = await DioClient.postEncrypt(loading: false, url, {
      "Amount": rxTotalAmount.value,
      "PhoneUser": storage.read('msisdn'),
      "Provider": qrModel.value.provider!,
    });
    rxFee.value = int.parse(response['FeeAmount'].toString());
    rxFeeConsumer.value = int.parse(response['FeeAmount_Consumer'].toString());
  }
}
