// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/controllers/log_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/models/providerTempBModel.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/reusable_template/reusable_result.dart';
import 'package:super_app/views/templateB/Result_TempB.dart';
import 'package:super_app/views/templateB/payment_tempB.dart';
import '../services/helper/random.dart';
import '../models/menu_model.dart';
import '../services/api/dio_client.dart';
import '../utility/dialog_helper.dart';

import 'home_controller.dart';

class TempBController extends GetxController {
  final storage = GetStorage();
  final userController = Get.find<UserController>();
  final paymentController = Get.find<PaymentController>();
  final logController = LogController();
  final HomeController homeController = Get.find();

  RxList<ProviderTempBModel> tampBmodel = <ProviderTempBModel>[].obs;
  Rx<ProviderTempBModel> tempBdetail = ProviderTempBModel().obs;
  RxList<RecentTempBModel> recenttampB = <RecentTempBModel>[].obs;

  RxString rxAccNo = ''.obs;
  RxString rxAccName = ''.obs;
  RxString rxDebit = ''.obs;
  RxString rxFee = ''.obs;
  RxString rxNote = ''.obs;
  RxString rxTransID = ''.obs;
  RxString rxTimeStamp = ''.obs;
  RxString rxPaymentAmount = ''.obs;

  final RxBool enableBottom = true.obs;

  //? Log
  var logVerify;
  var logPaymentReq;
  var logPaymentRes;

  var isLoading = false.obs;

  clear() {
    tampBmodel = <ProviderTempBModel>[].obs;
    tempBdetail = ProviderTempBModel().obs;
    recenttampB = <RecentTempBModel>[].obs;
    rxAccNo.value = '';
    rxAccName.value = '';
    rxDebit.value = '';
    rxFee.value = '';
    rxNote.value = '';
    rxTransID.value = '';
    rxTimeStamp.value = '';
    rxPaymentAmount.value = '';
    logVerify = null;
    logPaymentReq = null;
    logPaymentRes = null;
  }

  //!
  //! QRY PROVIDERS
  //!------------------------------------------------------------------------------
  fetchtempBList(Menulists menudetail) async {
    List<String> urlSplit = menudetail.url.toString().split(";");
    var response = await DioClient.postEncrypt(
        loading: false, urlSplit[0], key: 'lmm', {});
    tampBmodel.value = response
        .map<ProviderTempBModel>((json) => ProviderTempBModel.fromJson(json))
        .toList();
  }

  //!
  //! QRY RECENT
  //!------------------------------------------------------------------------------
  fetchrecent(Menulists menudetail) async {
    List<String> urlSplit = menudetail.url.toString().split(";");
    var response = await DioClient.postEncrypt(
        loading: false,
        urlSplit[3],
        {
          "Msisdn": storage.read('msisdn'),
          "ProviderID": tempBdetail.value.providerID
        },
        key: 'lmm');
    recenttampB.value = response
        .map<RecentTempBModel>((json) => RecentTempBModel.fromJson(json))
        .toList();
  }

  //!
  //! VERIFY ACCOUNT
  //!------------------------------------------------------------------------------
  verifyAcc(String accNo, Menulists menudetail) async {
    List<String> urlSplit = menudetail.url.toString().split(";");
    rxTransID.value = menudetail.description.toString() +
        await randomNumber().fucRandomNumber();
    String leasID = tempBdetail.value.leasID.toString();
    String providerID = tempBdetail.value.providerID.toString();
    var url = urlSplit[1];
    var data = {
      "TranID": rxTransID.value,
      "leasid": leasID,
      "Acc": accNo,
      "ProviderID": providerID
    };
    var response = await DioClient.postEncrypt(url, data, key: 'lmm');
    logVerify = response;
    if (response['ResultCode'] == "200") {
      rxAccNo.value = response['Acc'];
      rxAccName.value = response['Name'];
      rxDebit.value = response['Amount'];
      enableBottom.value = true;
      //? save log verify account
      Get.to(() => PaymentTempBScreen());
    } else {
      enableBottom.value = true;
      DialogHelper.showErrorDialogNew(
          description: response['ResultDesc'] ?? "Unknown error occurred");
    }
  }

  // Future<void> debitProcess(String accNumber) async {
  //   try {
  //     rxTransID.value =
  //         "${homeController.menudetail.value.description!}${await randomNumber().fucRandomNumber()}";
  //     final urlSplit = homeController.menudetail.value.url?.split(";") ?? [];
  //     final apiUrl = urlSplit[1];
  //     final payload = {
  //       "TransactionID": "",
  //       "PhoneUser": storage.read('msisdn'),
  //       "AccNo": accNumber,
  //       "EWid": tempBdetail.value.eWid,
  //       "Remark": "",
  //     };
  //     final response = await DioClient.postEncrypt(apiUrl, payload, key: 'lmm');
  //     if (response['ResultCode'] == "200") {
  //       rxAccName.value = response['AccName'] ?? "Unknown";
  //       rxAccNo.value = accNumber;
  //       rxDebit.value = response['Debit'] ?? 0;
  //       rxFee.value = tempBdetail.value.fee!;
  //       Get.to(() => PaymentTempBScreen());
  //     } else {
  //       // Show error dialog with the result description
  //       DialogHelper.showErrorDialogNew(
  //           description: response['ResultDesc'] ?? "Unknown error occurred");
  //     }
  //   } catch (e, stackTrace) {
  //     print("Error in debitProcess: $e");
  //     print("StackTrace: $stackTrace");
  //   }
  // }

  //!
  //! PAYMENT
  //!------------------------------------------------------------------------------
  paymentProcess(Menulists menudetail) async {
    if (userController.totalBalance.value >= int.parse(rxPaymentAmount.value)) {
      var data;
      var url;
      var response;
      rxFee.value = tempBdetail.value.fee.toString();
      //! Confirm CashOut
      if (await paymentController.confirmCashOut()) {
        //! Insert DB
        List<String> urlSplit = menudetail.url.toString().split(";");
        url = urlSplit[2];
        data = {
          "TranID": rxTransID.value,
          "ProviderID": tempBdetail.value.providerID.toString(),
          "leasid": tempBdetail.value.leasID.toString(),
          "Acc": rxAccNo.value,
          "AccName": rxAccName.value,
          "Amount": int.parse(rxPaymentAmount.value).toStringAsFixed(0),
          "PhoneUser": storage.read('msisdn'),
          "Remark": rxNote.value,
          "Name_Code": tempBdetail.value.nameCode.toString(),
          "Fee": tempBdetail.value.fee
        };
        response = await DioClient.postEncrypt(url, data, key: 'lmm');
        //! save log
        await saveLogPayment(data, response);
        if (response['ResultCode'] == '200') {
          //? save parameter to result screen
          rxTimeStamp.value = response['CreateDate'];
          rxPaymentAmount.value = response['Amount'];
          enableBottom.value = true;
          // Get.to(() => const ResultTempBscreen());
          Get.to(ReusableResultScreen(
            fromAccountImage:
                userController.userProfilemodel.value.profileImg ??
                    MyConstant.profile_default,
            fromAccountName: userController.profileName.value,
            fromAccountNumber: userController.rxMsisdn.value,
            toAccountImage: MyConstant.profile_default,
            toAccountName: rxAccName.value,
            toAccountNumber: rxAccNo.value,
            toTitleProvider: '',
            amount: rxPaymentAmount.toString(),
            fee: fn.format(double.parse(rxFee.value)),
            transactionId: rxTransID.value,
            note: rxNote.value,
            timestamp: rxTimeStamp.value,
          ));
        } else {
          enableBottom.value = true;
          DialogHelper.showErrorWithFunctionDialog(
              description: response['ResultDesc'],
              onClose: () {
                Get.close(userController.pageclose.value + 1);
              });
        }
      }
    } else {
      enableBottom.value = true;
      //! balance < payment
      DialogHelper.showErrorDialogNew(description: 'Your balance not enough.');
    }
  }

  Future<void> saveLogPayment(data, response) async {
    logPaymentReq = data;
    logPaymentRes = response;
    await logController.insertAllLog(
      homeController.menudetail.value.groupNameEN.toString(),
      rxTransID.value,
      tempBdetail.value.logo,
      tempBdetail.value.nameCode!,
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
  }

  //!
  //! PAYMENT BY VISA MASTERCARD
  //!------------------------------------------------------------------------------
  paymentProcessVisa(
    Menulists menudetail,
    String storedCardUniqueID,
    String cvvCode,
    String paymentType,
    String logo,
    String accName,
    String cardNumber,
  ) async {
    var data;
    var url;
    var response;
    rxFee.value = tempBdetail.value.fee.toString();
    rxTransID.value =
        "XX${homeController.menudetail.value.description! + await randomNumber().fucRandomNumber()}";
    //! Confirm CashOut
    if (await paymentController.paymentByVisaMasterCard(
      rxTransID.value,
      rxNote.value,
      rxPaymentAmount.value,
      storedCardUniqueID,
      cvvCode,
    )) {
      //! Insert DB
      List<String> urlSplit = menudetail.url.toString().split(";");
      url = urlSplit[2];
      data = {
        "TranID": rxTransID.value,
        "ProviderID": tempBdetail.value.providerID.toString(),
        "leasid": tempBdetail.value.leasID.toString(),
        "Acc": rxAccNo.value,
        "AccName": rxAccName.value,
        "Amount": int.parse(rxPaymentAmount.value).toStringAsFixed(0),
        "PhoneUser": storage.read('msisdn'),
        "Remark": rxNote.value,
        "Name_Code": tempBdetail.value.nameCode.toString(),
        "Fee": tempBdetail.value.fee
      };
      response = await DioClient.postEncrypt(url, data, key: 'lmm');
      //! save log
      await saveLogPayment(data, response);
      if (response['ResultCode'] == '200') {
        //? save parameter to result screen
        rxTimeStamp.value = response['CreateDate'];
        rxPaymentAmount.value = response['Amount'];
        enableBottom.value = true;
        // Get.to(() => const ResultTempBscreen());
        Get.to(ReusableResultScreen(
          fromAccountImage: paymentType == 'MMONEY'
              ? (userController.userProfilemodel.value.profileImg ??
                  MyConstant.profile_default)
              : logo,
          fromAccountName: paymentType == 'MMONEY'
              ? userController.profileName.value
              : accName,
          fromAccountNumber: paymentType == 'MMONEY'
              ? userController.rxMsisdn.value
              : cardNumber,
          toAccountImage: MyConstant.profile_default,
          toAccountName: rxAccName.value,
          toAccountNumber: rxAccNo.value,
          toTitleProvider: '',
          amount: rxPaymentAmount.toString(),
          fee: fn.format(double.parse(rxFee.value)),
          transactionId: rxTransID.value,
          note: rxNote.value,
          timestamp: rxTimeStamp.value,
        ));
      } else {
        enableBottom.value = true;
        DialogHelper.showErrorWithFunctionDialog(
          description: response['ResultDesc'],
          onClose: () {
            Get.close(userController.pageclose.value + 1);
          },
        );
      }
    } else {
      enableBottom.value = true;
    }
  }

  //!
  //! PAYMENT BY VISA MASTERCARD
  //!------------------------------------------------------------------------------
  // paymentProcessVisaWithoutstoredCardUniqueID(Menulists menudetail) async {
  //   var data;
  //   var url;
  //   var response;
  //   rxFee.value = tempBdetail.value.fee.toString();

  //   //! Insert DB
  //   List<String> urlSplit = menudetail.url.toString().split(";");
  //   url = urlSplit[2];
  //   data = {
  //     "TranID": rxTransID.value,
  //     "ProviderID": tempBdetail.value.providerID.toString(),
  //     "leasid": tempBdetail.value.leasID.toString(),
  //     "Acc": rxAccNo.value,
  //     "AccName": rxAccName.value,
  //     "Amount": int.parse(rxPaymentAmount.value).toStringAsFixed(0),
  //     "PhoneUser": storage.read('msisdn'),
  //     "Remark": rxNote.value,
  //     "Name_Code": tempBdetail.value.nameCode.toString(),
  //     "Fee": tempBdetail.value.fee
  //   };
  //   response = await DioClient.postEncrypt(url, data, key: 'lmm');
  //   //! save log
  //   await saveLogPayment(data, response);
  //   if (response['ResultCode'] == '200') {
  //     //? save parameter to result screen
  //     rxTimeStamp.value = response['CreateDate'];
  //     rxPaymentAmount.value = response['Amount'];
  //     enableBottom.value = true;
  //     Get.to(() => const ResultTempBscreen());
  //   } else {
  //     enableBottom.value = true;
  //     DialogHelper.showErrorWithFunctionDialog(
  //       description: response['ResultDesc'],
  //       onClose: () {
  //         Get.close(userController.pageclose.value + 1);
  //       },
  //     );
  //   }
  // }
}
