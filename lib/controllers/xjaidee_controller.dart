// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/controllers/log_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/models/xjaidee_model.dart';
import 'package:super_app/utility/dialog_helper.dart';
import '../services/api/dio_client.dart';
import 'home_controller.dart';

class XjaideeController extends GetxController {
  final storage = GetStorage();
  final userController = Get.find<UserController>();
  final paymentController = Get.find<PaymentController>();
  final logController = LogController();
  final HomeController homeController = Get.find();

  RxList<LoanModel> LoanModels = <LoanModel>[].obs;
  Rx<LoanModel> LoanModelDetail = LoanModel().obs;
  RxList<dynamic> loanHistory = <dynamic>[].obs;
  RxList<dynamic> loanList = <dynamic>[].obs;

  RxDouble balance = 0.0.obs;

  var isLoading = true.obs;

  var paymentAmount = 0.0.obs;
  var percent = '3%'.obs;
  var months = ''.obs;
  var monthlyPayment = 0.0.obs;

  RxString rxEmpID = ''.obs;
  RxString rxName = ''.obs;
  RxString rxSurname = ''.obs;
  RxString rxMsisdn = ''.obs;
  RxString rxDepartment = ''.obs;
  RxString rxSection = ''.obs;
  RxString rxDOB = ''.obs;
  RxString rxSWD = ''.obs;
  RxString rxImg = ''.obs;
  RxString rxBalance = ''.obs;
  RxString rxContact = ''.obs;
  RxString rxDescription = ''.obs;

  //!
  //! QRY RECENT
  //!------------------------------------------------------------------------------
  // fetchrecent(Menulists menudetail) async {
  //   List<String> urlSplit = menudetail.url.toString().split(";");
  //   var response = await DioClient.postEncrypt(
  //       loading: false,
  //       urlSplit[3],
  //       {
  //         "Msisdn": storage.read('msisdn'),
  //         "ProviderID": tempBdetail.value.providerID
  //       },
  //       key: 'lmm');
  //   recenttampB.value = response
  //       .map<RecentTempBModel>((json) => RecentTempBModel.fromJson(json))
  //       .toList();
  // }

  fetchDetails() async {
    var url = "http://localhost:4100/api/GetDataUsers";
    var data = {
      "msisdn": userController.rxMsisdn.value,
    };
    var response = await DioClient.post(url, data);
    LoanModels.value = [LoanModel.fromJson(response['data'])];
    rxEmpID.value = LoanModels.first.employeeID ?? "";
    rxName.value = LoanModels.first.name ?? "";
    rxSurname.value = LoanModels.first.surname ?? "";
    rxMsisdn.value = LoanModels.first.msisdn ?? "";
    rxDepartment.value = LoanModels.first.department ?? "";
    rxSection.value = LoanModels.first.section ?? "";
    rxDOB.value = LoanModels.first.dob ?? "";
    rxSWD.value = LoanModels.first.swd ?? "";
    rxImg.value = LoanModels.first.img ?? "";
    rxBalance.value = LoanModels.first.balance ?? "";
  }

  //   ! Show Menu
  // !------------------------------------------------------------------------------
  ShowMenu() async {
    var url = "http://localhost:4100/api/CheckApprove";
    var data = {
      "msisdn": userController.rxMsisdn.value,
    };
    var response = await DioClient.post(url, data);
    if (response['status'] == true) {
      return true;
    } else {
      return false;
    }
  }

  //   ! Show Menu
  // !------------------------------------------------------------------------------
  CheckCredit() async {
    var url = "http://localhost:4100/api/CheckCredit";
    var data = {
      "msisdn": userController.rxMsisdn.value,
    };
    var response = await DioClient.post(url, data);
    if (response['status'] == true) {
      balance.value = double.tryParse(response["balance"].toString()) ?? 0.0;
      return true;
    } else {
      return false;
    }
  }

  //   ! Save Info
  // !------------------------------------------------------------------------------
  SaveInfo() async {
    var url = "http://localhost:4100/api/Credit";
    var data = {
      "amount": paymentAmount.value,
      "month_to_repay": months.value,
      "monthly_payment": monthlyPayment.value,
      "msisdn": rxMsisdn.value,
      "emp_id": rxEmpID.value,
      "name": rxName.value,
      "surname": rxSurname.value,
      "tel": rxContact.value,
      "department": rxDepartment.value,
      "section": rxSection.value,
      "date_of_birth": rxDOB.value,
      "start_work_date": rxSWD.value,
      "img": rxImg.value,
      "description": rxDescription.value,
    };
    var response = await DioClient.post(url, data);
    if (response['status'] == true) {
      DialogHelper.showSuccessDialog(
          // onClose: () => DialogHelper.hide(),
          description: "ທ່ານໄດ້ກູ້ຢືມສິນເຊື່ອສຳເລັດ",
          description1: "ກະລຸນາລໍຖ້າຫົວຫນ້າຂອງທ່ານອານຸມັດ");
    }
  }

  //   ! Save Info
  // !------------------------------------------------------------------------------
  FetchHistory() async {
    var url = "http://localhost:4100/api/HistoryCredit";
    var data = {
      "msisdn": userController.rxMsisdn.value,
    };
    var response = await DioClient.post(url, data);
    if (response['status'] == true) {
      loanHistory.assignAll(response['data']); // Update loan history
    } else {
      print("1");
    }
  }

  //   ! Save Info
  // !------------------------------------------------------------------------------
  FetchListloan() async {
    try {
      isLoading.value = true;
      await Future.delayed(
          Duration(milliseconds: 100)); // Delay to prevent UI rebuild issue
      var url = "http://localhost:4100/api/ShowApproveCredit";
      var response = await DioClient.post(url, null);

      if (response['status'] == true) {
        loanList
            .assignAll(response['data']); // Updates the list after UI builds
      } else {
        print("Error: ${response['message']}");
      }
    } catch (e) {
      print("Request failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //!
  //! PAYMENT
  //!------------------------------------------------------------------------------
  // paymentProcess(Menulists menudetail) async {
  //   if (userController.totalBalance.value >= int.parse(rxPaymentAmount.value)) {
  //     var data;
  //     var url;
  //     var response;
  //     rxFee.value = tempBdetail.value.fee.toString();
  //     //! Confirm CashOut
  //     if (await paymentController.confirmCashOut()) {
  //       //! Insert DB
  //       List<String> urlSplit = menudetail.url.toString().split(";");
  //       url = urlSplit[2];
  //       data = {
  //         "TranID": rxTransID.value,
  //         "ProviderID": tempBdetail.value.providerID.toString(),
  //         "leasid": tempBdetail.value.leasID.toString(),
  //         "Acc": rxAccNo.value,
  //         "AccName": rxAccName.value,
  //         "Amount": int.parse(rxPaymentAmount.value).toStringAsFixed(0),
  //         "PhoneUser": storage.read('msisdn'),
  //         "Remark": rxNote.value,
  //         "Name_Code": tempBdetail.value.nameCode.toString(),
  //         "Fee": tempBdetail.value.fee
  //       };
  //       response = await DioClient.postEncrypt(url, data, key: 'lmm');
  //       //! save log
  //       await saveLogPayment(data, response);
  //       if (response['ResultCode'] == '200') {
  //         //? save parameter to result screen
  //         rxTimeStamp.value = response['CreateDate'];
  //         rxPaymentAmount.value = response['Amount'];
  //         enableBottom.value = true;
  //         Get.to(() => const ResultTempBscreen());
  //       } else {
  //         enableBottom.value = true;
  //         DialogHelper.showErrorWithFunctionDialog(
  //             description: response['ResultDesc'],
  //             onClose: () {
  //               Get.close(userController.pageclose.value + 1);
  //             });
  //       }
  //     }
  //   } else {
  //     enableBottom.value = true;
  //     //! balance < payment
  //     DialogHelper.showErrorDialogNew(description: 'Your balance not enough.');
  //   }
  // }

  // Future<void> saveLogPayment(data, response) async {
  //   logPaymentReq = data;
  //   logPaymentRes = response;
  //   await logController.insertAllLog(
  //     homeController.menudetail.value.groupNameEN.toString(),
  //     rxTransID.value,
  //     tempBdetail.value.logo,
  //     tempBdetail.value.nameCode!,
  //     rxAccNo.value,
  //     rxAccName.value,
  //     rxPaymentAmount.value,
  //     0,
  //     rxFee.value,
  //     rxNote.value,
  //     logVerify,
  //     logPaymentReq,
  //     logPaymentRes,
  //   );
  // }
}
