// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/models/ticket/TicketHistoryModel.dart';
import 'package:super_app/models/ticket/TicketListsModel.dart';
import 'package:super_app/services/api/dio_client.dart';
import 'package:intl/intl.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/widget/reusableResultWithCode.dart';
import '../utility/dialog_helper.dart';
import 'log_controller.dart';

class TicketController extends GetxController {
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final logController = LogController();
  final paymentController = Get.put(PaymentController());
  final storage = GetStorage();

  RxList<TicketListsModel> ticketLists = RxList();
  Rx<TicketListsModel> ticketDetail = TicketListsModel().obs;
  RxList<TicketHistoryModel> historyLists = RxList();

  RxString rxTransID = ''.obs;
  RxString rxTimeStamp = ''.obs;
  RxString rxFee = ''.obs;
  RxString rxPaymentAmount = ''.obs;
  RxString rxNote = ''.obs;
  RxString rxticketCode = ''.obs;

  var logPaymentReq;
  var logPaymentRes;

  @override
  clear() {
    ticketLists = <TicketListsModel>[].obs;
    ticketDetail = TicketListsModel().obs;
    historyLists = <TicketHistoryModel>[].obs;
    rxTransID = ''.obs;
    rxTimeStamp = ''.obs;
    rxFee = ''.obs;
    rxPaymentAmount = ''.obs;
    rxNote = ''.obs;
    rxticketCode = ''.obs;

    logPaymentReq = null;
    logPaymentRes = null;
  }

  fetchTicketLists() async {
    List<String> urlSplit =
        homeController.menudetail.value.url.toString().split(";");
    var response = await DioClient.postEncrypt(urlSplit[0], {}, loading: false);
    ticketLists.value = response
        .map<TicketListsModel>((json) => TicketListsModel.fromJson(json))
        .toList();
    // ticketLists.value = dataTest
    //     .map<TicketListsModel>((json) => TicketListsModel.fromJson(json))
    //     .toList();
  }

  fetchTicketHistory() async {
    List<String> urlSplit =
        homeController.menudetail.value.url.toString().split(";");

    print(urlSplit);
    var response = await DioClient.postEncrypt(loading: false, urlSplit[2], {
      "msisdn": storage.read('msisdn'),
    });
    print(response);
    // print('xxxxxx ${response.toString()}');
    if (response != null) {
      historyLists.value = response
          .map<TicketHistoryModel>((json) => TicketHistoryModel.fromJson(json))
          .toList();
    }
  }

  paymentProcess() async {
    userController.fetchBalance();
    if (userController.mainBalance.value >= ticketDetail.value.price!) {
      var data;
      var url;
      var response;
      rxFee.value = '0';

      //? cashout from wallet
      response = await paymentController.cashoutWallet(
        rxTransID.value,
        ticketDetail.value.price,
        '0',
        homeController.menudetail.value.groupNameEN.toString(),
        '',
        ticketDetail.value.title,
        '',
        homeController.menudetail.value.groupNameEN.toString(),
      );

      if (response["resultCode"] == 0) {
        // //? Insert DB
        List<String> urlSplit =
            homeController.menudetail.value.url.toString().split(";");
        url = urlSplit[1];
        data = {
          "TranID": rxTransID.value,
          "weid": ticketDetail.value.tickid,
          "amount": ticketDetail.value.price,
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
          ticketDetail.value.price.toString(),
          0,
          '0',
          ticketDetail.value.title,
          null,
          logPaymentReq,
          logPaymentRes,
        );
        if (response['ResultCode'] == '200') {
          rxticketCode.value = response["Code"].toString();
          rxPaymentAmount.value = response['Price'].toString();
          rxTimeStamp.value =
              DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
          Get.to(ReusableResultWithCode(
            fromAccountImage:
                userController.userProfilemodel.value.profileImg ??
                    MyConstant.profile_default,
            fromAccountName: userController.profileName.value,
            fromAccountNumber: userController.rxMsisdn.value,
            toAccountImage:
                ticketDetail.value.logo ?? MyConstant.profile_default,
            toAccountName: ticketDetail.value.title!,
            toAccountNumber: ticketDetail.value.title!,
            amount: ticketDetail.value.price.toString(),
            fee: rxFee.toString(),
            transactionId: rxTransID.value,
            timestamp: rxTimeStamp.value,
            code: rxticketCode.value,
            fromHistory: false,
          ));
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
      //! balance < payment
      DialogHelper.showErrorDialogNew(description: 'Your balance not enough.');
    }
  }
}
