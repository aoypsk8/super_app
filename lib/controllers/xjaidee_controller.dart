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
import '../views/x-jaidee/input_amountScreen.dart';
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

  //   ! Check credit
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

  //   ! Check can or cant
  // !------------------------------------------------------------------------------
  CheckPayment() async {
    var url = "http://localhost:4100/api/CheckPayment";
    var data = {
      "msisdn": userController.rxMsisdn.value,
    };
    var response = await DioClient.post(url, data);
    if (response['status'] == true) {
      DialogHelper.showDialogPolicy(
        title: "Policy",
        description:
            "1. Registration is required to register through the mobile phone number of the customer who registered in accordance with the rules to open an M-Money wallet account, which has to be active and reachable. Users can register to use:\n • Register and fill in the information, KYC manually according to the methods and procedures set by the company in this service.\n2. After the registration is completed, the user must set a secure personal password according to the company's instructions, which is a 6-digit number, then wait for confirmation from the system to start using the service.Using M-Money Wallet Services\n 1. Top Up Wallet\n Users of M-Money Wallet can top-up their wallet at: (1) the LTC Service Center, (2) the participating Banks, (3) the Agent Stores that the Company has periodically listed (4) Direct Sale staff. Minimum top up is 10,000 Kip (ten thousand kip).",
        onClose: () async {
          if (Get.isDialogOpen!) {
            Get.back();
          }
          await CheckCredit();
          Get.to(() => InputAmountXJaideeScreen());
        },
      );
    } else {
      DialogHelper.showErrorDialogNew(description: 'ກະລຸນາປິດສິນເຊື່ອກ່ອນ!');
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

  //   ! Load list
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

  //  Update
  // !------------------------------------------------------------------------------
  Future<bool> Update(
      {required String creditId, required String status}) async {
    var url = "http://localhost:4100/api/ApproveCredit";
    var data = {
      "credit_id": creditId,
      "status": status,
      "msisdn": userController.rxMsisdn.value,
    };
    var response = await DioClient.post(url, data);
    if (response['status'] == true) {
      return true;
    } else {
      return false;
    }
  }
}
