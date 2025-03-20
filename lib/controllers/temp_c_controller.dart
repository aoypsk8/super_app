// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/controllers/log_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/models/PackageTempCModel.dart';
import 'package:super_app/models/PrepiadTempCModel.dart';
import 'package:super_app/models/providerTempCModel.dart';
import 'package:super_app/models/serviceTempCModel.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/reusable_template/reusable_result.dart';
import 'package:super_app/views/templateC/package/PackageListScreen.dart';
import 'package:super_app/views/templateC/postpaid/PaymentPostpaidTempCScreen.dart';
import '../services/helper/random.dart';
import '../models/menu_model.dart';
import '../services/api/dio_client.dart';
import '../utility/dialog_helper.dart';
import 'home_controller.dart';
import 'package:flutter_cache/flutter_cache.dart' as cache;
import 'package:intl/intl.dart';

class TempCController extends GetxController {
  final storage = GetStorage();
  final userController = Get.find<UserController>();
  final paymentController = Get.put(PaymentController());
  final HomeController homeController = Get.find();
  final logController = Get.put(LogController());

  RxList<ProviderTempCModel> tempCmodel = <ProviderTempCModel>[].obs;
  RxList<ServiceTempCModel> tempCservicemodel = <ServiceTempCModel>[].obs;
  RxList<Packages> tempCpackagemodel = <Packages>[].obs;
  RxList<Topup> tempCprepaidmodel = <Topup>[].obs;

  Rx<ServiceTempCModel> tempCservicedetail = ServiceTempCModel().obs;
  Rx<ProviderTempCModel> tempCdetail = ProviderTempCModel().obs;
  Rx<Packages> tempCpackagedetail = Packages().obs;
  RxString rxgroupTelecom = ''.obs;
  RxBool rxPrepaidShow = false.obs;
  // RxString rxPrepaidAmount = ''.obs;
  RxBool rxPackageShow = false.obs;
  RxString rxPackageName = ''.obs;
  RxString rxAccNo = ''.obs;
  RxString rxAccName = ''.obs;
  RxString rxDebit = ''.obs;
  RxString rxNote = ''.obs;
  RxString rxTransID = ''.obs;
  RxString rxTimeStamp = ''.obs;
  RxString rxService = ''.obs;
  RxInt rxPaymentAmount = 0.obs;
  RxInt rxCouponAmount = 0.obs;
  RxInt rxTotalAmount = 0.obs;

  final RxBool enableBottom = true.obs;

  //? Log
  var logVerify;
  var logPaymentReq;
  var logPaymentRes;

  clear() {
    tempCmodel = <ProviderTempCModel>[].obs;
    tempCservicemodel = <ServiceTempCModel>[].obs;
    tempCpackagemodel = <Packages>[].obs;
    tempCprepaidmodel = <Topup>[].obs;
    tempCdetail = ProviderTempCModel().obs;
    tempCservicedetail = ServiceTempCModel().obs;
    tempCpackagedetail = Packages().obs;
    rxgroupTelecom.value = '';
    rxPrepaidShow.value = false;
    rxPackageShow.value = false;
    rxPackageName.value = '';
    rxAccNo.value = '';
    rxAccName.value = '';
    rxDebit.value = '';
    rxNote.value = '';
    rxTransID.value = '';
    rxTimeStamp.value = '';
    rxService.value = '';
    rxPaymentAmount.value = 0;
    rxCouponAmount.value = 0;
    rxTotalAmount.value = 0;
    logVerify = null;
    logPaymentReq = null;
    logPaymentRes = null;
  }

  //!
  //! QRY OPERATOR
  //!------------------------------------------------------------------------------
  fetchtempCList(Menulists menudetail) async {
    // cache.clear();
    //! check cache exist
    var cacheData = await cache.load('fetchtempCList', null);
    if (cacheData == null) {
      List<String> urlSplit = menudetail.url.toString().split(";");
      var response = await DioClient.postEncrypt(
          loading: false, urlSplit[0], key: 'lmm', {});
      //! save cache 5min
      await cache.remember('fetchtempCList', jsonEncode(response), 60 * 5);
      tempCmodel.value = response
          .map<ProviderTempCModel>((json) => ProviderTempCModel.fromJson(json))
          .toList();
    } else {
      //! load cache
      tempCmodel.value = jsonDecode(cacheData)
          .map<ProviderTempCModel>((json) => ProviderTempCModel.fromJson(json))
          .toList();
    }
  }

  //!
  //! QRY SERVICES
  //!------------------------------------------------------------------------------
  fetchServiceList() async {
    var url = "/Telecom/getServiceList";
    var data = {"GroupTelecom": rxgroupTelecom.value};
    var response =
        await DioClient.postEncrypt(loading: false, url, data, key: 'lmm');
    print(response);
    tempCservicemodel.value = response
        .map<ServiceTempCModel>((json) => ServiceTempCModel.fromJson(json))
        .toList();
  }

  //!
  //! VERIFY ACCOUNT
  //!------------------------------------------------------------------------------
  verifyAcc(String accNo) async {
    // final creditcardController = Get.find<CreditcardController>();
    rxTransID.value = homeController.menudetail.value.description! +
        await randomNumber().fucRandomNumber();
    rxAccNo.value = accNo;
    List<String> urlSplit = tempCservicedetail.value.url.toString().split(";");
    var url = urlSplit[0];
    rxService.value = tempCservicedetail.value.name.toString();
    var data = {
      "msisdn": accNo,
      "tranID": rxTransID.value,
      "type": rxService.value,
    };
    var response = await DioClient.postEncrypt(url, data, key: 'lmm');
    // await creditcardController.checkVisaPayment();
    if (response['ResultCode'] == "200") {
      if (rxService.value == "PREPAID") {
        rxAccName.value = "";
        rxPrepaidShow.value = true;
        enableBottom.value = true;
        tempCprepaidmodel.value = response['Topup']
            .map<Topup>((json) => Topup.fromJson(json))
            .toList();
      } else if (rxService.value == "PACKAGE") {
        rxAccName.value = "";
        rxPackageShow.value = true;
        tempCpackagemodel.value = response['Packages']
            .map<Packages>((json) => Packages.fromJson(json))
            .toList();
        enableBottom.value = true;
        Get.to(() => const PackageListScreen());
      } else {
        enableBottom.value = true;
        logVerify = response;
        rxAccName.value = response['Name'].toString();
        rxDebit.value = response['Balance'].toString();
        rxCouponAmount.value = 0;
        rxPaymentAmount.value = 0;
        rxTotalAmount.value = 0;
        Get.to(() => const PaymentPostpaidTempCScreen());
      }
    } else {
      enableBottom.value = true;
      rxCouponAmount.value = 0;
      rxPaymentAmount.value = 0;
      rxTotalAmount.value = 0;
      rxPrepaidShow.value = false;
      rxPackageShow.value = false;
      DialogHelper.showErrorDialogNew(description: response['ResultDesc']);
    }
  }

  //!
  //! POSTPAID
  //!------------------------------------------------------------------------------
  paymentPostpaid(Menulists menudetail) async {
    if (userController.totalBalance.value >= rxPaymentAmount.value) {
      var data;
      var url;
      var response;
      //! Confirm CashOut
      if (await paymentController.confirmCashOut()) {
        //! Insert DB
        List<String> urlSplit =
            tempCservicedetail.value.url.toString().split(";");
        var url = urlSplit[1];
        var data = {
          "PhoneUser": storage.read('msisdn'),
          "msisdn": rxAccNo.value,
          "tranID": rxTransID.value,
          "type": tempCservicedetail.value.name.toString(),
          "amount": rxTotalAmount.value.toStringAsFixed(0),
          "discount": tempCdetail.value.discount.toString(),
          "operator": tempCdetail.value.groupTelecom.toString(),
          "name": rxAccName.value
        };
        response = await DioClient.postEncrypt(url, data, key: 'lmm');
        //! save log
        await saveLogPostpaid(data, response);

        if (response['ResultCode'] == '200') {
          rxTimeStamp.value = response['Created'];
          rxPaymentAmount.value = int.parse(response['Amount']);
          saveHistoryMobile(rxAccNo.value, rxService.value);
          enableBottom.value = true;
          Get.to(
            ReusableResultScreen(
              fromAccountImage:
                  userController.userProfilemodel.value.profileImg ??
                      MyConstant.profile_default,
              fromAccountName: userController.profileName.value,
              fromAccountNumber: userController.rxMsisdn.value,
              toAccountImage: tempCdetail.value.groupLogo.toString(),
              toAccountName:
                  '${rxAccName.value} - ${tempCdetail.value.groupTelecom} - ${tempCservicedetail.value.name}',
              toAccountNumber: rxAccNo.value,
              amount: rxPaymentAmount.value.toString(),
              fee: '0',
              note: rxNote.value,
              toTitleProvider: '',
              transactionId: rxTransID.value,
              timestamp: rxTimeStamp.value,
            ),
          );
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

  Future<void> saveLogPostpaid(Map<String, dynamic> data, response) async {
    logPaymentReq = data;
    logPaymentRes = response;
    await logController.insertAllLog(
      homeController.menudetail.value.groupNameEN.toString(),
      rxTransID.value,
      tempCdetail.value.groupLogo,
      '${rxgroupTelecom.value}_${rxService.value}',
      rxAccNo.value,
      rxAccName.value,
      rxTotalAmount.value,
      rxCouponAmount.value,
      '',
      rxNote.value,
      logVerify,
      logPaymentReq,
      logPaymentRes,
    );
  }

  //!
  //! PREPAID
  //!------------------------------------------------------------------------------
  paymentPrepaid(Menulists menudetail) async {
    if (userController.totalBalance.value >= rxTotalAmount.value) {
      var data;
      var url;
      var response;
      //! Confirm CashOut
      if (await paymentController.confirmCashOut()) {
        //! Insert DB
        List<String> urlSplit =
            tempCservicedetail.value.url.toString().split(";");
        var url = urlSplit[1];
        var data = {
          "PhoneUser": storage.read('msisdn'),
          "msisdn": rxAccNo.value,
          "tranID": rxTransID.value,
          "type": tempCservicedetail.value.name.toString(),
          "amount": rxTotalAmount.value.toStringAsFixed(0),
          "discount": tempCdetail.value.discount.toString(),
          "operator": tempCdetail.value.groupTelecom.toString(),
        };
        response = await DioClient.postEncrypt(url, data, key: 'lmm');
        //! save log
        await saveLogPrepaid(data, response);
        if (response['ResultCode'] == '200') {
          rxTimeStamp.value = response['Created'];
          rxPaymentAmount.value = int.parse(response['Amount']);
          saveHistoryMobile(rxAccNo.value, rxService.value);
          enableBottom.value = true;

          Get.off(ReusableResultScreen(
            fromAccountImage:
                userController.userProfilemodel.value.profileImg ??
                    MyConstant.profile_default,
            fromAccountName: userController.profileName.value,
            fromAccountNumber: userController.rxMsisdn.value,
            toAccountImage: MyConstant.profile_default,
            toAccountName: tempCservicedetail.value.description.toString(),
            toAccountNumber: rxAccNo.value,
            toTitleProvider: '',
            amount: rxPaymentAmount.value.toString(),
            fee: '0',
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
      } else {
        enableBottom.value = true;
        DialogHelper.showErrorDialogNew(
            description: 'Your coupon amount not enough.');
      }
    } else {
      enableBottom.value = true;
      DialogHelper.showErrorDialogNew(description: 'Your balance not enough.');
    }
  }

  Future<void> saveLogPrepaid(Map<String, dynamic> data, response) async {
    logPaymentReq = data;
    logPaymentRes = response;
    await logController.insertAllLog(
      homeController.menudetail.value.groupNameEN.toString(),
      rxTransID.value,
      tempCdetail.value.groupLogo,
      '${rxgroupTelecom.value}_${rxService.value}',
      rxAccNo.value,
      rxAccName.value,
      rxTotalAmount.value,
      rxCouponAmount.value,
      '',
      rxNote.value,
      logVerify,
      logPaymentReq,
      logPaymentRes,
    );
  }

  //!
  //! PACKAGE
  //!------------------------------------------------------------------------------
  paymentPackage(Menulists menudetail) async {
    if (userController.totalBalance.value >= rxTotalAmount.value) {
      var data;
      var url;
      var response;
      if (await paymentController.confirmCashOut()) {
        //! Insert DB
        List<String> urlSplit =
            tempCservicedetail.value.url.toString().split(";");
        var url = urlSplit[1];

        var data = {
          "PhoneUser": storage.read('msisdn'),
          "phoneType": tempCpackagedetail.value.typeName.toString(),
          "type": tempCservicedetail.value.name.toString(),
          "msisdn": rxAccNo.value,
          "tranID": rxTransID.value,
          "massage": tempCpackagedetail.value.description.toString(),
          "amount": rxTotalAmount.value.toStringAsFixed(0),
          "Pk_code": tempCpackagedetail.value.pKCode.toString(),
          "discount": tempCdetail.value.discount.toString(),
          "operator": tempCpackagedetail.value.operator.toString()
        };
        response = await DioClient.postEncrypt(url, data, key: 'lmm');
        //! save log
        await saveLogPackage(data, response);
        if (response['ResultCode'] == '200') {
          rxTimeStamp.value = response['Created'];
          rxPaymentAmount.value = int.parse(response['Amount']);
          saveHistoryMobile(rxAccNo.value, rxService.value);
          // Get.to(() => const ResultPackageTempCScreen());
          enableBottom.value = true;
          Get.to(ReusableResultScreen(
            fromAccountImage:
                userController.userProfilemodel.value.profileImg ??
                    MyConstant.profile_default,
            fromAccountName: userController.profileName.value,
            fromAccountNumber: userController.rxMsisdn.value,
            toAccountImage: MyConstant.profile_default,
            toAccountName: tempCpackagedetail.value.packageName!,
            toAccountNumber:
                '${tempCpackagedetail.value.packageValue} | ${tempCpackagedetail.value.userDay} Day',
            toTitleProvider: '',
            amount: rxPaymentAmount.toString(),
            fee: '0',
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
      } else {
        enableBottom.value = true;
        DialogHelper.showErrorDialogNew(
            description: 'Your coupon amount not enough.');
      }
    } else {
      enableBottom.value = true;
      DialogHelper.showErrorDialogNew(description: 'Your balance not enough.');
    }
  }

  Future<void> saveLogPackage(Map<String, dynamic> data, response) async {
    logPaymentReq = data;
    logPaymentRes = response;
    logController.insertAllLog(
      homeController.menudetail.value.groupNameEN.toString(),
      rxTransID.value,
      tempCdetail.value.groupLogo,
      '${rxgroupTelecom.value}_${rxService.value}',
      rxAccNo.value,
      rxAccName.value,
      rxTotalAmount.value,
      rxCouponAmount.value,
      '',
      rxNote.value,
      logVerify,
      logPaymentReq,
      logPaymentRes,
    );
  }

  void saveHistoryMobile(String msisdn, String mobileType) async {
    final box = GetStorage();
    String? myDataString = box.read('historyMobile');

    if (myDataString == null) {
      var myData0 = [
        {
          'timeStamp': DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now()),
          'msisdn': msisdn,
          'mobileType': mobileType,
          'favorite': 0,
        }
      ];
      await box.write('historyMobile', json.encode(myData0));
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
          'mobileType': mobileType,
          'favorite': 0,
        });
      }
      await box.write('historyMobile', json.encode(myData));
    }
  }

  //!
  //! VISA - MASTER CARD PACKAGE
  //!------------------------------------------------------------------------------
  paymentPackageVisa(
      Menulists menudetail, String storedCardUniqueID, String cvvCode) async {
    var data;
    var url;
    var response;
    rxTransID.value =
        "XX${homeController.menudetail.value.description! + await randomNumber().fucRandomNumber()}";
    if (await paymentController.paymentByVisaMasterCard(
      rxTransID.value,
      tempCpackagedetail.value.description.toString(),
      rxTotalAmount.value,
      storedCardUniqueID,
      cvvCode,
    )) {
      //! Insert DB
      List<String> urlSplit =
          tempCservicedetail.value.url.toString().split(";");
      var url = urlSplit[1];

      var data = {
        "PhoneUser": storage.read('msisdn'),
        "phoneType": tempCpackagedetail.value.typeName.toString(),
        "type": tempCservicedetail.value.name.toString(),
        "msisdn": rxAccNo.value,
        "tranID": rxTransID.value,
        "massage": tempCpackagedetail.value.description.toString(),
        "amount": rxTotalAmount.value.toStringAsFixed(0),
        "Pk_code": tempCpackagedetail.value.pKCode.toString(),
        "discount": tempCdetail.value.discount.toString(),
        "operator": tempCpackagedetail.value.operator.toString()
      };
      response = await DioClient.postEncrypt(url, data, key: 'lmm');
      //! save log
      await saveLogPackage(data, response);
      if (response['ResultCode'] == '200') {
        rxTimeStamp.value = response['Created'];
        rxPaymentAmount.value = int.parse(response['Amount']);
        saveHistoryMobile(rxAccNo.value, rxService.value);
        enableBottom.value = true;
        Get.to(ReusableResultScreen(
          isUSD: true,
          fromAccountImage: userController.userProfilemodel.value.profileImg ??
              MyConstant.profile_default,
          fromAccountName: userController.profileName.value,
          fromAccountNumber: userController.rxMsisdn.value,
          toAccountImage: MyConstant.profile_default,
          toAccountName: tempCpackagedetail.value.packageName!,
          toAccountNumber:
              '${tempCpackagedetail.value.packageValue} | ${tempCpackagedetail.value.userDay} Day',
          toTitleProvider: '',
          amount: rxPaymentAmount.toString(),
          fee: '0',
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
    } else {
      enableBottom.value = true;
    }
  }

  //!
  //! VISA - MASTER CARD PACKAGE WithoutstoredCardUniqueID
  //!------------------------------------------------------------------------------
  // paymentPackageVisaWithoutstoredCardUniqueID(Menulists menudetail) async {
  //   var response;
  //   //! Insert DB
  //   List<String> urlSplit = tempCservicedetail.value.url.toString().split(";");
  //   var url = urlSplit[1];
  //   var data = {
  //     "PhoneUser": storage.read('msisdn'),
  //     "phoneType": tempCpackagedetail.value.typeName.toString(),
  //     "type": tempCservicedetail.value.name.toString(),
  //     "msisdn": rxAccNo.value,
  //     "tranID": rxTransID.value,
  //     "massage": tempCpackagedetail.value.description.toString(),
  //     "amount": rxTotalAmount.value.toStringAsFixed(0),
  //     "Pk_code": tempCpackagedetail.value.pKCode.toString(),
  //     "discount": tempCdetail.value.discount.toString(),
  //     "operator": tempCpackagedetail.value.operator.toString()
  //   };
  //   response = await DioClient.postEncrypt(url, data, key: 'lmm');
  //   //! save log
  //   await saveLogPackage(data, response);
  //   if (response['ResultCode'] == '200') {
  //     rxTimeStamp.value = response['Created'];
  //     rxPaymentAmount.value = int.parse(response['Amount']);
  //     saveHistoryMobile(rxAccNo.value, rxService.value);
  //     enableBottom.value = true;
  //     Get.to(ReusableResultScreen(
  //       isUSD: true,
  //       fromAccountImage: userController.userProfilemodel.value.profileImg ??
  //           MyConstant.profile_default,
  //       fromAccountName: userController.profileName.value,
  //       fromAccountNumber: userController.rxMsisdn.value,
  //       toAccountImage: MyConstant.profile_default,
  //       toAccountName: tempCpackagedetail.value.packageName!,
  //       toAccountNumber:
  //           '${tempCpackagedetail.value.packageValue} | ${tempCpackagedetail.value.userDay} Day',
  //       toTitleProvider: '',
  //       amount: rxPaymentAmount.toString(),
  //       fee: '0',
  //       transactionId: rxTransID.value,
  //       note: rxNote.value,
  //       timestamp: rxTimeStamp.value,
  //     ));
  //   } else {
  //     enableBottom.value = true;
  //     DialogHelper.showErrorWithFunctionDialog(
  //         description: response['ResultDesc'],
  //         onClose: () {
  //           Get.close(userController.pageclose.value + 1);
  //         });
  //   }
  // }

  //!
  //! VISA - MASTER CARD PREPAID
  //!------------------------------------------------------------------------------
  paymentPrepaidVisa(
      Menulists menudetail, String storedCardUniqueID, String cvvCode) async {
    var data;
    var url;
    var response;
    rxTransID.value =
        "XX${homeController.menudetail.value.description! + await randomNumber().fucRandomNumber()}";
    //! Confirm CashOut
    if (await paymentController.paymentByVisaMasterCard(
      rxTransID.value,
      tempCpackagedetail.value.description.toString(),
      rxTotalAmount.value,
      storedCardUniqueID,
      cvvCode,
    )) {
      //! Insert DB
      List<String> urlSplit =
          tempCservicedetail.value.url.toString().split(";");
      var url = urlSplit[1];
      var data = {
        "PhoneUser": storage.read('msisdn'),
        "msisdn": rxAccNo.value,
        "tranID": rxTransID.value,
        "type": tempCservicedetail.value.name.toString(),
        "amount": rxTotalAmount.value.toStringAsFixed(0),
        "discount": tempCdetail.value.discount.toString(),
        "operator": tempCdetail.value.groupTelecom.toString(),
      };
      response = await DioClient.postEncrypt(url, data, key: 'lmm');
      //! save log
      await saveLogPrepaid(data, response);
      if (response['ResultCode'] == '200') {
        rxTimeStamp.value = response['Created'];
        rxPaymentAmount.value = int.parse(response['Amount']);
        saveHistoryMobile(rxAccNo.value, rxService.value);
        enableBottom.value = true;

        Get.off(ReusableResultScreen(
          isUSD: true,
          fromAccountImage: userController.userProfilemodel.value.profileImg ??
              MyConstant.profile_default,
          fromAccountName: userController.profileName.value,
          fromAccountNumber: userController.rxMsisdn.value,
          toAccountImage: MyConstant.profile_default,
          toAccountName: tempCservicedetail.value.description.toString(),
          toAccountNumber: rxAccNo.value,
          toTitleProvider: '',
          amount: rxPaymentAmount.value.toString(),
          fee: '0',
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
    } else {
      enableBottom.value = true;
    }
  }

  //!
  //! VISA - MASTER CARD PREPAID
  //!------------------------------------------------------------------------------
  // paymentPrepaidVisaWithoutstoredCardUniqueID(Menulists menudetail) async {
  //   var response;

  //   //! Insert DB
  //   List<String> urlSplit = tempCservicedetail.value.url.toString().split(";");
  //   var url = urlSplit[1];
  //   var data = {
  //     "PhoneUser": storage.read('msisdn'),
  //     "msisdn": rxAccNo.value,
  //     "tranID": rxTransID.value,
  //     "type": tempCservicedetail.value.name.toString(),
  //     "amount": rxTotalAmount.value.toStringAsFixed(0),
  //     "discount": tempCdetail.value.discount.toString(),
  //     "operator": tempCdetail.value.groupTelecom.toString(),
  //   };
  //   response = await DioClient.postEncrypt(url, data, key: 'lmm');
  //   //! save log
  //   await saveLogPrepaid(data, response);
  //   if (response['ResultCode'] == '200') {
  //     rxTimeStamp.value = response['Created'];
  //     rxPaymentAmount.value = int.parse(response['Amount']);
  //     saveHistoryMobile(rxAccNo.value, rxService.value);
  //     enableBottom.value = true;

  //     Get.off(ReusableResultScreen(
  //       isUSD: true,
  //       fromAccountImage: userController.userProfilemodel.value.profileImg ??
  //           MyConstant.profile_default,
  //       fromAccountName: userController.profileName.value,
  //       fromAccountNumber: userController.rxMsisdn.value,
  //       toAccountImage: MyConstant.profile_default,
  //       toAccountName: tempCservicedetail.value.description.toString(),
  //       toAccountNumber: rxAccNo.value,
  //       toTitleProvider: '',
  //       amount: rxPaymentAmount.value.toString(),
  //       fee: '0',
  //       transactionId: rxTransID.value,
  //       note: rxNote.value,
  //       timestamp: rxTimeStamp.value,
  //     ));
  //   } else {
  //     enableBottom.value = true;
  //     DialogHelper.showErrorWithFunctionDialog(
  //         description: response['ResultDesc'],
  //         onClose: () {
  //           Get.close(userController.pageclose.value + 1);
  //         });
  //   }
  // }

  //!
  //! POSTPAID
  //!------------------------------------------------------------------------------
  paymentPostpaidVisa(
      Menulists menudetail, String storedCardUniqueID, String cvvCode) async {
    var data;
    var url;
    var response;
    //! Confirm CashOut
    rxTransID.value =
        "XX${homeController.menudetail.value.description! + await randomNumber().fucRandomNumber()}";
    if (await paymentController.paymentByVisaMasterCard(
      rxTransID.value,
      tempCpackagedetail.value.description.toString(),
      rxTotalAmount.value,
      storedCardUniqueID,
      cvvCode,
    )) {
      //! Insert DB
      List<String> urlSplit =
          tempCservicedetail.value.url.toString().split(";");
      var url = urlSplit[1];
      var data = {
        "PhoneUser": storage.read('msisdn'),
        "msisdn": rxAccNo.value,
        "tranID": rxTransID.value,
        "type": tempCservicedetail.value.name.toString(),
        "amount": rxTotalAmount.value.toStringAsFixed(0),
        "discount": tempCdetail.value.discount.toString(),
        "operator": tempCdetail.value.groupTelecom.toString(),
        "name": rxAccName.value
      };
      response = await DioClient.postEncrypt(url, data, key: 'lmm');
      //! save log
      await saveLogPostpaid(data, response);

      if (response['ResultCode'] == '200') {
        rxTimeStamp.value = response['Created'];
        rxPaymentAmount.value = int.parse(response['Amount']);
        saveHistoryMobile(rxAccNo.value, rxService.value);
        enableBottom.value = true;
        Get.to(
          ReusableResultScreen(
            isUSD: true,
            fromAccountImage:
                userController.userProfilemodel.value.profileImg ??
                    MyConstant.profile_default,
            fromAccountName: userController.profileName.value,
            fromAccountNumber: userController.rxMsisdn.value,
            toAccountImage: tempCdetail.value.groupLogo.toString(),
            toAccountName:
                '${rxAccName.value} - ${tempCdetail.value.groupTelecom} - ${tempCservicedetail.value.name}',
            toAccountNumber: rxAccNo.value,
            amount: rxPaymentAmount.value.toString(),
            fee: '0',
            note: rxNote.value,
            toTitleProvider: '',
            transactionId: rxTransID.value,
            timestamp: rxTimeStamp.value,
          ),
        );
      } else {
        enableBottom.value = true;
        DialogHelper.showErrorWithFunctionDialog(
            description: response['ResultDesc'],
            onClose: () {
              Get.close(userController.pageclose.value + 1);
            });
      }
    } else {
      enableBottom.value = true;
    }
  }

  //!
  //! POSTPAID
  //!------------------------------------------------------------------------------
  // paymentPostpaidVisaWithoutstoredCardUniqueID(Menulists menudetail) async {
  //   var response;
  //   //! Insert DB
  //   List<String> urlSplit = tempCservicedetail.value.url.toString().split(";");
  //   var url = urlSplit[1];
  //   var data = {
  //     "PhoneUser": storage.read('msisdn'),
  //     "msisdn": rxAccNo.value,
  //     "tranID": rxTransID.value,
  //     "type": tempCservicedetail.value.name.toString(),
  //     "amount": rxTotalAmount.value.toStringAsFixed(0),
  //     "discount": tempCdetail.value.discount.toString(),
  //     "operator": tempCdetail.value.groupTelecom.toString(),
  //     "name": rxAccName.value
  //   };
  //   response = await DioClient.postEncrypt(url, data, key: 'lmm');
  //   //! save log
  //   await saveLogPostpaid(data, response);

  //   if (response['ResultCode'] == '200') {
  //     rxTimeStamp.value = response['Created'];
  //     rxPaymentAmount.value = int.parse(response['Amount']);
  //     saveHistoryMobile(rxAccNo.value, rxService.value);
  //     enableBottom.value = true;
  //     Get.to(
  //       ReusableResultScreen(
  //         isUSD: true,
  //         fromAccountImage: userController.userProfilemodel.value.profileImg ??
  //             MyConstant.profile_default,
  //         fromAccountName: userController.profileName.value,
  //         fromAccountNumber: userController.rxMsisdn.value,
  //         toAccountImage: tempCdetail.value.groupLogo.toString(),
  //         toAccountName:
  //             '${rxAccName.value} - ${tempCdetail.value.groupTelecom} - ${tempCservicedetail.value.name}',
  //         toAccountNumber: rxAccNo.value,
  //         amount: rxPaymentAmount.value.toString(),
  //         fee: '0',
  //         note: rxNote.value,
  //         toTitleProvider: '',
  //         transactionId: rxTransID.value,
  //         timestamp: rxTimeStamp.value,
  //       ),
  //     );
  //   } else {
  //     enableBottom.value = true;
  //     DialogHelper.showErrorWithFunctionDialog(
  //         description: response['ResultDesc'],
  //         onClose: () {
  //           Get.close(userController.pageclose.value + 1);
  //         });
  //   }
  // }
}
